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

        sut.save(item.model) { _ in }

        XCTAssertEqual(store.messages, [.insert(item.storeModel)])
    }

    func test_save_failsWithInsertionError() {
        let (sut, store) = makeSUT()

        expect(sut, completesWith: .failure(anyNSError())) {
            store.completeInsertion(with: anyNSError())
        }
    }

    func test_save_succeedsOnSuccessfullStoreItemInsertion() {
        let (sut, store) = makeSUT()

        expect(sut, completesWith: .success(())) {
            store.completeInsertionSuccessfully()
        }
    }

    func test_save_doesNotCompletesAfterSUTInstanceHasBeenDeallocated() {
        let store = VaultStoreSpy()
        var sut: LocalVaultLoader? = LocalVaultLoader(store: store)
        var results = [Result<Void, Error>]()

        sut?.save(.fixture(), completion: { result in
            results.append(result)
        })

        sut = nil
        store.completeInsertionSuccessfully()

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
        _ sut: VaultSaver,
        completesWith expectedResult: VaultSaver.Result,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for save completion")

        sut.save(.fixture(name: "any")) { receivedResult in
            switch (receivedResult, expectedResult) {
            case (.success, .success): break
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
