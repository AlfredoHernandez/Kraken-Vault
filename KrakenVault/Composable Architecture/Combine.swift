//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

public func combine<Value, Action>(
    _ reducers: (inout Value, Action) -> Void...
) -> (inout Value, Action) -> Void {
    { value, action in
        for reducer in reducers {
            reducer(&value, action)
        }
    }
}
