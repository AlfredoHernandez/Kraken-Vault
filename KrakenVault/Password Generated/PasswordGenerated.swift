//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

private func generatePassword(with length: Int) -> [String] {
    let alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    let specialCharactersArray = ["(", ")", "{", "}", "[", "]", "/", "+", "*", "$", ">", ".", "|", "^", "?", "&"]
    let numbersArray = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    var password: [String] = [""]
    var uppercasedAlphabet: [String] = []

    for character in alphabet {
        uppercasedAlphabet.append(character.uppercased())
    }

    for _ in 0 ... length / 4 {
        password.append(uppercasedAlphabet.randomElement()!)
    }

    for _ in 0 ... length / 4 {
        password.append(specialCharactersArray.randomElement()!)
    }

    for _ in 0 ... length / 4 {
        password.append(alphabet.randomElement()!)
    }

    for _ in 0 ... length / 4 {
        password.append(numbersArray.randomElement()!)
    }

    password.shuffle()

    if password.joined().count != length {
        while password.joined().count > length {
            password.remove(at: 0)
        }
    }
    return password
}

func passwordGeneratedReducer(state: inout PasswordGeneratedState, action: PasswordGeneratedAction) {
    switch action {
    case .generate:
        state.characters = generatePassword(with: Int(state.characterCount))
    }
}

enum PasswordGeneratedAction {
    case generate
}

struct PasswordGeneratedState {
    var characters = ["1", "3", "%", "a", "B", "/", "#", "k", "0", "[", ">", "m", "0", "p", "{", "$"]
    var characterCount: Double = 16.0
    let passwordLenghtRange = 1.0 ... 32.0
    let alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    let specialCharactersArray = ["(", ")", "{", "}", "[", "]", "/", "+", "*", "$", ">", ".", "|", "^", "?", "&"]
    let numbersArray = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
}
