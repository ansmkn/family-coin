//
// Created by Head HandH on 13/05/16.
// Copyright (c) 2016 Sea. All rights reserved.
//

import Foundation
import Firebase


struct Urls {
    static let baseUrlString = "https://blinding-torch-7229.firebaseio.com"
    static let usersUrlString = "users"
    static let tasksUrlString = "tasks"
}

class FirebaseManager {

    
    let baseUrl = Firebase(url: Urls.baseUrlString)
    
    lazy var homeUrl: Firebase! = { [unowned self] in
        let defaults = UserDefaultsManager()
        let apiKey = defaults.apiKey!
        return Firebase(url: Urls.baseUrlString + "/" + apiKey)
    }()
    
    private var _usersUrl: Firebase!
    var usersUrl: Firebase {
        get {
            if _usersUrl == nil {
                _usersUrl = self.homeUrl.childByAppendingPath(Urls.usersUrlString)
            }
            return _usersUrl
        }
    }
    
    var userUrl: Firebase? {
        guard let userId = UserDefaultsManager.sharedInstance.userId else {
            return nil;
        }
        return self.userUrl(userId)
    }
    
    func userUrl(userId: String) -> Firebase {
        return usersUrl.childByAppendingPath(userId)
    }
    
    private var _tasksUrl: Firebase!
    var tasksUrl: Firebase {
        get {
            if _tasksUrl == nil {
                _tasksUrl = self.homeUrl.childByAppendingPath(Urls.tasksUrlString)
            }
            return _tasksUrl
        }
    }
    
    func taskUrl(taskId: String) -> Firebase {
        return usersUrl.childByAppendingPath(taskId)
    }
    
    

}
