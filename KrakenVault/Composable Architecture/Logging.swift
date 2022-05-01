//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

func logging<Value, Action>(
    _ reducer: @escaping Reducer<Value, Action>
) -> Reducer<Value, Action> {
    { value, action in
        let effects = reducer(&value, action)
        let value = value
        return [
            {
                print("==> Value: \(value)")
                print("==> Action: \(action)")
                return nil
            },
        ] + effects
    }
}
