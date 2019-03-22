//
//  SessionsViewController.swift
//  StudyBuddy
//
//  Created by Local Account 436-25 on 3/7/18.
//  Copyright © 2018 Local Account 436-25. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
class SessionsViewController: UIViewController {

    @IBOutlet weak var sessionTableView: UITableView!
    var ref : DatabaseReference!
    var sessionList = [Session]()
    var selectedSession : String!
    var selectedLocation : String!
    var selectedTime : String!
    var selectedClass : String!
    
    override func viewDidLoad() {
//        sessionTableView.delegate = self
//        sessionTableView.dataSource = self
//        ref = Database.database().reference()
//        fetchSessions()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
//    func fetchSessions(){
//        //var count = 0
//        let uid = Auth.auth().currentUser?.uid
//        ref.child("users").child(uid!).child("sessions").observe(.childAdded) { (snapshot) in
//            print(snapshot)
//            let value = snapshot.value as? NSDictionary
//            print(value)
//            let session = Session()
//            session.name = value?["name"] as! String
//            session.date = value?["date"] as! String
//            session.location = value?["location"] as! String
//            session.classSection = value?["classSection"] as! String
//            session.userID = value?["host"] as! String
//            self.sessionList.append(session)
//            //count += 1
//
//        }
//    }
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return sessionList.count
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
//
////    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        let uid = Auth.auth().currentUser?.uid
////        let cell = sessionTableView.dequeueReusableCell(withIdentifier: "sessionCell") as! SessionTableViewCell
////        let session = sessionList[indexPath.row]
////        if(session.userID == uid){
////            cell.backgroundColor = UIColor(red: 0.66, green: 1.85, blue: 2.44, alpha: 0.5)
////        }
////        cell.sessionLabel.text = session.name
////        cell.locationLabel.text = session.location
////        cell.profileImage.image = UIImage(named: "default.png")
////        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.height / 2
////        return cell
////    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let session = sessionList[indexPath.row]
//        selectedSession = session.name
//        selectedLocation = session.location
//        selectedTime = session.date
//        selectedClass = session.classSection
//        performSegue(withIdentifier: "DetailSessionView", sender: self)
//        //self.navigationController?.pushViewController(DvC, animated: true)
//    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if(segue.identifier == "DetailSessionView"){
//            let vc = segue.destination as! DetailedSessionViewController
//            vc.sessionname = selectedSession!
//            vc.locationName = selectedLocation!
//            vc.time = selectedTime!
//            vc.classSection = selectedClass!
//        }
//    }
//    @IBAction func unwindToSessions(segue: UIStoryboardSegue){
//        fetchSessions()
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
