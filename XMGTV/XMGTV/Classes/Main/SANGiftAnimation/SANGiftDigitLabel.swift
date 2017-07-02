//
//  SANGiftDigitLabel.swift
//  XMGTV
//
//  Created by 唐三彩 on 2017/6/27.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

class SANGiftDigitLabel: UILabel {

    override func drawText(in rect: CGRect) {
        //保存文本颜色
        let oldColor = textColor
        
        // 1.获取上下文
        let context = UIGraphicsGetCurrentContext()
        
        // 2.给上下文线段设置一个宽度, 通过该宽度画出文本
        context?.setLineWidth(5)
        context?.setLineJoin(.round)
        context?.setTextDrawingMode(.stroke)
        textColor = UIColor.orange
        super.drawText(in: rect)
        
        context?.setTextDrawingMode(.fill)
        textColor = oldColor
        shadowOffset = CGSize.zero
        
        super.drawText(in: rect)
    }
    
    
    func showDigitAnimation(_ complection : @escaping () -> ()) {
        UIView.animateKeyframes(withDuration: 0.25, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5, animations: {
                self.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                self.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            })
        }, completion: { isFinished in
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: [], animations: {
                self.transform = CGAffineTransform.identity
            }, completion: { (isFinished) in
                complection()
            })
        })
        
    }}
