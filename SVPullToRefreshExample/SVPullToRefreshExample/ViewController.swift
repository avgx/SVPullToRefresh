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
        scrollView.contentSize = CGSizeMake(scrollView.bounds.width, scrollView.bounds.height + 300)
        scrollView.addPullToRefreshWithAction({()->Void in println("hello")}, withPosition: .Top)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

