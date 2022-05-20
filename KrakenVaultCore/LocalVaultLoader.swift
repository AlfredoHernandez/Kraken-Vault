//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

public struct VaultItem: Equatable {
    public let name: String
    public let password: String
    public let url: URL

    public init(name: String, password: String, url: URL) {
        self.name = name
        self.password = password
        self.url = url
    }
}

public class LocalVaultLoader {
    private let store: VaultStore

    public init(store: VaultStore) {
        self.store = store
    }

    public func load(completion: @escaping (Result<[VaultItem], Error>) -> Void) {
        store.retrieve { result in
            switch result {
            case let .success(items):
                completion(.success(items.map { $0.toVaultItem() }))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    public func save(_ item: VaultItem, completion: @escaping (Result<Void, Error>) -> Void) {
        store.insert(item.toLocalItem(), completion: completion)
    }
}

// MARK: - Persistence

public struct LocalVaultItem: Equatable {
    let name: String
    let password: String
    let url: URL

    public init(name: String, password: String, url: URL) {
        self.name = name
        self.password = password
        self.url = url
    }
}

extension LocalVaultItem {
    func toVaultItem() -> VaultItem {
        VaultItem(name: name, password: password, url: url)
    }
}

extension VaultItem {
    func toLocalItem() -> LocalVaultItem {
        LocalVaultItem(name: name, password: password, url: url)
    }
}

public protocol VaultStore {
    func retrieve(completion: @escaping (Result<[LocalVaultItem], Error>) -> Void)

    func insert(_ item: LocalVaultItem, completion: @escaping (Result<Void, Error>) -> Void)
}
