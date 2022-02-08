//
//  viewControllerViewController.swift
//  Chatting
//
//  Created by cheonsong on 2022/02/08.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    
    var button: UIButton!
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button = UIButton().then {
            $0.setTitle("Login", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = .lightGray
            $0.layer.cornerRadius = 20
        }
        
        view.addSubview(button)
        
        button.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(150)
            $0.top.bottom.equalToSuperview().inset(400)
        }
        
        button.rx.tap
            .subscribe(onNext: {
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController else { return }
                
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            })
            .disposed(by: bag)
        
    }

}
