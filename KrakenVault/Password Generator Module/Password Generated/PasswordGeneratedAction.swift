//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

enum PasswordGeneratedAction {
    case generate
    case includeSpecialChars(Bool)
    case includeUppercased(Bool)
    case includeNumbers(Bool)
}
