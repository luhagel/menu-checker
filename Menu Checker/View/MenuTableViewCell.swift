//
//  MenuTableViewCell.swift
//  Menu Checker
//
//  Created by Luca Hagel on 7/12/16.
//  Copyright © 2016 Luca Hagel. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    @IBOutlet weak var productNameLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.productNameLabel.text = ""
        let icons = self.contentView.subviews.filter{$0 is UIImageView}
        for icon in icons {
            icon.removeFromSuperview()
        }
    }
}
