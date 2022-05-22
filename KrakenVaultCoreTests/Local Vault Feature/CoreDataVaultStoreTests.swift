//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import KrakenVaultCore
import XCTest

final class CoreDataVaultStoreTests: XCTestCase {
    func test_retrieve_deliversEmptyOnEmptyStore() throws {
        let sut = makeSUT()

        expect(sut, toRetrieve: .success([]))
    }

    func test_retrieve_deliversFoundValuesOnNonEmptyStore() throws {
        let sut = makeSUT()
        let item = makeItem()

        insert(item.storeModel, to: sut)

        expect(sut, toRetrieve: .success([item.storeModel]))
    }

    func test_insert_deliversNoErrorOnEmptyStore() throws {
        let sut = makeSUT()
        let insertionError = insert(.fixture(), to: sut)

        XCTAssertNil(insertionError, "Expected to insert item successfully")
    }

    func test_insert_deliversNoErrorOnNonEmptyStore() throws {
        let sut = makeSUT()
        insert(.fixture(), to: sut)

        let insertionError = insert(.fixture(name: "any-other-item"), to: sut)
        XCTAssertNil(insertionError, "Expected to insert item successfully")
    }

    func test_delete_deliversErrorOnEmptyStore() throws {
        let sut = makeSUT()

        let receivedError = delete(makeItem(uuid: .fake).storeModel, to: sut)
        XCTAssertEqual(receivedError as! CoreDataVaultStore.KrakenVaultError, CoreDataVaultStore.KrakenVaultError.itemNotFound(UUID.fake.uuidString))
    }

    func test_delete_deliversNoErrorOnNonEmptyStore() throws {
        let sut = makeSUT()
        let item = makeItem(uuid: .fake).storeModel
        insert(item, to: sut)

        let receivedError = delete(item, to: sut)
        XCTAssertNil(receivedError, "Expected to delete item successfully")
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> VaultStore {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataVaultStore(storeURL: storeURL)

        trackForMemoryLeaks(sut, file: file, line: line)

        return sut
    }

    func expect(
        _ sut: VaultStore,
        toRetrieve expectedResult: VaultStore.RetrievalResult,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for store retrieval")

        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case let (.success(expected), .success(retrieved)):
                XCTAssertEqual(retrieved, expected, file: file, line: line)
            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }

    @discardableResult
    func delete(_ item: VaultStoreItem, to sut: VaultStore) -> Error? {
        let exp = expectation(description: "Wait for store deletion")
        var receivedError: Error?

        sut.delete(item) { result in
            switch result {
            case .success: break
            case let .failure(error):
                receivedError = error
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
        return receivedError
    }

    @discardableResult
    func insert(_ item: VaultStoreItem, to sut: VaultStore) -> Error? {
        let exp = expectation(description: "Wait for store insertion")
        var receivedError: Error?

        sut.insert(item) { result in
            switch result {
            case .success: break
            case let .failure(error):
                receivedError = error
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
        return receivedError
    }
}
