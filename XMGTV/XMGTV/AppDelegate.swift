//
//  AppDelegate.swift
//  XMGTV
//
//  Created by 唐三彩 on 2017/5/31.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UINavigationBar.appearance().barTintColor = UIColor.black
        
        let attDict = [NSForegroundColorAttributeName : UIColor.clear ,
                       NSFontAttributeName : UIFont.systemFont(ofSize: 0.1)
        ]
        
        UIBarButtonItem.appearance().setTitleTextAttributes(attDict , for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes(attDict , for: .highlighted)

        return true
    }

    
}

