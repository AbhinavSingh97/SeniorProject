//
//  UserSessionsViewController.swift
//  StudyBuddy
//
//  Created by Abhinav Singh on 2/1/19.
//  Copyright © 2019 Local Account 436-25. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FanMenu
import Macaw

class UserSessionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
//    @IBOutlet weak var fanMenu: FanMenu!
    @IBOutlet weak var sessionsTable: UITableView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var joinButton: UIButton!
    var ref : DatabaseReference!
    var sessionList = [Session]()
    var selectedSession : String!
    var selectedLocation : String!
    var selectedTime : String!
    var selectedClass : String!
    @IBOutlet weak var fanMenu: FanMenu!
    override func viewDidLoad() {
        sessionsTable.delegate = self
        sessionsTable.dataSource = self
        fanMenu.button = FanMenuButton(
            id: "main",
            image: "plus",
            color: Color(val: 0x25FAC8)
        )
        
        fanMenu.items = [
            FanMenuButton(
                id: "add_session",
                image: "search.png",
                color: Color(val: 0xF55B58)
            ),
            FanMenuButton(
                id: "create_session",
                image: "create_new.png",
                color: Color(val: 0xF55B58)
            ),
            
        ]
        fanMenu.menuRadius = 100.0
        fanMenu.duration = 0.2
        fanMenu.radius = 25.0
        fanMenu.onItemDidClick = {button in
            print("ItemDidClick: \(button.id)")
            if(button.id == "create_session"){
                // Segue to the add controller
                let addSession = self.storyboard!.instantiateViewController(withIdentifier: "addSessionController") as! SessionViewController
                    addSession.title = " New Session"
                self.navigationController?.pushViewController(addSession, animated: true)
            }
            else if(button.id == "add_session"){
                //Segue to the sessions controller
                
                let joinSession = self.storyboard!.instantiateViewController(withIdentifier: "joinSession") as! GoogleMapViewController
                joinSession.title = "Sessions"
                self.navigationController?.pushViewController(joinSession, animated: true)
            }
        }
        
        fanMenu.backgroundColor = .clear
        ref = Database.database().reference()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchSessions()
    }
    func fetchSessions(){
        //var count = 0
        sessionList.removeAll()
        let uid = Auth.auth().currentUser?.uid
        ref = Database.database().reference()
        ref.child("users").child(uid!).child("sessions").observeSingleEvent(of: .value, with: { (snapshot) in
            if let sessionDict = snapshot.value as? [String:AnyObject] {
                for (_,sessionElement) in sessionDict {
                    //                    print(todoElement);
                    let session = Session()
                    session.name = sessionElement["name"] as? String
                    session.date = sessionElement["date"] as? String
                    session.location = sessionElement["location"] as? String
                    session.classSection = sessionElement["classSection"] as? String
                    session.hostID = sessionElement["host"] as? String
                    session.uniqueID = sessionElement["uniqueID"] as? String 
                    
                    self.sessionList.append(session)
                }
            }
            self.sessionsTable.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        print("Got the session data")
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessionList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = sessionsTable.dequeueReusableCell(withIdentifier: "sessionCell") as! UserSessionCell
        let session = sessionList[indexPath.row]
        cell.sessionTitle.text = session.name
        cell.locLabel.text = session.location
        cell.dateLabel.text = session.date
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sessionVC = self.storyboard!.instantiateViewController(withIdentifier: "DetailedSession") as! DetailedSessionViewController
       sessionVC.currentSession = sessionList[indexPath.row]
        self.navigationController?.pushViewController(sessionVC, animated: true)
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if(segue.identifier == "DetailedSessionViewController"){
//            let vc = segue.destination as! DetailedSessionViewController
//            vc.sessionname = selectedSession!
//            vc.locationName = selectedLocation!
//            vc.time = selectedTime!
//            vc.classSection = selectedClass!
//        }
//    }
    @IBAction func unwindToSessions(segue: UIStoryboardSegue){
        fetchSessions()
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
