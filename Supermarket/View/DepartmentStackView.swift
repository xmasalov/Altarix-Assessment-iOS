//
//  DepartmentStackView.swift
//  Supermarket
//
//  Created by Ilya Masalov on 01/07/2019.
//  Copyright © 2019 Ilya Masalov. All rights reserved.
//

import UIKit
import Bond

class DepartmentStackView: UIStackView {
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    
    var specified: Bool {
        return !(departmentLabel.text?.isEmpty ?? true)
    }
}

extension DepartmentStackView: Editable {
    
    func setEditing(_ editing: Bool) {
        isUserInteractionEnabled = editing
        titleLabel.textColor = editing ? .systemBlue : .black
        // TODO: Set gray if not selected
    }
}
