//
//  SANPageView.swift
//  XMGTV
//
//  Created by 唐三彩 on 2017/6/1.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

class SANPageView: UIView {

    fileprivate var titles : [String]
    fileprivate var childVcs : [UIViewController]
    fileprivate var parentVc : UIViewController
    fileprivate var style : SANTitleStyle
    
    fileprivate var titleView : SANTitleView!
    
    init(frame: CGRect, titles : [String], childVcs : [UIViewController], parentVc : UIViewController, style : SANTitleStyle) {
        
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = parentVc
        self.style = style
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension SANPageView {
    fileprivate func setupUI() {
        setupTitleView()
        setupContentView()
    }
    
    private func setupTitleView() {
        let titleFrame = CGRect(x: 0, y: 0, width: bounds.width, height: style.titleHeight)
        titleView = SANTitleView(frame: titleFrame, titles: titles)
        addSubview(titleView)
    }
    
    private func setupContentView() {
        let contentFrame = CGRect(x: 0, y: style.titleHeight, width: bounds.width, height: bounds.height - style.titleHeight)
        let contentView = SANContentView(frame: contentFrame, childVcs: childVcs, parentVc: parentVc)
        addSubview(contentView)
    }
}
