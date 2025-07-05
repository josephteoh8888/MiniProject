//
//  MePanelView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

protocol MePanelDelegate : AnyObject {

    //test > connect to other panel
    func didMeClickUser(id: String)
    func didMeClickEditProfile(id: String)
    func didMeClickFollowList(id: String, pointX: CGFloat, pointY: CGFloat)
    func didMeClickHistoryList(id: String, pointX: CGFloat, pointY: CGFloat)
    func didMeClickBookmarkList(id: String, pointX: CGFloat, pointY: CGFloat)
    func didMeClickLikeList(id: String, pointX: CGFloat, pointY: CGFloat)
    func didMeClickAccountSettingList()
    func didMeClickBaseList()
    func didMeClickMultiLocationList(id: String, pointX: CGFloat, pointY: CGFloat)
    func didMeClickMultiPostList(id: String, pointX: CGFloat, pointY: CGFloat)
    func didMeClickMultiPhotoList(id: String, pointX: CGFloat, pointY: CGFloat)
    func didMeClickMultiVideoList(id: String, pointX: CGFloat, pointY: CGFloat)
    func didMeClickCommentList(id: String, pointX: CGFloat, pointY: CGFloat)
    func didMeClickLogin()
    func didMeStartSignout()
    func didMeSignoutSuccess()
    func didMeSignoutFail()
}

class MePanelView: PanelView{
    var panel = UIView()
    
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    let stackView = UIView()
    let scrollView = UIScrollView()
    
    var dataFetchState = ""
    let aSpinner = SpinLoader()
    
    let aHLightSection = UIView()
    var aHLightDataArray = [String]()
//    var aHLightViewArray = [UIView]()
    var aHLightViewArray = [MeCell]()
    
    weak var delegate : MePanelDelegate?
    
    let aLoggedInTextBox = UIView()
    let aLoggedOutTextBox = UIView()
    let aLoggedOutBox = UIView()
    
    //test > user login/out status
    var isUserLoggedIn = false
    
    //test
    var hideCellIndex = -1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        viewWidth = frame.width
//        viewHeight = frame.height
        setupViews()

    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    func setupViews() {
        panel.backgroundColor = .ddmBlackOverlayColor
        self.addSubview(panel)
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        panel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //default 0
        panel.layer.masksToBounds = true
        panel.layer.cornerRadius = 10 //10
//        panel.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        panel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        panel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        
        let aBtn = UIView()
//        aBtn.backgroundColor = .ddmDarkColor
//        aBtn.backgroundColor = .clear
        panel.addSubview(aBtn)
        aBtn.translatesAutoresizingMaskIntoConstraints = false
        aBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
        aBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        aBtn.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -10).isActive = true
        aBtn.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 20).isActive = true
    //        aBtn.topAnchor.constraint(equalTo: userPanel.topAnchor, constant: 30).isActive = true
        aBtn.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        aBtn.layer.cornerRadius = 20
//        aBtn.layer.opacity = 0.3
        aBtn.isUserInteractionEnabled = true
        aBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onABtnClicked)))
        
        let rBoxBtn = UIImageView()
        rBoxBtn.image = UIImage(named:"icon_round_setting")?.withRenderingMode(.alwaysTemplate)
        rBoxBtn.tintColor = .white
        panel.addSubview(rBoxBtn)
        rBoxBtn.translatesAutoresizingMaskIntoConstraints = false
        rBoxBtn.centerXAnchor.constraint(equalTo: aBtn.centerXAnchor).isActive = true
        rBoxBtn.centerYAnchor.constraint(equalTo: aBtn.centerYAnchor).isActive = true
        rBoxBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true
        rBoxBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
//        rBoxBtn.layer.opacity = 0.5
        
        let aSemiTransparentTextBox = UIView()
        panel.addSubview(aSemiTransparentTextBox)
        aSemiTransparentTextBox.translatesAutoresizingMaskIntoConstraints = false
        aSemiTransparentTextBox.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true //default:0
        aSemiTransparentTextBox.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        aSemiTransparentTextBox.heightAnchor.constraint(equalToConstant: 40).isActive = true //42
        
//        let aLoggedInTextBox = UIView()
        aSemiTransparentTextBox.addSubview(aLoggedInTextBox)
        aLoggedInTextBox.translatesAutoresizingMaskIntoConstraints = false
        aLoggedInTextBox.topAnchor.constraint(equalTo: aSemiTransparentTextBox.topAnchor, constant: 0).isActive = true
        aLoggedInTextBox.bottomAnchor.constraint(equalTo: aSemiTransparentTextBox.bottomAnchor, constant: 0).isActive = true
        aLoggedInTextBox.leadingAnchor.constraint(equalTo: aSemiTransparentTextBox.leadingAnchor, constant: 0).isActive = true
        aLoggedInTextBox.trailingAnchor.constraint(equalTo: aSemiTransparentTextBox.trailingAnchor, constant: 0).isActive = true
        aLoggedInTextBox.isHidden = true
//        aLoggedInTextBox.layer.cornerRadius = 10
//        aLoggedInTextBox.backgroundColor = .black
        
//        let aLoggedOutTextBox = UIView()
        aSemiTransparentTextBox.addSubview(aLoggedOutTextBox)
        aLoggedOutTextBox.translatesAutoresizingMaskIntoConstraints = false
        aLoggedOutTextBox.topAnchor.constraint(equalTo: aSemiTransparentTextBox.topAnchor, constant: 0).isActive = true
        aLoggedOutTextBox.bottomAnchor.constraint(equalTo: aSemiTransparentTextBox.bottomAnchor, constant: 0).isActive = true
        aLoggedOutTextBox.leadingAnchor.constraint(equalTo: aSemiTransparentTextBox.leadingAnchor, constant: 0).isActive = true
        aLoggedOutTextBox.trailingAnchor.constraint(equalTo: aSemiTransparentTextBox.trailingAnchor, constant: 0).isActive = true
        aLoggedOutTextBox.isHidden = false
