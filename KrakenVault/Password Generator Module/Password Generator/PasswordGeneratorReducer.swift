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
            Effect { callback in
                effect.run { action in
                    callback(PasswordGeneratorAction.passwordGenerated(action))
                }
            }
        }
    case .copyPassword:
        return [
            copyPasswordInPasteboardEffect(passwordGenerated: state.passwordGenerated.characters),
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
