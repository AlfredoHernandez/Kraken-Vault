//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import KrakenVaultCore
import XCTest

final class SaveVaultItemsUseCaseTests: XCTestCase {
    func test_init_doesNotMessageLocalStoreUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertEqual(store.messages, [])
    }

    func test_save_requestsInsertionItems() {
        let (sut, store) = makeSUT()
        let item = makeItem(name: "any")

        sut.save(item.model)

        XCTAssertEqual(store.messages, [.insert(item.storeModel)])
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (LocalVaultLoader, VaultStoreSpy) {
        let store = VaultStoreSpy()
        let sut = LocalVaultLoader(store: store)

        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
}
