//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

public protocol VaultStore {
    typealias RetrievalResult = Result<[VaultStoreItem], Error>
    func retrieve(completion: @escaping (RetrievalResult) -> Void)

    typealias InsertionResult = Result<Void, Error>
    func insert(_ item: VaultStoreItem, completion: @escaping (InsertionResult) -> Void)

    typealias DeletionResult = Result<Void, Error>
    func delete(_ item: VaultStoreItem, completion: @escaping (DeletionResult) -> Void)
}
