//
//  RestaurantCollectionViewController.swift
//  Menu Checker
//
//  Created by Luca Hagel on 7/27/16.
//  Copyright © 2016 Luca Hagel. All rights reserved.
//

import UIKit
import SwiftyJSON

private let reuseIdentifier = "Cell"

class RestaurantCollectionViewController: UICollectionViewController {
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet var restaurantCollectionView: UICollectionView!
    
    var restaurantData: JSON!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(RestaurantCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        title = "Restaurants"
        settingsButton.title = "Settings"
        restaurantData = JSONHelper.pullData()

    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMenu" {
            let destination = segue.destination as! MenuTableViewController
            let cell = sender as! RestaurantCollectionViewCell
            if let indexPath = restaurantCollectionView.indexPath(for: cell) {
                destination.restaurant = restaurantData["restaurants"][indexPath.row]
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurantData["restaurants"].arrayValue.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = restaurantCollectionView.dequeueReusableCell(withReuseIdentifier: "RestaurantCell", for: indexPath) as! RestaurantCollectionViewCell
        
        let blur = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: blur)
        effectView.frame = self.view.frame
        cell.addSubview(effectView)
        cell.sendSubview(toBack: effectView)
        
        // Configure the cell
        cell.restaurantImageView?.image = UIImage(named: restaurantData["restaurants"][indexPath.row]["restaurant_name"].stringValue)
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
