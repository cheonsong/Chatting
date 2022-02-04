//
//  ChatView+Scroll.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/18.
//

import UIKit

extension ChatView : UIScrollViewDelegate {
    
    // 스크롤이 일정 높이만큼 올라갔을 때 아래로 버튼 생성
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentOffsetY = -scrollView.contentOffset.y + tableView.frame.height

        if contentOffsetY < tableView.frame.height * 0.2 {
            downButton.isHidden = false
        } else {
            downButton.isHidden = true
        }

    }
}

