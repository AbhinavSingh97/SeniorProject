//
//  UserGradeCell.swift
//  StudyBuddy
//
//  Created by Abhinav Singh on 3/10/19.
//  Copyright © 2019 Local Account 436-25. All rights reserved.
//

import UIKit

class UserGradeCell: UITableViewCell {

    @IBOutlet weak var assignmentLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
