//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import SwiftUI

struct PasswordGeneratorView: View {
    @ObservedObject var store: Store<PasswordGeneratorState, PasswordGeneratorAction>

    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    Section(header: Text("Password generated")) {
                        HStack {
                            Spacer()
                            PasswordGeneratedView(
                                store: store.view(value: { $0.passwordGenerated }, action: { .passwordGenerated($0) })
                            )
                        }
                        HStack {
                            Spacer()
                            Button(action: { store.send(.copyPassword) }) {
                                Text("Copy Password")
                            }
                            Spacer()
                        }
                    }

                    Section {
                        Slider(
                            value: Binding(get: {
                                store.value.passwordGenerated.characterCount
                            }, set: {
                                store.send(.updatePasswordLength($0))
                                store.send(.passwordGenerated(.generate))
                            }),
                            in: store.value.passwordGenerated.passwordLenghtRange,
                            step: 1
                        )
                        .transition(.opacity)
                        .transition(.move(edge: .top))
                        .animation(Animation.easeOut(duration: 0.8), value: store.value.passwordGenerated.characterCount)
                    } header: {
                        Text("Password length: \(Int(store.value.passwordGenerated.characterCount))")
                    }

                }.navigationTitle(Text("Generator"))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordGeneratorView(
            store: Store(initialValue: PasswordGeneratorState(), reducer: passwordGeneratorReducer)
        )
    }
}
