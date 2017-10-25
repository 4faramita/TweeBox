//
//  UserListTableViewController.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/15.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import UIKit
import ESPullToRefresh
import SwipeCellKit

class UserListTableViewController: UITableViewController {
    
    var userList = [Array<TwitterUser>]()
    
    private var headID: String? {
        return userList.first?.first?.id
    }
    
    private var tailID: String? {
        return userList.last?.last?.id
    }
    
    public var nextCursor = "-1" {
        didSet {
            print(">>> nextCursor set \(nextCursor)")
        }
    }
    public var previousCursor = "-1" {
        didSet {
            print(">>> previousCursor set \(previousCursor)")
        }
    }
    // cursor == "0" indicates the corresponding direction is at the end
    
    public var fetchOlder = true {
        didSet {
            print(">>> fetch older? >> \(fetchOlder)")
        }
    }
    
    public var userListRetriever: UserListRetrieverProtocol?
    
    private var selectedUser: TwitterUser?

        
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshUserList(handler: nil)
        tableView.rowHeight = 72
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addRefresher()
        pullToLoaderMore()
    }
    
    
    private func insertNewUsers(with newUsers: [TwitterUser]) {
        if !fetchOlder {
            self.userList.insert(newUsers, at: 0)
            self.tableView.insertSections([0], with: .automatic)
        } else {
            self.userList.append(newUsers)
            self.tableView.insertSections([self.userList.endIndex - 1], with: .automatic)

        }
    }
    
    
    func addRefresher() {
        self.tableView.es.addPullToRefresh {
            [unowned self] in
            
            self.fetchOlder = false
            self.refreshUserList {
//                self.tableView.es_stopPullToRefresh(ignoreDate: true)
                self.tableView.es.stopPullToRefresh(ignoreDate: true, ignoreFooter: false)
            }
            
            /// 设置ignoreFooter来处理不需要显示footer的情况
//            self.tableView.es_stopPullToRefresh(completion: true, ignoreFooter: false)
        }
    }
    
    func pullToLoaderMore() {
        self.tableView.es.addInfiniteScrolling {
            [weak self] in
            self?.fetchOlder = true
            self?.refreshUserList {
                self?.tableView.es.stopLoadingMore()
            }
            /// 如果你的加载更多事件成功，调用es_stopLoadingMore()重置footer状态
            //            self.tableView.es_stopLoadingMore()
            /// 通过es_noticeNoMoreData()设置footer暂无数据状态
            //            self.tableView.es_noticeNoMoreData()
        }
    }


    
    func refreshUserList(handler: (() -> Void)?) {
        
        if (fetchOlder && nextCursor == "0") || (!fetchOlder && previousCursor == "0") {
            print(">>> no more")
            if let handler = handler {
                handler()
            }
        } else {
            if let userList = userListRetriever as? UserList {
                userList.fetchOlder = fetchOlder
                userList.nextCursor = nextCursor
                userList.previousCursor = previousCursor
                userList.headID = self.headID
                userList.tailID = self.tailID
            }
            
            userListRetriever?.fetchData { [weak self] (nextCursor, previousCursor, newUserList) in
                
                if (self?.nextCursor == "-1") && (self?.previousCursor == "-1") {
                    self?.nextCursor = nextCursor
                    self?.previousCursor = previousCursor
                } else {
                    if let fetchOlder = self?.fetchOlder {
                        if fetchOlder {
                            self?.nextCursor = nextCursor
                        } else {
                            self?.previousCursor = previousCursor
                        }
                    }
                }
                
                if newUserList.count > 0 {
                    self?.insertNewUsers(with: newUserList)
                }
                
                if let handler = handler {
                    handler()
                }
            }
        }
    }
    
    
    @IBAction func done(_ sender: Any?) {
        dismiss(animated: true, completion: nil)
    }

    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return userList.count
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList[section].count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let user = userList[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Twitter User", for: indexPath)
        
        if let userCell = cell as? TwitterUserTableViewCell {
            userCell.user = user
            userCell.delegate = self
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedUser = userList[indexPath.section][indexPath.row]
        
        performSegue(withIdentifier: "View User", sender: self)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "View User" {
            
            if let userTimelineTableViewController = segue.destination as? UserTimelineTableViewController {
                userTimelineTableViewController.user = selectedUser
                userTimelineTableViewController.navigationItem.rightBarButtonItem = nil
            } else if let userTimelineTableViewController = segue.destination.content as? UserTimelineTableViewController {
                userTimelineTableViewController.user = selectedUser
            }
        }
    }
}


extension UserListTableViewController: SwipeTableViewCellDelegate {
    
