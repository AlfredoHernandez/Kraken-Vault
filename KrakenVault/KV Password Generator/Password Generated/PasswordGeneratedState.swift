//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

struct PasswordGeneratedState {
    var characters = [String]()
    var characterCount: Double = 16.0
    let passwordLenghtRange = 1.0 ... 32.0
    let alphabet = PasswordComponents.alphabet
    let specialCharactersArray = PasswordComponents.specialCharactersArray
    let numbersArray = PasswordComponents.numbersArray
}
