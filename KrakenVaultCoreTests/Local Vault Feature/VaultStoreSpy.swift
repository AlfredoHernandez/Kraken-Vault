//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import KrakenVaultCore

class VaultStoreSpy: VaultStore {
    enum Message {
        case retrieve
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
}
