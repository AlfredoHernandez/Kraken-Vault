//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

func passwordGeneratedReducer(state _: inout PasswordGeneratedState, action _: PasswordGeneratedAction) {}

enum PasswordGeneratedAction {}

struct PasswordGeneratedState {
    var characters = [String]()
    var characterCount: Int { characters.count }
    let passwordLenghtRange = 1 ... 32
    let alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    let specialCharactersArray = ["(", ")", "{", "}", "[", "]", "/", "+", "*", "$", ">", ".", "|", "^", "?", "&"]
    let numbersArray = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

    init(characters: [String] = []) {
        self.characters = characters
    }
}
