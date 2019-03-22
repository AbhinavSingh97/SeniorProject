//
//  AssignmentsTableVC.swift
//  StudyBuddy
//
//  Created by Abhinav Singh on 2/7/19.
//  Copyright © 2019 Local Account 436-25. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
class AssignmentsTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var allAssignments = [AssignmentObj]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        loadData()
    }
    
    func loadData(){
        self.allAssignments.removeAll()
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        ref.child("users/\(uid!)/assignments").observeSingleEvent(of: .value, with: { (snapshot) in
            if let todoDict = snapshot.value as? [String:AnyObject] {
                for (_,todoElement) in todoDict {
//                    print(todoElement);
                    let todo = AssignmentObj()
                    todo.name = todoElement["name"] as? String
                    todo.message = todoElement["message"] as? String
                    todo.reminderDate = todoElement["date"] as? String
                    todo.color = todoElement["color"] as? String
                    todo.uniqueId = todoElement["uniqueID"] as? String
                    self.allAssignments.append(todo)
                }
            }
            self.allAssignments.sort { (first, second) -> Bool in
                guard let firstRank = first.name?.lowercased() else { return true }
                guard let secondRank = second.name?.lowercased() else { return false }
                return firstRank < secondRank
            }
            self.tableView.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allAssignments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "assignmentCell") as! AssigmentCell
        let color = allAssignments[indexPath.row].color
        cell.title?.text = allAssignments[indexPath.row].name
        if(color == "Red"){
            cell.cellColor.backgroundColor = UIColor .red
        }
        else if(color == "Blue"){
            cell.cellColor.backgroundColor = UIColor .blue
        }
        else if(color == "Green"){
            cell.cellColor.backgroundColor = UIColor .green
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let asgnTVC = self.storyboard!.instantiateViewController(withIdentifier: "DetailAssignmentView") as! DetailedAsgnVC
        asgnTVC.assignmentNote = allAssignments[indexPath.row]
        self.navigationController?.pushViewController(asgnTVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        let asgn = allAssignments[indexPath.row]
        let action = UIContextualAction(style: .destructive, title: "Delete"){ (action, view, completion) in
            self.allAssignments.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            ref.child("users").child(uid!).child("assignments").observe(.childAdded){ (snapshot) in
                let value = snapshot.value as? NSDictionary
                if(asgn.uniqueId == value!["uniqueID"] as? String){
                    snapshot.ref.removeValue()
                }
            }
            completion(true)
        }
        action.image = UIImage(named:"trash.png")
        action.backgroundColor = .red
        
        return action
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
