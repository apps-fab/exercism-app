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

    @StateObject private var viewModel = ExerciseViewModel.shared

    @State private var shareOption = SolutionShareOption.share
    @State private var shareIterationsOptions = SolutionShareOption.Iteration.all
    @State private var selectedIteration: Int = 1
    @State private var numberOfIterations = 4
    @State private var isSubmitting = false

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
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)

            Group {
                Image("publishMan")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 200, maxHeight: 200)
                    .drawingGroup()
                    .padding(30)
            }
        }
        .padding(25)
        .frame(width: 800, height: 450)
        .onAppear {
            selectedIteration = viewModel.getDefaultIterationIdx()
        }
    }

    private var listItems: some View {
        VStack(alignment: .leading) {
            Picker("Select Solution Sharing Option", selection: $shareOption) {
                ForEach(SolutionShareOption.allCases, id: \.self) { option in
                    Text(option.rawValue).bold()
                        .tag(option)
                        .id(option)
                }
            }
            .labelsHidden()
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
                                Button("Iteration \(iteration.idx)") {
                                    selectedIteration = iteration.idx
                                }
                            }
                        } label: {
                            Text("Iteration \(selectedIteration)").roundEdges()
                        }
                        .frame(width: 100)
                        .opacity(shareIterationsOptions == .all ? 0 : 1)
                    }
                }
                .padding(.vertical, 10)
                .padding(.leading)
            }
        }
    }

    private var callToActions: some View {
        HStack(spacing: 20) {

            Button {
                dismiss()
            } label: {
                Text("Close")
                    .frame(width: 100, height: 30)
                    .roundEdges(
                        backgroundColor: Color.gray.opacity(0.25),
                        lineColor: Color.appAccent,
                        cornerRadius: 10)
            }
            .buttonStyle(.plain)

            Button {
                Task {
                    await completeExercise()
                }
            } label: {
                Label {
                    Text("Confirm")
                } icon: {
                    if isSubmitting {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(.white)
                            .foregroundStyle(.red)
                            .controlSize(.small)
                            .padding(.trailing, 1)

                    }
                }
                .foregroundStyle(.white)
                .frame(width: 100, height: 30)
                .roundEdges(backgroundColor: Color.appAccent, lineColor: .clear, cornerRadius: 10)
            }
            .buttonStyle(.plain)
            .disabled(isSubmitting)

        }
        .fontWeight(.semibold)
        .padding(.vertical)
    }

    private func completeExercise() async {
        guard let solution = viewModel.solutionToSubmit else { return }
        let shouldPublish = shareOption == .share
        let iterationIdx: Int? = shouldPublish && shareIterationsOptions == .single ? selectedIteration : nil
        isSubmitting = true
        do {
            let completeSolution =  try await viewModel.completeExercise(solutionId: solution.uuid,
                                                                         publish: shouldPublish,
                                                                         iterationIdx: iterationIdx)
            isSubmitting = false
            navigationModel.goToTrack(completeSolution.track)

        } catch {
            isSubmitting = false
        }
    }
}

#Preview {
    SubmitSolutionContentView()
}
