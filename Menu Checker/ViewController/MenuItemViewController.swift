//
//  MenuItemViewController.swift
//  Menu Checker
//
//  Created by Luca Hagel on 7/12/16.
//  Copyright © 2016 Luca Hagel. All rights reserved.
//

import UIKit
import SwiftyJSON

class MenuItemViewController: UIViewController {
    @IBOutlet weak var allergensLabel: UILabel!
    @IBOutlet weak var ingredientsTextView: UITextView!
    
    var productInfo: JSON? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = productInfo!["display_name"].stringValue
        
        let allergensArray = String(productInfo!["allergens"].arrayValue)
        allergensLabel.text = allergensArray
        ingredientsTextView.text = productInfo!["ingredients"].stringValue
    }
}
