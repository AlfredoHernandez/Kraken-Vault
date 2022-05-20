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
        vaultItemsStore: localVaultLoader
    )
)

let localVaultLoader = LocalVaultLoader(store: SampleStore())

class SampleStore: VaultStore {
    func retrieve(completion: @escaping (Result<[LocalVaultItem], Error>) -> Void) {
        completion(.success([
            .init(name: "Facebook", password: "1234556", url: URL(string: "https://any-url.com/")!),
            .init(name: "Twitter", password: "1234556", url: URL(string: "https://any-url.com/")!),
            .init(name: "WhatsApp", password: "1234556", url: URL(string: "https://any-url.com/")!),
            .init(name: "Telegram", password: "1234556", url: URL(string: "https://any-url.com/")!),
        ]))
    }
}
