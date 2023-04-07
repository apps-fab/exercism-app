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
    @State private var textInput: String = ""
    @State private var showAlert = false
    @State private var error: String?
    @EnvironmentObject private var model: TrackModel
    @EnvironmentObject private var coordinator: AppCoordinator

    var body: some View {
        GeometryReader { geometry in
            HStack() {
                leftView
                    .frame(width: geometry.size.width * 0.66,
                           height: geometry.size.height)
                    .background(Color("purple"))
                rightView
                    .frame(width: geometry.size.width * 0.33,
                           height: geometry.size.height)
                    .background(.white)
                    .foregroundColor(Color("darkBackground"))
            }.background(.white)
                .alert("Error logging in", isPresented: $showAlert, actions: {
                    // actions
                }, message: {
                    Text(error ?? "")
                })
        }
    }
    
    var leftView: some View {
        VStack() {
            Spacer()
            Image("mainLogo")
                .resizable()
                .accessibilityHidden(true)
                .aspectRatio(contentMode: .fit)
                .frame(width: 365, height: 208)
            Spacer()
            Text("Exercism is free for all people, everywhere.")
                .font(.system(size: 26, weight: .semibold))
                .multilineTextAlignment(.center)
            Text("Level up your programming skills with 3,444 exercises across 52 languages, and insightful discussion with our dedicated team of welcoming mentors.")
                .font(.system(size: 16, weight: .regular))
                .multilineTextAlignment(.center)
                .padding()
            Text("Exercism is 100% free forever.")
                .font(.system(size: 16, weight: .semibold))
            Spacer()
            Image("trackImages")
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
                Image("exercismLogo")
                Text("exercism")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 5)
            }.accessibilityAddTraits(.isHeader)
            Text("Code practice and mentorship for everyone")
                .font(.title2)
                .bold()
            Spacer()
            ExercismTextField(text: $textInput,
                              placeholder: Text("Enter your token")).onSubmit {
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
                Text("Log In")
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .foregroundColor(.white)
                
            }
            .frame(height: 40)
            .background(Color("purple"))
            .cornerRadius(7).buttonStyle(.plain)
            .padding()
            Text("You can find your token on your [settings page](https://exercism.org/settings)")
                .padding()
            
            Text("Important: The token above should be treated like a password and not be shared with anyone!")
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
                coordinator.goToTracksList()
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
