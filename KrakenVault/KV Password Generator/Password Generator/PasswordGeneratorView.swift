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
                            Button(action: { store.send(.copyPassword) }) {
                                Text("Copy Password")
                                    .bold()
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
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
                        .accentColor(.green)
                        .transition(.opacity)
                        .transition(.move(edge: .top))
                        .animation(Animation.easeOut(duration: 0.8), value: store.value.passwordGenerated.characterCount)
                    } header: {
                        Text("Password length: \(Int(store.value.passwordGenerated.characterCount))")
                    }

                    Section {
                        PasswordOptionToggle(
                            title: "Special Characters",
                            exampleText: "&-$",
                            color: .red,
                            option: Binding(
                                get: { store.value.passwordGenerated.includeSpecialChars },
                                set: { store.send(.passwordGenerated(.includeSpecialChars($0))) }
                            )
                        )

                        PasswordOptionToggle(
                            title: "Uppercased",
                            exampleText: "A-Z",
                            color: .yellow,
                            option: Binding(
                                get: { store.value.passwordGenerated.includeUppercased },
                                set: { store.send(.passwordGenerated(.includeUppercased($0))) }
                            )
                        )

                        PasswordOptionToggle(
                            title: "Numbers",
                            exampleText: "0-9",
                            color: .cyan,
                            option: Binding(
                                get: { store.value.passwordGenerated.includeNumbers },
                                set: { store.send(.passwordGenerated(.includeNumbers($0))) }
                            )
                        )
                    } header: { Text("Include") }
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
        .preferredColorScheme(.dark)
    }
}
