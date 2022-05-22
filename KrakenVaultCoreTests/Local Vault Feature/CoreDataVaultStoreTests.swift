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

    func test_insert_deliversNoErrorOnEmptyStore() throws {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try CoreDataVaultStore(storeURL: storeURL)
        let exp = expectation(description: "Wait for store insertion")

        sut.insert(.fixture(uuid: .fake, name: "Any", password: "any-password", url: URL(string: "https://any-url.com")!)) { result in
            switch result {
            case .success:
                break
            case let .failure(error):
                XCTFail("Expected no error on empty store, got \(error)")
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)

        expect(sut, toRetrieve: .success([
            .fixture(uuid: .fake, name: "Any", password: "any-password", url: URL(string: "https://any-url.com")!),
        ]))
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
}
