//
//  SubmitSolutionContentView.swift
//  Exercism
//
//  Created by Cédric Bahirwe on 22/12/2023.
//

import SwiftUI
import ExercismSwift

enum SolutionShareOption: String, CaseIterable {
    case complete = "No, I just want to mark the exercise as complete."
    case share = "Yes I'd like to share my solution with the community"

    enum Iteration: String, CaseIterable {
        case all = "All iterations"
        case single = "Single iteration"
    }
}

struct SubmitSolutionContentView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var navigationModel: NavigationModel
    @EnvironmentObject private var viewModel: ExerciseViewModel
    @State private var shareOption = SolutionShareOption.share
    @State private var shareIterationsOptions = SolutionShareOption.Iteration.all
    @State private var isSubmitting = false
    @State private var selectedIteration: Int = 1

    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading) {
                Image.terminal
                    .resizable()
                    .padding(5)
                    .scaledToFit()
                    .frame(width: 50, height: 40, alignment: .leading)

                VStack(alignment: .leading, spacing: 10) {
                    Text(Strings.publishCodeTitle.localized())
                        .multilineTextAlignment(.leading)
                        .font(.largeTitle.bold())
                        .minimumScaleFactor(0.8)

                    Text(Strings.publishCodeSubtitle.localized())
                        .multilineTextAlignment(.leading)
                        .padding(.vertical, 5)
                }

                listItems

                callToActions
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)

            Group {
                Image.publishMan
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 200, maxHeight: 200)
                    .drawingGroup()
                    .padding(30)
            }
        }.padding(25)
            .frame(width: 800, height: 450)
    }

    @ViewBuilder
    private var listItems: some View {
        VStack(alignment: .leading) {
            Picker(Strings.sharingOption.localized(), selection: $shareOption) {
                ForEach(SolutionShareOption.allCases, id: \.self) { option in
                    Text(option.rawValue).bold()
                        .tag(option)
                        .id(option)
                }
            }.labelsHidden()
#if os(macOS)
                .pickerStyle(.radioGroup)
#else
                .pickerStyle(.automatic)
#endif

            if shareOption == .share {
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Picker("", selection: $shareIterationsOptions) {
                            ForEach(SolutionShareOption.Iteration.allCases, id: \.self) { iteration in
                                Text(iteration.rawValue)
                            }
                        }
#if os(macOS)
                        .pickerStyle(.radioGroup)
                        .horizontalRadioGroupLayout()
#else
                        .pickerStyle(.automatic)
#endif

                        Menu {
                            ForEach(viewModel.sortedIterations, id: \.idx) { iteration in
                                Button(String(format: Strings.iteration.localized(), iteration.idx)) {
                                    selectedIteration = iteration.idx
                                }
                            }
                        } label: {
                            Text(String(format: Strings.iteration.localized(), selectedIteration))
                                .roundEdges()
                        }
                        .frame(width: 100)
                        .opacity(shareIterationsOptions == .all ? 0 : 1)
                    }
                }.padding(.vertical, 10)
                    .padding(.leading)
            }
        }
    }

    @ViewBuilder
    private var callToActions: some View {
        HStack(spacing: 20) {
            Button {
                dismiss()
            } label: {
                Text(Strings.close.localized())
                    .frame(width: 100, height: 30)
                    .roundEdges(
                        backgroundColor: Color.gray.opacity(0.25),
                        lineColor: Color.appAccent,
                        cornerRadius: 10)
            }.buttonStyle(.plain)

            Button {
                Task {
                    await completeExercise()
                }
            } label: {
                Label {
                    Text(Strings.confirm.localized())
                } icon: {
                    if isSubmitting {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(.white)
                            .foregroundStyle(.red)
                            .controlSize(.small)
                            .padding(.trailing, 1)

                    }
                }.foregroundStyle(.white)
                    .frame(width: 100, height: 30)
                    .roundEdges(backgroundColor: Color.appAccent, lineColor: .clear, cornerRadius: 10)
            }.buttonStyle(.plain)
                .disabled(isSubmitting)

        }.fontWeight(.semibold)
            .padding(.vertical)
    }

    private func completeExercise() async {
        isSubmitting = true
        let shouldPublish = shareOption == .share
        let iterationIdx: Int? = shouldPublish && shareIterationsOptions == .single ? selectedIteration : nil
        let result = await viewModel.completeExercise(shouldPublish, iterationIdx)

        if result {
            isSubmitting = false
            navigationModel.pop(number: 2)
        }
    }
}

#Preview {
    SubmitSolutionContentView()
        .environmentObject(ExerciseViewModel("Swift", "Hello-world"))
}
