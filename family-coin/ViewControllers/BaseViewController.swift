//
// Created by Head HandH on 13/05/16.
// Copyright (c) 2016 Sea. All rights reserved.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    
    lazy var firebase: FirebaseManager = {
        return FirebaseManager()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showMessage(title: String?, message: String!) {
        let titleString = title ?? NSLocalizedString("Error", comment: "")
        
        let alert = UIAlertController(title: titleString, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func showError(error: NSError?) {
        let defaultMessage = NSLocalizedString("Something went wrong", comment: "")
        if error == nil {
            self.showMessage(nil, message: defaultMessage)
            return
        }
        
        let message = error!.localizedDescription ?? defaultMessage
        self.showMessage(nil, message: message)
    }
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        activityIndicator.snp_makeConstraints {
            $0.center.equalTo(0)
        }
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    func toMainViewControler() {
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appdelegate.openTasks()
    }
    
    func toStartPage() {
        
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appdelegate.openStartPage()
    }
}

