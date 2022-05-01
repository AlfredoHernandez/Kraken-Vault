//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

func logging<Value, Action>(
    _ reducer: @escaping Reducer<Value, Action>
) -> Reducer<Value, Action> {
    { value, action in
        let effect = reducer(&value, action)
        let value = value
        return {
            print("==> Value: \(value)")
            print("==> Action: \(action)")
            effect()
        }
    }
}
