//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

let appReducer: Reducer<AppState, AppAction> = combine(
    pullback(passwordGeneratorReducer, value: \AppState.passwordGenerator, action: \AppAction.passwordGenerator)
)
