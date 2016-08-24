//
//  LoginViewController.swift
//  RongCloudIM
//
//  Created by hjl on 16/8/24.
//  Copyright © 2016年 hjl. All rights reserved.
//

import UIKit

let AppKey : String = "8brlm7ufrraa3"
let AppSecret : String = "B4ekZUC9tP"

class LoginViewController: UIViewController {

    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    
    @IBAction func LoginClick(sender: AnyObject) {
        
        let parameters = [
                    "userId": userTextField.text!,
                    "name": pwdTextField.text!,
                    "portraitUri": ""
                ]

        
        let Timestamp = String(format: "%.0f",NSDate().timeIntervalSince1970)
        let Nonce: String = String(arc4random())
        var sha1 = AppKey + Nonce + Timestamp
        sha1 = (sha1 as NSString).sha1()
        
        // 网址
        let urlstr = "https://api.cn.rong.io/user/getToken.json"
        let manage = NetworkTools.shareInstance
        
        // 键值对应
        manage.requestSerializer.setValue(AppKey, forHTTPHeaderField: "App-Key")
        manage.requestSerializer.setValue(AppSecret, forHTTPHeaderField: "appSecret")
        manage.requestSerializer.setValue(Nonce, forHTTPHeaderField: "Nonce")
        manage.requestSerializer.setValue(Timestamp, forHTTPHeaderField: "Timestamp")
        manage.requestSerializer.setValue(sha1, forHTTPHeaderField: "Signature")
        manage.requestSerializer.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        var Token = ""
        
        manage.POST(urlstr, parameters: parameters, success: { (request, AnyObject) in
            let too : NSDictionary = AnyObject as! NSDictionary
            
            Token = too["token"] as! String
            //print(Token)
            HHLog("token = " + Token)
            RCIM.sharedRCIM().initWithAppKey(AppKey)
            
            RCIM.sharedRCIM().connectWithToken(Token,
                success: { (userId) -> Void in
                    print("登陆成功。当前登录的用户ID：\(userId)")
                    
                    //UIApplication.sharedApplication().keyWindow?.rootViewController = MainViewController()
                    
                    
                }, error: { (status) -> Void in
                    print("登陆的错误码为:\(status.rawValue)")
                }, tokenIncorrect: {
                    //token过期或者不正确。
                    //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                    //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                    print("token错误")
            })
            
            
        }) { (request, NSError) in
            print(NSError)
        }
        
        

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
