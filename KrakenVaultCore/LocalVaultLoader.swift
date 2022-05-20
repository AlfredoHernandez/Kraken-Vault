//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

public struct VaultItem {
    let name: String
    let password: String
    let url: URL
}

public protocol VaultStore {
    func retrieve()
}

public class LocalVaultLoader {
    private let store: VaultStore

    public init(store: VaultStore) {
        self.store = store
    }

    public func load() {
        store.retrieve()
    }
}
