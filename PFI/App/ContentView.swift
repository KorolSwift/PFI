//
//  ContentView.swift
//  PFI
//
//  Created by Ди Di on 01/08/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "applelogo")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("PFI")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
