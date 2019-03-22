//
//  RegisterViewController.swift
//  StudyBuddy
//
//  Created by Local Account 436-25 on 2/28/18.
//  Copyright © 2018 Local Account 436-25. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class RegisterViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    let ref = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func signupUser(_ sender: Any) {
        // Change this to encompass more fields in a neater fashion rather than making all
        // these if statements, add .edu email support
        if(self.emailTextField.text == ""){
            self.createAlert(title: "Missing Field", message: "Missing Email")
            return
        }
        // Deprecated code for checking if the password was typed correctly, however we don't really need this anymore
        // considering adding email verification as well as a password reset with that.
//        if(self.passwordTextField.text == "" || self.repeatPasswordTextField.text == ""){
//            self.createAlert(title: "Missing Field", message: "One or more of the password fields were missing")
//            return
//        }
//        if((self.passwordTextField.text?.elementsEqual(self.repeatPasswordTextField.text!))! != true){
//            self.createAlert(title: "Error", message: "Passwords do not match")
//            return
//        }
        if let email = emailTextField.text, let password = passwordTextField.text{
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                if let firebaseError = error{
                    print(firebaseError.localizedDescription)
                    return
                }
                self.ref.child("users").child((user?.user.uid)!).setValue(["first": self.firstNameTextField.text, "last" : self.lastNameTextField.text, "sessions" : nil, "assignments" : nil])
                self.createAlert(title: "Success", message: "We're happy to have you!")
            })
        }
    }
    
    func createAlert(title : String, message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
