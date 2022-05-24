//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Combine
import ComposableArchitecture
import KrakenVaultCore
import PowerfulCombine
import SwiftUI

struct KrakenVaultView: View {
    @ObservedObject var store: Store<PasswordVaultState, PasswordVaultAction>
    @State var query: String = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(store.value.vaultItems) { item in
                    NavigationLink {
                        EmptyView()
                    } label: {
                        PasswordVaultItemView(siteName: item.name, loginIdentifier: item.username)
                    }
                }
                .onDelete { index in store.send(.delete(index)) }
            }
            .listStyle(PlainListStyle())
            .searchable(
                text: $query,
                placement: .navigationBarDrawer(displayMode: .automatic),
                prompt: Text("Search password")
            )
            .overlay(Group {
                if store.value.vaultItems.isEmpty {
                    Text("Oops, loos like there's no any passwords in your vault! Let's add a new one 🔑")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding()
                }
            })
            .navigationTitle(Text("Vault"))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                Button(action: { store.send(
                    .save(
                        VaultItem(
                            name: "A new name",
                            username: "a new username xD",
                            password: "anyPassword",
                            url: URL(string: "https://any-url.com")!
                        )
                    )
                ) }) {
                    Image(systemName: "plus")
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            store.send(.loadVault)
        }
    }
}

extension VaultItem: Identifiable {
    public var id: UUID { uuid }
}

struct VaultView_Previews: PreviewProvider {
    static var previews: some View {
        KrakenVaultView(
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
        .init(name: "Facebook", username: "user@mail.com", password: "123456", url: URL(string: "https://facebook.com/")!),
        .init(name: "Twitter", username: "username", password: "123456", url: URL(string: "https://twitter.com/")!),
        .init(name: "Instagram", username: "user@mail.com", password: "654321", url: URL(string: "https://instagram.com/")!),
    ]

    func insert(_ item: VaultStoreItem, completion: @escaping (Result<Void, Error>) -> Void) {
        items.append(item)
        completion(.success(()))
    }

    func retrieve(completion: @escaping (Result<[VaultStoreItem], Error>) -> Void) {
        completion(.success(items))
    }

    func delete(_ item: VaultStoreItem, completion: @escaping (Result<Void, Error>) -> Void) {
        items.removeAll(where: { $0.uuid == item.uuid })
        completion(.success(()))
    }
}
