//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import KrakenVaultCore
import XCTest

final class LoadVaultItemsFromLocalStoreUseCaseTests: XCTestCase {
    func test_init_doesNotMessageLocalStoreUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertEqual(store.messages, [])
    }

    func test_load_requestsRetrieveItems() {
        let (sut, store) = makeSUT()

        sut.load { _ in }

        XCTAssertEqual(store.messages, [.retrieve])
    }

    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let expectedError = NSError(domain: "io.alfredohdz.KrakenVaultCore.testing", code: 0)

        expect(sut, completesWith: .failure(expectedError)) {
            store.completeRetrieve(with: expectedError)
        }
    }

    func test_load_deliversNoItemsOnEmptyVault() {
        let (sut, store) = makeSUT()

        expect(sut, completesWith: .success([])) {
            store.completeRetrieve(with: [])
        }
    }

    func test_load_deliversVaultItemsOnNonEmptyVault() {
        let (sut, store) = makeSUT()
        let items: [(storeModel: LocalVaultItem, model: VaultItem)] = [
            makeItem(name: "Facebook", password: "apassword", url: URL(string: "https://facebook.com/")!),
            makeItem(name: "Twitter", password: "anothePassword", url: URL(string: "https://twitter.com/")!),
            makeItem(name: "Twitch", password: "Passw0rd4423", url: URL(string: "https://twich.com/")!),
        ]

        expect(sut, completesWith: .success(items.map(\.model))) {
            store.completeRetrieve(with: items.map(\.storeModel))
        }
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (LocalVaultLoader, VaultStoreSpy) {
        let store = VaultStoreSpy()
        let sut = LocalVaultLoader(store: store)

        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }

    private func expect(
        _ sut: LocalVaultLoader,
        completesWith expectedResult: Result<[VaultItem], Error>,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for loading completion")

        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case let (.failure(receivedError), .failure(expectedError)):
                XCTAssertEqual(receivedError as NSError, expectedError as NSError, file: file, line: line)
            default:
                XCTFail("Expected a \(expectedResult), but got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }

        action()
        wait(for: [exp], timeout: 1.0)
    }
}

extension LocalVaultItem {
    static func fixture(name: String = "", password: String = "", url: URL = URL(string: "https://any-url.com")!) -> Self {
        LocalVaultItem(name: name, password: password, url: url)
    }
}

extension VaultItem {
    static func fixture(name: String = "", password: String = "", url: URL = URL(string: "https://any-url.com")!) -> Self {
        VaultItem(name: name, password: password, url: url)
    }
}
