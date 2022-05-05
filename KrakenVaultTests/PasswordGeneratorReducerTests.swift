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
