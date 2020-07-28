//
//  ViewController.swift
//  TwitterFeels
//
//  Created by Shawn Chandwani on 7/22/20.
//  Copyright © 2020 Shawn Chandwani. All rights reserved.
//

import UIKit
import Swifter

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Instantiation using Twitter's OAuth Consumer Key and secret
        let TWITTER_CONSUMER_KEY = valueForAPIKey(named: "TWITTER_CONSUMER_KEY")
        let TWITTER_CONSUMER_SECRET = valueForAPIKey(named: "TWITTER_CONSUMER_SECRET")
        let swifter = Swifter(consumerKey: TWITTER_CONSUMER_KEY, consumerSecret: TWITTER_CONSUMER_SECRET)
        
    }


    @IBAction func predictPressed(_ sender: UIButton) {
        
    }
    
    func valueForAPIKey(named keyname:String) -> String {
      // Credit to the original source for this technique at
      // http://blog.lazerwalker.com/blog/2014/05/14/handling-private-api-keys-in-open-source-ios-apps
        let filePath = Bundle.main.path(forResource: "Secrets", ofType: "plist")
      let plist = NSDictionary(contentsOfFile:filePath!)
      let value = plist?.object(forKey: keyname) as! String
      return value
    }
}

