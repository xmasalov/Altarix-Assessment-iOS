//
//  BuyViewModel.swift
//  Supermarket
//
//  Created by Ilya Masalov on 27/06/2019.
//  Copyright © 2019 Ilya Masalov. All rights reserved.
//

import Bond

class ItemsViewModel {
    
    // MARK: - Properties
    private let itemManager: ItemManager

    let itemsToBuy = MutableObservableArray<Item>()
    let itemsToSell = MutableObservableArray<Item>()
    
    // MARK: - Init
    init(itemManager: ItemManager) {
        self.itemManager = itemManager
        bindModel()
        itemManager.fetchData()
    }
}

// MARK: - Methods
extension ItemsViewModel {

    func addItem(item: Item) {
        itemManager.add(item: item)
    }
}

// MARK: - Private methods
private extension ItemsViewModel {
    
    func bindModel() {
        itemManager.items.filterCollection({ $0.category == .buy }).bind(to: itemsToBuy)
        itemManager.items.filterCollection({ $0.category == .sell }).bind(to: itemsToSell)
    }
}
