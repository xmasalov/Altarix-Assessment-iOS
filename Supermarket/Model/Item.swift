//
//  Item.swift
//  Supermarket
//
//  Created by Ilya Masalov on 27/06/2019.
//  Copyright © 2019 Ilya Masalov. All rights reserved.
//

import RealmSwift

class Item: Object {
    
    // MARK: - Enumerations
    enum Department: String, CaseIterable {
        case none = "Без категории"
        case home = "Для дома"
        case appliances = "Бытовая техника"
        case food = "Еда"
        case clothes = "Одежда"
        case misc = "Прочее"

        var title: String {
            return rawValue
        }
    }

    enum Category: String {
        case buy
        case sell
        
        var title: String {
            return rawValue
        }
    }
    
    // MARK: - Properties
    @objc dynamic var name: String = ""
    @objc dynamic var price: Double = 0
    
    @objc private dynamic var realmcategory = ""
    var category: Category {
        get { return Category(rawValue: realmcategory)! }
        set { realmcategory = newValue.rawValue }
    }
    
    @objc private dynamic var realmdepartment = ""
    var department: Department {
        get { return Department(rawValue: realmdepartment)! }
        set { realmdepartment = newValue.rawValue }
    }
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var date = Date().description
    
    // MARK: - Methods
    override static func primaryKey() -> String? {
        return "id"
    }
}
