//
//  BuyViewController.swift
//  Supermarket
//
//  Created by Ilya Masalov on 27/06/2019.
//  Copyright © 2019 Ilya Masalov. All rights reserved.
//

import UIKit

class BuyViewController: UIViewController, ItemsViewModelBased {
    
    // MARK: - Properties
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var addButton: UIBarButtonItem!
    
    var viewModel: ItemsViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        addObservers()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? DetailViewController {
            let item = sender as? Item
            let viewModel = DetailViewModel(item: item, itemManager: self.viewModel.itemManager, category: .buy)
            viewController.viewModel = viewModel
        }
    }
}

// MARK: - Private methods
private extension BuyViewController {
    
    func addObservers() {
        _ = addButton.reactive.tap.observeNext { [weak self] in
            guard let self = self else { return }
            self.performSegue(withIdentifier: "DetailViewController", sender: nil)
        }
    }
    
    func bindViewModel() {
        viewModel.itemsToBuy.bind(to: tableView, cellType: ItemCell.self) { cell, item in
            cell.configure(name: item.name)
            
            cell.reactive.bag.dispose()
            _ = cell.reactive.tapGesture().observeNext { [weak self] _ in
                guard let self = self else { return }
                self.performSegue(withIdentifier: "DetailViewController", sender: item)
                
                }.dispose(in: cell.reactive.bag)
        }
    }
}
