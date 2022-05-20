//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

public struct VaultItem: Equatable {
    public let uuid: UUID
    public let name: String
    public let username: String
    public let password: String
    public let url: URL

    public init(uuid: UUID = UUID(), name: String, username: String, password: String, url: URL) {
        self.uuid = uuid
        self.name = name
        self.username = username
        self.password = password
        self.url = url
    }
}
