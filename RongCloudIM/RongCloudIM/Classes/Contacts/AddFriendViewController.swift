//
//  AddFriendViewController.swift
//  RongCloudIM
//
//  Created by SunnyMac on 16/8/25.
//  Copyright © 2016年 hjl. All rights reserved.
//

import UIKit

class AddFriendViewController: UIViewController {

    @IBOutlet weak var queryTextField: UITextField!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func addFriendClick(sender: AnyObject) {
        self.addButton.enabled = false
        
        // 数据关联
        let bUser = BmobUser.getCurrentUser()
        
        if (bUser != nil) {
            let friend = BmobObject(className:"Friends")
            friend.setObject(self.queryTextField.text, forKey: "userID")
            
            
            friend.saveInBackgroundWithResultBlock({ (isSuccessful, error) in
                if isSuccessful {
                    
                    let relation = BmobRelation()
                    relation.addObject(friend)
                    bUser.addRelation(relation, forKey: "friends")
                    
                    bUser.sub_updateInBackgroundWithResultBlock({ (isSuccessful, error) in
                        if isSuccessful {
                            HHLog("access")
                            
                            self.navigationController?.popViewControllerAnimated(true)
                        }else{
                            HHLog(error)
                        }
                    })
                    
                }
            })

        }
    }
    @IBAction func queryClick(sender: AnyObject) {
        
        let query = BmobUser.query()
        query.whereKey("username", equalTo: self.queryTextField.text)
        query.findObjectsInBackgroundWithBlock { (array, error) in
            for obj in array {
                let user  = obj as! BmobUser
                print("objectId \(user.objectId)")
                
                self.addButton.enabled = true
                
            }
        }
    }

  
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.addButton.enabled = false

    }
}
