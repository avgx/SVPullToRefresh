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
        scrollView.addPullToRefreshWithAction({()->Void in println("hello")}, withPosition: UIScrollView.SVPullToRefreshPosition.SVPullToRefreshPositionTop)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

