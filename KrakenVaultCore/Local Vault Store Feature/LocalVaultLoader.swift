//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

public class LocalVaultLoader {
    private let store: VaultStore

    public init(store: VaultStore) {
        self.store = store
    }

    public func load(completion: @escaping (Result<[VaultItem], Error>) -> Void) {
        store.retrieve { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success(items):
                completion(.success(items.map { $0.toVaultItem() }))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    public func save(_ item: VaultItem, completion: @escaping (Result<Void, Error>) -> Void) {
        store.insert(item.toLocalItem()) { [weak self] result in
            guard self != nil else { return }
            completion(result)
        }
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
