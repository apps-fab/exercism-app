//
//  ExerciseEditorWindowView.swift
//  Exercism
//
//  Created by Kirk Agbenyegah on 28/09/2022.
//

import SwiftUI
import ExercismSwift

struct ExerciseEditorWindowView: View {
    @StateObject var viewModel = ExerciseViewModel()
    @State private var showInspector = true
    @State private var showSubmissionTooltip = false
    let exercise: String
    let track: String
    var body: some View {
        NavigationView {
            ExerciseNavigatorView()
            GeometryReader { window in
                HStack {
                    ExerciseEditorView()
                        .frame(minWidth: showInspector ? window.size.width - 300.0 : window.size.width)
                    if showInspector {
                        ExerciseRightSidebarView()
                            .frame(minWidth: 300.0, minHeight: window.size.height)
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .slide))
                    }
                }
            }
        }
        .environmentObject(viewModel)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: toggleSidebar, label: { // 1
                    Image.sidebarLeading
                })
            }
            ToolbarItem(content: { Spacer() })
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    viewModel.runTest()
                    
                }, label: { // 1
                    HStack {
                        Image.playCircle
                        Text(Strings.runTests.localized())
                    }
                })
            }
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    viewModel.submitSolution()
                }, label: { // 1
                    HStack {
                        Image.paperplaneCircle
                        Text(Strings.submit.localized())
                    }
                })
                .disabled(!viewModel.canSubmitSolution)
                .onTapGesture {
                    if !viewModel.canSubmitSolution {
                        showSubmissionTooltip = true
                        print("showSubmissionTooltip: \($0)")
                    }
                }
                .if(showSubmissionTooltip) { view in
                    view
                        .help(Strings.runTestsBefore.localized())
                }
                //                        .help("You need to run the tests before submitting.")
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    withAnimation {
                        showInspector.toggle()
                    }
                }, label: { // 1
                    Label {
                        Text(Strings.toggleInstructions.localized())
                    } icon: {
                        Image.sidebarTrailing
                    }
                })
            }
        }
        .navigationViewStyle(.columns)
        .onAppear {
            viewModel.getDocument(track: track, exercise: exercise)
        }
        .navigationTitle(Text(viewModel.getTitle()))
    }
    
    private func toggleSidebar() { // 2
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
}

struct ExerciseEditorWindowView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseEditorWindowView(exercise: "Rust", track: "Hello-world")
    }
}
