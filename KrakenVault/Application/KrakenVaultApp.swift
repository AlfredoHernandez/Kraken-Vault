//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import SwiftUI

@main
struct KrakenVaultApp: App {
    var body: some Scene {
        WindowGroup {
            PasswordGeneratorView(
                store: Store(
                    initialValue: AppState(), reducer: logging(appReducer)
                ).view(value: { $0.passwordGenerator }, action: { AppAction.passwordGenerator($0) })
            )
        }
    }
}
