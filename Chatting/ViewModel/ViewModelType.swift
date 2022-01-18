//
//  ChatViewModelProtocol.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/17.
//

import Foundation
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get }
    
    func transform(input: Input) -> Output
}
