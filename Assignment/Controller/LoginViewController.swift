//
//  LoginViewController.swift
//  Demo
//
//  Created by Apple on 31/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import CoreData


class LoginViewController: UIViewController {
    
    // OUtlets
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var passwordTexrField: UITextField!
    
    // Variables
    let managedContext = CoreDataManager.shared.persistentContainer.viewContext
    
    //MARK:-  View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool){
        userNameTextField.text = ""
        passwordTexrField.text = ""
        
    }

    //MARK:-  View Custom Method
    private func checkForEmptyFields() -> Bool {
        if userNameTextField.text!.isEmpty {
            return false
        }else
            if passwordTexrField.text!.isEmpty {
                return false
        }
        return true
    }
    
     func validateRequiredFields(email: String, password: String) -> Bool {
        if checkForEmptyFields() {
            
            if email.isValidEmail() {
                if password.isValidPassword() {
                    
                    return true
                }else{
                    Utility.showMessageDialog(onController: self, withTitle: "Alert", withMessage: "Password should contain one special character and minimum 8 characters required")
                    return false
                }
            }else{
                Utility.showMessageDialog(onController: self, withTitle: "Alert", withMessage: "Email is not vaild.")
                return false
            }
            
        }else{
            Utility.showMessageDialog(onController: self, withTitle: "Alert", withMessage: "All field are required.")
            return false
        }
        
    }
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        let email = userNameTextField.text
        let password = passwordTexrField.text
        
        if validateRequiredFields(email: email!, password: password!) {
            let email = userNameTextField.text!
            let password = passwordTexrField.text!
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            request.predicate = NSPredicate (format: "email == %@ and password == %@", email, password)
            do
            {
                let result = try managedContext.fetch(request)
                if result.count > 0
                {
                    debugPrint(result)
                    
                    let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                    if let homeView = storyBoard.instantiateViewController(withIdentifier: "HomeView") as? HomeViewController {
                        homeView.emailID = userNameTextField.text!
                        self.navigationController?.show(homeView, sender: nil)
                    }
                    
                }else{
                    let alertController1 = UIAlertController (title: "Invalid Login", message: "", preferredStyle: UIAlertControllerStyle.alert)
                    alertController1.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    present(alertController1, animated: true, completion: nil)
                }
                
                userNameTextField.text=""
                passwordTexrField.text=""
            }
            catch {
                //handle error
                print(error)
            }
        
    }
    
}

}
