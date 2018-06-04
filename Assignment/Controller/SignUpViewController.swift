//
//  SignUpVC.swift
//  Demo
//
//  Created by Apple on 31/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import CoreData

class SignUpViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //-------------
    let thePicker = UIPickerView()
    let myPickerData = [String](arrayLiteral:"Male", "Female", "Other")
    //    lazy var newUser = User()
    
    let managedContext = CoreDataManager.shared.persistentContainer.viewContext
    
    
    //MARK:-  View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        thePicker.delegate = self
        genderTextField.inputView = thePicker
   
    }
        //MARK:-  Custom method
    
    @IBAction func loginBtnAct(_ sender: Any) {
        if validateRequiredField() {
            self.userRegistration()
        }else{
            debugPrint("something went wrong")
        }
        
    }
    
    private func checkForEmptyFields() -> Bool {
        if emailTextField.text!.isEmpty {
            return false
        }else
            if passwordTextField.text!.isEmpty {
                return false
            }else
                if genderTextField.text!.isEmpty {
                    return false
                }else
                    if mobileNumberTextField.text!.isEmpty {
                        return false
        }
        return true
    }
    
    private func validateRequiredField() -> Bool {
        
        if checkForEmptyFields() {
            
            if emailTextField.text!.isValidEmail() {
                if checkForExistingUser(email: emailTextField.text!) {
                    // debug print
                    debugPrint("New User")
                    
                    if passwordTextField.text!.isValidPassword() {
                        // do a check for mobile number
                        
                        return true
                    }
                }else{
                    debugPrint("existing User")
                }
                return false
            }
            return false
        }else{
            Utility.showMessageDialog(onController: self, withTitle: "Alert", withMessage: "Please complete the form.")
            return false
        }
    }
    
    func userRegistration() {
        
        guard let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: managedContext) as? User else {
            return
        }
        
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let mobileNumber = mobileNumberTextField.text!
        let gander = genderTextField.text!
        
        if  firstNameTextField.text!.isEmpty{
            user.setValue(" ", forKeyPath: "firstName")
        }else{
            user.setValue(firstNameTextField.text, forKeyPath: "firstName")
        }
        if  lastNameTextField.text!.isEmpty {
            user.setValue(" ", forKeyPath: "lastName")
        }else{
            user.setValue(lastNameTextField.text, forKeyPath: "lastName")
        }
        
        user.setValue(email, forKeyPath: "email")
        user.setValue(mobileNumber, forKeyPath: "mobileNumber")
        user.setValue(password, forKeyPath: "password")
        user.setValue(gander, forKeyPath: "gander")
        
        do {
            try managedContext.save()
            
            print("details save sucessfully")
            
             self.navigationController?.popViewController(animated: true)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        
    }
  
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func checkForExistingUser(email: String) -> Bool {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.predicate = NSPredicate (format: "email == %@", email)
        do
        {
            let result = try managedContext.fetch(request)
            if result.count > 0
            {
                return false
            }else{
                return true
                
            }
        }
        catch {
            //handle error
            print(error)
            return false
        }
    }
    
}

// MARK:- UIPickerView Delegates

extension  SignUpViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myPickerData.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return myPickerData[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = myPickerData[row]
    }
}
