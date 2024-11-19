//
//  NavigationManager.swift
//  IntelligenceKit-Sample
//
//  Created by Michel-Andre Chirita on 23/10/2024.
//

import Foundation
import SwiftUI

@MainActor @Observable
final class NavigationManager {

    // MARK: Properties

    var colorItem: ColorItem = .blue

    // MARK: Methods

    func openColor(_ colorItem: ColorItem) {
        self.colorItem = colorItem
    }
}

