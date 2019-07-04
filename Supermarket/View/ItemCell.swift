//
//  ItemCell.swift
//  Supermarket
//
//  Created by Ilya Masalov on 27/06/2019.
//  Copyright © 2019 Ilya Masalov. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    // MARK: - Properties
    @IBOutlet weak private var nameLabel: UILabel!
}

// MARK: - Methods
extension ItemCell {
    
    func configure(name: String) {
        nameLabel.text = name
    }
}
