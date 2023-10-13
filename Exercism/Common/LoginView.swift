//
//  LoginView.swift
//  Exercism
//
//  Created by Angie Mugo on 26/09/2022.
//

import SwiftUI
import ExercismSwift
import KeychainSwift

struct LoginView: View {
    @EnvironmentObject private var navigationModel: NavigationModel
    @State private var textInput: String = ""
    @State private var showAlert = false
    @State private var error: String?
    @State private var isLoading = false
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                leftView
                    .frame(width: geometry.size.width * 0.66,
                           height: geometry.size.height)
                    .background(Color.exercismPurple)
                rightView
                    .frame(width: geometry.size.width * 0.33,
                           height: geometry.size.height)
                    .background(.white)
                    .foregroundColor(.darkBackground)
            }.alert(Strings.loginError.localized(), isPresented: $showAlert, actions: {
                // actions
            }, message: {
                Text(error ?? "")
            }).toolbar(.hidden)
        }
    }
    
    var leftView: some View {
        VStack() {
            Spacer()
            Image.mainLogo
                .resizable()
                .accessibilityHidden(true)
                .aspectRatio(contentMode: .fit)
                .frame(width: 365, height: 208)
            Spacer()
            Text(Strings.introTitle.localized())
                .font(.system(size: 26, weight: .semibold))
                .multilineTextAlignment(.center)
            Text(Strings.introSubtitle.localized())
                .font(.system(size: 16, weight: .regular))
                .multilineTextAlignment(.center)
                .padding()
            Text(Strings.introFree.localized())
                .font(.system(size: 16, weight: .semibold))
            Spacer()
            Image.trackImages
                .resizable()
                .accessibilityHidden(true)
                .aspectRatio(contentMode: .fit)
                .frame(width: 450, height: 66)
            Spacer()
        }
    }
    
    var rightView: some View {
        VStack(alignment: .center) {
            Spacer()
            HStack {
                Image.exercismLogo.padding()
                Text(Strings.exercism.localized())
                    .font(.largeTitle)
                    .bold()
            }.accessibilityAddTraits(.isHeader)
            Text(Strings.codePractice.localized())
                .font(.title2)
                .bold()
            Spacer()
            TextField("",
                      text: $textInput)
            .placeholder(when: textInput.isEmpty, placeholderText: Strings.enterToken.localized())
            .padding()
            .frame(height: 55)
            .border(.gray)
            .textFieldStyle(.plain)
            .onSubmit {
                validateToken()
            }

            Spacer()
            ExercismButton(title: Strings.login.localized(),
                           isLoading: $isLoading) {
                validateToken()
            }
            Text("You can find your token on your [settings page](https://exercism.org/settings/api_cli)")
            Text(Strings.importantToken.localized())
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            Spacer()
        }.padding()
    }
    
    func validateToken() {
        isLoading = true
        if textInput.isEmpty {
            error = "API token cannot be empty"
            showAlert = true
        }
        let client = ExercismClient(apiToken: textInput)
        client.validateToken(completed: { response in
            isLoading = false
            switch response {
            case .success(_):
                ExercismKeychain.shared.set(textInput, for: Keys.token.rawValue)
                navigationModel.goToDashboard()
            case .failure(let error):
                if case ExercismClientError.apiError(_, _, let message) = error {
                    self.error = message
                }
                showAlert = true
            }
        })
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


extension NSTextView {
    open override var frame: CGRect {
        didSet {
            insertionPointColor = .gray
        }
    }
}
