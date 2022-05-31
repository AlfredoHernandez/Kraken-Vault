//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import ComposableArchitecture
import KrakenVaultCore
import PowerfulCombine

typealias VaultEnvironment = (vaultStore: LocalVaultLoader, scheduler: AnyDispatchQueueScheduler)

let krakenVaultReducer = Reducer<KrakenVaultState, KrakenVaultAction, VaultEnvironment> { state, action, environment in
    switch action {
    case .loadVault:
        return environment.vaultStore
            .loadPublisher()
            .receive(on: environment.scheduler)
            .replaceError(with: [])
            .flatMap { Effect(value: .loadedVault($0)) }
            .eraseToEffect()
    case let .loadedVault(items):
        state.vaultItems = items
        return .none
    case let .save(item):
        return environment.vaultStore
            .savePublisher(item: item)
            .receive(on: environment.scheduler)
            .replaceError(with: ())
            .flatMap { _ in Effect(value: .loadVault) }
            .receive(on: environment.scheduler)
            .eraseToEffect()
    case let .delete(indexSet):
        let item = state.vaultItems.remove(at: indexSet.first ?? 0)
        return environment.vaultStore
            .deletePublisher(item: item)
            .receive(on: environment.scheduler)
            .replaceError(with: ())
            .flatMap { _ in Effect(value: .loadVault) }
            .receive(on: environment.scheduler)
            .eraseToEffect()
    }
}
