//
//  SoundScrollablePanelView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage
import GoogleMaps
import AVFoundation

protocol SoundScrollablePanelDelegate : AnyObject {
    func didClickCloseSoundScrollablePanel()

    func didClickVcvSoundScrollablePanelItem(pointX: CGFloat, pointY: CGFloat, view: UIView)

    //test > map padding
    func didChangeMapPaddingSoundScrollable(y: CGFloat)
    func didStartMapChangeSoundScrollable()
    func didFinishMapChangeSoundScrollable()
    
    //test > connect to other panel
    func didSClickUserSoundScrollable()
    func didSClickPlaceSoundScrollable()
    func didSClickSoundSoundScrollable()
    func didSClickSoundScrollableVcvClickPost()
    func didSClickSoundScrollableVcvClickPhoto(pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String)
    func didSClickSoundScrollableVcvClickVideo(pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String)
    func didSClickSoundSignIn()
    
    //test > initialize
    func didFinishInitializeSoundScrollablePanel(pv: ScrollablePanelView)
    func didStartFetchSoundScrollableData(pv: ScrollablePanelView)
    func didFinishFetchSoundScrollableData(pv: ScrollablePanelView, isSuccess: Bool)
}

class SoundScrollablePanelView: ScrollablePanelView{
    
    var panelView = UIView()
    let aNameText = UILabel()
    let aPanelView = UIView()
    let aPhoto = SDAnimatedImageView()
    let aGrid = UIView()
    let bGrid = UIView()
    let cGrid = UIView()
    let dGrid = UIView()
    let pillBtn = UIView()

    let aNameTextB = UILabel()
    let aPhotoB = SDAnimatedImageView()
    let bMiniBtn = UIImageView()
    let cBtn = UIView()
    let aNameTextC = UILabel()
    
    let aUsernameAText = UILabel()
    let playBtn = UIImageView()
    let pauseBtn = UIImageView()
    let aHLightTitle = UILabel()
    let aFollowA = UIView()
    let aFollowAText = UILabel()
    let aFollow = UIView()
    let aFollowText = UILabel()
    let aFollowC = UIView()
    let aFollowCText = UILabel()

    var aPhotoHeightCons: NSLayoutConstraint?
    var aPhotoWidthCons: NSLayoutConstraint?
    var aNameTextTopCons: NSLayoutConstraint?
    var aPanelViewHeightCons: NSLayoutConstraint?

    weak var delegate : SoundScrollablePanelDelegate?

    var currentPanelMode = ""

    var vDataList = [String]()

    let aStickyHeader = UIView()

    //test > new
    var panelTopCons: NSLayoutConstraint?
    var currentPanelTopCons : CGFloat = 0.0
    let PANEL_MODE_HALF: String = "half"
    let PANEL_MODE_EMPTY: String = "empty"
    let PANEL_MODE_FULL: String = "full"
//    var scrollablePanelHeight : CGFloat = 400.0 //default: 300 in iphone 6s, 400 in iphone 11
//    var halfModeMapPadding : CGFloat = 200.0 //260, default: 210 in iphone 6s, 310 in iphone 11
    var halfModePanelHeight : CGFloat = 0.0
    var halfModeMapPadding : CGFloat = 0.0
    var aPanelViewTopMargin = 20.0
    var aPanelViewHalfModeHeight = 0.0
    var aPhotoBHeight = 0.0

    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0

    var currentMapPaddingBottom: CGFloat = 0

    //test > id for fetch/refresh data, i.e. place id
    var objectId = ""

    let aSpinner = SpinLoader()
    let bSpinner = SpinLoader()
    
    //test > tabs in user panel
    var tabList = [TabStack]()
    let tabSelect = UIView()
    var tabSelectLeadingCons: NSLayoutConstraint?
    var tabSelectWidthCons: NSLayoutConstraint?
    var stackviewUsableLength = 0.0
    let tabScrollView = UIScrollView()
    let stackView = UIView()
    let tabScrollMargin = 20.0
    
    var currentTabSelectLeadingCons = 0.0
    var tempCurrentIndex = 0

    //test > measure B section height
    var bPanelView = UIView()
    
    var cNameTextCenterYCons: NSLayoutConstraint?
    
    //test > half mode highlight box section
    let aHLightBox = UIView()
    var aHLightBoxArray = [String]()
    var aHLightBoxViewArray = [UIView]()
    
    //test > dynamic highlight section
    let aHLightSection = UIView()
    var aHLightDataArray = [String]()
    var aHLightViewArray = [UIView]()
    
    let feedScrollView = UIScrollView()
    var feedList = [ScrollDataFeedCell]()
    var currentIndex = 0
    
    let tabScrollLHSBtn = UIView()
    let tabScrollRHSBtn = UIView()
    
    //test > uicollectionview
    let scrollView = SGestureScrollView()
    let vStackView = UIView()
    
    var enableChildViewScroll = false
    var enableFatherViewScroll = true
    
    let objectSymbol = UIImageView()
    let aSubDesc = UILabel()
    
    let audioContainer = UIView()
    var player2: AVPlayer!
    
    //test page transition => track user journey in creating short video
    var pageList = [PanelView]()
    
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
        
    }
    
    @objc func onStickyHeaderClicked(gesture: UITapGestureRecognizer) {
        print("sticky header clicked")
    }

    //test > initialization state
    var isInitialized = false
    func initialize() {
        //set initial size for panel
        setInitialCondition()
        
        //init panel animation
        UIView.animate(withDuration: 0.2, animations: {
            self.panelTopCons?.constant = -self.halfModePanelHeight

            self.changeSoundPanelMode(panelMode: self.PANEL_MODE_HALF) //test

        }, completion: { _ in
            print("place panel init complete")

            //test > initialize and inform VC
//            self.delegate?.didFinishInitializePlaceScrollablePanel(pv: self)
        })
        
        if(!isInitialized) {
            //test xxx - lay out remaining b section panel
            redrawUI()
            
            layoutTabUI()
            
            //UI before fetch data
            self.delegate?.didStartFetchSoundScrollableData(pv: self)
            
            //start fetch data
            asyncFetchSoundProfile(id: getObjectId())
        }
        
        isInitialized = true
    }
    
    func setInitialCondition() {
        //set initial condiditons
        halfModePanelHeight = 400.0
        halfModeMapPadding = halfModePanelHeight/2
        aPanelViewHalfModeHeight = halfModePanelHeight - aPanelViewTopMargin
        aPhotoBHeight = 100.0
    }
    func redrawUI() {
        
        panelView.backgroundColor = .ddmBlackOverlayColor
        self.addSubview(panelView)
        panelView.translatesAutoresizingMaskIntoConstraints = false
        panelView.layer.masksToBounds = true
        panelView.layer.cornerRadius = 10 //10
        //test
        panelView.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        panelView.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true

//        let pillBtn = UIView()
        pillBtn.backgroundColor = .ddmDarkColor
        panelView.addSubview(pillBtn)
        pillBtn.translatesAutoresizingMaskIntoConstraints = false
        pillBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
        pillBtn.heightAnchor.constraint(equalToConstant: 6).isActive = true
        pillBtn.centerXAnchor.constraint(equalTo: panelView.centerXAnchor).isActive = true
        pillBtn.topAnchor.constraint(equalTo: panelView.topAnchor, constant: 10).isActive = true
        pillBtn.layer.cornerRadius = 3

        //test > half page UI
//        let aPanelView = UIView()
        panelView.addSubview(aPanelView)
//        aPanelView.backgroundColor = .red
        aPanelView.translatesAutoresizingMaskIntoConstraints = false
        aPanelView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        aPanelView.topAnchor.constraint(equalTo: panelView.topAnchor, constant: aPanelViewTopMargin).isActive = true
        aPanelView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        aPanelViewHeightCons = aPanelView.heightAnchor.constraint(equalToConstant: aPanelViewHalfModeHeight) //default: 380
        aPanelViewHeightCons?.isActive = true
        aPanelView.layer.masksToBounds = true

        //test 1 => APanel old way
////        let aNameText = UILabel()
//        aNameText.textAlignment = .left
//        aNameText.textColor = .white
//        aNameText.font = .boldSystemFont(ofSize: 16)
//        aPanelView.addSubview(aNameText)
//        aNameText.translatesAutoresizingMaskIntoConstraints = false
//        aNameTextTopCons = aNameText.topAnchor.constraint(equalTo: aPanelView.topAnchor, constant: 10)
//        aNameTextTopCons?.isActive = true
//        aNameText.leadingAnchor.constraint(equalTo: aPanelView.leadingAnchor, constant: 20).isActive = true
////        aNameText.text = "Canary Wharf"
//        aNameText.text = "Sound"
//
//        //test > spin loader when fetching data
//        let aSpinner = SpinLoader()
        aPanelView.addSubview(aSpinner)
        aSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        aSpinner.translatesAutoresizingMaskIntoConstraints = false
        aSpinner.topAnchor.constraint(equalTo: aPanelView.topAnchor, constant: CGFloat(10)).isActive = true
        aSpinner.centerXAnchor.constraint(equalTo: aPanelView.centerXAnchor).isActive = true
        aSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        aSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        aSpinner.startAnimating()
   
        //test 2 > APanel redesign
        let photoWidth = 100.0 //same as photo
        let photoHeight = 100.0
        aPanelView.addSubview(audioContainer)
        audioContainer.translatesAutoresizingMaskIntoConstraints = false
        audioContainer.topAnchor.constraint(equalTo: aPanelView.topAnchor, constant: 10).isActive = true
        audioContainer.widthAnchor.constraint(equalToConstant: photoWidth).isActive = true
        audioContainer.heightAnchor.constraint(equalToConstant: photoHeight).isActive = true
        audioContainer.leadingAnchor.constraint(equalTo: aPanelView.leadingAnchor, constant: 20).isActive = true
        audioContainer.clipsToBounds = true
        audioContainer.layer.cornerRadius = 10
        audioContainer.backgroundColor = .black
        
        aPanelView.addSubview(aPhoto)
        aPhoto.translatesAutoresizingMaskIntoConstraints = false
        aPhoto.widthAnchor.constraint(equalToConstant: 100).isActive = true //aPhotoBHeight=100, 80
        aPhoto.heightAnchor.constraint(equalToConstant: 100).isActive = true
        aPhoto.leadingAnchor.constraint(equalTo: aPanelView.leadingAnchor, constant: 20).isActive = true
        aPhoto.topAnchor.constraint(equalTo: aPanelView.topAnchor, constant: 10).isActive = true
//        let aImageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        aPhoto.contentMode = .scaleAspectFill
        aPhoto.layer.masksToBounds = true
        aPhoto.layer.cornerRadius = 10
//        aPhoto.sd_setImage(with: aImageUrl)
        aPhoto.backgroundColor = .ddmDarkColor
        
//        let aNameText = UILabel()
        aNameText.textAlignment = .left
        aNameText.textColor = .white
        aNameText.font = .boldSystemFont(ofSize: 16)
        aPanelView.addSubview(aNameText)
        aNameText.translatesAutoresizingMaskIntoConstraints = false
//        aNameText.topAnchor.constraint(equalTo: aPhoto.bottomAnchor, constant: 10).isActive = true
//        aNameText.leadingAnchor.constraint(equalTo: aPanelView.leadingAnchor, constant: 20).isActive = true
        aNameText.leadingAnchor.constraint(equalTo: aPhoto.trailingAnchor, constant: 10).isActive = true
        aNameText.trailingAnchor.constraint(equalTo: aPanelView.trailingAnchor, constant: -20).isActive = true
        aNameText.centerYAnchor.constraint(equalTo: aPhoto.centerYAnchor, constant: -15).isActive = true //0
//        aNameText.numberOfLines = 0
//        aNameText.text = "明知故犯" //明知故犯 - Hubert Wu
        aNameText.text = ""
        
//        let aUsernameAText = UILabel()
        aUsernameAText.textAlignment = .left
        aUsernameAText.textColor = .ddmDarkGrayColor
        aUsernameAText.font = .boldSystemFont(ofSize: 13)
        aPanelView.addSubview(aUsernameAText)
        aUsernameAText.translatesAutoresizingMaskIntoConstraints = false
        aUsernameAText.topAnchor.constraint(equalTo: aNameText.bottomAnchor, constant: 2).isActive = true //2
        aUsernameAText.leadingAnchor.constraint(equalTo: aNameText.leadingAnchor, constant: 0).isActive = true
//        aUsernameAText.text = "Hubert Wu"
        aUsernameAText.text = ""
//        aUsernameAText.text = "1.5M followers"
        
//        let playBtn = UIImageView(image: UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate))
        playBtn.image = UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate)
        playBtn.tintColor = .white
        aPanelView.addSubview(playBtn)
        playBtn.translatesAutoresizingMaskIntoConstraints = false
        playBtn.topAnchor.constraint(equalTo: aUsernameAText.bottomAnchor, constant: 8).isActive = true
        playBtn.leadingAnchor.constraint(equalTo: aUsernameAText.leadingAnchor, constant: -5).isActive = true //0
        playBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true //20
        playBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
        playBtn.isHidden = true
        playBtn.isUserInteractionEnabled = true
        playBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onResumeAudioClicked)))
        
        pauseBtn.image = UIImage(named:"icon_round_pause")?.withRenderingMode(.alwaysTemplate)
        pauseBtn.tintColor = .white
        aPanelView.addSubview(pauseBtn)
        pauseBtn.translatesAutoresizingMaskIntoConstraints = false
        pauseBtn.topAnchor.constraint(equalTo: aUsernameAText.bottomAnchor, constant: 8).isActive = true
        pauseBtn.leadingAnchor.constraint(equalTo: aUsernameAText.leadingAnchor, constant: -5).isActive = true //0
        pauseBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true //20
        pauseBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
        pauseBtn.isUserInteractionEnabled = true
        pauseBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPauseAudioClicked)))
        pauseBtn.isHidden = true
        
