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
    var listToDisplay: [JSON] = []
    
    @IBAction func filterButtonTapped(sender: UIBarButtonItem) {
        if userPrefs.count < 1 {
            performSegueWithIdentifier("ShowSettings", sender: self)
            userPrefs = defaults.objectForKey("UserPrefs") as? [String] ?? [String]()
            filterButton.title = "Filter (\(userPrefs.count))"
        } else {
            self.filterMenu()
            self.menuTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaults = NSUserDefaults.standardUserDefaults()
        userPrefs = defaults.objectForKey("UserPrefs") as? [String] ?? [String]()
        menu = restaurant!["menu"]
        
        title = "Menu"
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
            return self.filteredMenu[section]["products"].arrayValue.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuTableViewCell
        
        let icons = cell.contentView.subviews.filter{$0 is UIImageView}
        for icon in icons {
            icon.removeFromSuperview()
        }
        
        CellAnimator.animateCell(cell, withTransform: CellAnimator.TransformTipIn, andDuration: 0.5)
        
        if filteredMenu.count == 0 {
            self.listToDisplay = self.menu.arrayValue
        } else {
            self.listToDisplay = self.filteredMenu
        }

        let productName = listToDisplay[indexPath.section]["products"][indexPath.row]["display_name"].stringValue
        cell.productNameLabel.text = productName
        cell.productNameLabel.sizeToFit()
        if cell.contentView.subviews.filter({$0 is UIImageView}).count < 1 {
            let allergensArray = self.listToDisplay[indexPath.section]["products"][indexPath.row]["allergens"].arrayValue
            var newIconXPos = cell.productNameLabel.frame.width + 20
            for allergen in allergensArray {
                let allergenIcon = UIImageView(image: UIImage(named: allergen.stringValue))
                allergenIcon.frame = CGRect(x: newIconXPos, y: 10, width: 25, height: 25)
                allergenIcon.backgroundColor = UIColor.whiteColor()
                allergenIcon.layer.cornerRadius = 3
                allergenIcon.layer.masksToBounds = true
                cell.contentView.addSubview(allergenIcon)
                newIconXPos += 27
            }
        }
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
        
        let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        let jsonObject = JSON(data: data!)
        filteredMenu = jsonObject["menu"].arrayValue
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