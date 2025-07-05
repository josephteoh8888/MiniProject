//
//  LoginPanelView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

protocol LoginPanelDelegate : AnyObject {
    func didClickCloseLoginPanel()
    func didClickCreateUserAccount()
    func didLoginUserCreatorClickUpload(data: String)
}

class LoginPanelView: PanelView{
    var aPanel = UIView()
    var bPanel = UIView()
    var cPanel = UIView()
    weak var delegate : LoginPanelDelegate?
    
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
//    var panelTopCons: NSLayoutConstraint?
//    var currentPanelTopCons : CGFloat = 0.0
//
    var currentPanelMode = ""
    let PANEL_MODE_LOGIN: String = "login"
    let PANEL_MODE_SIGNUP: String = "signup"
    let PANEL_MODE_LOGIN_EMAIL: String = "login_email"
    
    let rContainer = UIView()
    let qContainer = UIView()
    let aUpload = UIView()
    
    let pTextField = UITextField()
    let qTextField = UITextField()
    
    let aSpinner = SpinLoader()
    let aContainer = UIView()
    
    let sTextField = UITextField()
    let tTextField = UITextField()
    
    let bSpinner = SpinLoader()
//    let tContainer = UIView()
    let qCHHBtn = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewWidth = frame.width
        viewHeight = frame.height
        setupViews()

    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    func setupViews() {
        let aBoxUnder = UIView()
        self.addSubview(aBoxUnder)
        aBoxUnder.backgroundColor = .ddmBlackOverlayColor
//        aBoxUnder.backgroundColor = .clear
        aBoxUnder.translatesAutoresizingMaskIntoConstraints = false
        aBoxUnder.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        aBoxUnder.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
//        aBoxUnder.layer.opacity = 0.5 //0.3
//        aBoxUnder.isHidden = true
//        aBoxUnder.isUserInteractionEnabled = true
//        aBoxUnder.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackPanelClicked)))
        
        //test > aPanel => default: Login
        aPanel.backgroundColor = .ddmBlackOverlayColor
//        panel.backgroundColor = .black
//        panel.backgroundColor = .white
        self.addSubview(aPanel)
        aPanel.translatesAutoresizingMaskIntoConstraints = false
        aPanel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        aPanel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        aPanel.layer.masksToBounds = true
        aPanel.layer.cornerRadius = 10 //10
        aPanel.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        aPanel.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
//        let gap = viewHeight
//        panelTopCons = panel.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -gap)
//        panelTopCons?.isActive = true
        
        let aBtn = UIView()
        aPanel.addSubview(aBtn)
        aBtn.translatesAutoresizingMaskIntoConstraints = false
        aBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
        aBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        aBtn.leadingAnchor.constraint(equalTo: aPanel.leadingAnchor, constant: 10).isActive = true
//        aBtn.topAnchor.constraint(equalTo: aPanel.topAnchor, constant: 50).isActive = true
        aBtn.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        aBtn.layer.cornerRadius = 20
        aBtn.isUserInteractionEnabled = true
        aBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackLoginPanelClicked)))

        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_close")?.withRenderingMode(.alwaysTemplate))
        bMiniBtn.tintColor = .ddmDarkGrayColor
        aPanel.addSubview(bMiniBtn)
        bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        bMiniBtn.centerXAnchor.constraint(equalTo: aBtn.centerXAnchor).isActive = true
        bMiniBtn.centerYAnchor.constraint(equalTo: aBtn.centerYAnchor).isActive = true
        bMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        bMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        bMiniBtn.layer.opacity = 0.3
        
        //test
        let aLoggedBox = UIView()
        aPanel.addSubview(aLoggedBox)
        aLoggedBox.translatesAutoresizingMaskIntoConstraints = false
//        aLoggedBox.topAnchor.constraint(equalTo: aSemiTransparentTextBox.topAnchor, constant: 0).isActive = true
        aLoggedBox.centerYAnchor.constraint(equalTo: aPanel.centerYAnchor, constant: -60).isActive = true //-90
        aLoggedBox.leadingAnchor.constraint(equalTo: aPanel.leadingAnchor).isActive = true
        aLoggedBox.trailingAnchor.constraint(equalTo: aPanel.trailingAnchor).isActive = true
        
        let aLoginText = UILabel()
        aLoginText.textAlignment = .center
        aLoginText.textColor = .white
//        aLoginText.textColor = .ddmBlackOverlayColor
        aLoginText.font = .boldSystemFont(ofSize: 18)
//        aPanel.addSubview(aLoginText)
        aLoggedBox.addSubview(aLoginText)
        aLoginText.translatesAutoresizingMaskIntoConstraints = false
//        aLoginText.topAnchor.constraint(equalTo: aPanel.topAnchor, constant: 250).isActive = true
        aLoginText.topAnchor.constraint(equalTo: aLoggedBox.topAnchor).isActive = true //test
        aLoginText.centerXAnchor.constraint(equalTo: aPanel.centerXAnchor, constant: 0).isActive = true
        aLoginText.text = "Log in to Mini" //default: Around You
        
        //test > add spinner when login with fb/google
//        aPanel.addSubview(aSpinner)
        aLoggedBox.addSubview(aSpinner)
        aSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        aSpinner.translatesAutoresizingMaskIntoConstraints = false
        aSpinner.topAnchor.constraint(equalTo: aLoginText.bottomAnchor, constant: 40).isActive = true  //0
        aSpinner.centerXAnchor.constraint(equalTo: aPanel.centerXAnchor).isActive = true
        aSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        aSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
//        let rContainer = UIView()
//        aPanel.addSubview(aContainer)
        aLoggedBox.addSubview(aContainer)
//        aContainer.backgroundColor = .red //test
        aContainer.translatesAutoresizingMaskIntoConstraints = false
        aContainer.leadingAnchor.constraint(equalTo: aPanel.leadingAnchor, constant: 0).isActive = true
        aContainer.trailingAnchor.constraint(equalTo: aPanel.trailingAnchor, constant: 0).isActive = true
        aContainer.topAnchor.constraint(equalTo: aLoginText.bottomAnchor, constant: 40).isActive = true
        aContainer.bottomAnchor.constraint(equalTo: aLoggedBox.bottomAnchor, constant: 0).isActive = true
        
        let gBtn = UIView()
//        aPanel.addSubview(gBtn)
        aContainer.addSubview(gBtn)
        gBtn.backgroundColor = .ddmBlackDark
//        gBtn.backgroundColor = .yellow
        gBtn.translatesAutoresizingMaskIntoConstraints = false
//        gBtn.leadingAnchor.constraint(equalTo: aPanel.leadingAnchor, constant: 40).isActive = true //70
//        gBtn.trailingAnchor.constraint(equalTo: aPanel.trailingAnchor, constant: -40).isActive = true
//        gBtn.topAnchor.constraint(equalTo: aLoginText.bottomAnchor, constant: 40).isActive = true
        gBtn.leadingAnchor.constraint(equalTo: aContainer.leadingAnchor, constant: 40).isActive = true //70
        gBtn.trailingAnchor.constraint(equalTo: aContainer.trailingAnchor, constant: -40).isActive = true
        gBtn.topAnchor.constraint(equalTo: aContainer.topAnchor, constant: 0).isActive = true
        gBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true //50
        gBtn.layer.cornerRadius = 10
        gBtn.isUserInteractionEnabled = true
        gBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLoginGProceedClicked)))
