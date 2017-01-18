//
//  ViewController.swift
//  swift-workshop
//
//  Created by David Ng on 18/1/2017.
//  Copyright © 2017 Skygear. All rights reserved.
//

import UIKit

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
        
    }
    
    @IBAction func loginButtonDidTap(_ sender: AnyObject) {
        print("Login!")
    }
    @IBAction func signupButtonDidTap(_ sender: AnyObject) {
        print("Signup!")
    }


}

