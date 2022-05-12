//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

@testable import KrakenVault
import ComposableArchitecture
import SwiftUI
import XCTest

enum StepType {
    case send
    case receive
}

struct Step<Value: Equatable, Action> {
    let type: StepType
    let action: Action
    let update: (inout Value) -> Void
    let file: StaticString
    let line: UInt

    init(_ type: StepType, _ action: Action, _ update: @escaping (inout Value) -> Void, file: StaticString = #filePath, line: UInt = #line) {
        self.type = type
        self.action = action
        self.update = update
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
        case .send:
            if !effects.isEmpty {
                XCTFail("Action sent before handling \(effects.count) pending effect(s).", file: step.file, line: step.line)
            }
            effects.append(contentsOf: reducer(&state, step.action))
        case .receive:
            guard !effects.isEmpty else {
                XCTFail("No pending effects to receive from", file: step.file, line: step.line)
                break
            }
            let expectation = XCTestExpectation(description: "Wait for receiveCompletion")
            var action: Action?
            let effect = effects.removeFirst()
            _ = effect.sink(receiveCompletion: { _ in
                expectation.fulfill()
            }, receiveValue: { action = $0 })
            if XCTWaiter.wait(for: [expectation], timeout: 1) != .completed {
                XCTFail("Timed out waiting for the effect to complete", file: step.file, line: step.line)
            }
            XCTAssertEqual(action, step.action, file: step.file, line: step.line)
            effects.append(contentsOf: reducer(&state, step.action))
        }
        step.update(&expected)
        XCTAssertEqual(state, expected, file: step.file, line: step.line)
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
            steps: Step(.send, .updatePasswordLength(16)) { $0.characterCount = 16 }
        )
    }

    func test_includeNumbers_includesNumbersAndGeneratesPassword() {
        CAAssertState(
            initialValue: .fixture(characterCount: 0, includeNumbers: false),
            reducer: passwordGeneratorReducer,
            steps:
            Step(.send, .includeNumbers(true)) { $0.includeNumbers = true },
            Step(.receive, .generate) { $0.characters = [] }
        )
    }

    func test_includeSpecialChars_includesSpecialCharsAndGeneratesPassword() {
        CAAssertState(
            initialValue: .fixture(characterCount: 0, includeSpecialChars: false),
            reducer: passwordGeneratorReducer,
            steps:
            Step(.send, .includeSpecialChars(true)) { $0.includeSpecialChars = true },
            Step(.receive, .generate) { $0.characters = [] }
        )
    }

    func test_includeUppercased_includesUppercasedCharsAndGeneratesPassword() {
        CAAssertState(
            initialValue: .fixture(characterCount: 0, includeUppercased: false),
            reducer: passwordGeneratorReducer,
            steps:
            Step(.send, .includeUppercased(true)) { $0.includeUppercased = true },
            Step(.receive, .generate) { $0.characters = [] }
        )
    }

    func test_copyPassword_copyPasswordOnPasteboardAndGeneratesFeedbackImpact() {
//        var state: PasswordGeneratorState = .fixture(characters: ["A", "N", "Y"])
//
//        let effects = passwordGeneratorReducer(state: &state, action: .copyPassword)
//        XCTAssertEqual(effects.count, 2, "Expected to generate 2 side effects")
//
//        _ = effects[0].sink { _ in
//            XCTFail("Expected to no produce more actions")
//        }
//        XCTAssertEqual(UIPasteboard.general.string, "ANY")

//        CAAssertState(
//            initialValue: .fixture(characters: ["A", "N", "Y"]),
//            reducer: passwordGeneratorReducer,
//            steps:
//            Step(.send, .copyPassword) { $0.characters = ["A", "N", "Y"] }
//        )
//        XCTAssertEqual(UIPasteboard.general.string, "ANY")

//        _ = effects[1].sink { _ in
//            XCTFail("Expected to no produce more actions")
//        }
    }

//    func test_generate_generatesPassword() {
//        let characterCount: Double = 16
//        var state: PasswordGeneratorState = .fixture(characters: [], characterCount: characterCount)
//
//        let effects = passwordGeneratorReducer(state: &state, action: .generate)
//
//        XCTAssertGreaterThan(state.characters.count, 0, "Expected to generate a password with \(Int(characterCount)) chars")
//        XCTAssertEqual(effects.count, 1)
//
//        _ = effects[0].sink { _ in
//            XCTFail("Expected to no produce more actions")
//        }
//    }
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