//        gBtn.layer.opacity = 0.3 //0.3
        
        let gBtnText = UILabel()
        gBtnText.textAlignment = .center
        gBtnText.textColor = .white
//        gBtnText.textColor = .ddmBlackOverlayColor
        gBtnText.font = .boldSystemFont(ofSize: 14)
//        aPanel.addSubview(gBtnText)
        aContainer.addSubview(gBtnText)
        gBtnText.translatesAutoresizingMaskIntoConstraints = false
//        gBtnText.topAnchor.constraint(equalTo: gBtn.topAnchor, constant: 10).isActive = true
//        gBtnText.bottomAnchor.constraint(equalTo: gBtn.bottomAnchor, constant: -10).isActive = true
        gBtnText.centerYAnchor.constraint(equalTo: gBtn.centerYAnchor).isActive = true
        gBtnText.leadingAnchor.constraint(equalTo: gBtn.leadingAnchor, constant: 20).isActive = true
        gBtnText.trailingAnchor.constraint(equalTo: gBtn.trailingAnchor, constant: -20).isActive = true
        gBtnText.text = "Continue with Facebook"
        
//        let gGrid = UIView()
        let gGrid = UIImageView()
//        gGrid.backgroundColor = .ddmDarkColor
//        gGrid.backgroundColor = .blue
        gGrid.image = UIImage(named:"flaticon_facebook")
//        aPanel.addSubview(gGrid)
        aContainer.addSubview(gGrid)
        gGrid.translatesAutoresizingMaskIntoConstraints = false
        gGrid.leadingAnchor.constraint(equalTo: gBtn.leadingAnchor, constant: 15).isActive = true
        gGrid.heightAnchor.constraint(equalToConstant: 24).isActive = true
        gGrid.widthAnchor.constraint(equalToConstant: 24).isActive = true
        gGrid.centerYAnchor.constraint(equalTo: gBtn.centerYAnchor, constant: 0).isActive = true
        gGrid.layer.cornerRadius = 5 //12

        //test > icon for create post
//        let gMiniImage = UIImageView(image: UIImage(named:"flaticon_soremba_post_a"))
//        panel.addSubview(gMiniImage)
//        gMiniImage.translatesAutoresizingMaskIntoConstraints = false
//        gMiniImage.centerXAnchor.constraint(equalTo: gGrid.centerXAnchor).isActive = true
//        gMiniImage.centerYAnchor.constraint(equalTo: gGrid.centerYAnchor).isActive = true
//        gMiniImage.heightAnchor.constraint(equalToConstant: 24).isActive = true //ori 28
//        gMiniImage.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        let hBtn = UIView()
//        aPanel.addSubview(hBtn)
        aContainer.addSubview(hBtn)
        hBtn.backgroundColor = .ddmBlackDark
//        hBtn.backgroundColor = .yellow
        hBtn.translatesAutoresizingMaskIntoConstraints = false
//        hBtn.leadingAnchor.constraint(equalTo: aPanel.leadingAnchor, constant: 40).isActive = true
//        hBtn.trailingAnchor.constraint(equalTo: aPanel.trailingAnchor, constant: -40).isActive = true
        hBtn.leadingAnchor.constraint(equalTo: aContainer.leadingAnchor, constant: 40).isActive = true
        hBtn.trailingAnchor.constraint(equalTo: aContainer.trailingAnchor, constant: -40).isActive = true
        hBtn.topAnchor.constraint(equalTo: gBtn.bottomAnchor, constant: 30).isActive = true
        hBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true //50
        hBtn.layer.cornerRadius = 10
        hBtn.isUserInteractionEnabled = true
        hBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLoginHProceedClicked)))
//        hBtn.layer.opacity = 0.3 //0.3
        
        let hBtnText = UILabel()
        hBtnText.textAlignment = .center
        hBtnText.textColor = .white
//        hBtnText.textColor = .ddmBlackOverlayColor
        hBtnText.font = .boldSystemFont(ofSize: 14)
//        aPanel.addSubview(hBtnText)
        aContainer.addSubview(hBtnText)
        hBtnText.translatesAutoresizingMaskIntoConstraints = false
//        hBtnText.topAnchor.constraint(equalTo: gBtn.topAnchor, constant: 10).isActive = true
//        hBtnText.bottomAnchor.constraint(equalTo: gBtn.bottomAnchor, constant: -10).isActive = true
        hBtnText.centerYAnchor.constraint(equalTo: hBtn.centerYAnchor).isActive = true
        hBtnText.leadingAnchor.constraint(equalTo: hBtn.leadingAnchor, constant: 20).isActive = true
        hBtnText.trailingAnchor.constraint(equalTo: hBtn.trailingAnchor, constant: -20).isActive = true
        hBtnText.text = "Continue with Google"
        
//        let hGrid = UIView()
        let hGrid = UIImageView()
        hGrid.image = UIImage(named:"flaticon_google")
//        hGrid.backgroundColor = .ddmDarkColor
//        hGrid.backgroundColor = .red
//        aPanel.addSubview(hGrid)
        aContainer.addSubview(hGrid)
        hGrid.translatesAutoresizingMaskIntoConstraints = false
        hGrid.leadingAnchor.constraint(equalTo: hBtn.leadingAnchor, constant: 15).isActive = true
        hGrid.heightAnchor.constraint(equalToConstant: 22).isActive = true //24
        hGrid.widthAnchor.constraint(equalToConstant: 22).isActive = true
        hGrid.centerYAnchor.constraint(equalTo: hBtn.centerYAnchor, constant: 0).isActive = true
        hGrid.layer.cornerRadius = 5 //12

        //test > icon for create post
//        let hMiniImage = UIImageView(image: UIImage(named:"flaticon_soremba_post_a"))
//        panel.addSubview(hMiniImage)
//        hMiniImage.translatesAutoresizingMaskIntoConstraints = false
//        hMiniImage.centerXAnchor.constraint(equalTo: hGrid.centerXAnchor).isActive = true
//        hMiniImage.centerYAnchor.constraint(equalTo: hGrid.centerYAnchor).isActive = true
//        hMiniImage.heightAnchor.constraint(equalToConstant: 24).isActive = true //ori 28
//        hMiniImage.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        let iBtn = UIView()
//        aPanel.addSubview(iBtn)
        aContainer.addSubview(iBtn)
        iBtn.backgroundColor = .ddmBlackDark
//        iBtn.backgroundColor = .yellow
        iBtn.translatesAutoresizingMaskIntoConstraints = false
//        iBtn.leadingAnchor.constraint(equalTo: aPanel.leadingAnchor, constant: 40).isActive = true
//        iBtn.trailingAnchor.constraint(equalTo: aPanel.trailingAnchor, constant: -40).isActive = true
        iBtn.leadingAnchor.constraint(equalTo: aContainer.leadingAnchor, constant: 40).isActive = true
        iBtn.trailingAnchor.constraint(equalTo: aContainer.trailingAnchor, constant: -40).isActive = true
        iBtn.topAnchor.constraint(equalTo: hBtn.bottomAnchor, constant: 30).isActive = true
        iBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true //50
        iBtn.layer.cornerRadius = 10
        iBtn.isUserInteractionEnabled = true
        iBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLoginIProceedClicked)))
//        iBtn.layer.opacity = 0.3 //0.3
        
        let iBtnText = UILabel()
        iBtnText.textAlignment = .center
        iBtnText.textColor = .white
