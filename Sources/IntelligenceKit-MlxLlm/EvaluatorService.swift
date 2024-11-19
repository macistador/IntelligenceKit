//
//  File.swift
//  IntelligenceKit
//
//  Created by Michel-Andre Chirita on 19/10/2024.
//

import Foundation
import MLX
import MLXRandom

@MainActor
public class EvaluatorService: ObservableObject {

    @Published public var running = false
    @Published public var output = ""
    @Published public var modelInfo = ""
    @Published public var stat = ""

    /// This controls which model loads. `phi3_5_4bit` is one of the smaller ones, so this will fit on
    /// more devices.
    let modelConfiguration = ModelConfiguration.llama3_2_1B_4bit

    /// parameters controlling the output
    let generateParameters = GenerateParameters(temperature: 0.6)
    let maxTokens = 240

    /// update the display every N tokens -- 4 looks like it updates continuously
    /// and is low overhead.  observed ~15% reduction in tokens/s when updating
    /// on every token
    let displayEveryNTokens = 4

    public enum LoadState {
        case idle
        case loaded(ModelContainer)
    }

    @Published public var loadState = LoadState.idle

    public init() {
    }

    /// load and return the model -- can be called multiple times, subsequent calls will
    /// just return the loaded model
    public func load() async throws -> ModelContainer {
        switch loadState {
        case .idle:
            // limit the buffer cache
            MLX.GPU.set(cacheLimit: 20 * 1024 * 1024)

            let modelContainer = try await loadModelContainer(configuration: modelConfiguration)
            {
                [modelConfiguration] progress in
                Task { @MainActor in
                    self.modelInfo =
                    "Downloading \(modelConfiguration.name): \(Int(progress.fractionCompleted * 100))%"
                }
            }
            let numParams = await modelContainer.perform {
                [] model, _ in
                return model.numParameters()
            }

            self.modelInfo =
            "Loaded \(modelConfiguration.id).  Weights: \(numParams / (1024*1024))M"
            loadState = .loaded(modelContainer)
            return modelContainer

        case .loaded(let modelContainer):
            return modelContainer
        }
    }

    public func generate(prompt: String) async {
        guard !running else { return }

        running = true
        self.output = ""

        do {
            let modelContainer = try await load()

            // augment the prompt as needed
            let prompt = modelConfiguration.prepare(prompt: prompt)

            let promptTokens = await modelContainer.perform { _, tokenizer in
                tokenizer.encode(text: prompt)
            }

            // each time you generate you will get something new
            MLXRandom.seed(UInt64(Date.timeIntervalSinceReferenceDate * 1000))

            let result = await modelContainer.perform { model, tokenizer in
                IntelligenceKit_MlxLlm.generate(
                    promptTokens: promptTokens, parameters: generateParameters, model: model,
                    tokenizer: tokenizer, extraEOSTokens: modelConfiguration.extraEOSTokens
                ) { tokens in
                    // update the output -- this will make the view show the text as it generates
                    if tokens.count % displayEveryNTokens == 0 {
                        let text = tokenizer.decode(tokens: tokens)
                        Task { @MainActor in
                            self.output = text
                        }
                    }

                    if tokens.count >= maxTokens {
                        return .stop
                    } else {
                        return .more
                    }
                }
            }

            // update the text if needed, e.g. we haven't displayed because of displayEveryNTokens
            if result.output != self.output {
                self.output = result.output
            }
            self.stat = " Tokens/second: \(String(format: "%.3f", result.tokensPerSecond))"

        } catch {
            output = "Failed: \(error)"
        }

        running = false
    }
}

