//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import ComposableArchitecture
import Foundation

typealias PasswordGeneratorEnvironment = (
    copyToPasteboard: ([String]) -> Void,
    generateFeedbackImpact: () -> Void,
    generatePassword: (_ length: Int, _ specialCharacters: Bool, _ uppercase: Bool, _ numbers: Bool) -> [String]
)

func passwordGeneratorReducer(
    state: inout PasswordGeneratorState,
    action: PasswordGeneratorAction,
    environment: PasswordGeneratorEnvironment
) -> [Effect<PasswordGeneratorAction>] {
    switch action {
    case .generate:
        state.characters = environment.generatePassword(
            Int(state.characterCount),
            state.includeSpecialChars,
            state.includeUppercased,
            state.includeNumbers
        )
        return [generateHapticEffect(environment.generateFeedbackImpact)]
    case let .includeNumbers(withNumbers):
        state.includeNumbers = withNumbers
        return [generatePasswordEffect()]
    case let .includeSpecialChars(withSpecialChars):
        state.includeSpecialChars = withSpecialChars
        return [generatePasswordEffect()]
    case let .includeUppercased(withUppercased):
        state.includeUppercased = withUppercased
        return [generatePasswordEffect()]
    case let .updatePasswordLength(length):
        state.characterCount = length
        return [generatePasswordEffect()]
    case .copyPassword:
        return [
            copyPasswordInPasteboardEffect(
                passwordGenerated: state.characters,
                copyToPasteboard: environment.copyToPasteboard
            ),
            generateHapticEffect(environment.generateFeedbackImpact),
        ]
    }
}

private func copyPasswordInPasteboardEffect(
    passwordGenerated: [String],
    copyToPasteboard: @escaping ([String]) -> Void
) -> Effect<PasswordGeneratorAction> {
    .fireAndForget { copyToPasteboard(passwordGenerated) }
}

private func generateHapticEffect(_ impactGenerator: @escaping () -> Void) -> Effect<PasswordGeneratorAction> {
    .fireAndForget(work: impactGenerator)
}

private func generatePasswordEffect() -> Effect<PasswordGeneratorAction> {
    .sync { .generate }
}
