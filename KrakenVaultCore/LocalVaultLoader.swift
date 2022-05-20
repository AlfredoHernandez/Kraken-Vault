//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

public struct VaultItem {
    let name: String
    let password: String
    let url: URL
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
}

// MARK: - Persistence

public struct LocalVaultItem {
    let name: String
    let password: String
    let url: URL
}

extension LocalVaultItem {
    func toVaultItem() -> VaultItem {
        VaultItem(name: name, password: password, url: url)
    }
}

public protocol VaultStore {
    func retrieve(completion: @escaping (Result<[LocalVaultItem], Error>) -> Void)
}
