//
//  SANGiftContainerView.swift
//  XMGTV
//
//  Created by 唐三彩 on 2017/6/27.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

private let kChannelCount = 2
private let kChannelViewH : CGFloat = 40
private let kChannelMargin : CGFloat = 10

class SANGiftContainerView: UIView {

    // MARK: 定义属性
    fileprivate lazy var channelViews : [SANGiftChannelView] = [SANGiftChannelView]()
    fileprivate lazy var cacheGiftModels : [SANGiftModel] = [SANGiftModel]()
    
    // MARK: 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 设置UI界面
extension SANGiftContainerView {
    fileprivate func setupUI() {
        // 1.根据当前的渠道数，创建SANGiftChannelView
        let w : CGFloat = frame.width
        let h : CGFloat = kChannelViewH
        let x : CGFloat = 0
        for i in 0..<kChannelCount {
            let y : CGFloat = (h + kChannelMargin) * CGFloat(i)
            
            let channelView = SANGiftChannelView.loadFromNib()
            channelView.frame = CGRect(x: x, y: y, width: w, height: h)
            channelView.alpha = 0.0
            addSubview(channelView)
            channelViews.append(channelView)
        }
    }
}


extension SANGiftContainerView {
    func showGiftModel(_ giftModel : SANGiftModel) {
        // 1.判断正在忙的ChanelView和赠送的新礼物的(username/giftname)
        if let channelView = checkUsingChanelView(giftModel) {
            channelView.addOnceToCache()
        }
        
        // 2.判断有没有闲置的ChanelView
        if let channelView = checkIdleChannelView() {
            channelView.giftModel = giftModel
        }
        
        // 3.将数据放入缓存中
        cacheGiftModels.append(giftModel)
    }
    
    private func checkUsingChanelView(_ giftModel : SANGiftModel) -> SANGiftChannelView? {
        for channelView in channelViews {
            if giftModel.isEqual(channelView.giftModel) && channelView.state != .endAnimating {
                return channelView
            }
        }
        
        return nil
    }
    
    private func checkIdleChannelView() -> SANGiftChannelView? {
        for channelView in channelViews {
            if channelView.state == .idle {
                return channelView
            }
        }
        
        return nil
    }
}
 