//        aLoggedOutTextBox.isHidden = true
        
        let aLoggedOutText = UILabel()
        aLoggedOutText.textAlignment = .center
        aLoggedOutText.textColor = .white
        aLoggedOutText.font = .boldSystemFont(ofSize: 14)
//        aSemiTransparentTextBox.addSubview(aSemiTransparentText)
        aLoggedOutTextBox.addSubview(aLoggedOutText)
        aLoggedOutText.translatesAutoresizingMaskIntoConstraints = false
        aLoggedOutText.topAnchor.constraint(equalTo: aLoggedOutTextBox.topAnchor, constant: 13).isActive = true
        aLoggedOutText.bottomAnchor.constraint(equalTo: aLoggedOutTextBox.bottomAnchor, constant: -13).isActive = true
        aLoggedOutText.leadingAnchor.constraint(equalTo: aLoggedOutTextBox.leadingAnchor, constant: 10).isActive = true
        aLoggedOutText.trailingAnchor.constraint(equalTo: aLoggedOutTextBox.trailingAnchor, constant: -10).isActive = true
        aLoggedOutText.text = "Account" //Profile
        
        let aStickyPhotoOuter = UIView()
        aStickyPhotoOuter.backgroundColor = .white
//        aSemiTransparentTextBox.addSubview(aStickyPhotoOuter)
        aLoggedInTextBox.addSubview(aStickyPhotoOuter)
        aStickyPhotoOuter.translatesAutoresizingMaskIntoConstraints = false
//        aStickyPhotoOuter.leadingAnchor.constraint(equalTo: aSemiTransparentTextBox.leadingAnchor, constant: 10).isActive = true
//        aStickyPhotoOuter.centerYAnchor.constraint(equalTo: aSemiTransparentTextBox.centerYAnchor, constant: 0).isActive = true
        aStickyPhotoOuter.leadingAnchor.constraint(equalTo: aLoggedInTextBox.leadingAnchor, constant: 10).isActive = true
        aStickyPhotoOuter.centerYAnchor.constraint(equalTo: aLoggedInTextBox.centerYAnchor, constant: 0).isActive = true
        aStickyPhotoOuter.heightAnchor.constraint(equalToConstant: 26).isActive = true //ori 38
        aStickyPhotoOuter.widthAnchor.constraint(equalToConstant: 26).isActive = true
        aStickyPhotoOuter.layer.cornerRadius = 13 //19

        let aStickyPhoto = SDAnimatedImageView()
        aStickyPhotoOuter.addSubview(aStickyPhoto)
        aStickyPhoto.translatesAutoresizingMaskIntoConstraints = false
        aStickyPhoto.centerXAnchor.constraint(equalTo: aStickyPhotoOuter.centerXAnchor).isActive = true
        aStickyPhoto.centerYAnchor.constraint(equalTo: aStickyPhotoOuter.centerYAnchor).isActive = true
        aStickyPhoto.heightAnchor.constraint(equalToConstant: 22).isActive = true //30
        aStickyPhoto.widthAnchor.constraint(equalToConstant: 22).isActive = true
        let stickyImageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        aStickyPhoto.contentMode = .scaleAspectFill
        aStickyPhoto.layer.masksToBounds = true
        aStickyPhoto.layer.cornerRadius = 11
        aStickyPhoto.sd_setImage(with: stickyImageUrl)
        
        let aSemiTransparentText = UILabel()
        aSemiTransparentText.textAlignment = .center
        aSemiTransparentText.textColor = .white
        aSemiTransparentText.font = .boldSystemFont(ofSize: 14)
//        aSemiTransparentTextBox.addSubview(aSemiTransparentText)
        aLoggedInTextBox.addSubview(aSemiTransparentText)
        aSemiTransparentText.translatesAutoresizingMaskIntoConstraints = false
//        aSemiTransparentText.topAnchor.constraint(equalTo: aSemiTransparentTextBox.topAnchor, constant: 13).isActive = true
//        aSemiTransparentText.bottomAnchor.constraint(equalTo: aSemiTransparentTextBox.bottomAnchor, constant: -13).isActive = true
        aSemiTransparentText.topAnchor.constraint(equalTo: aLoggedInTextBox.topAnchor, constant: 13).isActive = true
        aSemiTransparentText.bottomAnchor.constraint(equalTo: aLoggedInTextBox.bottomAnchor, constant: -13).isActive = true
        aSemiTransparentText.leadingAnchor.constraint(equalTo: aStickyPhotoOuter.trailingAnchor, constant: 10).isActive = true
        aSemiTransparentText.text = "@mic809" //default: Around You
        aSemiTransparentText.isUserInteractionEnabled = true
        aSemiTransparentText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onProfileClicked)))

        let arrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_down")?.withRenderingMode(.alwaysTemplate))
        arrowBtn.tintColor = .white
//        aSemiTransparentTextBox.addSubview(arrowBtn)
        aLoggedInTextBox.addSubview(arrowBtn)
        arrowBtn.translatesAutoresizingMaskIntoConstraints = false
//        arrowBtn.leadingAnchor.constraint(equalTo: aSemiTransparentText.trailingAnchor).isActive = true
//        arrowBtn.trailingAnchor.constraint(equalTo: aSemiTransparentTextBox.trailingAnchor, constant: 0).isActive = true
//        arrowBtn.centerYAnchor.constraint(equalTo: aSemiTransparentTextBox.centerYAnchor).isActive = true
        arrowBtn.leadingAnchor.constraint(equalTo: aSemiTransparentText.trailingAnchor).isActive = true
        arrowBtn.trailingAnchor.constraint(equalTo: aLoggedInTextBox.trailingAnchor, constant: 0).isActive = true
        arrowBtn.centerYAnchor.constraint(equalTo: aLoggedInTextBox.centerYAnchor).isActive = true
        arrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true //ori 26
        arrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        arrowBtn.isUserInteractionEnabled = true
//        arrowBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSemiArrowClicked)))
        
//        let scrollView = UIScrollView()
        panel.addSubview(scrollView)
        scrollView.backgroundColor = .clear
