//
//  SettingsTableViewController.swift
//  Menu Checker
//
//  Created by Luca Hagel on 7/18/16.
//  Copyright © 2016 Luca Hagel. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    @IBOutlet var settingsTableView: UITableView!
    let defaults = NSUserDefaults.standardUserDefaults()
    let allergens = [
        "Milk",
        "Eggs",
        "Fish",
        "Shellfish",
        "TreeNuts",
        "Peanuts",
        "Wheat",
        "Soybeans"
    ]
    
    var customAllergens = [String]()
    var userPrefs = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        userPrefs = defaults.arrayForKey("UserPrefs") as! [String]
        self.settingsTableView.tableFooterView = UIView(frame: CGRectZero)
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Allergens to Filter:"
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allergens.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Setting", forIndexPath: indexPath) as! SettingTableViewCell

        cell.seetingNameLabel.text = allergens[indexPath.row]
        cell.iconImageView.image = UIImage(named: allergens[indexPath.row])
        if isActive(allergens[indexPath.row]) {
            cell.settingSwitch.on = true
        }
        cell.delegate = self

        return cell
    }
    
    func isActive(allergen: String) -> Bool {
        for item in userPrefs {
            if item == allergen {
                return true
            }
        }
        return false
    }
    
    // MARK: - Navigation
    override func viewWillDisappear(animated : Bool) {
        super.viewWillDisappear(animated)
        defaults.setObject(userPrefs, forKey: "UserPrefs")
    }
}

extension SettingsTableViewController : SettingTableViewCellDelegate {
    func toggleOn(sender: SettingTableViewCell) {
        userPrefs += [sender.seetingNameLabel.text!]
        userPrefs = Array(Set(userPrefs))
    }
    func toggleOff(sender: SettingTableViewCell) {
        for (index, allergen) in userPrefs.enumerate() {
            if allergen == sender.seetingNameLabel.text! {
                userPrefs.removeAtIndex(index)
            }
        }
    }
}