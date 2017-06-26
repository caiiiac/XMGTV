//
//  ChatContentView.swift
//  XMGTV
//
//  Created by 唐三彩 on 2017/6/26.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

private let kChatContentCell = "kChatContentCell"

class ChatContentView: UIView, NibLoadable {
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate lazy var messages : [NSAttributedString] = [NSAttributedString]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.register(UINib(nibName: "ChatContentCell", bundle: nil), forCellReuseIdentifier: kChatContentCell)
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func insertMsg(_ message : NSAttributedString) {
        messages.append(message)
        tableView.reloadData()
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}


extension ChatContentView : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kChatContentCell, for: indexPath) as! ChatContentCell
        cell.contentLabel.attributedText = messages[indexPath.row]
        return cell
    }
}
