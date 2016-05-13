//
//  User.swift
//  family-coin
//
//  Created by Head HandH on 14/05/16.
//  Copyright © 2016 Sea. All rights reserved.
//

import Firebase

class User : Model {
    let name: String
    let userId: String
    let coints: Int
    init(name: String, userId: String) {
        self.name = name
        self.userId = userId
        self.coints = 0
    }
    
    override func attributes() -> [String: AnyObject] {
        return ["name" : self.name,
                "userId": self.userId,
                "coints": self.coints]
    }
}
