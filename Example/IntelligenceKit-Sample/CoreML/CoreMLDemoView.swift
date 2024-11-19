//
//  OpenELMView.swift
//  IntelligenceKit-Sample
//
//  Created by Michel-Andre Chirita on 19/10/2024.
//

import SwiftUI
import Tokenizers
import Generation
import Models
import CoreML

enum ModelState: Equatable {
    case noModel
    case loading
    case ready(Double?)
    case generating(Double)
    case failed(String)
}

struct CoreMLDemoView: View {

    @State private var inputText: String = ""
    @State private var status: ModelState = .noModel
    @State private var config = GenerationConfig(maxNewTokens: 20)
    @State private var prompt = "Write a poem about Valencia\n"
    @State private var modelURL: URL? = nil
    @State private var languageModel: LanguageModel? = nil
    @State private var outputText: AttributedString = ""

    func start() {
        guard status != .loading else { return }

        status = .loading
        Task {
            do {
                ///
                /// First download a model from https://huggingface.co/coreml-projects
                /// and add it to this project
                /// uncomment the following lines:
                ///

//                let modelURL = [YOUR MODEL].urlOfModelInThisBundle
//                languageModel = try LanguageModel.loadCompiled(url: modelURL, computeUnits: .cpuAndGPU)
//                if let config = languageModel?.defaultGenerationConfig {
//                    let maxNewTokens = self.config.maxNewTokens
//                    self.config = config
//                    Task {
//                        // Refresh after slider limits have been updated
//                        self.config.maxNewTokens = min(maxNewTokens, languageModel?.maxContextLength ?? 20)
//                    }
//                }
//                status = .ready(nil)
            } catch {
                print("No model could be loaded: \(error)")
                status = .noModel
            }
        }
    }

    func run() {
        guard let languageModel = languageModel else { return }

        @Sendable func showOutput(currentGeneration: String, progress: Double, completedTokensPerSecond: Double? = nil) {
            Task { @MainActor in
                // Temporary hack to remove start token returned by llama tokenizers
                var response = currentGeneration.deletingPrefix("<s> ")

                // Strip prompt
                guard response.count > prompt.count else { return }
                response = response[prompt.endIndex...].replacingOccurrences(of: "\\n", with: "\n")

                // Format prompt + response with different colors
                var styledPrompt = AttributedString(prompt)
                styledPrompt.foregroundColor = .black

                var styledOutput = AttributedString(response)
                styledOutput.foregroundColor = .accentColor

                outputText = styledPrompt + styledOutput
                if let tps = completedTokensPerSecond {
                    status = .ready(tps)
                } else {
                    status = .generating(progress)
                }
            }
        }

        Task {
            status = .generating(0)
            var tokensReceived = 0
            let begin = Date()
            do {
                let output = try await languageModel.generate(config: config, prompt: prompt) { inProgressGeneration in
                    tokensReceived += 1
                    showOutput(currentGeneration: inProgressGeneration, progress: Double(tokensReceived)/Double(config.maxNewTokens))
                }
                let completionTime = Date().timeIntervalSince(begin)
                let tokensPerSecond = Double(tokensReceived) / completionTime
                showOutput(currentGeneration: output, progress: 1, completedTokensPerSecond: tokensPerSecond)
                print("Took \(completionTime)")
            } catch {
                print("Error \(error)")
                Task { @MainActor in
                    status = .failed("\(error)")
                }
            }
        }
    }

    var body: some View {
        VStack {
            Spacer()

            switch status {
            case .noModel: Text("No model")
            case .loading: Text("Loading...")
            case .ready(let double): Text("Ready (\(double))")
            case .generating(let double): Text("Generating... (\(double))")
            case .failed(let string): Text("Failed \(string)")
            }

            TextField(text: $inputText, prompt: Text("Enter your prompt here")) {
                Text("Prompt")
            }
            .textFieldStyle(.roundedBorder)
            .onSubmit {
                run()
            }

            Text("Output")
            Text(outputText)
                .padding()
                .background(Color.gray.opacity(0.1), in: .rect(cornerRadius: 20))
        }
        .padding()
        .onAppear(perform: start)
    }
}

#Preview {
    CoreMLDemoView()
}


//import CoreML

//func predict(m1: MLMultiArray) async -> Int? {
//    let model = try! OpenELM_270M_Instruct_128_float32()
//    do {
//        let prediction = try model.prediction(input_ids: m1)
//
//        prediction.logits
//
////        var topIndexAndValue: (index: Int, value: Float)?
////
////        // Iterate through the MLMultiArray and store the values and their indices
////        for i in 0..<prediction.count {
////            if let value = prediction[i] as? Float {
////                // Update the top value if this value is greater
////                if topIndexAndValue == nil || value > topIndexAndValue!.value {
////                    topIndexAndValue = (index: i, value: value)
////                }
////            }
////        }
////
////        // Return the top index
////        return topIndexAndValue?.index
//
//    } catch {
//        print(error)
//        return nil
//    }
//}


extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else { return self }
        return String(dropFirst(prefix.count))
    }
}
