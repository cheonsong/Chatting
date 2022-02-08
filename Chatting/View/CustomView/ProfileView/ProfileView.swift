//
//  ProfileView.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/21.
//

import UIKit
import Then
import SnapKit

class ProfileView: UIView {
    
    // MARK: Property
    weak var profileView: UIView?
    let colorManager = ColorManager.instance
    
    // MARK: IBOutlet
    // 바뀌지 않는 뷰
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var likeLabel: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var introduceView: UIView!
    var safeAreaView: UIView!

    
    // 사람에 따라 바뀌어야할 뷰
    // 성별, 이름
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sexImage: UIImageView!
    @IBOutlet weak var sexAgeSuperView: UIView!
    @IBOutlet weak var sexAgeView: UIView!
    @IBOutlet weak var ageLabel: UILabel!
    
    // 프로필
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileBorderImage: UIImageView!
    
    // 소개글
    @IBOutlet weak var introduceLabel: UILabel!
    
    // MARK: IBAction
    // 좋아요
    @IBAction func tapLikeButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    // MARK: Init & Deinit
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    deinit {
        print("ProfileView Deinit")
    }
    
    private func initialize() {
        self.profileView = Bundle.main.loadNibNamed("ProfileView", owner: self, options: nil)?.first as? UIView
        profileView?.frame = self.bounds
        self.addSubview(profileView!)
        
        print("ProfileView init")
        
        safeAreaView = UIView().then {
            $0.backgroundColor = .white
        }
        self.addSubview(safeAreaView)
        safeAreaView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(bottomView.snp.bottom)
        }
        
        setCornerRadius()
        setGestureRecognizer()
        setBorder()
        setBackgroundColor()
    }
}
