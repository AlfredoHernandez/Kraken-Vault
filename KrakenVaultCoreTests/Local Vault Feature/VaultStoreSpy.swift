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

    func insert(_ item: LocalVaultItem) {
        messages.append(.insert(item))
    }
}
