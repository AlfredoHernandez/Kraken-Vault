//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation
import UIKit

func passwordGeneratorReducer(state: inout PasswordGeneratorState, action: PasswordGeneratorAction) -> Effect {
    switch action {
    case let .updatePasswordLength(length):
        state.passwordGenerated.characterCount = length
        return {}
    case let .passwordGenerated(action):
        return passwordGeneratedReducer(state: &state.passwordGenerated, action: action)
    case .copyPassword:
        let state = state
        return {
            UIPasteboard.general.string = state.passwordGenerated.characters.joined()
        }
    }
}
