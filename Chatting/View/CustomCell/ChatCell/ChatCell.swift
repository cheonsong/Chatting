//
//  ChatCell.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/17.
//

import UIKit
import RxSwift

class ChatCell: UITableViewCell {
    
    // MARK: Variables
    // 프로필 썸네일 클릭 시 실행되는 함수 ==> ChatView+Table -> DataSource 에서 구현
    var showProfile: (()->Void)? = nil
    var email: String?
    
    // MARK: Constant
    
    // MARK: IBOutlet
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var chat: UILabel!
    @IBOutlet weak var chatSuperView: UIView!
    @IBOutlet weak var profileImage: UIButton!
    
    // MARK: IBAction
    // 프로필 썸네일 클릭 시 실행되는 함수
    @IBAction func showMiniProfile(_ sender: UIButton) {
        
        if let showMiniProfile = self.showProfile {
            showMiniProfile()
        }
        
    }
    
    deinit {
        print("ChatCell deinit")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .clear
        chatSuperView.layer.cornerRadius = 4
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
