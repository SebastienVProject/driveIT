//
//  RessourcesTableViewCell.swift
//  driveIt
//
//  Created by utilisateur on 29/06/2017.
//  Copyright © 2017 SVInfo. All rights reserved.
//

import UIKit

class RessourcesTableViewCell: UITableViewCell {

    @IBOutlet weak var nomLabel: UILabel!
    @IBOutlet weak var prenomLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
