//
//  ProfileView.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/21.
//

import UIKit

class ProfileView: UIView {

    var view: UIView?
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var likeLabel: UIView!
    @IBOutlet weak var sexAgeSuperView: UIView!
    @IBOutlet weak var sexAgeView: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var introduceView: UIView!
    
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
    
    func setBackgroundColor() {
        sexAgeView.backgroundColor = .white
        locationView.backgroundColor = .white
        sexAgeSuperView.backgroundColor = .white
    }
    
    func setCornerRadius() {
        likeLabel.layer.cornerRadius = likeLabel.frame.height / 2
        bottomView.layer.cornerRadius = 25
        sexAgeView.layer.cornerRadius = sexAgeView.frame.height / 2
        locationView.layer.cornerRadius = locationView.frame.height / 2
        introduceView.layer.cornerRadius = 4
    }
    
    func setBorder() {
        sexAgeView.layer.borderColor = CustomColor.instance.profileSexAgeBorderColor.cgColor
        sexAgeView.layer.borderWidth = 1
        
        likeLabel.layer.borderColor = CustomColor.instance.profileLikeBorderColor.cgColor
        likeLabel.layer.borderWidth = 1
        
        locationView.layer.borderColor = CustomColor.instance.locationViewBorderColor.cgColor
        locationView.layer.borderWidth = 1
        
        introduceView.layer.borderColor = CustomColor.instance.color238.cgColor
        introduceView.layer.borderWidth = 1
    }
    
    func setGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.delegate = self
        self.topView.addGestureRecognizer(tapGesture)
    }
}
