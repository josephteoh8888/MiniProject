//
//  CreateAccountEmailPanelView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

//import Foundation
//import UIKit
//import SDWebImage
//
//protocol CreateAccountEmailPanelDelegate : AnyObject {
//    func didClickProceedCreateAccountEmail()
//}
//class CreateAccountEmailPanelView: PanelView{
//    var panel = UIView()
//    weak var delegate : CreateAccountEmailPanelDelegate?
//    
//    var viewHeight: CGFloat = 0
//    var viewWidth: CGFloat = 0
//    
//    var panelTopCons: NSLayoutConstraint?
//    
//    let aBoxUnder = UIView()
//    let pTextField = UITextField()
//    let qTextField = UITextField()
//    
////    let gBtnText = UILabel()
////    let gBtn = UIView()
//    let aSpinner = SpinLoader()
//    let aUpload = UIView()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        viewWidth = frame.width
//        viewHeight = frame.height
//        setupViews()
//
//    }
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        
//        setupViews()
//    }
//    
//    func setupViews() {
//        //test 1 > list view of videos
//        panel.backgroundColor = .ddmBlackOverlayColor
//        self.addSubview(panel)
//        panel.translatesAutoresizingMaskIntoConstraints = false
//        panel.layer.masksToBounds = true
//        panel.layer.cornerRadius = 10 //10
//        panel.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
//        panel.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
//        panelTopCons = panel.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -viewHeight)
//        panelTopCons?.isActive = true
//        
//        let aBtn = UIView()
////        aBtn.backgroundColor = .ddmDarkColor
//        aBtn.backgroundColor = .clear
//        panel.addSubview(aBtn)
//        aBtn.translatesAutoresizingMaskIntoConstraints = false
//        aBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
//        aBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        aBtn.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 10).isActive = true
//    //        aBtn.topAnchor.constraint(equalTo: userPanel.topAnchor, constant: 30).isActive = true
//        aBtn.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
//        aBtn.layer.cornerRadius = 20
////        aBtn.layer.opacity = 0.3
//        aBtn.isUserInteractionEnabled = true
//        aBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackPanelClicked)))
//
//        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_close")?.withRenderingMode(.alwaysTemplate))
//        bMiniBtn.tintColor = .ddmDarkGrayColor
////        loginPanel.addSubview(bMiniBtn)
//        panel.addSubview(bMiniBtn)
//        bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
//        bMiniBtn.centerXAnchor.constraint(equalTo: aBtn.centerXAnchor).isActive = true
//        bMiniBtn.centerYAnchor.constraint(equalTo: aBtn.centerYAnchor).isActive = true
//        bMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
//        bMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
////        bMiniBtn.layer.opacity = 0.3
//        
//        let scrollView = UIScrollView()
//        panel.addSubview(scrollView)
//        scrollView.backgroundColor = .clear
////        scrollView.backgroundColor = .red
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.topAnchor.constraint(equalTo: aBtn.bottomAnchor, constant: 10).isActive = true
//        scrollView.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
//        scrollView.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: 0).isActive = true
//        scrollView.showsVerticalScrollIndicator = false
//        scrollView.contentSize = CGSize(width: viewWidth, height: viewHeight - 150)
//        scrollView.delegate = self
//        scrollView.alwaysBounceVertical = true
//        scrollView.centerXAnchor.constraint(equalTo: panel.centerXAnchor).isActive = true
//        
//        let stackView = UIView()
//        stackView.backgroundColor = .clear
////        stackView.backgroundColor = .blue
//        scrollView.addSubview(stackView)
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
//        stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
//        stackView.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
//        
//        let aPhoto = SDAnimatedImageView()
//        stackView.addSubview(aPhoto)
//        aPhoto.translatesAutoresizingMaskIntoConstraints = false
//        aPhoto.widthAnchor.constraint(equalToConstant: 100).isActive = true //ori: 80
//        aPhoto.heightAnchor.constraint(equalToConstant: 100).isActive = true
//        aPhoto.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
////        aPhotoTopCons = aPhoto.topAnchor.constraint(equalTo:  self.safeAreaLayoutGuide.topAnchor, constant: 60) //50+10
////        aPhotoTopCons?.isActive = true
////        aPhotoTopCons = aPhoto.topAnchor.constraint(equalTo: aBtn.bottomAnchor, constant: 20)
//        aPhoto.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 90).isActive = true
//        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
//        aPhoto.contentMode = .scaleAspectFill
//        aPhoto.layer.masksToBounds = true
//        aPhoto.layer.cornerRadius = 50
//        aPhoto.sd_setImage(with: imageUrl)
//        
//        //test > email
//        let pResult = UIView()
//        pResult.backgroundColor = .ddmDarkColor
////        pResult.backgroundColor = .ddmBlackOverlayColor
//        stackView.addSubview(pResult)
//        pResult.translatesAutoresizingMaskIntoConstraints = false
//        pResult.topAnchor.constraint(equalTo: aPhoto.bottomAnchor, constant: 70).isActive = true
////        pResult.centerXAnchor.constraint(equalTo: panel.centerXAnchor, constant: 0).isActive = true
//        pResult.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        pResult.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 50).isActive = true
//        pResult.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -50).isActive = true
//        pResult.layer.cornerRadius = 10 //5
////        pResult.layer.opacity = 0.3 //0.1
////        pResult.isUserInteractionEnabled = true
////        pResult.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onAddPTextClicked)))
//        
////        let pHint = UILabel()
////        pHint.textAlignment = .left
////        pHint.textColor = .white
////        pHint.font = .boldSystemFont(ofSize: 14)
////        stackView.addSubview(pHint)
////        pHint.translatesAutoresizingMaskIntoConstraints = false
////        pHint.leadingAnchor.constraint(equalTo: pResult.leadingAnchor, constant: 20).isActive = true
////        pHint.topAnchor.constraint(equalTo: pResult.topAnchor, constant: 10).isActive = true
////        pHint.text = "Enter email"
////        pHint.layer.opacity = 0.5
//        
//        //test > password
//        let qResult = UIView()
//        qResult.backgroundColor = .ddmDarkColor
////        qResult.backgroundColor = .ddmBlackOverlayColor
//        stackView.addSubview(qResult)
//        qResult.translatesAutoresizingMaskIntoConstraints = false
//        qResult.topAnchor.constraint(equalTo: pResult.bottomAnchor, constant: 20).isActive = true
////        qResult.centerXAnchor.constraint(equalTo: panel.centerXAnchor, constant: 0).isActive = true
//        qResult.heightAnchor.constraint(equalToConstant: 40).isActive = true //40
//        qResult.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 50).isActive = true
//        qResult.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -50).isActive = true
//        qResult.layer.cornerRadius = 10 //5
////        qResult.layer.opacity = 0.3
////        qResult.isUserInteractionEnabled = true
////        qResult.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onAddQTextClicked)))
//        qResult.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 0).isActive = true
//        
////        let qHint = UILabel()
////        qHint.textAlignment = .left
////        qHint.textColor = .white
////        qHint.font = .boldSystemFont(ofSize: 14)
////        stackView.addSubview(qHint)
////        qHint.translatesAutoresizingMaskIntoConstraints = false
////        qHint.leadingAnchor.constraint(equalTo: qResult.leadingAnchor, constant: 20).isActive = true
////        qHint.topAnchor.constraint(equalTo: qResult.topAnchor, constant: 10).isActive = true
////        qHint.text = "Set password"
////        qHint.layer.opacity = 0.5
//        
//////        let gBtn = UIView()
////        panel.addSubview(gBtn)
////        gBtn.backgroundColor = .yellow
////        gBtn.translatesAutoresizingMaskIntoConstraints = false
////        gBtn.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 100).isActive = true
////        gBtn.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -100).isActive = true
////        gBtn.topAnchor.constraint(equalTo: qResult.bottomAnchor, constant: 50).isActive = true
//////        gBtn.bottomAnchor.constraint(equalTo: gBox.bottomAnchor, constant: -30).isActive = true
////        gBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
////        gBtn.layer.cornerRadius = 10
////        gBtn.isUserInteractionEnabled = true
////        gBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCreateProceedClicked)))
//////        gBtn.layer.opacity = 0.1
////
////        let gBtnText = UILabel()
////        gBtnText.textAlignment = .center
////        gBtnText.textColor = .black
////        gBtnText.font = .boldSystemFont(ofSize: 14)
////        gBtn.addSubview(gBtnText)
////        gBtnText.translatesAutoresizingMaskIntoConstraints = false
//////        gBtnText.topAnchor.constraint(equalTo: gBtn.topAnchor, constant: 10).isActive = true
//////        gBtnText.bottomAnchor.constraint(equalTo: gBtn.bottomAnchor, constant: -10).isActive = true
////        gBtnText.centerYAnchor.constraint(equalTo: gBtn.centerYAnchor).isActive = true
////        gBtnText.leadingAnchor.constraint(equalTo: gBtn.leadingAnchor, constant: 20).isActive = true
////        gBtnText.trailingAnchor.constraint(equalTo: gBtn.trailingAnchor, constant: -20).isActive = true
////        gBtnText.text = "Next"
//        
//        //test > post upload btn
////        let aUpload = UIView()
//        aUpload.backgroundColor = .yellow
//        panel.addSubview(aUpload)
////        stack2.addSubview(aUpload)
//        aUpload.translatesAutoresizingMaskIntoConstraints = false
//        aUpload.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        aUpload.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -10).isActive = true
////        aUpload.topAnchor.constraint(equalTo: panel.topAnchor, constant: 50).isActive = true
////        aUpload.leadingAnchor.constraint(equalTo: stack2.leadingAnchor, constant: 10).isActive = true
////        aUpload.trailingAnchor.constraint(equalTo: stack2.trailingAnchor, constant: 0).isActive = true
//        aUpload.centerYAnchor.constraint(equalTo: aBtn.centerYAnchor).isActive = true
//        aUpload.layer.cornerRadius = 10
//        aUpload.isUserInteractionEnabled = true
//        aUpload.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCreateProceedClicked)))
//
//        let aUploadText = UILabel()
//        aUploadText.textAlignment = .center
//        aUploadText.textColor = .black
//        aUploadText.font = .boldSystemFont(ofSize: 13)
////        panel.addSubview(aUploadText)
//        aUpload.addSubview(aUploadText)
//        aUploadText.translatesAutoresizingMaskIntoConstraints = false
////        aUploadText.centerXAnchor.constraint(equalTo: aUpload.centerXAnchor).isActive = true
//        aUploadText.centerYAnchor.constraint(equalTo: aUpload.centerYAnchor).isActive = true
//        aUploadText.leadingAnchor.constraint(equalTo: aUpload.leadingAnchor, constant: 25).isActive = true
//        aUploadText.trailingAnchor.constraint(equalTo: aUpload.trailingAnchor, constant: -25).isActive = true
//        aUploadText.text = "Next"
//        
//        //test > spin loader for loading
////        let aSpinner = SpinLoader()
//        panel.addSubview(aSpinner)
//        aSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
//        aSpinner.translatesAutoresizingMaskIntoConstraints = false
//        aSpinner.centerYAnchor.constraint(equalTo: aUpload.centerYAnchor).isActive = true
//        aSpinner.centerXAnchor.constraint(equalTo: aUpload.centerXAnchor).isActive = true
//        aSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        aSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        
//        //test > try scrollview instead of another blackoverlay
////        let pTextField = UITextField()
//        pTextField.textAlignment = .left
//        pTextField.textColor = .white
//        pTextField.backgroundColor = .clear
////        pTextField.backgroundColor = .red
//        pTextField.font = .systemFont(ofSize: 14)
//        stackView.addSubview(pTextField)
//        pTextField.translatesAutoresizingMaskIntoConstraints = false
//        pTextField.leadingAnchor.constraint(equalTo: pResult.leadingAnchor, constant: 20).isActive = true //10
//        pTextField.trailingAnchor.constraint(equalTo: pResult.trailingAnchor, constant: -10).isActive = true
//        pTextField.topAnchor.constraint(equalTo: pResult.topAnchor, constant: 2).isActive = true
//        pTextField.bottomAnchor.constraint(equalTo: pResult.bottomAnchor, constant: -2).isActive = true
////        pTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true //test
//        pTextField.text = ""
//        pTextField.tintColor = .yellow
//        pTextField.placeholder = "Enter email"
//
////        let qTextField = UITextField()
//        qTextField.textAlignment = .left
//        qTextField.textColor = .white
//        qTextField.backgroundColor = .clear
////        qTextField.backgroundColor = .red
//        qTextField.font = .systemFont(ofSize: 14)
//        stackView.addSubview(qTextField)
//        qTextField.translatesAutoresizingMaskIntoConstraints = false
//        qTextField.leadingAnchor.constraint(equalTo: qResult.leadingAnchor, constant: 20).isActive = true //10
//        qTextField.trailingAnchor.constraint(equalTo: qResult.trailingAnchor, constant: -10).isActive = true
//        qTextField.topAnchor.constraint(equalTo: qResult.topAnchor, constant: 2).isActive = true
//        qTextField.bottomAnchor.constraint(equalTo: qResult.bottomAnchor, constant: -2).isActive = true
////        qTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true //test
//        qTextField.text = ""
//        qTextField.tintColor = .yellow
//        qTextField.placeholder = "Set password"
//    }
//    
//    @objc func onBackPanelClicked(gesture: UITapGestureRecognizer) {
//        resignResponder()
//        closePanel(isAnimated: true)
//    }
//    
//    @objc func onCreateProceedClicked(gesture: UITapGestureRecognizer) {
////        delegate?.didClickProceedCreateAccount()
//        
//        resignResponder()
//        aUpload.isHidden = true
//        aSpinner.startAnimating()
//    }
//    
//    @objc func onBoxUnderClicked(gesture: UITapGestureRecognizer) {
//        print("box under")
//        resignResponder()
//    }
//    
//    func resignResponder() {
//        self.endEditing(true)
//    }
//    
//    func activate(textField: UITextField) {
//        setFirstResponder(textField: textField)
//    }
//    func setFirstResponder(textField: UITextField) {
//        textField.becomeFirstResponder()
//    }
//    
//    var isInitialized = false
//    func initialize() {
//        
//        if(!isInitialized) {
//            activate(textField: pTextField)
//        }
//        
//        isInitialized = true
//    }
//    
//    func closePanel(isAnimated: Bool) {
//        
//        if(isAnimated) {
//            UIView.animate(withDuration: 0.2, animations: {
//                self.panelTopCons?.constant = 0
//                self.layoutIfNeeded()
//            }, completion: { _ in
//                self.removeFromSuperview()
////                self.delegate?.didClickCloseSoundPanel()
//            })
//        } else {
//            self.removeFromSuperview()
////            self.delegate?.didClickCloseSoundPanel()
//        }
//    }
//}
//
//extension LoginPanelView: CreateAccountEmailPanelDelegate{
//    func didClickProceedCreateAccountEmail() {
//        openUserCreatorPanel()
//    }
//}
//
//extension CreateAccountEmailPanelView: UIScrollViewDelegate {
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        print("xx1 scrollview begin: \(scrollView.contentOffset.y)")
//        let scrollOffsetY = scrollView.contentOffset.y
//        
//        resignResponder()
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("xx1 scrollview scroll: \(scrollView.contentOffset.y)")
//
//        let scrollOffsetY = scrollView.contentOffset.y
//    }
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        print("xx1 scrollview end: \(scrollView.contentOffset.y)")
//    }
//
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        print("xx1 scrollview end drag: \(scrollView.contentOffset.y)")
//    }
//    
//    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        print("xx1 scrollview animation ended")
//    }
//}
