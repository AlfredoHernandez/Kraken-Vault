//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import SwiftUI

struct PasswordGeneratedView: View {
    @State private var angle: Double = 360
    @ObservedObject var store: Store<PasswordGeneratedState, PasswordGeneratedAction>

    var body: some View {
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
