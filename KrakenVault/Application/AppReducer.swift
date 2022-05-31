//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import ComposableArchitecture

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    passwordGeneratorReducer.pullback(state: \AppState.passwordGeneratorState, action: /AppAction.passwordGenerated, environment: {
        (copyToPasteboard: $0.copyToPasteboard, generateFeedbackImpact: $0.generateFeedbackImpact, generatePassword: $0.generatePassword)
    }),
    vaultReducer.pullback(state: \AppState.passwordVaultState, action: /AppAction.vault, environment: {
        (vaultStore: $0.vaultItemsStore, scheduler: $0.dispatchQueueScheduler)
    }),
    createPasswordReducer.pullback(state: \AppState.createPasswordState, action: /AppAction.createPassword, environment: { $0.vaultItemsStore })
)
