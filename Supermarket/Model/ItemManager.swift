//
//  ItemManager.swift
//  Supermarket
//
//  Created by Ilya Masalov on 27/06/2019.
//  Copyright © 2019 Ilya Masalov. All rights reserved.
//

import Bond

class ItemManager {
    
    // MARK: - Properties
    private(set) var items = MutableObservableArray<Item>()
}

// MARK: - Methods
extension ItemManager {
    
    func fetchData() {
    }
    
    func add(item: Item) {
        items.append(item)
    }
}
