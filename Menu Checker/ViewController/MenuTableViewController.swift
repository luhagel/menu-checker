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
    
    var restaurant: JSON? = nil
    var menu: JSON!
    var filteredMenu: [JSON] = []
    
    @IBAction func filterButtonTapped(sender: UIBarButtonItem) {
        self.filterMenu()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Menu"
        menu = restaurant!["menu"]
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.menu.arrayValue.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredMenu.count == 0 {
            return self.menu[section]["products"].arrayValue.count
        } else {
            return filteredMenu[section]["products"].arrayValue.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuTableViewCell
        
        var listToDisplay: [JSON]
        if filteredMenu.count == 0 {
            listToDisplay = self.menu.arrayValue
        } else {
            listToDisplay = self.filteredMenu
        }

        let productName = listToDisplay[indexPath.section]["products"][indexPath.row]["display_name"].stringValue
        cell.productNameLabel.text = productName
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.menu[section]["category_name"].stringValue
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowProduct" {
            let destination = segue.destinationViewController as! MenuItemViewController
            if let indexPath = menuTableView.indexPathForSelectedRow {
                destination.productInfo = self.menu[indexPath.section]["products"][indexPath.row]
            }
        }
    }
    
    //MARK: Methods
    func filterMenu() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let userPrefs = defaults.objectForKey("UserPrefs") as? [String] ?? [String]()
        print(userPrefs)
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
        
        let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        let jsonObject = JSON(data: data!)
        filteredMenu = jsonObject["menu"].arrayValue
        menuTableView.reloadData()
    }
    
    func isAllergic(allergens: [JSON], userPrefs: [String]) -> Bool {
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