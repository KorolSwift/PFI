//
//  PFITests.swift
//  PFITests
//
//  Created by Ди Di on 01/08/26.
//

import Foundation
import Testing
@testable import PFI

struct PFITests {
    @Test func bundleIdentifierIsFromOurNamespace() {
        #expect(Bundle.main.bundleIdentifier?.hasPrefix("io.pfi") == true)
    }
}