//        iBtnText.textColor = .ddmBlackOverlayColor
        iBtnText.font = .boldSystemFont(ofSize: 14)
//        aPanel.addSubview(iBtnText)
        aContainer.addSubview(iBtnText)
        iBtnText.translatesAutoresizingMaskIntoConstraints = false
//        iBtnText.topAnchor.constraint(equalTo: gBtn.topAnchor, constant: 10).isActive = true
//        iBtnText.bottomAnchor.constraint(equalTo: gBtn.bottomAnchor, constant: -10).isActive = true
        iBtnText.centerYAnchor.constraint(equalTo: iBtn.centerYAnchor).isActive = true
        iBtnText.leadingAnchor.constraint(equalTo: iBtn.leadingAnchor, constant: 20).isActive = true
        iBtnText.trailingAnchor.constraint(equalTo: iBtn.trailingAnchor, constant: -20).isActive = true
        iBtnText.text = "Use email"
        
//        let iGrid = UIView()
        let iGrid = UIImageView()
        iGrid.image = UIImage(named:"icon_round_mail")?.withRenderingMode(.alwaysTemplate)
        iGrid.tintColor = .white
//        iGrid.backgroundColor = .yellow
//        aPanel.addSubview(iGrid)
        aContainer.addSubview(iGrid)
        iGrid.translatesAutoresizingMaskIntoConstraints = false
        iGrid.leadingAnchor.constraint(equalTo: iBtn.leadingAnchor, constant: 15).isActive = true
        iGrid.heightAnchor.constraint(equalToConstant: 24).isActive = true
        iGrid.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iGrid.centerYAnchor.constraint(equalTo: iBtn.centerYAnchor, constant: 0).isActive = true
        iGrid.layer.cornerRadius = 5 //12
//        iGrid.layer.opacity = 0.2 //0.3

        //test > icon for create post
//        let iMiniImage = UIImageView(image: UIImage(named:"flaticon_soremba_post_a"))
//        panel.addSubview(iMiniImage)
//        iMiniImage.translatesAutoresizingMaskIntoConstraints = false
//        iMiniImage.centerXAnchor.constraint(equalTo: iGrid.centerXAnchor).isActive = true
//        iMiniImage.centerYAnchor.constraint(equalTo: iGrid.centerYAnchor).isActive = true
//        iMiniImage.heightAnchor.constraint(equalToConstant: 24).isActive = true //ori 28
//        iMiniImage.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        let gDenyText = UILabel()
        gDenyText.textAlignment = .center
        gDenyText.textColor = .white
//        gDenyText.textColor = .ddmBlackOverlayColor
        gDenyText.font = .systemFont(ofSize: 14)
//        aPanel.addSubview(gDenyText)
        aContainer.addSubview(gDenyText)
        gDenyText.translatesAutoresizingMaskIntoConstraints = false
        gDenyText.topAnchor.constraint(equalTo: iBtn.bottomAnchor, constant: 80).isActive = true
//        gDenyText.bottomAnchor.constraint(equalTo: gBox.bottomAnchor, constant: -30).isActive = true
        gDenyText.centerXAnchor.constraint(equalTo: aPanel.centerXAnchor, constant: 0).isActive = true
        gDenyText.text = "Don't have an account?"
//        gDenyText.layer.opacity = 0.5
        
//        let fDenyText = UILabel()
//        fDenyText.textAlignment = .center
//        fDenyText.textColor = .yellow
////        fDenyText.textColor = .ddmBlackOverlayColor
//        fDenyText.font = .boldSystemFont(ofSize: 14)
//        panel.addSubview(fDenyText)
//        fDenyText.translatesAutoresizingMaskIntoConstraints = false
//        fDenyText.topAnchor.constraint(equalTo: gDenyText.bottomAnchor, constant: 10).isActive = true
////        fDenyText.bottomAnchor.constraint(equalTo: gBox.bottomAnchor, constant: -30).isActive = true
//        fDenyText.centerXAnchor.constraint(equalTo: panel.centerXAnchor, constant: 0).isActive = true
//        fDenyText.text = "Sign Up"
//        fDenyText.isUserInteractionEnabled = true
//        fDenyText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSignUpDenyClicked)))
        
        let aFollow = UIView()
        aFollow.backgroundColor = .yellow
//        aPanel.addSubview(aFollow)
        aContainer.addSubview(aFollow)
        aFollow.translatesAutoresizingMaskIntoConstraints = false
        aFollow.centerXAnchor.constraint(equalTo: aPanel.centerXAnchor).isActive = true
        aFollow.heightAnchor.constraint(equalToConstant: 30).isActive = true //30
        aFollow.topAnchor.constraint(equalTo: gDenyText.bottomAnchor, constant: 10).isActive = true
        aFollow.layer.cornerRadius = 10
        aFollow.isUserInteractionEnabled = true
        aFollow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLoginDenyClicked)))
        aFollow.bottomAnchor.constraint(equalTo: aContainer.bottomAnchor, constant: 0).isActive = true

        let aFollowText = UILabel()
        aFollowText.textAlignment = .center
        aFollowText.textColor = .black
        aFollowText.font = .boldSystemFont(ofSize: 13) //default 14
        aFollow.addSubview(aFollowText)
        aFollowText.translatesAutoresizingMaskIntoConstraints = false
        aFollowText.leadingAnchor.constraint(equalTo: aFollow.leadingAnchor, constant: 20).isActive = true
        aFollowText.trailingAnchor.constraint(equalTo: aFollow.trailingAnchor, constant: -20).isActive = true
        aFollowText.centerYAnchor.constraint(equalTo: aFollow.centerYAnchor).isActive = true
        aFollowText.text = "Sign Up" //Sign Up

        //test > bPanel => Sign up
        bPanel.backgroundColor = .ddmBlackOverlayColor
//        panel.backgroundColor = .black
//        panel.backgroundColor = .white
        self.addSubview(bPanel)
        bPanel.translatesAutoresizingMaskIntoConstraints = false
        bPanel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        bPanel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        bPanel.layer.masksToBounds = true
        bPanel.layer.cornerRadius = 10 //10
        bPanel.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        bPanel.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        bPanel.isUserInteractionEnabled = true
        bPanel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickPanelClicked)))
        bPanel.isHidden = true
        
        let aABtn = UIView()
        bPanel.addSubview(aABtn)
        aABtn.translatesAutoresizingMaskIntoConstraints = false
        aABtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
        aABtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        aABtn.leadingAnchor.constraint(equalTo: bPanel.leadingAnchor, constant: 10).isActive = true
//        aABtn.topAnchor.constraint(equalTo: bPanel.topAnchor, constant: 50).isActive = true
        aABtn.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        aABtn.layer.cornerRadius = 20
        aABtn.isUserInteractionEnabled = true
        aABtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackSignupPanelClicked)))

        let bBMiniBtn = UIImageView(image: UIImage(named:"icon_round_close")?.withRenderingMode(.alwaysTemplate))
        bBMiniBtn.tintColor = .ddmDarkGrayColor
        bPanel.addSubview(bBMiniBtn)
        bBMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        bBMiniBtn.centerXAnchor.constraint(equalTo: aABtn.centerXAnchor).isActive = true
        bBMiniBtn.centerYAnchor.constraint(equalTo: aABtn.centerYAnchor).isActive = true
        bBMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        bBMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        bBMiniBtn.layer.opacity = 0.3
        
        //test
        let bLoggedBox = UIView()
        bPanel.addSubview(bLoggedBox)
        bLoggedBox.translatesAutoresizingMaskIntoConstraints = false
