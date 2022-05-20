//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import KrakenVaultCore

class VaultStoreSpy: VaultStore {
    enum Message: Equatable {
        case retrieve
        case insert(LocalVaultItem)
    }

    var messages = [Message]()

    // MARK: - Retrieval

    var retrieveRequests = [(Result<[LocalVaultItem], Error>) -> Void]()

    func retrieve(completion: @escaping (Result<[LocalVaultItem], Error>) -> Void) {
        messages.append(.retrieve)
        retrieveRequests.append(completion)
    }

    func completeRetrieve(with error: Error, at index: Int = 0) {
        retrieveRequests[index](.failure(error))
    }

    func completeRetrieve(with items: [LocalVaultItem], at index: Int = 0) {
        retrieveRequests[index](.success(items))
    }

    // MARK: - Insertion

    var insertionRequests = [(Result<Void, Error>) -> Void]()

    func insert(_ item: LocalVaultItem, completion: @escaping (Result<Void, Error>) -> Void) {
        messages.append(.insert(item))
        insertionRequests.append(completion)
    }

    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionRequests[index](.failure(error))
    }
}
