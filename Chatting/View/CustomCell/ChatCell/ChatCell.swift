//
//  ChatCell.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/17.
//

import UIKit
import RxSwift

class ChatCell: UITableViewCell {
    
    var showProfile: (()->Void)? = nil

    var apiManager: JoinApiService?
    var email: String?
    private lazy var profileView = ProfileView(frame: CGRect(x: 0, y: 0, width: superview!.frame.width, height: superview!.frame.height))
    
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var chat: UILabel!
    @IBOutlet weak var chatSuperView: UIView!
    @IBOutlet weak var profileImage: UIButton!
    var disposeBag: DisposeBag = DisposeBag()
    
    @IBAction func showMiniProfile(_ sender: UIButton) {
        
        if let showMiniProfile = self.showProfile {
            showMiniProfile()
        }
        
    }
    
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .clear
        chatSuperView.layer.cornerRadius = 4
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.clipsToBounds = true
        
        apiManager = JoinApiManager(service: APIServiceProvider())
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
}
