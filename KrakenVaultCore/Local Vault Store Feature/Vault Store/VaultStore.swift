//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

public protocol VaultStore {
    func retrieve(completion: @escaping (Result<[VaultStoreItem], Error>) -> Void)

    func insert(_ item: VaultStoreItem, completion: @escaping (Result<Void, Error>) -> Void)
}
