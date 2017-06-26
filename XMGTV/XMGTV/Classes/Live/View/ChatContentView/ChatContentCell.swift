//
//  ChatContentCell.swift
//  XMGTV
//
//  Created by 唐三彩 on 2017/6/26.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

class ChatContentCell: UITableViewCell {
    
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        contentLabel.font = UIFont.systemFont(ofSize: 15)
        contentLabel.textColor = UIColor.white
        selectionStyle = .none
        contentView.backgroundColor = UIColor.clear
    }
    
}
