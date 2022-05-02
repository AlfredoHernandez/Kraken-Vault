//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation
import UIKit

func passwordGeneratorReducer(state: inout PasswordGeneratorState, action: PasswordGeneratorAction) -> [Effect<PasswordGeneratorAction>] {
    switch action {
    case let .updatePasswordLength(length):
        state.passwordGenerated.characterCount = length
        return []
    case let .passwordGenerated(action):
        let effects = passwordGeneratedReducer(state: &state.passwordGenerated, action: action)
        return effects.map { effect in
            if let action = effect() {
                return { PasswordGeneratorAction.passwordGenerated(action) }
            }
            return { nil }
        }
    case .copyPassword:
        return [
            copyPasswordInPasteboardEffect(passwordGenerated: state.passwordGenerated.characters),
            generateHapticEffect(),
        ]
    }
}

private func copyPasswordInPasteboardEffect(passwordGenerated: [String]) -> Effect<PasswordGeneratorAction> {
    {
        UIPasteboard.general.string = passwordGenerated.joined()
        return nil
    }
}

private func generateHapticEffect() -> Effect<PasswordGeneratorAction> {
    {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        return nil
    }
}