//        scrollView.backgroundColor = .red
        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.topAnchor.constraint(equalTo: aBtn.bottomAnchor, constant: 10).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true //50
//        scrollView.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: 0).isActive = true
        scrollView.showsVerticalScrollIndicator = false
//        scrollView.contentSize = CGSize(width: viewWidth, height: viewHeight - 150)
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = true
        scrollView.centerXAnchor.constraint(equalTo: panel.centerXAnchor).isActive = true
        
        panel.addSubview(aSpinner)
        aSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        aSpinner.translatesAutoresizingMaskIntoConstraints = false
        aSpinner.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true  //0
        aSpinner.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        aSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        aSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
//        let stackView = UIView()
        stackView.backgroundColor = .clear
//        stackView.backgroundColor = .blue
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
//        stackView.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0).isActive = true
        
//        let aHLightSection = UIView()
        stackView.addSubview(aHLightSection)
//        aHLightSection.backgroundColor = .green
        aHLightSection.translatesAutoresizingMaskIntoConstraints = false
//        aHLightSection.topAnchor.constraint(equalTo: aPhoto.bottomAnchor, constant: 30).isActive = true
        aHLightSection.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 10).isActive = true
        aHLightSection.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0).isActive = true
        aHLightSection.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0).isActive = true
        aHLightSection.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -10).isActive = true

        //test > logged out UI
//        let aLoggedOutBox = UIView()
        panel.addSubview(aLoggedOutBox)
        aLoggedOutBox.translatesAutoresizingMaskIntoConstraints = false
//        aLoggedOutBox.topAnchor.constraint(equalTo: aSemiTransparentTextBox.topAnchor, constant: 0).isActive = true
        aLoggedOutBox.centerYAnchor.constraint(equalTo: panel.centerYAnchor, constant: -60).isActive = true //-90
        aLoggedOutBox.leadingAnchor.constraint(equalTo: panel.leadingAnchor).isActive = true
        aLoggedOutBox.trailingAnchor.constraint(equalTo: panel.trailingAnchor).isActive = true
        aLoggedOutBox.isHidden = false
//        aLoggedOutBox.isHidden = true
        
//        let loggedOutImage = UIImageView(image: UIImage(named:"icon_outline_account")?.withRenderingMode(.alwaysTemplate))
        let loggedOutImage = UIImageView(image: UIImage(named:"icon_round_account_b")?.withRenderingMode(.alwaysTemplate))
        loggedOutImage.tintColor = .white
        aLoggedOutBox.addSubview(loggedOutImage)
        loggedOutImage.translatesAutoresizingMaskIntoConstraints = false
        loggedOutImage.topAnchor.constraint(equalTo: aLoggedOutBox.topAnchor).isActive = true
        loggedOutImage.centerXAnchor.constraint(equalTo: aLoggedOutBox.centerXAnchor, constant: 0).isActive = true
        loggedOutImage.heightAnchor.constraint(equalToConstant: 60).isActive = true //ori 26
        loggedOutImage.widthAnchor.constraint(equalToConstant: 60).isActive = true
//        loggedOutImage.layer.opacity = 0.8
        
        let aLoginText = UILabel()
        aLoginText.textAlignment = .center
        aLoginText.textColor = .white
        aLoginText.font = .boldSystemFont(ofSize: 13)
//        aLoginText.font = .systemFont(ofSize: 14)
        aLoggedOutBox.addSubview(aLoginText)
        aLoginText.translatesAutoresizingMaskIntoConstraints = false
        aLoginText.topAnchor.constraint(equalTo: loggedOutImage.bottomAnchor, constant: 10).isActive = true
        aLoginText.centerXAnchor.constraint(equalTo: loggedOutImage.centerXAnchor, constant: 0).isActive = true
        aLoginText.text = "Log into existing account" //default: Around You
        
        let aFollow = UIView()
        aFollow.backgroundColor = .yellow
        aLoggedOutBox.addSubview(aFollow)
        aFollow.translatesAutoresizingMaskIntoConstraints = false
//        aFollow.leadingAnchor.constraint(equalTo: aLoggedOutBox.leadingAnchor, constant: 100).isActive = true
//        aFollow.trailingAnchor.constraint(equalTo: aLoggedOutBox.trailingAnchor, constant: -100).isActive = true
        aFollow.centerXAnchor.constraint(equalTo: aLoggedOutBox.centerXAnchor).isActive = true
        aFollow.heightAnchor.constraint(equalToConstant: 40).isActive = true //30
        aFollow.topAnchor.constraint(equalTo: aLoginText.bottomAnchor, constant: 20).isActive = true
        aFollow.bottomAnchor.constraint(equalTo: aLoggedOutBox.bottomAnchor, constant: 0).isActive = true
        aFollow.layer.cornerRadius = 10
        aFollow.isUserInteractionEnabled = true
        aFollow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onFollowClicked)))

        let aFollowText = UILabel()
        aFollowText.textAlignment = .center
        aFollowText.textColor = .black
        aFollowText.font = .boldSystemFont(ofSize: 13) //default 14
        aFollow.addSubview(aFollowText)
        aFollowText.translatesAutoresizingMaskIntoConstraints = false
