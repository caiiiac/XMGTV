//
//  NSDate-Extension.swift
//  XMGTV
//
//  Created by 唐三彩 on 2017/6/8.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import Foundation

extension Date {
    static func getCurrentTime() -> String {
        let nowDate = Date()
        
        let interval = Int(nowDate.timeIntervalSince1970)
        
        return "\(interval)"
    }
}
