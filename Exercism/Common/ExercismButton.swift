//
//  ExercismButton.swift
//  Exercism
//
//  Created by Angie Mugo on 05/09/2023.
//

import SwiftUI

struct ExercismButton: View {
    let title: String
    let backgroundColor = Color.appAccent
    @Binding var isLoading: Bool
    let action: () -> Void

    var body: some View {
        ZStack(alignment: .center) {
            ProgressView()
                .colorInvert()
                .brightness(1)
                .frame(width: 40, height: 40)
                .opacity(isLoading ? 1 : 0)

            Button {
                action()
            } label: {
                Text(title)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(.white)
                    .opacity(isLoading ? 0 : 1)
                    .contentShape(Rectangle())
            }
        }.onChange(of: isLoading) { isLoading in
            if isLoading {
                announce("Loading in progress")
            }
        }.frame(height: 55)
            .background(backgroundColor)
            .cornerRadius(7)
            .buttonStyle(.plain)
    }
}

#Preview {
    ExercismButton(title: "Exercism Button", isLoading: .constant(false)) {
        print("Button pressed")

    }
}

func announce(_ message: String) {
    if #available(macOS 14.0, *) {
        var announcement = AttributedString(message)
        announcement.accessibilitySpeechAnnouncementPriority = .high
        AccessibilityNotification.Announcement(announcement).post()
    } else {
        NSAccessibility.post(element: message, notification: .announcementRequested)
    }
}
