//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct PasswordGeneratorView: View {
    let store: Store<PasswordGeneratorState, PasswordGeneratorAction>
    @State private var angle: Double = 360

    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                ZStack {
                    Form {
                        Section(header: Text("Password generated")) {
                            VStack {
                                HStack {
                                    Spacer()
                                    HStack(spacing: 0) {
                                        HStack(spacing: 1) {
                                            ForEach(0 ..< viewStore.characters.count, id: \.self) { index in
                                                Text(viewStore.characters[index])
                                                    .foregroundColor(
                                                        viewStore.specialCharactersArray.contains(viewStore.characters[index]) ? Color.red
                                                            : viewStore.numbersArray.contains(viewStore.characters[index]) ? Color.cyan
                                                            : viewStore.alphabet.contains(viewStore.characters[index]) ? .gray : .yellow
                                                    )
                                            }
                                        }
                                        .fixedSize(horizontal: false, vertical: true)
                                        .font(viewStore.characterCount > 25 ? .system(size: 15).monospaced().bold() : .body.monospaced().bold())
                                        .animation(Animation.easeOut(duration: 0.2), value: viewStore.characters)
                                        .frame(maxWidth: .infinity)

                                        Button(action: {
                                            angle += 360
                                            viewStore.send(.generate)
                                        }) {
                                            Image(systemName: "arrow.triangle.2.circlepath")
                                                .foregroundColor(.accentColor)
                                                .font(.body.bold())
                                                .frame(width: 32, height: 32, alignment: .center)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        .rotationEffect(Angle(degrees: angle))
                                        .animation(.easeIn, value: angle)
                                    }.onAppear(perform: { viewStore.send(.generate) })
                                }
                                HStack {
                                    Button(action: { viewStore.send(.copyPassword) }) {
                                        Text("Copy password")
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
                        }

                        Section {
                            HStack {
                                Text("6").foregroundColor(Color.secondary)
                                Slider(
                                    value: Binding(get: {
                                        viewStore.characterCount
                                    }, set: {
                                        viewStore.send(.updatePasswordLength($0))
                                    }),
                                    in: viewStore.passwordLengthRange,
                                    step: 1
                                )
                                .accentColor(.accentColor)
                                .transition(.opacity)
                                .transition(.move(edge: .top))
                                .animation(Animation.easeOut(duration: 0.8), value: viewStore.characterCount)
                                Text("32").foregroundColor(Color.secondary)
                            }
                        } header: {
                            Text("Password length: \(Int(viewStore.characterCount))")
                        }

                        Section {
                            PasswordOptionToggle(
                                title: "Special Characters",
                                exampleText: "&-$",
                                color: .red,
                                option: Binding(
                                    get: { viewStore.includeSpecialChars },
                                    set: { viewStore.send(.includeSpecialChars($0)) }
                                )
                            )

                            PasswordOptionToggle(
                                title: "Uppercased",
                                exampleText: "A-Z",
                                color: .yellow,
                                option: Binding(
                                    get: { viewStore.includeUppercased },
                                    set: { viewStore.send(.includeUppercased($0)) }
                                )
                            )

                            PasswordOptionToggle(
                                title: "Numbers",
                                exampleText: "0-9",
                                color: .cyan,
                                option: Binding(
                                    get: { viewStore.includeNumbers },
                                    set: { viewStore.send(.includeNumbers($0)) }
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordGeneratorView(
            store: Store(
                initialState: PasswordGeneratorState(),
                reducer: passwordGeneratorReducer,
                environment: PasswordGeneratorEnvironment(
                    copyToPasteboard: { _ in },
                    generateFeedbackImpact: {},
                    generatePassword: generatePassword
                )
            )
        )
    }
}
