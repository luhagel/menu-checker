//
//  MenuTableViewController.swift
//  Menu Checker
//
//  Created by Luca Hagel on 7/12/16.
//  Copyright © 2016 Luca Hagel. All rights reserved.
//

import UIKit
import SwiftyJSON
import CellAnimator

class MenuTableViewController: UITableViewController {
    @IBOutlet var menuTableView: UITableView!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    var restaurant: JSON? = nil
    var menu: JSON!
    var filteredMenu: [JSON] = []
    var defaults: NSUserDefaults!
    var userPrefs: [String]!
    
    @IBAction func filterButtonTapped(sender: UIBarButtonItem) {
        if userPrefs.count < 1 {
            performSegueWithIdentifier("ShowSettings", sender: self)
        } else {
            self.filterMenu()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Menu"
        defaults = NSUserDefaults.standardUserDefaults()
        userPrefs = defaults.objectForKey("UserPrefs") as? [String] ?? [String]()
        menu = restaurant!["menu"]
        filterButton.title = "Filter (\(userPrefs.count))"
        let backgroundImage = UIImage(named: "splashscreen")
        let backgroundView = UIImageView(image: backgroundImage)
        self.menuTableView.backgroundView = backgroundView
        self.menuTableView.backgroundView?.contentMode = .ScaleAspectFill
        self.menuTableView.tableFooterView = UIView(frame: CGRectZero)
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
        
        CellAnimator.animateCell(cell, withTransform: CellAnimator.TransformHelix, andDuration: 0.5)
        
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
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let title = UILabel()
        title.textColor = UIColor.whiteColor()
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = title.font
        header.textLabel?.textColor = title.textColor
        header.tintColor = UIColor.orangeColor()
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