//
//  DetailViewModel.swift
//  Supermarket
//
//  Created by Ilya Masalov on 01/07/2019.
//  Copyright © 2019 Ilya Masalov. All rights reserved.
//

import Foundation
import ReactiveKit
import Bond

class DetailViewModel: ViewModel {
    
    // MARK: - Properties
    let editStateTitle = "Редактировать"
    let doneStateTitle = "Готово"
    let departmentAlertTitle = "Категория"
    let departmentAlertMessage = "Выберите подходящую категорию"
    let departmentAlertActionTitle = "Продолжить"
    
    private let item: Item?
    private let category: Item.Category
    internal let itemManager: ItemManager
    
    private(set) lazy var itemName = Observable<String?>(item?.name ?? "")
    private(set) lazy var itemDepartment = Observable<Item.Department>(item?.department ?? .none)
    private(set) lazy var itemPrice = Observable<String?>(item?.price.description ?? "")
    
    private(set) var allowedToSaveEdits = Observable<Bool>(false)
    
    init(item: Item?, itemManager: ItemManager, category: Item.Category) {
        self.item = item
        self.itemManager = itemManager
        self.category = category
        
        addBindings()
    }
}

// MARK: - Computed properties
extension DetailViewModel {
    
    var creatingItem: Bool {
        return item == nil
    }
}

// MARK: - Methods
extension DetailViewModel {
    
    func writeChanges() {
        if let item = item {
            itemManager.update(item: item, name: itemName.value!, price: Double(itemPrice.value!)!, department: itemDepartment.value, category: category)
        } else {
            let item = Item()
            item.name = itemName.value!
            item.price = Double(itemPrice.value!)!
            item.department = itemDepartment.value
            item.category = category
            itemManager.add(item: item)
        }
    }
    
    func shouldChangeCharactersIn(text oldText: String, range: NSRange, replacementString string: String) -> Bool {
        guard let r = Range(range, in: oldText) else {
            return true
        }
        
        let newText = oldText.replacingCharacters(in: r, with: string)
        let isNumeric = newText.isEmpty || (Double(newText) != nil)
        let numberOfDots = newText.components(separatedBy: ".").count - 1
        
        let numberOfDecimalDigits: Int
        if let dotIndex = newText.firstIndex(of: ".") {
            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }
        
        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
    }
    
    func priceFormatter(value: Any?) -> String? {
        guard let value = value else {
            return nil
        }
        
        let numberFormatter = NumberFormatter()
        
        numberFormatter.decimalSeparator = "."
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        
        return numberFormatter.string(from: value as! NSNumber)
    }
}

// MARK: - Private methods
private extension DetailViewModel {
    
    func addBindings() {
        combineLatest(itemName, itemPrice) { name, price in
            let nameFilled = !(name?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
            let priceFilled = !(price?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
            
            return nameFilled && priceFilled
            }.bind(to: allowedToSaveEdits)
    }
}
