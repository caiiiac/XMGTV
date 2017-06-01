//
//  SANContentView.swift
//  XMGTV
//
//  Created by 唐三彩 on 2017/6/1.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

class SANContentView: UIView {

    fileprivate var childVcs : [UIViewController]
    fileprivate var parentVc : UIViewController
    
    init(frame: CGRect, childVcs : [UIViewController], parentVc : UIViewController) {
        self.childVcs = childVcs
        self.parentVc = parentVc
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
