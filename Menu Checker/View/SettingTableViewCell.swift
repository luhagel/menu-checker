//
//  SettingTableViewCell.swift
//  Menu Checker
//
//  Created by Luca Hagel on 7/18/16.
//  Copyright © 2016 Luca Hagel. All rights reserved.
//

import UIKit

protocol SettingTableViewCellDelegate {
    func toggleOn(sender: SettingTableViewCell)
    func toggleOff(sender: SettingTableViewCell)
}

class SettingTableViewCell: UITableViewCell {
    var delegate: SettingTableViewCellDelegate?
    
    @IBOutlet weak var seetingNameLabel: UILabel!
    @IBOutlet weak var settingSwitch: UISwitch!
    
    @IBAction func settingSwitched(sender: AnyObject) {
        if self.settingSwitch.on {
            delegate?.toggleOn(self)
        } else {
            delegate?.toggleOff(self)
        }
    }
}
