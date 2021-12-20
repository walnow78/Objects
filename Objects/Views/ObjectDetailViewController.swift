//
//  ObjectDetailViewController.swift
//  Objects
//
//  Created by Pawel Walicki on 19/12/21.
//

import UIKit

protocol ObjectDetailViewControllerDelegate: AnyObject {
    func refreshContent()
}

final class ObjectDetailViewController: UIViewController {

    @IBOutlet weak var objectNameLabel: UILabel! {
        didSet {
            objectNameLabel.text = "Name"
        }
    }
    
    @IBOutlet weak var objectNameText: UITextField!
    
    @IBOutlet weak var objectDescriptionLabel: UILabel! {
        didSet {
            objectDescriptionLabel.text = "Description"
        }
    }
    
    @IBOutlet weak var addRelationButton: UIButton! {
        didSet {
            addRelationButton.setTitle("Relations", for: .normal)
        }
    }

    @IBOutlet weak var objectDescriptionText: UITextField!
    
    @IBOutlet weak var objectTypeLabel: UILabel! {
        didSet {
            objectTypeLabel.text = "Type"
        }
    }
    
    @IBOutlet weak var objectTypeText: UITextField!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 30
            tableView.allowsSelection = false
            tableView.register(UINib(nibName: RelationCell.cellId, bundle: nil), forCellReuseIdentifier: RelationCell.cellId)
        }
    }
    
    weak var delegate: ObjectDetailViewControllerDelegate?
    
    var viewModel: ObjectDetailViewModel
    
    // MARK: Lifecycle
    init(viewModel: ObjectDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        objectNameText.text = viewModel.objectName
        objectDescriptionText.text = viewModel.objectDescription
        objectTypeText.text = viewModel.objectType
    }
    
    // MARK: - Private methods
    private func setupView() {
        title = "Object Detail"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButton))
    }
    
    // MARK: - Actions / Selectors
    @IBAction func addRelationAction(_ sender: Any) {
        guard let viewModel = viewModel.relationViewModel() else {
            return
        }
        
        let relationViewController = RelationViewController(viewModel: viewModel)
        relationViewController.delegate = self
        navigationController?.pushViewController(relationViewController, animated: true)
    }
    
    @objc func saveButton() {
        viewModel.saveObject(objectName: objectNameText.text, objectDescription: objectDescriptionText.text, objectType: objectTypeText.text)
        delegate?.refreshContent()
        navigationController?.popViewController(animated: true)
    }
}


extension ObjectDetailViewController: UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRow
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RelationCell.cellId, for: indexPath) as? RelationCell else {
            fatalError("ObjectCell not found")
        }
        
        cell.viewModel = viewModel.relationCellViewModelBy(indexPath)
        return cell
    }
}

extension ObjectDetailViewController: RelationViewControllerDelegate {
    func relationDidChange() {
        tableView.reloadData()
    }
}
