//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation
import UIKit

func passwordGeneratedReducer(state: inout PasswordGeneratedState, action: PasswordGeneratedAction) -> [Effect<PasswordGeneratedAction>] {
    switch action {
    case .generate:
        state.characters = generatePassword(
            lenght: Int(state.characterCount),
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
    {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        return nil
    }
}

private func generatePasswordEffect() -> Effect<PasswordGeneratedAction> {
    { .generate }
}
