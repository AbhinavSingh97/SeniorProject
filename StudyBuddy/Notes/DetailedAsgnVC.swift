//
//  DetailedAsgnVC.swift
//  StudyBuddy
//
//  Created by Abhinav Singh on 2/7/19.
//  Copyright © 2019 Local Account 436-25. All rights reserved.
//

import UIKit

class DetailedAsgnVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var assignmentNote : AssignmentObj?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.assignmentNote != nil {
            titleLabel.text = self.assignmentNote?.name
            messageLabel.text = self.assignmentNote?.message
            dateLabel.text = self.assignmentNote?.reminderDate
        }
        
        // Do any additional setup after loading the view.
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
