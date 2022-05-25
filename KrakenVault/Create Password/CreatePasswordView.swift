//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import ComposableArchitecture
import KrakenVaultCore
import SwiftUI

struct CreatePasswordState: Equatable {
    var displayingForm = false
    var showPassword = false
    var siteName = "The Kraken Vault"
    var username = "AlfredoHernandez"
    var password = "ASecretPassw0rd"
    var siteURL = "https://any-url.com"
}

enum CreatePasswordAction {
    case create
    case setName(String)
    case setUsername(String)
    case setPassword(String)
    case setSiteURL(String)
    case toggleShowPassword
    case displayingForm(Bool)
}

func createPasswordReducer(state: inout CreatePasswordState, action: CreatePasswordAction, environment: LocalVaultLoader) -> [Effect<CreatePasswordAction>] {
    switch action {
    case .create:
        let item = VaultItem(name: state.siteName, username: state.username, password: state.password, url: URL(string: state.siteURL)!)
        return [
            .fireAndForget {
                environment.save(item) { _ in }
            },
            .sync { .displayingForm(false) },
        ]
    case let .setName(string):
        state.siteName = string
        return []
    case let .setUsername(string):
        state.username = string
        return []
    case let .setPassword(string):
        state.password = string
        return []
    case let .setSiteURL(string):
        state.siteURL = string
        return []
    case .toggleShowPassword:
        state.showPassword = !state.showPassword
        return []
    case let .displayingForm(value):
        state.displayingForm = value
        return []
    }
}

struct CreatePasswordView: View {
    @ObservedObject var store: Store<CreatePasswordState, CreatePasswordAction>

    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading) {
                            Text("Name").bold()
                            TextField(
                                "Kraken Vault",
                                text: Binding(get: { store.value.siteName }, set: { store.send(.setName($0)) })
                            )
                            .textContentType(.organizationName)
                            .keyboardType(.asciiCapable)
                        }

                        VStack(alignment: .leading) {
                            Text("Username or e-mail").bold()
                            TextField(
                                "Username/e-mail",
                                text: Binding(get: { store.value.username }, set: { store.send(.setUsername($0)) })
                            )
                            .textContentType(.username)
                            .keyboardType(.emailAddress)
                            .disableAutocorrection(true)
                        }

                        VStack(alignment: .leading) {
                            Text("Password").bold()
                            HStack {
                                if !store.value.showPassword {
                                    SecureField(
                                        "Your password",
                                        text: Binding(get: { store.value.password }, set: { store.send(.setPassword($0)) })
                                    )
                                    .textContentType(.password)
                                    .keyboardType(.asciiCapable)
                                } else {
                                    TextField(
                                        "Password",
                                        text: Binding(get: { store.value.password }, set: { store.send(.setPassword($0)) })
                                    )
                                    .textContentType(.password)
                                    .keyboardType(.asciiCapable)
                                    .disableAutocorrection(true)
                                }
                            }.overlay(alignment: .trailing) {
                                Image(systemName: store.value.showPassword ? "eye.slash" : "eye")
                                    .onTapGesture {
                                        store.send(.toggleShowPassword)
                                    }
                            }
                        }

                        VStack(alignment: .leading) {
                            Text("Site URL").bold()
                            TextField(
                                "https://your-site.com",
                                text: Binding(get: { store.value.siteURL }, set: { store.send(.setSiteURL($0)) })
                            )
                            .textContentType(.URL)
                            .keyboardType(.URL)
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                        }
                    }
                }
            }
            .navigationTitle(Text("New Password"))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { store.send(.displayingForm(false)) }, label: {
                        Text("Cancel")
                    })
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        store.send(.create)
                    }, label: {
                        Text("Save")
                    })
                }
            }
        }
    }
}

struct CreatePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePasswordView(
            store: Store(
                initialValue: .init(),
                reducer: createPasswordReducer,
                environment: LocalVaultLoader(store: TestVaultStore())
            )
        )
    }
}
