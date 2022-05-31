//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

// import Foundation
import KrakenVaultCore

struct AppState: Equatable {
    var passwordVaultState = PasswordVaultState()
    var passwordGeneratorState = PasswordGeneratorState()
    var createPasswordState = CreatePasswordState()
}