//        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 12)
        aPanelView.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.centerYAnchor.constraint(equalTo: playBtn.centerYAnchor, constant: 0).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: playBtn.trailingAnchor, constant: 5).isActive = true
//        aHLightTitle.text = "00:29"
        aHLightTitle.text = ""
        
//        let aFollowA = UIView()
        aFollowA.backgroundColor = .yellow
        aPanelView.addSubview(aFollowA)
        aFollowA.translatesAutoresizingMaskIntoConstraints = false
        aFollowA.trailingAnchor.constraint(equalTo: aPanelView.trailingAnchor, constant: -20).isActive = true
        aFollowA.heightAnchor.constraint(equalToConstant: 30).isActive = true //30
//        aFollowA.centerYAnchor.constraint(equalTo: aFollowerCountAText.centerYAnchor, constant: 0).isActive = true
        aFollowA.centerYAnchor.constraint(equalTo: aHLightTitle.centerYAnchor, constant: 0).isActive = true
        aFollowA.layer.cornerRadius = 10
        aFollowA.isUserInteractionEnabled = true
        aFollowA.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onFollowClicked)))
        aFollowA.isHidden = true
        
//        let aFollowAText = UILabel()
        aFollowAText.textAlignment = .center
        aFollowAText.textColor = .black
        aFollowAText.font = .boldSystemFont(ofSize: 13) //default 14
//        aPanelView.addSubview(aFollowAText)
        aFollowA.addSubview(aFollowAText)
        aFollowAText.translatesAutoresizingMaskIntoConstraints = false
        aFollowAText.leadingAnchor.constraint(equalTo: aFollowA.leadingAnchor, constant: 15).isActive = true //20
        aFollowAText.trailingAnchor.constraint(equalTo: aFollowA.trailingAnchor, constant: -15).isActive = true
        aFollowAText.centerYAnchor.constraint(equalTo: aFollowA.centerYAnchor).isActive = true
        aFollowAText.text = "Save"
        
        //*test => highlight box section
        aPanelView.addSubview(aHLightBox)
//        aHLightBox.backgroundColor = .green
        aHLightBox.translatesAutoresizingMaskIntoConstraints = false
        aHLightBox.topAnchor.constraint(equalTo: aPhoto.bottomAnchor, constant: 10).isActive = true
        aHLightBox.leadingAnchor.constraint(equalTo: aPanelView.leadingAnchor, constant: 0).isActive = true
        aHLightBox.trailingAnchor.constraint(equalTo: aPanelView.trailingAnchor, constant: 0).isActive = true
//        aHLightBox.bottomAnchor.constraint(equalTo: aPanelView.bottomAnchor, constant: 0).isActive = true
        
        //test > gesture recognizer for dragging place panel
        let bPanelPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onPanelPanGesture))
//        self.addGestureRecognizer(bPanelPanGesture)
        aPanelView.addGestureRecognizer(bPanelPanGesture)
        
        //get safe area top margin
        let topSafeAreaHeight = safeAreaInsets.top
        let stickyHeaderHeight = 50.0
        
        let tabScrollViewHeight = 40.0
        let vCvTopMargin = topSafeAreaHeight + stickyHeaderHeight + tabScrollViewHeight

        //test > add scrollview
        panelView.addSubview(scrollView)
        scrollView.backgroundColor = .clear
//        scrollView.backgroundColor = .blue
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: aPanelView.bottomAnchor, constant: topSafeAreaHeight - aPanelViewTopMargin).isActive = true //50
        scrollView.leadingAnchor.constraint(equalTo: panelView.leadingAnchor, constant: 0).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: panelView.trailingAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: panelView.bottomAnchor, constant: 0).isActive = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = true
        scrollView.centerXAnchor.constraint(equalTo: panelView.centerXAnchor).isActive = true

        vStackView.backgroundColor = .clear
        scrollView.addSubview(vStackView)
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        vStackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        vStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        vStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
        vStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0).isActive = true
        
        //test xxx
        vStackView.addSubview(bPanelView)
//        bPanelView.backgroundColor = .red
        bPanelView.translatesAutoresizingMaskIntoConstraints = false
        bPanelView.trailingAnchor.constraint(equalTo: vStackView.trailingAnchor).isActive = true
        bPanelView.leadingAnchor.constraint(equalTo: vStackView.leadingAnchor, constant: 0).isActive = true
        bPanelView.topAnchor.constraint(equalTo: vStackView.topAnchor, constant: stickyHeaderHeight).isActive = true //0
        bPanelView.layer.masksToBounds = true
        
//        let aPhotoB = SDAnimatedImageView()
        bPanelView.addSubview(aPhotoB)
        aPhotoB.translatesAutoresizingMaskIntoConstraints = false
        aPhotoWidthCons = aPhotoB.widthAnchor.constraint(equalToConstant: 0)
        aPhotoWidthCons?.isActive = true
        aPhotoHeightCons = aPhotoB.heightAnchor.constraint(equalToConstant: 0)
        aPhotoHeightCons?.isActive = true
        aPhotoB.leadingAnchor.constraint(equalTo: bPanelView.leadingAnchor, constant: 20).isActive = true
        aPhotoB.topAnchor.constraint(equalTo: bPanelView.topAnchor, constant: 0).isActive = true
//        let bImageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        aPhotoB.contentMode = .scaleAspectFill
        aPhotoB.layer.masksToBounds = true
        aPhotoB.layer.cornerRadius = 10
//        aPhotoB.sd_setImage(with: bImageUrl)
        aPhotoB.backgroundColor = .ddmDarkColor

//        let aNameTextB = UILabel()
        aNameTextB.textAlignment = .left
        aNameTextB.textColor = .white
        aNameTextB.font = .boldSystemFont(ofSize: 16)
        bPanelView.addSubview(aNameTextB)
        aNameTextB.translatesAutoresizingMaskIntoConstraints = false
        aNameTextB.topAnchor.constraint(equalTo: aPhotoB.topAnchor, constant: 10).isActive = true
//        aNameTextB.topAnchor.constraint(equalTo: aObjectGridBG.topAnchor, constant: 5).isActive = true
        aNameTextB.leadingAnchor.constraint(equalTo: aPhotoB.trailingAnchor, constant: 10).isActive = true
//        aNameTextB.leadingAnchor.constraint(equalTo: aObjectGridBG.trailingAnchor, constant: 10).isActive = true
//        aNameTextB.text = "Canary Wharf"
        aNameTextB.text = ""
        
        objectSymbol.image = UIImage(named:"icon_round_music")?.withRenderingMode(.alwaysTemplate)
        objectSymbol.tintColor = .white
        bPanelView.addSubview(objectSymbol)
        objectSymbol.translatesAutoresizingMaskIntoConstraints = false
        objectSymbol.topAnchor.constraint(equalTo: aNameTextB.bottomAnchor, constant: 10).isActive = true
        objectSymbol.leadingAnchor.constraint(equalTo: aPhotoB.trailingAnchor, constant: 10).isActive = true
        objectSymbol.heightAnchor.constraint(equalToConstant: 14).isActive = true //18
        objectSymbol.widthAnchor.constraint(equalToConstant: 14).isActive = true
        objectSymbol.layer.opacity = 0.4
        objectSymbol.isHidden = true

//        let aSubDesc = UILabel()
        aSubDesc.textAlignment = .left
        aSubDesc.textColor = .white
        aSubDesc.font = .systemFont(ofSize: 11)
        bPanelView.addSubview(aSubDesc)
        aSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aSubDesc.centerYAnchor.constraint(equalTo: objectSymbol.centerYAnchor).isActive = true
        aSubDesc.leadingAnchor.constraint(equalTo: objectSymbol.trailingAnchor, constant: 5).isActive = true
        aSubDesc.text = ""//00:29
        aSubDesc.layer.opacity = 0.4

//        let aFollow = UIView()
        aFollow.backgroundColor = .yellow
        bPanelView.addSubview(aFollow)
        aFollow.translatesAutoresizingMaskIntoConstraints = false
//        aFollow.leadingAnchor.constraint(equalTo: aNameText.leadingAnchor).isActive = true
        aFollow.leadingAnchor.constraint(equalTo: bPanelView.leadingAnchor, constant: 20).isActive = true
        aFollow.trailingAnchor.constraint(equalTo: bPanelView.trailingAnchor, constant: -20).isActive = true
        aFollow.heightAnchor.constraint(equalToConstant: 30).isActive = true //30
        aFollow.topAnchor.constraint(equalTo: aPhotoB.bottomAnchor, constant: 15).isActive = true
//        aFollow.bottomAnchor.constraint(equalTo: bPanelView.bottomAnchor, constant: -20).isActive = true
        aFollow.layer.cornerRadius = 10
        aFollow.isUserInteractionEnabled = true
        aFollow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onFollowClicked)))
        aFollow.isHidden = true
        
//        let aFollowText = UILabel()
        aFollowText.textAlignment = .center
        aFollowText.textColor = .black
        aFollowText.font = .boldSystemFont(ofSize: 13) //default 14
        aFollow.addSubview(aFollowText)
        aFollowText.translatesAutoresizingMaskIntoConstraints = false
        aFollowText.centerXAnchor.constraint(equalTo: aFollow.centerXAnchor).isActive = true
        aFollowText.centerYAnchor.constraint(equalTo: aFollow.centerYAnchor).isActive = true
        aFollowText.text = "Save"
        
        bPanelView.addSubview(aHLightSection)
//        aHLightSection.backgroundColor = .green
        aHLightSection.translatesAutoresizingMaskIntoConstraints = false
        aHLightSection.topAnchor.constraint(equalTo: aFollow.bottomAnchor, constant: 20).isActive = true
        aHLightSection.leadingAnchor.constraint(equalTo: bPanelView.leadingAnchor, constant: 0).isActive = true
        aHLightSection.trailingAnchor.constraint(equalTo: bPanelView.trailingAnchor, constant: 0).isActive = true
        aHLightSection.bottomAnchor.constraint(equalTo: bPanelView.bottomAnchor, constant: -10).isActive = true
        
        //test > spin loader for Bwhen fetching data
//        let bSpinner = SpinLoader()
        bPanelView.addSubview(bSpinner)
        bSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        bSpinner.translatesAutoresizingMaskIntoConstraints = false
        bSpinner.centerYAnchor.constraint(equalTo: aPhotoB.centerYAnchor, constant: CGFloat(0)).isActive = true
        bSpinner.centerXAnchor.constraint(equalTo: bPanelView.centerXAnchor).isActive = true
        bSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        bSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        bSpinner.startAnimating()

        //test > tabs for navigating posts and videos
//        vDataList.append("v") //video
//        vDataList.append("p") //post
//        vDataList.append("s") //shots/photos
//        vDataList.append("p") //post
        vDataList.append("p") //posts
        vDataList.append("v") //videos
//        vDataList.append("p")
//        vDataList.append("v")

        //test ** > uiscrollview
//        let tabScrollView = UIScrollView()
        vStackView.addSubview(tabScrollView)
//        tabScrollView.backgroundColor = .blue
        tabScrollView.backgroundColor = .clear
        tabScrollView.translatesAutoresizingMaskIntoConstraints = false
        tabScrollView.heightAnchor.constraint(equalToConstant: tabScrollViewHeight).isActive = true //ori 60
//        tabScrollView.topAnchor.constraint(equalTo: aHLightRect2.bottomAnchor, constant: 20).isActive = true
//        tabScrollView.topAnchor.constraint(equalTo: aFollow.bottomAnchor, constant: 20).isActive = true
        tabScrollView.topAnchor.constraint(equalTo: bPanelView.bottomAnchor, constant: 0).isActive = true //20
        tabScrollView.leadingAnchor.constraint(equalTo: vStackView.leadingAnchor, constant: tabScrollMargin).isActive = true
        tabScrollView.trailingAnchor.constraint(equalTo: vStackView.trailingAnchor, constant: -tabScrollMargin).isActive = true
        tabScrollView.showsHorizontalScrollIndicator = false
        tabScrollView.alwaysBounceHorizontal = true //test
        tabScrollView.delegate = self
        //**
        
        stackView.backgroundColor = .clear //clear
        tabScrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.heightAnchor.constraint(equalToConstant: 40).isActive = true //ori 30
        stackView.topAnchor.constraint(equalTo: tabScrollView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: tabScrollView.leadingAnchor, constant: 0).isActive = true //10
        
        tabSelect.backgroundColor = .clear
        stackView.addSubview(tabSelect)
        tabSelect.translatesAutoresizingMaskIntoConstraints = false
        tabSelectLeadingCons = tabSelect.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0)
        tabSelectLeadingCons?.isActive = true
        tabSelect.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
        tabSelect.heightAnchor.constraint(equalToConstant: 2).isActive = true //ori 60
//        tabSelect.widthAnchor.constraint(equalToConstant: hWidth).isActive = true
        tabSelectWidthCons = tabSelect.widthAnchor.constraint(equalToConstant: 0)
        tabSelectWidthCons?.isActive = true
//        aHighlight.widthAnchor.constraint(equalToConstant: 30).isActive = true
        tabSelect.isHidden = true
        
        let aHighlightInner = UIView()
        aHighlightInner.backgroundColor = .yellow
        tabSelect.addSubview(aHighlightInner)
        aHighlightInner.translatesAutoresizingMaskIntoConstraints = false
        aHighlightInner.heightAnchor.constraint(equalToConstant: 2).isActive = true //ori 60
//        aHighlightInner.widthAnchor.constraint(equalToConstant: 30).isActive = true
        aHighlightInner.centerYAnchor.constraint(equalTo: tabSelect.centerYAnchor).isActive = true
