//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

enum AppAction {
    case passwordGenerated(PasswordGeneratedAction)
}

extension AppAction {
    public var passwordGenerated: PasswordGeneratedAction? {
        get {
            guard case let .passwordGenerated(value) = self else { return nil }
            return value
        }
        set {
            guard case .passwordGenerated = self, let newValue = newValue else { return }
            self = .passwordGenerated(newValue)
        }
    }
}
