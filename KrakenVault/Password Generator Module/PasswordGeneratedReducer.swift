//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation
import UIKit

func passwordGeneratorReducer(state: inout PasswordGeneratorState, action: PasswordGeneratorAction) -> [Effect<PasswordGeneratorAction>] {
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
    case let .updatePasswordLength(length):
        state.characterCount = length
        return []
    case .copyPassword:
        return [
            copyPasswordInPasteboardEffect(passwordGenerated: state.characters),
            generateHapticEffect(),
        ]
    }
}

private func copyPasswordInPasteboardEffect(passwordGenerated: [String]) -> Effect<PasswordGeneratorAction> {
    Effect { _ in UIPasteboard.general.string = passwordGenerated.joined() }
}

private func generateHapticEffect() -> Effect<PasswordGeneratorAction> {
    Effect { _ in UIImpactFeedbackGenerator(style: .light).impactOccurred() }
}

private func generatePasswordEffect() -> Effect<PasswordGeneratorAction> {
    Effect { callback in callback(.generate) }
}
