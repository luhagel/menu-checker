//
//  MenuTableViewController.swift
//  Menu Checker
//
//  Created by Luca Hagel on 7/12/16.
//  Copyright © 2016 Luca Hagel. All rights reserved.
//

import UIKit
import SwiftyJSON

class MenuTableViewController: UITableViewController {
    @IBOutlet var menuTableView: UITableView!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    var restaurant: JSON?       = []
    var filteredMenu: [JSON]    = []
    var listToDisplay: [JSON]   = []
    var defaults: UserDefaults!
    var userPrefs: [String]!
    var menu: JSON!
    
    @IBAction func filterButtonTapped(_ sender: UIBarButtonItem) {
        if userPrefs.count < 1 {
            performSegue(withIdentifier: "ShowSettings", sender: self)
            userPrefs = defaults.object(forKey: "UserPrefs") as? [String] ?? [String]()
            filterButton.title = "Filter (\(userPrefs.count))"
        } else {
            self.filterMenu()
            self.menuTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaults = UserDefaults.standard
        userPrefs = defaults.object(forKey: "UserPrefs") as? [String] ?? [String]()
        menu = restaurant!["menu"]
        
        title = "Menu"
        filterButton.title = "Filter (\(userPrefs.count))"
        
        let backgroundImage = UIImage(named: "splashscreen")
        let backgroundView = UIImageView(image: backgroundImage)
        self.menuTableView.backgroundView = backgroundView
        self.menuTableView.backgroundView?.contentMode = .scaleAspectFill
        
        self.menuTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userPrefs = defaults.object(forKey: "UserPrefs") as? [String] ?? [String]()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.menu.arrayValue.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredMenu.count == 0 {
            return self.menu[section]["products"].arrayValue.count
        } else {
            return self.filteredMenu[section]["products"].arrayValue.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuTableViewCell
        
        if filteredMenu.count == 0 {
            self.listToDisplay = self.menu.arrayValue
        } else {
            self.listToDisplay = self.filteredMenu
        }

        let productName = listToDisplay[indexPath.section]["products"][indexPath.row]["display_name"].stringValue.trunc(22, trailing: "...")
        cell.productNameLabel.text = productName
        cell.productNameLabel.sizeToFit()
        if cell.contentView.subviews.filter({$0 is UIImageView}).count < 1 {
            let allergensArray = self.listToDisplay[indexPath.section]["products"][indexPath.row]["allergens"].arrayValue
            var newIconXPos = cell.productNameLabel.frame.width + 20
            for allergen in allergensArray {
                let allergenIcon = UIImageView(image: UIImage(named: allergen.stringValue))
                allergenIcon.frame = CGRect(x: newIconXPos, y: 10, width: 25, height: 25)
                allergenIcon.backgroundColor = UIColor.white
                allergenIcon.layer.cornerRadius = 3
                allergenIcon.layer.masksToBounds = true
                cell.contentView.addSubview(allergenIcon)
                newIconXPos += 27
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.menu[section]["category_name"].stringValue
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let title = UILabel()
        title.textColor = UIColor.white
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = title.font
        header.textLabel?.textColor = title.textColor
        header.tintColor = UIColor.orange
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowProduct" {
            let destination = segue.destination as! MenuItemViewController
            if let indexPath = menuTableView.indexPathForSelectedRow {
                destination.productInfo = self.listToDisplay[indexPath.section]["products"][indexPath.row]
            }
        }
    }
    
    //MARK: Methods
    func filterMenu() {
        var jsonString: String = ""
        var categoriesJsonString: String = ""
        for category in self.menu.arrayValue {
            if !categoriesJsonString.isEmpty {
               categoriesJsonString += ","
            }
            let categoryName = category["category_name"].stringValue
            let productsArray = category["products"].arrayValue
            let filteredProductsArray = productsArray.filter({!isAllergic($0["allergens"].arrayValue, userPrefs: userPrefs)})
            categoriesJsonString += "{\"category_name\": \"\(categoryName)\", \"products\": \(filteredProductsArray)}"
        }
        
        jsonString = "{\"menu\":[\(categoriesJsonString)]}"
        
        let data = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false)
        let jsonObject = JSON(data: data!)
        filteredMenu = jsonObject["menu"].arrayValue
    }
    
    func isAllergic(_ allergens: [JSON], userPrefs: [String]) -> Bool {
        for allergen in allergens {
            for pref in userPrefs {
                if pref == allergen.stringValue {
                    return true
                }
            }
        }
        return false
    }
}

extension String {
    func trunc(_ length: Int, trailing: String? = "...") -> String {
        if self.characters.count > length {
            return self.substring(to: self.characters.index(self.startIndex, offsetBy: length)) + (trailing ?? "")
        } else {
            return self
        }
    }
}
