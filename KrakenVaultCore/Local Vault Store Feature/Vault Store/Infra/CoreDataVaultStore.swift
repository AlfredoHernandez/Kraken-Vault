//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import CoreData
import Foundation

public final class CoreDataVaultStore {
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

    func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = context
        context.perform { action(context) }
    }
}

extension CoreDataVaultStore: VaultStore {
    public enum KrakenVaultError: Error, Equatable {
        case itemNotFound(String)
    }

    public func retrieve(completion: @escaping (RetrievalResult) -> Void) {
        perform { context in
            completion(Result {
                try ManagedVaultItem.all(in: context).map {
                    VaultStoreItem(uuid: $0.uuid, name: $0.name, username: $0.username, password: $0.password, url: $0.url)
                }
            })
        }
    }

    public func delete(_ item: VaultStoreItem, completion: @escaping (DeletionResult) -> Void) {
        perform { context in
            do {
                guard let toDelete = try ManagedVaultItem.find(item, in: context) else {
                    return completion(.failure(KrakenVaultError.itemNotFound(item.uuid.uuidString)))
                }
                context.delete(toDelete)
                try context.save()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }

    public func insert(_ item: VaultStoreItem, completion: @escaping (InsertionResult) -> Void) {
        perform { context in
            completion(Result { try ManagedVaultItem.create(from: item, in: context) })
        }
    }
}
