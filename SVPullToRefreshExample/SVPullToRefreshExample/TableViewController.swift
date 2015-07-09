//
//  TableViewController.swift
//  SVPullToRefreshExample
//
//  Created by Wizard Li on 7/1/15.
//  Copyright (c) 2015 morgenworks. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController
{
    struct Constants {
        static let identifier = "ExampleTableCell"
    }
    var dataSource = [String]()
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.identifier, forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel!.text = dataSource[indexPath.row]
        
        return cell
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.triggerPullToRefresh(.Top)
    }
    
    override func viewDidLoad() {
        for i in 1...20 {
            dataSource.append(String(i))
        }
        
        tableView.addPullToRefreshWithAction(.Top, triggeredHandler: { () -> Void in
            for i in 1...10 {
                self.dataSource.append(String(i))
            }
            
            let delayInSeconds : Int64 = 2
            let popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * Int64(NSEC_PER_SEC))
            
            dispatch_after(popTime, dispatch_get_main_queue(), { () -> Void in
                self.tableView.topRefreshView!.stopAnimating()
                self.tableView.reloadData()
            })
        })
        
//        tableView.addPullToRefreshWithAction({ () -> Void in
//            
//            for i in 1...10 {
//                self.dataSource.append(String(i))
//            }
//            
//            let delayInSeconds : Int64 = 2
//            let popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * Int64(NSEC_PER_SEC))
//            
//            dispatch_after(popTime, dispatch_get_main_queue(), { () -> Void in
//                self.tableView.bottomRefreshView!.stopAnimating()
//                self.tableView.reloadData()
//            })
//            
//            }, withPosition: .Bottom)
        
        tableView.addInfiniteScrollingWithActionHandler { () -> Void in

            for i in 1...10 {
                self.dataSource.append(String(i))
            }
            
            let delayInSeconds : Int64 = 2
            let popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * Int64(NSEC_PER_SEC))
            
            dispatch_after(popTime, dispatch_get_main_queue(), { () -> Void in
                self.tableView.infiniteScrollingView!.stopAnimating()
                self.tableView.reloadData()
            })
        }
    }

}