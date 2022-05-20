//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import KrakenVaultCore
import XCTest

final class LocalVaultLoaderTests: XCTestCase {
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
        let exp = expectation(description: "Wait for loading completion")

        sut.load { result in
            switch result {
            case let .failure(receivedError):
                XCTAssertEqual(receivedError as NSError, expectedError)
            case .success:
                XCTFail("Expected an error, but got \(result) instead")
            }
            exp.fulfill()
        }

        store.completeRetrieve(with: expectedError)
        wait(for: [exp], timeout: 1.0)
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (LocalVaultLoader, VaultStoreSpy) {
        let store = VaultStoreSpy()
        let sut = LocalVaultLoader(store: store)

        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }

    class VaultStoreSpy: VaultStore {
        enum Message {
            case retrieve
        }

        var messages = [Message]()
        var retrieveRequests = [(Result<[LocalVaultItem], Error>) -> Void]()

        func retrieve(completion: @escaping (Result<[LocalVaultItem], Error>) -> Void) {
            messages.append(.retrieve)
            retrieveRequests.append(completion)
        }

        func completeRetrieve(with error: Error, at index: Int = 0) {
            retrieveRequests[index](.failure(error))
        }
    }
}

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak!", file: file, line: line)
        }
    }
}
