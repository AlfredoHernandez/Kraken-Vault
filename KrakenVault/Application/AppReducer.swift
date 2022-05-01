//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

let appReducer: (inout AppState, AppAction) -> Void = combine(
    pullback(passwordGeneratorReducer, value: \AppState.passwordGenerator, action: \AppAction.passwordGenerator)
)
