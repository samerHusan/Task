//
//  HomeViewController.swift
//  Alamofire
//
//  Created by samer on 03/06/18.
//

import UIKit
import  CoreData

class HomeViewController: UIViewController {
    
    
    @IBOutlet var firstNameLabel: UILabel!
    @IBOutlet var lastNameLabel: UILabel!
    @IBOutlet var mobileTextField: UITextField!
    
    var emailID: String?
    let managedContext = CoreDataManager.shared.persistentContainer.viewContext
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        self.view.addGestureRecognizer(tapgesture)
        // Do any additional setup after loading the view.
        
        // get thet current user with email id
        findUser()
        // update tu UI
    
        
    }
   
     @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func findUser(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.predicate = NSPredicate (format: "email == %@", emailID!)
        do
        {
            let result = try managedContext.fetch(request)
            if result.count > 0
            {
                
               debugPrint(result.first as! User)
                let user = result.first as! User
                self.updateUIWith(user: user)
                
            }else{
               debugPrint("error")

            }
        }
        catch {
            //handle error
            print(error)
        }
    }
    
    func updateUIWith(user: User) {
        self.firstNameLabel.text = user.firstName
        self.lastNameLabel.text = user.lastName
        self.mobileTextField.text = user.mobileNumber
        
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        // log out user
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func editMobileNumberButtonTapped(_ sender: UIButton){
        mobileTextField.isEnabled = true
    }
    
    func updateUserWithMobileNumber(number: String) {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.predicate = NSPredicate (format: "email == %@", emailID!)
        do
        {
            let result = try managedContext.fetch(request)
            if result.count > 0
            {
                
                debugPrint(result.first as! User)
                let user = result.first as! User
                
                user.setValue(number, forKeyPath: "mobileNumber")
                
                
                do {
                    try managedContext.save()
                    print("details update sucessfully")
                    
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }else{
                debugPrint("error")
                
            }
        }
        catch {
            //handle error
            print(error)
        }
    }
}

extension HomeViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        // check for empty text field
        updateUserWithMobileNumber(number: textField.text!)
        textField.isEnabled = false
        
    }
}
