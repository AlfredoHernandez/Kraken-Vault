//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import ComposableArchitecture

typealias PasswordGeneratorEnvironment = (
    copyToPasteboard: ([String]) -> Void,
    generateFeedbackImpact: () -> Void,
    generatePassword: (_ length: Int, _ specialCharacters: Bool, _ uppercase: Bool, _ numbers: Bool) -> [String]
)

private func copyPasswordInPasteboardEffect(
    passwordGenerated: [String],
    copyToPasteboard: @escaping ([String]) -> Void
) -> Effect<PasswordGeneratorAction, Never> {
    .fireAndForget { copyToPasteboard(passwordGenerated) }
}

let passwordGeneratorReducer = Reducer<PasswordGeneratorState, PasswordGeneratorAction, PasswordGeneratorEnvironment> { state, action, environment in
    switch action {
    case .generate:
        state.characters = environment.generatePassword(
            Int(state.characterCount),
            state.includeSpecialChars,
            state.includeUppercased,
            state.includeNumbers
        )
        return Effect.fireAndForget { generateFeedbackImpact() }
    case let .includeNumbers(withNumbers):
        state.includeNumbers = withNumbers
        return Effect(value: .generate)
    case let .includeSpecialChars(withSpecialChars):
        state.includeSpecialChars = withSpecialChars
        return Effect(value: .generate)
    case let .includeUppercased(withUppercased):
        state.includeUppercased = withUppercased
        return Effect(value: .generate)
    case let .updatePasswordLength(length):
        state.characterCount = length
        return Effect(value: .generate)
    case .copyPassword:
        return copyPasswordInPasteboardEffect(
            passwordGenerated: state.characters,
            copyToPasteboard: environment.copyToPasteboard
        )
    }
}
