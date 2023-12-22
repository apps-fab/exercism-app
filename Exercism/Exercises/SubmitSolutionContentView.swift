//
//  SubmitSolutionContentView.swift
//  Exercism
//
//  Created by Cédric Bahirwe on 22/12/2023.
//

import SwiftUI

enum SolutionShareOption: String, CaseIterable {
    case complete = "No, I just want to mark the exercise as complete."
    case share = "Yes I'd like to share my solution with the community"
    
    enum Iteration: String, CaseIterable {
        case all = "All iterations"
        case single = "Single iteration"
    }
}

struct SubmitSolutionContentView: View {
    @State private var shareOption = SolutionShareOption.share
    @State private var shareIterationsOptions = SolutionShareOption.Iteration.single
    @State private var selectedIteration = 1
    @State private var numberOfIterations = 4
    @Binding var isPresented: Bool
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading) {
                Image(systemName: "terminal")
                    .frame(width: 50, height: 50)
                
                Text("Publish your code and share\nyour knowledge")
                    .multilineTextAlignment(.leading)
                    .font(.largeTitle.bold())
                    .minimumScaleFactor(0.8)
                
                Text("By publishing your code, you'll help others learn from your work.\nYou can choose which iterations you publish, add more iterations once it's published, and unpublish it at any time.")
                    .multilineTextAlignment(.leading)
                
                listItems
                
                HStack(spacing: 20) {
                    Button {
                        print("confirm thing")
                    } label: {
                        Text("Confirm")
                            .frame(width: 100, height: 30)
                            .roundEdges(backgroundColor: Color.exercismPurple, lineColor: .clear, cornerRadius: 10)
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        isPresented = false
                    } label: {
                        Text("Close")
                            .frame(width: 100, height: 30)
                            .roundEdges(
                                backgroundColor: Color.gray.opacity(0.25),
                                lineColor: .exercismPurple,
                                cornerRadius: 10)
                    }
                    .buttonStyle(.plain)
                    
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Group {
                Image("publishMan")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 200, maxHeight: 200)
                    .padding(30)
                    .background(.green)
            }
        }
        .padding()
        .frame(width: 800, height: 400)
    }
    
    private var listItems: some View {
        VStack {
            Picker("", selection: $shareOption) {
                ForEach(SolutionShareOption.allCases, id: \.self) { option in
                    Text(option.rawValue).bold()
                }
            }.pickerStyle(.radioGroup)
            
            if shareOption == .share {
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Picker("", selection: $shareIterationsOptions) {
                            ForEach(SolutionShareOption.Iteration.allCases, id: \.self) { iteration in
                                Text(iteration.rawValue)
                            }
                        }.pickerStyle(.radioGroup)
                            .horizontalRadioGroupLayout()
                        Menu {
                            ForEach(1...numberOfIterations, id: \.self) { index in
                                Text("Iteration \(index)")
                            }
                        } label: {
                            Text("Iteration \(selectedIteration)").roundEdges()
                        }.opacity(shareIterationsOptions == .all ? 0 : 1)
                            .frame(width: 100)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                
            }
        }
    }
}

#Preview {
    SubmitSolutionContentView(isPresented: .constant(true))
}
