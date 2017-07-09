//
//  RoomViewController.swift
//  XMGTV
//
//  Created by 唐三彩 on 2017/6/8.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit
import IJKMediaFramework


private let kChatToolsViewHeight : CGFloat = 44
private let kGiftlistViewHeight : CGFloat = kScreenH * 0.5
private let kChatContentViewHeight : CGFloat = 200

class RoomViewController: UIViewController, Emitterable{
    
    // MARK: 控件属性
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var roomNumLabel: UILabel!
    
    fileprivate lazy var chatToolsView : ChatToolsView = ChatToolsView.loadFromNib()
    fileprivate lazy var giftListView : GiftListView = GiftListView.loadFromNib()
    fileprivate lazy var chatContentView : ChatContentView = ChatContentView.loadFromNib()
    
    fileprivate lazy var socket : SANSocket = SANSocket(addr: "192.168.1.103", port: 7999)
    fileprivate lazy var giftContainerView : SANGiftContainerView = SANGiftContainerView(frame: CGRect(x: 0, y: 100, width: 250, height: 100))

    fileprivate var beatsTimer : Timer?
    
    fileprivate lazy var roomVM : RoomViewModel = RoomViewModel()
    
    //播放器
    fileprivate var player : IJKFFMoviePlayerController?
    
    // MARK: 对外提供控件属性
    var anchor : AnchorModel?
    
    
    // MARK: 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        //监听键盘通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        //连接聊天服务器
        if socket.connectServer(10) {
            print("连接成功")
            socket.startReadMsg()
            addBeatsTimer()
            socket.sendJoinMsg()
            socket.delegate = self
        }
        
        // 加载房间信息
        loadRoomInfo()
        // 设置内容
        setupAnchorInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        socket.sendLeaveMsg()
        player?.shutdown()
    }
    
    deinit {
        beatsTimer?.invalidate()
        beatsTimer = nil
        NotificationCenter.default.removeObserver(self)
    }
}


// MARK:- 设置UI界面内容
extension RoomViewController {
    fileprivate func setupUI() {
        setupBlurView()
        setupBottomView()
        view.addSubview(giftContainerView)
    }
    
    fileprivate func setupBlurView() {
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        blurView.frame = bgImageView.bounds
        bgImageView.addSubview(blurView)
    }
    
    fileprivate func setupBottomView() {
        
        // 设置Chat内容的View
        chatContentView.frame = CGRect(x: 0, y: view.bounds.height - 44 - kChatContentViewHeight, width: view.bounds.width, height: kChatContentViewHeight)
        chatContentView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        view.addSubview(chatContentView)

        
        // 设置chatToolsView
        chatToolsView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: kChatToolsViewHeight)
        chatToolsView.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        chatToolsView.delegate = self
        view.addSubview(chatToolsView)
        
        // 设置giftListView
        giftListView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: kGiftlistViewHeight)
        giftListView.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        view.addSubview(giftListView)
        giftListView.delegate = self
    }
}

// MARK:- 加载房间信息
extension RoomViewController {
    fileprivate func loadRoomInfo() {
        if let roomid = anchor?.roomid, let uid = anchor?.uid {
            print(roomid, uid)
            roomVM.loadLiveURL(roomid, uid, {
                self.setupDisplayView()
            })
        }
    }
    
    fileprivate func setupDisplayView() {
        // 0.关闭log
        IJKFFMoviePlayerController.setLogReport(false)
        
        // 1.初始化播放器
        let url = URL(string: roomVM.liveURL)
        player = IJKFFMoviePlayerController(contentURL: url, with: nil)
        
        // 2.设置播放器View的位置和尺寸
        if anchor?.push == 1 {
            let screenW = UIScreen.main.bounds.width
            player?.view.frame = CGRect(x: 0, y: 150, width: screenW, height: screenW * 3 / 4)
        } else {
            player?.view.frame = view.bounds
        }
        
        // 3.将view添加到控制器的view中
        bgImageView.insertSubview(player!.view, at: 1)
        
        // 4.准备播放
        DispatchQueue.global().async {
            self.player?.prepareToPlay()
            self.player?.play()
        }
    }
    
}

// MARK:- 设置内容
extension RoomViewController {
    fileprivate func setupAnchorInfo() {
        bgImageView.setImage(anchor?.pic74)
        nickNameLabel.text = anchor?.name
        roomNumLabel.text = "房间号：\(anchor!.roomid)"
        iconImageView.setImage(anchor?.pic51)
        
    }
}


