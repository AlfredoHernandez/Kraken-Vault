//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Combine
import KrakenVaultCore

extension LocalVaultLoader {
    func publisher() -> AnyPublisher<[VaultItem], Error> {
        Deferred {
            Future { [weak self] completion in
                self?.load(completion: completion)
            }
        }.eraseToAnyPublisher()
    }
}
