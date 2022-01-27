//
//  ChatView+Scroll.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/18.
//

import UIKit

extension ChatView : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = -scrollView.contentOffset.y + tableView.frame.height
        let contentSize = tableView.contentSize.height
        let paginationY = contentSize * 0.8
        if contentOffsetY < contentSize - paginationY {
            downButton.isHidden = false
        } else {
            downButton.isHidden = true
        }
    }
}
