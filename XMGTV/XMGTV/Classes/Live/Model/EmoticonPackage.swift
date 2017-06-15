//
//  EmoticonPackage.swift
//  XMGTV
//
//  Created by 唐三彩 on 2017/6/15.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

class EmoticonPackage {
    
    lazy var emoticons : [Emoticon] = [Emoticon]()
    
    init(plistName : String) {
        guard let path = Bundle.main.path(forResource: plistName, ofType: nil) else {
            return
        }
        
        guard let emotionArray = NSArray(contentsOfFile: path) as? [String] else {
            return
        }
        
        for str in emotionArray {
            emoticons.append(Emoticon(emoticonName: str))
        }
    }
}
