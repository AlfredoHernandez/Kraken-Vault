//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct KrakenVaultMainView: View {
    let store: Store<AppState, AppAction>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            TabView {
                KrakenVaultView(
                    store: store.scope(state: { $0.passwordVaultState }, action: { AppAction.vault($0) }),
                    presentSheet: Binding(
                        get: { viewStore.createPasswordState.displayingForm },
                        set: { viewStore.send(.createPassword(.displayingForm($0))) }
                    ),
                    createPasswordView: {
                        CreatePasswordView(
                            store: store
                                .scope(
                                    state: { $0.createPasswordState },
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
                    store: store.scope(state: { $0.passwordGeneratorState }, action: { AppAction.passwordGenerated($0) })
                ).tabItem {
                    Image(systemName: "person.badge.key.fill")
                    Text("Generator")
                }
            }
        }
    }
}

struct KrakenVaultMainView_Previews: PreviewProvider {
    static var previews: some View {
        KrakenVaultMainView(store: store)
    }
}
