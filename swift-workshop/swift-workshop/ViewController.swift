//
//  ViewController.swift
//  swift-workshop
//
//  Created by David Ng on 18/1/2017.
//  Copyright © 2017 Skygear. All rights reserved.
//

import UIKit
import SKYKit

class ViewController: UIViewController {

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUserStatus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUserStatus() {
        if((SKYContainer.default().currentUserRecordID) != nil) {
            print("Logged in ")
        } else {
            print("Not Logged in ")
        }
    }
    
    @IBAction func loginButtonDidTap(_ sender: AnyObject) {
        let email = self.emailField.text!
        let password = self.passwordField.text!
        
        print("Login! \(email) \(password)")
        
        SKYContainer.default().login(withEmail: emailField.text, password: passwordField.text) { (user, error) in
            if (error != nil) {
                
                let meError = error as NSError!
                
                let alert = UIAlertController(title: "Error logging in", message:meError?.skyErrorMessage(), preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            print("Log in as: \(user)")
            self.updateUserStatus()
        }
    }
    
    @IBAction func signupButtonDidTap(_ sender: AnyObject) {
        let email = self.emailField.text!
        let password = self.passwordField.text!
        
        print("Signup! \(email) \(password)")
        SKYContainer.default().signup(withEmail: emailField.text, password: passwordField.text) { (user, error) in
            if (error != nil) {
                
                let meError = error as NSError!
                
                let alert = UIAlertController(title: "Error signing up", message:meError?.skyErrorMessage(), preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            print("Signed up as: \(user)")
            self.updateUserStatus()
            }
        }


}

