//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

internal func generatePassword(with length: Int) -> [String] {
    var password: [String] = [""]
    var uppercasedAlphabet: [String] = []

    for character in PasswordComponents.alphabet {
        uppercasedAlphabet.append(character.uppercased())
    }

    for _ in 0 ... length / 4 {
        password.append(uppercasedAlphabet.randomElement()!)
    }

    for _ in 0 ... length / 4 {
        password.append(PasswordComponents.specialCharactersArray.randomElement()!)
    }

    for _ in 0 ... length / 4 {
        password.append(PasswordComponents.alphabet.randomElement()!)
    }

    for _ in 0 ... length / 4 {
        password.append(PasswordComponents.numbersArray.randomElement()!)
    }

    password.shuffle()

    if password.joined().count != length {
        while password.joined().count > length {
            password.remove(at: 0)
        }
    }
    return password
}
