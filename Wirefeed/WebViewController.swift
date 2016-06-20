//
//  WebViewController.swift
//  Wirefeed
//
//  Created by Clement Besson on 6/19/16.
//  Copyright © 2016 Clement Besson. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    //MARK: - Properties
    @IBOutlet weak var webView: UIWebView!
    var imageJSON: Dictionary<String, AnyObject> = [:]
    var portfolioURL = String()
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    var loadingView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        webView.hidden = true
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeBack))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        let url = NSURL(string: portfolioURL)
        let urlRequest = NSURLRequest(URL: url!)
        webView.loadRequest(urlRequest)
        showActivityIndicatory(view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
     func swipeBack(swipeRecognizer: UISwipeGestureRecognizer) {
     performSegueWithIdentifier("PortofolioToDetails", sender: self)
     }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "PortofolioToDetails") {
            let detailViewController = segue.destinationViewController as! DetailsViewController
            detailViewController.json = imageJSON
        }
    }
    
    // MARK: - Web delegate
    func webViewDidFinishLoad(webView: UIWebView) {
        webView.hidden = false
        actInd.stopAnimating()
        loadingView.hidden = true
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
