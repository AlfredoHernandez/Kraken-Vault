//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import KrakenVaultCore

func makeItem(
    uuid: UUID = .fake,
    name: String = "",
    username: String = "",
    password: String = "",
    url: URL = URL(string: "https://any-url.com")!
) -> (storeModel: VaultStoreItem, model: VaultItem) {
    return (
        .fixture(uuid: uuid, name: name, username: username, password: password, url: url),
        .fixture(uuid: uuid, name: name, username: username, password: password, url: url)
    )
}
