//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

let appReducer = pullback(passwordGeneratedReducer, value: \AppState.passwordGenerated, action: \AppAction.passwordGenerated)
