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
    
    var body: some View {
        GeometryReader { geometry in
            HStack() {
                leftView
                    .frame(width: geometry.size.width * 0.66,
                           height: geometry.size.height)
                    .background(Color.exercismPurple)
                rightView
                    .frame(width: geometry.size.width * 0.33,
                           height: geometry.size.height)
                    .background(.white)
                    .foregroundColor(.darkBackground)
            }.background(.white)
                .alert(Strings.loginError.localized(), isPresented: $showAlert, actions: {
                    // actions
                }, message: {
                    Text(error ?? "")
                })
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
                    .padding(.bottom, 5)
            }.accessibilityAddTraits(.isHeader)
            Text(Strings.codePractice.localized())
                .font(.title2)
                .bold()
            Spacer()
            ExercismTextField(text: $textInput,
                              placeholder: Text(Strings.enterToken.localized())).onSubmit {
                validateToken()
            }
                              .frame(height: 28)
                              .border(.gray)
                              .padding(.leading, 26)
                              .padding(.trailing, 26)
            Spacer()
            Button(action: {
                validateToken()
            }) {
                Text(Strings.login.localized())
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .foregroundColor(.white)
                
            }
            .frame(height: 40)
            .background(Color.exercismPurple)
            .cornerRadius(7).buttonStyle(.plain)
            .padding()
            Text("You can find your token on your [settings page](https://exercism.org/settings/api_cli)")
                .padding()
            Text(Strings.importantToken.localized())
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            Spacer()
            
        }
    }
    
    func validateToken() {
        // show the error message in the alert
        let client = ExercismClient(apiToken: textInput)
        client.validateToken(completed: { response in
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
