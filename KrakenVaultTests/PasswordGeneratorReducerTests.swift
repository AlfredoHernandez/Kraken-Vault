//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

@testable import KrakenVault
import ComposableArchitecture
import SwiftUI
import XCTest

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