//        aFollowText.centerXAnchor.constraint(equalTo: aFollow.centerXAnchor).isActive = true
        aFollowText.leadingAnchor.constraint(equalTo: aFollow.leadingAnchor, constant: 60).isActive = true
        aFollowText.trailingAnchor.constraint(equalTo: aFollow.trailingAnchor, constant: -60).isActive = true
        aFollowText.centerYAnchor.constraint(equalTo: aFollow.centerYAnchor).isActive = true
        aFollowText.text = "Login"
    }
    
    @objc func onABtnClicked(gesture: UITapGestureRecognizer) {
        print("mePanel setting btn clicked")
    }
    @objc func onFollowClicked(gesture: UITapGestureRecognizer) {
        
        aLoggedOutBox.isHidden = true
        
        delegate?.didMeClickLogin()
    }
    @objc func onProfileClicked(gesture: UITapGestureRecognizer) {
//        delegate?.didMeClickUser()
    }
    
    //test
    override func resumeActiveState() {
        print("mepanel resume")
        //test > check for signin status when in active state
        asyncFetchSigninStatus()
        
        //test
        dehideCell()
    }
    
    func dehideCell() {
        if(hideCellIndex > -1) {
            let currentVc = aHLightViewArray[hideCellIndex]
            currentVc.dehideCell()
            hideCellIndex = -1
        }
    }
    
    //test > initialization state
    var isInitialized = false
    func initialize() {
        if(!isInitialized) {
            if(isUserLoggedIn) {
                aLoggedOutBox.isHidden = true
                
                self.asyncFetchFeed(id: "post_feed")
            } else {
                aLoggedOutBox.isHidden = false
            }
        }
        
        isInitialized = true
    }
    func initialize(width: CGFloat, height: CGFloat) {
        viewWidth = width
        viewHeight = height
        
//        initialize()
        
        //test
        asyncFetchSigninStatus()
    }
    
    func deconfigureMeCell() {
        
        self.scrollView.setContentOffset(CGPoint.zero, animated: false) //to prevent sudden scroll up
        
        if(!aHLightViewArray.isEmpty) {
            for e in aHLightViewArray {
                e.removeFromSuperview()
            }
            aHLightViewArray.removeAll()
        }
        if(!aHLightDataArray.isEmpty) {
            aHLightDataArray.removeAll()
        }
    }
    
    func configureMeCell() {
        for l in aHLightDataArray {
            if(l == "a") {
                let cell = MultiPhotosMeCell(frame: CGRect(x: 0 , y: 0, width: viewWidth, height: viewHeight))
//                aHLightRect1.addSubview(cell)
                aHLightSection.addSubview(cell)
                cell.translatesAutoresizingMaskIntoConstraints = false
                cell.leadingAnchor.constraint(equalTo: aHLightSection.leadingAnchor, constant: 0).isActive = true
                cell.trailingAnchor.constraint(equalTo: aHLightSection.trailingAnchor, constant: 0).isActive = true
                if(aHLightViewArray.isEmpty) {
                    cell.topAnchor.constraint(equalTo: aHLightSection.topAnchor, constant: 0).isActive = true
                } else {
                    let lastArrayE = aHLightViewArray[aHLightViewArray.count - 1]
                    cell.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 10).isActive = true //10
                }
                aHLightViewArray.append(cell)
                cell.initialize()
                cell.aDelegate = self
            } else if(l == "b") {
                let cell = MultiLoopsMeCell(frame: CGRect(x: 0 , y: 0, width: viewWidth, height: viewHeight))
//                aHLightRect1.addSubview(cell)
                aHLightSection.addSubview(cell)
                cell.translatesAutoresizingMaskIntoConstraints = false
                cell.leadingAnchor.constraint(equalTo: aHLightSection.leadingAnchor, constant: 0).isActive = true
                cell.trailingAnchor.constraint(equalTo: aHLightSection.trailingAnchor, constant: 0).isActive = true
                if(aHLightViewArray.isEmpty) {
                    cell.topAnchor.constraint(equalTo: aHLightSection.topAnchor, constant: 0).isActive = true
                } else {
                    let lastArrayE = aHLightViewArray[aHLightViewArray.count - 1]
                    cell.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 10).isActive = true //10
                }
                aHLightViewArray.append(cell)
                cell.initialize()
                cell.aDelegate = self
            } else if(l == "c") {
                let cell = MultiPostsMeCell(frame: CGRect(x: 0 , y: 0, width: viewWidth, height: viewHeight))
//                aHLightRect1.addSubview(cell)
                aHLightSection.addSubview(cell)
                cell.translatesAutoresizingMaskIntoConstraints = false
                cell.leadingAnchor.constraint(equalTo: aHLightSection.leadingAnchor, constant: 0).isActive = true
                cell.trailingAnchor.constraint(equalTo: aHLightSection.trailingAnchor, constant: 0).isActive = true
                if(aHLightViewArray.isEmpty) {
                    cell.topAnchor.constraint(equalTo: aHLightSection.topAnchor, constant: 0).isActive = true
                } else {
                    let lastArrayE = aHLightViewArray[aHLightViewArray.count - 1]
                    cell.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 10).isActive = true //10
                }
                aHLightViewArray.append(cell)
                cell.initialize()
                cell.aDelegate = self
            } else if(l == "co") {
                let cell = MultiCommentsMeCell(frame: CGRect(x: 0 , y: 0, width: viewWidth, height: viewHeight))
//                aHLightRect1.addSubview(cell)
                aHLightSection.addSubview(cell)
                cell.translatesAutoresizingMaskIntoConstraints = false
                cell.leadingAnchor.constraint(equalTo: aHLightSection.leadingAnchor, constant: 0).isActive = true
                cell.trailingAnchor.constraint(equalTo: aHLightSection.trailingAnchor, constant: 0).isActive = true
                if(aHLightViewArray.isEmpty) {
                    cell.topAnchor.constraint(equalTo: aHLightSection.topAnchor, constant: 0).isActive = true
                } else {
                    let lastArrayE = aHLightViewArray[aHLightViewArray.count - 1]
                    cell.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 10).isActive = true //10
                }
                aHLightViewArray.append(cell)
                cell.initialize()
                cell.aDelegate = self
            } else if(l == "h") {
                let cell = HistoryMeCell(frame: CGRect(x: 0 , y: 0, width: viewWidth, height: viewHeight))
//                aHLightRect1.addSubview(cell)
                aHLightSection.addSubview(cell)
                cell.translatesAutoresizingMaskIntoConstraints = false
                cell.leadingAnchor.constraint(equalTo: aHLightSection.leadingAnchor, constant: 0).isActive = true
                cell.trailingAnchor.constraint(equalTo: aHLightSection.trailingAnchor, constant: 0).isActive = true
                if(aHLightViewArray.isEmpty) {
                    cell.topAnchor.constraint(equalTo: aHLightSection.topAnchor, constant: 0).isActive = true
                } else {
                    let lastArrayE = aHLightViewArray[aHLightViewArray.count - 1]
                    cell.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 10).isActive = true //10
                }
                aHLightViewArray.append(cell)
                cell.initialize()
                cell.aDelegate = self
            } else if(l == "l") {
                let cell = LikeMeCell(frame: CGRect(x: 0 , y: 0, width: viewWidth, height: viewHeight))
//                aHLightRect1.addSubview(cell)
                aHLightSection.addSubview(cell)
                cell.translatesAutoresizingMaskIntoConstraints = false
                cell.leadingAnchor.constraint(equalTo: aHLightSection.leadingAnchor, constant: 0).isActive = true
                cell.trailingAnchor.constraint(equalTo: aHLightSection.trailingAnchor, constant: 0).isActive = true
                if(aHLightViewArray.isEmpty) {
                    cell.topAnchor.constraint(equalTo: aHLightSection.topAnchor, constant: 0).isActive = true
                } else {
                    let lastArrayE = aHLightViewArray[aHLightViewArray.count - 1]
                    cell.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 10).isActive = true //10
                }
                aHLightViewArray.append(cell)
                cell.initialize()
                cell.aDelegate = self
            } else if(l == "s") {
                let cell = BookmarkMeCell(frame: CGRect(x: 0 , y: 0, width: viewWidth, height: viewHeight))
//                aHLightRect1.addSubview(cell)
                aHLightSection.addSubview(cell)
                cell.translatesAutoresizingMaskIntoConstraints = false
                cell.leadingAnchor.constraint(equalTo: aHLightSection.leadingAnchor, constant: 0).isActive = true
                cell.trailingAnchor.constraint(equalTo: aHLightSection.trailingAnchor, constant: 0).isActive = true
                if(aHLightViewArray.isEmpty) {
                    cell.topAnchor.constraint(equalTo: aHLightSection.topAnchor, constant: 0).isActive = true
                } else {
                    let lastArrayE = aHLightViewArray[aHLightViewArray.count - 1]
                    cell.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 10).isActive = true //10
                }
                aHLightViewArray.append(cell)
                cell.initialize()
                cell.aDelegate = self
            } else if(l == "as") {
                let cell = AccountMeCell(frame: CGRect(x: 0 , y: 0, width: viewWidth, height: viewHeight))
//                aHLightRect1.addSubview(cell)
                aHLightSection.addSubview(cell)
                cell.translatesAutoresizingMaskIntoConstraints = false
                cell.leadingAnchor.constraint(equalTo: aHLightSection.leadingAnchor, constant: 0).isActive = true
                cell.trailingAnchor.constraint(equalTo: aHLightSection.trailingAnchor, constant: 0).isActive = true
                if(aHLightViewArray.isEmpty) {
                    cell.topAnchor.constraint(equalTo: aHLightSection.topAnchor, constant: 0).isActive = true
                } else {
                    let lastArrayE = aHLightViewArray[aHLightViewArray.count - 1]
                    cell.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 10).isActive = true //10
                }
                aHLightViewArray.append(cell)
                cell.initialize()
                cell.aDelegate = self
            } else if(l == "ba") {
                let cell = BaseMeCell(frame: CGRect(x: 0 , y: 0, width: viewWidth, height: viewHeight))
//                aHLightRect1.addSubview(cell)
                aHLightSection.addSubview(cell)
                cell.translatesAutoresizingMaskIntoConstraints = false
                cell.leadingAnchor.constraint(equalTo: aHLightSection.leadingAnchor, constant: 0).isActive = true
                cell.trailingAnchor.constraint(equalTo: aHLightSection.trailingAnchor, constant: 0).isActive = true
                if(aHLightViewArray.isEmpty) {
                    cell.topAnchor.constraint(equalTo: aHLightSection.topAnchor, constant: 0).isActive = true
                } else {
                    let lastArrayE = aHLightViewArray[aHLightViewArray.count - 1]
                    cell.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 10).isActive = true //10
                }
                aHLightViewArray.append(cell)
                cell.initialize()
                cell.aDelegate = self
            } else if(l == "ep") {
                let cell = EditProfileMeCell(frame: CGRect(x: 0 , y: 0, width: viewWidth, height: viewHeight))
//                aHLightRect1.addSubview(cell)
                aHLightSection.addSubview(cell)
                cell.translatesAutoresizingMaskIntoConstraints = false
                cell.leadingAnchor.constraint(equalTo: aHLightSection.leadingAnchor, constant: 0).isActive = true
                cell.trailingAnchor.constraint(equalTo: aHLightSection.trailingAnchor, constant: 0).isActive = true
                if(aHLightViewArray.isEmpty) {
                    cell.topAnchor.constraint(equalTo: aHLightSection.topAnchor, constant: 0).isActive = true
                } else {
                    let lastArrayE = aHLightViewArray[aHLightViewArray.count - 1]
                    cell.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 10).isActive = true //10
                }
                aHLightViewArray.append(cell)
                cell.initialize()
                cell.aDelegate = self
            } else if(l == "fr") {
                let cell = FollowerMeCell(frame: CGRect(x: 0 , y: 0, width: viewWidth, height: viewHeight))
//                aHLightRect1.addSubview(cell)
                aHLightSection.addSubview(cell)
                cell.translatesAutoresizingMaskIntoConstraints = false
                cell.leadingAnchor.constraint(equalTo: aHLightSection.leadingAnchor, constant: 0).isActive = true
                cell.trailingAnchor.constraint(equalTo: aHLightSection.trailingAnchor, constant: 0).isActive = true
                if(aHLightViewArray.isEmpty) {
                    cell.topAnchor.constraint(equalTo: aHLightSection.topAnchor, constant: 0).isActive = true
                } else {
                    let lastArrayE = aHLightViewArray[aHLightViewArray.count - 1]
                    cell.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 10).isActive = true //10
                }
                aHLightViewArray.append(cell)
                cell.initialize()
                cell.aDelegate = self
            } else if(l == "lo") {
                let cell = LocationMeCell(frame: CGRect(x: 0 , y: 0, width: viewWidth, height: viewHeight))
//                aHLightRect1.addSubview(cell)
                aHLightSection.addSubview(cell)
                cell.translatesAutoresizingMaskIntoConstraints = false
                cell.leadingAnchor.constraint(equalTo: aHLightSection.leadingAnchor, constant: 0).isActive = true
                cell.trailingAnchor.constraint(equalTo: aHLightSection.trailingAnchor, constant: 0).isActive = true
                if(aHLightViewArray.isEmpty) {
                    cell.topAnchor.constraint(equalTo: aHLightSection.topAnchor, constant: 0).isActive = true
                } else {
                    let lastArrayE = aHLightViewArray[aHLightViewArray.count - 1]
                    cell.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 10).isActive = true //10
                }
                aHLightViewArray.append(cell)
                cell.initialize()
                cell.aDelegate = self
            } else if(l == "pme") {
                let cell = ProfileMeCell(frame: CGRect(x: 0 , y: 0, width: viewWidth, height: viewHeight))
//                aHLightRect1.addSubview(cell)
                aHLightSection.addSubview(cell)
                cell.translatesAutoresizingMaskIntoConstraints = false
                cell.leadingAnchor.constraint(equalTo: aHLightSection.leadingAnchor, constant: 0).isActive = true
                cell.trailingAnchor.constraint(equalTo: aHLightSection.trailingAnchor, constant: 0).isActive = true
                if(aHLightViewArray.isEmpty) {
                    cell.topAnchor.constraint(equalTo: aHLightSection.topAnchor, constant: 0).isActive = true
                } else {
                    let lastArrayE = aHLightViewArray[aHLightViewArray.count - 1]
                    cell.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 10).isActive = true //10
                }
                aHLightViewArray.append(cell)
                cell.initialize()
                cell.aDelegate = self
            } else if(l == "so") {
                let cell = SignoutMeCell(frame: CGRect(x: 0 , y: 0, width: viewWidth, height: viewHeight))
//                aHLightRect1.addSubview(cell)
                aHLightSection.addSubview(cell)
                cell.translatesAutoresizingMaskIntoConstraints = false
                cell.leadingAnchor.constraint(equalTo: aHLightSection.leadingAnchor, constant: 0).isActive = true
                cell.trailingAnchor.constraint(equalTo: aHLightSection.trailingAnchor, constant: 0).isActive = true
                if(aHLightViewArray.isEmpty) {
                    cell.topAnchor.constraint(equalTo: aHLightSection.topAnchor, constant: 0).isActive = true
                } else {
                    let lastArrayE = aHLightViewArray[aHLightViewArray.count - 1]
                    cell.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 10).isActive = true //10
                }
                aHLightViewArray.append(cell)
                cell.initialize()
                cell.aDelegate = self
            }
        }
        
        if(!aHLightViewArray.isEmpty) {
            let lastArrayE = aHLightViewArray[aHLightViewArray.count - 1]
            lastArrayE.bottomAnchor.constraint(equalTo: aHLightSection.bottomAnchor, constant: -10).isActive = true
        }
    }
    
    func refreshFetchData() {
        //clear data
        dataFetchState = ""
        
        //fetch new data
        asyncFetchFeed(id: "post_feed")
    }
    
    func asyncFetchFeed(id: String) {
        
        //test
        deconfigureMeCell()

        dataFetchState = "start"
        aSpinner.startAnimating()
        
        //test > adjust contentInset to y = 50 to move cv downward to accomodate spinner
//        self.adjustContentInset(topInset: CGFloat(50), bottomInset: CGFloat(120)) //50 bottominset
        scrollView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0) //top: 50, left: 0, bottom: 0, right: 0
        
        DataFetchManager.shared.fetchData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("api success \(id), \(l)")
                    
                    guard let self = self else {
                        return
                    }
                    
                    //test
                    self.aSpinner.stopAnimating()
                    
                    //test > animate cv back to y = 0 by contentOffset then only adjust contentInset after animate
