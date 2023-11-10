//
//  LoginView.swift
//  Exercism
//
//  Created by Angie Mugo on 26/09/2022.
//

import SwiftUI
import KeychainSwift

struct LoginView: View {
    @EnvironmentObject private var navigationModel: NavigationModel
    @StateObject private var authenticationVM = AuthenticationViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                leftView
                    .frame(width: geometry.size.width * 0.62,
                           height: geometry.size.height)
                    .background(Color.exercismPurple)
                rightView
                    .frame(maxWidth: .infinity)
                    .frame(height: geometry.size.height)
            }
            .background(.white)
            .foregroundStyle(.black)
            .alert(
                Strings.loginError.localized(),
                isPresented: $authenticationVM.showAlert,
                actions: { },
                message: { Text(authenticationVM.error ?? "") }
            )
            .toolbar(.hidden)
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
        .foregroundStyle(.white)
        .padding(20)
    }
    
    var rightView: some View {
        VStack {
            Spacer()
            HStack {
                Image.exercismLogo.padding()
                Text(Strings.exercism.localized())
                    .font(.largeTitle.weight(.bold))
            }
            .accessibilityAddTraits(.isHeader)
            
            Text(Strings.codePractice.localized())
                .font(.title2.weight(.bold))
                .multilineTextAlignment(.center)
            
            Spacer()
            TextField("Enter your token",
                      text: $authenticationVM.tokenInput)
            .lineLimit(1)
            .placeholder(when: authenticationVM.tokenInput.isEmpty,
                         placeholderText: Strings.enterToken.localized())
            .padding()
            
            .frame(height: 55)
            .border(.gray)
            .textFieldStyle(.plain)
            .onSubmit {
                validateToken()
            }
            
            Spacer()
         
            
            VStack(spacing: 20) {
                
                ExercismButton(title: Strings.login.localized(),
                               isLoading: $authenticationVM.isLoading) {
                    validateToken()
                }
                Text("You can find your token on your [settings page](https://exercism.org/settings/api_cli)")
                    .lineLimit(1)
                    .minimumScaleFactor(0.3)
                
                Text(Strings.importantToken.localized())
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
            }
            Spacer()
        }
        .padding()
    }
    
    private func validateToken() {
        _Concurrency.Task {
            let isValid = await authenticationVM.validateToken()
            if isValid {
                ExercismKeychain.shared.set(authenticationVM.tokenInput, for: Keys.token.rawValue)
                navigationModel.goToDashboard()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .previewLayout(.fixed(width: 900, height: 800))
    }
}
