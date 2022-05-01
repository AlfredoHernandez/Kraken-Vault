//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

public func combine<Value, Action>(
    _ reducers: Reducer<Value, Action>...
) -> Reducer<Value, Action> {
    { value, action in
        let effects = reducers.map { $0(&value, action) }
        return { effects.forEach { $0() } }
    }
}
