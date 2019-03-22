//
//  UserViewController.swift
//  StudyBuddy
//
//  Created by Local Account 436-25 on 3/4/18.
//  Copyright © 2018 Local Account 436-25. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class UserViewController: UIViewController {

    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    let ref = Database.database().reference()
    let user = Auth.auth().currentUser
    //let userID : String = (Auth.auth().currentUser?.uid)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       userInfo()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func userInfo(){
        let uid = Auth.auth().currentUser?.uid
        ref.child("users").child(uid!).observeSingleEvent(of: .value, with:{(snapshot) in
            let value = snapshot.value as? NSDictionary
            self.firstNameLabel.text = (value?["first"] as? String)! + " " + (value?["last"] as? String)!
            self.emailLabel.text = (self.user?.email)!
            //self.passwordTextField.text = self.user?.password
            
        })
        
    }
    
    @IBAction func unwindToUser(segue: UIStoryboardSegue){
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
