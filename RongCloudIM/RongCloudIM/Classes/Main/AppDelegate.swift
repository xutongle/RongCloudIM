//
//  AppDelegate.swift
//  RongCloudIM
//
//  Created by hjl on 16/8/21.
//  Copyright © 2016年 hjl. All rights reserved.
//

import UIKit

let Token = "DsSRYMp90Czh6a71EWeLZwCwqJBZ6qdQhFCGjvPrWk36F7nMiFMAs0NvyaeMSVyroLRssi9H+o7C0zvrugSosA=="

let AppKey : String = "8brlm7ufrraa3"
let AppSecret : String = "B4ekZUC9tP"

func HHLog<T>(message: T, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line){
    //#if DEBUG
        print("\(methodName)[\(lineNumber)]:\(message)")
    //#endif
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func getToken() {
        
        let parameters = [
            "userId": "003",
            "name": "003",
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

        manage.POST(urlstr, parameters: parameters, success: { (request, AnyObject) in
            print(AnyObject)
            }) { (request, NSError) in
            print(NSError)
        }
        
        
        //NSURLSession
        
        
        
        
        
//        [manager POST:str parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"responseObject:%@",responseObject);
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@",error);
//        }];
        
    
        
        
    }
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        RCIM.sharedRCIM().initWithAppKey(AppKey)
        
        getToken()
        
        RCIM.sharedRCIM().connectWithToken(Token,
                                           success: { (userId) -> Void in
                                            print("登陆成功。当前登录的用户ID：\(userId)")
            }, error: { (status) -> Void in
                print("登陆的错误码为:\(status.rawValue)")
            }, tokenIncorrect: {
                //token过期或者不正确。
                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                print("token错误")
        })
        
        window = UIWindow.init(frame: UIScreen.mainScreen().bounds)
        
        window?.rootViewController = MainViewController()
        
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}