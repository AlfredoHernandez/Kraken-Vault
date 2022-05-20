//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import KrakenVaultCore

func makeItem(
    name: String = "",
    password: String = "",
    url: URL = URL(string: "https://any-url.com")!
) -> (storeModel: LocalVaultItem, model: VaultItem) {
    return (.fixture(name: name, password: password, url: url), .fixture(name: name, password: password, url: url))
}
