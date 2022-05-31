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
    case vault(KrakenVaultAction)
    case createPassword(CreatePasswordAction)
}

typealias AppEnvironment = (
    copyToPasteboard: ([String]) -> Void,
    generateFeedbackImpact: () -> Void,
    generatePassword: (_ length: Int, _ specialCharacters: Bool, _ uppercase: Bool, _ numbers: Bool) -> [String],
    vaultItemsStore: LocalVaultLoader,
    dispatchQueueScheduler: AnyDispatchQueueScheduler
)
