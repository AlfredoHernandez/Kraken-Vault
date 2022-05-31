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

typealias CreatePasswordEnvironment = LocalVaultLoader
let createPasswordReducer = Reducer<CreatePasswordState, CreatePasswordAction, CreatePasswordEnvironment> { state, action, environment in
    switch action {
    case .create:
        let item = VaultItem(name: state.siteName, username: state.username, password: state.password, url: URL(string: state.siteURL)!)
        return Effect.concatenate(
            .fireAndForget {
                environment.save(item, completion: { _ in })
            },
            Effect(value: .displayingForm(false))
        )
    case let .setName(string):
        state.siteName = string
        return .none
    case let .setUsername(string):
        state.username = string
        return .none
    case let .setPassword(string):
        state.password = string
        return .none
    case let .setSiteURL(string):
        state.siteURL = string
        return .none
    case .toggleShowPassword:
        state.showPassword = !state.showPassword
        return .none
    case let .displayingForm(value):
        state.displayingForm = value
        return .none
    }
}

struct CreatePasswordView: View {
    let store: Store<CreatePasswordState, CreatePasswordAction>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                Form {
                    Section {
                        VStack(alignment: .leading, spacing: 16) {
                            VStack(alignment: .leading) {
                                Text("Name").bold()
                                TextField(
                                    "Kraken Vault",
                                    text: Binding(get: { viewStore.siteName }, set: { viewStore.send(.setName($0)) })
                                )
                                .textContentType(.organizationName)
                                .keyboardType(.asciiCapable)
                            }

                            VStack(alignment: .leading) {
                                Text("Username or e-mail").bold()
                                TextField(
                                    "Username/e-mail",
                                    text: Binding(get: { viewStore.username }, set: { viewStore.send(.setUsername($0)) })
                                )
                                .textContentType(.username)
                                .keyboardType(.emailAddress)
                                .disableAutocorrection(true)
                            }

                            VStack(alignment: .leading) {
                                Text("Password").bold()
                                HStack {
                                    if !viewStore.showPassword {
                                        SecureField(
                                            "Your password",
                                            text: Binding(get: { viewStore.password }, set: { viewStore.send(.setPassword($0)) })
                                        )
                                        .textContentType(.password)
                                        .keyboardType(.asciiCapable)
                                    } else {
                                        TextField(
                                            "Password",
                                            text: Binding(get: { viewStore.password }, set: { viewStore.send(.setPassword($0)) })
                                        )
                                        .textContentType(.password)
                                        .keyboardType(.asciiCapable)
                                        .disableAutocorrection(true)
                                    }
                                }.overlay(alignment: .trailing) {
                                    Image(systemName: viewStore.showPassword ? "eye.slash" : "eye")
                                        .onTapGesture {
                                            viewStore.send(.toggleShowPassword)
                                        }
                                }
                            }

                            VStack(alignment: .leading) {
                                Text("Site URL").bold()
                                TextField(
                                    "https://your-site.com",
                                    text: Binding(get: { viewStore.siteURL }, set: { viewStore.send(.setSiteURL($0)) })
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
                        Button(action: { viewStore.send(.displayingForm(false)) }, label: {
                            Text("Cancel")
                        })
                    }

                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            viewStore.send(.create)
                        }, label: {
                            Text("Save")
                        })
                    }
                }
            }
        }
    }
}

struct CreatePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePasswordView(
            store: Store(
                initialState: .init(),
                reducer: createPasswordReducer,
                environment: LocalVaultLoader(store: TestVaultStore())
            )
        )
    }
}