//        bLoggedBox.topAnchor.constraint(equalTo: aSemiTransparentTextBox.topAnchor, constant: 0).isActive = true
        bLoggedBox.centerYAnchor.constraint(equalTo: bPanel.centerYAnchor, constant: -60).isActive = true //-90
        bLoggedBox.leadingAnchor.constraint(equalTo: bPanel.leadingAnchor).isActive = true
        bLoggedBox.trailingAnchor.constraint(equalTo: bPanel.trailingAnchor).isActive = true
        
        let aALoginText = UILabel()
        aALoginText.textAlignment = .center
        aALoginText.textColor = .white
//        aLoginText.textColor = .ddmBlackOverlayColor
        aALoginText.font = .boldSystemFont(ofSize: 18)
//        bPanel.addSubview(aALoginText)
        bLoggedBox.addSubview(aALoginText)
        aALoginText.translatesAutoresizingMaskIntoConstraints = false
//        aALoginText.topAnchor.constraint(equalTo: bPanel.topAnchor, constant: 250).isActive = true
        aALoginText.topAnchor.constraint(equalTo: bLoggedBox.topAnchor).isActive = true //test
        aALoginText.centerXAnchor.constraint(equalTo: bPanel.centerXAnchor, constant: 0).isActive = true
        aALoginText.text = "Sign up for Mini" //default: Around You
        
        let gGBtn = UIView()
//        bPanel.addSubview(gGBtn)
        bLoggedBox.addSubview(gGBtn)
        gGBtn.backgroundColor = .ddmDarkColor
//        gBtn.backgroundColor = .yellow
        gGBtn.translatesAutoresizingMaskIntoConstraints = false
        gGBtn.leadingAnchor.constraint(equalTo: bPanel.leadingAnchor, constant: 40).isActive = true //70
        gGBtn.trailingAnchor.constraint(equalTo: bPanel.trailingAnchor, constant: -40).isActive = true
        gGBtn.topAnchor.constraint(equalTo: aALoginText.bottomAnchor, constant: 40).isActive = true
//        gBtn.bottomAnchor.constraint(equalTo: gBox.bottomAnchor, constant: -30).isActive = true
        gGBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true //40
        gGBtn.layer.cornerRadius = 10
//        gBtn.layer.opacity = 0.3 //0.3
        
//        let gGrid = UIView()
        let gGGrid = UIImageView()
//        gGrid.backgroundColor = .ddmDarkColor
//        gGrid.backgroundColor = .blue
        gGGrid.image = UIImage(named:"icon_round_mail")?.withRenderingMode(.alwaysTemplate)
//        bPanel.addSubview(gGGrid)
        bLoggedBox.addSubview(gGGrid)
        gGGrid.translatesAutoresizingMaskIntoConstraints = false
        gGGrid.leadingAnchor.constraint(equalTo: gGBtn.leadingAnchor, constant: 15).isActive = true
        gGGrid.heightAnchor.constraint(equalToConstant: 24).isActive = true
        gGGrid.widthAnchor.constraint(equalToConstant: 24).isActive = true
        gGGrid.centerYAnchor.constraint(equalTo: gGBtn.centerYAnchor, constant: 0).isActive = true
        gGGrid.layer.cornerRadius = 5 //12
        gGGrid.tintColor = .white
        
//        let pTextField = UITextField()
        pTextField.textAlignment = .left
        pTextField.textColor = .white
        pTextField.backgroundColor = .clear
//        pTextField.backgroundColor = .red
        pTextField.font = .systemFont(ofSize: 14)
//        bPanel.addSubview(pTextField)
        bLoggedBox.addSubview(pTextField)
        pTextField.translatesAutoresizingMaskIntoConstraints = false
        pTextField.leadingAnchor.constraint(equalTo: gGBtn.leadingAnchor, constant: 70).isActive = true //10
        pTextField.trailingAnchor.constraint(equalTo: gGBtn.trailingAnchor, constant: -10).isActive = true
        pTextField.topAnchor.constraint(equalTo: gGBtn.topAnchor, constant: 2).isActive = true
        pTextField.bottomAnchor.constraint(equalTo: gGBtn.bottomAnchor, constant: -2).isActive = true
//        pTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true //test
        pTextField.text = ""
        pTextField.tintColor = .yellow
        pTextField.placeholder = "Enter email address"
        
//        let rContainer = UIView()
//        bPanel.addSubview(rContainer)
        bLoggedBox.addSubview(rContainer)
//        rContainer.backgroundColor = .yellow
        rContainer.translatesAutoresizingMaskIntoConstraints = false
        rContainer.leadingAnchor.constraint(equalTo: bPanel.leadingAnchor, constant: 0).isActive = true
        rContainer.trailingAnchor.constraint(equalTo: bPanel.trailingAnchor, constant: 0).isActive = true
        rContainer.topAnchor.constraint(equalTo: gGBtn.bottomAnchor, constant: 30).isActive = true
//        rContainer.bottomAnchor.constraint(equalTo: bPanel.bottomAnchor, constant: 0).isActive = true
        rContainer.bottomAnchor.constraint(equalTo: bLoggedBox.bottomAnchor, constant: 0).isActive = true
        
        let hHBtn = UIView()
//        bPanel.addSubview(hHBtn)
        rContainer.addSubview(hHBtn)
        hHBtn.backgroundColor = .yellow
//        hHBtn.backgroundColor = .yellow
        hHBtn.translatesAutoresizingMaskIntoConstraints = false
        hHBtn.leadingAnchor.constraint(equalTo: rContainer.leadingAnchor, constant: 40).isActive = true
        hHBtn.trailingAnchor.constraint(equalTo: rContainer.trailingAnchor, constant: -40).isActive = true
//        hHBtn.centerXAnchor.constraint(equalTo: rContainer.centerXAnchor).isActive = true
        hHBtn.topAnchor.constraint(equalTo: gGBtn.bottomAnchor, constant: 30).isActive = true
        hHBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        hHBtn.layer.cornerRadius = 10
        hHBtn.isUserInteractionEnabled = true
        hHBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSignupHProceedClicked)))
//        hHBtn.layer.opacity = 0.3 //0.3
        
        let hHBtnText = UILabel()
        hHBtnText.textAlignment = .center
        hHBtnText.textColor = .black
//        hHBtnText.textColor = .ddmBlackOverlayColor
        hHBtnText.font = .boldSystemFont(ofSize: 13)
//        bPanel.addSubview(hHBtnText)
        rContainer.addSubview(hHBtnText)
        hHBtnText.translatesAutoresizingMaskIntoConstraints = false
//        hHBtnText.topAnchor.constraint(equalTo: gBtn.topAnchor, constant: 10).isActive = true
//        hHBtnText.bottomAnchor.constraint(equalTo: gBtn.bottomAnchor, constant: -10).isActive = true
        hHBtnText.centerYAnchor.constraint(equalTo: hHBtn.centerYAnchor).isActive = true
        hHBtnText.leadingAnchor.constraint(equalTo: hHBtn.leadingAnchor, constant: 20).isActive = true
        hHBtnText.trailingAnchor.constraint(equalTo: hHBtn.trailingAnchor, constant: -20).isActive = true
        hHBtnText.text = "Continue"
        
        let iContinueText = UILabel()
        iContinueText.textAlignment = .center
        iContinueText.textColor = .ddmDarkGrayColor
