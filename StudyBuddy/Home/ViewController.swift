//
//  ViewController.swift
//  StudyBuddy
//
//  Created by Local Account 436-25 on 2/27/18.
//  Copyright © 2018 Local Account 436-25. All rights reserved.
//

import UIKit
import FirebaseAuth
class ViewController: UIViewController{
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func loginButton(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text{
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if let firebaseError = error{
                    print(firebaseError.localizedDescription)
                    return
                }
                self.presentLoggedInScreen()
                print("success")
            })
        }
    }
    func presentLoggedInScreen(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle : nil)
        let loggedInVC = storyBoard.instantiateViewController(withIdentifier: "LoggedInTabViewController")
        self.present(loggedInVC, animated: true, completion: nil)
    }
    @IBAction func unwindToLogin(segue: UIStoryboardSegue){
    }
    
}

