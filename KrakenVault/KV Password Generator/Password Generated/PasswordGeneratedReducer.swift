//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation
import UIKit

func passwordGeneratedReducer(state: inout PasswordGeneratedState, action: PasswordGeneratedAction) -> [Effect<PasswordGeneratedAction>] {
    switch action {
    case .generate:
        state.characters = generatePassword(with: Int(state.characterCount))
        return [generateHapticEffect()]
    }
}

private func generateHapticEffect() -> Effect<PasswordGeneratedAction> {
    {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        return nil
    }
}
