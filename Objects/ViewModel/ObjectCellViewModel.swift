//
//  ObjectCellViewModel.swift
//  Objects
//
//  Created by Pawel Walicki on 19/12/21.
//

import Foundation

/// The viewModel for the ObjectCell
final class ObjectCellViewModel {
    
    private let myObject: MyObject
    
    var isSelected = false
    
    var objectName: String {
        "Name: \(myObject.objectName ?? "")"
    }
    
    var objectDescription: String {
        "Description: \(myObject.objectDescription ?? "")"
    }
    
    var objectType: String {
        return "Type: \(myObject.objectType ?? "")"
    }
    
    init(myObject: MyObject) {
        self.myObject = myObject
    }
}
