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
    
    
    var json: Dictionary<String, AnyObject> = [:]
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeBack))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        if let photo = json as? [String: AnyObject] {
            if let urls = photo["urls"] {
                if let url = urls["full"] as? String{
                    if let data = NSData(contentsOfURL: NSURL(string: url)!) {
                        let image = UIImage(data: data)
                        imageView.image = image
                        //imageView.contentMode = UIViewContentMode.ScaleAspectFill
                    }
                }
            }
            
            if let likes = photo["likes"] {
                likesValue.text = String(likes)
                likesValue.bringSubviewToFront(self.view)
            }
            
            if let date = photo["created_at"] {
                dateValue.text = String(String(date).characters.prefix(10))
            }
            
            if let author = photo["user"] {
                if let name = author["username"] as? String{
                    authorName.text = name
                }
                if let profileImage = author["profile_image"]{
                    if let url = profileImage!["large"] as? String{
                        if let data = NSData(contentsOfURL: NSURL(string: url)!) {
                            let image = UIImage(data: data)
                            authorProfilePicture.image = image
                            authorProfilePicture.frame.size.height = (image?.size.height)!
                            //authorProfilePicture.contentMode = UIViewContentMode.ScaleAspectFit
                        }
                    }
                }
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
    
}
