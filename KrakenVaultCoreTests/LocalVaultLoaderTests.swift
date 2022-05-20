//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import KrakenVaultCore
import XCTest

final class LocalVaultLoaderTests: XCTestCase {
    func test_init_doesNotMessageLocalStoreUponCreation() {
        let store = VaultStoreSpy()
        _ = LocalVaultLoader(store: store)

        XCTAssertEqual(store.messages, [])
    }

    func test_load_requestsRetrieveItems() {
        let store = VaultStoreSpy()
        let sut = LocalVaultLoader(store: store)

        sut.load()

        XCTAssertEqual(store.messages, [.retrieve])
    }

    // MARK: - Helpers

    class VaultStoreSpy: VaultStore {
        enum Message {
            case retrieve
        }

        var messages = [Message]()

        func retrieve() {
            messages.append(.retrieve)
        }
    }
}
