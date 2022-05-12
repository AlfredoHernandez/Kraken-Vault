//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

@testable import KrakenVault
import ComposableArchitecture
import SwiftUI
import XCTest

struct Step<Value: Equatable, Action> {
    enum StepType {
        case send(Action, (inout Value) -> Void)
        case receive(Action, (inout Value) -> Void)
        case fireAndForget
    }

    let type: StepType
    let file: StaticString
    let line: UInt

    init(_ type: StepType, file: StaticString = #filePath, line: UInt = #line) {
        self.type = type
        self.file = file
        self.line = line
    }
}

func CAAssertState<Value: Equatable, Action: Equatable>(
    initialValue: Value,
    reducer: Reducer<Value, Action>,
    steps: Step<Value, Action>...,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    var state = initialValue
    var effects = [Effect<Action>]()
    steps.forEach { step in
        var expected = state
        switch step.type {
        case let .send(action, update):
            if !effects.isEmpty {
                XCTFail("Action sent before handling \(effects.count) pending effect(s).", file: step.file, line: step.line)
            }
            effects.append(contentsOf: reducer(&state, action))
            update(&expected)
            XCTAssertEqual(state, expected, file: step.file, line: step.line)
        case let .receive(expectedAction, update):
            guard !effects.isEmpty else {
                XCTFail("No pending effects to receive from", file: step.file, line: step.line)
                break
            }
            let expectation = XCTestExpectation(description: "Wait for receiveCompletion")
            var action: Action!
            let effect = effects.removeFirst()
            _ = effect.sink(receiveCompletion: { _ in
                expectation.fulfill()
            }, receiveValue: { action = $0 })
            if XCTWaiter.wait(for: [expectation], timeout: 1.0) != .completed {
                XCTFail("Timed out waiting for the effect to complete", file: step.file, line: step.line)
            }
            XCTAssertEqual(action, expectedAction, file: step.file, line: step.line)
            effects.append(contentsOf: reducer(&state, action))
            update(&expected)
            XCTAssertEqual(state, expected, file: step.file, line: step.line)
        case .fireAndForget:
            guard !effects.isEmpty else {
                XCTFail("No pending effects to run", file: step.file, line: step.line)
                break
            }
            let effect = effects.removeFirst()
            let receivedCompletion = XCTestExpectation(description: "receivedCompletion")
            _ = effect.sink(
                receiveCompletion: { _ in
                    receivedCompletion.fulfill()
                },
                receiveValue: { _ in XCTFail() }
            )
            if XCTWaiter.wait(for: [receivedCompletion], timeout: 1.0) != .completed {
                XCTFail("Timed out waiting for the effect to complete", file: step.file, line: step.line)
            }
        }
    }

    if !effects.isEmpty {
        XCTFail("Assertion failed to handle: There is/are \(effects.count) pending effect(s).", file: file, line: line)
    }
}

class PasswordGeneratorReducerTests: XCTestCase {
    func test_updatePasswordLength_updatesPasswordLength() {
        CAAssertState(
            initialValue: .fixture(characterCount: 10),
            reducer: passwordGeneratorReducer,
            steps: Step(.send(.updatePasswordLength(16)) { $0.characterCount = 16 })
        )
    }

    func test_includeNumbers_includesNumbersAndGeneratesPassword() {
        CAAssertState(
            initialValue: .fixture(characterCount: 0, includeNumbers: false),
            reducer: passwordGeneratorReducer,
            steps:
            Step(.send(.includeNumbers(true)) { $0.includeNumbers = true }),
            Step(.receive(.generate) { $0.characters = [] }),
            Step(.fireAndForget)
        )
    }

    func test_includeSpecialChars_includesSpecialCharsAndGeneratesPassword() {
        CAAssertState(
            initialValue: .fixture(characterCount: 0, includeSpecialChars: false),
            reducer: passwordGeneratorReducer,
            steps:
            Step(.send(.includeSpecialChars(true)) { $0.includeSpecialChars = true }),
            Step(.receive(.generate) { $0.characters = [] }),
            Step(.fireAndForget)
        )
    }

    func test_includeUppercased_includesUppercasedCharsAndGeneratesPassword() {
        CAAssertState(
            initialValue: .fixture(characterCount: 0, includeUppercased: false),
            reducer: passwordGeneratorReducer,
            steps:
            Step(.send(.includeUppercased(true)) { $0.includeUppercased = true }),
            Step(.receive(.generate) { $0.characters = [] }),
            Step(.fireAndForget)
        )
    }

    func test_copyPassword_copyPasswordOnPasteboardAndGeneratesFeedbackImpact() {
        CAAssertState(
            initialValue: .fixture(characters: ["A", "N", "Y"]),
            reducer: passwordGeneratorReducer,
            steps:
            Step(.send(.copyPassword) { $0.characters = ["A", "N", "Y"] }),
            Step(.fireAndForget),
            Step(.fireAndForget)
        )
        XCTAssertEqual(UIPasteboard.general.string, "ANY")
    }
}

extension PasswordGeneratorState {
    static func fixture(
        characters: [String] = [],
        characterCount: Double = 0,
        includeSpecialChars: Bool = true,
        includeUppercased: Bool = true,
        includeNumbers: Bool = true
    ) -> PasswordGeneratorState {
        PasswordGeneratorState(
            characters: characters,
            characterCount: characterCount,
            includeSpecialChars: includeSpecialChars,
            includeUppercased: includeUppercased,
            includeNumbers: includeNumbers
        )
    }
}
