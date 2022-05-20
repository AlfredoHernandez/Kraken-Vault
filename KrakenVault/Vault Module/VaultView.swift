//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Combine
import ComposableArchitecture
import KrakenVaultCore
import PowerfulCombine
import SwiftUI

struct VaultView: View {
    @ObservedObject var store: Store<PasswordVaultState, PasswordVaultAction>
    @State var query: String = ""

    var body: some View {
        NavigationView {
            List(store.value.vaultItems) { item in
                PasswordVaultItemView(siteName: item.name, loginIdentifier: "AlfredoHernandezAlarcon")
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
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            store.send(.loadVault)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                store.send(.save(VaultItem(name: "A new name", password: "anyPassword", url: URL(string: "https://any-url.com")!)))
            }
        }
    }
}

extension VaultItem: Identifiable {
    public var id: String {
        name + url.absoluteString
    }
}

struct VaultView_Previews: PreviewProvider {
    static var previews: some View {
        VaultView(
            store: Store(
                initialValue: .init(),
                reducer: vaultReducer,
                environment: (testlVaultLoader, .immediateOnMainQueue)
            )
        )
    }
}

let testlVaultLoader = LocalVaultLoader(store: TestVaultStore())

class TestVaultStore: VaultStore {
    var items: [VaultStoreItem] = [
        .init(name: "Facebook", password: "1234556", url: URL(string: "https://any-url.com/")!),
        .init(name: "Twitter", password: "1234556", url: URL(string: "https://any-url.com/")!),
        .init(name: "WhatsApp", password: "1234556", url: URL(string: "https://any-url.com/")!),
        .init(name: "Telegram", password: "1234556", url: URL(string: "https://any-url.com/")!),
    ]

    func insert(_ item: VaultStoreItem, completion: @escaping (Result<Void, Error>) -> Void) {
        items.append(item)
        completion(.success(()))
    }

    func retrieve(completion: @escaping (Result<[VaultStoreItem], Error>) -> Void) {
        completion(.success(items))
    }
}
