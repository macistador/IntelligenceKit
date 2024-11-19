//
//  MLXDemoView.swift
//  IntelligenceKit-Sample
//
//  Created by Michel-Andre Chirita on 19/10/2024.
//

import SwiftUI
import MarkdownUI
#if canImport(IntelligenceKit_MlxLlm)
import IntelligenceKit_MlxLlm
#endif

struct MLXDemoView: View {

    @State var prompt = ""
    @State var llm = EvaluatorService()
    @State private var selectedDisplayStyle = displayStyle.markdown

    enum displayStyle: String, CaseIterable, Identifiable {
        case plain, markdown
        var id: Self { self }
    }

    var body: some View {
        VStack {
            headerView
            modelOutputView
            promptView
        }
        .padding()
        .task {
            /// pre-load the weights on launch to speed up the first generation
            _ = try? await llm.load()
        }
    }

    @ViewBuilder
    private var headerView: some View {
        HStack {
            Text(llm.modelInfo)
                .textFieldStyle(.roundedBorder)

            Spacer()

            Text(llm.stat)
        }
        HStack {
            Spacer()
            if llm.running {
                ProgressView()
                    .frame(maxHeight: 20)
                Spacer()
            }
            Picker("", selection: $selectedDisplayStyle) {
                ForEach(displayStyle.allCases, id: \.self) { option in
                    Text(option.rawValue.capitalized)
                        .tag(option)
                }

            }
            .pickerStyle(.segmented)
            .frame(maxWidth: 150)
        }
    }

    @ViewBuilder
    private var modelOutputView: some View {
        ScrollView(.vertical) {
            ScrollViewReader { sp in
                Group {
                    if selectedDisplayStyle == .plain {
                        Text(llm.output)
                            .textSelection(.enabled)
                    } else {
                        Markdown(llm.output)
                            .textSelection(.enabled)
                    }
                }
                .onChange(of: llm.output) { _, _ in
                    sp.scrollTo("bottom")
                }

                Spacer()
                    .frame(width: 1, height: 1)
                    .id("bottom")
            }
        }
    }

    private var promptView: some View {
        HStack(alignment: .top) {
            TextField("Enter your prompt...", text: $prompt, axis: .vertical)
                .multilineTextAlignment(.leading)
                .lineLimit(2...4)
                .onSubmit(generate)
                .disabled(llm.running)
                .padding(10)
                .background(.gray.opacity(0.3), in: .rect(cornerRadius: 20))

            Button("generate", action: generate)
                .disabled(llm.running || prompt.isEmpty)
        }
    }

    private func generate() {
        guard !prompt.isEmpty else { return }
        Task {
            await llm.generate(prompt: prompt)
            prompt = ""
        }
    }
}

#Preview {
    MLXDemoView()
}
