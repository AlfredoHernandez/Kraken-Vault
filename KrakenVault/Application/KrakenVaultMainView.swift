//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct KrakenVaultMainView: View {
    let store: Store<AppState, AppAction>

    var body: some View {
        TabView {
            KrakenVaultView(
                presentSheet: Binding(
                    get: { store.value.createPassword.displayingForm },
                    set: { store.send(.createPassword(.displayingForm($0))) }
                ),
                store: store.view(value: { $0.vault }, action: { AppAction.vault($0) }),
                createPasswordView: {
                    CreatePasswordView(
                        store: store
                            .view(
                                value: { $0.createPassword },
                                action: { AppAction.createPassword($0) }
                            )
                    )
                }
            )
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
        }
    }
}

struct KrakenVaultMainView_Previews: PreviewProvider {
    static var previews: some View {
        KrakenVaultMainView(store: store)
    }
}
