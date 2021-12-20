//
//  ObjectCell.swift
//  Objects
//
//  Created by Pawel Walicki on 19/12/21.
//

import UIKit

class ObjectCell: UITableViewCell {
    
    @IBOutlet weak var objectName: UILabel!
    @IBOutlet weak var objectDescription: UILabel!
    @IBOutlet weak var objectType: UILabel!
    
    static let cellId = "ObjectCell"
    
    var viewModel: ObjectCellViewModel! {
        didSet {
            updateCell()
        }
    }
    
    private func updateCell() {
        objectName.text = viewModel.objectName
        objectDescription.text = viewModel.objectDescription
        objectType.text = viewModel.objectType
        
        if viewModel.isSelected {
            accessoryType = .checkmark
        } else {
            accessoryType = .none
        }
    }
}
