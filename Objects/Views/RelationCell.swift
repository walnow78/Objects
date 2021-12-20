//
//  RelationCell.swift
//  Objects
//
//  Created by Pawel Walicki on 19/12/21.
//

import UIKit

class RelationCell: UITableViewCell {

    @IBOutlet weak var relationNameLabel: UILabel!
    
    static let cellId = "RelationCell"
    
    var viewModel: RelationCellViewModel! {
        didSet {
            updateCell()
        }
    }
    
    private func updateCell() {
        relationNameLabel.text = viewModel.objectName
    }
}
