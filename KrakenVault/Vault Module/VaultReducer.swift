//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import ComposableArchitecture
import Foundation
import KrakenVaultCore
import PowerfulCombine

typealias VaultEnvironment = (loader: LocalVaultLoader, scheduler: AnyDispatchQueueScheduler)

func vaultReducer(state: inout PasswordVaultState, action: PasswordVaultAction, environment: VaultEnvironment) -> [Effect<PasswordVaultAction>] {
    switch action {
    case .loadVault:
        return [
            environment.loader.publisher()
                .receive(on: environment.scheduler)
                .replaceError(with: [])
                .eraseToEffect()
                .flatMap { items in
                    Effect<PasswordVaultAction>.sync {
                        .loadedVault(items)
                    }
                }.eraseToEffect(),
        ]
    case let .loadedVault(items):
        state.vaultItems = items
        return []
    }
}
