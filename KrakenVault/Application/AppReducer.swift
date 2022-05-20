//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import ComposableArchitecture

let appReducer: Reducer<AppState, AppAction, AppEnvironment> = combine(
    pullback(
        passwordGeneratorReducer,
        value: \AppState.passwordGenerator,
        action: \AppAction.passwordGenerated,
        environment: { ($0.copyToPasteboard, $0.generateFeedbackImpact, $0.generatePassword) }
    ),
    pullback(vaultReducer, value: \AppState.vault, action: \AppAction.vault, environment: { $0.vaultItemsStore })
)
