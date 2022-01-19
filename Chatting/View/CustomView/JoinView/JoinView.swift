//
//  JoinView.swift
//  Chatting
//
//  Created by cheonsong on 2022/01/19.
//

import UIKit
import RxCocoa
import RxSwift

class JoinView: UIView {
    
    var view: UIView?
    let colorManager = CustomColor()
    let placeholder = "소개글을 작성해주세요"
    let viewModel = JoinViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var superView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var pictureView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sexView: NSLayoutConstraint!
    @IBOutlet weak var manButton: UIButton!
    @IBOutlet weak var womanButton: UIButton!
    @IBOutlet weak var yearView: UIView!
    @IBOutlet weak var monthView: UIView!
    @IBOutlet weak var dayView: UIView!
    @IBOutlet weak var remainTextLabel: UILabel!
    @IBOutlet weak var introduceSuperView: UIView!
    @IBOutlet weak var introduceTextView: UITextView!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var yearButton: UIButton!
    @IBOutlet weak var monthButton: UIButton!
    @IBOutlet weak var dayButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        bindToViewModel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
        bindToViewModel()
    }
    
    private func initialize() {
        self.view = Bundle.main.loadNibNamed("JoinView", owner: self, options: nil)?.first as? UIView
        view?.frame = self.bounds
        self.addSubview(view!)
        
        setCornerRadius()
        setBorderColor()
        setBorderWidth()
        setTextColor()
    }
    
    func bindToViewModel() {
        let input = JoinViewModel.Input(backButtonClicked: backButton.rx.tap.asObservable(),
                                    manButtonClicked: manButton.rx.tap.asObservable(),
                                    womanButtonClicked: womanButton.rx.tap.asObservable(),
                                    yearButtonClicked: yearButton.rx.tap.asObservable(),
                                    monthButtonClicked: monthButton.rx.tap.asObservable(),
                                    dayButtonClicked: dayButton.rx.tap.asObservable(),
                                    introduceText: introduceTextView.rx.text.orEmpty.asObservable(),
                                    joinButtonClicked: joinButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.deleteView
            .subscribe(onNext: {
                self.removeFromSuperview()
            })
            .disposed(by: disposeBag)

    }
    
    func setCornerRadius() {
        pictureView.layer.cornerRadius = 10
        textField.layer.cornerRadius = 5
        manButton.layer.cornerRadius = 5
        womanButton.layer.cornerRadius = 5
        yearView.layer.cornerRadius = 5
        monthView.layer.cornerRadius = 5
        dayView.layer.cornerRadius = 5
        introduceSuperView.layer.cornerRadius = 4
        joinButton.layer.cornerRadius = joinButton.frame.height / 2
    }
    
    func setBorderColor() {
        topView.layer.addBorder([.bottom], color: CustomColor.instance.color223, width: 1)
        pictureView.layer.borderColor = CustomColor.instance.color223.cgColor
        textField.layer.borderColor = CustomColor.instance.color223.cgColor
        manButton.layer.borderColor = CustomColor.instance.color223.cgColor
        womanButton.layer.borderColor = CustomColor.instance.color223.cgColor
        yearView.layer.borderColor = CustomColor.instance.color223.cgColor
        monthView.layer.borderColor = CustomColor.instance.color223.cgColor
        dayView.layer.borderColor = CustomColor.instance.color223.cgColor
        introduceSuperView.layer.borderColor = CustomColor.instance.color223.cgColor
    }
    
    func setBorderWidth() {
        pictureView.layer.borderWidth = 1
        textField.layer.borderWidth = 1
        manButton.layer.borderWidth = 1
        womanButton.layer.borderWidth = 1
        yearView.layer.borderWidth = 1
        monthView.layer.borderWidth = 1
        dayView.layer.borderWidth = 1
        introduceSuperView.layer.borderWidth = 1
    }
    
    func setTextColor() {
        textField.textColor = CustomColor.instance.color99
        introduceTextView.textColor = CustomColor.instance.color191
    }
}
