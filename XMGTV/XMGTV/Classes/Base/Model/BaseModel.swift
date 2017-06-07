//
//  BaseModel.swift
//  XMGTV
//
//  Created by 唐三彩 on 2017/6/7.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

class BaseModel: NSObject {
    override init() {
        
    }
    
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}

}
