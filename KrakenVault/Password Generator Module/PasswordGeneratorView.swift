//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import SwiftUI

struct PasswordGeneratorView: View {
    @State private var angle: Double = 360
    @ObservedObject var store: Store<PasswordGeneratorState, PasswordGeneratorAction>

    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    Section(header: Text("Password generated")) {
                        HStack {
                            Spacer()
                            HStack(spacing: 0) {
                                HStack(spacing: 1) {
                                    ForEach(0 ..< store.value.characters.count, id: \.self) { index in
                                        Text(store.value.characters[index])
                                                .foregroundColor(
                                                        store.value.specialCharactersArray.contains(store.value.characters[index]) ? Color.red
                                                                : store.value.numbersArray.contains(store.value.characters[index]) ? Color.cyan
                                                                : store.value.alphabet.contains(store.value.characters[index]) ? .gray : .yellow
                                                )
                                    }
                                }
                                        .fixedSize(horizontal: false, vertical: true)
                                        .font(store.value.characterCount > 25 ? .system(size: 15).monospaced().bold() : .body.monospaced().bold())
                                        .animation(Animation.easeOut(duration: 0.2), value: store.value.characters)
                                        .frame(maxWidth: .infinity)

                                Button(action: {
                                    angle += 360
                                    store.send(.generate)
                                }) {
                                    Image(systemName: "arrow.triangle.2.circlepath")
                                            .foregroundColor(.accentColor)
                                            .font(.body.bold())
                                            .frame(width: 32, height: 32, alignment: .center)
                                }
                                        .buttonStyle(PlainButtonStyle())
                                        .rotationEffect(Angle(degrees: angle))
                                        .animation(.easeIn, value: angle)
                            }.onAppear(perform: { store.send(.generate) })
                        }
                        HStack {
                            Button(action: { store.send(.copyPassword) }) {
                                Text("Copy Password")
                                    .bold()
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.accentColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }

                    Section {
                        Slider(
                            value: Binding(get: {
                                store.value.characterCount
                            }, set: {
                                store.send(.updatePasswordLength($0))
                                store.send(.generate)
                            }),
                            in: store.value.passwordLengthRange,
                            step: 1
                        )
                        .accentColor(.accentColor)
                        .transition(.opacity)
                        .transition(.move(edge: .top))
                        .animation(Animation.easeOut(duration: 0.8), value: store.value.characterCount)
                    } header: {
                        Text("Password length: \(Int(store.value.characterCount))")
                    }

                    Section {
                        PasswordOptionToggle(
                            title: "Special Characters",
                            exampleText: "&-$",
                            color: .red,
                            option: Binding(
                                get: { store.value.includeSpecialChars },
                                set: { store.send(.includeSpecialChars($0)) }
                            )
                        )

                        PasswordOptionToggle(
                            title: "Uppercased",
                            exampleText: "A-Z",
                            color: .yellow,
                            option: Binding(
                                get: { store.value.includeUppercased },
                                set: { store.send(.includeUppercased($0)) }
                            )
                        )

                        PasswordOptionToggle(
                            title: "Numbers",
                            exampleText: "0-9",
                            color: .cyan,
                            option: Binding(
                                get: { store.value.includeNumbers },
                                set: { store.send(.includeNumbers($0)) }
                            )
                        )
                    } header: {
                        Text("Include")
                    } footer: {
                        HStack(alignment: .top) {
                            Text("Note: Each active parameter reinforces the password security.")
                        }
                    }
                }.navigationTitle(Text("Generator"))
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
