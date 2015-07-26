//
//  ViewController.swift
//  SVPullToRefreshExample
//
//  Created by Wizard Li on 6/29/15.
//  Copyright (c) 2015 morgenworks. All rights reserved.
//

import UIKit
import SVPullToRefresh

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        scrollView.contentSize = CGSizeMake(scrollView.bounds.width, scrollView.bounds.height)
        scrollView.addPullToRefreshWithAction(.Top, triggeredHandler: {
            () -> Void in
            
            let delayInSeconds : Int64 = 2
            let popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * Int64(NSEC_PER_SEC))
            
            dispatch_after(popTime, dispatch_get_main_queue(), {
                [weak self]
                () -> Void in
                
                if let weakSelf = self {
                    weakSelf.scrollView.topRefreshView?.stopAnimating()
                }
            })
        })
        
        scrollView.addPullToRefreshWithAction(.Bottom, triggeredHandler: { () -> Void in
            let delayInSeconds : Int64 = 2
            let popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * Int64(NSEC_PER_SEC))
            
            dispatch_after(popTime, dispatch_get_main_queue(), { () -> Void in
                self.scrollView.bottomRefreshView!.stopAnimating()
            })
        })
        
        scrollView.triggerPullToRefresh(.Top)
    }

    @IBAction func buttonPressed() {
        
        println("scroll view frame : \(scrollView.frame)")
        println("scroll view insets : \(scrollView.contentInset.top), \(scrollView.contentInset.left), \(scrollView.contentInset.bottom), \(scrollView.contentInset.right), ")
        println("scroll view offset : \(scrollView.contentOffset)")
        println("scroll view content size : \(scrollView.contentSize)")
        
        if let view = scrollView.topRefreshView {
            println("top refresh view frame : \(view.frame)")
            view.backgroundColor = UIColor.cyanColor()
            //println("view.arrow.frame : \(view.arrow.frame)")
        }
    }
}

