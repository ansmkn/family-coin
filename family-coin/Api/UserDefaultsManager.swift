//
// Created by Head HandH on 13/05/16.
// Copyright (c) 2016 Sea. All rights reserved.
//

import Foundation

struct DefaultsKeys {
    static let apiKey = "apiKey"
    static let userId = "userId"
    static let userName = "userName"
    static let isClient = "isClient"
}

class UserDefaultsManager {
    let defaults = NSUserDefaults.standardUserDefaults()
    static let sharedInstance = UserDefaultsManager()

    private var _isClient : Bool = true
    
    init() {
        
    }
    
    var isClient: Bool {
        return userId != nil
    }

    private var _apiKey : String?

    var apiKey: String? {
        set {
            _apiKey = newValue
            defaults.setObject(newValue, forKey: DefaultsKeys.apiKey)
        }
        get {
            if _apiKey == nil {
                _apiKey = defaults.objectForKey(DefaultsKeys.apiKey) as? String
            }
            return _apiKey
        }
    }
    
    private var _userId : String?
    
    var userId: String? {
        set {
            _userId = newValue
            defaults.setObject(newValue, forKey: DefaultsKeys.userId)
        }
        get {
            if _userId == nil {
                _userId = defaults.objectForKey(DefaultsKeys.userId) as? String
            }
            return _userId
        }
    }

    private var _userName : String?
    
    var userName: String? {
        set {
            _userName = newValue
            defaults.setObject(newValue, forKey: DefaultsKeys.userName)
        }
        get {
            if _userName == nil {
                _userName = defaults.objectForKey(DefaultsKeys.userName) as? String
            }
            return _userName
        }
    }
}
