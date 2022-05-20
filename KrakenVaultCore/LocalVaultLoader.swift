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
            if case let .failure(error) = result {
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

public protocol VaultStore {
    func retrieve(completion: @escaping (Result<[LocalVaultItem], Error>) -> Void)
}
