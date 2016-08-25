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
        
        // 获取token
        
        
       // BmobUser.loginWithUsernameInBackground("001", password: "001")
        
        BmobUser.loginWithUsernameInBackground(self.userTextField.text, password: self.pwdTextField.text) { (bUser, error) in
            HHLog(bUser)
            if error != nil {
                HHLog(error)
            }
            self.getTokenWithBmobUser(bUser.username)
        }
        
    }
    
    @IBAction func RegisterClick(sender: AnyObject) {
        
        let bUser = BmobUser()
        bUser.username = self.userTextField.text
        bUser.password = self.pwdTextField.text

        bUser.signUpInBackgroundWithBlock { (isSuccessful, error) in
            
            if isSuccessful {
                bUser.updateInBackground()
                
                print("注册成功")
            }else{
                print("注册失败 = \(error)")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}


extension LoginViewController {
    func getTokenWithBmobUser(bmobUser: String)  -> String {
        let parameters = [
            "userId": bmobUser,
            "name": bmobUser,
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
            HHLog("token = " + Token)
            
            // 用token登录上线
            self.loginWithToken(Token)
            
        }) { (request, NSError) in
            print(NSError)
        }
        return Token
    }
    
    func loginWithToken(token : String) {
        RCIM.sharedRCIM().initWithAppKey(AppKey)
        
        RCIM.sharedRCIM().connectWithToken(token,
                                           success: { (userId) -> Void in
    
                print("登陆成功。当前登录的用户ID：\(userId)")
                                            
                // 换根控制器失败, 原因:此处不是主线程, 换控制器操作, 必须在主线程操作
                dispatch_sync(dispatch_get_main_queue(), { 
                    UIApplication.sharedApplication().keyWindow?.rootViewController = MainViewController()
                })
                                            
            }, error: { (status) -> Void in
                print("登陆的错误码为:\(status.rawValue)")
            }, tokenIncorrect: {
                //token过期或者不正确。
                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                print("token错误")
        })
    }
}

