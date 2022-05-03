//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

struct AppState {
    var characters = [String]()
    var characterCount: Double = 12
    var includeSpecialChars = true
    var includeUppercased = true
    var includeNumbers = true
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
}
