//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation
import KrakenVaultCore

struct AppState {
    var characters = [String]()
    var characterCount: Double = 12
    var includeSpecialChars = true
    var includeUppercased = true
    var includeNumbers = true
    var vaultItems: [VaultItem] = []
}

extension AppState {
    var passwordGenerator: PasswordGeneratorState {
        get {
            PasswordGeneratorState(
                characters: characters,
                characterCount: characterCount,
                includeSpecialChars: includeSpecialChars,
                includeUppercased: includeUppercased,
                includeNumbers: includeNumbers
            )
        }
        set {
            characters = newValue.characters
            characterCount = newValue.characterCount
            includeSpecialChars = newValue.includeSpecialChars
            includeUppercased = newValue.includeUppercased
            includeNumbers = newValue.includeNumbers
        }
    }

    var vault: PasswordVaultState {
        get {
            PasswordVaultState(vaultItems: vaultItems)
        }
        set {
            vaultItems = newValue.vaultItems
        }
    }
}
