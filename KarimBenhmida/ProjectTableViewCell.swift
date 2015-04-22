//
//  ProjectTableViewCell.swift
//  KarimBenhmida
//
//  Created by Karim Benhmida on 22/04/2015.
//  Copyright (c) 2015 Karim Benhmida. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {

    @IBOutlet weak var projectTitle: UILabel!
    @IBOutlet weak var projectPicture: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        projectPicture.layer.borderColor = UIColor(rgba: "#A6A6A6").CGColor;
        projectPicture.layer.borderWidth = 0.5
        projectPicture.layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
