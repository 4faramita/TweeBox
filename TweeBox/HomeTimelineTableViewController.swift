//
//  HomeTimelineTableViewController.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/14.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import UIKit
import SwipeCellKit

class HomeTimelineTableViewController: UserTimelineTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userID = Constants.selfID
        // let's user database here
    }
    
    override func addLefttActions(at indexPath: IndexPath) -> [SwipeAction]? {
        
        let tweet = timeline[indexPath.section][indexPath.row]
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            print(">>> Delete")
            
            let composer = SimpleTweetComposer(id: tweet.id)
            composer.deleteTweet() { [weak self] (succeeded, _) in
                
                self?.timeline[indexPath.section].remove(at: indexPath.row)
//                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                self?.tableView.deleteRows(at: [indexPath], with: .automatic)

                
                if succeeded {
                    print(">>> Delete succeed")
                } else {
                    print(">>> Delete failed")
                }
            }
        }
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        
        var options = SwipeTableOptions()
        options.transitionStyle = .border
        
//        if orientation == .left {
        options.expansionStyle = .destructive
//        }
        
        return options
    }

}
