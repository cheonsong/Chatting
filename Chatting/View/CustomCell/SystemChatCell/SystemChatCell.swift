//
//  SystemChatCell.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/25.
//

import UIKit

class SystemChatCell: UITableViewCell {

    @IBOutlet weak var chatSuperView: UIView!
    @IBOutlet weak var message: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .clear
        chatSuperView.layer.cornerRadius = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
