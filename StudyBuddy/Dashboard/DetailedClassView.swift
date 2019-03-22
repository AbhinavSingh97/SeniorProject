//
//  DetailedClassView.swift
//  StudyBuddy
//
//  Created by Abhinav Singh on 2/12/19.
//  Copyright © 2019 Local Account 436-25. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FanMenu
import Macaw

class DetailedClassView: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var grades: UITableView!
    @IBOutlet weak var fanMenu: FanMenu!
    @IBOutlet weak var gradeLabel: UILabel!
    var ref : DatabaseReference!
    var classValue : Class?
    var userGrades = [Grade]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        grades.delegate = self
        grades.dataSource = self
        grades.estimatedRowHeight = 80
        grades.rowHeight = UITableViewAutomaticDimension
        if self.classValue != nil {
            className.text = self.classValue?.name
            gradeLabel.text = determineGradeString(gradePercentage: self.classValue?.grade ?? -1.0) + " ~ " + (self.classValue?.grade?.description)! + "%"
            
        }
        fanMenu.button = FanMenuButton(
            id: "main",
            image: "plus.png",
            color: Color(val: 0x77F7CB)
        )
        
        fanMenu.items = [
            FanMenuButton(
                id: "add_grade",
                image: "create_new.png",
                color: Color(val: 0x209EF7)
            ),
            FanMenuButton(
                id: "delete_class",
                image: "trash_white.png",
                color: Color(val: 0x209EF7)
            )
        ]
        fanMenu.menuRadius = 80.0
        fanMenu.duration = 0.2
        fanMenu.radius = 25.0
        fanMenu.interval = (Double.pi, 2 * Double.pi)
        fanMenu.onItemDidClick = {button in
            print("ItemDidClick: \(button.id)")
            if(button.id == "add_grade"){
                let addGrade = self.storyboard!.instantiateViewController(withIdentifier: "addGradeController") as! NewGradeViewController
                addGrade.classVal = self.classValue
                self.navigationController?.pushViewController(addGrade, animated: true)
            }
            else if(button.id == "delete_class"){
                let ref = Database.database().reference()
                let uid = Auth.auth().currentUser?.uid
                
                ref.child("users/\(uid!)/classes/\(String(describing: self.classValue!.uniqueId))").observe(.childAdded){ (snapshot) in
                    snapshot.ref.removeValue()
                }
                self.performSegue(withIdentifier: "unwindToDash", sender: self)
            }
            
        }
        
        fanMenu.backgroundColor = .clear
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchGrades()
        calculateGrade()
    }
    func calculateGrade(){
        if classValue?.weights != nil{
            print("Calculating weight based grade")
            calculatePointGrade()
        }else{
            calculatePointGrade()
        }
    }
    func calculatePointGrade(){
        print("Recomputing grade...")
        let uid = Auth.auth().currentUser?.uid
        var totalPoints = 0.0
        var userPoints = 0.0
        ref = Database.database().reference()
        //        print(classValue?.uniqueId)
        ref.child("users/\(uid!)/classes/\(String(describing: classValue!.uniqueId))/grades").observeSingleEvent(of: .value, with: { (snapshot) in
            if let sessionDict = snapshot.value as? [String:AnyObject] {
                for (_,sessionElement) in sessionDict {
 
                    totalPoints += Double(sessionElement["maxScore"] as! String)!
                    userPoints += Double(sessionElement["userScore"] as! String)!
                }
            }
            if(totalPoints == 0.0){
                self.ref.child("users/\(uid!)/classes/\(String(describing: self.classValue!.uniqueId))").updateChildValues(["grade": 100.0])
                self.gradeLabel.text = " A ~ 100%"
            }else{
                let tempValue = (userPoints/totalPoints) * 100
                let value = Double(round(1000*tempValue)/1000)
                self.ref.child("users/\(uid!)/classes/\(String(describing: self.classValue!.uniqueId))").updateChildValues(["grade": value])
                self.gradeLabel.text = self.determineGradeString(gradePercentage: value) + " ~ " + String(value) + "%"
            }
        }){ (error) in
            print(error.localizedDescription)
        }
    }
    func fetchGrades(){
        //var count = 0
        userGrades.removeAll()
        let uid = Auth.auth().currentUser?.uid
        ref = Database.database().reference()
//        print(classValue?.uniqueId)
        ref.child("users/\(uid!)/classes/\(String(describing: classValue!.uniqueId))/grades").observeSingleEvent(of: .value, with: { (snapshot) in
            if let sessionDict = snapshot.value as? [String:AnyObject] {
                for (_,sessionElement) in sessionDict {
                    print(sessionElement);
                    let tempGrade = Grade()
                    print(sessionElement["name"])
                    tempGrade.name = sessionElement["name"] as! String
                    tempGrade.category = sessionElement["category"] as! String
                    tempGrade.maxScore = Double(sessionElement["maxScore"] as! String)
                    tempGrade.userScore = Double(sessionElement["userScore"] as! String)
                    tempGrade.uniqueId = sessionElement["uniqueID"] as? String
                    tempGrade.percentage = tempGrade.userScore! / tempGrade.maxScore!
                    self.userGrades.append(tempGrade)
                }
            }
            print(self.userGrades.count)
            self.grades.reloadData()

        }) { (error) in
            print(error.localizedDescription)
        }

    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let button = UIButton(type: .system)
    if(section == 0){
        button.setTitle("Grades", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(displayP3Red: 115/255, green: 247/255, blue: 197/255, alpha: 1.0)
    }
    return button
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userGrades.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = grades.dequeueReusableCell(withIdentifier: "userGradeCell") as! UserGradeCell
        let grade = userGrades[indexPath.row]
        cell.assignmentLabel.text = grade.name
        let tempValue = (grade.percentage! * 100)
        let value = Double(round(100*tempValue)/100)
        cell.scoreLabel.text = String(value) + "%"
        return cell
    }
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let delete = deleteAction(at: indexPath)
//        return UISwipeActionsConfiguration(actions: [delete])
//    }
//
//    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
//        let ref = Database.database().reference()
//        let uid = Auth.auth().currentUser?.uid
//        let asgn = userGrades[indexPath.row]
//        let action = UIContextualAction(style: .destructive, title: "Delete"){ (action, view, completion) in
//            self.userGrades.remove(at: indexPath.row)
//            self.grades.deleteRows(at: [indexPath], with: .automatic)
//
//            ref.child("users/\(uid!)/classes/\(String(describing: self.classValue!.uniqueId))/grades").observeSingleEvent(of: .value, with: { (snapshot) in
//                if let sessionDict = snapshot.value as? [String:AnyObject] {
//                    for (_,sessionElement) in sessionDict {
//                        if(asgn.uniqueId == sessionElement["uniqueID"] as? String){
//                            snapshot.ref.removeValue()
//                        }
//                    }
//                }
//                print(self.userGrades.count)
//                self.grades.reloadData()
//
//            })
//            completion(true)
//        }
//
//        action.image = UIImage(named:"trash.png")
//        action.backgroundColor = .red
//
//        return action
//    }
    @IBAction func saveGrade(segue: UIStoryboardSegue){
    }
    func determineGradeString(gradePercentage: Double) -> String{
        if(gradePercentage >= 93.0){
            return "A"
        }
        else if(gradePercentage >= 90){
            return "A-"
        }
        else if(gradePercentage >= 87){
            return "B+"
        }
        else if(gradePercentage >= 83){
            return "B"
        }
        else if(gradePercentage >= 80){
            return "B-"
        }
        else if(gradePercentage >= 77){
            return "C+"
        }else if(gradePercentage >= 73){
            return "C"
        }
        else if(gradePercentage >= 70){
            return "C-"
        }
        else if(gradePercentage >= 67){
            return "D+"
        }
        else if(gradePercentage >= 63){
            return "D"
        }else if(gradePercentage >= 60){
            return "D-"
        }
        else if(gradePercentage >= 0){
            return "F"
        }
        else{
            return "No grade"
        }
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
