//
//  SANTitleView.swift
//  XMGTV
//
//  Created by 唐三彩 on 2017/6/1.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

protocol SANTitleViewDelegate : class {
    func titleView(_ titleView : SANTitleView, targetIndex : Int)
}

class SANTitleView: UIView {

    weak var delegate : SANTitleViewDelegate?
    
    fileprivate var titles : [String]
    fileprivate var style : SANTitleStyle
    
    fileprivate lazy var currentIndex : Int = 0
    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    fileprivate lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        
        return scrollView
    }()
    
    init(frame: CGRect, titles : [String], style : SANTitleStyle) {
        self.titles = titles
        self.style = style
        
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK: - UI
extension SANTitleView {
    fileprivate func setupUI() {
        //添加scrollView
        addSubview(scrollView)
        
        //添加标题label
        setupTitleLabels()
        
        //设置标题label的fram
        setupTitleLabelsFrame()
    }
    
    private func setupTitleLabels() {
        for (i, title) in titles.enumerated() {
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.textAlignment = .center
            titleLabel.textColor = style.normalColor
            titleLabel.font = UIFont.systemFont(ofSize: style.fontSize)
            titleLabel.tag = i
            titleLabel.textColor = i == 0 ? style.selectColor : style.normalColor

            let tap = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_:)))
            titleLabel.addGestureRecognizer(tap)
            titleLabel.isUserInteractionEnabled = true
            
            scrollView.addSubview(titleLabel)
            titleLabels.append(titleLabel)
        }
    }
    
    private func setupTitleLabelsFrame() {
        let count = titles.count
        
        for (i, label) in titleLabels.enumerated() {
            var w : CGFloat = 0
            let h : CGFloat = bounds.height
            var x : CGFloat = 0
            let y : CGFloat = 0
            
            //是否可以滚动
            if style.isScrollEnable {
                w = (titles[i] as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : label.font], context: nil).width
                x = (i == 0 ? (style.itemMargin * 0.5) : (titleLabels[i - 1]).frame.maxX + style.itemMargin)
            } else {
                w = bounds.width / CGFloat(count)
                x = w * CGFloat(i)
            }
            
            label.frame = CGRect(x: x, y: y, width: w, height: h)
        }
        
        scrollView.contentSize = style.isScrollEnable ? CGSize(width: titleLabels.last!.frame.maxX + style.itemMargin * 0.5, height: 0) : CGSize.zero
    }
}

//MARK: - 监听事件
extension SANTitleView {
    @objc fileprivate func titleLabelClick(_ tap : UITapGestureRecognizer) {
        
        //取出点击的label
        let targetLabel = tap.view as! UILabel
        let sourceLabel = titleLabels[currentIndex]
        
        //切换文字颜色
        targetLabel.textColor = style.selectColor
        sourceLabel.textColor = style.normalColor
        
        //记录下标
        currentIndex = targetLabel.tag
        
        //点击代理,content相应改变
        delegate?.titleView(self, targetIndex: currentIndex)
        
        //调整位置
        if style.isScrollEnable {
            var offsetX = targetLabel.center.x - scrollView.bounds.width * 0.5
            
            if offsetX < 0 {
                offsetX = 0
            }
            if offsetX > (scrollView.contentSize.width - scrollView.bounds.width) {
                offsetX = scrollView.contentSize.width - scrollView.bounds.width
            }
            
            scrollView.setContentOffset(CGPoint(x : offsetX, y : 0), animated: true)
        }
        
    }
}

