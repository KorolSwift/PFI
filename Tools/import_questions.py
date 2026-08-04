#!/usr/bin/env python3
"""
Идемпотентный импорт вопросов и задач PFI из Markdown в seed_content.json.

Запускать сколько угодно раз: повторный импорт того же файла ничего не сломает
и не создаст дублей. Существующий контент и порядок сохраняются.

Использование:
    python3 Tools/import_questions.py --dry-run     # показать, что произойдёт
    python3 Tools/import_questions.py               # применить

Подробности формата: Tools/README.md
"""

from __future__ import annotations

import argparse
import json
import re
import sys
import unicodedata
import uuid
from dataclasses import dataclass, field
from pathlib import Path

# Фиксированный namespace: id вопроса детерминированно выводится из его текста.
# Менять нельзя — иначе весь существующий контент получит новые id и задублируется.
NAMESPACE = uuid.UUID("6f9b1e42-3c7a-5d18-9e04-2b7c8a1f6d33")

SCHEMA_VERSION = 1
LEVELS = {"junior", "middle", "senior"}
DIFFICULTIES = {"easy", "medium", "hard"}

ROOT = Path(__file__).resolve().parent.parent
DEFAULT_INPUT = ROOT / "Content" / "incoming"
DEFAULT_OUTPUT = ROOT / "Content" / "seed_content.json"


# --------------------------------------------------------------------------- #
# Модель
# --------------------------------------------------------------------------- #

@dataclass
class Entry:
    """Один вопрос или одна задача, разобранные из Markdown."""
    kind: str                 # "question" | "task"
    text: str
    body: str
    level: str
    topic: str
    subtopic: str
    tags: list[str] = field(default_factory=list)
    source_file: str = ""
    source_line: int = 0

    @property
    def uid(self) -> str:
        return str(uuid.uuid5(NAMESPACE, normalize(self.text)))


def normalize(text: str) -> str:
    """Ключ для дедупликации: регистр, пунктуация и пробелы не должны влиять."""
    text = unicodedata.normalize("NFKD", text).lower()
    text = re.sub(r"[^\w\s]", "", text, flags=re.UNICODE)
    return re.sub(r"\s+", " ", text).strip()


def slugify(text: str) -> str:
    text = unicodedata.normalize("NFKD", text).lower().strip()
    text = re.sub(r"[^\w\s-]", "", text, flags=re.UNICODE)
    return re.sub(r"[\s_]+", "-", text)


# --------------------------------------------------------------------------- #
# Разбор Markdown
# --------------------------------------------------------------------------- #

HEADER_RE = re.compile(r"^(topic|subtopic|level|type|tags)\s*:\s*(.+)$", re.IGNORECASE)
ENTRY_RE = re.compile(r"^##\s+(?:\[(\w+)\]\s*)?(.+?)\s*$")


def parse_file(path: Path, problems: list[str]) -> list[Entry]:
    lines = path.read_text(encoding="utf-8").splitlines()

    meta = {"topic": "", "subtopic": "", "level": "middle", "type": "question", "tags": ""}
    entries: list[Entry] = []

    current: Entry | None = None
    buffer: list[str] = []
    in_header = True
    fence_open = False
    in_comment = False

    def flush() -> None:
        nonlocal current, buffer
        if current is not None:
            current.body = "\n".join(buffer).strip()
            entries.append(current)
        current, buffer = None, []

    for lineno, line in enumerate(lines, start=1):
        stripped = line.strip()

        # Шапка файла — до первого вопроса, пустые строки и комментарии пропускаем.
        if in_header and not stripped.startswith("##"):
            if in_comment:
                if "-->" in stripped:
                    in_comment = False
                continue
            if stripped.startswith("<!--"):
                if "-->" not in stripped:
                    in_comment = True
                continue
            if not stripped:
                continue
            m = HEADER_RE.match(stripped)
            if m:
                meta[m.group(1).lower()] = m.group(2).strip()
                continue
            problems.append(f"{path.name}:{lineno}: непонятная строка в шапке — {stripped!r}")
            continue

        # Внутри ``` заголовки не считаются заголовками.
        if stripped.startswith("```"):
            fence_open = not fence_open

        if not fence_open:
            m = ENTRY_RE.match(line)
            if m:
                in_header = False
                flush()
                level = (m.group(1) or meta["level"]).lower()
                if level not in LEVELS and meta["type"] == "question":
                    problems.append(
                        f"{path.name}:{lineno}: неизвестный уровень {level!r}, "
                        f"допустимы {sorted(LEVELS)}"
                    )
                    level = "middle"
                current = Entry(
                    kind=meta["type"].lower(),
                    text=m.group(2).strip(),
                    body="",
                    level=level,
                    topic=meta["topic"].strip(),
                    subtopic=meta["subtopic"].strip(),
                    tags=[t.strip() for t in meta["tags"].split(",") if t.strip()],
                    source_file=path.name,
                    source_line=lineno,
                )
                continue

        if current is not None:
            buffer.append(line)

    flush()

    if fence_open:
        problems.append(f"{path.name}: непарный ``` — блок кода не закрыт до конца файла")
    if not meta["topic"]:
        problems.append(f"{path.name}: не указана тема (строка `topic:` в начале файла)")

    return entries


