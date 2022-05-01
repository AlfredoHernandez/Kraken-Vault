//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation
import UIKit

func passwordGeneratorReducer(state: inout PasswordGeneratorState, action: PasswordGeneratorAction) {
    switch action {
    case let .updatePasswordLength(length):
        state.passwordGenerated.characterCount = length
    case let .passwordGenerated(action):
        passwordGeneratedReducer(state: &state.passwordGenerated, action: action)
    case .copyPassword:
        UIPasteboard.general.string = state.passwordGenerated.characters.joined()
    }
}
