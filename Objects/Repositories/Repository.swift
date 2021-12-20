//
//  Repository.swift
//  Objects
//
//  Created by Pawel Walicki on 19/12/21.
//

import Foundation
import CoreData

/// Repository handling persistent store.
final class Repository {
    static var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "Objects")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = Repository.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    /**
     Fetch the objects from persistent store
    - parameter filter: Filter the objects by name.
    - returns: Array with the objects
    */
    func fetchObjects(filter: String? = nil) -> [MyObject]? {
        let context = Repository.persistentContainer.viewContext
        let request = MyObject.fetchRequest()
    
        if let filter = filter {
            request.predicate = NSPredicate(format: "objectName CONTAINS[cd] %@", filter)
        }
        
        
        request.sortDescriptors = [NSSortDescriptor(key: "objectName", ascending: true)]
        do {
            return try context.fetch(request)
        } catch let error {
            print("error: \(error.localizedDescription)")
            return nil
        }
    }
    
    /**
     Fetch the relation from an object
    - parameter object: Parent object.
    - returns: Array with objects that has the relation with the object
    */
    func fetchRelations(object: MyObject) -> [MyObject]? {
        guard let objects = object.relations?.allObjects,
              let relations = objects as? [MyObject] else {
            return nil
        }
        
        return relations
    }
    
    /**
     Save or modifiy the object  on the persistent store i
    - parameter objectName: The object name.
    - parameter objectDescription: The object description.
    - parameter objectType: The object type.
    - parameter currentObject: Object to be modified.
    - returns: None
    */
    func saveObject(objectName: String,
                    objectDescription: String,
                    objectType: String,
                    currentObject: MyObject?) {
        
        let myObject: MyObject
        
        if let currentObject = currentObject {
            myObject = currentObject
        } else {
            let context = Repository.persistentContainer.viewContext
            myObject = MyObject(context: context)
        }
        
        myObject.objectName = objectName
        myObject.objectDescription = objectDescription
        myObject.objectType = objectType
        saveContext()
    }
    
    /**
     Saves changes to the persistent store if the context has uncommitted changes.

    - parameter parent: The parent object that will contain the relations.
    - parameter relation: Array with the relations.
    - returns: None
     # Notes: #
     Before save the relations, the old relations will be deleted
    */
    func saveRelations(parent: MyObject,
                       relations: [MyObject]?) {
        
        parent.relations = nil
        
        guard let relations = relations else {
            saveContext()
            return
        }
        
        relations.forEach { relation in
            parent.addToRelations(relation)
        }
        
        saveContext()
    }
    
    /**
     Delete the object from persistent store.
    - parameter object: Object to delete
    - returns: None
    */
    func deleteObject(object: MyObject) {
        Repository.persistentContainer.viewContext.delete(object)
        saveContext()
    }
}
