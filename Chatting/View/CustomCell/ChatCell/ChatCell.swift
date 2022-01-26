//
//  ChatCell.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/17.
//

import UIKit
import RxSwift

class ChatCell: UITableViewCell {

    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var chat: UILabel!
    @IBOutlet weak var chatSuperView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    var disposeBag: DisposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .clear
        chatSuperView.layer.cornerRadius = 4
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
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
