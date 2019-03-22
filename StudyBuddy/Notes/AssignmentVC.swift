//
//  AssignmentVC.swift
//  StudyBuddy
//
//  Created by Abhinav Singh on 2/5/19.
//  Copyright © 2019 Local Account 436-25. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
class AssignmentVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var messageTF: UITextField!
    @IBOutlet weak var datePickerOutlet: UIDatePicker!
    @IBOutlet weak var colorChoice: UITextField!
    var assignmentNote : AssignmentObj?
    let colors = ["No Color", "Red", "Blue", "Green"]
    override func viewDidLoad() {
        super.viewDidLoad()
        let pickerView = UIPickerView()
        pickerView.delegate = self
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(datePressed))
        toolbar.setItems([done], animated: false)
        colorChoice.inputAccessoryView = toolbar
        colorChoice.inputView = pickerView
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveAssignment(_ sender: Any) {
        if(assignmentNote == nil){
            assignmentNote = AssignmentObj()
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"

        assignmentNote?.name = self.titleTF.text
        assignmentNote?.message = self.messageTF.text
        assignmentNote?.reminderDate = dateFormatter.string(from: self.datePickerOutlet.date)
        assignmentNote?.color = self.colorChoice.text

        //second section
        
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid

        let key = ref.child("users").child(uid!).child("assignments").childByAutoId().key

        let dictionaryTodo = [ "name"    : assignmentNote!.name! ,
                               "message" : assignmentNote!.message!,
                               "date"    : assignmentNote!.reminderDate!,
                               "color"   : assignmentNote!.color!,
                               "uniqueID": NSUUID().uuidString]

        let childUpdates = ["users/\(uid!)/assignments/\(String(describing: key))": dictionaryTodo]
        ref.updateChildValues(childUpdates, withCompletionBlock: { (error, ref) -> Void in
            self.navigationController?.popViewController(animated: true)
        })
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
        colorChoice.text = colors[row]
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
