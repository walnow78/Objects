//
//  MyObject+CoreDataProperties.swift
//  Objects
//
//  Created by Pawel Walicki on 20/12/21.
//
//

import Foundation
import CoreData


extension MyObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyObject> {
        return NSFetchRequest<MyObject>(entityName: "MyObject")
    }

    @NSManaged public var objectName: String?
    @NSManaged public var objectDescription: String?
    @NSManaged public var objectType: String?
    @NSManaged public var relations: NSSet?

}

// MARK: Generated accessors for relations
extension MyObject {

    @objc(addRelationsObject:)
    @NSManaged public func addToRelations(_ value: MyObject)

    @objc(removeRelationsObject:)
    @NSManaged public func removeFromRelations(_ value: MyObject)

    @objc(addRelations:)
    @NSManaged public func addToRelations(_ values: NSSet)

    @objc(removeRelations:)
    @NSManaged public func removeFromRelations(_ values: NSSet)

}

extension MyObject : Identifiable {

}
