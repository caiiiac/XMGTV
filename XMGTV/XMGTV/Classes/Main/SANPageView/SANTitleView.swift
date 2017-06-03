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
    fileprivate lazy var bottomLine : UIView = {
        let view = UIView()
        view.backgroundColor = self.style.scrollLineColor
        view.frame.size.height = self.style.scrollLineHeight
        view.frame.origin.y = self.bounds.height - self.style.scrollLineHeight
        
        return view
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
        
        //添加滚动条
        if style.isShowScrollLine {
            scrollView.addSubview(bottomLine)
        }
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
            
                if i == 0 && style.isShowScrollLine {
                    bottomLine.frame.origin.x = x
                    bottomLine.frame.size.width = w
                }
            } else {
                w = bounds.width / CGFloat(count)
                x = w * CGFloat(i)
                
                if i == 0 && style.isShowScrollLine {
                    bottomLine.frame.origin.x = 0
                    bottomLine.frame.size.width = w
                }
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
        
        //调整title
        adjustTitleLabel(targetIndex: targetLabel.tag)
        
        //调整滚动条
        if style.isShowScrollLine {
            UIView.animate(withDuration: 0.25, animations: { 
                self.bottomLine.frame.origin.x = targetLabel.frame.origin.x
                self.bottomLine.frame.size.width = targetLabel.frame.width
            })
        }
        
        //点击代理,content相应改变
        delegate?.titleView(self, targetIndex: currentIndex)

    }
    
    fileprivate func adjustTitleLabel(targetIndex : Int) {
        //取出点击的label
        let targetLabel = titleLabels[targetIndex]
        let sourceLabel = titleLabels[currentIndex]
        
        //切换文字颜色
        sourceLabel.textColor = style.normalColor
        targetLabel.textColor = style.selectColor
        
        
        //记录下标
        currentIndex = targetLabel.tag
        
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

//MARK: - SANContentViewDelegate
extension SANTitleView : SANContentViewDelegate {
    func contentView(_ contentView: SANContentView, targetIndex: Int) {
        adjustTitleLabel(targetIndex: targetIndex)
    }
    
    func contentView(_ contentView: SANContentView, targetIndex: Int, progress: CGFloat) {
    
        //取出点击的label
        let targetLabel = titleLabels[targetIndex]
        let sourceLabel = titleLabels[currentIndex]
        
        //颜色渐变
        let deltaRGB = UIColor.getRGBDelta(style.selectColor, style.normalColor)
        let selectRGB = style.selectColor.getRGB()
        let normalRGB = style.normalColor.getRGB()
        targetLabel.textColor = UIColor(r: normalRGB.0 + deltaRGB.0 * progress, g: normalRGB.1 + deltaRGB.1 * progress, b: normalRGB.2 + deltaRGB.2 * progress)
        sourceLabel.textColor = UIColor(r: selectRGB.0 - deltaRGB.0 * progress, g: selectRGB.1 - deltaRGB.1 * progress, b: selectRGB.2 - deltaRGB.2 * progress)
        
        //bottomLine渐变
        if style.isShowScrollLine {
            let deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
            let deltaW = targetLabel.frame.width - sourceLabel.frame.width
            bottomLine.frame.origin.x = sourceLabel.frame.origin.x + deltaX * progress
            bottomLine.frame.size.width = sourceLabel.frame.width + deltaW * progress
        }
    }
}
