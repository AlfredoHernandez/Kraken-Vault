//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

enum PasswordGeneratorAction {
    case generate
    case includeSpecialChars(Bool)
    case includeUppercased(Bool)
    case includeNumbers(Bool)
    case copyPassword
    case updatePasswordLength(Double)
}
