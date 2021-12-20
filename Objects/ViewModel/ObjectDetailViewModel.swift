//
//  ObjectDetailViewModel.swift
//  Objects
//
//  Created by Pawel Walicki on 19/12/21.
//

import Foundation

// The ViewModel for the ObjectDetailViewController
final class ObjectDetailViewModel {
    
    private let myObject: MyObject?
    private let repository = Repository()
    
    var objectName: String? { myObject?.objectName }
    var objectDescription: String? { myObject?.objectDescription }
    var objectType: String? { myObject?.objectType }
    
    /// Return the number of relation for current object
    var numberOfRow: Int {
        return myObject?.relations?.count ?? 0
    }

    init(myObject: MyObject?) {
        self.myObject = myObject
    }
    
    /**
     Setup viewModel for relation cell
    - parameter indexPath: IndexPath for current object.
    - returns: ViewModel for RelationCell
    */
    func relationCellViewModelBy(_ indexPath: IndexPath) -> RelationCellViewModel? {
        guard let relations = myObject?.relations?.allObjects as? [MyObject] else { return nil }
        
        let currentObject = relations[indexPath.row]
        return RelationCellViewModel(relation: currentObject, parent: myObject)
    }
    
    /**
     Setup viewModel for relation
    - parameter indexPath: IndexPath for current object.
    - returns: ViewModel for relations
    */
    func relationViewModel() -> RelationViewModel? {
        guard let myObject = myObject else { return nil }
        
        return RelationViewModel(parent: myObject)
    }
    
    /**
     Setup viewModel for detail view
    - parameter objectName: The name of the object
    - parameter objectDescription: The description of the object
    - parameter objectType: The type of the object
    - returns: None
    */
    func saveObject(objectName: String?, objectDescription: String?, objectType: String?) {
        guard let objectName = objectName,
              let objectDescription = objectDescription,
              let objectType = objectType else {
                  return
              }
        
        repository.saveObject(objectName: objectName,
                              objectDescription: objectDescription,
                              objectType: objectType,
                              currentObject: myObject)
    }
}
