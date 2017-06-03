//
//  UIColor-Extension.swift
//  XMGTV
//
//  Created by 唐三彩 on 2017/5/31.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

extension UIColor {
    //在extension中给系统的类扩充构造函数,只能扩充便利构造函数
    convenience init(r : CGFloat, g : CGFloat, b : CGFloat, alpha : CGFloat = 1.0) {
        self.init(red: r / 255.0, green: b / 255.0, blue: b / 255.0, alpha: alpha)
    }
    
    convenience init?(hex : String, alpha : CGFloat = 1.0) {
        //判断字符串长度是否符合
        guard hex.characters.count >= 6 else {
            return nil
        }
        //将字符串转成大写
        var tempHex = hex.uppercased()
        
        //判断开头的0x ## # 将去除
        if tempHex.hasPrefix("0x") || tempHex.hasPrefix("##") {
            tempHex = (tempHex as NSString).substring(from: 2)
        }
        if tempHex.hasPrefix("#") {
            tempHex = (tempHex as NSString).substring(from: 1)
        }
        
        var range = NSMakeRange(0, 2)
        let rHex = (tempHex as NSString).substring(with: range)
        range.location = 2
        let gHex = (tempHex as NSString).substring(with: range)
        range.location = 4
        let bHex = (tempHex as NSString).substring(with: range)
        
        var r : UInt32 = 0, g : UInt32 = 0, b : UInt32 = 0
        Scanner(string: rHex).scanHexInt32(&r)
        Scanner(string: gHex).scanHexInt32(&g)
        Scanner(string: bHex).scanHexInt32(&b)
        
        self.init(r: CGFloat(r), g: CGFloat(g), b: CGFloat(b))
    }
    
    class func randomColor() -> UIColor {
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
    
    class func getRGBDelta(_ firstColor : UIColor, _ secondColor : UIColor) -> (CGFloat, CGFloat, CGFloat) {
        let firstRGB = firstColor.getRGB()
        let secondRGB = secondColor.getRGB()
        
        return (firstRGB.0 - secondRGB.0, firstRGB.1 - secondRGB.1, firstRGB.2 - secondRGB.2)
    }
    
    func getRGB() -> (CGFloat, CGFloat, CGFloat) {
        guard let cmps = cgColor.components else {
            fatalError("保证颜色是RGB方式传入")
        }
        
        return(cmps[0] * 255, cmps[1] * 255, cmps[2] * 255)
    }
}