//        aHighlightInner.centerXAnchor.constraint(equalTo: tabSelect.centerXAnchor).isActive = true
        aHighlightInner.leadingAnchor.constraint(equalTo: tabSelect.leadingAnchor, constant: 0).isActive = true
        aHighlightInner.trailingAnchor.constraint(equalTo: tabSelect.trailingAnchor, constant: 0).isActive = true
        
//        let tabScrollLHSBtn = UIView()
        tabScrollLHSBtn.backgroundColor = .ddmBlackOverlayColor
//        tabScrollLHSBtn.backgroundColor = .red
        vStackView.addSubview(tabScrollLHSBtn)
        tabScrollLHSBtn.translatesAutoresizingMaskIntoConstraints = false
        tabScrollLHSBtn.widthAnchor.constraint(equalToConstant: 18).isActive = true //ori: 40
        tabScrollLHSBtn.heightAnchor.constraint(equalToConstant: 18).isActive = true
        tabScrollLHSBtn.trailingAnchor.constraint(equalTo: tabScrollView.leadingAnchor, constant: 9).isActive = true
        tabScrollLHSBtn.centerYAnchor.constraint(equalTo: tabScrollView.centerYAnchor, constant: 0).isActive = true
        tabScrollLHSBtn.isUserInteractionEnabled = true
        tabScrollLHSBtn.layer.cornerRadius = 9
        tabScrollLHSBtn.isHidden = true
        
        let tabScrollLHSBg = UIView()
        tabScrollLHSBg.backgroundColor = .white
        tabScrollLHSBtn.addSubview(tabScrollLHSBg)
        tabScrollLHSBg.translatesAutoresizingMaskIntoConstraints = false
        tabScrollLHSBg.widthAnchor.constraint(equalToConstant: 14).isActive = true //ori: 40
        tabScrollLHSBg.heightAnchor.constraint(equalToConstant: 14).isActive = true
        tabScrollLHSBg.centerXAnchor.constraint(equalTo: tabScrollLHSBtn.centerXAnchor, constant: 0).isActive = true
        tabScrollLHSBg.centerYAnchor.constraint(equalTo: tabScrollLHSBtn.centerYAnchor, constant: 0).isActive = true
        tabScrollLHSBg.layer.cornerRadius = 7
        tabScrollLHSBg.layer.opacity = 0.5
        
        let tabScrollLHSBoxBtn = UIImageView()
        tabScrollLHSBoxBtn.image = UIImage(named:"icon_round_arrow_left")?.withRenderingMode(.alwaysTemplate)
        tabScrollLHSBoxBtn.tintColor = .ddmBlackOverlayColor
        tabScrollLHSBg.addSubview(tabScrollLHSBoxBtn)
        tabScrollLHSBoxBtn.translatesAutoresizingMaskIntoConstraints = false
        tabScrollLHSBoxBtn.centerXAnchor.constraint(equalTo: tabScrollLHSBg.centerXAnchor).isActive = true
        tabScrollLHSBoxBtn.centerYAnchor.constraint(equalTo: tabScrollLHSBg.centerYAnchor).isActive = true
        tabScrollLHSBoxBtn.heightAnchor.constraint(equalToConstant: 14).isActive = true
        tabScrollLHSBoxBtn.widthAnchor.constraint(equalToConstant: 14).isActive = true
        
//        let tabScrollRHSBtn = UIView()
        tabScrollRHSBtn.backgroundColor = .ddmBlackOverlayColor
//        tabScrollRHSBtn.backgroundColor = .red
        vStackView.addSubview(tabScrollRHSBtn)
        tabScrollRHSBtn.translatesAutoresizingMaskIntoConstraints = false
        tabScrollRHSBtn.widthAnchor.constraint(equalToConstant: 18).isActive = true //ori: 40
        tabScrollRHSBtn.heightAnchor.constraint(equalToConstant: 18).isActive = true
        tabScrollRHSBtn.leadingAnchor.constraint(equalTo: tabScrollView.trailingAnchor, constant: -9).isActive = true
        tabScrollRHSBtn.centerYAnchor.constraint(equalTo: tabScrollView.centerYAnchor, constant: 0).isActive = true
        tabScrollRHSBtn.isUserInteractionEnabled = true
        tabScrollRHSBtn.layer.cornerRadius = 9
        tabScrollRHSBtn.isHidden = true
        
        let tabScrollRHSBg = UIView()
        tabScrollRHSBg.backgroundColor = .white
        tabScrollRHSBtn.addSubview(tabScrollRHSBg)
        tabScrollRHSBg.translatesAutoresizingMaskIntoConstraints = false
        tabScrollRHSBg.widthAnchor.constraint(equalToConstant: 14).isActive = true //ori: 40
        tabScrollRHSBg.heightAnchor.constraint(equalToConstant: 14).isActive = true
        tabScrollRHSBg.centerXAnchor.constraint(equalTo: tabScrollRHSBtn.centerXAnchor, constant: 0).isActive = true
        tabScrollRHSBg.centerYAnchor.constraint(equalTo: tabScrollRHSBtn.centerYAnchor, constant: 0).isActive = true
        tabScrollRHSBg.layer.cornerRadius = 7
        tabScrollRHSBg.layer.opacity = 0.5
        
        let tabScrollRHSBoxBtn = UIImageView()
        tabScrollRHSBoxBtn.image = UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate)
        tabScrollRHSBoxBtn.tintColor = .ddmBlackOverlayColor
        tabScrollRHSBg.addSubview(tabScrollRHSBoxBtn)
        tabScrollRHSBoxBtn.translatesAutoresizingMaskIntoConstraints = false
        tabScrollRHSBoxBtn.centerXAnchor.constraint(equalTo: tabScrollRHSBg.centerXAnchor).isActive = true
        tabScrollRHSBoxBtn.centerYAnchor.constraint(equalTo: tabScrollRHSBg.centerYAnchor).isActive = true
        tabScrollRHSBoxBtn.heightAnchor.constraint(equalToConstant: 14).isActive = true
        tabScrollRHSBoxBtn.widthAnchor.constraint(equalToConstant: 14).isActive = true
        //
        
        vStackView.addSubview(feedScrollView)
        feedScrollView.backgroundColor = .clear //clear
        feedScrollView.translatesAutoresizingMaskIntoConstraints = false
        feedScrollView.topAnchor.constraint(equalTo: tabScrollView.bottomAnchor, constant: 0).isActive = true
        let height = self.frame.height - vCvTopMargin
        feedScrollView.heightAnchor.constraint(equalToConstant: height).isActive = true
        feedScrollView.leadingAnchor.constraint(equalTo: vStackView.leadingAnchor, constant: 0).isActive = true
        feedScrollView.trailingAnchor.constraint(equalTo: vStackView.trailingAnchor, constant: 0).isActive = true
        feedScrollView.showsHorizontalScrollIndicator = false
        feedScrollView.alwaysBounceHorizontal = true //test
        feedScrollView.isPagingEnabled = true
        feedScrollView.delegate = self
        feedScrollView.bottomAnchor.constraint(equalTo: vStackView.bottomAnchor, constant: 0).isActive = true

        //test > sticky header
        aStickyHeader.backgroundColor = .ddmBlackOverlayColor
        panelView.addSubview(aStickyHeader)
        aStickyHeader.translatesAutoresizingMaskIntoConstraints = false
        aStickyHeader.trailingAnchor.constraint(equalTo: panelView.trailingAnchor).isActive = true
        aStickyHeader.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: stickyHeaderHeight).isActive = true
        aStickyHeader.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        aStickyHeader.leadingAnchor.constraint(equalTo: panelView.leadingAnchor, constant: 0).isActive = true
        aStickyHeader.isHidden = true
        aStickyHeader.layer.masksToBounds = true
        aStickyHeader.isUserInteractionEnabled = true
        aStickyHeader.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onStickyHeaderClicked)))

        let aBtn = UIView()
//        aBtn.backgroundColor = .ddmDarkColor
        aStickyHeader.addSubview(aBtn)
        aBtn.translatesAutoresizingMaskIntoConstraints = false
        aBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
        aBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        aBtn.leadingAnchor.constraint(equalTo: aStickyHeader.leadingAnchor, constant: 10).isActive = true
    //        aBtn.topAnchor.constraint(equalTo: userPanel.topAnchor, constant: 30).isActive = true
        aBtn.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        aBtn.layer.cornerRadius = 20
        aBtn.layer.opacity = 0.3
        aBtn.isUserInteractionEnabled = true
        aBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCloseClicked)))

        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_arrow_down_a")?.withRenderingMode(.alwaysTemplate))
        bMiniBtn.tintColor = .white
        aStickyHeader.addSubview(bMiniBtn)
        bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        bMiniBtn.centerXAnchor.constraint(equalTo: aBtn.centerXAnchor).isActive = true
        bMiniBtn.centerYAnchor.constraint(equalTo: aBtn.centerYAnchor).isActive = true
        bMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        bMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        
        let stickyHLight = UIView()
//        stickyHLight.backgroundColor = .ddmDarkColor
        aStickyHeader.addSubview(stickyHLight)
        stickyHLight.translatesAutoresizingMaskIntoConstraints = false
        stickyHLight.leadingAnchor.constraint(equalTo: aBtn.trailingAnchor, constant: 10).isActive = true //20
        stickyHLight.trailingAnchor.constraint(equalTo: aStickyHeader.trailingAnchor, constant: -30).isActive = true //20
        stickyHLight.heightAnchor.constraint(equalToConstant: 40).isActive = true //30
        cNameTextCenterYCons = stickyHLight.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 50)
        cNameTextCenterYCons?.isActive = true
        
        //test *object symbol
        let aStickyGridBG = UIView()
        aStickyGridBG.backgroundColor = .ddmDarkColor
        stickyHLight.addSubview(aStickyGridBG)
        aStickyGridBG.translatesAutoresizingMaskIntoConstraints = false
        aStickyGridBG.leadingAnchor.constraint(equalTo: stickyHLight.leadingAnchor, constant: 0).isActive = true
        aStickyGridBG.heightAnchor.constraint(equalToConstant: 30).isActive = true
        aStickyGridBG.widthAnchor.constraint(equalToConstant: 30).isActive = true
        aStickyGridBG.centerYAnchor.constraint(equalTo: stickyHLight.centerYAnchor, constant: 0).isActive = true
        aStickyGridBG.layer.cornerRadius = 5 //20
        aStickyGridBG.layer.opacity = 0.5
        
        let objectSymbolC = UIImageView(image: UIImage(named:"icon_round_music")?.withRenderingMode(.alwaysTemplate))
        objectSymbolC.tintColor = .white
        stickyHLight.addSubview(objectSymbolC)
        objectSymbolC.translatesAutoresizingMaskIntoConstraints = false
        objectSymbolC.centerYAnchor.constraint(equalTo: aStickyGridBG.centerYAnchor, constant: 0).isActive = true
        objectSymbolC.centerXAnchor.constraint(equalTo: aStickyGridBG.centerXAnchor, constant: 0).isActive = true
        objectSymbolC.heightAnchor.constraint(equalToConstant: 16).isActive = true //18
        objectSymbolC.widthAnchor.constraint(equalToConstant: 16).isActive = true
        //*
        
//        let aNameTextC = UILabel()
        aNameTextC.textAlignment = .left
        aNameTextC.textColor = .white
        aNameTextC.font = .boldSystemFont(ofSize: 14)
        stickyHLight.addSubview(aNameTextC)
        aNameTextC.translatesAutoresizingMaskIntoConstraints = false
        aNameTextC.centerYAnchor.constraint(equalTo: stickyHLight.centerYAnchor, constant: 0).isActive = true
        aNameTextC.leadingAnchor.constraint(equalTo: aStickyGridBG.trailingAnchor, constant: 10).isActive = true
        aNameTextC.text = ""
//        aNameTextC.text = ""
        
//        let aFollowC = UIView()
        aFollowC.backgroundColor = .yellow
        stickyHLight.addSubview(aFollowC)
        aFollowC.translatesAutoresizingMaskIntoConstraints = false
        aFollowC.trailingAnchor.constraint(equalTo: stickyHLight.trailingAnchor, constant: 0).isActive = true
        aFollowC.heightAnchor.constraint(equalToConstant: 30).isActive = true //30
        aFollowC.centerYAnchor.constraint(equalTo: stickyHLight.centerYAnchor).isActive = true
        aFollowC.layer.cornerRadius = 10
        aFollowC.isUserInteractionEnabled = true
        aFollowC.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onFollowClicked)))
        aFollowC.isHidden = true
        