//        iContinueText.textColor = .ddmBlackOverlayColor
        iContinueText.font = .systemFont(ofSize: 14)
//        bPanel.addSubview(iContinueText)
        rContainer.addSubview(iContinueText)
        iContinueText.translatesAutoresizingMaskIntoConstraints = false
        iContinueText.topAnchor.constraint(equalTo: hHBtn.bottomAnchor, constant: 60).isActive = true
//        iContinueText.centerXAnchor.constraint(equalTo: bPanel.centerXAnchor, constant: 0).isActive = true
        iContinueText.centerXAnchor.constraint(equalTo: rContainer.centerXAnchor, constant: 0).isActive = true
        iContinueText.text = "Or continue with"
//        iContinueText.layer.opacity = 0.5
        
        let aBtnContainer = UIView()
//        bPanel.addSubview(aBtnContainer)
        rContainer.addSubview(aBtnContainer)
        aBtnContainer.translatesAutoresizingMaskIntoConstraints = false
//        aBtnContainer.centerXAnchor.constraint(equalTo: bPanel.centerXAnchor, constant: 0).isActive = true
        aBtnContainer.centerXAnchor.constraint(equalTo: rContainer.centerXAnchor, constant: 0).isActive = true
        aBtnContainer.topAnchor.constraint(equalTo: iContinueText.bottomAnchor, constant: 20).isActive = true
        
        let iIBtn = UIView()
        aBtnContainer.addSubview(iIBtn)
        iIBtn.backgroundColor = .ddmDarkColor
//        iBtn.backgroundColor = .yellow
        iIBtn.translatesAutoresizingMaskIntoConstraints = false
        iIBtn.leadingAnchor.constraint(equalTo: aBtnContainer.leadingAnchor, constant: 0).isActive = true
//        iBtn.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -40).isActive = true
        iIBtn.topAnchor.constraint(equalTo: aBtnContainer.topAnchor, constant: 0).isActive = true
        iIBtn.bottomAnchor.constraint(equalTo: aBtnContainer.bottomAnchor, constant: 0).isActive = true
        iIBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        iIBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        iIBtn.layer.cornerRadius = 20
        iIBtn.isUserInteractionEnabled = true
        iIBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSignupIProceedClicked)))
//        iBtn.layer.opacity = 0.3 //0.3
        
//        let iGrid = UIView()
        let iIGrid = UIImageView()
        iIGrid.image = UIImage(named:"flaticon_google")
//        iGrid.tintColor = .white
//        iGrid.backgroundColor = .yellow
        aBtnContainer.addSubview(iIGrid)
        iIGrid.translatesAutoresizingMaskIntoConstraints = false
        iIGrid.centerXAnchor.constraint(equalTo: iIBtn.centerXAnchor, constant: 0).isActive = true
        iIGrid.heightAnchor.constraint(equalToConstant: 30).isActive = true
        iIGrid.widthAnchor.constraint(equalToConstant: 30).isActive = true
        iIGrid.centerYAnchor.constraint(equalTo: iIBtn.centerYAnchor, constant: 0).isActive = true
        iIGrid.layer.cornerRadius = 15 //12
//        iGrid.layer.opacity = 0.2 //0.3
        
        let jBtn = UIView()
        aBtnContainer.addSubview(jBtn)
        jBtn.backgroundColor = .ddmDarkColor
//        jBtn.backgroundColor = .yellow
        jBtn.translatesAutoresizingMaskIntoConstraints = false
        jBtn.leadingAnchor.constraint(equalTo: iIBtn.trailingAnchor, constant: 20).isActive = true
        jBtn.trailingAnchor.constraint(equalTo: aBtnContainer.trailingAnchor, constant: 0).isActive = true
        jBtn.topAnchor.constraint(equalTo: aBtnContainer.topAnchor, constant: 0).isActive = true
        jBtn.bottomAnchor.constraint(equalTo: aBtnContainer.bottomAnchor, constant: 0).isActive = true
        jBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        jBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        jBtn.layer.cornerRadius = 20
        jBtn.isUserInteractionEnabled = true
        jBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSignupJProceedClicked)))
        
        let jGrid = UIImageView()
        jGrid.image = UIImage(named:"flaticon_facebook")
//        iGrid.tintColor = .white
//        iGrid.backgroundColor = .yellow
        aBtnContainer.addSubview(jGrid)
        jGrid.translatesAutoresizingMaskIntoConstraints = false
        jGrid.centerXAnchor.constraint(equalTo: jBtn.centerXAnchor, constant: 0).isActive = true
        jGrid.heightAnchor.constraint(equalToConstant: 30).isActive = true
        jGrid.widthAnchor.constraint(equalToConstant: 30).isActive = true
        jGrid.centerYAnchor.constraint(equalTo: jBtn.centerYAnchor, constant: 0).isActive = true
        jGrid.layer.cornerRadius = 15 //12
        
        let gGDenyText = UILabel()
        gGDenyText.textAlignment = .center
        gGDenyText.textColor = .white
//        gDenyText.textColor = .ddmBlackOverlayColor
        gGDenyText.font = .systemFont(ofSize: 14)
//        bPanel.addSubview(gGDenyText)
        rContainer.addSubview(gGDenyText)
        gGDenyText.translatesAutoresizingMaskIntoConstraints = false
        gGDenyText.topAnchor.constraint(equalTo: aBtnContainer.bottomAnchor, constant: 80).isActive = true
//        gGDenyText.centerXAnchor.constraint(equalTo: bPanel.centerXAnchor, constant: 0).isActive = true
        gGDenyText.centerXAnchor.constraint(equalTo: rContainer.centerXAnchor, constant: 0).isActive = true
        gGDenyText.text = "Already have an account?"
//        gDenyText.layer.opacity = 0.5
        
        let fDenyText = UILabel()
        fDenyText.textAlignment = .center
        fDenyText.textColor = .yellow
//        fDenyText.textColor = .ddmBlackOverlayColor
        fDenyText.font = .boldSystemFont(ofSize: 14)
//        bPanel.addSubview(fDenyText)
        rContainer.addSubview(fDenyText)
        fDenyText.translatesAutoresizingMaskIntoConstraints = false
        fDenyText.topAnchor.constraint(equalTo: gGDenyText.bottomAnchor, constant: 10).isActive = true
//        fDenyText.centerXAnchor.constraint(equalTo: bPanel.centerXAnchor, constant: 0).isActive = true
        fDenyText.centerXAnchor.constraint(equalTo: rContainer.centerXAnchor, constant: 0).isActive = true
        fDenyText.text = "Login"
        fDenyText.isUserInteractionEnabled = true
        fDenyText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSignupDenyClicked)))
        fDenyText.bottomAnchor.constraint(equalTo: rContainer.bottomAnchor, constant: 0).isActive = true
        
//        let qContainer = UIView()
        bPanel.addSubview(qContainer)
        qContainer.translatesAutoresizingMaskIntoConstraints = false
        qContainer.leadingAnchor.constraint(equalTo: bPanel.leadingAnchor, constant: 0).isActive = true
        qContainer.trailingAnchor.constraint(equalTo: bPanel.trailingAnchor, constant: 0).isActive = true
        qContainer.topAnchor.constraint(equalTo: gGBtn.bottomAnchor, constant: 30).isActive = true
        qContainer.bottomAnchor.constraint(equalTo: bPanel.bottomAnchor, constant: 0).isActive = true
        qContainer.isHidden = true
        
        let gHBtn = UIView()
        qContainer.addSubview(gHBtn)
        gHBtn.backgroundColor = .ddmDarkColor
