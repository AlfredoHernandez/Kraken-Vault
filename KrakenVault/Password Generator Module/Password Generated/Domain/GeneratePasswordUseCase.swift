//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

func generatePassword(lenght: Int, specialCharacters: Bool, uppercase: Bool, numbers: Bool) -> [String] {
    // All parameters
    if uppercase && specialCharacters && numbers {
        return threeParameterPassword(lenght: lenght)
    }

    // Two parameters
    if uppercase && specialCharacters || uppercase && numbers || numbers && specialCharacters {
        return twoParameterPassword(lenght: lenght, specialCharacters: specialCharacters, uppercase: uppercase, numbers: numbers)
    }

    // One parameter
    if uppercase || specialCharacters || numbers {
        return oneParameterPassword(lenght: lenght, specialCharacters: specialCharacters, uppercase: uppercase, numbers: numbers)
    } else {
        return lowercasePassword(lenght: lenght)
    }
}

func lowercasePassword(lenght: Int) -> [String] {
    var password: [String] = [""]

    for _ in 0 ... lenght {
        password.append(PasswordComponents.alphabet.randomElement()!)
    }

    if password.joined().count != lenght {
        while password.joined().count > lenght {
            password.remove(at: 0)
        }
    }
    return password
}

func oneParameterPassword(lenght: Int, specialCharacters: Bool, uppercase: Bool, numbers: Bool) -> [String] {
    var password: [String] = [""]
    var uppercasedAlphabet: [String] = []

    for character in PasswordComponents.alphabet {
        uppercasedAlphabet.append(character.uppercased())
    }

    if specialCharacters {
        for _ in 0 ... lenght / 2 {
            password.append(PasswordComponents.alphabet.randomElement()!)
        }

        for _ in 0 ... lenght / 2 {
            password.append(PasswordComponents.specialCharactersArray.randomElement()!)
        }
        password.shuffle()

        if password.joined().count != lenght {
            while password.joined().count > lenght {
                password.remove(at: 0)
            }
        }

        return password
    }

    if uppercase {
        for _ in 0 ... lenght / 2 {
            password.append(PasswordComponents.alphabet.randomElement()!)
        }

        for _ in 0 ... lenght / 2 {
            password.append(uppercasedAlphabet.randomElement()!)
        }
        password.shuffle()

        if password.joined().count != lenght {
            while password.joined().count > lenght {
                password.remove(at: 0)
            }
        }
        return password
    }

    if numbers {
        for _ in 0 ... lenght / 2 {
            password.append(PasswordComponents.alphabet.randomElement()!)
        }

        for _ in 0 ... lenght / 2 {
            password.append(PasswordComponents.numbersArray.randomElement()!)
        }
        password.shuffle()

        if password.joined().count != lenght {
            while password.joined().count > lenght {
                password.remove(at: 0)
            }
        }
        return password
    }
    return password
}

func twoParameterPassword(lenght: Int, specialCharacters: Bool, uppercase: Bool, numbers: Bool) -> [String] {
    var password: [String] = [""]
    var uppercasedAlphabet: [String] = []

    for character in PasswordComponents.alphabet {
        uppercasedAlphabet.append(character.uppercased())
    }

    if uppercase, specialCharacters {
        for _ in 0 ... lenght / 3 {
            password.append(uppercasedAlphabet.randomElement()!)
        }

        for _ in 0 ... lenght / 3 {
            password.append(PasswordComponents.specialCharactersArray.randomElement()!)
        }

        for _ in 0 ... lenght / 3 {
            password.append(PasswordComponents.alphabet.randomElement()!)
        }

        password.shuffle()

        if password.joined().count != lenght {
            while password.joined().count > lenght {
                password.remove(at: 0)
            }
        }
        return password
    }

    if uppercase, numbers {
        for _ in 0 ... lenght / 3 {
            password.append(uppercasedAlphabet.randomElement()!)
        }

        for _ in 0 ... lenght / 3 {
            password.append(PasswordComponents.numbersArray.randomElement()!)
        }

        for _ in 0 ... lenght / 3 {
            password.append(PasswordComponents.alphabet.randomElement()!)
        }

        password.shuffle()

        if password.joined().count != lenght {
            while password.joined().count > lenght {
                password.remove(at: 0)
            }
        }
        return password
    }

    if numbers, specialCharacters {
        for _ in 0 ... lenght / 3 {
            password.append(PasswordComponents.numbersArray.randomElement()!)
        }

        for _ in 0 ... lenght / 3 {
            password.append(PasswordComponents.specialCharactersArray.randomElement()!)
        }

        for _ in 0 ... lenght / 3 {
            password.append(PasswordComponents.alphabet.randomElement()!)
        }

        password.shuffle()

        if password.joined().count != lenght {
            while password.joined().count > lenght {
                password.remove(at: 0)
            }
        }
        return password
    }
    return password
}

func threeParameterPassword(lenght: Int) -> [String] {
    var password: [String] = [""]
    var uppercasedAlphabet: [String] = []

    for character in PasswordComponents.alphabet {
        uppercasedAlphabet.append(character.uppercased())
    }

    for _ in 0 ... lenght / 4 {
        password.append(uppercasedAlphabet.randomElement()!)
    }

    for _ in 0 ... lenght / 4 {
        password.append(PasswordComponents.specialCharactersArray.randomElement()!)
    }

    for _ in 0 ... lenght / 4 {
        password.append(PasswordComponents.alphabet.randomElement()!)
    }

    for _ in 0 ... lenght / 4 {
        password.append(PasswordComponents.numbersArray.randomElement()!)
    }

    password.shuffle()

    if password.joined().count != lenght {
        while password.joined().count > lenght {
            password.remove(at: 0)
        }
    }
    return password
}
