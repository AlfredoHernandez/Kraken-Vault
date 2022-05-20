//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

public struct VaultStoreItem: Equatable {
    let name: String
    let username: String
    let password: String
    let url: URL

    public init(name: String, username: String, password: String, url: URL) {
        self.name = name
        self.username = username
        self.password = password
        self.url = url
    }
}
