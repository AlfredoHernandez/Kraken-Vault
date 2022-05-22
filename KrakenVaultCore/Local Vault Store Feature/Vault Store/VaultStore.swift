//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

public protocol VaultStore {
    typealias RetrievalResult = Result<[VaultStoreItem], Error>
    func retrieve(completion: @escaping (RetrievalResult) -> Void)

    func insert(_ item: VaultStoreItem, completion: @escaping (Result<Void, Error>) -> Void)

    func delete(_ item: VaultStoreItem, completion: @escaping (Result<Void, Error>) -> Void)
}
