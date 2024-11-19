//
//  IntentHandler.swift
//  IntelliIntents
//
//  Created by Michel-Andre Chirita on 23/10/2024.
//

import Intents

class IntentHandler: INExtension {
    override func handler(for intent: INIntent) -> Any {
        if intent is ShowColorIntent {
            return ShowColorIntentHandler()
        }
        return self
    }
}
