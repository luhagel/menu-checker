//
//  RestaurantTableViewController.swift
//  Menu Checker
//
//  Created by Luca Hagel on 7/12/16.
//  Copyright © 2016 Luca Hagel. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage

class RestaurantTableViewController: UITableViewController {
    @IBOutlet var restaurantTableView: UITableView!
    
    var restaurantData: JSON!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Restaurants"

        restaurantData = JSONHelper.pullData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantData["restaurants"].arrayValue.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RestaurantCell", forIndexPath: indexPath) as! RestaurantTableViewCell
        
        let imageURL = NSURL(string: restaurantData["restaurants"][indexPath.row]["img"].stringValue)!
        cell.restaurantImageView.af_setImageWithURL(imageURL)
        
        let restaurantName = restaurantData["restaurants"][indexPath.row]["restaurant_name"].stringValue
        cell.restaurantNameLabel.text = restaurantName

        return cell
    }

    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowMenu" {
            let destination = segue.destinationViewController as! MenuTableViewController
            if let indexPath = restaurantTableView.indexPathForSelectedRow {
                destination.restaurant = restaurantData["restaurants"][indexPath.row]
            }
        }
    }
}
