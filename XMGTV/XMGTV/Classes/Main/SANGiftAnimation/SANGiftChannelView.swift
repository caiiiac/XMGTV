//
//  SANGiftChannelView.swift
//  XMGTV
//
//  Created by 唐三彩 on 2017/6/27.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

private let kShowChannelDuration : TimeInterval = 0.25
private let kHiddenChannelDelay : TimeInterval = 3.0


enum SANGiftChannelState {
    case idle
    case animating
    case willEnd
    case endAnimating
}

protocol SANGiftChannelViewDelegate : class{
    func giftAnimationDidCompletion()
}

class SANGiftChannelView: UIView, NibLoadable {

    // MARK: 控件属性
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var giftDescLabel: UILabel!
    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var digitLabel: SANGiftDigitLabel!
    
    //MARK: - 内部属性
    fileprivate var cacheNumber : Int = 0
    fileprivate var currentNumber : Int = 0
    
    //MARK: - 对外属性
    var state : SANGiftChannelState = .idle
    weak var delegate : SANGiftChannelViewDelegate?
    
    var giftModel : SANGiftModel? {
        didSet {
            // 1.对模型进行校验
            guard let giftModel = giftModel else {
                return
            }
            
            // 2.给控件设置信息
            iconImageView.image = UIImage(named: giftModel.senderURL)
            senderLabel.text = giftModel.senderName
            giftDescLabel.text = "送出礼物：【\(giftModel.giftName)】"
            giftImageView.image = UIImage(named: giftModel.giftURL)
            
        }
    }
}


// MARK:- 设置UI界面
extension SANGiftChannelView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgView.layer.cornerRadius = frame.height * 0.5
        iconImageView.layer.cornerRadius = frame.height * 0.5
        bgView.layer.masksToBounds = true
        iconImageView.layer.masksToBounds = true
        iconImageView.layer.borderWidth = 1
        iconImageView.layer.borderColor = UIColor.green.cgColor
    }
}


// MARK:- 对外提供的函数
extension SANGiftChannelView {
    func addOnceGiftAnimToCache() {
        
        if state == .animating {
            cacheNumber += 1
        } else {
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            performDigitAnimation()
        }
    }
    
    func performAnimation() {
        //改变状态
        state = .animating
        
        //弹出channelView
        UIView.animate(withDuration: kShowChannelDuration, animations: {
            
        }) { (isFinished : Bool) in
            self.performDigitAnimation()
        }
    }

    
}


// MARK:- 执行动画代码
extension SANGiftChannelView {
    
    fileprivate func performDigitAnimation() {
        digitLabel.alpha = 1.0
        currentNumber += 1
        digitLabel.text = "x\(currentNumber)"
        
        
        digitLabel.showDigitAnimation(kShowChannelDuration, {
            
            if self.cacheNumber > 0 {
                self.cacheNumber -= 1
                self.performDigitAnimation()
            } else {
                self.state = .willEnd
                self.perform(#selector(self.performEndAnimation), with: nil, afterDelay: kHiddenChannelDelay)
            }
            
        })
    }
    
    @objc fileprivate func performEndAnimation() {
        
        state = .endAnimating
        
        UIView.animate(withDuration: kShowChannelDuration, animations: {
            self.frame.origin.x = UIScreen.main.bounds.width
            self.alpha = 0.0
        }, completion: { isFinished in
            self.giftModel = nil
            self.digitLabel.alpha = 0.0
            self.frame.origin.x = -self.frame.width
            self.currentNumber = 0
            self.state = .idle
            
            //结束动画代理
            self.delegate?.giftAnimationDidCompletion()
        })
    }
}
