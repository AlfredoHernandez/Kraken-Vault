//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

public protocol VaultDeleter {
    typealias Result = Swift.Result<Void, Error>
    func delete(_ item: VaultItem, completion: @escaping (VaultDeleter.Result) -> Void)
}

public class LocalVaultLoader: VaultLoader {
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
}

extension LocalVaultLoader: VaultSaver {
    public func save(_ item: VaultItem, completion: @escaping (Result<Void, Error>) -> Void) {
        store.insert(item.toLocalItem()) { [weak self] result in
            guard self != nil else { return }
            completion(result)
        }
    }
}

extension LocalVaultLoader: VaultDeleter {
    public func delete(_ item: VaultItem, completion: @escaping (Result<Void, Error>) -> Void) {
        store.delete(item.toLocalItem()) { [weak self] result in
            guard self != nil else { return }
            completion(result)
        }
    }
}

extension VaultStoreItem {
    func toVaultItem() -> VaultItem {
        VaultItem(uuid: uuid, name: name, username: username, password: password, url: url)
    }
}

extension VaultItem {
    func toLocalItem() -> VaultStoreItem {
        VaultStoreItem(uuid: uuid, name: name, username: username, password: password, url: url)
    }
}
