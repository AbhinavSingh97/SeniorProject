//
//  UpdateViewController.swift
//  StudyBuddy
//
//  Created by Local Account 436-25 on 3/6/18.
//  Copyright © 2018 Local Account 436-25. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class UpdateViewController: UIViewController {

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let ref = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateInformation(_ sender: Any) {
        let uid = Auth.auth().currentUser?.uid
        let user = Auth.auth().currentUser
        var information = [AnyHashable : Any]()
        if(self.emailField.text != nil){
            user?.updateEmail(to: self.emailField.text!, completion: nil)
        }
        if(self.passwordField.text != nil){
            user?.updatePassword(to: self.passwordField.text!, completion: nil)
        }
        if(firstNameField.text != nil && firstNameField.text != ""){
            information.updateValue(self.firstNameField.text, forKey: "first")
        }
        if(lastNameField.text != nil && lastNameField.text != ""){
            information.updateValue(self.lastNameField.text, forKey: "last")
        }
        ref.child("users").child(uid!).updateChildValues(information)
    }
    @IBAction func deleteUser(_ sender: Any) {
        let user = Auth.auth().currentUser
        user?.delete(completion: nil)
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
