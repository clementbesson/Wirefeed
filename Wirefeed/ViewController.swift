//
//  ViewController.swift
//  Wirefeed
//
//  Created by Clement Besson on 6/18/16.
//  Copyright © 2016 Clement Besson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UnsplashDelegate {
    
    //MARK - Properties
    @IBOutlet weak var scrollView: UIScrollView!
    var imageMapping = [UIView: AnyObject]()
    var imageJSON: Dictionary<String, AnyObject> = [:]
    var imageURL = [String]()
    var testURL = String()
    var yPosition: CGFloat = 0
    var scrollViewContentSize: CGFloat = 0
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    var loadingView: UIView = UIView()
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        logoView.hidden = true
        headerLabel.hidden = true
        showActivityIndicatory(self.view)
        self.scrollView.frame = view.frame
        //self.scrollView.frame.height = self.view.frame.size.height
        // MARK: - Unsplash Fetching
        let url = "https://api.unsplash.com/photos/?client_id=82ffabe0aba9f4e30e7a1f97899b809b829bf69313787a6fcd93c10d871056ee"
        let instanceOfSplash = Unsplash(urlString: url)
        instanceOfSplash.delegate = self
        instanceOfSplash.getimage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Unsplash Delegate
    func unsplash(unsplash: Unsplash, didReceivedData data: [AnyObject]){
        
        // TODO: update UI
        for item in data as! [Dictionary<String, AnyObject>] {
            if let photo = item as? [String: AnyObject] {
                if let urls = photo["urls"] {
                    if let url = urls["small"] as? String{
                        if let data = NSData(contentsOfURL: NSURL(string: url)!) {
                            let image = UIImage(data: data)
                            let imageView: UIImageView = UIImageView()
                            let singleTap = UITapGestureRecognizer(target: self, action: #selector(imageDetail))
                            singleTap.numberOfTapsRequired = 1
                            imageView.image = image
                            imageView.contentMode = UIViewContentMode.ScaleAspectFit
                            imageView.frame.size.width = self.view.frame.width
                            if let width = photo["width"] as? Float {
                                if let height = photo["height"] as? Float  {
                                    let ratio = height / width
                                    let imageHeight = self.view.frame.width * CGFloat(ratio)
                                    imageView.frame.size.height = imageHeight
                                }
                            }
                            imageView.center = self.view.center
                            imageView.frame.origin.x = 0
                            imageView.frame.origin.y = self.yPosition
                            imageView.addGestureRecognizer(singleTap)
                            imageView.userInteractionEnabled = true
                            imageMapping.updateValue(item, forKey: imageView)
                            self.scrollView.addSubview(imageView)
                            self.yPosition += imageView.frame.size.height
                            self.scrollViewContentSize += imageView.frame.size.height
                            self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollViewContentSize)
                            actInd.stopAnimating()
                            loadingView.hidden = true
                            logoView.hidden = false
                            headerLabel.hidden = false
                        }
                    }
                }
            }
        }
        
    }
    
    func unsplash(unsplash: Unsplash, gotError errorCode: Int) {
        print("got error \(errorCode)")
    }

    // MARK: - Navigation
    func imageDetail(tapRecognizer: UITapGestureRecognizer) {
        if let selectedJSON = imageMapping[tapRecognizer.view!] as? Dictionary<String, AnyObject> {
            imageJSON = selectedJSON
            performSegueWithIdentifier("ListToDetails", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "ListToDetails") {
            let detailViewController = segue.destinationViewController as! DetailsViewController
            detailViewController.json = imageJSON
        }
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

