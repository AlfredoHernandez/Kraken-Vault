//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

@testable import KrakenVault
import ComposableArchitecture
import XCTest

class PasswordGeneratorReducerTests: XCTestCase {
    func test_updatePasswordLength_updatesPasswordLength() {
        CAAssertState(
            initialValue: .fixture(characterCount: 10),
            reducer: passwordGeneratorReducer,
            environment: PasswordGeneratorEnvironment(
                copyToPasteboard: { _ in },
                generateFeedbackImpact: {},
                generatePassword: { _, _, _, _ in
                    ["P", "4", "S", "S"]
                }
            ),
            steps:
            Step(.send(.updatePasswordLength(4)) { $0.characterCount = 4 }),
            Step(.receive(.generate) { $0.characters = ["P", "4", "S", "S"] }),
            Step(.fireAndForget)
        )
    }

    func test_includeNumbers_includesNumbersAndGeneratesPassword() {
        CAAssertState(
            initialValue: .fixture(characterCount: 0, includeNumbers: false),
            reducer: passwordGeneratorReducer,
            environment: PasswordGeneratorEnvironment(copyToPasteboard: { _ in }, generateFeedbackImpact: {}, generatePassword: { _, _, _, _ in
                ["P", "4", "S", "S"]
            }),
            steps:
            Step(.send(.includeNumbers(true)) { $0.includeNumbers = true }),
            Step(.receive(.generate) { $0.characters = ["P", "4", "S", "S"] }),
            Step(.fireAndForget)
        )
    }

    func test_includeSpecialChars_includesSpecialCharsAndGeneratesPassword() {
        CAAssertState(
            initialValue: .fixture(characterCount: 0, includeSpecialChars: false),
            reducer: passwordGeneratorReducer,
            environment: PasswordGeneratorEnvironment(copyToPasteboard: { _ in }, generateFeedbackImpact: {}, generatePassword: { _, _, _, _ in
                ["P", "4", "S", "S"]
            }),
            steps:
            Step(.send(.includeSpecialChars(true)) { $0.includeSpecialChars = true }),
            Step(.receive(.generate) { $0.characters = ["P", "4", "S", "S"] }),
            Step(.fireAndForget)
        )
    }

    func test_includeUppercased_includesUppercasedCharsAndGeneratesPassword() {
        CAAssertState(
            initialValue: .fixture(characterCount: 0, includeUppercased: false),
            reducer: passwordGeneratorReducer,
            environment: PasswordGeneratorEnvironment(copyToPasteboard: { _ in }, generateFeedbackImpact: {}, generatePassword: { _, _, _, _ in
                ["P", "4", "S", "S"]
            }),
            steps:
            Step(.send(.includeUppercased(true)) { $0.includeUppercased = true }),
            Step(.receive(.generate) { $0.characters = ["P", "4", "S", "S"] }),
            Step(.fireAndForget)
        )
    }

    func test_copyPassword_copyPasswordOnPasteboardAndGeneratesFeedbackImpact() {
        var passwordsGenerated = [String]()
        var feedbackImpactCallCount = 0
        CAAssertState(
            initialValue: .fixture(characters: ["A", "N", "Y"]),
            reducer: passwordGeneratorReducer,
            environment: PasswordGeneratorEnvironment(copyToPasteboard: { passwordGenerated in
                passwordsGenerated.append(passwordGenerated.joined())
            }, generateFeedbackImpact: {
                feedbackImpactCallCount += 1
            }, generatePassword: { _, _, _, _ in
                ["P", "4", "S", "S"]
            }),
            steps:
            Step(.send(.copyPassword) { $0.characters = ["A", "N", "Y"] }),
            Step(.fireAndForget),
            Step(.fireAndForget)
        )
        XCTAssertEqual(passwordsGenerated, ["ANY"], "Expected copy password as side effect, given \(passwordsGenerated)")
        XCTAssertEqual(feedbackImpactCallCount, 1, "Expected a feedback impact as side effect, given \(feedbackImpactCallCount)")
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
