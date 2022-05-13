//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct KrakenVaultMainView: View {
    var body: some View {
        TabView {
            VaultView()
                .tabItem {
                    Image(systemName: "lock.square")
                    Text("Vault")
                }

            PasswordGeneratorView(
                store: Store(
                    initialValue: AppState(),
                    reducer: appReducer,
                    environment: AppEnvironment(
                        copyToPasteboard: { passwordGenerated in
                            UIPasteboard.general.string = passwordGenerated.joined()
                        },
                        generateFeedbackImpact: {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        },
                        generatePassword: generatePassword
                    )
                ).view(value: { $0.passwordGenerator }, action: { AppAction.passwordGenerated($0) })
            ).tabItem {
                Image(systemName: "person.badge.key.fill")
                Text("Generator")
            }
        }.accentColor(.teal)
    }
}

struct KrakenVaultMainView_Previews: PreviewProvider {
    static var previews: some View {
        KrakenVaultMainView()
    }
}
