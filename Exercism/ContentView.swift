//
//  ContentView.swift
//  Exercism
//
//  Created by Kirk Agbenyegah on 04/07/2022.
//

import SwiftUI
import ExercismSwift

struct ContentView: View {
    @State private var textInput: String = ""
    @State private var showAlert = false

    var body: some View {
        GeometryReader { geometry in
            HStack() {
                VStack() {
                    Spacer()
                    Image("mainLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 365, height: 208)
                    Spacer()
                    Text("Exercism is free for all people, everywhere")
                        .font(.system(size: 26, weight: .semibold))
                        .multilineTextAlignment(.center)
                    Text("Level up your programming skills with 3444 exercises across 52 languages, and insightful discussion with our dedicated team of welcoming mentors")
                        .multilineTextAlignment(.center)
                        .padding()
                    Text("Exercism is 100% free forever")
                        .bold()
                    Spacer()
                    Image("trackImages")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 450, height: 66)
                    Spacer()
                }.frame(width: geometry.size.width * 0.66,
                        height: geometry.size.height)
                .background(Color("purple"))
                VStack(alignment: .center) {
                    Spacer()
                    HStack {
                        Image("exercismLogo")
                        Text("exercism")
                            .font(.title)
                            .bold()
                            .padding(.bottom, 5)
                    }
                    Text("Code practice and mentorship for everyone")
                        .font(.title2)
                        .bold()
                    Spacer()
                    ExercismTextField(placeholder: Text("Enter your token"),
                                      text: $textInput)
                    .frame(height: 28)
                    .textFieldStyle(.squareBorder)
                    .border(.gray)
                    .padding(.leading, 26)
                    .padding(.trailing, 26)
                    Spacer()
                    Button(action: {
                        validateToken()
                    }) {
                        Text("Log in")
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                            .foregroundColor(.white)

                    }
                    .frame(height: 40)
                    .background(Color("purple"))
                    .cornerRadius(7).buttonStyle(.plain)
                    .padding()
                    Text("You can find your token on your [settings page](https://example.com)")
                        .padding()

                    Text("Important: The token above should be treated like a password and not shared with anyone")
                        .bold()
                    Spacer()

                }.frame(width: geometry.size.width * 0.33,
                        height: geometry.size.height)
                .background(.white)
                .foregroundColor(.black)
            }.background(.white)
                .alert("Important message", isPresented: $showAlert) {
                    Button("OK", role: .cancel) { }
                }
        }
    }

    func validateToken() {
        // show the error message in the alert
        let client = ExercismClient(apiToken: textInput)
        client.validateToken(completed: { response in
            switch response {
            case .success(let success):
                print("This was a success")
            case .failure(let failure):
                showAlert = true
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