//        gHBtn.backgroundColor = .yellow
        gHBtn.translatesAutoresizingMaskIntoConstraints = false
        gHBtn.leadingAnchor.constraint(equalTo: qContainer.leadingAnchor, constant: 40).isActive = true //70
        gHBtn.trailingAnchor.constraint(equalTo: qContainer.trailingAnchor, constant: -40).isActive = true
        gHBtn.topAnchor.constraint(equalTo: qContainer.topAnchor, constant: 0).isActive = true
//        gHBtn.bottomAnchor.constraint(equalTo: gBox.bottomAnchor, constant: -30).isActive = true
        gHBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true //40
        gHBtn.layer.cornerRadius = 10
//        gHBtn.layer.opacity = 0.3 //0.3
        
        let gHGrid = UIImageView()
//        gHGrid.backgroundColor = .ddmDarkColor
//        gHGrid.backgroundColor = .blue
        gHGrid.image = UIImage(named:"icon_round_key")?.withRenderingMode(.alwaysTemplate)
        qContainer.addSubview(gHGrid)
        gHGrid.translatesAutoresizingMaskIntoConstraints = false
        gHGrid.leadingAnchor.constraint(equalTo: gHBtn.leadingAnchor, constant: 15).isActive = true
        gHGrid.heightAnchor.constraint(equalToConstant: 24).isActive = true
        gHGrid.widthAnchor.constraint(equalToConstant: 24).isActive = true
        gHGrid.centerYAnchor.constraint(equalTo: gHBtn.centerYAnchor, constant: 0).isActive = true
        gHGrid.layer.cornerRadius = 5 //12
        gHGrid.tintColor = .white
        
//        let qTextField = UITextField()
        qTextField.textAlignment = .left
        qTextField.textColor = .white
        qTextField.backgroundColor = .clear
//        qTextField.backgroundColor = .red
        qTextField.font = .systemFont(ofSize: 14)
        qContainer.addSubview(qTextField)
        qTextField.translatesAutoresizingMaskIntoConstraints = false
        qTextField.leadingAnchor.constraint(equalTo: gHBtn.leadingAnchor, constant: 70).isActive = true //10
        qTextField.trailingAnchor.constraint(equalTo: gHBtn.trailingAnchor, constant: -10).isActive = true
        qTextField.topAnchor.constraint(equalTo: gHBtn.topAnchor, constant: 2).isActive = true
        qTextField.bottomAnchor.constraint(equalTo: gHBtn.bottomAnchor, constant: -2).isActive = true
//        qTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true //test
        qTextField.text = ""
        qTextField.tintColor = .yellow
        qTextField.placeholder = "Set password"
        
        let qHHBtn = UIView()
//        bPanel.addSubview(hHBtn)
        qContainer.addSubview(qHHBtn)
        qHHBtn.backgroundColor = .yellow
//        qHHBtn.backgroundColor = .yellow
        qHHBtn.translatesAutoresizingMaskIntoConstraints = false
        qHHBtn.leadingAnchor.constraint(equalTo: qContainer.leadingAnchor, constant: 40).isActive = true
        qHHBtn.trailingAnchor.constraint(equalTo: qContainer.trailingAnchor, constant: -40).isActive = true
        qHHBtn.topAnchor.constraint(equalTo: gHBtn.bottomAnchor, constant: 30).isActive = true
        qHHBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        qHHBtn.layer.cornerRadius = 10
        qHHBtn.isUserInteractionEnabled = true
        qHHBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSignupQHProceedClicked)))
//        qHHBtn.layer.opacity = 0.3 //0.3

        let qHHBtnText = UILabel()
        qHHBtnText.textAlignment = .center
        qHHBtnText.textColor = .black
//        hHBtnText.textColor = .ddmBlackOverlayColor
        qHHBtnText.font = .boldSystemFont(ofSize: 13)
//        bPanel.addSubview(hHBtnText)
        qHHBtn.addSubview(qHHBtnText)
        qHHBtnText.translatesAutoresizingMaskIntoConstraints = false
//        qHHBtnText.topAnchor.constraint(equalTo: gBtn.topAnchor, constant: 10).isActive = true
//        qHHBtnText.bottomAnchor.constraint(equalTo: gBtn.bottomAnchor, constant: -10).isActive = true
        qHHBtnText.centerYAnchor.constraint(equalTo: qHHBtn.centerYAnchor).isActive = true
        qHHBtnText.leadingAnchor.constraint(equalTo: qHHBtn.leadingAnchor, constant: 20).isActive = true
        qHHBtnText.trailingAnchor.constraint(equalTo: qHHBtn.trailingAnchor, constant: -20).isActive = true
        qHHBtnText.text = "Continue"
        
        //test > login with email
        cPanel.backgroundColor = .ddmBlackOverlayColor
//        panel.backgroundColor = .black
//        panel.backgroundColor = .white
        self.addSubview(cPanel)
        cPanel.translatesAutoresizingMaskIntoConstraints = false
        cPanel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        cPanel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        cPanel.layer.masksToBounds = true
        cPanel.layer.cornerRadius = 10 //10
        cPanel.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        cPanel.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        cPanel.isUserInteractionEnabled = true
        cPanel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickCPanelClicked)))
        cPanel.isHidden = true
        
        let aCBtn = UIView()
        cPanel.addSubview(aCBtn)
        aCBtn.translatesAutoresizingMaskIntoConstraints = false
        aCBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
        aCBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        aCBtn.leadingAnchor.constraint(equalTo: cPanel.leadingAnchor, constant: 10).isActive = true
//        aCBtn.topAnchor.constraint(equalTo: cPanel.topAnchor, constant: 50).isActive = true
        aCBtn.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        aCBtn.layer.cornerRadius = 20
        aCBtn.isUserInteractionEnabled = true
        aCBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackCPanelClicked)))

        let bCMiniBtn = UIImageView(image: UIImage(named:"icon_round_close")?.withRenderingMode(.alwaysTemplate))
        bCMiniBtn.tintColor = .ddmDarkGrayColor
        cPanel.addSubview(bCMiniBtn)
        bCMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        bCMiniBtn.centerXAnchor.constraint(equalTo: aCBtn.centerXAnchor).isActive = true
        bCMiniBtn.centerYAnchor.constraint(equalTo: aCBtn.centerYAnchor).isActive = true
        bCMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        bCMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        bCMiniBtn.layer.opacity = 0.3
        
        //test
        let cLoggedBox = UIView()
//        cLoggedBox.backgroundColor = .red
        cPanel.addSubview(cLoggedBox)
        cLoggedBox.translatesAutoresizingMaskIntoConstraints = false
//        cLoggedBox.topAnchor.constraint(equalTo: aSemiTransparentTextBox.topAnchor, constant: 0).isActive = true
        cLoggedBox.centerYAnchor.constraint(equalTo: cPanel.centerYAnchor, constant: -90).isActive = true 
        cLoggedBox.leadingAnchor.constraint(equalTo: cPanel.leadingAnchor).isActive = true
        cLoggedBox.trailingAnchor.constraint(equalTo: cPanel.trailingAnchor).isActive = true
        
        let aCLoginText = UILabel()
        aCLoginText.textAlignment = .center
        aCLoginText.textColor = .white
//        aCLoginText.textColor = .ddmBlackOverlayColor
        aCLoginText.font = .boldSystemFont(ofSize: 18)
