//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Combine
import ComposableArchitecture
import KrakenVaultCore
import PowerfulCombine
import SwiftUI

extension LocalVaultLoader {
    func publisher() -> AnyPublisher<[VaultItem], Error> {
        Deferred {
            Future { [weak self] completion in
                self?.load(completion: completion)
            }
        }.eraseToAnyPublisher()
    }
}

struct PasswordVaultState {
    var vaultItems: [VaultItem] = []
}

enum PasswordVaultAction {
    case loadVault
    case loadedVault([VaultItem])
}

typealias VaultEnvironment = (loader: LocalVaultLoader, scheduler: AnyDispatchQueueScheduler)

func vaultReducer(state: inout PasswordVaultState, action: PasswordVaultAction, environment: VaultEnvironment) -> [Effect<PasswordVaultAction>] {
    switch action {
    case .loadVault:
        return [
            environment.loader.publisher()
                .receive(on: environment.scheduler)
                .replaceError(with: [])
                .eraseToEffect()
                .flatMap { items in
                    Effect<PasswordVaultAction>.sync {
                        .loadedVault(items)
                    }
                }.eraseToEffect(),
        ]
    case let .loadedVault(items):
        state.vaultItems = items
        return []
    }
}

extension VaultItem: Identifiable {
    public var id: String {
        name + url.absoluteString
    }
}

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
        .onAppear { store.send(.loadVault) }
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
    func retrieve(completion: @escaping (Result<[LocalVaultItem], Error>) -> Void) {
        completion(.success([
            .init(name: "Facebook", password: "1234556", url: URL(string: "https://any-url.com/")!),
            .init(name: "Twitter", password: "1234556", url: URL(string: "https://any-url.com/")!),
            .init(name: "WhatsApp", password: "1234556", url: URL(string: "https://any-url.com/")!),
            .init(name: "Telegram", password: "1234556", url: URL(string: "https://any-url.com/")!),
        ]))
    }
}
