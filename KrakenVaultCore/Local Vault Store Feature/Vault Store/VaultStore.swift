//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

public protocol VaultStore {
    func retrieve(completion: @escaping (Result<[LocalVaultItem], Error>) -> Void)

    func insert(_ item: LocalVaultItem, completion: @escaping (Result<Void, Error>) -> Void)
}
