//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

// import Foundation
import KrakenVaultCore

struct AppState: Equatable {
    var passwordVaultState = KrakenVaultState()
    var passwordGeneratorState = PasswordGeneratorState()
    var createPasswordState = CreatePasswordState(
        displayingForm: false,
        showPassword: true,
        siteName: "The Kraken Vault",
        username: "AlfredoHernandez",
        password: "ASecretPassw0rd",
        siteURL: "https://any-url.com"
    )
}
