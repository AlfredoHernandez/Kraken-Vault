//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import KrakenVaultCore

func makeItem(
    name: String = "",
    username: String = "",
    password: String = "",
    url: URL = URL(string: "https://any-url.com")!
) -> (storeModel: VaultStoreItem, model: VaultItem) {
    return (.fixture(name: name, username: username, password: password, url: url), .fixture(name: name, username: username, password: password, url: url))
}
