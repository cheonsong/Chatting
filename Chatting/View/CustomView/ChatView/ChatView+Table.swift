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
        
//        self.tableView.rx.setDelegate(self).disposed(by: disposeBag)
//
//        Observable.of(list)
//            .bind(to: self.tableView.rx.items(cellIdentifier: "ChatCell", cellType: ChatCell.self)) { index, element, cell in
//                cell.chat.text = element.chat!
//                cell.nickname.text = element.nickname!
//            }.disposed(by: disposeBag)
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
