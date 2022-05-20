//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

public protocol VaultLoader {
    typealias Result = Swift.Result<[VaultItem], Error>
    func load(completion: @escaping (VaultLoader.Result) -> Void)
}
