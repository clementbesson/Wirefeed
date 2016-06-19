//
//  Unsplash.swift
//  Wirefeed
//
//  Created by Clement Besson on 6/18/16.
//  Copyright © 2016 Clement Besson. All rights reserved.
//

import Foundation
import UIKit

class Unsplash {
    var urlString: String
    var urlArray: [String] = []

    
    init?(urlString: String) {
        self.urlString = urlString
    }
    
    func getimage() {
        var imageURL = [String]()
        let requestURL: NSURL = NSURL(string: urlString)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
        (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    // Loops trough json object
                    for item in json as! [Dictionary<String, AnyObject>] {
                        if let photo = item as? [String: AnyObject] {
                            // gets id of the photo
                            if let id = photo["id"] as? String{
                                
                                
                                
                            }
                            // gets small image url
                            if let urls = photo["urls"] as? [String: AnyObject] {
                                if let url = urls["small"] as? String{
                                    imageURL.append(url)
                                }
                            }
                        }
                     //completionHandler("finished", nil)
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                    self.urlArray = imageURL
                    print("value in class is \(self.urlArray)")
                    })
                    // goes back to the main thread to update the UI
                    /*dispatch_async(dispatch_get_main_queue(), {
                        print(imageURL)
                        //return imageURL
                    })
                    */
                }
                catch {
                }
            }
        }
        task.resume()
    
    }
}
