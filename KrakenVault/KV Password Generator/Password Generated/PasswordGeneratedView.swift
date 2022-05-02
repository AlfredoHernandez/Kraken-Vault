//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import SwiftUI

struct PasswordGeneratedView: View {
    @State private var angle: Double = 365
    @ObservedObject var store: Store<PasswordGeneratedState, PasswordGeneratedAction>

    var body: some View {
        HStack {
            HStack(spacing: 0.5) {
                ForEach(store.value.characters, id: \.self) { character in
                    Text(character)
                        .foregroundColor(
                            store.value.specialCharactersArray.contains(character) ? Color.red
                                : store.value.numbersArray.contains(character) ? Color.cyan
                                : store.value.alphabet.contains(character) ? .gray : .yellow
                        )
                }
            }
            .font(store.value.characterCount > 25 ? .system(size: 15) : .body)
            .animation(Animation.easeOut(duration: 0.2), value: store.value.characters)
            .frame(maxWidth: .infinity)
            Button(action: {
                angle += 365
                store.send(.generate)
            }) {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .foregroundColor(.green)
                    .font(.body.bold())
                    .frame(width: 32, height: 32, alignment: .center)
            }.rotationEffect(Angle(degrees: angle))
                .animation(.easeIn, value: angle)
        }.onAppear(perform: { store.send(.generate) })
    }
}

struct PasswordGeneratedView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PasswordGeneratedView(
                store: Store(initialValue: PasswordGeneratedState(), reducer: passwordGeneratedReducer)
            ).previewLayout(.sizeThatFits)
            PasswordGeneratedView(
                store: Store(initialValue: PasswordGeneratedState(), reducer: passwordGeneratedReducer)
            ).preferredColorScheme(.dark).previewLayout(.sizeThatFits)
        }
    }
}
