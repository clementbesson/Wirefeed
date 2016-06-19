//
//  DetailsViewController.swift
//  Wirefeed
//
//  Created by Clement Besson on 6/18/16.
//  Copyright © 2016 Clement Besson. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {   //MARK - Properties
    
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
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    var loadingView: UIView = UIView()
    var imageArt = UIImage()
    var imageArtist = UIImage()
    var likesText = String()
    var dateText = String()
    var artistText = String()
    var json: Dictionary<String, AnyObject> = [:]
    
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

        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            // do some task
            if let photo = self.json as? [String: AnyObject] {
                if let urls = photo["urls"] {
                    if let url = urls["full"] as? String{
                        if let data = NSData(contentsOfURL: NSURL(string: url)!) {
                            self.imageArt = UIImage(data: data)!
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
                self.imageView.image = self.imageArt
                self.authorProfilePicture.image = self.imageArtist
                self.likesValue.text = self.likesText
                self.dateValue.text = self.dateText
                self.authorName.text = self.artistText
                self.authorProfilePicture.hidden = false
                self.authorName.hidden = false
                self.imageView.hidden = false
                self.likesValue.hidden = false
                self.likeLogo.hidden = false
                self.dateLogo.hidden = false
                self.dateValue.hidden = false
                self.blurImage.hidden = false
                self.actInd.stopAnimating()
                self.loadingView.hidden = true
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
}