//        cPanel.addSubview(aCLoginText)
        cLoggedBox.addSubview(aCLoginText)
        aCLoginText.translatesAutoresizingMaskIntoConstraints = false
//        aCLoginText.topAnchor.constraint(equalTo: cPanel.topAnchor, constant: 250).isActive = true
        aCLoginText.topAnchor.constraint(equalTo: cLoggedBox.topAnchor, constant: 0).isActive = true
        aCLoginText.centerXAnchor.constraint(equalTo: cPanel.centerXAnchor, constant: 0).isActive = true
        aCLoginText.text = "Login with Email"
        
        let gCBtn = UIView()
//        cPanel.addSubview(gCBtn)
        cLoggedBox.addSubview(gCBtn)
        gCBtn.backgroundColor = .ddmDarkColor
//        gCBtn.backgroundColor = .yellow
        gCBtn.translatesAutoresizingMaskIntoConstraints = false
        gCBtn.leadingAnchor.constraint(equalTo: cPanel.leadingAnchor, constant: 40).isActive = true //70
        gCBtn.trailingAnchor.constraint(equalTo: cPanel.trailingAnchor, constant: -40).isActive = true
        gCBtn.topAnchor.constraint(equalTo: aCLoginText.bottomAnchor, constant: 40).isActive = true
//        gCBtn.bottomAnchor.constraint(equalTo: gBox.bottomAnchor, constant: -30).isActive = true
        gCBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true //40
        gCBtn.layer.cornerRadius = 10
//        gCBtn.layer.opacity = 0.3 //0.3
        
//        let gGrid = UIView()
        let gCGrid = UIImageView()
//        gGrid.backgroundColor = .ddmDarkColor
//        gGrid.backgroundColor = .blue
        gCGrid.image = UIImage(named:"icon_round_mail")?.withRenderingMode(.alwaysTemplate)
//        cPanel.addSubview(gCGrid)
        cLoggedBox.addSubview(gCGrid)
        gCGrid.translatesAutoresizingMaskIntoConstraints = false
        gCGrid.leadingAnchor.constraint(equalTo: gCBtn.leadingAnchor, constant: 15).isActive = true
        gCGrid.heightAnchor.constraint(equalToConstant: 24).isActive = true
        gCGrid.widthAnchor.constraint(equalToConstant: 24).isActive = true
        gCGrid.centerYAnchor.constraint(equalTo: gCBtn.centerYAnchor, constant: 0).isActive = true
        gCGrid.layer.cornerRadius = 5 //12
        gCGrid.tintColor = .white
        
//        let pTextField = UITextField()
        sTextField.textAlignment = .left
        sTextField.textColor = .white
        sTextField.backgroundColor = .clear
//        pTextField.backgroundColor = .red
        sTextField.font = .systemFont(ofSize: 14)
//        cPanel.addSubview(sTextField)
        cLoggedBox.addSubview(sTextField)
        sTextField.translatesAutoresizingMaskIntoConstraints = false
        sTextField.leadingAnchor.constraint(equalTo: gCBtn.leadingAnchor, constant: 70).isActive = true //10
        sTextField.trailingAnchor.constraint(equalTo: gCBtn.trailingAnchor, constant: -10).isActive = true
        sTextField.topAnchor.constraint(equalTo: gCBtn.topAnchor, constant: 2).isActive = true
        sTextField.bottomAnchor.constraint(equalTo: gCBtn.bottomAnchor, constant: -2).isActive = true
//        sTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true //test
        sTextField.text = ""
        sTextField.tintColor = .yellow
        sTextField.placeholder = "Enter email address"
        
        let gCHBtn = UIView()
//        cPanel.addSubview(gCHBtn)
        cLoggedBox.addSubview(gCHBtn)
        gCHBtn.backgroundColor = .ddmDarkColor
//        gCHBtn.backgroundColor = .yellow
        gCHBtn.translatesAutoresizingMaskIntoConstraints = false
        gCHBtn.leadingAnchor.constraint(equalTo: cPanel.leadingAnchor, constant: 40).isActive = true //70
        gCHBtn.trailingAnchor.constraint(equalTo: cPanel.trailingAnchor, constant: -40).isActive = true
        gCHBtn.topAnchor.constraint(equalTo: gCBtn.bottomAnchor, constant: 30).isActive = true
//        gCHBtn.bottomAnchor.constraint(equalTo: gBox.bottomAnchor, constant: -30).isActive = true
        gCHBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true //40
        gCHBtn.layer.cornerRadius = 10
//        gCHBtn.layer.opacity = 0.3 //0.3
        
        let gCHGrid = UIImageView()
//        gCHGrid.backgroundColor = .ddmDarkColor
//        gCHGrid.backgroundColor = .blue
        gCHGrid.image = UIImage(named:"icon_round_key")?.withRenderingMode(.alwaysTemplate)
//        cPanel.addSubview(gCHGrid)
        cLoggedBox.addSubview(gCHGrid)
        gCHGrid.translatesAutoresizingMaskIntoConstraints = false
        gCHGrid.leadingAnchor.constraint(equalTo: gCHBtn.leadingAnchor, constant: 15).isActive = true
        gCHGrid.heightAnchor.constraint(equalToConstant: 24).isActive = true
        gCHGrid.widthAnchor.constraint(equalToConstant: 24).isActive = true
        gCHGrid.centerYAnchor.constraint(equalTo: gCHBtn.centerYAnchor, constant: 0).isActive = true
        gCHGrid.layer.cornerRadius = 5 //12
        gCHGrid.tintColor = .white
        
//        let qTextField = UITextField()
        tTextField.textAlignment = .left
        tTextField.textColor = .white
        tTextField.backgroundColor = .clear
//        tTextField.backgroundColor = .red
        tTextField.font = .systemFont(ofSize: 14)
//        cPanel.addSubview(tTextField)
        cLoggedBox.addSubview(tTextField)
        tTextField.translatesAutoresizingMaskIntoConstraints = false
        tTextField.leadingAnchor.constraint(equalTo: gCHBtn.leadingAnchor, constant: 70).isActive = true //10
        tTextField.trailingAnchor.constraint(equalTo: gCHBtn.trailingAnchor, constant: -10).isActive = true
        tTextField.topAnchor.constraint(equalTo: gCHBtn.topAnchor, constant: 2).isActive = true
        tTextField.bottomAnchor.constraint(equalTo: gCHBtn.bottomAnchor, constant: -2).isActive = true
//        tTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true //test
        tTextField.text = ""
        tTextField.tintColor = .yellow
        tTextField.placeholder = "Enter password"
        
//        let qCHHBtn = UIView()
//        bPanel.addSubview(hHBtn)
//        cPanel.addSubview(qCHHBtn)
        cLoggedBox.addSubview(qCHHBtn)
        qCHHBtn.backgroundColor = .yellow
//        qHHBtn.backgroundColor = .yellow
        qCHHBtn.translatesAutoresizingMaskIntoConstraints = false
        qCHHBtn.leadingAnchor.constraint(equalTo: cPanel.leadingAnchor, constant: 40).isActive = true
        qCHHBtn.trailingAnchor.constraint(equalTo: cPanel.trailingAnchor, constant: -40).isActive = true
        qCHHBtn.topAnchor.constraint(equalTo: gCHBtn.bottomAnchor, constant: 30).isActive = true
        qCHHBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        qCHHBtn.layer.cornerRadius = 10
        qCHHBtn.isUserInteractionEnabled = true
        qCHHBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSignupCQHProceedClicked)))
