//
//  IntelligenceKit_SampleApp.swift
//  IntelligenceKit-Sample
//
//  Created by Michel-Andre Chirita on 14/10/2024.
//

import SwiftUI
import AppIntents

@main
struct IntelligenceKit_SampleApp: App {

    let navigationManager: NavigationManager

    init() {
        let navigationManager = NavigationManager()
        AppDependencyManager.shared.add(dependency: navigationManager)
        self.navigationManager = navigationManager
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(navigationManager)
        }
    }
}
