//
//  ContentView.swift
//  Exercism
//
//  Created by Kirk Agbenyegah on 04/07/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var textInput: String = ""

    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .top) {
                VStack(alignment: .center) {
                    Image(systemName: "star").padding()
                    Text("Exercism is free for all people, everywhere").font(.title).bold().padding()
                    Text("Level up your programming skills with 3444 exercises across 52 languages, and insightful discussion with our dedicated team of welcoming mentors").padding()
                    Text("Exercism is 100% free forever").bold().padding()
                }.frame(width: geometry.size.width * 0.66,
                        height: geometry.size.height)
                .background(Color("purple"))
                VStack(alignment: .center) {
                    Text("exercism")
                        .font(.title)
                        .bold()
                    Text("Code practice and mentorship for everyone")
                        .font(.title2)
                        .bold()
                    TextField(text: $textInput, prompt: Text("Required")) {
                        Text("Username")
                    }.border(.gray)
                        .foregroundColor(.gray)
                    Spacer()
                    Button(action: {
                        print("Log in tapped")
                    }) {
                        Text("Log in")
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                            .foregroundColor(.white)

                    }
                    .frame(height: 40)
                    .background(Color("purple"))
                    .cornerRadius(7).buttonStyle(.plain)
                    Spacer()

                    Text("You can find your token on your [settings page](https://example.com)")
                    Spacer()
                    Text("Important: The token above should be treated like a password and not shared with anyone")
                        .bold()
                    Spacer()
                }.padding()
                    .frame(width: geometry.size.width * 0.33,
                        height: geometry.size.height)
                    .background(.white)
                    .foregroundColor(.black)

            }.background(.white)
        }
    }
}

extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set {}
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
