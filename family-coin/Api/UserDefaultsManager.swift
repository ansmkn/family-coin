//
// Created by Head HandH on 13/05/16.
// Copyright (c) 2016 Sea. All rights reserved.
//

import Foundation

struct DefaultsKeys {
    static let apiKey = "apiKey"
    static let isClient = "isClient"
}

class UserDefaultsManager {
    let defaults = NSUserDefaults.standardUserDefaults()

    private var _isClient : Bool = true
    
    var isClient: Bool {
        set {
            _isClient = newValue
            defaults.setBool(newValue, forKey: DefaultsKeys.isClient)
        }
        get {
            return defaults.boolForKey(DefaultsKeys.isClient)
        }
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

}
