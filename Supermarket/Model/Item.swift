//
//  Item.swift
//  Supermarket
//
//  Created by Ilya Masalov on 27/06/2019.
//  Copyright © 2019 Ilya Masalov. All rights reserved.
//

struct Item {
    
    // MARK: - Enumerations
    enum Department: String {
        case home = "Для дома"
        case appliances = "Бытовая техника"
        case food = "Еда"
        case clothes = "Одежда"
        case misc = "Прочее"
        
        var title: String {
            return rawValue
        }
    }
    
    enum Category {
        case buy
        case sell
    }
    
    // MARK: - Properties
    let name: String
    let price: Double
    let department: Department
    let category: Category
}
