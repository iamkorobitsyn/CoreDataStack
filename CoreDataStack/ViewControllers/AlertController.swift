//
//  AlertControlle.swift
//  CoreDataStack
//
//  Created by Александр Коробицын on 10.11.2022.
//

import UIKit

class AlertController: UIAlertController {
    
    var completion: ((_ name: String, _ age: Int64) -> Void)?
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        
        instanceActions()
        instanceTextFields()
    }
    
    //MARK: - Instance UI Elements
    
    private func instanceActions() {
        let rightAction = UIAlertAction(title: "Add", style: .default) { _ in
            guard let name = self.textFields?.first?.text,
                  let age = Int64(self.textFields?.last?.text ?? ""), age != 0
            else {return}
            self.completion?(name, age)
        }
        rightAction.isEnabled = false
        
        let leftAction = UIAlertAction(title: "Cancel", style: .default) { _ in
            print("Cancel")
        }
        
        self.addAction(leftAction)
        self.addAction(rightAction)
    }
    
    private func instanceTextFields() {
        self.addTextField() { [weak self] (textField: UITextField!) in
            textField.delegate = self
            textField.placeholder = "String"
        }
        self.addTextField() { [weak self] (textField: UITextField!) in
            textField.delegate = self
            textField.placeholder = "Int"
        }
    }
}

//MARK: - UITextFieldDelegate
    
extension AlertController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if self.textFields?.first?.text != "",
           self.textFields?.last?.text != ""
        {
            self.actions.last?.isEnabled = true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return validator(text: string,
                         firstTextfield: self.textFields?.first,
                         lastTextField: self.textFields?.last)
    }

    private func validator(text: String, firstTextfield: UITextField?, lastTextField: UITextField?) -> Bool {
        let space = " "
        if text.contains(space) {
            return false
        }
        return true
    }
}

