//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

enum AppAction {
    case passwordGenerator(PasswordGeneratorAction)
}

extension AppAction {
    public var passwordGenerator: PasswordGeneratorAction? {
        get {
            guard case let .passwordGenerator(value) = self else { return nil }
            return value
        }
        set {
            guard case .passwordGenerator = self, let newValue = newValue else { return }
            self = .passwordGenerator(newValue)
        }
    }
}
