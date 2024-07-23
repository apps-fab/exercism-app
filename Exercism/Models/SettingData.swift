//
// Created by Kirk Agbenyegah on 01/10/2022.
//

import Foundation
import CodeEditor

class SettingData: ObservableObject {
    @Published var theme = CodeEditor.ThemeName.pojoaque
    @Published var fontSize: Double = 12
}
