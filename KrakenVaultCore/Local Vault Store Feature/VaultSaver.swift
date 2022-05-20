//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

public protocol VaultSaver {
    typealias Result = Swift.Result<Void, Error>
    func save(_ item: VaultItem, completion: @escaping (VaultSaver.Result) -> Void)
}
