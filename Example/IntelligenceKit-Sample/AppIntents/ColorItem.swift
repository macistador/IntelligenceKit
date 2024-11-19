//
//  Color.swift
//  IntelligenceKit-Sample
//
//  Created by Michel-Andre Chirita on 23/10/2024.
//

import Foundation
import SwiftUI

enum ColorItem {
    case red
    case blue
    case green
    case yellow

    var color: Color {
        switch self {
        case .red: .red
        case .blue: .blue
        case .green: .green
        case .yellow: .yellow
        }
    }
}
