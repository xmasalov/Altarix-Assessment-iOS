//
//  SellViewController.swift
//  Supermarket
//
//  Created by Ilya Masalov on 27/06/2019.
//  Copyright © 2019 Ilya Masalov. All rights reserved.
//

import UIKit
import RLBAlertsPickers

class SellViewController: UIViewController, ItemsViewModelCompatible {
    
    // MARK: - Properties
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var addButton: UIBarButtonItem!
    @IBOutlet weak private var filterButton: UIBarButtonItem!
    
    var viewModel: ItemsViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
        bindViewModel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? DetailViewController {
            let item = sender as? Item
            let viewModel = DetailViewModel(item: item, itemManager: self.viewModel.itemManager, category: .sell)
            viewController.viewModel = viewModel
        }
    }
}

// MARK: - Private methods
private extension SellViewController {
    
    func addObservers() {
        _ = addButton.reactive.tap.observeNext { [unowned self] in
            self.performSegue(withIdentifier: "DetailViewController", sender: nil)
        }
        
        _ = filterButton.reactive.tap.observeNext { [unowned self] in
            self.presentDepartmentFilterPicker()
        }
    }
    
    func bindViewModel() {        
        viewModel.itemsToSell.bind(to: tableView, cellType: ItemCell.self) { cell, item in
            cell.configure(name: item.name)
            
            cell.reactive.bag.dispose()
            _ = cell.reactive.tapGesture().observeNext { [unowned self] _ in
                self.performSegue(withIdentifier: "DetailViewController", sender: item)
                
                }.dispose(in: cell.reactive.bag)
        }
    }
    
    func presentDepartmentFilterPicker() {
        let alert = UIAlertController(style: .actionSheet, title: viewModel.departmentAlertTitle, message: viewModel.departmentAlertMessage)
        
        let enumValues = ItemsViewModel.Filter.allCases
        let stringValues = enumValues.map { $0.rawValue }
        
        let index = PickerViewViewController.Index(column: 0, row: viewModel.selectedFilter.index ?? 0)
        
        alert.addPickerView(values: [stringValues], initialSelection: index) { [unowned self] vc, picker, index, values in
            
            self.viewModel.selectedFilter = enumValues[index.row]
            self.filterButton.title = enumValues[index.row].title
        }
        
        alert.addAction(title: viewModel.departmentAlertActionTitle)
        alert.show()
    }
}
