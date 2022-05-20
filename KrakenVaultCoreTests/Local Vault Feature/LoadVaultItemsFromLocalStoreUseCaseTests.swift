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

        expect(sut, completesWith: .failure(anyNSError())) {
            store.completeRetrieve(with: anyNSError())
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
        let items: [(storeModel: VaultStoreItem, model: VaultItem)] = [
            makeItem(name: "Facebook", password: "apassword", url: URL(string: "https://facebook.com/")!),
            makeItem(name: "Twitter", password: "anothePassword", url: URL(string: "https://twitter.com/")!),
            makeItem(name: "Twitch", password: "Passw0rd4423", url: URL(string: "https://twich.com/")!),
        ]

        expect(sut, completesWith: .success(items.map(\.model))) {
            store.completeRetrieve(with: items.map(\.storeModel))
        }
    }

    func test_load_doesNotCompletesAfterSUTInstanceHasBeenDeallocated() {
        let store = VaultStoreSpy()
        var sut: LocalVaultLoader? = LocalVaultLoader(store: store)
        var results = [Result<[VaultItem], Error>]()

        sut?.load(completion: { result in
            results.append(result)
        })

        sut = nil
        store.completeRetrieve(with: [.fixture()])

        XCTAssertTrue(results.isEmpty, "Expected no results after SUT instance has been deallocated")
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
        _ sut: VaultLoader,
        completesWith expectedResult: VaultLoader.Result,
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

extension VaultStoreItem {
    static func fixture(name: String = "", username: String = "", password: String = "", url: URL = URL(string: "https://any-url.com")!) -> Self {
        VaultStoreItem(name: name, username: username, password: password, url: url)
    }
}

extension VaultItem {
    static func fixture(name: String = "", username: String = "", password: String = "", url: URL = URL(string: "https://any-url.com")!) -> Self {
        VaultItem(name: name, username: username, password: password, url: url)
    }
}