//                    self.adjustContentOffset(x: 0, y: 0, animated: true)
                    
                    //**test > update contentsize of scrollview
//                    let a = self.stackView.bounds
//                    print("stackview size 2: \(a), \(self.frame)")
//
//                    //test > add bottom margin
//                    let bottomMargin = 70.0
//
//                    self.scrollView.contentSize = CGSize(width: a.width, height: a.height + bottomMargin)
                    
                    //test > configure cells
                    self.aHLightDataArray.append("pme")
                    self.aHLightDataArray.append("ba")
                    self.aHLightDataArray.append("ep")
                    self.aHLightDataArray.append("as")
        //            aHLightDataArray.append("f")
                    self.aHLightDataArray.append("fr")
                    self.aHLightDataArray.append("h")
                    self.aHLightDataArray.append("l")
                    self.aHLightDataArray.append("s")
                    
                    self.aHLightDataArray.append("a")
                    self.aHLightDataArray.append("b")
                    self.aHLightDataArray.append("c")
                    self.aHLightDataArray.append("lo")
//                    self.aHLightDataArray.append("co")
                    self.aHLightDataArray.append("so")
                    self.configureMeCell()
                    
                    self.scrollView.setContentOffset(CGPoint.zero, animated: true)
//                    self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                    //**
                    
                    self.dataFetchState = "end"
                }

                case .failure(_):
                    print("api fail")
                    break
            }
        }
    }
    
    func asyncSignoutAccount(id: String) {
        
        delegate?.didMeStartSignout()
        
        SignInManager.shared.signOut(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("mepanel signout api success \(id), \(l)")
                    
                    guard let self = self else {
                        return
                    }
                    
                    let isSignedIn = l
                    if(self.isUserLoggedIn != isSignedIn) {
                        self.isUserLoggedIn = isSignedIn
                        
                        self.deconfigureMeCell()
                
                        self.isInitialized = false
                        self.initialize()
                    }
                    
                    //test > remove signout progress view
                    self.delegate?.didMeSignoutSuccess()
                }

                case .failure(_):
                
                DispatchQueue.main.async {
                    print("mepanel signout api fail \(id)")
                    
                    guard let self = self else {
                        return
                    }
                    
                    //test > remove signout progress view
                    self.delegate?.didMeSignoutFail()
                }
                    
                break
            }
        }
    }
    
    func asyncFetchSigninStatus() {
        //test > simple get method
        let isSignedIn = SignInManager.shared.getStatus()
        if(self.isInitialized) {
            if(self.isUserLoggedIn != isSignedIn) {
                self.isUserLoggedIn = isSignedIn
                
                self.deconfigureMeCell()
        
                self.isInitialized = false
                self.initialize()
                print("mepanel A")
            }
            //test > recheck UI for aLoggedOut
            else {
                if(self.isUserLoggedIn) {
                    self.aLoggedOutBox.isHidden = true
                } else {
                    self.aLoggedOutBox.isHidden = false
                }
                print("mepanel B")
            }
        } else {
            self.isUserLoggedIn = isSignedIn
            self.initialize()
            print("mepanel C")
        }
    }
}

