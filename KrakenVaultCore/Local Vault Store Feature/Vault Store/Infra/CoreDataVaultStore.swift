//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import CoreData
import Foundation

public final class CoreDataVaultStore: VaultStore {
    private static let modelName = "KrakenVaultStore"
    private static let model = NSManagedObjectModel.with(name: modelName, in: Bundle(for: CoreDataVaultStore.self))

    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext

    enum StoreError: Error {
        case modelNotFound
        case failedToLoadPersistentContainer(Error)
    }

    public init(storeURL: URL) throws {
        guard let model = CoreDataVaultStore.model else {
            throw StoreError.modelNotFound
        }

        do {
            container = try NSPersistentContainer.load(name: CoreDataVaultStore.modelName, model: model, url: storeURL)
            context = container.newBackgroundContext()
        } catch {
            throw StoreError.failedToLoadPersistentContainer(error)
        }
    }

    public func retrieve(completion: @escaping (RetrievalResult) -> Void) {
        do {
            try context.performAndWait {
                let vaultItems = try ManagedVaultItem.all(in: context)
                completion(
                    .success(vaultItems.map {
                        VaultStoreItem(uuid: $0.uuid, name: $0.name, username: $0.username, password: $0.password, url: $0.url)
                    })
                )
            }
        } catch {
            completion(.failure(error))
        }
    }

    public func delete(_: VaultStoreItem, completion _: @escaping (Result<Void, Error>) -> Void) {}

    public func insert(_ item: VaultStoreItem, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(Result {
            try ManagedVaultItem.create(from: item, in: context)
        })
    }
}