//        let aFollowCText = UILabel()
        aFollowCText.textAlignment = .center
        aFollowCText.textColor = .black
        aFollowCText.font = .boldSystemFont(ofSize: 13) //default 14
        aFollowC.addSubview(aFollowCText)
        aFollowCText.translatesAutoresizingMaskIntoConstraints = false
        aFollowCText.leadingAnchor.constraint(equalTo: aFollowC.leadingAnchor, constant: 20).isActive = true
        aFollowCText.trailingAnchor.constraint(equalTo: aFollowC.trailingAnchor, constant: -20).isActive = true
        aFollowCText.centerYAnchor.constraint(equalTo: aFollowC.centerYAnchor).isActive = true
        aFollowCText.text = "Save"
    }
    
    func preloadAudio() {
        let videoURL2 = "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_audio_4.m4a?alt=media"
        let audioUrl = CacheManager.shared.getCacheUrlFor(videoUrl: videoURL2)
        let asset2 = AVAsset(url: audioUrl)
        let item2 = AVPlayerItem(asset: asset2)
        player2 = AVPlayer(playerItem: item2)
//        player2 = AVPlayer()
        let layer2 = AVPlayerLayer(player: player2)
        layer2.frame = audioContainer.bounds
        audioContainer.layer.addSublayer(layer2)
    }
    @objc func onResumeAudioClicked(gesture: UITapGestureRecognizer) {
        print("clicked play audio")
        resumeAudio()
    }
    @objc func onPauseAudioClicked(gesture: UITapGestureRecognizer) {

        pauseAudio()
    }
    
    func resumeAudio() {
        pauseBtn.isHidden = false //test
        playBtn.isHidden = true //test
        
        player2?.play()
    }
    func pauseAudio() {
        pauseBtn.isHidden = true //test
        playBtn.isHidden = false //test
        
        player2?.pause()
    }
    
    func layoutTabUI() {
        
        for d in vDataList {
            
            let stack = TabStack()
            stackView.addSubview(stack)
            stack.translatesAutoresizingMaskIntoConstraints = false
            if(tabList.isEmpty) {
                stack.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0).isActive = true //20
            } else {
                let lastArrayE = tabList[tabList.count - 1]
                stack.leadingAnchor.constraint(equalTo: lastArrayE.trailingAnchor, constant: 0).isActive = true //20
            }
            stack.centerYAnchor.constraint(equalTo: stackView.centerYAnchor, constant: 0).isActive = true
            stack.heightAnchor.constraint(equalToConstant: 40).isActive = true
            tabList.append(stack)
            if(!tabList.isEmpty && tabList.count == vDataList.count) {
                stack.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0).isActive = true
            }
            //test > if less than 3 tabs, can split width of tab to two equal parts
            let tabCount = vDataList.count
            var isTabWidthFixed = false
            if(tabCount == 2 || tabCount == 3) {
                let tabWidth = (viewWidth - tabScrollMargin*2)/CGFloat(tabCount)
                stack.widthAnchor.constraint(equalToConstant: tabWidth).isActive = true
                isTabWidthFixed = true
            }
            stack.setTabTextMargin(isTabWidthFixed: isTabWidthFixed)
            stack.setTabTypeSmall(isSmall: true)
            stack.delegate = self
            
            if(d == "v") {
                stack.setText(code: d, d: "Loops")
            } else if(d == "p") {
                stack.setText(code: d, d: "Posts")
            } else if(d == "s") {
                stack.setText(code: d, d: "Shots")
            }
        }
    }
    
    func redrawScrollFeedUI() {
        let viewWidth = self.frame.width
        let feedHeight = feedScrollView.frame.height
        for v in vDataList {
            
            let stack: ScrollDataFeedCell
            if(v == "p") {
                stack = ScrollFeedHPostListCell()
            } else if(v == "v") {
                stack = ScrollFeedGridVideo2xViewCell()
            } else if(v == "s") {
                stack = ScrollFeedGridPhoto2xViewCell()
            } else {
                return
            }
            feedScrollView.addSubview(stack)
            stack.translatesAutoresizingMaskIntoConstraints = false
            if(feedList.isEmpty) {
                stack.leadingAnchor.constraint(equalTo: feedScrollView.leadingAnchor, constant: 0).isActive = true //20
            } else {
                let lastArrayE = feedList[feedList.count - 1]
                stack.leadingAnchor.constraint(equalTo: lastArrayE.trailingAnchor, constant: 0).isActive = true //20
            }
            stack.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
            stack.heightAnchor.constraint(equalToConstant: feedHeight).isActive = true
            feedList.append(stack)

            stack.initialize()
            stack.aDelegate = self
            stack.setShowVerticalScroll(isShowVertical: true)
        }

        let tabCount = vDataList.count
        feedScrollView.contentSize = CGSize(width: viewWidth * CGFloat(tabCount), height: feedHeight)
    }
    
    func configureHLightBox() {
        for l in aHLightBoxArray {
            let aHLightRect1 = UIView()
            aHLightBox.addSubview(aHLightRect1)
            aHLightRect1.translatesAutoresizingMaskIntoConstraints = false
            aHLightRect1.leadingAnchor.constraint(equalTo: aHLightBox.leadingAnchor, constant: 0).isActive = true //20
            aHLightRect1.trailingAnchor.constraint(equalTo: aHLightBox.trailingAnchor, constant: 0).isActive = true //-20
            if(aHLightBoxViewArray.isEmpty) {
                aHLightRect1.topAnchor.constraint(equalTo: aHLightBox.topAnchor, constant: 0).isActive = true
            } else {
                let lastArrayE = aHLightBoxViewArray[aHLightBoxViewArray.count - 1]
                aHLightRect1.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 10).isActive = true //10
            }
            aHLightBoxViewArray.append(aHLightRect1)
            
            if(l == "np") {
                let cell = SoundEmptyPostHighlightBox(frame: CGRect(x: 0 , y: 0, width: viewWidth, height: viewHeight))
                aHLightRect1.addSubview(cell)
                cell.translatesAutoresizingMaskIntoConstraints = false
                cell.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
                cell.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
                cell.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true
                cell.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
                cell.redrawUI()
            } else if(l == "d_s") {
                let cell = DiscoverSoundSizeMHighlightCell(frame: CGRect(x: 0 , y: 0, width: viewWidth, height: viewHeight))
                aHLightRect1.addSubview(cell)
                cell.translatesAutoresizingMaskIntoConstraints = false
                cell.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
                cell.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
                cell.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true
                cell.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
                cell.redrawUI()
                cell.delegate = self
            }
            //test > error handling
            else if(l == "na") {
                let cell = SoundNotFoundHighlightBox(frame: CGRect(x: 0 , y: 0, width: viewWidth, height: viewHeight))
                aHLightRect1.addSubview(cell)
                cell.translatesAutoresizingMaskIntoConstraints = false
                cell.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
                cell.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
                cell.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true
                cell.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
                cell.redrawUI()
            } else if(l == "e") {
                let cell = FetchErrorHighlightBox(frame: CGRect(x: 0 , y: 0, width: viewWidth, height: viewHeight))
                aHLightRect1.addSubview(cell)
                cell.translatesAutoresizingMaskIntoConstraints = false
                cell.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
                cell.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
                cell.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true
                cell.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
                cell.redrawUI()
                cell.delegate = self
            } else if(l == "us") {
                let cell = SoundSuspendedHighlightBox(frame: CGRect(x: 0 , y: 0, width: viewWidth, height: viewHeight))
                aHLightRect1.addSubview(cell)
                cell.translatesAutoresizingMaskIntoConstraints = false
                cell.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
                cell.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
                cell.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true
                cell.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
                cell.redrawUI()
            }
        }
        
        //test
        if(!aHLightBoxViewArray.isEmpty) {
            let lastArrayE = aHLightBoxViewArray[aHLightBoxViewArray.count - 1]
            lastArrayE.bottomAnchor.constraint(equalTo: aHLightBox.bottomAnchor, constant: -10).isActive = true
        }
    }
    
    func configureHLightUI() {
        for l in aHLightDataArray {
            //highlight container for each highlight content
            let aHLightRect1 = UIView()
//            aHLightRect1.backgroundColor = .ddmDarkColor //.ddmDarkColor
    //        aHLightRect1.backgroundColor = .clear
            aHLightSection.addSubview(aHLightRect1)
            aHLightRect1.translatesAutoresizingMaskIntoConstraints = false
            aHLightRect1.leadingAnchor.constraint(equalTo: aHLightSection.leadingAnchor, constant: 0).isActive = true
            aHLightRect1.trailingAnchor.constraint(equalTo: aHLightSection.trailingAnchor, constant: 0).isActive = true
            if(aHLightViewArray.isEmpty) {
                aHLightRect1.topAnchor.constraint(equalTo: aHLightSection.topAnchor, constant: 0).isActive = true
            } else {
                let lastArrayE = aHLightViewArray[aHLightViewArray.count - 1]
                aHLightRect1.topAnchor.constraint(equalTo: lastArrayE.bottomAnchor, constant: 20).isActive = true //10
            }
//            aHLightRect1.layer.cornerRadius = 10 //10
//            aHLightRect1.layer.opacity = 0.1 //0.2
            aHLightViewArray.append(aHLightRect1)
            
            if(l == "j") {
                
                //test 2 > reusable cell
                let cell = JobHighlightCell(frame: CGRect(x: 0 , y: 0, width: viewWidth, height: viewHeight))
//                aHLightSection.addSubview(cell)
                aHLightRect1.addSubview(cell)
                cell.translatesAutoresizingMaskIntoConstraints = false
                cell.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
                cell.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
                cell.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true
                cell.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
                cell.redrawUI()
            }
            else if(l == "s") {
                
                //test 2 > reusable cell
                let cell = ShopHighlightCell(frame: CGRect(x: 0 , y: 0, width: viewWidth, height: viewHeight))
//                aHLightSection.addSubview(cell)
                aHLightRect1.addSubview(cell)
                cell.translatesAutoresizingMaskIntoConstraints = false
                cell.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
                cell.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
                cell.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true
                cell.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
                cell.redrawUI()
                
                //add delegate
                cell.delegate = self
            }
            else if(l == "b") {
                
                //test 2 > reusable cell
                let cell = BookHighlightCell(frame: CGRect(x: 0 , y: 0, width: viewWidth, height: viewHeight))
//                aHLightSection.addSubview(cell)
                aHLightRect1.addSubview(cell)
                cell.translatesAutoresizingMaskIntoConstraints = false
                cell.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
                cell.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
                cell.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true
                cell.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
                cell.redrawUI()
            }
            else if(l == "r") {
                
                //test 2 > reusable cell
                let cell = RankHighlightCell(frame: CGRect(x: 0 , y: 0, width: viewWidth, height: viewHeight))
//                aHLightSection.addSubview(cell)
                aHLightRect1.addSubview(cell)
                cell.translatesAutoresizingMaskIntoConstraints = false
                cell.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
                cell.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
                cell.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true
                cell.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
                cell.redrawUI()
            }
            //test > error handling
            //reuse HighlightBox due to laziness to create new error handling HighlightCells
            else if(l == "na") {
                let cell = SoundNotFoundHighlightBox(frame: CGRect(x: 0 , y: 0, width: viewWidth, height: viewHeight))
                aHLightRect1.addSubview(cell)
                cell.translatesAutoresizingMaskIntoConstraints = false
                cell.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
                cell.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
                cell.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true
                cell.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
                cell.redrawUI()
            } else if(l == "e") {
                let cell = FetchErrorHighlightBox(frame: CGRect(x: 0 , y: 0, width: viewWidth, height: viewHeight))
                aHLightRect1.addSubview(cell)
                cell.translatesAutoresizingMaskIntoConstraints = false
                cell.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
                cell.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
                cell.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true
                cell.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
                cell.redrawUI()
//                cell.delegate = self
            } else if(l == "us") {
                let cell = SoundSuspendedHighlightBox(frame: CGRect(x: 0 , y: 0, width: viewWidth, height: viewHeight))
                aHLightRect1.addSubview(cell)
                cell.translatesAutoresizingMaskIntoConstraints = false
                cell.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
                cell.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
                cell.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true
                cell.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
                cell.redrawUI()
            }
        }
        
        if(!aHLightViewArray.isEmpty) {
            let lastArrayE = aHLightViewArray[aHLightViewArray.count - 1]
            lastArrayE.bottomAnchor.constraint(equalTo: aHLightSection.bottomAnchor, constant: -10).isActive = true
        }
    }
    
    //test
    var isBFullDisplayed = true //part B at 80, means profile photo not hidden at full mode
    @objc func onPanelPanGesture(gesture: UIPanGestureRecognizer) {

        if(gesture.state == .began) {
            print("onPan start: ")
            currentPanelTopCons = panelTopCons!.constant
        } else if(gesture.state == .changed) {
            let translation = gesture.translation(in: self)
            let x = translation.x
            let y = translation.y

            let velocity = gesture.velocity(in: self)

            //test > put a limit to how high panel can be scrolled
            if(y < 0) {
                //y go up
                if(panelTopCons!.constant <= -self.frame.height) {
                    self.panelTopCons?.constant = -self.frame.height
                } else {
                    panelTopCons?.constant = currentPanelTopCons + y
                }
            } else {
                //y go down
                print("xtest panel onPan goDown: ")
                panelTopCons?.constant = currentPanelTopCons + y
            }

            //test > AB section transition when panel toggle between full and half
            scrollABTransition(scrollLevel: getScrollLevel())

            //test > map padding and marker react
            mapReactToPanelPanChange(y: y)
        } else if(gesture.state == .ended){
            print("onPan end: ")

            //test xxx
            if(self.currentPanelMode == self.PANEL_MODE_HALF) {
                if(self.currentPanelTopCons - self.panelTopCons!.constant > 75) {
                    reactToPanelModeEndState(panelMode: PANEL_MODE_FULL)
                } else if (self.currentPanelTopCons - self.panelTopCons!.constant < -150) {
                    close(isAnimated: true)
                } else {
                    reactToPanelModeEndState(panelMode: PANEL_MODE_HALF)
                }
            }

            //test > map markers react to panel mode change
            if(self.currentPanelMode != self.PANEL_MODE_EMPTY) {
                self.delegate?.didFinishMapChangeSoundScrollable()
            }
        }
    }
    
    override func close(isAnimated: Bool) {
        print("close correctMapPadding: ")
        //test
        delegate?.didStartMapChangeSoundScrollable()
        self.changeSoundPanelMode(panelMode: self.PANEL_MODE_EMPTY) //test

        if(isAnimated) {
            UIView.animate(withDuration: 0.2, animations: {
                self.panelTopCons?.constant = 0

                self.scrollABTransition(scrollLevel: self.getScrollLevel())
                self.superview?.layoutIfNeeded()
            }, completion: { _ in
                //test > stop video before closing panel
                self.destroyCell()
//                self.pauseFeedPlayingMedia()
                
                self.delegate?.didClickCloseSoundScrollablePanel()
                self.removeFromSuperview()
            })
        } else {
            //test > stop video before closing panel
            self.destroyCell()
//            self.pauseFeedPlayingMedia()
            
            self.delegate?.didClickCloseSoundScrollablePanel()
            self.removeFromSuperview()
        }
    }

    func getScrollLevel() -> CGFloat {
        var scrollLevel = (self.halfModePanelHeight + self.panelTopCons!.constant)/(self.halfModePanelHeight - self.frame.height)
        if(scrollLevel < 0) {
            scrollLevel = 0
        }
        return scrollLevel
    }

    func changeSoundPanelMode(panelMode : String) {
        print("change correctMapPadding: \(panelMode)")
        if(panelMode == PANEL_MODE_EMPTY) {
            currentMapPaddingBottom = 0
            delegate?.didChangeMapPaddingSoundScrollable(y: 0)
        } else {
            currentMapPaddingBottom = halfModeMapPadding
            delegate?.didChangeMapPaddingSoundScrollable(y: halfModeMapPadding)
        }
        currentPanelMode = panelMode
    }

    @objc func onAPhotoClicked(gesture: UITapGestureRecognizer) {
        delegate?.didSClickSoundSoundScrollable()
    }
    @objc func onBPhotoClicked(gesture: UITapGestureRecognizer) {
        delegate?.didSClickUserSoundScrollable()
    }
    @objc func onCPhotoClicked(gesture: UITapGestureRecognizer) {
        delegate?.didSClickSoundSoundScrollable()
    }

    override func setStateTarget(target: CLLocationCoordinate2D) {
        mapTargetCoordinates = target
    }
    override func setStateZoom(zoom: Float) {
        mapTargetZoom = zoom
    }
    override func getStateTarget() -> CLLocationCoordinate2D {
        return mapTargetCoordinates
    }
    override func getStateZoom() -> Float {
        return mapTargetZoom
    }

    override func correctMapPadding() {
        print("correctMapPadding:")
        delegate?.didChangeMapPaddingSoundScrollable(y: halfModeMapPadding)
    }
    
    //scroll down to half mode
    @objc func onCloseClicked(gesture: UITapGestureRecognizer) {
        print("onCloseClick: ")

        UIView.animate(withDuration: 0.2, animations: {
            //test > programatically scroll to original half mode
            self.panelTopCons?.constant = -self.halfModePanelHeight
            self.changeSoundPanelMode(panelMode: self.PANEL_MODE_HALF)

            let scrollLevel = 0.0
            self.scrollABTransition(scrollLevel: scrollLevel)

            self.superview?.layoutIfNeeded()
            
            //test > pause video when close to half mode, check for video intersected when full mode
            if(!self.feedList.isEmpty) {
                let aVc = self.feedList[self.currentIndex]
                guard let b = aVc as? ScrollFeedHPostListCell else {
                    return
                }
//                b.reactToIntersectedVideo(intersectedIdx: -1)
                
                //test 2 > new method => pause media if half/empty mode
                b.pauseMediaAsset(cellAssetIdx: b.playingCellMediaAssetIdx)
                b.playingCellMediaAssetIdx = [-1, -1] //reset state
            }
        }, completion: { finished in

        })
    }
    
    //test > share sheet when click on share post
    func openShareSheet() {
        let sharePanel = ShareSheetScrollableView(frame: CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.height))
        panelView.addSubview(sharePanel)
        sharePanel.translatesAutoresizingMaskIntoConstraints = false
        sharePanel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        sharePanel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        sharePanel.delegate = self
        
        //test > track share scrollable view
        pageList.append(sharePanel)
    }
    
    //test > add comment panel
    func openComment() {
        let commentPanel = CommentScrollableView(frame: CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.height))
        panelView.addSubview(commentPanel)
        commentPanel.translatesAutoresizingMaskIntoConstraints = false
        commentPanel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        commentPanel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        commentPanel.delegate = self
        commentPanel.initialize()
        commentPanel.setBackgroundDark()
        
        //test > track comment scrollable view
        pageList.append(commentPanel)
    }
    
    //test > object id for fetching data
    func setObjectId(id: String) {
        objectId = id
    }
    func getObjectId() -> String {
        return objectId
    }
    
    //test > click follow btn
    var isAction = false
    @objc func onFollowClicked(gesture: UITapGestureRecognizer) {
        let isSignedIn = SignInManager.shared.getStatus()
        if(isSignedIn) {
            if(isAction) {
                actionUI(doneState: false)
                isAction = false
            } else {
                actionUI(doneState: true)
                isAction = true
            }
        }
        else {
            delegate?.didSClickSoundSignIn()
        }
    }
    func actionUI(doneState: Bool) {
        if(doneState) {
            aFollowA.backgroundColor = .ddmDarkColor
            aFollowAText.text = "Saved"
            aFollowAText.textColor = .white
            aFollow.backgroundColor = .ddmDarkColor
            aFollowText.text = "Saved"
            aFollowText.textColor = .white
            aFollowC.backgroundColor = .ddmDarkColor
            aFollowCText.text = "Saved"
            aFollowCText.textColor = .white
        }
        else {
            aFollowA.backgroundColor = .yellow
            aFollowAText.text = "Save"
            aFollowAText.textColor = .black
            aFollow.backgroundColor = .yellow
            aFollowText.text = "Save"
            aFollowText.textColor = .black
            aFollowC.backgroundColor = .yellow
            aFollowCText.text = "Save"
            aFollowCText.textColor = .black
        }
    }
    
    var tabScrollGap = 0.0
    var totalTabScrollXLead = 0.0
    func measureTabScroll() {
        tabScrollGap = stackviewUsableLength - tabScrollView.frame.width
        if(tabScrollGap < 0) {
            tabScrollGap = 0.0
        }
        if(!self.tabList.isEmpty) {
            totalTabScrollXLead = stackviewUsableLength - tabList[tabList.count - 1].frame.width
        }
    }
    func arrowReactToTabScroll(tabXOffset: CGFloat) {
        if(tabScrollGap > 0) {
            if(tabXOffset > tabScrollGap - 26.0) {
                tabScrollRHSBtn.isHidden = true
            } else {
                tabScrollRHSBtn.isHidden = false
            }
            if(tabXOffset < 26.0) {
                tabScrollLHSBtn.isHidden = true
            } else {
                tabScrollLHSBtn.isHidden = false
            }
        }
    }
    
    //test > populate UI when data fetched
    func configureUI(data: String) {
        if(data == "a") {
            self.aNameText.text = "明知故犯 - Hubert Wu"
            self.aNameTextB.text = "明知故犯 - Hubert Wu"
            self.aNameTextC.text = "明知故犯 - Hubert Wu"
            self.objectSymbol.isHidden = false
            self.aSubDesc.text = "00:29"
            
            self.aUsernameAText.text = "Hubert Wu"
            self.playBtn.isHidden = false
            self.aHLightTitle.text = "00:29"
            self.aFollowA.isHidden = false
            self.aFollow.isHidden = false
            self.aFollowC.isHidden = false
            
            let aImageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
            aPhoto.sd_setImage(with: aImageUrl)
            aPhotoB.sd_setImage(with: aImageUrl)
        }
        else {
            deconfigureUI()
        }
    }
    
    func activateTabUI() {
        if(!self.tabList.isEmpty) {
            for l in self.tabList {
                self.stackviewUsableLength += l.frame.width
            }
            self.tabScrollView.contentSize = CGSize(width: self.stackviewUsableLength, height: 40)

            let tab = self.tabList[0]
            self.tabSelectWidthCons?.constant = tab.frame.width
            self.tabSelect.isHidden = false
        }
        self.measureTabScroll()
        let xTabOffset = self.tabScrollView.contentOffset.x
        self.arrowReactToTabScroll(tabXOffset: xTabOffset)
        self.reactToTabSectionChange(index: self.currentIndex)
    }
    
    func deconfigurePanel() {
        deconfigureUI()
        deconfigureHLightBox()
        deconfigureHLightUI()
        deconfigureScrollFeedUI()
        deconfigureTabUI()
    }
    func deconfigureUI() {
        self.aNameText.text = ""
        self.aNameTextB.text = ""
        self.aNameTextC.text = ""
        self.objectSymbol.isHidden = true
        self.aSubDesc.text = ""
        
        self.aUsernameAText.text = ""
        self.playBtn.isHidden = true
        self.aHLightTitle.text = ""
        self.aFollowA.isHidden = true
        self.aFollow.isHidden = true
        self.aFollowC.isHidden = true
        
        let aImageUrl = URL(string: "")
        aPhoto.sd_setImage(with: aImageUrl)
        aPhotoB.sd_setImage(with: aImageUrl)
    }
    func deconfigureHLightBox() {
        if(!aHLightBoxViewArray.isEmpty) {
            for e in aHLightBoxViewArray {
                e.removeFromSuperview()
            }
            aHLightBoxViewArray.removeAll()
        }
        if(!aHLightBoxArray.isEmpty) {
            aHLightBoxArray.removeAll()
        }
    }
    func deconfigureHLightUI() {
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
    func deconfigureScrollFeedUI() {
        if(!feedList.isEmpty) {
            for feed in feedList {
                feed.dataPaginateStatus = ""
                feed.vDataList.removeAll()
                feed.vCV?.reloadData()
                
                feed.removeFromSuperview()
            }
            feedList.removeAll()
        }
    }
    func deconfigureTabUI() {
        if(!tabList.isEmpty) {
            for e in tabList {
                e.removeFromSuperview()
            }
            tabList.removeAll()
        }
        
        //reset to 0
        stackviewUsableLength = 0.0
        tabSelect.isHidden = true
    }
    func refreshFetchSoundProfile() {
        deconfigurePanel()
        
        self.isFetchFeedAllowed = false
        layoutTabUI()
//        asyncFetchSoundProfile(id: getObjectId())
        
        //test for error handling
        asyncFetchSoundProfile(id: "s_")
    }
    //test > async fetch data sound profile => temp testing
    var isFetchFeedAllowed = false
    func asyncFetchSoundProfile(id: String) {
        
        self.aSpinner.startAnimating()
        self.bSpinner.startAnimating()
        
        //test > new fetch method for testing error handling
        DataFetchManager.shared.fetchSoundData(id: id) { [weak self]result in
//        DataFetchManager.shared.fetchData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("api success \(id), \(l)")
                    guard let self = self else {
                        return
                    }
                    
                    self.aSpinner.stopAnimating()
                    self.bSpinner.stopAnimating()
                    
                    if(!l.isEmpty) {
                        let l_ = l[0]
                        if(l_ == "a") {
                            
                            //test > preload audio for playing sound
                            self.preloadAudio()
                            
                            //user account exists
                            self.isFetchFeedAllowed = true
                            
                            //test > lay out halfmode highlight box
                            self.aHLightBoxArray.append("np") //no posts
                            self.aHLightBoxArray.append("d_s") //discover more places
                            
                            //test > lay out highlight section
                            self.aHLightDataArray.append("r") //ranking *
                            
                            self.configureUI(data: "a")
                        }
                        else if(l_ == "b"){
                            self.aHLightBoxArray.append("us") //suspended
                            self.aHLightDataArray.append("us") //job //*
                            //suspended
                            self.configureUI(data: "b")
                        }
                        else {
                            //deleted
                            self.aHLightBoxArray.append("na") //not found highlight box
                            self.aHLightDataArray.append("na")
                            self.configureUI(data: "na")//na - data not available
                        }
                    }
                    
                    //test > half mode highlight box
                    self.configureHLightBox()
                    self.configureHLightUI()
                    
                    //test > assue fetch placemarkers here, then show markers on map
                    self.delegate?.didFinishFetchSoundScrollableData(pv: self, isSuccess: true)
                    
                    //test > init tabscroll UI e.g. measure width
                    self.activateTabUI()
                    self.redrawScrollFeedUI()
                    
                    //test > async fetch feed
                    if(!self.feedList.isEmpty) {
                        let b = self.feedList[self.currentIndex]
                        if(self.isFetchFeedAllowed) {
                            self.asyncFetchFeed(cell: b, id: "post_feed")
                        }
                    }
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    print("api fail")
                    guard let self = self else {
                        return
                    }
                    self.aSpinner.stopAnimating()
                    self.bSpinner.stopAnimating()
                    
                    if let a = error as? FetchDataError{
                        
                        if(a == .dataNotFound) {
                            self.configureUI(data: "na")//na - user data not available
                            
                            self.aHLightBoxArray.append("na") //user not found highlight box
                            self.aHLightDataArray.append("na")
                        } else if(a == .invalidResponse) {
                            self.configureUI(data: "e")//na - user data not available
                            
                            self.aHLightBoxArray.append("e") //user not found highlight box
                            self.aHLightDataArray.append("e")
                        } else if(a == .networkError) {
                            self.configureUI(data: "e")//na - user data not available
                            
                            self.aHLightBoxArray.append("e") //user not found highlight box
                            self.aHLightDataArray.append("e")
                        }
                    }
                    
                    //test > half mode highlight box
                    self.configureHLightBox()
                    self.configureHLightUI()
                    
                    //test > to be added with failure error
                    self.delegate?.didFinishFetchSoundScrollableData(pv: self, isSuccess: false)
                    
                    //test > init tabscroll UI e.g. measure width
                    self.activateTabUI()
                    //test > populate scrollfeedcells
                    self.redrawScrollFeedUI()
                }
                    
                break
            }
        }
    }

    //test > fetch data => temp fake data => try refresh data first
    func refreshFetchData() {
        if(!feedList.isEmpty) {
            let feed = feedList[currentIndex]
            feed.configureFooterUI(data: "")
            
            feed.dataPaginateStatus = ""
            asyncFetchFeed(cell: feed, id: "post")
        }
    }
    
    //**test > remove elements from dataset n uicollectionview
    func removeData(cell: ScrollDataFeedCell?, idxToRemove: Int) {
        guard let feed = cell else {
            return
        }
        if(!feed.vDataList.isEmpty) {
            if(idxToRemove > -1 && idxToRemove < feed.vDataList.count) {
                var indexPaths = [IndexPath]()
                let idx = IndexPath(item: idxToRemove, section: 0)
                indexPaths.append(idx)
                
                feed.vDataList.remove(at: idxToRemove)
                feed.vCV?.deleteItems(at: indexPaths)
                
                feed.unselectItemData()
                
                //test > footer to show msg when no more data
                if(feed.vDataList.isEmpty) {
                    feed.setFooterAaText(text: "Nothing has been posted yet.")
                    feed.configureFooterUI(data: "na")
                }
            }
        }
    }
    //**
    
    func asyncFetchFeed(cell: ScrollDataFeedCell?, id: String) {

        cell?.vDataList.removeAll()
        cell?.vCV?.reloadData()

        cell?.aSpinner.startAnimating()
        cell?.bSpinner.stopAnimating()
        
        cell?.dataPaginateStatus = "fetch"

        let id_ = "post"
        let isPaginate = false
        DataFetchManager.shared.fetchFeedData(id: id_, isPaginate: isPaginate) { [weak self]result in
//        DataFetchManager.shared.fetchData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("userscrollable api success \(id), \(l)")

                    guard let feed = cell else {
                        return
                    }
                    
                    //test
                    feed.aSpinner.stopAnimating()
                    
                    //test 2 > new append method
                    for i in l {
                        let postData = PostData()
                        postData.setDataType(data: i)
                        postData.setData(data: i)
                        postData.setTextString(data: i)
                        feed.vDataList.append(postData)
                    }
                    feed.vCV?.reloadData()
                    
                    //*test 3 > reload only appended data, not entire dataset
//                    let dataCount = feed.vDataList.count
//                    var indexPaths = [IndexPath]()
//                    var j = 1
//                    for i in l {
//                        let postData = PostData()
//                        postData.setDataType(data: i)
//                        postData.setData(data: i)
//                        postData.setTextString(data: i)
//                        feed.vDataList.append(postData)
//
//                        let idx = IndexPath(item: dataCount - 1 + j, section: 0)
//                        indexPaths.append(idx)
//                        j += 1
//
//                        print("ppv asyncfetch reload \(idx)")
//                    }
//                    feed.vCV?.insertItems(at: indexPaths)
                    //*

                    //test
                    if(l.isEmpty) {
                        print("postpanelscroll footer reuse configure")
                        feed.setFooterAaText(text: "Nothing has been posted yet.")
                        feed.configureFooterUI(data: "na")
                    }
                }

                case .failure(let error):
                print("api fail")
                DispatchQueue.main.async {
                    cell?.aSpinner.stopAnimating()
                    
                    cell?.configureFooterUI(data: "e")
                }

                break
            }
        }
    }
    
    func asyncPaginateFetchFeed(cell: ScrollDataFeedCell?, id: String) {

        cell?.bSpinner.startAnimating()
        
        let id_ = "post"
        let isPaginate = true
        DataFetchManager.shared.fetchFeedData(id: id_, isPaginate: isPaginate) { [weak self]result in
//        DataFetchManager.shared.fetchData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("api success \(id), \(l), \(l.isEmpty)")
                    
                    guard let self = self else {
                        return
                    }
                    
                    guard let feed = cell else {
                        return
                    }
                    if(l.isEmpty) {
                        feed.dataPaginateStatus = "end"
                    }
                    
                    //test
                    feed.bSpinner.stopAnimating()
                    
                    //test 2 > new append method
//                    for i in l {
//                        let postData = PostData()
//                        postData.setDataType(data: i)
//                        postData.setData(data: i)
//                        postData.setTextString(data: i)
//                        feed.vDataList.append(postData)
//                    }
//                    feed.vCV?.reloadData()
                    
                    //*test 3 > reload only appended data, not entire dataset
                    let dataCount = feed.vDataList.count
                    var indexPaths = [IndexPath]()
                    var j = 1
                    for i in l {
                        let postData = PostData()
                        postData.setDataType(data: i)
                        postData.setData(data: i)
                        postData.setTextString(data: i)
                        feed.vDataList.append(postData)

                        let idx = IndexPath(item: dataCount - 1 + j, section: 0)
                        indexPaths.append(idx)
                        j += 1

                        print("ppv asyncpaginate reload \(idx)")
                    }
                    feed.vCV?.insertItems(at: indexPaths)
                    //*
                    
                    //test
                    if(l.isEmpty) {
                        feed.configureFooterUI(data: "end")
                    }
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    print("api fail")
                    cell?.bSpinner.stopAnimating()
                    
                    cell?.configureFooterUI(data: "e")
                }
                break
            }
        }
    }
    
    //test > tab section UI Change (hardcoded - to be fixed in future)
    func reactToTabSectionChange(index: Int) {

        if(!self.tabList.isEmpty) {
            var i = 0
            for l in self.tabList {
                if(i == currentIndex) {
                    l.selectStack()
                } else {
                    l.unselectStack()
                }
                i += 1
            }
        }
    }
    
    func scrollABTransition(scrollLevel: CGFloat) {
        //A-Panel
        var newCons = 10.0
//        newCons = 10 + (-200 - 30)*scrollLevel
        newCons = 10 + (-260 - 30)*scrollLevel
        aNameTextTopCons?.constant = newCons

        var newPanelHeightCons = aPanelViewHalfModeHeight
        newPanelHeightCons = aPanelViewHalfModeHeight + (0 - aPanelViewHalfModeHeight)*scrollLevel
        aPanelViewHeightCons?.constant = newPanelHeightCons

        var newOpacity = 1.0
        newOpacity = 1 + (0 - 1)*scrollLevel
        aPanelView.layer.opacity = Float(newOpacity)

        //B-Panel
        var newInverseOpacity = 0.0
        newInverseOpacity = 0 + (1 - 0)*scrollLevel
        aNameTextB.layer.opacity = Float(newInverseOpacity)
        aPhotoB.layer.opacity = Float(newInverseOpacity)

        var newSize = 0.0
        newSize = 0 + (aPhotoBHeight - 0)*scrollLevel
        aPhotoWidthCons?.constant = newSize
        aPhotoHeightCons?.constant = newSize

        //Sticky header
        if(scrollLevel >= 1) {
            pillBtn.layer.opacity = Float(0.0)
            aStickyHeader.isHidden = false
        } else {
            pillBtn.layer.opacity = Float(1.0)
            aStickyHeader.isHidden = true
        }
    }
    
    func scrollBTransition(scrollLevel: CGFloat) {
        //B-Panel
        var newInverseOpacity = 0.0
        newInverseOpacity = 0 + (1 - 0)*scrollLevel
        aNameTextB.layer.opacity = Float(newInverseOpacity)
        aPhotoB.layer.opacity = Float(newInverseOpacity)

        var newSize = 0.0
        newSize = 0 + (aPhotoBHeight - 0)*scrollLevel
        aPhotoWidthCons?.constant = newSize
        aPhotoHeightCons?.constant = newSize

        //Sticky header
        if(scrollLevel >= 1) {
            pillBtn.layer.opacity = Float(0.0)
            aStickyHeader.isHidden = false
        } else {
            pillBtn.layer.opacity = Float(1.0)
            aStickyHeader.isHidden = true
        }
    }
    
    //test > sticky header title animation when scroll up and down
    var isCTitleDisplayed = false
    func cTitleAnimateDisplay() {
        //title appear
        if(isCTitleDisplayed == false) {
            UIView.animate(withDuration: 0.2, animations: {
                self.cNameTextCenterYCons?.constant = 0.0
                self.layoutIfNeeded()
                
                self.isCTitleDisplayed = true
            })
        }
    }
    func cTitleAnimateHide() {
        //title hide
        if(isCTitleDisplayed == true) {
            UIView.animate(withDuration: 0.2, animations: {
                self.cNameTextCenterYCons?.constant = 50.0
                self.layoutIfNeeded()
                
                self.isCTitleDisplayed = false
            })
        }
    }
    
    func mapReactToPanelPanChange(y: CGFloat){
        if(panelTopCons!.constant < -halfModePanelHeight) {
            print("xtest onPan place 1: ")
            delegate?.didChangeMapPaddingSoundScrollable(y: halfModeMapPadding)
            
        } else {
            if(self.currentPanelMode == self.PANEL_MODE_HALF) {
                if(currentMapPaddingBottom - y < 0) {
                    print("xtest onPan place 2: \(y), \(currentMapPaddingBottom)")
                    delegate?.didChangeMapPaddingSoundScrollable(y: 0)
                } else {
                    print("xtest onPan place 3: \(y), \(currentMapPaddingBottom)")
                    delegate?.didChangeMapPaddingSoundScrollable(y: currentMapPaddingBottom - y)

                    //test marker disappear trigger
                    delegate?.didStartMapChangeSoundScrollable()
                }
            }
            else if(self.currentPanelMode == self.PANEL_MODE_FULL) {
                let gapY = panelTopCons!.constant + halfModePanelHeight
                if(currentMapPaddingBottom - gapY < 0) {
                    print("xtest onPan place 5: \(gapY), \(currentMapPaddingBottom)")
                    delegate?.didChangeMapPaddingSoundScrollable(y: 0)
                } else {
                    print("xtest onPan place 6: \(gapY), \(currentMapPaddingBottom)")
                    delegate?.didChangeMapPaddingSoundScrollable(y: currentMapPaddingBottom - gapY)

                    //test marker disappear trigger
                    delegate?.didStartMapChangeSoundScrollable()
                }
            }
        }
    }

    func reactToPanelModeEndState(panelMode : String) {

        UIView.animate(withDuration: 0.2, animations: {
            
//            var idx = -1
            if(panelMode == self.PANEL_MODE_FULL) {
                self.panelTopCons?.constant = -self.frame.height
                
                //test > check for intersected idx
//                idx = self.getIntersectedIdx()
            }
            else if(panelMode == self.PANEL_MODE_HALF) {
                self.panelTopCons?.constant = -self.halfModePanelHeight
            }
            self.scrollABTransition(scrollLevel: self.getScrollLevel())
            self.changeSoundPanelMode(panelMode: panelMode) //test
            self.superview?.layoutIfNeeded()
            
            //test > pause video when close to half mode, check for video intersected when full mode
//            let aVc = self.feedList[self.currentIndex]
//            guard let b = aVc as? ScrollFeedHPostListCell else {
//                return
//            }
//            b.reactToIntersectedVideo(intersectedIdx: idx)
            
        }, completion: { finished in
            if(panelMode == self.PANEL_MODE_FULL) {
                //test > b section measure
                self.refreshScrollViewContentSize()
            }
            
            print("onpan end reactpanelmode")
        })
    }
    
    //test > B panelview measure
    func refreshScrollViewContentSize() {
        //test > get vstackview height
        //test > update scrollview contentsize for scroll
        let a = self.vStackView.bounds
        let b = self.bPanelView.frame.size.height
        self.scrollView.contentSize = CGSize(width: a.width, height: a.height + 0.0)
        print("a & b heights: \(a.height), \(b)")
    }
    
    //test
    override func resumeActiveState() {
        print("soundscrollableview resume active")

        //test > only resume video if no comment scrollable view/any other view
        if(pageList.isEmpty) {
            resumeFeedPlayingMedia()
            dehideCell()
        }
        else {
            //dehide cell for commment view
            if let c = pageList[pageList.count - 1] as? CommentScrollableView {
                c.resumePlayingMedia()
                c.dehideCell()
            }
        }
    }
    
    //test > make viewcell image reappear after video panel closes
    func dehideCell() {
        if(!self.feedList.isEmpty) {
            let feed = self.feedList[currentIndex]
            if let b = feed as? ScrollFeedGridVideo2xViewCell {
                b.dehideCell()
            }
            else if let c = feed as? ScrollFeedGridPhoto2xViewCell {
                c.dehideCell()
            }
            else if let d = feed as? ScrollFeedHPostListCell {
                d.dehideCell()
            }
        }
    }
    
    //test > stop current video for closing
    func pauseFeedPlayingMedia() {
        if(!feedList.isEmpty) {
            let feed = feedList[currentIndex]
            if let b = feed as? ScrollFeedHPostListCell {
                b.pausePlayingMedia()
            }
        }
    }
    //test > resume current video
    func resumeFeedPlayingMedia() {
        if(!feedList.isEmpty) {
            let feed = feedList[currentIndex]
            if let b = feed as? ScrollFeedHPostListCell {
                b.resumePlayingMedia()
            }
        }
    }
    
    //test > destroy cell
    func destroyCell() {
        if(!self.feedList.isEmpty) {
            let feed = feedList[currentIndex]
            if let b = feed as? ScrollFeedHPostListCell {
                b.destroyCell()
            }
        }
    }
    
    //test 2 > new intersect func() for multi-video/audio assets play on/off
    //try autoplay OFF first, then only autoplay
    var isMediaAutoplayEnabled = true
