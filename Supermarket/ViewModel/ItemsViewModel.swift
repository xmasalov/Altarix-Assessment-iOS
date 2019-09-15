//
//  ItemsViewModel.swift
//  Supermarket
//
//  Created by Ilya Masalov on 27/06/2019.
//  Copyright © 2019 Ilya Masalov. All rights reserved.
//

import ReactiveKit
import Bond

class ItemsViewModel: ViewModel {
    
    // MARK: - Enums
    enum Filter: String, CaseIterable {
        case all = "Все категории"
        case home = "Для дома"
        case appliances = "Бытовая техника"
        case food = "Еда"
        case clothes = "Одежда"
        case misc = "Прочее"
        
        var title: String {
            return rawValue
        }
    }

    // MARK: - Properties
    let departmentAlertTitle = "Категория"
    let departmentAlertMessage = "Выберите подходящую категорию"
    let departmentAlertActionTitle = "Выбрать"
    
    internal let itemManager: ItemManager
    
    let itemsToBuy = MutableObservableArray<Item>()
    let itemsToSell = MutableObservableArray<Item>()
    private let bag = DisposeBag()
    
    var selectedFilter: Filter = .all {
        didSet {
            disposeModel()
            bindModel()
        }
    }
    
    // MARK: - Init
    init(itemManager: ItemManager) {
        self.itemManager = itemManager
        bindModel()
    }
}

// MARK: - Private methods
private extension ItemsViewModel {
    
    func bindModel() {
        itemManager.items.filterCollection({ $0.category == .buy })
            .suppressError(logging: true)
            .bind(to: itemsToBuy)
            .dispose(in: bag)
        
        itemManager.items.filterCollection({ [weak self] in
            guard let self = self else { return false }
            
            return self.selectedFilter == .all ?
                $0.category == .sell :
                $0.category == .sell && $0.department.title == self.selectedFilter.title
            
        })
            .suppressError(logging: true)
            .bind(to: itemsToSell)
            .dispose(in: bag)
    }
    
    func disposeModel() {
        bag.dispose()
    }
}
