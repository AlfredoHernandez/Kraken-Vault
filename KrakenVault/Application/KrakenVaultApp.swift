//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import ComposableArchitecture
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
        vaultItemsStore: localVaultLoader,
        dispatchQueueScheduler: DispatchQueue.main.eraseToAnyScheduler()
    )
)

let localVaultLoader = LocalVaultLoader(store: TestVaultStore())
