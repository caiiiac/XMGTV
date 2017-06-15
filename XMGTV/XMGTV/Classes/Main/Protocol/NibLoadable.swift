//
//  NibLoadable.swift
//  XMGTV
//
//  Created by 唐三彩 on 2017/6/13.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

protocol NibLoadable {

}

extension NibLoadable where Self : UIView {
    static func loadFromNib(_ nibname : String? = nil) -> Self {
        let loadName = nibname == nil ? "\(self)" : nibname!
        return Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
    }
}
