//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import ComposableArchitecture

let appReducer: Reducer<AppState, AppAction> = combine(
    pullback(passwordGeneratorReducer, value: \AppState.passwordGenerator, action: \AppAction.passwordGenerated)
)
