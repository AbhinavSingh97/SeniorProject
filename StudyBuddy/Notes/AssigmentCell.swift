//
//  AssigmentCell.swift
//  StudyBuddy
//
//  Created by Abhinav Singh on 2/7/19.
//  Copyright © 2019 Local Account 436-25. All rights reserved.
//

import UIKit

class AssigmentCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var cellColor: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
