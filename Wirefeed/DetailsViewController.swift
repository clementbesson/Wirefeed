//
//  DetailsViewController.swift
//  Wirefeed
//
//  Created by Clement Besson on 6/18/16.
//  Copyright © 2016 Clement Besson. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UnsplashDelegate {   //MARK - Properties
    
    // MARK: - Properties
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var dateValue: UILabel!
    @IBOutlet weak var authorProfilePicture: UIImageView!
    @IBOutlet weak var likesValue: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLogo: UIImageView!
    @IBOutlet weak var liveLogo: NSLayoutConstraint!
    @IBOutlet weak var likeLogo: UIImageView!
    @IBOutlet weak var blurImage: UIImageView!
    @IBOutlet weak var backgroundView: UIImageView!
    
    
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    var loadingView: UIView = UIView()
    var imageArt = UIImage()
    var imageArtist = UIImage()
    var likesText = String()
    var dateText = String()
    var artistText = String()
    var width = Float()
    var height = Float()
    var json: Dictionary<String, AnyObject> = [:]
    var xCount: CGFloat = 0
    var yCount: CGFloat = 0
    var imageCount: Int = 0
    let artView: UIImageView = UIImageView()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        showActivityIndicatory(view)
        self.authorProfilePicture.hidden = true
        self.authorName.hidden = true
        self.imageView.hidden = true
        self.likesValue.hidden = true
        self.likeLogo.hidden = true
        self.dateLogo.hidden = true
        self.dateValue.hidden = true
        self.blurImage.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeBack))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        // MARK: - Unsplash Fetching
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            // do some task
            if let photo = self.json as? [String: AnyObject] {
                if let urls = photo["urls"] {
                    if let url = urls["full"] as? String{
                        if let data = NSData(contentsOfURL: NSURL(string: url)!) {
                            self.imageArt = UIImage(data: data)!
                        }
                        if let widthPhoto = photo["width"] as? Float {
                            if let heightPhoto = photo["height"] as? Float  {
                                self.width = widthPhoto
                                self.height = heightPhoto
                            }
                        }
                        
                    }
                }
                
                if let likes = photo["likes"] {
                    self.likesText = String(likes)
                }
                
                if let date = photo["created_at"] {
                    self.dateText = String(String(date).characters.prefix(10))
                }
                
                if let author = photo["user"] {
                    if let name = author["username"] as? String{
                        self.artistText = name
                    }
                    if let profileImage = author["profile_image"]{
                        if let url = profileImage!["large"] as? String{
                            if let data = NSData(contentsOfURL: NSURL(string: url)!) {
                                let image = UIImage(data: data)
                                self.imageArtist = image!
                            }
                        }
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue()) {
                // update UI
                self.artView.contentMode = UIViewContentMode.ScaleAspectFit
                let ratio = self.height / self.width
                let imageHeight = self.view.frame.width * CGFloat(ratio)
                self.artView.frame.size.width = self.view.frame.width
                self.artView.frame.size.height = imageHeight
                self.artView.center = self.view.center
                self.artView.frame.origin.y = self.view.frame.size.height - self.artView.frame.size.height - self.blurImage.frame.size.height
                self.artView.image = self.imageArt
                self.backgroundView.addSubview(self.artView)
                self.authorProfilePicture.image = self.imageArtist
                self.likesValue.text = self.likesText
                self.dateValue.text = self.dateText
                self.authorName.text = self.artistText
                let url_1 = "https://api.unsplash.com/users/"
                let url_2 = "/photos?per_page=4&client_id=82ffabe0aba9f4e30e7a1f97899b809b829bf69313787a6fcd93c10d871056ee"
                let url = url_1 + self.artistText + url_2
                let instanceOfSplash = Unsplash(urlString: url)
                instanceOfSplash.delegate = self
                instanceOfSplash.getimage()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Unsplash Delegate
    func unsplash(unsplash: Unsplash, didReceivedData data: [AnyObject]){
        //print("unsplash fetched: \(data)")
        
        for item in data as! [Dictionary<String, AnyObject>] {
            if let photo = item as? [String: AnyObject] {
                if let urls = photo["urls"] {
                    if let url = urls["small"] as? String{
                        if let data = NSData(contentsOfURL: NSURL(string: url)!) {
                            let image = UIImage(data: data)
                            let imageView: UIImageView = UIImageView()
                            imageView.image = image
                            imageView.frame.size.width = self.view.frame.width
                            let imageWidth = self.view.frame.size.width/2
                            let imageHeight = (self.view.frame.size.height - self.blurImage.frame.size.height - self.artView.frame.size.height) / 2
                            
                            if self.imageCount  == 0 {
                                xCount = self.view.frame.origin.x
                                yCount = self.view.frame.origin.y
                            } else if self.imageCount  == 1  {
                                xCount = imageWidth
                                yCount = self.view.frame.origin.y
 
                            } else if self.imageCount  == 2 {
                                xCount = self.view.frame.origin.x
                                yCount = imageHeight
                            } else if self.imageCount  == 3 {
                                xCount = imageWidth
                                yCount = imageHeight
                            }
                            imageView.frame.origin.x = xCount
                            imageView.frame.origin.y = yCount
                            imageView.frame.size.height = imageHeight
                            imageView.frame.size.width = imageWidth
                            imageView.contentMode = UIViewContentMode.ScaleAspectFill
                            imageView.clipsToBounds = true
                            
                            self.backgroundView.addSubview(imageView)
                            self.imageCount = self.imageCount + 1
                        }
                    }
                }
            }
        }
        self.authorProfilePicture.hidden = false
        self.authorName.hidden = false
        self.likesValue.hidden = false
        self.likeLogo.hidden = false
        self.dateLogo.hidden = false
        self.dateValue.hidden = false
        self.blurImage.hidden = false
        self.actInd.stopAnimating()
        self.loadingView.hidden = true
    }
    
    func unsplash(unsplash: Unsplash, gotError errorCode: Int) {
        print("got error \(errorCode)")
        
    }
    
    // MARK: - Navigation
    func swipeBack(swipeRecognizer: UISwipeGestureRecognizer) {
        performSegueWithIdentifier("DetailsToList", sender: self)
    }
    
    // MARK: - UI
    func showActivityIndicatory(uiView: UIView) {
        loadingView.frame = CGRectMake(0, 0, 80, 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        actInd.frame = CGRectMake(0.0, 0.0, 40.0, 40.0)
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.WhiteLarge
        actInd.center = CGPointMake(loadingView.frame.size.width / 2,
                                    loadingView.frame.size.height / 2);
        actInd.hidesWhenStopped = true
        loadingView.addSubview(actInd)
        uiView.addSubview(loadingView)
        actInd.startAnimating()
    }
    
    func reloadImage(tapRecognizer: UITapGestureRecognizer) {
       print("image tapped")
    }
}