//    var isMediaAutoplayEnabled = false
    func getIntersect2(aVc: ScrollFeedHPostListCell) {
        guard let v = aVc.vCV else {
            return
        }
        
        //fixed dummy area
        let dummyTopMargin = 200.0
//        let panelRectY = panelView.frame.origin.y
//        let vCvRectY = v.frame.origin.y //will always be 0
//        let dummyOriginY = vCvRectY + dummyTopMargin
        let aStickyHeaderH = aStickyHeader.frame.size.height //try add stickyheader h as vcv origin can't be used
        let dummyOriginY = dummyTopMargin + aStickyHeaderH
        let dummyView = CGRect(x: 0, y: dummyOriginY, width: self.frame.width, height: 300)
        //*just in case > add view for illustration
//        let dV = UIView(frame: dummyView)
//        dV.backgroundColor = .blue
//        self.addSubview(dV)
        //*
        
        //identify intersected assets
        var cellAssetIdxArray = [[Int]]() //[cellIdx, assetIdx] => use array for simplicity
        for cell in v.visibleCells {
            guard let indexPath = v.indexPath(for: cell) else {
                return
            }
            guard let b = cell as? HPostListAViewCell else {
                return
            }
            
            let cellRect = v.convert(b.frame, to: self)
            let aTestRect = b.aTest.frame
            
            let p = b.mediaArray
            if(!p.isEmpty) {
                for m in p {
                    //test > quote
                    if let q = m as? PostQuoteContentCell {
                        //for quote content cells only => double loop for inner media
                        let pp = q.mediaArray
                        if(!pp.isEmpty) {
                            for mm in pp {
                                let mmFrame = mm.frame
                                let aaTestRect = q.aTest.frame
                                
                                let mFrame = m.frame
                                if let j = b.aTestArray.firstIndex(of: m) {
                                    let cVidCOriginY = mFrame.origin.y + aTestRect.origin.y + cellRect.origin.y + mmFrame.origin.y + aaTestRect.origin.y
                                    let cVidCRect = CGRect(x: 0, y: cVidCOriginY, width: mmFrame.size.width, height: mmFrame.size.height)
                                    
                                    let isIntersect = dummyView.intersects(cVidCRect)
                                    if(isIntersect) {
                                        let idx = [indexPath.row, j]
                                        cellAssetIdxArray.append(idx)
                                    }
                                }
                            }
                        }
                    } else {
                        let mFrame = m.frame
                        if let j = b.aTestArray.firstIndex(of: m) {
                            let cVidCOriginY = mFrame.origin.y + aTestRect.origin.y + cellRect.origin.y
                            let cVidCRect = CGRect(x: 0, y: cVidCOriginY, width: mFrame.size.width, height: mFrame.size.height)
                            
                            let isIntersect = dummyView.intersects(cVidCRect)
                            if(isIntersect) {
                                let idx = [indexPath.row, j]
                                cellAssetIdxArray.append(idx)
                            }
                        }
                    }
                }
            }
        }
 
        print("getintersect2 x: \(cellAssetIdxArray); \(aVc.playingCellMediaAssetIdx)")
        
        //test > pause media when playingMedia is no longer intersected inside dummy view
        let t = cellAssetIdxArray.contains(aVc.playingCellMediaAssetIdx)
        if(!t) {
            aVc.pauseMediaAsset(cellAssetIdx: aVc.playingCellMediaAssetIdx)
            aVc.playingCellMediaAssetIdx = [-1, -1] //reset state
        }
        
        //test > autoplay video when intersected
        if(isMediaAutoplayEnabled) {
            if(!cellAssetIdxArray.isEmpty) {
                let iCellAssetIdx = cellAssetIdxArray[0]
                print("getintersect2 x: \(iCellAssetIdx); \(aVc.playingCellMediaAssetIdx) => \(iCellAssetIdx == aVc.playingCellMediaAssetIdx)")
                if(iCellAssetIdx != aVc.playingCellMediaAssetIdx) {
                    
                    //autostop playing media to prevent multi-video playing together
                    if(aVc.playingCellMediaAssetIdx != [-1, -1]) {
                        aVc.pauseMediaAsset(cellAssetIdx: aVc.playingCellMediaAssetIdx)
                        aVc.playingCellMediaAssetIdx = [-1, -1]
                    }
                    
                    //autoplay media when intersected
                    if(iCellAssetIdx.count == 2) {
                        let cIdx = iCellAssetIdx[0]
                        let aIdx = iCellAssetIdx[1]
                        if(cIdx > -1 && aIdx > -1) {
                            aVc.playingCellMediaAssetIdx = [cIdx, aIdx]
                            aVc.resumeMediaAsset(cellAssetIdx: aVc.playingCellMediaAssetIdx)
                        }
                    }
                }
            }
        }
    }
}

