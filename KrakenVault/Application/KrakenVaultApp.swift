//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import SwiftUI

@main
struct KrakenVaultApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                Text("Vault")
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Vault")
                    }

                PasswordGeneratorView(
                    store: Store(
                        initialValue: AppState(), reducer: logging(appReducer)
                    ).view(value: { $0.passwordGenerator }, action: { AppAction.passwordGenerator($0) })
                ).tabItem {
                    Image(systemName: "person.badge.key.fill")
                    Text("Generator")
                }
            }
        }
    }
}
