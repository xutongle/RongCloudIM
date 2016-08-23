//
//  ContactsViewController.swift
//  RongCloudIM
//
//  Created by SunnyMac on 16/8/23.
//  Copyright © 2016年 hjl. All rights reserved.
//

import UIKit

class ContactsViewController: UITableViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNav()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.hidden = false
    }
    
    func setupNav() {
        let item = UIBarButtonItem.init(title: "会话", style: .Done, target: self, action: #selector(ContactsViewController.rightBarButtonItemClick))
        
        navigationItem.rightBarButtonItem = item
    }
    
    func rightBarButtonItemClick() {
        
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

}

    // MARK: - Table view data source
extension ContactsViewController {

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    /*
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
}