    /**
     Asks the delegate for the actions to display in response to a swipe in the specified row.
     
     - parameter tableView: The table view object which owns the cell requesting this information.
     
     - parameter indexPath: The index path of the row.
     
     - parameter orientation: The side of the cell requesting this information.
     
     - returns: An array of `SwipeAction` objects representing the actions for the row. Each action you provide is used to create a button that the user can tap.  Returning `nil` will prevent swiping for the supplied orientation.
     */
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        let user = userList[indexPath.section][indexPath.row]
        
        if orientation == .right {
            
            let followAction: SwipeAction
            if let following = user.following, following {
                followAction = SwipeAction(style: .default, title: "Unfollow") { action, indexPath in
                    print(">>> Unfollow")
                    
                    let manager = FriendshipManager(userID: user.id)
                    
                    manager.unfollow(handler: { [weak self] (succeeded, returnedUser) in
                        if succeeded, var returnedUser = returnedUser {
                            returnedUser.following = false
                            
                            self?.userList[indexPath.section][indexPath.row] = returnedUser
                            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                        }
                    })
                }
                
            } else {
                followAction = SwipeAction(style: .default, title: "Follow") { action, indexPath in
                    print(">>> Follow")
                    
                    let manager = FriendshipManager(userID: user.id)
                    
                    manager.follow(handler: { [weak self] (succeeded, returnedUser) in
                        if succeeded, var returnedUser = returnedUser {
                            returnedUser.following = true
                            
                            self?.userList[indexPath.section][indexPath.row] = returnedUser
                            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                        }
                    })

                }
            }
            
            followAction.backgroundColor = .yellow
            followAction.textColor = .black
            
            let DMAction = SwipeAction(style: .default, title: "Message") { action, indexPath in
                print(">>> Message")
            }
            DMAction.backgroundColor = .blue
            
            return [followAction, DMAction]
            
        } else {
            
            let BlockAction: SwipeAction = SwipeAction(style: .default, title: "Block") { [weak self] action, indexPath in
                print(">>> Block")
                
                let alert = UIAlertController(title: "About To Block", message: "You will not see any tweet or mention from this account directly. Proceed?", preferredStyle: .alert)
                alert.addAction(
                    UIAlertAction(
                        title: "OK",
                        style: .destructive,
                        handler: { (action) in
                            let manager = FriendshipManager(userID: user.id)
                            
                            manager.block(handler: { (succeeded, user) in
                                self?.userList[indexPath.section].remove(at: indexPath.row)
                                self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                            })
                        }
                    )
                )
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self?.present(alert, animated: true, completion: nil)
                
            }
            BlockAction.backgroundColor = .darkGray
            BlockAction.textColor = .red
            
            
            
            let reportAction = SwipeAction(style: .default, title: "Report Spam") { [weak self] action, indexPath in
                print(">>> Report Spam")
                
                let alert = UIAlertController(title: "About To Report Spam", message: "You will report this account as a spam account. Proceed?", preferredStyle: .alert)
                alert.addAction(
                    UIAlertAction(
                        title: "OK",
                        style: .destructive,
                        handler: { (action) in
                            
                            var alsoBlock: Bool? {
                                didSet {
                                    let manager = FriendshipManager(userID: user.id)

                                    manager.reportSpam(block: alsoBlock) { (succeeded, user) in
                                        self?.userList[indexPath.section].remove(at: indexPath.row)
                                        self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                                    }
                                    
                                    guard let alsoBlock = alsoBlock, !alsoBlock else {
                                        self?.userList[indexPath.section].remove(at: indexPath.row)
                                        self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                                        return
                                    }
                                }
                            }
                            
                            let alert = UIAlertController(title: "Also Block This Account?", message: "You may also want to block this account. Proceed?", preferredStyle: .alert)

                            
                            alert.addAction(UIAlertAction(title: "Block", style: .destructive, handler: { (action) in
                                alsoBlock = true
                            }))
                                
                            alert.addAction(UIAlertAction(title: "Not Now", style: .default, handler: { (action) in
                                alsoBlock = false
                            }))
                        }
                    )
                )
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self?.present(alert, animated: true, completion: nil)

            }
            reportAction.backgroundColor = .red
            
            return [BlockAction, reportAction]
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        
        var options = SwipeTableOptions()
        
        options.transitionStyle = .border
        
        //        if orientation == .right {
        options.expansionStyle = .selection
        //        } else {
        //            options.expansionStyle = .destructive
        //        }
        
        return options
    }
}




//enum UserListType {
//    case follower
//    case following
//}
