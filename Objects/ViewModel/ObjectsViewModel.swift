//
//  ObjectsViewModel.swift
//  Objects
//
//  Created by Pawel Walicki on 19/12/21.
//

import Foundation

/// The ViewModel for the ObjectsViewController
final class ObjectsViewModel {
    
    private let repository = Repository()
    
    private var myObjects: [MyObject] = []
    
    var numberOfRow: Int {
        return myObjects.count
    }
    
    /**
     Setup viewModel for the object cell
    - parameter indexPath: IndexPath for current object.
    - returns: ViewModel for ObjectCell
    */
    func cellViewModelBy(_ indexPath: IndexPath) -> ObjectCellViewModel {
        let currentObject = myObjects[indexPath.row]
        return ObjectCellViewModel(myObject: currentObject)
    }
    
    /**
     Setup viewModel for detail view
    - parameter indexPath: IndexPath for current object.
    - returns: ViewModel for object detail view
    */
    func detailViewModelBy(_ indexPath: IndexPath?) -> ObjectDetailViewModel {
        
        guard let indexPath = indexPath else {
            return ObjectDetailViewModel(myObject: nil)
        }
        
        let currentObject = myObjects[indexPath.row]
        
        return ObjectDetailViewModel(myObject: currentObject)
    }
    
    /**
     Fetch all the objects
    - parameter filter: Filter the objects by objectName.
    - returns: None
    */
    func fetchObject(filter: String? = nil) {
        if let myObjects = repository.fetchObjects(filter: filter) {
            self.myObjects = myObjects
        }
    }
    
    /**
     Delete object by IndexPath
    - parameter indexPath: IndexPath for  object to be deleted.
    - returns: None
    */
    func deleteObjectBy(_ indexPath: IndexPath) {
        let currentObject = myObjects[indexPath.row]
        myObjects.remove(at: indexPath.row)
        repository.deleteObject(object: currentObject)
    }
}
