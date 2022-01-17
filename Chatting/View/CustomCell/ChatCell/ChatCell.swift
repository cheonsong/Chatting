//
//  ChatCell.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/17.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var chat: UILabel!
    @IBOutlet weak var chatSuperView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        chatSuperView.layer.cornerRadius = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
