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
            channelView.delegate = self
            addSubview(channelView)
            channelViews.append(channelView)
        }
    }
}

// MARK:- 对外提供函数
extension SANGiftContainerView {
    func showGiftModel(_ giftModel : SANGiftModel) {
        // 1.判断正在忙的ChanelView和赠送的新礼物的(username/giftname)
        if let channelView = checkUsingChanelView(giftModel) {
            channelView.addOnceGiftAnimToCache()
            return
        }
        
        // 2.判断有没有闲置的ChanelView
        if let channelView = checkIdleChannelView() {
            channelView.giftModel = giftModel
            channelView.performAnimation()
            return
        }
        
        // 3.将数据放入缓存中
        cacheGiftModels.append(giftModel)
    }
}

//MARK: - 私有函数
extension SANGiftContainerView {
    //检查是否有giftModel正在被执行动画
    fileprivate func checkUsingChanelView(_ giftModel : SANGiftModel) -> SANGiftChannelView? {
        for channelView in channelViews {
            if let channelModel = channelView.giftModel {
                if channelModel.isEqual(giftModel) && channelView.state != .endAnimating {
                    return channelView
                }
            }
        }
        
        return nil
    }
    
    //检查是否有闲置的channelView
    fileprivate func checkIdleChannelView() -> SANGiftChannelView? {
        for channelView in channelViews {
            if channelView.state == .idle {
                return channelView
            }
        }
        
        return nil
    }
}

//MARK: - 监听动画是否执行结束
extension SANGiftContainerView : SANGiftChannelViewDelegate {
    
    func giftAnimationDidCompletion(channelView : SANGiftChannelView) {
        if cacheGiftModels.count > 0 {
            let giftModel = cacheGiftModels.first!
            cacheGiftModels.removeFirst()
            showGiftModel(giftModel)
            for cacheModel in cacheGiftModels.reversed(){
                if cacheModel.isEqual(giftModel) {
                    cacheGiftModels.remove(at: cacheGiftModels.index(of: cacheModel)!)
                    channelView.addOnceGiftAnimToCache()
                }
            }
        }
    }
}

