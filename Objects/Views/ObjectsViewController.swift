//
//  ObjectsViewController.swift
//  Objects
//
//  Created by Pawel Walicki on 19/12/21.
//

import UIKit

class ObjectsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 60
            tableView.register(UINib(nibName: ObjectCell.cellId, bundle: nil), forCellReuseIdentifier: ObjectCell.cellId)
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
            searchBar.showsSearchResultsButton = true
            searchBar.showsCancelButton = true
        }
    }
    
    private let viewModel: ObjectsViewModel
    
    // MARK: Lifecycle
    init(viewModel: ObjectsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        reloadObjects()
    }
    
    // MARK: - Private functions
    private func showDetail(indexPath: IndexPath?) {
        let detailViewController = ObjectDetailViewController(viewModel: viewModel.detailViewModelBy(indexPath))
        detailViewController.delegate = self
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    private func setupView() {
        title = "Objects"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButton))
        
    }
    
    private func reloadObjects(filter: String? = nil) {
        viewModel.fetchObject(filter: filter)
        tableView.reloadData()
    }
    
    // MARK: - Actions / Selectors
    @objc func addButton() {
        showDetail(indexPath: nil)
    }
}

// MARK: - UITableViewDataSource
extension ObjectsViewController: UITableViewDataSource {
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
}

// MARK: - UITableViewDelegate
extension ObjectsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showDetail(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteObjectBy(indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - ObjectDetailViewControllerDelegate
extension ObjectsViewController: ObjectDetailViewControllerDelegate {
    func refreshContent() {
        reloadObjects()
    }
}

// MARK: - UISearchBarDelegate
extension ObjectsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let filter = searchBar.text, !filter.isEmpty {
            reloadObjects(filter: filter)
        } else {
            reloadObjects()
        }
        
        view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        view.endEditing(true)
        reloadObjects()
    }
}
