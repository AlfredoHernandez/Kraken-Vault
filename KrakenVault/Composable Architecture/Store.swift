//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Combine
import SwiftUI

public final class Store<Value, Action>: ObservableObject {
    private let reducer: (inout Value, Action) -> Void
    @Published public private(set) var value: Value
    private var cancellable: Cancellable?

    public init(initialValue: Value, reducer: @escaping (inout Value, Action) -> Void) {
        self.reducer = reducer
        value = initialValue
    }

    public func send(_ action: Action) {
        reducer(&value, action)
    }

    public func view<LocalValue, LocalAction>(
        value toLocalValue: @escaping (Value) -> LocalValue,
        action toGlobalAction: @escaping (LocalAction) -> Action
    ) -> Store<LocalValue, LocalAction> {
        let localStore = Store<LocalValue, LocalAction>(
            initialValue: toLocalValue(value),
            reducer: { localValue, localAction in
                self.send(toGlobalAction(localAction))
                localValue = toLocalValue(self.value)
            }
        )
        localStore.cancellable = $value.sink { [weak localStore] newValue in
            localStore?.value = toLocalValue(newValue)
        }
        return localStore
    }
}
