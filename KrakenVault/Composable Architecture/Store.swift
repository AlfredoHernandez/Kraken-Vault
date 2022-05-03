//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Combine
import SwiftUI

public typealias Reducer<Value, Action> = (inout Value, Action) -> [Effect<Action>]

public struct Effect<A> {
    public let run: (@escaping (A) -> Void) -> Void

    public init(run: @escaping (@escaping (A) -> Void) -> Void) {
        self.run = run
    }

    public func map<B>(_ f: @escaping (A) -> B) -> Effect<B> {
        Effect<B> { callback in
            self.run { a in callback(f(a)) }
        }
    }
}

public final class Store<Value, Action>: ObservableObject {
    private let reducer: Reducer<Value, Action>
    @Published public private(set) var value: Value
    private var cancellable: Cancellable?

    public init(initialValue: Value, reducer: @escaping Reducer<Value, Action>) {
        self.reducer = reducer
        value = initialValue
    }

    public func send(_ action: Action) {
        let effects = reducer(&value, action)
        effects.forEach { effect in
            effect.run(self.send(_:))
        }
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
                return []
            }
        )
        localStore.cancellable = $value.sink { [weak localStore] newValue in
            localStore?.value = toLocalValue(newValue)
        }
        return localStore
    }
}