//        qHHBtn.layer.opacity = 0.3 //0.3
        qCHHBtn.bottomAnchor.constraint(equalTo: cLoggedBox.bottomAnchor, constant: 0).isActive = true

        let qCHHBtnText = UILabel()
        qCHHBtnText.textAlignment = .center
        qCHHBtnText.textColor = .black
//        hHBtnText.textColor = .ddmBlackOverlayColor
        qCHHBtnText.font = .boldSystemFont(ofSize: 13)
//        bPanel.addSubview(hHBtnText)
//        qCHHBtn.addSubview(qCHHBtnText)
        cLoggedBox.addSubview(qCHHBtnText)
        qCHHBtnText.translatesAutoresizingMaskIntoConstraints = false
//        qHHBtnText.topAnchor.constraint(equalTo: gBtn.topAnchor, constant: 10).isActive = true
//        qHHBtnText.bottomAnchor.constraint(equalTo: gBtn.bottomAnchor, constant: -10).isActive = true
        qCHHBtnText.centerYAnchor.constraint(equalTo: qCHHBtn.centerYAnchor).isActive = true
        qCHHBtnText.leadingAnchor.constraint(equalTo: qCHHBtn.leadingAnchor, constant: 20).isActive = true
        qCHHBtnText.trailingAnchor.constraint(equalTo: qCHHBtn.trailingAnchor, constant: -20).isActive = true
        qCHHBtnText.text = "Login"
        
        //test > add spinner when login with fb/google
//        cPanel.addSubview(bSpinner)
        cLoggedBox.addSubview(bSpinner)
        bSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        bSpinner.translatesAutoresizingMaskIntoConstraints = false
        bSpinner.topAnchor.constraint(equalTo: gCHBtn.bottomAnchor, constant: 30).isActive = true  //0
        bSpinner.centerXAnchor.constraint(equalTo: cPanel.centerXAnchor).isActive = true
        bSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        bSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    @objc func onBackLoginPanelClicked(gesture: UITapGestureRecognizer) {
        closePanel(isAnimated: true)
    }
    
    @objc func onLoginGProceedClicked(gesture: UITapGestureRecognizer) {
//        openUserCreatorPanel()
        
        resignResponder()
        asyncSigninAccount(id: "sign_in_facebook")
    }
    @objc func onLoginHProceedClicked(gesture: UITapGestureRecognizer) {
        resignResponder()
        asyncSigninAccount(id: "sign_in_google")
    }
    @objc func onLoginIProceedClicked(gesture: UITapGestureRecognizer) {
        reactToPanelModeChange(mode: PANEL_MODE_LOGIN_EMAIL)
    }
    
    @objc func onLoginDenyClicked(gesture: UITapGestureRecognizer) {
        reactToPanelModeChange(mode: PANEL_MODE_SIGNUP)
    }
    
    @objc func onBackSignupPanelClicked(gesture: UITapGestureRecognizer) {
        resignResponder()
        closePanel(isAnimated: true)
    }
    @objc func onClickPanelClicked(gesture: UITapGestureRecognizer) {
        resignResponder()
    }
    @objc func onSignupHProceedClicked(gesture: UITapGestureRecognizer) {
        resignResponder()
        
        rContainer.isHidden = true
        qContainer.isHidden = false

        activate(textField: qTextField)
    }
    @objc func onSignupIProceedClicked(gesture: UITapGestureRecognizer) {

    }
    @objc func onSignupJProceedClicked(gesture: UITapGestureRecognizer) {

    }
    @objc func onSignupDenyClicked(gesture: UITapGestureRecognizer) {
        resignResponder()
        reactToPanelModeChange(mode: PANEL_MODE_LOGIN)
    }
    @objc func onSignupQHProceedClicked(gesture: UITapGestureRecognizer) {
        resignResponder()
        
        openUserCreatorPanel()
    }
    @objc func onClickCPanelClicked(gesture: UITapGestureRecognizer) {
        resignResponder()
    }
    @objc func onBackCPanelClicked(gesture: UITapGestureRecognizer) {
        resignResponder()
        closePanel(isAnimated: true)
    }
    @objc func onSignupCQHProceedClicked(gesture: UITapGestureRecognizer) {
        resignResponder()
        qCHHBtn.isHidden = true
        bSpinner.startAnimating()
        asyncSigninAccount(id: "sign_in")
    }
    func resignResponder() {
        self.endEditing(true)
    }
    
    func activate(textField: UITextField) {
        setFirstResponder(textField: textField)
    }
    func setFirstResponder(textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    //test > initialization state
    var isInitialized = false
    func initialize() {
        
        if(!isInitialized) {
            
            reactToPanelModeChange(mode: PANEL_MODE_LOGIN)
        }
        
        isInitialized = true
    }
    
    func reactToPanelModeChange(mode: String) {
        
        bPanel.isHidden = true
        cPanel.isHidden = true
        
        if(mode == PANEL_MODE_LOGIN) {
            currentPanelMode = PANEL_MODE_LOGIN
            bPanel.isHidden = true
        } else if(mode == PANEL_MODE_SIGNUP){
            currentPanelMode = PANEL_MODE_SIGNUP
            bPanel.isHidden = false
        } else {
            currentPanelMode = PANEL_MODE_LOGIN_EMAIL
            cPanel.isHidden = false
        }
    }
    
    func closePanel(isAnimated: Bool) {
        if(isAnimated) {
            UIView.animate(withDuration: 0.2, animations: {

                self.layoutIfNeeded()
            }, completion: { _ in
                self.removeFromSuperview()
                
                self.delegate?.didClickCloseLoginPanel()
            })
        } else {
            self.removeFromSuperview()
            self.delegate?.didClickCloseLoginPanel()
        }
    }
    
    func openUserCreatorPanel() {
        //test > use reusable method
        let panel = UserCreatorConsolePanelView(frame: CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.height))
        self.addSubview(panel)
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        panel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        panel.initialize()
        panel.delegate = self
    }
    
    func asyncSigninAccount(id: String) {
        
        //test > spinner animate
        aSpinner.startAnimating()
        aContainer.isHidden = true
        
        SignInManager.shared.signIn(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("loginpanel api success \(id), \(l)")
                    guard let self = self else {
                        return
                    }
                    
                    self.aSpinner.stopAnimating()
//                    self.aContainer.isHidden = false
                    
                    self.closePanel(isAnimated: true)
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    print("signin error : \(error)")
                
                    guard let self = self else {
                        return
                    }
                    self.closePanel(isAnimated: true)
                }
                break
            }
        }
    }
}

extension ViewController: LoginPanelDelegate{
    func didClickCloseLoginPanel(){
        //test 1 > as not scrollable
        print("mepanel login close")
        backPage(isCurrentPageScrollable: false)
    }
    func didClickCreateUserAccount(){
        
    }
    
    func didLoginUserCreatorClickUpload(data: String){
        openInAppMsgView(data: data)
//        openInAppMsgView(data: "up_user")
    }
}

extension LoginPanelView: UserCreatorPanelDelegate{
    func didInitializeUserCreator() {
        
    }
    
    func didClickFinishUserCreator() {
        //test
        resignResponder()
        closePanel(isAnimated: true)
    }
    
    func didUserCreatorClickUpload(data: String) {
        delegate?.didLoginUserCreatorClickUpload(data: data)
    }
}
