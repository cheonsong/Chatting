//
//  ProfileView.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/21.
//

import UIKit

class ProfileView: UIView {
    
    // MARK: Property
    var view: UIView?
    let colorManager = ColorManager.instance
    
    // MARK: IBOutlet
    // 바뀌지 않는 뷰
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var likeLabel: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var introduceView: UIView!

    
    // 사람에 따라 바뀌어야할 뷰
    // 성별, 이름
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sexImage: UIImageView!
    @IBOutlet weak var sexAgeSuperView: UIView!
    @IBOutlet weak var sexAgeView: UIView!
    @IBOutlet weak var ageLabel: UILabel!
    
    // 좋아요

    @IBAction func tapLikeButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    // 프로필
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileBorderImage: UIImageView!
    
    // 소개글
    @IBOutlet weak var introduceLabel: UILabel!
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        self.view = Bundle.main.loadNibNamed("ProfileView", owner: self, options: nil)?.first as? UIView
        view?.frame = self.bounds
        self.addSubview(view!)
        
        setCornerRadius()
        setGestureRecognizer()
        setBorder()
        setBackgroundColor()
    }
    
}
