//
//  Persistence.swift
//  Gremo
//
//  Created by Andy Lin on 2023/6/19.
//

import CoreData

struct PersistenceController {

    static let shared = PersistenceController()

    let container: NSPersistentCloudKitContainer

    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Item")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Gremo")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
