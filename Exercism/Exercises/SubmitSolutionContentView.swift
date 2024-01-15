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
    @SwiftUI.Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel = ExerciseViewModel.shared

    @State private var shareOption = SolutionShareOption.share
    @State private var shareIterationsOptions = SolutionShareOption.Iteration.all
    @State private var selectedIteration: Int = 1
    @State private var numberOfIterations = 4
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading) {
                Image(systemName: "terminal")
                    .resizable()
                    .padding(5)
                    .scaledToFit()
                    .frame(width: 50, height: 40, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Publish your code and share\nyour knowledge")
                        .multilineTextAlignment(.leading)
                        .font(.largeTitle.bold())
                        .minimumScaleFactor(0.8)
                    
                    Text("By publishing your code, you'll help others learn from your work.\nYou can choose which iterations you publish, add more iterations once it's published, and unpublish it at any time.")
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
            .pickerStyle(.radioGroup)
            
            if shareOption == .share {
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Picker("", selection: $shareIterationsOptions) {
                            ForEach(SolutionShareOption.Iteration.allCases, id: \.self) { iteration in
                                Text(iteration.rawValue)
                            }
                        }
                        .pickerStyle(.radioGroup)
                        .horizontalRadioGroupLayout()
                        
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
                        lineColor: .exercismPurple,
                        cornerRadius: 10)
            }
            .buttonStyle(.plain)
            
            Button {
                _Concurrency.Task {
                   await completeExercise()
                }
            } label: {
                Text("Confirm")
                    .foregroundStyle(.white)
                    .frame(width: 100, height: 30)
                    .roundEdges(backgroundColor: Color.exercismPurple, lineColor: .clear, cornerRadius: 10)
            }
            .buttonStyle(.plain)

        }
        .fontWeight(.semibold)
        .padding(.vertical)
    }
    
    private func completeExercise() async  {
        guard let solution = viewModel.solutionToSubmit else { return }
        let shouldPublish = shareOption == .share
        let iterationIdx: Int? = shouldPublish && shareIterationsOptions == .single ? selectedIteration : nil
        
        await viewModel.completeExercise(solutionId: solution.uuid,
                                         publish: shouldPublish,
                                         iterationIdx: iterationIdx)
    }
}

#Preview {
    SubmitSolutionContentView()
        .preferredColorScheme(.light)
}
