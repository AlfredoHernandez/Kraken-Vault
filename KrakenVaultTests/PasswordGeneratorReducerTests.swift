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
