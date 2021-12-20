//
//  MyObject+CoreDataClass.swift
//  Objects
//
//  Created by Pawel Walicki on 20/12/21.
//
//

import Foundation
import CoreData

@objc(MyObject)
public class MyObject: NSManagedObject, Codable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(objectName, forKey: .objectName)
            try container.encode(objectDescription, forKey: .objectDescription)
            try container.encode(objectType, forKey: .objectType)
        } catch {
            print("error")
        }
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
              let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: "MyObject", in: managedObjectContext)
        else {
            fatalError("decode failure")
        }

        self.init(entity: entity, insertInto: managedObjectContext)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            objectName = try values.decode(String.self, forKey: .objectName)
            objectDescription = try values.decode(String.self, forKey: .objectDescription)
            objectType = try values.decode(String.self, forKey: .objectType)
        } catch {
            print ("error")
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case objectName = "objectName"
        case objectDescription = "objectDescription"
        case objectType = "objectType"
    }
}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}
