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
            try context.performAndWait { [weak self] in
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ManagedVaultItem")
                let vaultItems = try self?.context.fetch(fetchRequest) as? [ManagedVaultItem]

                let localVaultItems = vaultItems.map { items in
                    items.map {
                        VaultStoreItem(uuid: $0.uuid, name: $0.name, username: $0.username, password: $0.password, url: $0.url)
                    }
                }

                completion(.success(localVaultItems ?? []))
            }
        } catch {
            completion(.failure(error))
        }
    }

    public func delete(_: VaultStoreItem, completion _: @escaping (Result<Void, Error>) -> Void) {}

    public func insert(_: VaultStoreItem, completion _: @escaping (Result<Void, Error>) -> Void) {}
}

extension NSPersistentContainer {
    static func load(name: String, model: NSManagedObjectModel, url: URL) throws -> NSPersistentContainer {
        let description = NSPersistentStoreDescription(url: url)
        let container = NSPersistentContainer(name: name, managedObjectModel: model)
        container.persistentStoreDescriptions = [description]

        var loadError: Swift.Error?
        container.loadPersistentStores { loadError = $1 }
        try loadError.map { throw $0 }

        return container
    }
}

extension NSManagedObjectModel {
    static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
        bundle
            .url(forResource: name, withExtension: "momd")
            .flatMap { NSManagedObjectModel(contentsOf: $0) }
    }
}
