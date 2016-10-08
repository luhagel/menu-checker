//
//  SettingTableViewCell.swift
//  Menu Checker
//
//  Created by Luca Hagel on 7/18/16.
//  Copyright © 2016 Luca Hagel. All rights reserved.
//

import UIKit

protocol SettingTableViewCellDelegate {
    func toggleOn(_ sender: SettingTableViewCell)
    func toggleOff(_ sender: SettingTableViewCell)
}

class SettingTableViewCell: UITableViewCell {
    var delegate: SettingTableViewCellDelegate?
    
    @IBOutlet weak var seetingNameLabel: UILabel!
    @IBOutlet weak var settingSwitch: UISwitch!
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBAction func settingSwitched(_ sender: AnyObject) {
        if self.settingSwitch.isOn {
            delegate?.toggleOn(self)
        } else {
            delegate?.toggleOff(self)
        }
    }
}
