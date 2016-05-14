//
//  Task.swift
//  family-coin
//
//  Created by Head HandH on 14/05/16.
//  Copyright © 2016 Sea. All rights reserved.
//

import UIKit

class Task: Model {
    let title: String
    let description: String
    let cost: Int
    let isComplete: Bool
    var key: String?
    var userId: String?
    var userName: String?
    init(title: String, description: String, cost: Int, isComplete: Bool) {
        self.title = title
        self.description = description
        self.cost = cost
        self.isComplete = isComplete
    }
    
    init(attributes: [String: AnyObject]) {
        
        self.title = attributes["title"] as! String
        self.description = attributes["description"] as! String
        self.cost = attributes["cost"] as! Int
        if let key = attributes["key"] {
            self.key = key as? String
        }
        self.isComplete = attributes["isComplete"] as! Bool
        if let id = attributes["userId"] {
            self.userId = id as? String
        }
        if let name = attributes["userName"] {
            self.userName = name as? String
        }
        
        
    }
    
    override func attributes() -> [String: AnyObject] {
        var result = super.attributes() ?? [:]
        result["title"] = self.title
        result["description"] = self.description
        result["cost"] = self.cost
        result["isComplete"] = self.isComplete
        if self.userId != nil {
            result["userId"] = self.userId
        }
        
        if self.userName != nil  {
            result["userName"] = self.userName
        }
        return result
    }
}