// MARK:- 事件监听
extension RoomViewController {
    @IBAction func exitBtnClick() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        chatToolsView.inputTextField.resignFirstResponder()
        
        UIView.animate(withDuration: 0.25, animations: {
            self.giftListView.frame.origin.y = kScreenH
        })

    }
    
    @IBAction func bottomMenuClick(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            chatToolsView.inputTextField.becomeFirstResponder()
        case 1:
            print("点击了分享")
        case 2:
            UIView.animate(withDuration: 0.25, animations: {
                self.giftListView.frame.origin.y = kScreenH - kGiftlistViewHeight
            })
        case 3:
            print("点击了更多")
        case 4:
            sender.isSelected = !sender.isSelected
            let point = CGPoint(x: sender.center.x, y: view.bounds.height - sender.bounds.height * 0.5)
            sender.isSelected ? startEmittering(point) : stopEmittering()
        default:
            fatalError("未处理按钮")
        }
    }
}

// MARK:- 监听键盘的弹出
extension RoomViewController {
    @objc fileprivate func keyboardWillChangeFrame(_ note : Notification) {
        let duration = note.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let endFrame = (note.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let inputViewY = endFrame.origin.y - kChatToolsViewHeight
        
        UIView.animate(withDuration: duration, animations: {
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: 7)!)
            let endY = inputViewY == (kScreenH - kChatToolsViewHeight) ? kScreenH : inputViewY
            self.chatToolsView.frame.origin.y = endY
            let contentEndY = inputViewY == (kScreenH - kChatToolsViewHeight) ? (kScreenH - kChatContentViewHeight - 44) : endY - kChatContentViewHeight
            self.chatContentView.frame.origin.y = contentEndY
        })
    }
}



// MARK:- 监听用户输入的内容
extension RoomViewController : ChatToolsViewDelegate, GiftListViewDelegate{
    func chatToolsView(toolView: ChatToolsView, message: String) {
        socket.sendTextMsg(message)
    }
    
    func giftListView(giftView: GiftListView, giftModel: GiftModel) {
        socket.sendGiftMsg(giftModel.subject, giftModel.img2, giftModel.coin)
    }
}

//MARK: - 给服务器发送即时消息
extension RoomViewController {
    fileprivate func addBeatsTimer () {
        beatsTimer = Timer(fireAt: Date(), interval: 9, target: self, selector: #selector(sendBeats), userInfo: nil, repeats: true)
        RunLoop.main.add(beatsTimer!, forMode: .commonModes)
    }
    
    @objc fileprivate func sendBeats() {
        socket.sendBeatsData()
    }
}

// MARK:- 接受聊天服务器返回的消息
extension RoomViewController : SANSocketDelegate {
    func socket(_ socket: SANSocket, joinRoom user: UserInfo) {
        chatContentView.insertMsg(AttrStringGenerator.generateJoinLeaveRoom(user.name, true))
    }
    
    func socket(_ socket: SANSocket, leaveRoom user: UserInfo) {
        chatContentView.insertMsg(AttrStringGenerator.generateJoinLeaveRoom(user.name, false))
    }
    
    func socket(_ socket: SANSocket, chatMsg: ChatMessage) {
        // 1.通过富文本生成器, 生成需要的富文本
        let chatMsgMAttr = AttrStringGenerator.generateTextMessage(chatMsg.user.name, chatMsg.text)
        
        // 2.将文本的属性字符串插入到内容View中
        chatContentView.insertMsg(chatMsgMAttr)
    }
    
    func socket(_ socket: SANSocket, giftMsg: GiftMessage) {
        // 1.通过富文本生成器, 生成需要的富文本
        let giftMsgAttr = AttrStringGenerator.generateGiftMessage(giftMsg.giftname, giftMsg.giftUrl, giftMsg.user.name)
        
        // 2.将文本的属性字符串插入到内容View中
        chatContentView.insertMsg(giftMsgAttr)
        
        let gif = SANGiftModel(senderName: giftMsg.user.name, senderURL: giftMsg.user.iconUrl, giftName: giftMsg.giftname, giftURL: giftMsg.giftUrl)
            giftContainerView.showGiftModel(gif)
        
        
    }
}
