//
//  IntentEnum.swift
//  IntelligenceKit-Sample
//
//  Created by Michel-Andre Chirita on 23/10/2024.
//

import Foundation
import AppIntents

@AssistantEnum(schema: .whiteboard.color)
enum ColorType: String, AppEnum {
    case red
    case blue
    case green
    case yellow

    static let caseDisplayRepresentations: [ColorType: DisplayRepresentation] = [
        .red: "Red",
        .blue: "Blue",
        .green: "Green",
        .yellow: "Yellow"
    ]
}
