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
}
