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
    weak var view: UIView?
    var kakaoEmail: String?
    var naverEmail: String?
    var imageName: String?
    var keyboardHeight: CGFloat?
    
    // CustomColor Manager
    let colorManager = ColorManager.instance
    // 소개 입력창 placeholder
    let placeholder = "소개글을 작성해주세요 "
    // Join ViewModel
    let viewModel = JoinViewModel()
    let disposeBag = DisposeBag()
    // 프로필 사진 이미지 피커
    let imagePicker = UIImagePickerController()
    let apiManager = JoinApiManager(service: APIServiceProvider())

    
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
    
    @IBOutlet weak var profileImageSuperView: UIView!
    @IBOutlet weak var addImageLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pictureView: UIView!
    
    // 돌아가기 버튼
    @IBOutlet weak var backButton: UIButton!
    
    // 상위뷰
    @IBOutlet weak var superView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
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
    
    // MARK: Init & Deinit
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
        view?.backgroundColor = .white
        print("JoinView init")
        
        setDelegate()
        
        setCornerRadius()
        
        setBorderColor()
        
        setBorderWidth()
        
        setTextColor()
        
        setKeyboardNoti()
        
        setGestureRecognizer()
        
        setPickerView()
    }
    
    deinit {
        print("JoinView Deinit")
    }
    
    override func draw(_ rect: CGRect) {
        joinButton.setGradient(color1: colorManager.makeColor(r: 133, g: 129, b: 255), color2: colorManager.makeColor(r: 152, g: 107, b: 255))
    }
    
    // MARK: Function
    func bindToViewModel() {
        let input = JoinViewModel.Input(
                                        introduceText: introduceTextView.rx.text.orEmpty.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        // Input: introduceText
        // (0/200) 텍스트 변경
        output.textCount
            .bind(to: remainTextLabel.rx.text)
            .disposed(by: disposeBag)
        
        // Input: backButtonClicked
        // 회원가입창에서 뒤로가기
        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.removeFromSuperview()
            })
            .disposed(by: disposeBag)
        
        // Input: manButtonClicked
        manButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.manButton.layer.borderColor = UIColor.blue.cgColor
                self.manButton.backgroundColor = self.colorManager.manButtonColor
                self.womanButton.layer.borderColor = self.colorManager.color223.cgColor
                self.womanButton.backgroundColor = UIColor.white
                self.manButton.isSelected = true
                self.womanButton.isSelected = false
            })
            .disposed(by: disposeBag)
        
        // Input: womanButtonClicked
        womanButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.manButton.layer.borderColor = self.colorManager.color223.cgColor
                self.manButton.backgroundColor = UIColor.white
                self.womanButton.layer.borderColor = self.colorManager.womanButtonBorder.cgColor
                self.womanButton.backgroundColor = self.colorManager.womanButtonColor
                self.manButton.isSelected = false
                self.womanButton.isSelected = true
            })
            .disposed(by: disposeBag)
        
        // Input: joinButtonClicked
        // 작성된 회원정보를 서버로 보냄
        
        joinButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                let validation = self.validation()
                
                if validation.0 {
                    self.apiManager.postUserInfo(self.getUserInfo(), completion: nil)
                    self.removeFromSuperview()
                } else {
                    let alert = UIAlertController(title: validation.1, message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                    getRootViewController()?.present(alert, animated: false, completion: nil)
                }
                
            })
            .disposed(by: disposeBag)
        
    }
    
    // 모든 정보가 작성됐을 경우에만 가입버튼 활성화
    func validation() -> (Bool,String) {
        
        var what: String = ""
        
        if !textField.text!.isEmpty && (manButton.isSelected || womanButton.isSelected) && yearLabel.text!.count > 1 && monthLabel.text!.count > 1 && dayLabel.text!.count > 1 && introduceTextView.text != placeholder {
            return (true, what)
        }
        
        if textField.text!.isEmpty {
            what = what + "이름, "
        }
        
        if manButton.isSelected && womanButton.isSelected {
            what = what + "성별, "
        }
        
        if yearLabel.text!.count == 1 || monthLabel.text!.count == 1 || dayLabel.text!.count == 1 {
            what = what + "생년월일, "
        }
        
        if introduceTextView.text == placeholder {
            what = what + "소개 "
        }
        
        what = what + "항목이 미입력 됐습니다."
        
        return (false, what)
    }
    
    // 회원정보 모델 얻어오기
    func getUserInfo() -> JoinModel {
        let userInfo = JoinModel()
        
        userInfo.email = kakaoEmail == "" ? naverEmail! : kakaoEmail!
        userInfo.name = textField.text
        userInfo.profileImg = imageView.image ?? UIImage()
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
