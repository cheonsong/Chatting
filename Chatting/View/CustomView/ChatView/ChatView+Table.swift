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
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.backgroundColor = .clear
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        updateTableContentInset()
        
//        self.tableView.rx.setDelegate(self).disposed(by: disposeBag)
//
//        Observable.of(list)
//            .bind(to: self.tableView.rx.items(cellIdentifier: "ChatCell", cellType: ChatCell.self)) { index, element, cell in
//                cell.chat.text = element.chat!
//                cell.nickname.text = element.nickname!
//            }.disposed(by: disposeBag)
    }
    
    // 채팅이 아래서부터 올라오도록 업데이트
    func updateTableContentInset() {
        let numRows = self.tableView.numberOfRows(inSection: 0)
        var contentInsetTop = self.tableView.bounds.size.height
        for i in 0..<numRows {
            let rowRect = self.tableView.rectForRow(at: IndexPath(item: i, section: 0))
            contentInsetTop -= rowRect.size.height
            if contentInsetTop <= 0 {
                contentInsetTop = 0
            }
        }
        self.tableView.contentInset = UIEdgeInsets(top: contentInsetTop,left: 0,bottom: 0,right: 0)
    }
    
}

extension ChatView: UITableViewDelegate {
    
}

extension ChatView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat = self.list[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as! ChatCell
        cell.chat.text = chat.chat!
        cell.nickname.text = chat.nickname!
        
        return cell
    }
    
    
}
