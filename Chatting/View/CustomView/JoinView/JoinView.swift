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
    // MARK: Property
    var view: UIView?
    let colorManager = CustomColor()
    let placeholder = "소개글을 작성해주세요 "
    let viewModel = JoinViewModel()
    let disposeBag = DisposeBag()
    let imagePicker = UIImagePickerController()
    var userInfo: JoinModel?
    var imageName: String?
    let apiManager = JoinApiManager(service: APIServiceProvider())
    var kakaoEmail: String?
    
    
    let yearPickerView = UIPickerView()
    let monthPickerView = UIPickerView()
    let dayPickerView = UIPickerView()
    let pickerToolbar = UIToolbar()
    
    let year = Array(1900...2022).map{String($0)}
    let month = Array(1...12).map{String($0)}
    let day = Array(1...31).map{String($0)}
    
    // MARK: IBOutlet
    // 프로필사진
    @IBOutlet weak var addImageLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imagePickButton: UIButton!
    @IBOutlet weak var pictureView: UIView!
    
    // 돌아가기 버튼
    @IBOutlet weak var backButton: UIButton!
    
    // 상위뷰
    @IBOutlet weak var superView: UIView!
    @IBOutlet weak var topView: UIView!
    
    // 닉네임
    @IBOutlet weak var textField: UITextField!
    
    // 성별
    @IBOutlet weak var manButton: UIButton!
    @IBOutlet weak var womanButton: UIButton!
    
    // 생년월일
    @IBOutlet weak var yearView: UIView!
    @IBOutlet weak var monthView: UIView!
    @IBOutlet weak var dayView: UIView!
    @IBOutlet weak var yearButton: UIButton!
    @IBOutlet weak var monthButton: UIButton!
    @IBOutlet weak var dayButton: UIButton!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    // 소개
    @IBOutlet weak var remainTextLabel: UILabel!
    @IBOutlet weak var introduceSuperView: UIView!
    @IBOutlet weak var introduceTextView: UITextView!
    
    // 가입완료
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    // MARK: Init
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
        
        setDelegate()
        setCornerRadius()
        setBorderColor()
        setBorderWidth()
        setTextColor()
        setKeyboardNoti()
        setGestureRecognizer()
        setPickerView()
    }
    
    // MARK: Function
    func bindToViewModel() {
        let input = JoinViewModel.Input(
                                        imagePickButtonClicked: imagePickButton.rx.tap.asObservable(),
                                        backButtonClicked: backButton.rx.tap.asObservable(),
                                        manButtonClicked: manButton.rx.tap.asObservable(),
                                        womanButtonClicked: womanButton.rx.tap.asObservable(),
                                        yearButtonClicked: yearButton.rx.tap.asObservable(),
                                        monthButtonClicked: monthButton.rx.tap.asObservable(),
                                        dayButtonClicked: dayButton.rx.tap.asObservable(),
                                        introduceText: introduceTextView.rx.text.orEmpty.asObservable(),
                                        joinButtonClicked: joinButton.rx.tap.asObservable()
                                        
        )
        
        let output = viewModel.transform(input: input)
        
        output.deleteView
            .subscribe(onNext: {
                self.removeFromSuperview()
            })
            .disposed(by: disposeBag)
        
        output.checkManButton
            .subscribe(onNext: { _ in
                self.manButton.layer.borderColor = UIColor.blue.cgColor
                self.manButton.backgroundColor = CustomColor.instance.manButtonColor
                self.womanButton.layer.borderColor = CustomColor.instance.color223.cgColor
                self.womanButton.backgroundColor = UIColor.white
                self.manButton.isSelected = true
                self.womanButton.isSelected = false
                print(self.validation())
            })
            .disposed(by: disposeBag)
        
        output.checkWomanButton
            .subscribe(onNext: { _ in
                self.manButton.layer.borderColor = CustomColor.instance.color223.cgColor
                self.manButton.backgroundColor = UIColor.white
                self.womanButton.layer.borderColor = CustomColor.instance.womanButtonBorder.cgColor
                self.womanButton.backgroundColor = CustomColor.instance.womanButtonColor
                self.manButton.isSelected = false
                self.womanButton.isSelected = true
                print(self.validation())
            })
            .disposed(by: disposeBag)
        
        output.imagePick
            .subscribe(onNext: { _ in
                self.openLibrary()
                print(self.validation())
            })
            .disposed(by: disposeBag)
        
        output.yearPick
            .subscribe(onNext: { _ in
                self.view?.addSubview(self.yearPickerView)
                self.view?.addSubview(self.pickerToolbar)
                print(self.validation())
            })
            .disposed(by: disposeBag)
        
        output.monthPick
            .subscribe(onNext: { _ in
                self.view?.addSubview(self.monthPickerView)
                self.view?.addSubview(self.pickerToolbar)
                print(self.validation())
            })
            .disposed(by: disposeBag)
        
        output.dayPick
            .subscribe(onNext: { _ in
                self.view?.addSubview(self.dayPickerView)
                self.view?.addSubview(self.pickerToolbar)
                print(self.validation())
            })
            .disposed(by: disposeBag)
        
        output.textCount
            .bind(to: remainTextLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.textCount
            .subscribe(onNext: { _ in
                print(self.validation())
            })
            .disposed(by: disposeBag)
        
        output.userInfo
            .subscribe(onNext: { _ in
                self.userInfo = self.setUserInfo()
                self.apiManager.postUserInfo(self.userInfo!, completion: nil)
                self.removeFromSuperview()
            })
            .disposed(by: disposeBag)
        
    }
    
    func validation() -> Bool{
        
        if !textField.text!.isEmpty && (manButton.isSelected || womanButton.isSelected) && yearLabel.text!.count > 1 && monthLabel.text!.count > 1 && dayLabel.text!.count > 1 && !introduceTextView.text!.isEmpty {
            joinButton.isEnabled = true
            joinButton.backgroundColor = .purple
            return true
        }
        joinButton.isEnabled = false
        joinButton.backgroundColor = .gray
        return false
    }
    
    func setUserInfo() -> JoinModel {
        let userInfo = JoinModel()
        
        userInfo.email = kakaoEmail
        userInfo.name = textField.text
        userInfo.profileImg = imageView.image
        userInfo.age = "26"
        userInfo.costs = introduceTextView.text
        userInfo.gender = manButton.isSelected ? "M" : "F"
        
        return userInfo
    }
}
