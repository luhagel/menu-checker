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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Menu"
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurant!["menu"][0]["products"].arrayValue.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuTableViewCell

        let productName = restaurant!["menu"][0]["products"][indexPath.row]["display_name"].stringValue
        cell.productNameLabel.text = productName
        return cell
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowProduct" {
            let destination = segue.destinationViewController as! MenuItemViewController
            if let indexPath = menuTableView.indexPathForSelectedRow {
                destination.productInfo = restaurant!["menu"][0]["products"][indexPath.row]
            }
        }
    }

}