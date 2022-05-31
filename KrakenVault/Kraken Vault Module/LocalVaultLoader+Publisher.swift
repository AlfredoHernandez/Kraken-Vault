//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Combine
import KrakenVaultCore

extension LocalVaultLoader {
    func loadPublisher() -> AnyPublisher<[VaultItem], Error> {
        Deferred {
            Future { [weak self] completion in
                self?.load(completion: completion)
            }
        }.eraseToAnyPublisher()
    }
}

extension LocalVaultLoader {
    func savePublisher(item: VaultItem) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { [weak self] completion in
                self?.save(item, completion: completion)
            }
        }.eraseToAnyPublisher()
    }
}

extension LocalVaultLoader {
    func deletePublisher(item: VaultItem) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { [weak self] completion in
                self?.delete(item, completion: completion)
            }
        }.eraseToAnyPublisher()
    }
}
