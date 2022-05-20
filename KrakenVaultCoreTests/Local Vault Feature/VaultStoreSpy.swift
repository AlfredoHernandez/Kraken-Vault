//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import KrakenVaultCore

class VaultStoreSpy: VaultStore {
    enum Message: Equatable {
        case retrieve
        case insert(VaultStoreItem)
        case delete(VaultStoreItem)
    }

    var messages = [Message]()

    // MARK: - Retrieval

    var retrieveRequests = [(Result<[VaultStoreItem], Error>) -> Void]()

    func retrieve(completion: @escaping (Result<[VaultStoreItem], Error>) -> Void) {
        messages.append(.retrieve)
        retrieveRequests.append(completion)
    }

    func completeRetrieve(with error: Error, at index: Int = 0) {
        retrieveRequests[index](.failure(error))
    }

    func completeRetrieve(with items: [VaultStoreItem], at index: Int = 0) {
        retrieveRequests[index](.success(items))
    }

    // MARK: - Insertion

    var insertionRequests = [(Result<Void, Error>) -> Void]()

    func insert(_ item: VaultStoreItem, completion: @escaping (Result<Void, Error>) -> Void) {
        messages.append(.insert(item))
        insertionRequests.append(completion)
    }

    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionRequests[index](.failure(error))
    }

    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionRequests[index](.success(()))
    }

    // MARK: - Deletion

    var deletionRequests = [(Result<Void, Error>) -> Void]()

    func delete(_ item: VaultStoreItem, completion: @escaping (Result<Void, Error>) -> Void) {
        messages.append(.delete(item))
        deletionRequests.append(completion)
    }

    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionRequests[index](.failure(error))
    }

    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionRequests[index](.success(()))
    }
}
