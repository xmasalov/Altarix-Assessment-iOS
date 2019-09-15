//
//  ItemManager.swift
//  Supermarket
//
//  Created by Ilya Masalov on 16/09/2019.
//  Copyright © 2019 Ilya Masalov. All rights reserved.
//

import ReactiveKit
import Bond
import RealmSwift

protocol ItemManager {
    
    // FIXME: Items type
    var items: Signal<OrderedCollectionChangeset<Results<Item>>, NSError> { get set }
    
    func update(item: Item, name: String, price: Double, department: Item.Department, category: Item.Category)
    func add(item: Item)
    func remove(item: Item)
}
