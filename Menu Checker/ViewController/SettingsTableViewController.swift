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
    let defaults = UserDefaults.standard
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
        userPrefs = defaults.array(forKey: "UserPrefs") as! [String]
        self.settingsTableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Allergens to Filter:"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allergens.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Setting", for: indexPath) as! SettingTableViewCell

        cell.seetingNameLabel.text = allergens[(indexPath as NSIndexPath).row]
        cell.iconImageView.image = UIImage(named: allergens[(indexPath as NSIndexPath).row])
        if isActive(allergens[(indexPath as NSIndexPath).row]) {
            cell.settingSwitch.isOn = true
        }
        cell.delegate = self

        return cell
    }
    
    func isActive(_ allergen: String) -> Bool {
        for item in userPrefs {
            if item == allergen {
                return true
            }
        }
        return false
    }
    
    // MARK: - Navigation
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        defaults.set(userPrefs, forKey: "UserPrefs")
    }
}

extension SettingsTableViewController : SettingTableViewCellDelegate {
    func toggleOn(_ sender: SettingTableViewCell) {
        userPrefs += [sender.seetingNameLabel.text!]
        userPrefs = Array(Set(userPrefs))
    }
    func toggleOff(_ sender: SettingTableViewCell) {
        for (index, allergen) in userPrefs.enumerated() {
            if allergen == sender.seetingNameLabel.text! {
                userPrefs.remove(at: index)
            }
        }
    }
}