//test > try scrollview listener
extension SoundScrollablePanelView: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        //test 3 > new scrollview method
        if(scrollView == feedScrollView) {
            let xOffset = scrollView.contentOffset.x
            let viewWidth = self.frame.width
            let currentIndex = round(xOffset/viewWidth)
            
            //*tab select UI
            tempCurrentIndex = Int(currentIndex) //use tempcurrentindex as user will scroll fast cause problem
            let currentItemIndex = tempCurrentIndex
            var xWidth = 0.0
            var i = 0
            if(!self.tabList.isEmpty) {
                for l in self.tabList {
                    if(i == currentItemIndex) {
                        break
                    }
                    xWidth += l.frame.width
                    i += 1
                }
            }
            currentTabSelectLeadingCons = xWidth
            
            //test > keep scrollview y-offset constant(not wobbling up and down)
//            self.scrollView.isScrollEnabled = false
            //**
            
            //test > reset feed to y-contentoffset to 0 when aPanel not fully hidden
            let bPanelHeight = bPanelView.frame.size.height
            if self.scrollView.contentOffset.y < bPanelHeight {
                for feed in feedList {
                    feed.vCV?.contentOffset.y = 0
                }
            }
        }
        else if(scrollView == self.scrollView) {
            print("upv scrollview begin : \(scrollView.contentOffset.y), \(panelTopCons!.constant)")
            isBFullDisplayed = false
            if(scrollView.contentOffset.y == 0) {
                isBFullDisplayed = true
            }
            currentPanelTopCons = panelTopCons!.constant
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView == feedScrollView) {
            let xOffset = scrollView.contentOffset.x
            let viewWidth = self.frame.width
            let currentIndex = round(xOffset/viewWidth)

            if(!self.tabList.isEmpty) {
                let currentItemIndex = tempCurrentIndex
                let currentX = panelView.frame.width * CGFloat(currentItemIndex)
                let currentTabWidth = tabList[currentItemIndex].frame.width
                var hOffsetX = 0.0
                if(xOffset >= currentX) {
                    var nextTabWidth = tabList[currentItemIndex].frame.width
                    if(currentItemIndex < tabList.count - 1) {
                        nextTabWidth = tabList[currentItemIndex + 1].frame.width
                    }
                    hOffsetX = (xOffset - currentX)/(panelView.frame.width) * currentTabWidth + currentTabSelectLeadingCons
                    tabSelectLeadingCons?.constant = hOffsetX

                    let hWidth = (xOffset - currentX)/(panelView.frame.width) * (nextTabWidth - currentTabWidth) + currentTabWidth
                    tabSelectWidthCons?.constant = hWidth
                }
                else if (xOffset < currentX) {
                    var prevTabWidth = tabList[currentItemIndex].frame.width
                    if(currentItemIndex > 0) {
                        prevTabWidth = tabList[currentItemIndex - 1].frame.width
                    }

                    hOffsetX = (xOffset - currentX)/(panelView.frame.width) * prevTabWidth + currentTabSelectLeadingCons
                    tabSelectLeadingCons?.constant = hOffsetX

                    let hWidth = (xOffset - currentX)/(panelView.frame.width) * (currentTabWidth - prevTabWidth) + currentTabWidth
                    tabSelectWidthCons?.constant = hWidth
                }
                
                //test > tabscroll move along when feedscroll scroll to next tab
                if(self.tabList.count > 1) { //otherwise tabscroll cannot contentoffset
                    var oX = hOffsetX
                    if(hOffsetX > totalTabScrollXLead) {
                        oX = totalTabScrollXLead
                    }
                    if(totalTabScrollXLead > 0) {
                        let tabXContentOffset = oX/totalTabScrollXLead * tabScrollGap
                        tabScrollView.setContentOffset(CGPoint(x: tabXContentOffset, y: 0), animated: false)
                    }
                }
            }
            
            //test > async fetch feed
            let rIndex = Int(round(currentIndex))
            if(!self.feedList.isEmpty) {
                let b = self.feedList[rIndex]
                if(b.dataPaginateStatus == "") {
                    if(self.isFetchFeedAllowed) {
                        self.asyncFetchFeed(cell: b, id: "post_feed")
                    }
                }
            }
        }
        else if(scrollView == tabScrollView) {
            print("upv did scroll \(tabScrollView.contentOffset.x), \(tabScrollGap)")
            let tabXOffset = scrollView.contentOffset.x
            self.arrowReactToTabScroll(tabXOffset: tabXOffset)
        }
        else if(scrollView == self.scrollView) {

            //get direction of scroll => up or down
            let bPanelHeight = bPanelView.frame.size.height
            
            //test > METHOD 2
            if (bPanelHeight > 0) {
                if(!self.feedList.isEmpty) {
                    let feed = self.feedList[currentIndex]
                    guard let vCv = feed.vCV else {
                        return
                    }
                    let h = vCv.collectionViewLayout.collectionViewContentSize.height
                    let feedH = feedScrollView.frame.height

                    if !enableFatherViewScroll {
                        //**default solution
    //                    scrollView.contentOffset.y = bPanelHeight // point A
    //                    enableChildViewScroll = true
                        //**
                        
                        //test 1 > fix childscrollview that content height < cv height
                        if(h > feedH) {
                            scrollView.contentOffset.y = bPanelHeight // point A
                            enableChildViewScroll = true
                        } else {
                            //y -ve scroll to top
                            if scrollView.contentOffset.y >= bPanelHeight {
                                scrollView.contentOffset.y = bPanelHeight
                                enableFatherViewScroll = false
                                enableChildViewScroll = true
                            } else {
                                //test > flip to reset
                                enableFatherViewScroll = true
                                enableChildViewScroll = false
                            }
                        }
                    } else if scrollView.contentOffset.y >= bPanelHeight {
                        scrollView.contentOffset.y = bPanelHeight
                        enableFatherViewScroll = false
                        enableChildViewScroll = true
                    }
                    
                    //test > stickyheader UI respond to scroll change
                    if(scrollView.contentOffset.y >= aPhotoBHeight) {
                        cTitleAnimateDisplay()
                    } else {
                        cTitleAnimateHide()
                    }
                }
            }
            
            //test > scroll down to half mode
            let y = scrollView.contentOffset.y
            if(currentPanelMode == PANEL_MODE_FULL) {
                if(isBFullDisplayed) {

                    var newY = self.currentPanelTopCons - y
                    if(newY < -self.frame.height) {
                        newY = -self.frame.height
                    }
                    panelTopCons?.constant = newY
                    
                    print("upv scrollview scroll : \(y), \(newY)")
                    
                    //test > AB section transition when panel toggle between full and half
                    scrollBTransition(scrollLevel: getScrollLevel())
                }
            }
            
            //test > check for intersected video while scrolling
            if(!feedList.isEmpty) {
                let aVc = feedList[currentIndex]
                guard let b = aVc as? ScrollFeedHPostListCell else {
                    return
                }
//                var idx = -1
                if(currentPanelMode == PANEL_MODE_FULL) {
//                    idx = getIntersectedIdx(aVc: b)
                    
                    //test 2 > new method
                    getIntersect2(aVc: b)
                } else {
                    //for half mode and empty mode
                    
                    //test 2 > new method => pause media if half/empty mode
                    b.pauseMediaAsset(cellAssetIdx: b.playingCellMediaAssetIdx)
                    b.playingCellMediaAssetIdx = [-1, -1] //reset state
                }
//                b.reactToIntersectedVideo(intersectedIdx: idx)
            }
            print("onPan end xx scrollview: \(scrollView.contentOffset.y), \(currentPanelMode)")
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if(scrollView == feedScrollView) {
            let xOffset = scrollView.contentOffset.x
            let viewWidth = self.frame.width
            print("notifypanel scroll decelerate \(xOffset), \(viewWidth)")

//            currentIndex = Int(xOffset/viewWidth)
            let visibleIndex = Int(xOffset/viewWidth)
            
            //test > pause video when scroll to next tab
            if(!self.feedList.isEmpty) {
                let currentFeed = self.feedList[visibleIndex]
                let previousFeed = self.feedList[currentIndex]
                
                currentIndex = visibleIndex
                
                if(currentFeed != previousFeed) {
                    if let b = currentFeed as? ScrollFeedHPostListCell {
                        b.resumePlayingMedia()
                    }
                    else if let c = previousFeed as? ScrollFeedHPostListCell {
                        c.pausePlayingMedia()
                    }
                }
            }
            
            reactToTabSectionChange(index: currentIndex)
        }
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if(scrollView == feedScrollView) {
            let xOffset = scrollView.contentOffset.x
            let viewWidth = self.frame.width
            print("notifypanel scroll decelerate \(xOffset), \(viewWidth)")

//            currentIndex = Int(xOffset/viewWidth)
            let visibleIndex = Int(xOffset/viewWidth)
            
            //test > pause video when scroll to next tab
            if(!self.feedList.isEmpty) {
                let currentFeed = self.feedList[visibleIndex]
                let previousFeed = self.feedList[currentIndex]
                
                currentIndex = visibleIndex
                
                if(currentFeed != previousFeed) {
                    if let b = currentFeed as? ScrollFeedHPostListCell {
                        b.resumePlayingMedia()
                    }
                    else if let c = previousFeed as? ScrollFeedHPostListCell {
                        c.pausePlayingMedia()
                    }
                }
            }
            
            reactToTabSectionChange(index: currentIndex)
            
            //test > finalize current index tabselect margin and width
            var xWidth = 0.0
            var i = 0
            if(!self.tabList.isEmpty) {
                for l in self.tabList {
                    if(i == currentIndex) {
                        break
                    }
                    xWidth += l.frame.width
                    i += 1
                }
            }
            tabSelectLeadingCons?.constant = xWidth
            tabSelectWidthCons?.constant = tabList[currentIndex].frame.width
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if(scrollView == feedScrollView) {
            let xOffset = scrollView.contentOffset.x
            let viewWidth = self.frame.width
            
            //test > keep scrollview y-offset constant(not wobbling up and down)
//            self.scrollView.isScrollEnabled = true
        }
        else if(scrollView == self.scrollView) {
            print("onPan end scrollview: ")
            if(currentPanelMode == PANEL_MODE_FULL) {
                if(isBFullDisplayed) {
                    if(self.currentPanelTopCons - self.panelTopCons!.constant < -75) { //-150
                        reactToPanelModeEndState(panelMode: PANEL_MODE_HALF)
                    } else {
                        reactToPanelModeEndState(panelMode: PANEL_MODE_FULL)
                    }
                }
            }
        }
    }
}

