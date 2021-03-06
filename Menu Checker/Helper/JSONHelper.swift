//
//  JSONHelper.swift
//  Menu Checker
//
//  Created by Luca Hagel on 7/11/16.
//  Copyright © 2016 Luca Hagel. All rights reserved.
//

import Foundation
import SwiftyJSON

class JSONHelper {
    static func pullData() -> JSON { //TODO: Pull only selcted restaurant, pull from server
        let path = Bundle.main.path(forResource: "data", ofType: "json")
        let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path!))
        let json = JSON(data: jsonData!)
        
        return json
    }
}
