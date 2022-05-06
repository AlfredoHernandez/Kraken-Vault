//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

@testable import KrakenVault
import XCTest

class PasswordGeneratorReducerTests: XCTestCase {
    func test_updatePasswordLength_updatesPasswordLength() {
        var state: PasswordGeneratorState = .fixture(characterCount: 10)

        let effects = passwordGeneratorReducer(state: &state, action: .updatePasswordLength(16))

        XCTAssertEqual(state, .fixture(characterCount: 16))
        XCTAssertTrue(effects.isEmpty, "Expected no side effects")
    }

    func test_includeNumbers_includesNumbersOnPasswordGeneration() {
        var state: PasswordGeneratorState = .fixture(includeNumbers: false)

        _ = passwordGeneratorReducer(state: &state, action: .includeNumbers(true))

        XCTAssertEqual(state, .fixture(includeNumbers: true))
    }

    func test_includeNumbers_generatesPasswordAsSideEffect() {
        var state: PasswordGeneratorState = .fixture()

        let effects = passwordGeneratorReducer(state: &state, action: .includeNumbers(true))

        _ = effects.last?.sink { action in
            XCTAssertEqual(action, .generate, "Expected to `generate` password")
        }
    }

    func test_includeSpecialChars_includesSpecialCharsOnPasswordGeneration() {
        var state: PasswordGeneratorState = .fixture(includeSpecialChars: false)

        _ = passwordGeneratorReducer(state: &state, action: .includeSpecialChars(true))

        XCTAssertEqual(state, .fixture(includeSpecialChars: true))
    }

    func test_includeSpecialChars_generatesPasswordAsSideEffect() {
        var state: PasswordGeneratorState = .fixture()

        let effects = passwordGeneratorReducer(state: &state, action: .includeSpecialChars(true))

        _ = effects.last?.sink { action in
            XCTAssertEqual(action, .generate, "Expected to `generate` password")
        }
    }

    func test_includeUppercased_includesUppercasedCharsOnPasswordGeneration() {
        var state: PasswordGeneratorState = .fixture(includeUppercased: true)

        _ = passwordGeneratorReducer(state: &state, action: .includeUppercased(false))

        XCTAssertEqual(state, .fixture(includeUppercased: false))
    }

    func test_includeUppercased_generatesPasswordAsSideEffect() {
        var state: PasswordGeneratorState = .fixture()

        let effects = passwordGeneratorReducer(state: &state, action: .includeUppercased(true))

        _ = effects.last?.sink { action in
            XCTAssertEqual(action, .generate, "Expected to `generate` password")
        }
    }

    func test_copyPassword_copyPasswordOnPasteboardAndGeneratesFeedbackImpact() {
        var state: PasswordGeneratorState = .fixture(characters: ["A", "N", "Y"])

        let effects = passwordGeneratorReducer(state: &state, action: .copyPassword)
        XCTAssertEqual(effects.count, 2, "Expected to generate 2 side effects")

        _ = effects[0].sink { _ in
            XCTFail("Expected to no produce more actions")
        }
        XCTAssertEqual(UIPasteboard.general.string, "ANY")

        _ = effects[1].sink { _ in
            XCTFail("Expected to no produce more actions")
        }
    }

    func test_generate_generatesPassword() {
        let characterCount: Double = 16
        var state: PasswordGeneratorState = .fixture(characters: [], characterCount: characterCount)

        let effects = passwordGeneratorReducer(state: &state, action: .generate)

        XCTAssertGreaterThan(state.characters.count, 0, "Expected to generate a password with \(Int(characterCount)) chars")
        XCTAssertEqual(effects.count, 1)

        _ = effects[0].sink { _ in
            XCTFail("Expected to no produce more actions")
        }
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
