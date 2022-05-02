//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

struct PasswordGeneratedState {
    var characters = [String]()
    var characterCount: Double = 12
    let passwordLenghtRange = 6.0 ... 32.0
    let alphabet = PasswordComponents.alphabet
    let specialCharactersArray = PasswordComponents.specialCharactersArray
    let numbersArray = PasswordComponents.numbersArray

    var includeSpecialChars = true
    var includeUppercased = true
    var includeNumbers = true
}
