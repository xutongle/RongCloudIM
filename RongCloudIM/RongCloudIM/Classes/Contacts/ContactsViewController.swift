//
//  ContactsViewController.swift
//  RongCloudIM
//
//  Created by SunnyMac on 16/8/23.
//  Copyright © 2016年 hjl. All rights reserved.
//

import UIKit

class ContactsViewController: UITableViewController {
    
    var userIdArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNav()
        
        // 查询
        let bUser = BmobUser.getCurrentUser()

        let query   = BmobQuery(className: "Friends")

        query.whereObjectKey("friends", relatedTo: bUser)
        
        query.findObjectsInBackgroundWithBlock { (array, error) in
            
            for a in array {
                
                //HHLog(a)
                
                let t  = a.objectForKey("userID") as! String
                
                HHLog("username \(t)")
                
                self.userIdArr.append(t)
                
            }
            HHLog(self.userIdArr)
            
            self.tableView.reloadData()
        }      
    }

    
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.hidden = false
    }
    
    func setupNav() {
        let leftItem = UIBarButtonItem.init(title: "会话", style: .Done, target: self, action: #selector(ContactsViewController.leftBarButtonItemClick))
        
        navigationItem.leftBarButtonItem = leftItem
        
        
        let rightItem = UIBarButtonItem.init(title: "加好友", style: .Done, target: self, action: #selector(ContactsViewController.rightBarButtonItemClick))
        
        navigationItem.rightBarButtonItem = rightItem
    }
    
    func leftBarButtonItemClick() {
        
        self.tabBarController?.tabBar.hidden = true
        
        //新建一个聊天会话View Controller对象
        let chat = RCConversationViewController()
        //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
        chat.conversationType = RCConversationType.ConversationType_PRIVATE
        //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
        chat.targetId = "001"
        //设置聊天会话界面要显示的标题
        chat.title = "想显示的会话标题"
        //显示聊天会话界面
        self.navigationController?.pushViewController(chat, animated: true)
    }
    
    func rightBarButtonItemClick() {
        
        navigationController?.pushViewController(AddFriendViewController(), animated: true)
        
    }

}

    // MARK: - Table view data source
extension ContactsViewController {

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.userIdArr.count
    }
    
    
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell.init(style: .Default, reuseIdentifier: "reuseIdentifier")
        
        cell.textLabel?.text = self.userIdArr[indexPath.row]
        
        return cell
        
     }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.tabBarController?.tabBar.hidden = true
        
        //新建一个聊天会话View Controller对象
        let chat = RCConversationViewController()
        //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
        chat.conversationType = RCConversationType.ConversationType_PRIVATE
        //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
        chat.targetId = userIdArr[indexPath.row]
        //设置聊天会话界面要显示的标题
        chat.title = userIdArr[indexPath.row]
        //显示聊天会话界面
        self.navigationController?.pushViewController(chat, animated: true)
        
    }
    
}
