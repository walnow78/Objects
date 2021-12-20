//
//  RelationViewController.swift
//  Objects
//
//  Created by Pawel Walicki on 19/12/21.
//

import UIKit

protocol RelationViewControllerDelegate: AnyObject {
    func relationDidChange()
}

final class RelationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 60
            tableView.allowsMultipleSelection = true
            tableView.register(UINib(nibName: ObjectCell.cellId, bundle: nil), forCellReuseIdentifier: ObjectCell.cellId)
        }
    }
    
    private let viewModel: RelationViewModel
    
    weak var delegate: RelationViewControllerDelegate?
    
    // MARK: Lifecycle
    init(viewModel: RelationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        viewModel.fetchObject()
        
        tableView.reloadData()
    }
    
    private func setupView() {
        title = "Relations"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButton))
    }

    private func saveRelations() {
        let selected = tableView.indexPathsForSelectedRows
        viewModel.saveRelations(indexPaths: selected)
    }
    
    // MARK: - Actions / Selectors
    @objc func saveButton() {
        saveRelations()
        delegate?.relationDidChange()
        navigationController?.popViewController(animated: true)
    }

}

// MARK: - UITableViewDataSource
extension RelationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ObjectCell.cellId, for: indexPath) as? ObjectCell else {
            fatalError("ObjectCell not found")
        }
        
        cell.viewModel = viewModel.cellViewModelBy(indexPath)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let lastIndex = tableView.indexPathsForVisibleRows?.last {
               if indexPath == lastIndex {
                   viewModel.indexPaths.forEach { indexPath in
                       tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                   }
               }
        }
    }
}

// MARK: - UITableViewDelegate
extension RelationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
}
