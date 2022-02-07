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
    let colorManager = ColorManager.instance
    let placeholder = "소개글을 작성해주세요 "
    let viewModel = JoinViewModel()
    let disposeBag = DisposeBag()
    let imagePicker = UIImagePickerController()
    
    var userInfo: JoinModel?
    var imageName: String?
    let apiManager = JoinApiManager(service: APIServiceProvider())
    var kakaoEmail: String?
    var naverEmail: String?
    
    // 생년월일 데이트피커
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
        
        // Input: backButtonClicked
        // 회원가입창에서 뒤로가기
        output.deleteView
            .subscribe(onNext: {
                self.removeFromSuperview()
            })
            .disposed(by: disposeBag)
        
        // Input: manButtonClicked
        output.checkManButton
            .subscribe(onNext: { _ in
                self.manButton.layer.borderColor = UIColor.blue.cgColor
                self.manButton.backgroundColor = self.colorManager.manButtonColor
                self.womanButton.layer.borderColor = self.colorManager.color223.cgColor
                self.womanButton.backgroundColor = UIColor.white
                self.manButton.isSelected = true
                self.womanButton.isSelected = false
                print(self.validation())
            })
            .disposed(by: disposeBag)
        
        // Input: womanButtonClicked
        output.checkWomanButton
            .subscribe(onNext: { _ in
                self.manButton.layer.borderColor = self.colorManager.color223.cgColor
                self.manButton.backgroundColor = UIColor.white
                self.womanButton.layer.borderColor = self.colorManager.womanButtonBorder.cgColor
                self.womanButton.backgroundColor = self.colorManager.womanButtonColor
                self.manButton.isSelected = false
                self.womanButton.isSelected = true
                print(self.validation())
            })
            .disposed(by: disposeBag)
        
        // Input: imagePickButtonClicked
        // 라이브러리에서 이미지 선택하기
        output.imagePick
            .subscribe(onNext: { _ in
                self.openLibrary()
                print(self.validation())
            })
            .disposed(by: disposeBag)
        
        // Input: yearButtonClicked
        output.yearPick
            .subscribe(onNext: { _ in
                self.view?.addSubview(self.yearPickerView)
                self.view?.addSubview(self.pickerToolbar)
                print(self.validation())
            })
            .disposed(by: disposeBag)
        
        // Input: monthButtonClicked
        output.monthPick
            .subscribe(onNext: { _ in
                self.view?.addSubview(self.monthPickerView)
                self.view?.addSubview(self.pickerToolbar)
                print(self.validation())
            })
            .disposed(by: disposeBag)
        
        // Input: dayButtonClicked
        output.dayPick
            .subscribe(onNext: { _ in
                self.view?.addSubview(self.dayPickerView)
                self.view?.addSubview(self.pickerToolbar)
                print(self.validation())
            })
            .disposed(by: disposeBag)
        
        // Input: introduceText
        // (0/200) 텍스트 변경
        output.textCount
            .bind(to: remainTextLabel.rx.text)
            .disposed(by: disposeBag)
        
        // Input: introduceText
        output.textCount
            .subscribe(onNext: { _ in
                print(self.validation())
            })
            .disposed(by: disposeBag)
        
        // Input: joinButtonClicked
        // 작성된 회원정보를 서버로 보냄
        output.userInfo
            .subscribe(onNext: { _ in
                self.userInfo = self.setUserInfo()
                //self.apiManager.postUserInfo(self.userInfo!, completion: nil)
                self.removeFromSuperview()
            })
            .disposed(by: disposeBag)
        
    }
    
    // 모든 정보가 작성됐을 경우에만 가입버튼 활성화
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
    
    // 회원정보 모델
    func setUserInfo() -> JoinModel {
        let userInfo = JoinModel()
        
        userInfo.email = kakaoEmail == "" ? naverEmail! : kakaoEmail!
        userInfo.name = textField.text
        userInfo.profileImg = imageView.image
        userInfo.age = currentAge()
        userInfo.costs = introduceTextView.text
        userInfo.gender = manButton.isSelected ? "m" : "f"
        
        return userInfo
    }
    
    // 현재 나이 계산 함수
    func currentAge() -> String {
        let year = yearLabel.text?.trimmingCharacters(in: .letters)
        
        return String(compareDate(prevTime: year!) / (60*60*24*365) + 1)
        
    }
}
