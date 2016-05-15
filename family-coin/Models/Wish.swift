//
//  Wish.swift
//  family-coin
//
//  Created by Head HandH on 15/05/16.
//  Copyright © 2016 Sea. All rights reserved.
//

import Foundation

class Wish: Model {

    var uiid: String!
    var title: String!
    var description: String!
    var cost: Int?
    var isConfirm: Bool!
    var userId: String!
    var userName: String!
    
    init(uiid: String, title: String, description: String, userId: String, userName: String) {
        self.uiid = uiid
        self.title = title
        self.description = description
        self.userId = userId
        self.userName = userName
        self.isConfirm = false
    }
    
    init(attributes: [String: AnyObject]) {
        
        self.uiid = attributes["uiid"] as! String
        self.title = attributes["title"] as! String
        self.description = attributes["description"] as! String
        self.userId = attributes["userId"] as! String
        self.userName = attributes["userName"] as! String
        self.isConfirm = attributes["isConfirm"] as! Bool
        
        if let cost = attributes["cost"]  {
            self.cost = cost as? Int
        }
        
    }
    
    override func attributes() -> [String: AnyObject] {
        var result: [String: AnyObject] = [:]
        
        result["uiid"] = self.uiid
        result["title"] = self.title
        result["description"] = self.description
        result["userId"] = self.userId
        result["userName"] = self.userName
        result["isConfirm"] = self.isConfirm
        if let _ = self.cost {
            result["cost"] = cost!
        }
        return result
    }
}
