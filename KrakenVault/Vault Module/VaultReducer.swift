//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import ComposableArchitecture
import Foundation
import KrakenVaultCore
import PowerfulCombine

typealias VaultEnvironment = (vaultStore: LocalVaultLoader, scheduler: AnyDispatchQueueScheduler)

let vaultReducer = Reducer<PasswordVaultState, PasswordVaultAction, VaultEnvironment> { state, action, environment in
    switch action {
    case .loadVault:
        return environment.vaultStore
            .loadPublisher()
            .receive(on: environment.scheduler)
            .replaceError(with: [])
            .flatMap { items in
                Effect(value: .loadedVault(items))
            }.eraseToEffect()
    case let .loadedVault(items):
        state.vaultItems = items
        return .none
    case let .save(item):
        return environment.vaultStore
            .savePublisher(item: item)
            .replaceError(with: ())
            .flatMap { _ in
                Effect(value: .loadVault)
            }
            .receive(on: environment.scheduler)
            .eraseToEffect()
    case let .delete(indexSet):
        let item = state.vaultItems.remove(at: indexSet.first ?? 0)
        return environment.vaultStore
            .deletePublisher(item: item)
            .replaceError(with: ())
            .flatMap { _ in
                Effect(value: .loadVault)
            }
            .receive(on: environment.scheduler)
            .eraseToEffect()
    }
}

// func vaultReducer(state: inout PasswordVaultState, action: PasswordVaultAction, environment: VaultEnvironment) -> [Effect<PasswordVaultAction>] {
//    switch action {
//    case .loadVault:
//        return [
//            environment.vaultStore
//                .loadPublisher()
//                .receive(on: environment.scheduler)
//                .replaceError(with: [])
//                .flatMap { items in
//                    Effect<PasswordVaultAction>.sync {
//                        .loadedVault(items)
//                    }
//                }.eraseToEffect(),
//        ]
//    case let .loadedVault(items):
//        state.vaultItems = items
//        return []
//    case let .save(item):
//        return [
//            environment.vaultStore
//                .savePublisher(item: item)
//                .replaceError(with: ())
//                .flatMap { _ in
//                    Effect<PasswordVaultAction>.sync { .loadVault }
//                }
//                .receive(on: environment.scheduler)
//                .eraseToEffect(),
//        ]
//    case let .delete(indexSet):
//        let item = state.vaultItems.remove(at: indexSet.first ?? 0)
//        return [
//            environment.vaultStore
//                .deletePublisher(item: item)
//                .replaceError(with: ())
//                .flatMap { _ in
//                    Effect<PasswordVaultAction>.sync { .loadVault }
//                }
//                .receive(on: environment.scheduler)
//                .eraseToEffect(),
//        ]
//    }
// }
