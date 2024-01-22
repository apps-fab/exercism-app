//
//  AlertModel.swift
//  Exercism
//
//  Created by Cédric Bahirwe on 22/01/2024.
//

import Foundation

struct AlertItem: Identifiable {
    let id = UUID()
    let title: String
    private(set) var message: String
    var isPresented: Bool
    
    init(title: String = Strings.alert.localized(), message: String = "", isPresented: Bool = false) {
        self.title = title
        self.message = message
        self.isPresented = isPresented
    }
    
    mutating func showMessage(_ message: String) {
        self.message = message
        isPresented = true
    }
    
    mutating func showError(_ error: Error) {
        self.message = error.localizedDescription
        isPresented = true
    }
}
