//
//  SANTitleStyle.swift
//  XMGTV
//
//  Created by 唐三彩 on 2017/6/1.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

class SANTitleStyle {
    //标题调度
    var titleHeight : CGFloat = 44
    
    //标题默认及选中颜色
    var normalColor : UIColor = UIColor(r: 0, g: 0, b: 0)
    var selectColor : UIColor = UIColor(r: 255, g: 127, b: 0)
    
    //字体
    var fontSize : CGFloat = 15
    
    //是否可以滚动
    var isScrollEnable : Bool = false
    
    //item间距
    var itemMargin : CGFloat = 30
    
    //滚动条相关
    var isShowScrollLine : Bool = false
    var scrollLineHeight : CGFloat = 2
    var scrollLineColor: UIColor = .orange
    
}
