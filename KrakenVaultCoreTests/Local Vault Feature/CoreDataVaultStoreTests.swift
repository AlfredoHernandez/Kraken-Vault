//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import KrakenVaultCore
import XCTest

final class CoreDataVaultStoreTests: XCTestCase {
    func test_retrieve_deliversEmptyOnEmptyStore() throws {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try CoreDataVaultStore(storeURL: storeURL)

        expect(sut, toRetrieve: .success([]))
    }

    func test_retrieve_deliversNoErrorOnNonEmptyStore() throws {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try CoreDataVaultStore(storeURL: storeURL)
        let item = makeItem()

        insert(item.storeModel, to: sut)

        expect(sut, toRetrieve: .success([item.storeModel]))
    }

    func test_insert_deliversNoErrorOnEmptyStore() throws {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try CoreDataVaultStore(storeURL: storeURL)
        let insertionError = insert(.fixture(), to: sut)

        XCTAssertNil(insertionError, "Expected to insert item successfully")
    }

    // MARK: - Helpers

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
