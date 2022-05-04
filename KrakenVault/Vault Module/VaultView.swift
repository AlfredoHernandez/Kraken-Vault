//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import SwiftUI

struct VaultView: View {
    @State var query: String = ""

    var body: some View {
        NavigationView {
            List {
                Section("F") {
                    ForEach(1 ..< 2) { _ in
                        NavigationLink(destination: { EmptyView() }) {
                            PasswordVaultItemView(siteName: "facebook.com", loginIdentifier: "AlfredoHernandezAlarcon")
                        }
                    }
                }
                Section("G") {
                    ForEach(1 ..< 3) { _ in
                        NavigationLink(destination: { EmptyView() }) {
                            PasswordVaultItemView(siteName: "github.com", loginIdentifier: "AlfredoHernandez")
                        }
                    }
                }
            }
            .searchable(
                text: $query,
                placement: .navigationBarDrawer(displayMode: .automatic),
                prompt: Text("Search password")
            )
            .navigationTitle(Text("Vault"))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                Button(action: {}) {
                    Image(systemName: "plus")
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct VaultView_Previews: PreviewProvider {
    static var previews: some View {
        VaultView()
    }
}
