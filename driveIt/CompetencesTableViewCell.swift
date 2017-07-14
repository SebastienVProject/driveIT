//
//  CompetencesTableViewCell.swift
//  driveIt
//
//  Created by utilisateur on 09/07/2017.
//  Copyright © 2017 SVInfo. All rights reserved.
//

import UIKit

class CompetencesTableViewCell: UITableViewCell {

    @IBOutlet weak var libelleLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
