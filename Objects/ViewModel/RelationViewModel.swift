//
//  RelationViewModel.swift
//  Objects
//
//  Created by Pawel Walicki on 19/12/21.
//

import Foundation

/// The ViewModel for RelationViewController
final class RelationViewModel {
    
    private let repository = Repository()
    
    // All available object for create the relation
    private var myObjects: [MyObject] = []
    
    // Parent object
    private var parent: MyObject
    
    /// Selected object as relations
    private var selectedObjects: [MyObject] = []
    
    // Return number of object for relation.
    var numberOfRow: Int {
        return myObjects.count
    }
    
    // IndexPaths for all the object used to relation with parent object
    var indexPaths: [IndexPath] = []
    
    init(parent: MyObject) {
        self.parent = parent
    }

    /**
     Setup viewModel for ObjectCell
    - parameter indexPath: IndexPath for current object.
    - returns: ViewModel for ObjectCell
    */
    func cellViewModelBy(_ indexPath: IndexPath) -> ObjectCellViewModel {
        
        let currentObject = myObjects[indexPath.row]
        
        let objectCellViewModel = ObjectCellViewModel(myObject: currentObject)
        if hasRelationWithParent(currentObject) {
            objectCellViewModel.isSelected = true
            indexPaths.append(indexPath)
        }
        return objectCellViewModel
    }
    
    /**
     Fetch the objects
    - parameter indexPath: IndexPath for current object.
    - returns: ViewModel for RelationCell
    */
    func fetchObject() {
        if let myObjects = repository.fetchObjects() {
            self.myObjects = myObjects
        }
    }
    
    /**
     Check if the object has the relation
    - parameter object: Object to be check check.
    - returns: Bool is the object has the relation
    */
    private func hasRelationWithParent(_ object: MyObject) -> Bool {
        guard let relations = parent.relations?.allObjects as? [MyObject] else {
            return false
        }
        
        let index = relations.firstIndex(where: {$0.id == object.id})
        return index != nil
    }
    
    /**
     Save the relations
    - parameter [indexPath]: Array of IndexPaths for all the selected object for the relation
    - returns: None
    */
    func saveRelations(indexPaths: [IndexPath]?) {
        guard let indexPaths = indexPaths else {
            parent.relations = nil
            return
        }
        
        indexPaths.forEach { indexPath in
            selectedObjects.append(myObjects[indexPath.row])
        }
        
        repository.saveRelations(parent: parent, relations: selectedObjects)
    }
}