extension MePanelView: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("xx6 scrollview begin: \(scrollView.contentOffset.y)")
        let scrollOffsetY = scrollView.contentOffset.y
        
//        resignResponder()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("xx6 scrollview scroll: \(scrollView.contentOffset.y)")

        let scrollOffsetY = scrollView.contentOffset.y
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("xx6 scrollview end: \(scrollView.contentOffset.y)")
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("xx6 scrollview end drag: \(scrollView.contentOffset.y)")
        
        let scrollOffsetY = scrollView.contentOffset.y
        
        //test > refresh dataset
        if(scrollOffsetY < -80) {
            if(isUserLoggedIn) {
                self.refreshFetchData()
            }
        }
        
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        print("xx6 scrollview animation ended")
        
        //**test > update contentsize of scrollview
        let a = self.stackView.bounds
        print("stackview size 2: \(a), \(self.frame)")
        
        //test > add bottom margin
        let bottomMargin = 70.0
        
        self.scrollView.contentSize = CGSize(width: a.width, height: a.height + bottomMargin)
        print("xx6 scrollview animation ended stackview size 2: \(a)")
        
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension MePanelView: MeCellDelegate{

    func didMeCellClickSignout() {
        asyncSignoutAccount(id: "sign_out")
    }
    func didMeCellClickBase(id: String) {
        delegate?.didMeClickBaseList()
    }
    func didMeCellClickEditProfile(id: String) {
        delegate?.didMeClickEditProfile(id: id)
    }
    func didMeCellClickAccountSetting(){
        delegate?.didMeClickAccountSettingList()
    }
    func didMeCellClickFollow(id: String, pointX: CGFloat, pointY: CGFloat, c: MeCell){
        let originInRootView = aHLightSection.convert(c.frame.origin, to: self)
        let pointX1 = originInRootView.x + pointX
        let pointY1 = originInRootView.y + pointY
        delegate?.didMeClickFollowList(id: id, pointX: pointX1, pointY: pointY1)
        
        var i = 0
        for cell in aHLightViewArray {
            if(cell == c) {
                print("mecell hidden \(i)")
                hideCellIndex = i
                break
            }
            i += 1
        }
    }
    func didMeCellClickHistory(id: String, pointX: CGFloat, pointY: CGFloat, c: MeCell){
        let originInRootView = aHLightSection.convert(c.frame.origin, to: self)
        let pointX1 = originInRootView.x + pointX
        let pointY1 = originInRootView.y + pointY
        delegate?.didMeClickHistoryList(id: id, pointX: pointX1, pointY: pointY1)
        
        var i = 0
        for cell in aHLightViewArray {
            if(cell == c) {
                print("mecell hidden \(i)")
                hideCellIndex = i
                break
            }
            i += 1
        }
    }
    func didMeCellClickLike(id: String, pointX: CGFloat, pointY: CGFloat, c: MeCell){
//        delegate?.didMeClickLikeList()
        let originInRootView = aHLightSection.convert(c.frame.origin, to: self)
        let pointX1 = originInRootView.x + pointX
        let pointY1 = originInRootView.y + pointY
        delegate?.didMeClickLikeList(id: id, pointX: pointX1, pointY: pointY1)
        
        var i = 0
        for cell in aHLightViewArray {
            if(cell == c) {
                print("mecell hidden \(i)")
                hideCellIndex = i
                break
            }
            i += 1
        }
    }
    func didMeCellClickBookmark(id: String, pointX: CGFloat, pointY: CGFloat, c: MeCell){
        let originInRootView = aHLightSection.convert(c.frame.origin, to: self)
        let pointX1 = originInRootView.x + pointX
        let pointY1 = originInRootView.y + pointY
        delegate?.didMeClickBookmarkList(id: id, pointX: pointX1, pointY: pointY1)
        
        var i = 0
        for cell in aHLightViewArray {
            if(cell == c) {
                print("mecell hidden \(i)")
                hideCellIndex = i
                break
            }
            i += 1
        }
    }
    func didMeCellClickLocations(id: String, pointX: CGFloat, pointY: CGFloat, c: MeCell){
//        delegate?.didMeClickMultiLocationList()
        let originInRootView = aHLightSection.convert(c.frame.origin, to: self)
        let pointX1 = originInRootView.x + pointX
        let pointY1 = originInRootView.y + pointY
        delegate?.didMeClickMultiLocationList(id: id, pointX: pointX1, pointY: pointY1)
        
        var i = 0
        for cell in aHLightViewArray {
            if(cell == c) {
                print("mecell hidden \(i)")
                hideCellIndex = i
                break
            }
            i += 1
        }
    }
    func didMeCellClickComments(id: String, pointX: CGFloat, pointY: CGFloat, c: MeCell){
//        delegate?.didMeClickCommentList()
        let originInRootView = aHLightSection.convert(c.frame.origin, to: self)
        let pointX1 = originInRootView.x + pointX
        let pointY1 = originInRootView.y + pointY
        delegate?.didMeClickCommentList(id: id, pointX: pointX1, pointY: pointY1)
        
        var i = 0
        for cell in aHLightViewArray {
            if(cell == c) {
                print("mecell hidden \(i)")
                hideCellIndex = i
                break
            }
            i += 1
        }
    }
    func didMeCellClickPosts(id: String, pointX: CGFloat, pointY: CGFloat, c: MeCell){
//        delegate?.didMeClickMultiPostList()
        let originInRootView = aHLightSection.convert(c.frame.origin, to: self)
        let pointX1 = originInRootView.x + pointX
        let pointY1 = originInRootView.y + pointY
        delegate?.didMeClickMultiPostList(id: id, pointX: pointX1, pointY: pointY1)
        
        var i = 0
        for cell in aHLightViewArray {
            if(cell == c) {
                print("mecell hidden \(i)")
                hideCellIndex = i
                break
            }
            i += 1
        }
    }
    func didMeCellClickPhotos(id: String, pointX: CGFloat, pointY: CGFloat, c: MeCell){
//        delegate?.didMeClickMultiPhotoList()
        let originInRootView = aHLightSection.convert(c.frame.origin, to: self)
        let pointX1 = originInRootView.x + pointX
        let pointY1 = originInRootView.y + pointY
        delegate?.didMeClickMultiPhotoList(id: id, pointX: pointX1, pointY: pointY1)
        
        var i = 0
        for cell in aHLightViewArray {
            if(cell == c) {
                print("mecell hidden \(i)")
                hideCellIndex = i
                break
            }
            i += 1
        }
    }
    func didMeCellClickVideos(id: String, pointX: CGFloat, pointY: CGFloat, c: MeCell){
//        delegate?.didMeClickMultiVideoList()
        let originInRootView = aHLightSection.convert(c.frame.origin, to: self)
        let pointX1 = originInRootView.x + pointX
        let pointY1 = originInRootView.y + pointY
        delegate?.didMeClickMultiVideoList(id: id, pointX: pointX1, pointY: pointY1)
        
        var i = 0
        for cell in aHLightViewArray {
            if(cell == c) {
                print("mecell hidden \(i)")
                hideCellIndex = i
                break
            }
            i += 1
        }
    }
    func didMeCellClickUser(id: String) {
        delegate?.didMeClickUser(id: id)
    }
}

