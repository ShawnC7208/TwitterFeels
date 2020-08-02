//
//  ViewController.swift
//  TwitterFeels
//
//  Created by Shawn Chandwani on 7/22/20.
//  Copyright © 2020 Shawn Chandwani. All rights reserved.
//

import UIKit
import Swifter
import CoreML
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    let sentimentClassifier = TweetSentimentClassifer()
    
    lazy var TWITTER_CONSUMER_KEY = valueForAPIKey(named: "TWITTER_CONSUMER_KEY")
    lazy var TWITTER_CONSUMER_SECRET = valueForAPIKey(named: "TWITTER_CONSUMER_SECRET")
    lazy var swifter = Swifter(consumerKey: TWITTER_CONSUMER_KEY, consumerSecret: TWITTER_CONSUMER_SECRET)
    var tweets = [TweetSentimentClassiferInput]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Instantiation using Twitter's OAuth Consumer Key and secret
        
    }


    @IBAction func predictPressed(_ sender: UIButton) {
        if let safeText = textField.text {
            var sentimentScore = 0
            swifter.searchTweet(using: safeText, lang: "en", count: 100, tweetMode: TweetMode.extended, success: { (results, metadata) in
                for tweet in results.array! {
                    if let tweetText = tweet["full_text"].string {
                        self.tweets.append(TweetSentimentClassiferInput(text: tweetText))
                    }
                }
                let predictions = try! self.sentimentClassifier.predictions(inputs: self.tweets)
                for prediction in predictions {
                    if prediction.label == "Neg" {
                        sentimentScore -= 1
                    }
                    else if prediction.label == "Pos" {
                        sentimentScore += 1
                    }
                }
                print(sentimentScore)
                if sentimentScore > 10 {
                    self.sentimentLabel.text = "😍"
                }
                else if sentimentScore > 5 {
                    self.sentimentLabel.text = "😀"
                }
                else if sentimentScore < -10 && sentimentScore >= -19 {
                    self.sentimentLabel.text = "😕"
                }
                else if sentimentScore < -20 && sentimentScore >= -29 {
                    self.sentimentLabel.text = "☹️"
                }
                else if sentimentScore < -30 && sentimentScore >= -39 {
                    self.sentimentLabel.text = "😩"
                }
                else if sentimentScore < -40 && sentimentScore >= -49 {
                    self.sentimentLabel.text = "😡"
                }
                else if sentimentScore < -50 {
                    self.sentimentLabel.text = "🤬"
                }
                else {
                    self.sentimentLabel.text = "😐"
                }
            }) { (error) in
                print(error)
            }
        }
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

