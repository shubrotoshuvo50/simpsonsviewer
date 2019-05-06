//
//  dataTableViewCell.swift
//  simpsonsviewer
//
//  Created by IMCS2 on 5/3/19.
//  Copyright © 2019 Shubroto. All rights reserved.
//

import UIKit

class dataTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
