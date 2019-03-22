//
//  DetailedSessionViewController.swift
//  StudyBuddy
//
//  Created by Local Account 436-25 on 3/3/18.
//  Copyright © 2018 Local Account 436-25. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseDatabase

class DetailedSessionViewController: UIViewController {
    
//    var sessionname = String()
//    var locationName = String()
//    var time = String()
//    var classSection = String()
    var currentSession : Session?
    @IBOutlet weak var locLabel: UILabel!
    @IBOutlet weak var sessionName: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(currentSession != nil){
            sessionName.text = currentSession?.name
            locLabel.text = currentSession?.location
            timeLabel.text = currentSession?.date
            classLabel.text = currentSession?.classSection
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func deleteSession(_ sender: Any) {
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        
        ref.child("users").child(uid!).child("sessions").observe(.childAdded){ (snapshot) in
                let value = snapshot.value as? NSDictionary
            if(self.currentSession?.uniqueID == value!["uniqueID"] as? String){
                if(value!["host"] as! String == uid){
                    ref.child("sessions").observe(.childAdded, with: { (snapshot2) in
                        let value2 = snapshot2.value as? NSDictionary
                        if(value2!["host"] as! String == uid && value2!["uniqueID"] as! String == self.currentSession?.uniqueID){
                            snapshot2.ref.removeValue()
                        }
                    })
                }
                snapshot.ref.removeValue()
            }
        }
    }
}
    
//    @IBAction func deleteSession(_ sender: Any) {
//        let ref = Database.database().reference()
//        let uid = Auth.auth().currentUser?.uid
//        ref.child("users").child(uid!).child("sessions").observe(.childAdded) { (snapshot) in
//            let value = snapshot.value as? NSDictionary
//            if(self.sessionname == value!["name"] as! String && self.locationName == value!["location"] as! String){
//                snapshot.ref.removeValue()
//                if(value!["host"] as! String == uid){
//                    print("Removing from database since you're the host")
//                    ref.child("sessions").observe(.childAdded, with: { (snapshot2) in
//                        let value2 = snapshot2.value as? NSDictionary
//                        if(value2!["host"] as! String == uid){
//                            snapshot2.ref.removeValue()
//                        }
//                    })
//
//                    ref.child("users").observe(.childAdded){(snapshotUser) in
//                        if let userValues = snapshotUser.value as? NSDictionary
//                        {
//                            if let sessions = userValues["sessions"] as? NSDictionary{
//                                for session in sessions{
//                                    if let sessionObj = session as? NSDictionary{
//                                        if(sessionObj["host"] as! String == uid){
//                                            snapshotUser.ref.removeValue()
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//                return
//            }
//        }
//        }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
