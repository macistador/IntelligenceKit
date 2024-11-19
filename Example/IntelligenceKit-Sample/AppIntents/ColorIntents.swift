//
//  ColorIntents.swift
//  IntelligenceKit-Sample
//
//  Created by Michel-Andre Chirita on 23/10/2024.
//

import Foundation
import AppIntents
import Foundation
import SwiftUI

enum IntentError: Error {
    case noEntity
}

@AssistantIntent(schema: .whiteboard.openBoard)
struct OpenColorIntent: OpenIntent {
    var target: ColorEntity

    @Dependency
    var navigation: NavigationManager

    @MainActor
    func perform() async throws -> some IntentResult {
        let color = target.color

        navigation.openColor(color)
        return .result()
    }
}
