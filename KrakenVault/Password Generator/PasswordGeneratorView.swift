//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import SwiftUI

struct PasswordGeneratorView: View {
    @ObservedObject var store: Store<AppState, AppAction>

    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    Section(header: Text("Password generado")) {
                        PasswordGeneratedView(
                            store: store.view(value: { $0.passwordGenerated }, action: { .passwordGenerated($0) })
                        )
                    }
                }.navigationTitle(Text("Generador"))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordGeneratorView(
            store: Store(initialValue: AppState(), reducer: appReducer)
        )
    }
}
