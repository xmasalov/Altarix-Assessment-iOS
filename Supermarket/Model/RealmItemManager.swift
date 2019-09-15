//
//  RealmItemManager.swift
//  Supermarket
//
//  Created by Ilya Masalov on 27/06/2019.
//  Copyright © 2019 Ilya Masalov. All rights reserved.
//

import Bond
import ReactiveKit
import RealmSwift

class RealmItemManager: ItemManager {
    
    // MARK: - Properties
    private let realm = try! Realm()
    lazy var items = realm.objects(Item.self).sorted(byKeyPath: "date", ascending: false).toChangesetSignal()
}

// MARK: - Methods
extension RealmItemManager {
    
    func add(item: Item) {
        let randomDelay = Double.random(in: 1...3)
        DispatchQueue.main.asyncAfter(deadline: .now() + randomDelay) {
            try! self.realm.write {
                self.realm.add(item)
            }
        }
    }
    
    func update(item: Item, name: String, price: Double, department: Item.Department, category: Item.Category) {
        DispatchQueue.main.async {
            try! self.realm.write {
                item.setValue(name, forKey: "name")
                item.setValue(price, forKey: "price")
                item.setValue(department.title, forKey: "realmdepartment")
                item.setValue(category.title, forKey: "realmcategory")
            }
        }
    }
    
    func remove(item: Item) {
        DispatchQueue.main.async {
            try! self.realm.write {
                self.realm.delete(item)
            }
        }
    }
    
    static func addSampleData() {
        [("Nike Air Max", 6499.99),
         ("Nike Air Jordan", 8299.49),
         ("Футболка Puma", 799.49),
         ("Футболка Nike", 699.49),
         ("Adidas Busenitz", 3499.99)].forEach {
            let item = Item()
            item.name = $0.0
            item.price = $0.1
            item.department = .clothes
            item.category =  Bool.random() == true ? .buy : .sell
            
            DispatchQueue.main.async {
                autoreleasepool {
                    let realm = try! Realm()
                    try! realm.write {
                        realm.add(item)
                    }
                }
            }
        }
    }
}
