//
//  NewGradeViewController.swift
//  StudyBuddy
//
//  Created by Abhinav Singh on 3/10/19.
//  Copyright © 2019 Local Account 436-25. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class NewGradeViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var assignmentName: UITextField!
    @IBOutlet weak var userScore: UITextField!
    @IBOutlet weak var maxScore: UITextField!
    @IBOutlet weak var category: UITextField!
    var ref : DatabaseReference!
    var refhandle : DatabaseHandle!
    var classVal : Class?
    var colors = [""]
    override func viewDidLoad() {
        super.viewDidLoad()
        let pickerView = UIPickerView()
        pickerView.delegate = self as! UIPickerViewDelegate
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(datePressed))
        toolbar.setItems([done], animated: false)
        category.inputAccessoryView = toolbar
        category.inputView = pickerView
        colors = determineCategories()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveAssignment(_ sender: Any) {
        let uid = Auth.auth().currentUser?.uid
        ref = Database.database().reference()
        let key = ref.child("users").child(uid!).child("classes").childByAutoId().key

        let newAssignment = ["name":assignmentName.text,
                          "userScore":userScore.text,
                          "maxScore":maxScore.text,
                          "category" : category.text,
                          "uniqueID": NSUUID().uuidString
            ] as [String : Any]
//        ref?.child("users").child(uid!).child("classes").childByAutoId().setValue(newAssignment)
        let childUpdates = ["users/\(uid!)/classes/\(String(describing: classVal?.uniqueId))/grades/\(String(describing: key))": newAssignment]
        ref.updateChildValues(childUpdates)
//        createAlert(title: "Success", message: "New assignment added")
    }
    func determineCategories() -> [String] {
        if classVal?.weights != nil{
            var result = [String]()
            for str in (classVal?.weights)!{
                if str != "New Item"{
                    let splitCategory = str.characters.split{$0 == ":"}.map(String.init)
                    result.append(splitCategory[0])
                }
                
            }
            return result
        }
        return ["Points"]
    }
    func createAlert(title : String, message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    @objc func datePressed(){
        self.view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colors.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return colors[row]
    }
    // When user selects an option, this function will set the text of the text field to reflect
    // the selected option.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        category.text = colors[row]
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