extension SoundScrollablePanelView: HighlightCellDelegate {
    func hcWillBeginDragging(offsetY: CGFloat) {
        //test > keep scrollview y-offset constant(not wobbling up and down)
//        self.scrollView.isScrollEnabled = false
        //**
    }
    func hcScrollViewDidScroll(offsetY: CGFloat) {

    }
    func hcSrollViewDidEndDecelerating(offsetY: CGFloat) {

    }
    func hcScrollViewDidEndDragging(offsetY: CGFloat, decelerate: Bool) {
        //test > keep scrollview y-offset constant(not wobbling up and down)
//        self.scrollView.isScrollEnabled = true
        //**
    }
    
    func didHighlightClickUser(id: String) {
        
    }
    func didHighlightClickPlace(id: String) {
        
    }
    func didHighlightClickSound(id: String) {
        delegate?.didSClickSoundSoundScrollable()
    }
    
    func didHighlightClickRefresh(){
        //test > refresh data when clicked to refetch
        refreshFetchSoundProfile()
    }
}

extension SoundScrollablePanelView: ScrollFeedCellDelegate {
    func sfcWillBeginDragging(offsetY: CGFloat) {
        print("xtest scrollview begin: \(offsetY)")
    }
    func sfcScrollViewDidScroll(offsetY: CGFloat) {
        //test > METHOD 2
        if(!self.feedList.isEmpty) {
            let feed = self.feedList[currentIndex]
            guard let vCv = feed.vCV else {
                return
            }
            
            if !enableChildViewScroll {
                vCv.contentOffset.y = 0
            } else if vCv.contentOffset.y <= 0 {
                enableChildViewScroll = false
                enableFatherViewScroll = true
            }
            
            //test
    //        let aVc = feedList[currentIndex]
            guard let b = feed as? ScrollFeedHPostListCell else {
                return
            }
//            b.reactToIntersectedVideo(intersectedIdx: getIntersectedIdx(aVc: b))
            
            //test 2 > new method
            getIntersect2(aVc: b)
        }
    }
    func sfcSrollViewDidEndDecelerating(offsetY: CGFloat) {

    }
    func sfcScrollViewDidEndDragging(offsetY: CGFloat, decelerate: Bool) {

    }

