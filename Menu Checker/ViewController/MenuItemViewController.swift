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
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var bgView: UIView!
    
    var productInfo: JSON? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = productInfo!["display_name"].stringValue
        
        let blur = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: blur)
        effectView.frame = bgView.bounds
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.bgView.addSubview(effectView)
        self.bgView.layer.cornerRadius = 10
        self.bgView.layer.masksToBounds = true
        self.view.sendSubview(toBack: bgImageView)
        
        let allergensJSONArray = productInfo!["allergens"].arrayValue
        let allergensArray:[String] = allergensJSONArray.map { $0.string!}
        allergensLabel.text = allergensArray.joined(separator: ", ")
        
        ingredientsTextView.text = productInfo!["ingredients"].stringValue
    }
}
