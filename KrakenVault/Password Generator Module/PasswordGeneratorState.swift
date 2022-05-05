//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

struct PasswordGeneratorState: Equatable {
    let passwordLengthRange = 6.0 ... 32.0
    let alphabet = PasswordComponents.alphabet
    let specialCharactersArray = PasswordComponents.specialCharactersArray
    let numbersArray = PasswordComponents.numbersArray

    var characters = [String]()
    var characterCount: Double = 12
    var includeSpecialChars = true
    var includeUppercased = true
    var includeNumbers = true
}
