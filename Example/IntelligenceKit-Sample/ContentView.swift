//
//  ContentView.swift
//  IntelligenceKit-Sample
//
//  Created by Michel-Andre Chirita on 14/10/2024.
//

import SwiftUI

struct ContentView: View {

    @Environment(NavigationManager.self) private var navigation

    var body: some View {
        @Bindable var navigation = navigation
        TabView() {
            Tab("Features", systemImage: "photo.on.rectangle") {
                firstTabView
            }
            Tab("Albums", systemImage: "photo.stack") {
                ColorIntentView(colorItem: navigation.colorItem)
            }
        }
    }

    @ViewBuilder
    private var firstTabView: some View {
        NavigationStack() {
            List {
                Section("CoreML") {
                    NavigationLink {
                        CoreMLDemoView()
                    } label: {
                        Text("OpenELM with CoreML")
                    }
                }

                Section("MLX") {
                    NavigationLink {
                        MLXDemoView()
                    } label: {
                        Text("Llama 3.2 1B with MLX")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
