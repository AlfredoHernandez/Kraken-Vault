//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import KrakenVaultCore

enum KrakenVaultAction {
    case loadVault
    case loadedVault([VaultItem])
    case save(VaultItem)
    case delete(IndexSet)
}
