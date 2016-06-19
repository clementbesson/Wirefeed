//
//  Unsplash.swift
//  Wirefeed
//
//  Created by Clement Besson on 6/18/16.
//  Copyright © 2016 Clement Besson. All rights reserved.
//

import Foundation

protocol UnsplashDelegate: class {
    func unsplash(unsplash: Unsplash, didReceivedData data: [AnyObject])
    func unsplash(unsplash: Unsplash, gotError errorCode: Int)
}

class Unsplash {
    var urlString: String
    var jsonImage = [AnyObject]()
    weak var delegate: UnsplashDelegate?
    
    init(urlString: String) {
        self.urlString = urlString
    }
    
    func getimage() {
        let requestURL: NSURL = NSURL(string: urlString)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            if let httpResponse = response as? NSHTTPURLResponse {
                let statusCode = httpResponse.statusCode
                
                if (statusCode == 200) {
                    do{
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                        // Loops trough json object
                        for item in json as! [Dictionary<String, AnyObject>] {
                            self.jsonImage.append(item)
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            if let delegate = self.delegate {
                                delegate.unsplash(self, didReceivedData: self.jsonImage)
                            }
                        })
                    }
                    catch {
                        
                    }
                } else {
                    if let delegate = self.delegate {
                        delegate.unsplash(self, gotError: statusCode)
                    }
                }
            } else {
                if let delegate = self.delegate {
                    delegate.unsplash(self, gotError: -1)
                }
            }
        }
        task.resume()
    }
}
