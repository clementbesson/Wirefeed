//
//  ViewController.swift
//  Wirefeed
//
//  Created by Clement Besson on 6/18/16.
//  Copyright © 2016 Clement Besson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //MARK - Properties
    @IBOutlet weak var imageTest: UIImageView!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!

    
    var imageURL = [String]()
    var width = [Int]()
    var height = [Int]()
    var testURL = String()
    var yPosition: CGFloat = 0
    var scrollViewContentSize: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getData(){
        //let requestURL: NSURL = NSURL(string: "http://www.learnswiftonline.com/Samples/subway.json")!
        let requestURL: NSURL = NSURL(string: "https://api.unsplash.com/photos/?client_id=82ffabe0aba9f4e30e7a1f97899b809b829bf69313787a6fcd93c10d871056ee")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        
        
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    
                    // gets items from JSON object
                    for item in json as! [Dictionary<String, AnyObject>] {
                        if let photo = item as? [String: AnyObject] {
                            // gets width of the photo
                            if let width = photo["width"] as? Int{
                                self.width.append(width)
                            }
                            // gets height of the photo
                            if let height = photo["height"] as? Int{
                                self.height.append(height)
                            }
                            // gets url of the photo
                            if let urls = photo["urls"] as? [String: AnyObject] {
                                if let url = urls["small"] as? String{
                                    self.imageURL.append(url)
                                }
                            }
                        }
                    }
                    print(self.width)
                    print(self.height)
                    self.testURL = self.imageURL[0]
                    
                    // goes back to the main thread to update the UI
                    dispatch_async(dispatch_get_main_queue(), {

                        for urlString in self.imageURL {
                            
                            if let url = NSURL(string: urlString) {
                                if let data = NSData(contentsOfURL: url) {
                                    let image = UIImage(data: data)
                                    let imageView: UIImageView = UIImageView()
                                    imageView.image = image
                                    imageView.contentMode = UIViewContentMode.ScaleAspectFit
                                    imageView.frame.size.width = self.view.frame.width
                                    imageView.frame.size.height = 300
                                    imageView.center = self.view.center
                                    imageView.frame.origin.x = 0
                                    imageView.frame.origin.y = self.yPosition
                                    
                                    self.scrollView.addSubview(imageView)
                                    
                                    self.yPosition += imageView.frame.size.height  + 20
                                    self.scrollViewContentSize += imageView.frame.size.height  + 20
                            
                                    self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollViewContentSize)
                                }
                            }
                            
                        }
                        
                        
                        
                    })
                }
                catch {
                }
            }
        }
        task.resume()
    }

}

