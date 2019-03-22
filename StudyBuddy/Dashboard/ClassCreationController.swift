//
//  ClassCreationController.swift
//  StudyBuddy
//
//  Created by Abhinav Singh on 2/10/19.
//  Copyright © 2019 Local Account 436-25. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ClassCreationController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    struct Section {
        var items: [String]
        var collapsed: Bool

        init(items: [String], collapsed: Bool) {
            self.items = items
            self.collapsed = collapsed
        }
    }
    
    @IBOutlet weak var gradeSystem: UITableView!
    @IBOutlet weak var unitsLabel: UITextField!
    @IBOutlet weak var classLabel: UITextField!
    var selectedSection = 0
//    var typeOfGrading = ["Use Point Grading", "Use Percent Grading"]
//    var items = ["Quiz : 40%", "Partcipation : 10%", "Tests : 50%"]
    var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradeSystem.delegate = self
        gradeSystem.dataSource = self
        gradeSystem.estimatedRowHeight = 44
        gradeSystem.rowHeight = UITableViewAutomaticDimension
        gradeSystem.tableFooterView = UIView()
        sections = [
            Section(items: [], collapsed: true),
            Section(items: ["Quiz : 20%", "Partcipation : 10%", "Tests : 50%", "Homework : 20%", "New Item"], collapsed: true)
        ]
        // Do any additional setup after loading the view.
    }
    
    @IBAction func writeToFirebase(_ sender: Any) {
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid

        let key = ref.child("users").child(uid!).child("classes").childByAutoId().key

        let dictionaryTodo = [ "name"    : classLabel.text ,
                               "grade" : 100.0,
                               "units" : Int(unitsLabel.text!)!,
                               "weights" : sections[selectedSection].items,
                               "key" : key] as [String : Any]

        let childUpdates = ["users/\(uid!)/classes/\(key)": dictionaryTodo]
        ref.updateChildValues(childUpdates, withCompletionBlock: { (error, ref) -> Void in
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    @objc func wipeRows() {
        let section = 1
        var indexPaths = [IndexPath]()
        for row in sections[section].items.indices{
            print(section, row)
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        sections[section].collapsed = true
        gradeSystem.deleteRows(at: indexPaths, with: .fade)
        self.selectedSection = 0

//        items.removeAll()
    }
    @objc func addRows() {
        let section = 1
        var indexPaths = [IndexPath]()
        for row in sections[section].items.indices{
            print(section, row)
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        sections[section].collapsed = false
        gradeSystem.insertRows(at: indexPaths, with: .fade)
        self.selectedSection = 1
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44;
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let button = UIButton(type: .system)
        if(section == 0){
            button.setTitle("Point Based System", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor(displayP3Red: 0, green: 148/255, blue: 219/255, alpha: 1.0)
            button.addTarget(self, action: #selector(wipeRows), for: .touchUpInside)
        }
        else{
            button.setTitle("Weight Based System", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor(displayP3Red: 115/255, green: 247/255, blue: 197/255, alpha: 1.0)
            button.addTarget(self, action: #selector(addRows), for: .touchUpInside)

        }
        return button
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sections[section].collapsed == true {
            return 0
        }
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gradeCell") as! TVGradeCell
        if(!sections[indexPath.section].items.isEmpty){
            cell.rowTitle.text = sections[indexPath.section].items[indexPath.row]
        }
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit" {
            
            var path = gradeSystem.indexPathForSelectedRow
            
            let detailViewController = segue.destination as! EditItem
            
            detailViewController.index = path?.row
            detailViewController.modelArray = sections[1].items
            
        }
    }
    @IBAction func saveToMainViewController(segue: UIStoryboardSegue){
        let detailViewController = segue.source as! EditItem
        let index = detailViewController.index
        let modelString = detailViewController.editedModel
        sections[1].items[index!] = modelString!
        gradeSystem.reloadData()
    }
    
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if sections[indexPath.section].collapsed == true{
//            sections[indexPath.section].collapsed == false
//            let opens = IndexSet.init(integer: indexPath.section)
//            tableView.reloadSections(opens, with: .none)
//        }
//        else{
//            sections[indexPath.section].collapsed == true
//            let opens = IndexSet.init(integer: indexPath.section)
//            tableView.reloadSections(opens, with: .none)
//        }
//    }
    

}
