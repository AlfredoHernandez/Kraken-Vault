//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation
import UIKit

func passwordGeneratedReducer(state: inout PasswordGeneratedState, action: PasswordGeneratedAction) -> [Effect<PasswordGeneratedAction>] {
    switch action {
    case .generate:
        state.characters = generatePassword(
            length: Int(state.characterCount),
            specialCharacters: state.includeSpecialChars,
            uppercase: state.includeUppercased,
            numbers: state.includeNumbers
        )
        return [generateHapticEffect()]
    case let .includeNumbers(withNumbers):
        state.includeNumbers = withNumbers
        return [generatePasswordEffect()]
    case let .includeSpecialChars(withSpecialChars):
        state.includeSpecialChars = withSpecialChars
        return [generatePasswordEffect()]
    case let .includeUppercased(withUppercased):
        state.includeUppercased = withUppercased
        return [generatePasswordEffect()]
    }
}

private func generateHapticEffect() -> Effect<PasswordGeneratedAction> {
    Effect { _ in UIImpactFeedbackGenerator(style: .light).impactOccurred() }
}

private func generatePasswordEffect() -> Effect<PasswordGeneratedAction> {
    Effect { callback in callback(.generate) }
}
