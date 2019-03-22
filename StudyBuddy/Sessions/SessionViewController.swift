//
//  SessionViewController.swift
//  StudyBuddy
//
//  Created by Local Account 436-25 on 3/3/18.
//  Copyright © 2018 Local Account 436-25. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import GooglePlaces
class SessionViewController: UIViewController {

    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var classLabel: UITextField!
    @IBOutlet weak var locationLabel: UITextField!
    @IBOutlet weak var dateField: UITextField!
    //@IBOutlet weak var capField: UITextField!
    
    let GoogleSearchPlaceAPIKey = "AIzaSyBtmGgEXIyDUKZcjFe6WUp0ef8MSriPYAY"
    var ref : DatabaseReference!
    var refhandle : DatabaseHandle!
    //let capPicker = UIPickerView()
    let picker = UIDatePicker()
    var longTime : Double!
    override func viewDidLoad() {
        super.viewDidLoad()
        GMSPlacesClient.provideAPIKey(GoogleSearchPlaceAPIKey)
        locationLabel.addTarget(self, action: #selector(myPlaces), for: UIControlEvents.touchDown)
        getDate()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
            }
    @objc func myPlaces(textField: UITextField) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    func getDate(){
        let toolbar = UIToolbar()
        let date = Date()
        toolbar.sizeToFit()
        picker.minimumDate = date
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(datePressed))
        toolbar.setItems([done], animated: false)
        dateField.inputAccessoryView = toolbar
        dateField.inputView = picker
    }
    @objc func datePressed(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        let dateString = formatter.string(from: picker.date)
        longTime = self.picker.date.timeIntervalSince1970
        dateField.text = "\(dateString)"
        self.view.endEditing(true)
    }
    @IBAction func createNewSession(_ sender: Any) {
        let uid = Auth.auth().currentUser?.uid
        ref = Database.database().reference()
        let newSession = ["name":nameLabel.text,
                          "date":dateField.text,
                          "location":locationLabel.text,
                          "classSection":classLabel.text,
                          "timestamp" : longTime,
                          "host" : uid,
                          "uniqueID": NSUUID().uuidString
            ] as [String : Any]
        ref?.child("sessions").childByAutoId().setValue(newSession)
        ref?.child("users").child(uid!).child("sessions").childByAutoId().setValue(newSession)
        createAlert(title: "Success", message: "Your session was successfully created!")
    }
    func createAlert(title : String, message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
extension SessionViewController : GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        locationLabel.text = place.formattedAddress
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    
}
