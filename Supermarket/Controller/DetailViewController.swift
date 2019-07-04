//
//  DetailViewController.swift
//  Supermarket
//
//  Created by Ilya Masalov on 27/06/2019.
//  Copyright © 2019 Ilya Masalov. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import RLBAlertsPickers

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak private var nameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak private var departmentStackView: DepartmentStackView!
    @IBOutlet weak private var priceTextField: SkyFloatingLabelTextField!
    
    var viewModel: DetailViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObservers()
        bindViewModel()
        setDelegates()
        setEditingProperties()
    }
    
    // MARK: - Editing
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        editButtonItem.title = editing ? viewModel.doneStateTitle : viewModel.editStateTitle
        
        nameTextField.setEditing(editing)
        departmentStackView.setEditing(editing)
        priceTextField.setEditing(editing)
        
        if editing {
            nameTextField.becomeFirstResponder()
        } else {
            viewModel.writeChanges()
        }
    }
}

// - MARK: UITextFieldDelegate
extension DetailViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == priceTextField, let text = textField.text {
            return viewModel.shouldChangeCharactersIn(text: text, range: range, replacementString: string)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameTextField {
            textField.text = textField.text?.trimmingCharacters(in: .whitespaces)
        }
        
        if textField == priceTextField {
            textField.text = viewModel.priceFormatter(value: Double(textField.text ?? ""))
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if nameTextField == textField {
            presentDepartmentPicker()
        }
        
        if priceTextField == textField {
            setEditing(false, animated: true)
        }
        
        return true
    }
}

// - MARK: Private methods
private extension DetailViewController {
    
    func addObservers() {
        _ = departmentStackView.reactive.tapGesture().observeNext { [unowned self] _ in
            self.presentDepartmentPicker()
        }
    }
    
    func bindViewModel() {
        viewModel.itemName.bidirectionalBind(to: nameTextField.reactive.text)
        viewModel.itemPrice.bidirectionalBind(to: priceTextField.reactive.text)
        viewModel.itemDepartment.map { $0.title }.bind(to: departmentStackView.departmentLabel.reactive.text)
        viewModel.allowedToSaveEdits.bind(to: editButtonItem.reactive.isEnabled)
    }
    
    func setDelegates() {
        nameTextField.delegate = self
        priceTextField.delegate = self
    }
    
    func setEditingProperties() {
        navigationItem.rightBarButtonItem = editButtonItem
        editButtonItem.title = viewModel.editStateTitle
        
        if viewModel.creatingItem {
            isEditing = true
        }
    }
    
    func presentDepartmentPicker() {
        let alert = UIAlertController(style: .actionSheet, title: viewModel.departmentAlertTitle, message: viewModel.departmentAlertMessage)
        
        let enumValues = Item.Department.allCases
        let stringValues = enumValues.map { $0.rawValue }
        
        let index = PickerViewViewController.Index(column: 0, row: viewModel.itemDepartment.value.index ?? 0)

        alert.addPickerView(values: [stringValues], initialSelection: index) { [unowned self] vc, picker, index, values in
            
            self.viewModel.itemDepartment.value = enumValues[index.row]
        }
        
        alert.addAction(title: viewModel.departmentAlertActionTitle) { [unowned self] _ in
            self.priceTextField.becomeFirstResponder()
        }
        
        alert.show { [unowned self] in
            if !self.departmentStackView.specified {
                self.viewModel.itemDepartment.value = enumValues[index.row]
            }
        }
    }
}
