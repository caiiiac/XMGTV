//
//  EmoticonViewCell.swift
//  XMGTV
//
//  Created by 唐三彩 on 2017/6/15.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

class EmoticonViewCell: UICollectionViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    
    var emoticon : Emoticon? {
        didSet {
            iconImageView.image = UIImage(named: emoticon!.emoticonName)
        }
    }
}
