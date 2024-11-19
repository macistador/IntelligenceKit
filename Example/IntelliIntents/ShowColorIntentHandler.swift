//
//  ShowColorIntentHandler.swift
//  IntelliIntents
//
//  Created by Michel-Andre Chirita on 23/10/2024.
//

import Intents

final class ShowColorIntentHandler: NSObject, ShowColorIntentHandling {

    func resolveColor(for intent: ShowColorIntent) async -> ColorsResolutionResult {
        .success(with: intent.color)
    }
    
    func handle(intent: ShowColorIntent, completion: @escaping (ShowColorIntentResponse) -> Void) {
        let colorItem = intent.color
        let response = ShowColorIntentResponse(code: .success, userActivity: nil)
        completion(response)
    }
}