# --------------------------------------------------------------------------- #
# Слияние
# --------------------------------------------------------------------------- #

def load_seed(path: Path) -> dict:
    if not path.exists():
        return {"schemaVersion": SCHEMA_VERSION, "topics": [], "questions": [], "tasks": []}
    data = json.loads(path.read_text(encoding="utf-8"))
    for key in ("topics", "questions", "tasks"):
        data.setdefault(key, [])
    data.setdefault("schemaVersion", SCHEMA_VERSION)
    return data


def merge(seed: dict, entries: list[Entry], problems: list[str]) -> dict:
    stats = {"added": 0, "updated": 0, "unchanged": 0, "dup_in_input": 0}

    by_id_q = {q["id"]: q for q in seed["questions"]}
    by_id_t = {t["id"]: t for t in seed["tasks"]}
    next_order = max(
        [q.get("order", 0) for q in seed["questions"]]
        + [t.get("order", 0) for t in seed["tasks"]]
        + [0]
    ) + 1

    seen_in_input: dict[str, Entry] = {}
    topics: dict[str, dict] = {t["slug"]: t for t in seed["topics"]}

    for entry in entries:
        if not entry.body:
            problems.append(
                f"{entry.source_file}:{entry.source_line}: пустой ответ у «{entry.text[:50]}»"
            )
            continue

        if entry.uid in seen_in_input:
            first = seen_in_input[entry.uid]
            problems.append(
                f"{entry.source_file}:{entry.source_line}: дубль «{entry.text[:50]}» "
                f"(уже был в {first.source_file}:{first.source_line}) — пропущен"
            )
            stats["dup_in_input"] += 1
            continue
        seen_in_input[entry.uid] = entry

        register_topic(topics, entry)

        bucket = by_id_q if entry.kind == "question" else by_id_t
        existing = bucket.get(entry.uid)

        if existing is None:
            bucket[entry.uid] = build_record(entry, next_order)
            next_order += 1
            stats["added"] += 1
        elif differs(existing, entry):
            update_record(existing, entry)
            stats["updated"] += 1
        else:
            stats["unchanged"] += 1

    seed["topics"] = sorted(topics.values(), key=lambda t: t["order"])
    seed["questions"] = sorted(by_id_q.values(), key=lambda q: q["order"])
    seed["tasks"] = sorted(by_id_t.values(), key=lambda t: t["order"])
    seed["schemaVersion"] = SCHEMA_VERSION
    return stats


def register_topic(topics: dict[str, dict], entry: Entry) -> None:
    t_slug = slugify(entry.topic)
    topic = topics.get(t_slug)
    if topic is None:
        topic = {
            "id": str(uuid.uuid5(NAMESPACE, "topic:" + t_slug)),
            "title": entry.topic,
            "slug": t_slug,
            "order": len(topics) + 1,
            "iconName": "questionmark.circle",
            "subtopics": [],
        }
        topics[t_slug] = topic

    if not entry.subtopic:
        return
    s_slug = slugify(entry.subtopic)
    if any(s["slug"] == s_slug for s in topic["subtopics"]):
        return
    topic["subtopics"].append({
        "id": str(uuid.uuid5(NAMESPACE, f"subtopic:{t_slug}/{s_slug}")),
        "title": entry.subtopic,
        "slug": s_slug,
        "order": len(topic["subtopics"]) + 1,
    })


