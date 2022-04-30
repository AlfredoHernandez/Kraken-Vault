//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

public func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction>(
    _ reducer: @escaping (inout LocalValue, LocalAction) -> Void,
    value: WritableKeyPath<GlobalValue, LocalValue>,
    action: WritableKeyPath<GlobalAction, LocalAction?>
) -> (inout GlobalValue, GlobalAction) -> Void {
    { globalValue, globalAction in
        guard let localAction = globalAction[keyPath: action] else { return }
        reducer(&globalValue[keyPath: value], localAction)
    }
}
