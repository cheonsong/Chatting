//
//  ChatView+Table.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/18.
//

import Foundation
import UIKit

extension ChatView {
    
    func setTableView() {
        self.tableView.register(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: "ChatCell")
        self.tableView.register(UINib(nibName: "SystemChatCell", bundle: nil), forCellReuseIdentifier: "SystemChatCell")
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.backgroundColor = UIColor.clear
        // 테이블뷰 뒤집기 -> 채팅이 아래에서 위로 올라오도록 하기 위해
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func setTableViewGradient() {
        // 테이블뷰 상단 블러처리
        let gradient = CAGradientLayer()
        gradient.frame = tableView.superview?.bounds ?? CGRect.null
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.0, 0.15]
        tableView.superview?.layer.mask = gradient
    }
    
}

extension ChatView: UITableViewDelegate {
    
}

extension ChatView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 테이블뷰를 뒤집었기 때문에 list도 뒤집어 줘야함
        let chat = self.list.reversed()[indexPath.row]
        
        switch (chat.type) {
            
        // 시스템 채팅
        case .system:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SystemChatCell") as! SystemChatCell
            cell.message.text = chat.chat!
            cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
            return cell
            
        // 일반 채팅
        case .user:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as! ChatCell
            cell.email = chat.email!
            cell.chat.text = chat.chat!
            cell.nickname.text = chat.nickname!
            cell.profileImage.setImage(chat.image, for: .normal)
            cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
            
            // cell의 프로필 이미지가 클릭됐을 시 실행될 함수
            cell.showProfile = {
                self.apiManager.getMembershipStatus(chat.email!, completion: { data in
                    let profileView = ProfileView(frame: self.chatView!.frame)
                    let userInfo = data["mem_info"]
                    profileView.nameLabel.text = userInfo["name"].stringValue
                    profileView.ageLabel.text = userInfo["age"].stringValue
                    profileView.introduceLabel.text = userInfo["contents"].stringValue
                    do {
                        let imageData = try Data(contentsOf: URL(string: userInfo["profile_image"].stringValue)!)
                        profileView.profileImage.image = UIImage(data: imageData)
                    } catch {
                        profileView.profileImage.image = UIImage()
                    }
                    if userInfo["gender"].stringValue == "M" {
                        profileView.profileBorderImage.image = UIImage(named: "img_profile_line_m")
                        profileView.sexImage.image = UIImage(named: "ico_sex_m")
                        profileView.sexAgeView.layer.borderColor = self.colorManager.profileManSexAgeBorderColor.cgColor
                        profileView.ageLabel.textColor = self.colorManager.profileSexLabeltextColor
                    }

                    UIView.transition(with: self.chatView!, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                      self.chatView?.addSubview(profileView)
                    }, completion: nil)
                })
            }
            return cell
            
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    
}
