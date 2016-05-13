//
//  FirebaseModel.swift
//  family-coin
//
//  Created by Head HandH on 14/05/16.
//  Copyright © 2016 Sea. All rights reserved.
//

import Foundation
import Firebase

class Model: ModelDictionaryProtocol, FirebaseModelProtocol {
    
    var ref: Firebase?
    
    func attributes() -> [String: AnyObject] {
        if ref != nil {
            return ["key": ref!.key];
        }
        return ["key": "null"]
    }
    
    
}
