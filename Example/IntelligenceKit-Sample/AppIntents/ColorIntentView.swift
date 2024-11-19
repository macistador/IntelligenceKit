//
//  ColorIntentView.swift
//  IntelligenceKit-Sample
//
//  Created by Michel-Andre Chirita on 23/10/2024.
//

import SwiftUI

struct ColorIntentView: View {

    var colorItem: ColorItem

    var body: some View {
        VStack {
            Spacer()
        }
        .background(colorItem.color)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ColorIntentView(colorItem: .blue)
}
