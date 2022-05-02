//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

enum PasswordGeneratorAction {
    case passwordGenerated(PasswordGeneratedAction)
    case copyPassword
    case updatePasswordLength(Double)
}
