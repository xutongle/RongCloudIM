//
//  MainViewController.swift
//  RongCloudIM
//
//  Created by SunnyMac on 16/8/22.
//  Copyright © 2016年 hjl. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addChildViewController(ConversationListViewController(), title: "微信", imageName: "")
        addChildViewController(ContactsViewController(), title: "通讯录", imageName: "")
        addChildViewController(DiscoverViewController(), title: "发现", imageName: "")
        addChildViewController(MeViewController(), title: "我", imageName: "")
    }
}


extension MainViewController {
    
    func addChildViewController(childController: UIViewController, title: String, imageName: String) {
        
        childController.title = title
        
        let nav = UINavigationController.init(rootViewController: childController)
        
        addChildViewController(nav)
        
    }
    
}