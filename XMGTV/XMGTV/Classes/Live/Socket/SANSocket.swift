//
//  SANSocket.swift
//  Client
//
//  Created by 唐三彩 on 2017/6/19.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

protocol SANSocketDelegate : class {
    func socket(_ socket : SANSocket, joinRoom user : UserInfo)
    func socket(_ socket : SANSocket, leaveRoom user : UserInfo)
    func socket(_ socket : SANSocket, chatMsg : ChatMessage)
    func socket(_ socket : SANSocket, giftMsg : GiftMessage)
}

enum MessageType : Int {
    case join = 0
    case leave = 1
    case text = 2
    case gift = 3
}

class SANSocket: NSObject {
    weak var delegate : SANSocketDelegate?
    
    fileprivate var tcpClient : TCPClient
    fileprivate var isConnected : Bool = false
    fileprivate lazy var user : UserInfo.Builder = {
        let user = UserInfo.Builder()
        user.level = Int32(arc4random_uniform(20))
        user.name = "why\(arc4random_uniform(10))"
        user.iconUrl = "icon\(arc4random_uniform(2))"
        return user
    }()
    
    init(addr : String, port : Int) {
        tcpClient = TCPClient(addr: addr, port: port)
    }
}

extension SANSocket {
    
    func connectServer(_ timeout : Int) -> Bool {
        isConnected = true
        return tcpClient.connect(timeout: timeout).0
    }
    
    func startReadMsg() {
        DispatchQueue.global().async {
            while self.isConnected {
                // 1.取出长度消息
                if let lengthMsg = self.tcpClient.read(4) {
                    let lData = Data(bytes: lengthMsg, count: 4)
                    var length : Int = 0
                    (lData as NSData).getBytes(&length, length: 4)
                    
                    // 2.读取类型消息
                    guard let typeMsg = self.tcpClient.read(2) else {
                        continue
                    }
                    
                    var type : Int = 0
                    let tdata = Data(bytes: typeMsg, count: 2)
                    (tdata as NSData).getBytes(&type, length: 2)
                    
                    // 3.读取消息
                    guard let msg = self.tcpClient.read(length) else {
                        continue
                    }
                    let msgData = Data(bytes: msg, count: length)
                    
                    // 4.消息转发出去
                    DispatchQueue.main.async {
                        self.handleMsg(type, msgData: msgData)
                    }
                }
            }
        }
    }
    
    fileprivate func handleMsg(_ type : Int, msgData : Data) {
        switch type {
        case 0, 1:
            let user = try! UserInfo.parseFrom(data: msgData)
            type == 0 ? delegate?.socket(self, joinRoom: user) : delegate?.socket(self, leaveRoom: user)
        case 2:
            let chatMsg = try! ChatMessage.parseFrom(data: msgData)
            delegate?.socket(self, chatMsg: chatMsg)
        case 3:
            let giftMsg = try! GiftMessage.parseFrom(data: msgData)
            delegate?.socket(self, giftMsg: giftMsg)
        default:
            print("其他类型消息")
        }
    }
    
    func sendJoinMsg() {
        // 1.获取长度
        let data = (try! user.build()).data()
        
        // 2.发送消息
        sendMsg(type: 0, msgData: data)
    }
    
    func sendLeaveMsg() {
        // 1.获取长度
        let data = (try! user.build()).data()
        
        // 2.发送消息
        sendMsg(type: 1, msgData: data)
    }
    
    func sendTextMsg(_ text : String) {
        // 1.创建聊天的对象
        let chatMsg = ChatMessage.Builder()
        chatMsg.text = text
        chatMsg.user = try! user.build()
        
        // 2.转成data类型
        let chatData = (try! chatMsg.build()).data()
        
        // 3.发送消息
        sendMsg(type: 2, msgData: chatData)
    }
    
    func sendGiftMsg(_ giftname : String, _ giftURL : String, _ giftcount : Int) {
        // 1.创建礼物的对象
        let giftMsg = GiftMessage.Builder()
        giftMsg.giftname = giftname
        giftMsg.giftUrl = giftURL
        giftMsg.giftcount = Int32(giftcount)
        giftMsg.user = try! user.build()
        
        // 2.转成data类型
        let giftData = (try! giftMsg.build()).data()
        
        // 3.发送消息
        sendMsg(type: 3, msgData: giftData)
    }
    
    func sendBeatsData() {
        let heartStr = "heart"
        let heartData = heartStr.data(using: .utf8)!
        
        sendMsg(type: 100, msgData: heartData)
        
    }
    
    func sendMsg(type : Int, msgData : Data) {
        // 1.长度data
        var length = msgData.count
        let lengthData = Data(bytes: &length, count: 4)
        
        // 2.类型data
        var type = type
        let typeData = Data(bytes: &type, count: 2)
        
        // 3.拼接所有的data,并且发送消息
        let totalData = lengthData + typeData + msgData
        _ = tcpClient.send(data: totalData)
    }
}

