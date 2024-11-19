//
//  SiriKitDemoView.swift
//  IntelligenceKit-Sample
//
//  Created by Michel-Andre Chirita on 21/10/2024.
//

import SwiftUI
import Intents

struct SiriKitDemoView: View {

    enum ViewState {
        case fetchingStatus
        case notRequested
        case authorized
        case denied
    }

    @State private var state: ViewState = .fetchingStatus

    var body: some View {
        VStack {
            Spacer()

            switch state {
            case .fetchingStatus:
                ProgressView()

            case .notRequested:
                Button {
                    askForSiriPermission()
                } label: {
                    Text("Allow Siri")
                }
                .buttonStyle(.borderedProminent)

            case .authorized:
                Text("Say now \"Hey Siri, show blue color \"")
            case .denied:
                Text("Siri permission denied, please allow it in the device settings.")
            }

            Spacer()
        }
        .onAppear {
            updateState(with: INPreferences.siriAuthorizationStatus())
        }
    }

    private func askForSiriPermission() {
        INPreferences.requestSiriAuthorization(updateState(with:))
    }

    private func updateState(with status: INSiriAuthorizationStatus) {
        switch status {
        case .notDetermined: state = .notRequested
        case .restricted, .denied: state = .denied
        case .authorized: state = .authorized
        @unknown default: state = .notRequested
        }
    }
}

#Preview {
    SiriKitDemoView()
}