def build_record(entry: Entry, order: int) -> dict:
    base = {
        "id": entry.uid,
        "order": order,
        "topicSlug": slugify(entry.topic),
        "subtopicSlug": slugify(entry.subtopic) if entry.subtopic else "",
        "tags": entry.tags,
    }
    if entry.kind == "question":
        base |= {"text": entry.text, "answerMarkdown": entry.body, "level": entry.level}
    else:
        base |= {
            "title": entry.text,
            "statementMarkdown": entry.body,
            "difficulty": entry.level if entry.level in DIFFICULTIES else "medium",
            "hints": [],
            "referenceSolution": "",
        }
    return base


def body_key(record: dict) -> str:
    return "answerMarkdown" if "answerMarkdown" in record else "statementMarkdown"


def differs(record: dict, entry: Entry) -> bool:
    return (
        record.get(body_key(record), "") != entry.body
        or record.get("tags", []) != entry.tags
        or record.get("topicSlug", "") != slugify(entry.topic)
    )


def update_record(record: dict, entry: Entry) -> None:
    """Обновляем содержимое, но НЕ трогаем id и order — на них завязан прогресс."""
    record[body_key(record)] = entry.body
    record["tags"] = entry.tags
    record["topicSlug"] = slugify(entry.topic)
    record["subtopicSlug"] = slugify(entry.subtopic) if entry.subtopic else ""
    if "level" in record:
        record["level"] = entry.level


# --------------------------------------------------------------------------- #

def main() -> int:
    parser = argparse.ArgumentParser(description="Импорт вопросов PFI из Markdown в JSON")
    parser.add_argument("--input", type=Path, default=DEFAULT_INPUT)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    parser.add_argument("--dry-run", action="store_true", help="ничего не записывать")
    args = parser.parse_args()

    if not args.input.exists():
        print(f"Папка с входными файлами не найдена: {args.input}", file=sys.stderr)
        return 1

    files = sorted(args.input.glob("*.md"))
    if not files:
        print(f"В {args.input} нет ни одного .md — нечего импортировать.")
        return 0

    problems: list[str] = []
    entries: list[Entry] = []
    for path in files:
        entries.extend(parse_file(path, problems))

    seed = load_seed(args.output)
    before = len(seed["questions"]) + len(seed["tasks"])
    stats = merge(seed, entries, problems)
    after = len(seed["questions"]) + len(seed["tasks"])

    print(f"Файлов прочитано:  {len(files)}")
    print(f"Записей разобрано: {len(entries)}")
    print()
    print(f"  добавлено новых:      {stats['added']}")
    print(f"  обновлено:            {stats['updated']}")
    print(f"  без изменений:        {stats['unchanged']}")
    print(f"  дублей во входе:      {stats['dup_in_input']}")
    print()
    print(f"Всего в базе: {before} → {after}")
    print(f"  вопросов: {len(seed['questions'])}, задач: {len(seed['tasks'])}, "
          f"тем: {len(seed['topics'])}")

    if problems:
        print(f"\n⚠️  Замечания ({len(problems)}):")
        for p in problems[:40]:
            print(f"  · {p}")
        if len(problems) > 40:
            print(f"  … и ещё {len(problems) - 40}")

    if args.dry_run:
        print("\n--dry-run: файл не изменён.")
        return 0

    args.output.parent.mkdir(parents=True, exist_ok=True)
    tmp = args.output.with_suffix(".json.tmp")
    tmp.write_text(
        json.dumps(seed, ensure_ascii=False, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    tmp.replace(args.output)          # атомарная замена: файл не бьётся при сбое
    print(f"\n✅ Записано: {args.output}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
