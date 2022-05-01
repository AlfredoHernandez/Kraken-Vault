//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

func passwordGeneratedReducer(state: inout PasswordGeneratedState, action: PasswordGeneratedAction) {
    switch action {
    case .generate:
        state.characters = generatePassword(with: Int(state.characterCount))
    }
}
