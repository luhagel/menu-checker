//
//  RestaurantCollectionViewController.swift
//  Menu Checker
//
//  Created by Luca Hagel on 7/27/16.
//  Copyright © 2016 Luca Hagel. All rights reserved.
//

import UIKit
import SwiftyJSON
import AlamofireImage
import FontAwesome_swift

private let reuseIdentifier = "Cell"

class RestaurantCollectionViewController: UICollectionViewController {
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet var restaurantCollectionView: UICollectionView!
    
    var restaurantData: JSON!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.registerClass(RestaurantCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        title = "Restaurants"
        let attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(20)] as Dictionary!
        settingsButton.setTitleTextAttributes(attributes, forState: .Normal)
        settingsButton.title = String.fontAwesomeIconWithName(.Cog)
        restaurantData = JSONHelper.pullData()

    }

    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowMenu" {
            let destination = segue.destinationViewController as! MenuTableViewController
            let cell = sender as! RestaurantCollectionViewCell
            if let indexPath = restaurantCollectionView.indexPathForCell(cell) {
                destination.restaurant = restaurantData["restaurants"][indexPath.row]
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurantData["restaurants"].arrayValue.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = restaurantCollectionView.dequeueReusableCellWithReuseIdentifier("RestaurantCell", forIndexPath: indexPath) as! RestaurantCollectionViewCell
        
        let blur = UIBlurEffect(style: .Dark)
        let effectView = UIVisualEffectView(effect: blur)
        effectView.frame = self.view.frame
        cell.addSubview(effectView)
        cell.sendSubviewToBack(effectView)
        
        // Configure the cell
        let imageURL = NSURL(string: restaurantData["restaurants"][indexPath.row]["img"].stringValue)!
        cell.restaurantImageView?.af_setImageWithURL(imageURL)
        cell.restaurantImageView.layer.cornerRadius = 5;
        cell.restaurantImageView.clipsToBounds = true;
        
        let restaurantName = restaurantData["restaurants"][indexPath.row]["restaurant_name"].stringValue
        cell.restaurantNameLabel?.text = restaurantName
//        if imageURL.absoluteString == "" {
//            print("center")
//            let newTopConstraint = NSLayoutConstraint(item: cell.restaurantNameLabel, attribute: .CenterX, relatedBy: .Equal, toItem: cell.contentView, attribute: .CenterX, multiplier: 1, constant: 1)
//            cell.restaurantNameLabel.addConstraint(newTopConstraint)
//        }
        
        return cell
    }
}
