//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Combine
import Foundation
import KrakenVaultCore
import PowerfulCombine
import UIKit

enum AppAction {
    case passwordGenerated(PasswordGeneratorAction)
    case vault(PasswordVaultAction)
}

extension AppAction {
    public var passwordGenerated: PasswordGeneratorAction? {
        get {
            guard case let .passwordGenerated(value) = self else { return nil }
            return value
        }
        set {
            guard case .passwordGenerated = self, let newValue = newValue else { return }
            self = .passwordGenerated(newValue)
        }
    }

    public var vault: PasswordVaultAction? {
        get {
            guard case let .vault(value) = self else { return nil }
            return value
        }
        set {
            guard case .vault = self, let newValue = newValue else { return }
            self = .vault(newValue)
        }
    }
}

typealias AppEnvironment = (
    copyToPasteboard: ([String]) -> Void,
    generateFeedbackImpact: () -> Void,
    generatePassword: (_ length: Int, _ specialCharacters: Bool, _ uppercase: Bool, _ numbers: Bool) -> [String],
    vaultItemsStore: LocalVaultLoader,
    dispatchQueueScheduler: AnyDispatchQueueScheduler
)
