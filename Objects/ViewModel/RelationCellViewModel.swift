//
//  RelationCellViewModel.swift
//  Objects
//
//  Created by Pawel Walicki on 19/12/21.
//

import Foundation

/// ViewModel for RelationCell
final class RelationCellViewModel {
    
    private let relation: MyObject
      
    var objectName: String? {
        relation.objectName
    }
    
    init(relation: MyObject, parent: MyObject?) {
        self.relation = relation
    }
    
}
