//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

public struct VaultStoreItem: Equatable {
    let name: String
    let password: String
    let url: URL

    public init(name: String, password: String, url: URL) {
        self.name = name
        self.password = password
        self.url = url
    }
}
