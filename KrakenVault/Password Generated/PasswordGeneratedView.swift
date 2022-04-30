//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import SwiftUI

struct PasswordGeneratedView: View {
    @ObservedObject var store: Store<PasswordGeneratedState, PasswordGeneratedAction>

    var body: some View {
        HStack {
            HStack(spacing: 0.5) {
                ForEach(store.value.characters, id: \.self) { character in
                    Text(character)
                        .foregroundColor(
                            store.value.specialCharactersArray.contains(character) ? Color(hexadecimal: "#f16581")
                                : store.value.numbersArray.contains(character) ? Color(hexadecimal: "#4EB3BC")
                                : store.value.alphabet.contains(character) ? .gray : Color(hexadecimal: "#ffbc42")
                        )
                }
            }
            .font(store.value.characterCount > 25 ? .system(size: 15) : .body)
            .animation(Animation.easeOut(duration: 0.1), value: store.value.characters)
        }
    }
}

struct PasswordGeneratedView_Previews: PreviewProvider {
    static let password = ["1", "3", "%", "a", "B", "/", "#", "k", "0", "[", ">", "m", "0", "p", "{"]
    static var previews: some View {
        Group {
            PasswordGeneratedView(
                store: Store(initialValue: PasswordGeneratedState(characters: password), reducer: passwordGeneratedReducer)
            ).previewLayout(.sizeThatFits)
            PasswordGeneratedView(
                store: Store(initialValue: PasswordGeneratedState(characters: password), reducer: passwordGeneratedReducer)
            ).preferredColorScheme(.dark).previewLayout(.sizeThatFits)
        }
    }
}