    func sfcVCVPanBegan(offsetY: CGFloat, isScrollActive: Bool){

    }

    func sfcVCVPanChanged(offsetY: CGFloat, isScrollActive: Bool) {

    }

    func sfcVCVPanEnded(offsetY: CGFloat, isScrollActive: Bool) {

    }

    func sfcDidClickVcvRefresh(){
        refreshFetchData()
    }
    func sfcDidClickVcvComment() {
        print("fcDidClickVcvComment ")
        pauseFeedPlayingMedia()
        openComment()
    }
    func sfcDidClickVcvLove() {
        print("fcDidClickVcvLike ")
    }
    func sfcDidClickVcvShare() {
        print("fcDidClickVcvShare ")
        pauseFeedPlayingMedia()
        openShareSheet()
    }

    func sfcDidClickVcvClickUser() {
        pauseFeedPlayingMedia()
        delegate?.didSClickUserSoundScrollable()
    }
    func sfcDidClickVcvClickPlace() {
        pauseFeedPlayingMedia()
        delegate?.didSClickPlaceSoundScrollable()
    }
    func sfcDidClickVcvClickSound() {

    }
    func sfcDidClickVcvClickPost() {
        pauseFeedPlayingMedia()
        delegate?.didSClickSoundScrollableVcvClickPost()
    }
    func sfcDidClickVcvClickPhoto(pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String) {
        
        pauseFeedPlayingMedia()
        
        if(!self.feedList.isEmpty) {
            let b = self.feedList[self.currentIndex]
            let originInRootView = feedScrollView.convert(b.frame.origin, to: self)
            
            let adjustY = pointY + originInRootView.y
            delegate?.didSClickSoundScrollableVcvClickPhoto(pointX: pointX, pointY: adjustY, view: view, mode: mode)
        }
    }
    func sfcDidClickVcvClickVideo(pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String) {
        
        pauseFeedPlayingMedia()
        
        if(!self.feedList.isEmpty) {
            let b = self.feedList[self.currentIndex]
            let originInRootView = feedScrollView.convert(b.frame.origin, to: self)
            
            let adjustY = pointY + originInRootView.y
            delegate?.didSClickSoundScrollableVcvClickVideo(pointX: pointX, pointY: adjustY, view: view, mode: mode)
        }
    }

    //test
    func sfcAsyncFetchFeed() {

    }
    func sfcAsyncPaginateFeed(cell: ScrollFeedCell?) {

        guard let b = cell as? ScrollDataFeedCell else {
            return
        }
        if(self.isFetchFeedAllowed) {
            asyncPaginateFetchFeed(cell: b, id: "post_feed_end")
        }
    }
    
    func sfcIsScrollCarousel(isScroll: Bool) {

    }
    
    func sfcAutoplayVideo(cell: ScrollFeedCell?, vCCell: UICollectionViewCell?) {
//    func sfcAutoplayVideo(cell: ScrollFeedCell?, vCCell: HPostListAViewCell?) {
        //test > method 3 => add a timer before check for intersected rect first
//        asyncLayoutVc(id: "search_term")
    }
}

//test
extension ViewController: SoundScrollablePanelDelegate{
    func didClickCloseSoundScrollablePanel() {
        
        //test > reappear video when back from place panel
        backPage(isCurrentPageScrollable: true)
    }
    
    func didClickVcvSoundScrollablePanelItem(pointX: CGFloat, pointY: CGFloat, view: UIView) {
        print("click vcv in VC \(pointX), \(pointY), \(view.frame)")
    }
    
    func didChangeMapPaddingSoundScrollable(y: CGFloat) {
        changeMapPadding(padding: y)
        
        //test > try move redView of collision check according to map padding
        //-ve as y direction is inverse
        redViewTopCons?.constant = -y

    }
    
    func didStartMapChangeSoundScrollable(){
        mapDisappearMarkers()
    }
    func didFinishMapChangeSoundScrollable(){
        mapReappearMarkers()
    }
    
    func didSClickUserSoundScrollable() {
        
        //test
        openUserPanel()
    }
    func didSClickPlaceSoundScrollable(){
        
        openPlacePanel()
    }
    func didSClickSoundSoundScrollable(){
        
        //test
        openSoundPanel()
    }
    func didSClickSoundScrollableVcvClickPost(){
        openPostDetailPanel()
    }
    func didSClickSoundScrollableVcvClickPhoto(pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String){
        let offsetX = pointX - self.view.frame.width/2 + view.frame.width/2
        let offsetY = pointY - self.view.frame.height/2 + view.frame.height/2
        
        if(mode == PhotoTypes.P_SHOT) {
            //test > open photo panel with predetermined datasets
            var dataset = [String]()
    //        dataset.append("a")
            dataset.append("a")
            self.openPhotoPanel(offX: offsetX, offY: offsetY, originatorView: view, originatorViewType: OriginatorTypes.UIVIEW, id: 0, originatorViewId: "", preterminedDatasets: dataset)
        } else if(mode == PhotoTypes.P_0){
            openPhotoZoomPanel(offX: offsetX, offY: offsetY)
        } else if(mode == PhotoTypes.P_SHOT_DETAIL) {
            openPhotoDetailPanel()
        }
    }
    func didSClickSoundScrollableVcvClickVideo(pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String){
        let offsetX = pointX - self.view.frame.width/2 + view.frame.width/2
        let offsetY = pointY - self.view.frame.height/2 + view.frame.height/2

        //test 1 > for video only
        var dataset = [String]()
//        dataset.append("a")
        dataset.append("a")
        self.openVideoPanel(offX: offsetX, offY: offsetY, originatorView: view, originatorViewType: OriginatorTypes.UIVIEW, id: 0, originatorViewId: "", preterminedDatasets: dataset, mode: mode)
    }
    
    func didSClickSoundSignIn(){
        openLoginPanel()
    }
    
    func didFinishInitializeSoundScrollablePanel(pv: ScrollablePanelView){
        //test > show place marker when scrollable is initialized
//        showSinglePlacePoint(number: singleNumber, pv: pv)
//        singleNumber += 1
    }
    
    func didStartFetchSoundScrollableData(pv: ScrollablePanelView) {
        sSemiTransparentSpinner.startAnimating()
        sSemiGifImageOuter.isHidden = true
        sSemiTransparentText.text = ""
    }
    
    func didFinishFetchSoundScrollableData(pv: ScrollablePanelView, isSuccess: Bool) {
        //test 2 > with error handling
        if(isSuccess) {
            showSingleSoundPoint(number: singleSoundNumber, pv: pv)
            singleSoundNumber += 1
            
            //show data on map semi transparent textbox
            sSemiTransparentSpinner.stopAnimating()
            sSemiGifImageOuter.isHidden = false
            sSemiTransparentText.text = "明知故犯 - Hubert Wu"
        } else {
            sSemiTransparentSpinner.stopAnimating()
            sSemiGifImageOuter.isHidden = true
            sSemiTransparentText.text = ""
        }
    }
}
extension SoundScrollablePanelView: ShareSheetScrollableDelegate{
    func didShareSheetClick(){
        //test > for deleting item
        if(!pageList.isEmpty) {
            pageList.remove(at: pageList.count - 1)
            
            if(pageList.count > 0) {
                let lastPage = pageList[pageList.count - 1]
                if let a = lastPage as? CommentScrollableView {
                    print("lastpagelist e \(a.selectedItemIdx)")
                    let idx = a.selectedItemIdx
                    a.removeData(idxToRemove: idx)
                }
                else if let b = lastPage as? ShareSheetScrollableView {
                    print("lastpagelist f")
                }
            } else {
                if(!self.feedList.isEmpty) {
                    let feed = feedList[currentIndex]
                    removeData(cell: feed, idxToRemove: feed.selectedItemIdx)
                }
            }
        } else {

        }
    }
    func didShareSheetClickClosePanel(){
        
    }
    func didShareSheetFinishClosePanel(){
        //test > remove scrollable view from pagelist
        if(!pageList.isEmpty) {
            pageList.remove(at: pageList.count - 1)
            
            if(pageList.count > 0) {
                let lastPage = pageList[pageList.count - 1]
                if let a = lastPage as? CommentScrollableView {
                    print("lastpagelist c")
                    a.resumePlayingMedia()
                    a.unselectItemData()
                }
                else if let b = lastPage as? ShareSheetScrollableView {
                    print("lastpagelist d")
                }
            } else {
                resumeFeedPlayingMedia()
                
                if(!self.feedList.isEmpty) {
                    let feed = feedList[currentIndex]
                    feed.unselectItemData()
                }
            }
        }
    }
}
extension SoundScrollablePanelView: CommentScrollableDelegate{
    func didCClickUser(){
        delegate?.didSClickUserSoundScrollable()
    }
    func didCClickPlace(){
        delegate?.didSClickPlaceSoundScrollable()
    }
    func didCClickSound(){
        delegate?.didSClickSoundSoundScrollable()
    }
    func didCClickClosePanel(){
//        bottomBox.isHidden = true
    }
    func didCFinishClosePanel() {
        //test > remove comment scrollable view from pagelist
        if(!pageList.isEmpty) {
            pageList.remove(at: pageList.count - 1)
            
            if(pageList.count > 0) {
                let lastPage = pageList[pageList.count - 1]
                if let a = lastPage as? CommentScrollableView {
                    print("lastpagelist a")
                }
                else if let b = lastPage as? ShareSheetScrollableView {
                    print("lastpagelist b")
                }
            } else {
                resumeFeedPlayingMedia()
            }
        }
    }
    func didCClickComment(){
        
    }
    func didCClickShare(){
        openShareSheet()
    }
    func didCClickPost(){
        delegate?.didSClickSoundScrollableVcvClickPost()
    }
    func didCClickClickPhoto(pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
        delegate?.didSClickSoundScrollableVcvClickPhoto(pointX: pointX, pointY: pointY, view: view, mode: mode)
    }
    func didCClickClickVideo(pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
        delegate?.didSClickSoundScrollableVcvClickVideo(pointX: pointX, pointY: pointY, view: view, mode: mode)
    }
}
extension SoundScrollablePanelView: TabStackDelegate {
    func didClickTabStack(tabCode: String, isSelected: Bool) {
        if let index = vDataList.firstIndex(of: tabCode) {
            print("tabstack index clicked: \(index), \(tabCode)")
            if(currentIndex != index) {
                let xOffset = CGFloat(index) * viewWidth
                feedScrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
            }
            else {
                
            }
        } else {
            print("Element not found in the array")
        }
    }
}
