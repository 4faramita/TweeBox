//
//  UserListTableViewController.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/15.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import UIKit
import ESPullToRefresh

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
        self.tableView.es_addPullToRefresh {
            [unowned self] in
            
            self.fetchOlder = false
            self.refreshUserList {
//                self.tableView.es_stopPullToRefresh(ignoreDate: true)
                self.tableView.es_stopPullToRefresh(ignoreDate: true, ignoreFooter: false)
            }
            
            /// 设置ignoreFooter来处理不需要显示footer的情况
//            self.tableView.es_stopPullToRefresh(completion: true, ignoreFooter: false)
        }
    }
    
    func pullToLoaderMore() {
        self.tableView.es_addInfiniteScrolling {
            [weak self] in
            self?.fetchOlder = true
            self?.refreshUserList {
                self?.tableView.es_stopLoadingMore()
            }
            /// 如果你的加载更多事件成功，调用es_stopLoadingMore()重置footer状态
            //            self.tableView.es_stopLoadingMore()
            /// 通过es_noticeNoMoreData()设置footer暂无数据状态
            //            self.tableView.es_noticeNoMoreData()
        }
    }


    
    func refreshUserList(handler: ((Void) -> Void)?) {
        
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


//enum UserListType {
//    case follower
//    case following
//}
