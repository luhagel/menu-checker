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
    
    @IBOutlet weak var bgView: UIView!
    var productInfo: JSON? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = productInfo!["display_name"].stringValue
        
        let blur = UIBlurEffect(style: .Dark)
        let effectView = UIVisualEffectView(effect: blur)
        effectView.frame = bgView.bounds
        effectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.bgView.addSubview(effectView)
        self.bgView.layer.cornerRadius = 10
        self.bgView.layer.masksToBounds = true
        
        let allergensJSONArray = productInfo!["allergens"].arrayValue
        let allergensArray:[String] = allergensJSONArray.map { $0.string!}
        
        allergensLabel.text = allergensArray.joinWithSeparator(", ")
        ingredientsTextView.text = productInfo!["ingredients"].stringValue
    }
}