extension ViewController: MePanelDelegate{

    func didMeClickUser(id: String) {
//        openUserPanel()
        //test > real id for fetching data
        openUserPanel(id: id)
    }
    func didMeClickEditProfile(id: String){
//        openMeListPanel(l: "ep")
        openUserCreatorPanel(id: id)
    }
    func didMeClickFollowList(id: String, pointX: CGFloat, pointY: CGFloat){
//        openMeListPanel(l: "fr")
        
        //test > new method
        let offsetX = pointX - self.view.frame.width/2
        let offsetY = pointY - self.view.frame.height/2
        openMeListPanel(l: "fr", id: id, offX: offsetX, offY: offsetY)
    }
    func didMeClickHistoryList(id: String, pointX: CGFloat, pointY: CGFloat){
//        openMeListPanel(l: "h")
        
        //test > new method
        let offsetX = pointX - self.view.frame.width/2
        let offsetY = pointY - self.view.frame.height/2
        openMeListPanel(l: "h", id: id, offX: offsetX, offY: offsetY)
    }
    func didMeClickBookmarkList(id: String, pointX: CGFloat, pointY: CGFloat){
//        openMeListPanel(l: "s")
        
        //test > new method
        let offsetX = pointX - self.view.frame.width/2
        let offsetY = pointY - self.view.frame.height/2
        openMeListPanel(l: "s", id: id, offX: offsetX, offY: offsetY)
    }
    func didMeClickLikeList(id: String, pointX: CGFloat, pointY: CGFloat){
//        openMeListPanel(l: "l")
        
        //test > new method
        let offsetX = pointX - self.view.frame.width/2
        let offsetY = pointY - self.view.frame.height/2
        openMeListPanel(l: "l", id: id, offX: offsetX, offY: offsetY)
    }
    func didMeClickAccountSettingList(){
        //real identity verification
    }
    func didMeClickBaseList(){
        
    }
    func didMeClickMultiLocationList(id: String, pointX: CGFloat, pointY: CGFloat){
//        openMeListPanel(l: "lo")
        //test > new method
        let offsetX = pointX - self.view.frame.width/2
        let offsetY = pointY - self.view.frame.height/2
        openMeListPanel(l: "lo", id: id, offX: offsetX, offY: offsetY)
    }
    func didMeClickMultiPostList(id: String, pointX: CGFloat, pointY: CGFloat){
//        openMeListPanel(l: "c")
        //test > new method
        let offsetX = pointX - self.view.frame.width/2
        let offsetY = pointY - self.view.frame.height/2
        openMeListPanel(l: "c", id: id, offX: offsetX, offY: offsetY)
    }
    func didMeClickMultiPhotoList(id: String, pointX: CGFloat, pointY: CGFloat){
//        openMeListPanel(l: "a")
        //test > new method
        let offsetX = pointX - self.view.frame.width/2
        let offsetY = pointY - self.view.frame.height/2
        openMeListPanel(l: "a", id: id, offX: offsetX, offY: offsetY)
    }
    func didMeClickMultiVideoList(id: String, pointX: CGFloat, pointY: CGFloat){
//        openMeListPanel(l: "b")
        //test > new method
        let offsetX = pointX - self.view.frame.width/2
        let offsetY = pointY - self.view.frame.height/2
        openMeListPanel(l: "b", id: id, offX: offsetX, offY: offsetY)
    }
    func didMeClickCommentList(id: String, pointX: CGFloat, pointY: CGFloat){
        
    }
    func didMeClickLogin() {
        openLoginPanel()
    }
    //test > signout progress view
    func didMeStartSignout() {
        openSignoutProgressPanel()
    }
    func didMeSignoutSuccess() {
        signoutProgressPanel?.closePanel(isAnimated: true)
    }
    func didMeSignoutFail() {
        signoutProgressPanel?.closePanel(isAnimated: true)
    }
}
