//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import CoreData

@objc(ManagedVaultItem)
class ManagedVaultItem: NSManagedObject {
    @NSManaged var uuid: UUID
    @NSManaged var name: String
    @NSManaged var username: String
    @NSManaged var password: String
    @NSManaged var url: URL
}

extension ManagedVaultItem {
    static func all(in context: NSManagedObjectContext) throws -> [ManagedVaultItem] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ManagedVaultItem")
        return try context.fetch(fetchRequest) as! [ManagedVaultItem]
    }

    static func create(from item: VaultStoreItem, in context: NSManagedObjectContext) throws {
        let managedItem = ManagedVaultItem(context: context)
        managedItem.uuid = item.uuid
        managedItem.name = item.name
        managedItem.username = item.username
        managedItem.password = item.password
        managedItem.url = item.url
        try context.save()
    }

    static func find(_ item: VaultStoreItem, in context: NSManagedObjectContext) throws -> ManagedVaultItem? {
        let request = NSFetchRequest<ManagedVaultItem>(entityName: entity().name!)
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(ManagedVaultItem.uuid), item.uuid])
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
}
