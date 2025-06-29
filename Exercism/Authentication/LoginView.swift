//
//  LoginView.swift
//  Exercism
//
//  Created by Angie Mugo on 26/09/2022.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var navigationModel: NavigationModel
    @StateObject private var authenticationVM = AuthenticationViewModel()

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                leftView
                    .frame(width: geometry.size.width * 0.62,
                           height: geometry.size.height)
                    .background(Color.appAccent)
                rightView
                    .frame(maxWidth: .infinity)
                    .frame(height: geometry.size.height)
            }
            .background(.white)
            .foregroundStyle(.black)
            .onChange(of: authenticationVM.authSuccess) {
                if authenticationVM.authSuccess {
                    ExercismKeychain.shared.set(authenticationVM.tokenInput, for: Keys.token.rawValue)
                    navigationModel.goToDashboard()
                }
            }
            .alert(
                Strings.loginError.localized(),
                isPresented: $authenticationVM.showAlert,
                actions: { },
                message: { Text(authenticationVM.error ?? "") }
            ).toolbar(.hidden)
        }
    }

    var leftView: some View {
        VStack {
            Spacer()
            Image.mainLogo
                .resizable()
                .accessibilityHidden(true)
                .aspectRatio(contentMode: .fit)
                .frame(idealWidth: 365)
                .frame(maxHeight: 208)
            Spacer()
            Text(Strings.introTitle.localized())
                .font(.largeTitle.weight(.semibold))
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.8)

            Text(Strings.introSubtitle.localized())
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding()

            Text(Strings.introFree.localized())
                .font(.title3.weight(.semibold))

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
                Image.exercodeLogo.resizable().frame(width: 150, height: 50)
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
                Text("You can find your token on your Settings Page"
                    .getLink(Color.appAccent,
                             linkText: "Settings Page",
                             linkURL: "https://exercism.org/settings/api_cli"))
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
        Task {
            await authenticationVM.validateToken()
        }
    }
}

#Preview {
    LoginView()
}
