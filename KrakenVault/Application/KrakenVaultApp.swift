//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import ComposableArchitecture
import CoreData
import KrakenVaultCore
import SwiftUI

@main
struct KrakenVaultApp: App {
    var body: some Scene {
        WindowGroup {
            KrakenVaultMainView(store: store)
        }
    }
}

let store = Store(
    initialValue: AppState(),
    reducer: appReducer,
    environment: AppEnvironment(
        copyToPasteboard: copyToPasteboard,
        generateFeedbackImpact: generateFeedbackImpact,
        generatePassword: generatePassword,
        vaultItemsStore: zurry(localVaultLoader),
        dispatchQueueScheduler: DispatchQueue.main.eraseToAnyScheduler()
    )
)

let KrakenVaultStore: VaultStore = try! CoreDataVaultStore(
    storeURL: NSPersistentContainer
        .defaultDirectoryURL()
        .appendingPathComponent("kraken-vault-store.sqlite")
)

func localVaultLoader() -> LocalVaultLoader {
    KrakenVaultStore
        |> LocalVaultLoader.init
}
