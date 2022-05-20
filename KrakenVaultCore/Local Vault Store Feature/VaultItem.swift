//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

public struct VaultItem: Equatable {
    public let name: String
    public let password: String
    public let url: URL

    public init(name: String, password: String, url: URL) {
        self.name = name
        self.password = password
        self.url = url
    }
}
