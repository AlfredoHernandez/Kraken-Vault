//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct KrakenVaultMainView: View {
    let store: Store<AppState, AppAction>

    var body: some View {
        TabView {
            VaultView(store: store.view(value: { $0.vault }, action: { AppAction.vault($0) }))
                .tabItem {
                    Image(systemName: "lock.square")
                    Text("Vault")
                }

            PasswordGeneratorView(
                store: store.view(value: { $0.passwordGenerator }, action: { AppAction.passwordGenerated($0) })
            ).tabItem {
                Image(systemName: "person.badge.key.fill")
                Text("Generator")
            }
        }.accentColor(.teal)
    }
}

struct KrakenVaultMainView_Previews: PreviewProvider {
    static var previews: some View {
        KrakenVaultMainView(store: store)
    }
}
