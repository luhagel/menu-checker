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
        return self.menu[section]["products"].arrayValue.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuTableViewCell

        let productName = restaurant!["menu"][indexPath.section]["products"][indexPath.row]["display_name"].stringValue
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
}
