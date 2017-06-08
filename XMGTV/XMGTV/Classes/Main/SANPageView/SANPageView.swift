//
//  SANPageView.swift
//  XMGTV
//
//  Created by 唐三彩 on 2017/6/1.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

class SANPageView: UIView {

    // MARK: 定义属性
    fileprivate var titles : [String]!
    fileprivate var style : SANTitleStyle!
    fileprivate var childVcs : [UIViewController]!
    fileprivate weak var parentVc : UIViewController!
    
    fileprivate var titleView : SANTitleView!
    fileprivate var contentView : SANContentView!
    
    // MARK: 自定义构造函数
    init(frame: CGRect, titles : [String], style : SANTitleStyle, childVcs : [UIViewController], parentVc : UIViewController) {
        super.init(frame: frame)
        
        assert(titles.count == childVcs.count, "标题&控制器个数不同,请检测!!!")
        self.style = style
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = parentVc
        parentVc.automaticallyAdjustsScrollViewInsets = false
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK:- 设置界面内容
extension SANPageView {
    fileprivate func setupUI() {
        let titleH : CGFloat = 44
        let titleFrame = CGRect(x: 0, y: 0, width: frame.width, height: titleH)
        titleView = SANTitleView(frame: titleFrame, titles: titles, style : style)
        titleView.delegate = self
        addSubview(titleView)
        
        let contentFrame = CGRect(x: 0, y: titleH, width: frame.width, height: frame.height - titleH)
        contentView = SANContentView(frame: contentFrame, childVcs: childVcs, parentViewController: parentVc)
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.delegate = self
        addSubview(contentView)
    }
}


// MARK:- 设置HYContentView的代理
extension SANPageView : SANContentViewDelegate {
    func contentView(_ contentView: SANContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        titleView.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
    func contentViewEndScroll(_ contentView: SANContentView) {
        titleView.contentViewDidEndScroll()
    }
}


// MARK:- 设置HYTitleView的代理
extension SANPageView : SANTitleViewDelegate {
    func titleView(_ titleView: SANTitleView, selectedIndex index: Int) {
        contentView.setCurrentIndex(index)
    }
}
