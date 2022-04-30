//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import SwiftUI

private let examplePassword = ["1", "3", "%", "a", "B", "/", "#", "k", "0", "[", ">", "m", "0", "p", "{"]

@main
struct KrakenVaultApp: App {
    var body: some Scene {
        WindowGroup {
            PasswordGeneratorView(
                store: Store(
                    initialValue: AppState(passwordGenerated: PasswordGeneratedState(characters: examplePassword)), reducer: appReducer
                )
            )
        }
    }
}
