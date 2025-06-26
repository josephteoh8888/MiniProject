//
//  MeFollowListPanelView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 19/07/2024.
//

import Foundation
import UIKit
import SDWebImage

protocol MeListPanelDelegate : AnyObject {
    func didMeListClickUser(id: String)
    func didMeListClickClose()
    func didMeListClickSignIn()
    func didMeListClickPost(id: String, dataType: String, pointX: CGFloat, pointY: CGFloat)
    func didMeListClickPhoto(id: String, pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String)
    func didMeListClickVideo(id: String, pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String)
//    func didMeListClickUser(id: String)
    func didMeListClickPlace(id: String)
    func didMeListClickSound(id: String)
    
    //test > for marker animation after video closes
    func didStartMeListPanGesture(ppv : MeListPanelView)
    func didEndMeListPanGesture(ppv : MeListPanelView)
    func didStartOpenMeListPanel()
    func didFinishOpenMeListPanel()
    func didStartCloseMeListPanel(ppv : MeListPanelView)
    func didFinishCloseMeListPanel(ppv : MeListPanelView)
}

//test > new method with uiscrollview of feedcells
class MeListPanelView: PanelView, UIGestureRecognizerDelegate{
//    var panelLeadingCons: NSLayoutConstraint?
//    var currentPanelLeadingCons : CGFloat = 0.0
    var panel = UIView()
    var tabDataList = [String]()
    
    weak var delegate : MeListPanelDelegate?
    
    let aStickyHeader = UIView()
    
    let feedScrollView = UIScrollView()
    var feedList = [ScrollFeedHResultListCell]()
    
//    var tabList = [UIView]()
    var tabList = [TabStack]()
    let tabSelect = UIView()
    var tabSelectLeadingCons: NSLayoutConstraint?
    var tabSelectWidthCons: NSLayoutConstraint?
    var stackviewUsableLength = 0.0
    let tabScrollView = UIScrollView()
    let stackView = UIView()
//    let tabScrollMargin = 90.0 //20, 0, 50
    let tabScrollMargin = 0.0
    
    var currentIndex = 0
    
    var currentTabSelectLeadingCons = 0.0
    var tempCurrentIndex = 0
    
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    //test > user login/out status
    var isUserLoggedIn = false
    let aLoggedOutBox = UIView()
    
    //test > circle mask
    var cView = UIView()
    var offsetX: CGFloat = 0.0
    var offsetY: CGFloat = 0.0
    var panelLeadingCons: NSLayoutConstraint?
    var currentPanelLeadingCons : CGFloat = 0.0
    var panelTopCons: NSLayoutConstraint?
    var currentPanelTopCons : CGFloat = 0.0
    
    //test > scroll view for carousel
    var isCarouselScrolled = false
    let aTitleText = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewWidth = frame.width
        viewHeight = frame.height
        setupViews()
        setupMaskLayer()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViews()
        setupMaskLayer()
    }
    
    //test > masking into a circle like in snapmap
    let shapeLayer = CAShapeLayer()
    var isSubLayerSet = false
    func setupMaskLayer(){
        shapeLayer.fillColor = UIColor.white.cgColor
        panel.layer.addSublayer(shapeLayer)

        panel.layer.mask = shapeLayer
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)

        print("circle mask layout sublayer")

        //isSubLayerSet is to prevent repeated calling of layoutSublayers()
        if(!isSubLayerSet) {
            let width = viewWidth
//            let height = viewHeight + 100 //ori => 100 is arbitrary
//            let height = viewHeight //circle is too small, cannot fully cover phone screen

            let sum2 = pow(width, 2) + pow(viewHeight, 2)
            let height = sqrt(sum2)
            print("sumsqrt: \(height), \(viewHeight)")
            
            let oriX = width/2 - height/2 //default 200
    //        let oriY = height/2 - height/2
            let oriY = viewHeight/2 - height/2
            let circlePath = UIBezierPath(ovalIn: CGRect(x: oriX, y: oriY, width: height, height: height))
            shapeLayer.path = circlePath.cgPath

            isSubLayerSet = true
        }
    }
    
    func setupViews() {
        cView.backgroundColor = .black
        self.addSubview(cView)
        cView.layer.opacity = 0.0
        cView.translatesAutoresizingMaskIntoConstraints = false
        cView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        cView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        cView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true //default 0
        cView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        
        panel.backgroundColor = .ddmBlackOverlayColor
        self.addSubview(panel)
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.layer.masksToBounds = true
        panel.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        panel.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        panelTopCons = panel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        panelTopCons?.isActive = true
        panelLeadingCons = panel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
        panelLeadingCons?.isActive = true
        
        let aStickyHeader = UIView()
//        aStickyHeader.backgroundColor = .ddmBlackOverlayColor
        panel.addSubview(aStickyHeader)
        aStickyHeader.translatesAutoresizingMaskIntoConstraints = false
        aStickyHeader.trailingAnchor.constraint(equalTo: panel.trailingAnchor).isActive = true
        aStickyHeader.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        aStickyHeader.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        aStickyHeader.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 0).isActive = true
//        aStickyHeader.isHidden = true
        
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
//        aBtn.layer.opacity = 0.3
        aBtn.isUserInteractionEnabled = true
        aBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackPanelClicked)))

        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_arrow_left")?.withRenderingMode(.alwaysTemplate))
        bMiniBtn.tintColor = .white
        aStickyHeader.addSubview(bMiniBtn)
        bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        bMiniBtn.centerXAnchor.constraint(equalTo: aBtn.centerXAnchor).isActive = true
        bMiniBtn.centerYAnchor.constraint(equalTo: aBtn.centerYAnchor).isActive = true
        bMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        bMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        
//        let aTitleText = UILabel()
        aTitleText.textAlignment = .center
        aTitleText.textColor = .white
        aTitleText.font = .boldSystemFont(ofSize: 14)
//        aSemiTransparentTextBox.addSubview(aSemiTransparentText)
        aStickyHeader.addSubview(aTitleText)
        aTitleText.translatesAutoresizingMaskIntoConstraints = false
        aTitleText.topAnchor.constraint(equalTo: aBtn.topAnchor, constant: 0).isActive = true
        aTitleText.bottomAnchor.constraint(equalTo: aBtn.bottomAnchor, constant: 0).isActive = true
        aTitleText.centerXAnchor.constraint(equalTo: aStickyHeader.centerXAnchor, constant: 0).isActive = true
        aTitleText.text = "-" //Profile
        
//        tabDataList.append("f") //follow
//        tabDataList.append("fr") //follower
        
        //test ** > uiscrollview
        panel.addSubview(tabScrollView)
        tabScrollView.backgroundColor = .clear //clear
        tabScrollView.translatesAutoresizingMaskIntoConstraints = false
        tabScrollView.heightAnchor.constraint(equalToConstant: 40).isActive = true //ori 60
        tabScrollView.topAnchor.constraint(equalTo: aStickyHeader.bottomAnchor, constant: 0).isActive = true
//        tabScrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true //10
        tabScrollView.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: tabScrollMargin).isActive = true
        tabScrollView.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -tabScrollMargin).isActive = true
        tabScrollView.showsHorizontalScrollIndicator = false
        tabScrollView.alwaysBounceHorizontal = true //test
        //**

        stackView.backgroundColor = .clear //clear
        tabScrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.heightAnchor.constraint(equalToConstant: 40).isActive = true //ori 30
        stackView.topAnchor.constraint(equalTo: tabScrollView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: tabScrollView.leadingAnchor, constant: 10).isActive = true
//
//        aHighlight.backgroundColor = .yellow
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
        aHighlightInner.widthAnchor.constraint(equalToConstant: 30).isActive = true
        aHighlightInner.centerYAnchor.constraint(equalTo: tabSelect.centerYAnchor).isActive = true
        aHighlightInner.centerXAnchor.constraint(equalTo: tabSelect.centerXAnchor).isActive = true
        
        panel.addSubview(feedScrollView)
        feedScrollView.backgroundColor = .clear //clear
        feedScrollView.translatesAutoresizingMaskIntoConstraints = false
        feedScrollView.topAnchor.constraint(equalTo: tabScrollView.bottomAnchor, constant: 10).isActive = true
        feedScrollView.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: 0).isActive = true //0
        feedScrollView.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 0).isActive = true
        feedScrollView.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: 0).isActive = true
        feedScrollView.showsHorizontalScrollIndicator = false
        feedScrollView.alwaysBounceHorizontal = true //test
        feedScrollView.isPagingEnabled = true
        feedScrollView.delegate = self
        
        //test > logged out UI
//        let aLoggedOutBox = UIView()
        panel.addSubview(aLoggedOutBox)
        aLoggedOutBox.translatesAutoresizingMaskIntoConstraints = false
//        aLoggedOutBox.topAnchor.constraint(equalTo: aSemiTransparentTextBox.topAnchor, constant: 0).isActive = true
        aLoggedOutBox.centerYAnchor.constraint(equalTo: panel.centerYAnchor, constant: -90).isActive = true
        aLoggedOutBox.leadingAnchor.constraint(equalTo: panel.leadingAnchor).isActive = true
        aLoggedOutBox.trailingAnchor.constraint(equalTo: panel.trailingAnchor).isActive = true
//        aLoggedOutBox.isHidden = false
        aLoggedOutBox.isHidden = true
        
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
        aFollow.leadingAnchor.constraint(equalTo: aLoggedOutBox.leadingAnchor, constant: 100).isActive = true
        aFollow.trailingAnchor.constraint(equalTo: aLoggedOutBox.trailingAnchor, constant: -100).isActive = true
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
        aFollowText.centerXAnchor.constraint(equalTo: aFollow.centerXAnchor).isActive = true
        aFollowText.centerYAnchor.constraint(equalTo: aFollow.centerYAnchor).isActive = true
        aFollowText.text = "Login"
        
        //test > gesture recognizer for dragging user panel
        let panelPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onPanelPanGesture))
//        self.addGestureRecognizer(panelPanGesture)
        
        panelPanGesture.delegate = self
        feedScrollView.addGestureRecognizer(panelPanGesture)
    }
    
    //test
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer is UIPanGestureRecognizer) {
            return true
//            return false
        } else {
            return false
        }
    }
    
    @objc func onBackPanelClicked(gesture: UITapGestureRecognizer) {
        closePanel(isAnimated: true)
    }
    
    @objc func onABtnClicked(gesture: UITapGestureRecognizer) {

    }
    
    @objc func onFollowClicked(gesture: UITapGestureRecognizer) {
//        delegate?.didNotifyClickLogin()
    }
    
    //test
    override func resumeActiveState() {
        print("mefollowlistpanelview resume active")
        
        //test > check for signin status when in active state
        asyncFetchSigninStatus()
        //test
        dehideCurrentCell()
    }
    
    func dehideCurrentCell() {
        if(!feedList.isEmpty) {
            let feed = self.feedList[currentIndex]
            if let b = feed as? ScrollFeedHResultVideoListCell {
                b.dehideCell()
            }
            else if let c = feed as? ScrollFeedHResultPhotoListCell {
                c.dehideCell()
            }
            else if let c = feed as? ScrollFeedHResultPostListCell {
                c.dehideCell()
            }
        }
    }
    
    var meType = ""
    func setType(type: String) {
        meType = type
        if(type == "fr") {
            aTitleText.text = "Follows"
            tabDataList.append("f") //follow
            tabDataList.append("fr") //follower
        } else if(type == "h") {
            aTitleText.text = "History"
            tabDataList.append("pu_post") //posts
            tabDataList.append("pu_loop") //video
            tabDataList.append("pu_shot") //shot
        } else if(type == "s") {
            aTitleText.text = "Saves"
            tabDataList.append("pu_post") //posts
            tabDataList.append("pu_loop") //video
            tabDataList.append("pu_shot") //shot
            tabDataList.append("pu_location") //location
            tabDataList.append("pu_sound") //sound
        } else if(type == "l") {
            aTitleText.text = "Likes"
            tabDataList.append("pu_post") //posts
            tabDataList.append("pu_loop") //video
            tabDataList.append("pu_shot") //shot
        } else if(type == "lo") {
            aTitleText.text = "Locations"
            tabDataList.append("pu_location")
            tabDataList.append("pr_location")
        } else if(type == "c") {
            aTitleText.text = "Posts"
            tabDataList.append("pu_post")
            tabDataList.append("pr_post")
        } else if(type == "a") {
            aTitleText.text = "Shots"
            tabDataList.append("pu_shot")
            tabDataList.append("pr_shot")
        } else if(type == "b") {
            aTitleText.text = "Loops"
            tabDataList.append("pu_loop")
            tabDataList.append("pr_loop")
        }
    }
    
    var direction = "na"
    //test > another variable for threshold to shrink postpanel, instead of normal scroll
    var isToPostPan = false
    @objc func onPanelPanGesture(gesture: UIPanGestureRecognizer) {
        if(gesture.state == .began) {
            
            print("t1 onPanelPanGesture begin: ")

            //test
            currentPanelTopCons = panelTopCons!.constant
            currentPanelLeadingCons = panelLeadingCons!.constant
        } else if(gesture.state == .changed) {
            let translation = gesture.translation(in: self)
            let x = translation.x
            let y = translation.y
            
            //test > determine direction of scroll
            if(currentIndex == 0) {
                if(direction == "na") {
                    if(abs(x) > abs(y)) {
                        direction = "x"
                    } else {
                        direction = "y"
                    }
                }
                if(direction == "x") {
    //                if(abs(x) > 40) {
                    if(x > 40) {
                        print("postpanel vcv panning exit")
                        
                        //test > include carousel
                        if(!isCarouselScrolled) {
                            isToPostPan = true
                        }
                    } else {
                        print("postpanel vcv panning no exit")
                    }
                }
            }
            
            //test > panning panel exit once x-threshold reached
            if(isToPostPan) {
                let distLimit = 100.0
                let minScale = 0.5
                let maxCornerRadius = 200.0
                let x2 = pow(x, 2)
                let y2 = pow(y, 2)
                let dist = sqrt(x2 + y2)
                print("onPan change circle mask: \(dist), \(currentPanelTopCons), \(currentPanelLeadingCons)")

                let width = viewWidth
                let height = viewHeight
                var newMaskSize = height + ((100 - height)/distLimit * dist)
                if(newMaskSize < 100) {
                    newMaskSize = 100
                }

                print("onPan change mask: \(newMaskSize), \(viewHeight), \(viewWidth)")
                let oriX = width/2 - newMaskSize/2 //default 200
                let oriY = height/2 - newMaskSize/2
                let circlePath = UIBezierPath(ovalIn: CGRect(x: oriX, y: oriY, width: newMaskSize, height: newMaskSize))
                shapeLayer.path = circlePath.cgPath

                var newMaskBGOpacity = 1.0 + ((0.0 - 1.0)/distLimit * dist)
                cView.layer.opacity = Float(newMaskBGOpacity)

                if(newMaskSize <= viewWidth){
                    panelTopCons?.constant = currentPanelTopCons + y
                    panelLeadingCons?.constant = currentPanelLeadingCons + x
                } else {
                    //test > move back to 0, 0
                    panelTopCons?.constant = 0.0
                    panelLeadingCons?.constant = 0.0
                }
            }
        } else if(gesture.state == .ended){
            
            print("t1 onPanelPanGesture ended: ")
            //test
            let width = viewWidth
            let height = viewHeight + 100

            let distLimit = 100.0 //default : 50
            let x2 = pow(panelLeadingCons!.constant, 2)
            let y2 = pow(panelTopCons!.constant, 2)
            let dist = sqrt(x2 + y2)

            if(dist >= distLimit) {
                self.delegate?.didStartCloseMeListPanel(ppv: self)

            } else {
                let oriX = width/2 - height/2 //default 200
                let oriY = viewHeight/2 - height/2
                let circlePath = UIBezierPath(ovalIn: CGRect(x: oriX, y: oriY, width: height, height: height))
                shapeLayer.path = circlePath.cgPath

                //test > move back to 0, 0
                panelTopCons?.constant = 0.0
                panelLeadingCons?.constant = 0.0

                //test
                self.delegate?.didEndMeListPanGesture(ppv: self)
            }
            
            //test > determine direction of scroll
            direction = "na"
            
            //test
            isToPostPan = false
        }
    }
    
    //test > initialization state
    var isInitialized = false
    func initializePanel() {
        
        if(!isInitialized) {
            
            //redraw UI
            layoutTabUI()
            
            if(isUserLoggedIn) {
                aLoggedOutBox.isHidden = true
            } else {
                aLoggedOutBox.isHidden = false
            }
            
            //start fetch data
            self.asyncInit(id: "search_term")
        }
            
        isInitialized = true
    }
    func initialize() {
        //test
        asyncFetchSigninStatus()
    }
    
    //test > destroy cell
    func destroyCell() {
        if(!self.feedList.isEmpty) {
            let b = feedList[currentIndex]
            b.destroyCell()
        }
    }
    
    var isToClosePanel = false
    func closePanel(isAnimated: Bool) {
        
        isToClosePanel = true
        
        if(isAnimated) {
            
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
                self.panel.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                    .concatenating(CGAffineTransform(translationX: self.offsetX, y: self.offsetY))
                self.panel.layer.cornerRadius = 200

            }, completion: { finished in
                //test > stop video before closing panel
                self.destroyCell()
                
                self.removeFromSuperview()

                self.delegate?.didFinishCloseMeListPanel(ppv : self)
            })
        } else {
            //test > stop video before closing panel
            self.destroyCell()
//            self.pausePlayingMedia()
            
            self.removeFromSuperview()
            
//            self.delegate?.didClickPostDetailClosePanel()
            self.delegate?.didFinishCloseMeListPanel(ppv : self)
        }
    }
    
    func open(offX: CGFloat, offY: CGFloat, delay: CGFloat, isAnimated: Bool) {

        //test > make video panel return to original size
        self.panel.transform = CGAffineTransform.identity
        panelTopCons?.constant = 0
        panelLeadingCons?.constant = 0
        self.panel.layer.cornerRadius = 10

        if(isAnimated) {
            self.delegate?.didStartOpenMeListPanel()

            offsetX = offX
            offsetY = offY

            self.panel.layer.cornerRadius = 200 //default: 10
            self.panel.transform = CGAffineTransform(scaleX: 0.001, y: 0.001).concatenating(CGAffineTransform(translationX: offX, y: offY))
            UIView.animate(withDuration: 0.2, delay: delay, options: [.curveEaseInOut], //default: 0.2
                animations: {
                self.panel.transform = CGAffineTransform.identity
                self.panel.layer.cornerRadius = 10
                
            }, completion: { finished in
                self.delegate?.didFinishOpenMeListPanel()

                //test
                self.initialize()
            })
        }
    }
    
    func layoutTabUI() {
        
        for d in tabDataList {
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
            if(!tabList.isEmpty && tabList.count == tabDataList.count) {
                stack.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0).isActive = true
            }
            //test > if less than 3 tabs, can split width of tab to two equal parts
            let tabCount = tabDataList.count
            var isTabWidthFixed = false
//            if(tabCount < 3) {
            if(tabCount == 2 || tabCount == 3) {
                let tabWidth = (viewWidth - tabScrollMargin*2)/CGFloat(tabCount)
                stack.widthAnchor.constraint(equalToConstant: tabWidth).isActive = true
                isTabWidthFixed = true
            }
            stack.setTabTextMargin(isTabWidthFixed: isTabWidthFixed)
            stack.setTabTypeSmall(isSmall: true)
            stack.setUIChange(isChange: false)
            stack.setArrowAdded(isArrowAdd: false)
            stack.delegate = self
            
            if(meType == "fr") {
                if(d == "f") {
                    stack.setText(code: d, d: "Following") //Messages
                } else if(d == "fr") {
                    stack.setText(code: d, d: "Followers")
                }
            } else if(meType == "h") {
                if(d == "pu_post") {
                    stack.setText(code: d, d: "Posts") //Messages
                } else if(d == "pu_loop") {
                    stack.setText(code: d, d: "Loops")
                } else if(d == "pu_shot") {
                    stack.setText(code: d, d: "Shots")
                }
            } else if(meType == "s") {
                if(d == "pu_post") {
                    stack.setText(code: d, d: "Posts") //Messages
                } else if(d == "pu_loop") {
                    stack.setText(code: d, d: "Loops")
                } else if(d == "pu_shot") {
                    stack.setText(code: d, d: "Shots")
                } else if(d == "pu_location") {
                    stack.setText(code: d, d: "Locations")
                } else if(d == "pu_sound") {
                    stack.setText(code: d, d: "Sounds")
                }
            } else if(meType == "l") {
                if(d == "pu_post") {
                    stack.setText(code: d, d: "Posts") //Messages
                } else if(d == "pu_loop") {
                    stack.setText(code: d, d: "Loops")
                } else if(d == "pu_shot") {
                    stack.setText(code: d, d: "Shots")
                }
            } else if(meType == "lo") {
                if(d == "pu_location") {
                    stack.setText(code: d, d: "Public") //Messages
                } else if(d == "pr_location") {
                    stack.setText(code: d, d: "Private")
                }
            } else if(meType == "c") {
                if(d == "pu_post") {
                    stack.setText(code: d, d: "Public") //Messages
                } else if(d == "pr_post") {
                    stack.setText(code: d, d: "Private")
                }
            } else if(meType == "a") {
                if(d == "pu_shot") {
                    stack.setText(code: d, d: "Public") //Messages
                } else if(d == "pr_shot") {
                    stack.setText(code: d, d: "Private")
                }
            } else if(meType == "b") {
                if(d == "pu_loop") {
                    stack.setText(code: d, d: "Public") //Messages
                } else if(d == "pr_loop") {
                    stack.setText(code: d, d: "Private")
                }
            }
        }
    }
    
    func redrawUI() {
        let viewWidth = self.frame.width
        let feedHeight = feedScrollView.frame.height
        for d in tabDataList {
            var stack: ScrollFeedHResultListCell?
            
            if(d == "f") {
                stack = ScrollFeedHResultUserListCell()
            } else if(d == "fr") {
                stack = ScrollFeedHResultUserListCell()
            } else if(d == "pu_post") {
                stack = ScrollFeedHResultPostListCell()
            } else if(d == "pr_post") {
                stack = ScrollFeedHResultPostListCell()
            } else if(d == "pu_shot") {
                stack = ScrollFeedHResultPhotoListCell()
            } else if(d == "pr_shot") {
                stack = ScrollFeedHResultPhotoListCell()
            } else if(d == "pu_loop") {
                stack = ScrollFeedHResultVideoListCell()
            } else if(d == "pr_loop") {
                stack = ScrollFeedHResultVideoListCell()
            } else if(d == "pu_location") {
                stack = ScrollFeedHResultLocationListCell()
            } else if(d == "pr_location") {
                stack = ScrollFeedHResultLocationListCell()
            } else if(d == "pu_sound") {
                stack = ScrollFeedHResultSoundListCell()
            } else if(d == "pr_sound") {
                stack = ScrollFeedHResultSoundListCell()
            }
            
            guard let stack = stack else {
                return
            }
            feedScrollView.addSubview(stack)
            stack.translatesAutoresizingMaskIntoConstraints = false
            if(feedList.isEmpty) {
                stack.leadingAnchor.constraint(equalTo: feedScrollView.leadingAnchor, constant: 0).isActive = true
            } else {
                let lastArrayE = feedList[feedList.count - 1]
                stack.leadingAnchor.constraint(equalTo: lastArrayE.trailingAnchor, constant: 0).isActive = true //20
            }
            stack.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
            stack.heightAnchor.constraint(equalToConstant: feedHeight).isActive = true
            feedList.append(stack)
            
            stack.initialize()
            stack.aDelegate = self
            //test > additional delegate
            stack.bDelegate = self
            
            //test > set code
            stack.setCode(code: d)
        }
        
        let tabCount = tabDataList.count
        feedScrollView.contentSize = CGSize(width: viewWidth * CGFloat(tabCount), height: feedHeight)
        print("mefollowlistpanel contentsize \(viewWidth * CGFloat(tabCount)), \(feedHeight)")
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
    
    func activateTabUI() {
        if(!self.tabList.isEmpty) {
            for l in self.tabList {
                self.stackviewUsableLength += l.frame.width
            }
//                        self.stackviewUsableLength += 10.0 //leading constraint on tabscrollview
            print("mefollowlistpanel tabstack usablewidth \(self.stackviewUsableLength)")
            self.tabScrollView.contentSize = CGSize(width: self.stackviewUsableLength, height: 40)

            let tab = self.tabList[0]
            self.tabSelectWidthCons?.constant = tab.frame.width
            self.tabSelect.isHidden = false
        }
        self.measureTabScroll()
        
        self.reactToTabSectionChange(index: self.currentIndex) //test
    }
    func asyncInit(id: String) {
        DataFetchManager.shared.fetchData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("mefollowlistpanel init api success \(id), \(l)")

                    guard let self = self else {
                        return
                    }
                    
                    //test > init tabscroll UI e.g. measure width
                    self.activateTabUI()
                    self.redrawUI()
                    
                    //test > async fetch feed
                    if(!self.feedList.isEmpty) {
                        let feed = self.feedList[self.currentIndex]
                        if(self.isUserLoggedIn) {
//                            self.asyncFetchFeed(cell: feed, id: "notify_feed")
                            self.asyncFetchFeed(cell: feed, id: self.getDataType(feedcode: feed.feedCode))
                        }
                    }
                }

                case .failure(_):
                    print("api fail")
                    break
            }
        }
    }
    
    //test > remove all UI when user sign out
    func deconfigurePanel() {
        
        if(!feedList.isEmpty) {
            for feed in feedList {
                feed.dataPaginateStatus = ""
                feed.vDataList.removeAll()
                feed.vCV?.reloadData()
                
                feed.removeFromSuperview()
            }
            feedList.removeAll()
        }
        
        if(!tabList.isEmpty) {
            for e in tabList {
                e.removeFromSuperview()
            }
            tabList.removeAll()
        }
        
        //reset to 0
        stackviewUsableLength = 0.0
    }
    
    //test > fetch data => temp fake data => try refresh data first
    func refreshFetchData() {
        if(!feedList.isEmpty) {
            let feed = feedList[currentIndex]
            feed.configureFooterUI(data: "")
            
            feed.dataPaginateStatus = ""
//            asyncFetchFeed(cell: feed, id: "notify_feed")
            asyncFetchFeed(cell: feed, id: getDataType(feedcode: feed.feedCode))
        }
    }
    
    func getDataType(feedcode: String) -> String{
        var t: String = ""
        if(feedcode == "f") {
            t = DataTypes.USER
        } else if(feedcode == "fr") {
            t = DataTypes.USER
        } else if(feedcode == "pu_post") {
            t = DataTypes.POST
        } else if(feedcode == "pr_post") {
            t = DataTypes.POST
        } else if(feedcode == "pu_shot") {
            t = DataTypes.SHOT
        } else if(feedcode == "pr_shot") {
            t = DataTypes.SHOT
        } else if(feedcode == "pu_loop") {
            t = DataTypes.LOOP
        } else if(feedcode == "pr_loop") {
            t = DataTypes.LOOP
        } else if(feedcode == "pu_location") {
            t = DataTypes.LOCATION
        } else if(feedcode == "pr_location") {
            t = DataTypes.LOCATION
        } else if(feedcode == "pu_sound") {
            t = DataTypes.SOUND
        } else if(feedcode == "pr_sound") {
            t = DataTypes.SOUND
        }
        return t
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
    
    func asyncFetchFeed(cell: ScrollFeedHResultListCell?, id: String) {

        cell?.vDataList.removeAll()
        cell?.vCV?.reloadData()

        cell?.aSpinner.startAnimating()
        cell?.bSpinner.stopAnimating()
        
        cell?.dataPaginateStatus = "fetch"

        let id_ = "u"
        let isPaginate = false
        DataFetchManager.shared.fetchFeedData(id: id, isPaginate: isPaginate) { [weak self]result in
//        DataFetchManager.shared.fetchFeedData(id: id_, isPaginate: isPaginate) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("mefollowlistpanel api success \(id), \(l)")

                    guard let feed = cell else {
                        return
                    }
                    
                    //test
                    feed.aSpinner.stopAnimating()
                    
                    //test 2 > new method
                    for i in l {
                        if let u = i as? UserDataset {
                            let uData = UserData()
                            uData.setData(rData: u)
                            feed.vDataList.append(uData)
                        }
                        else if let p = i as? PlaceDataset {
                            let pData = PlaceData()
                            pData.setData(rData: p)
                            feed.vDataList.append(pData)
                        }
                        else if let s = i as? SoundDataset {
                            let sData = SoundData()
                            sData.setData(rData: s)
                            feed.vDataList.append(sData)
                        }
                        else if let post = i as? PostDataset {
                            let postData = PostData()
                            postData.setData(rData: post)
                            feed.vDataList.append(postData)
                        }
                        else if let photo = i as? PhotoDataset {
                            let photoData = PhotoData()
                            photoData.setData(rData: photo)
                            feed.vDataList.append(photoData)
                        }
                        else if let video = i as? VideoDataset {
                            let videoData = VideoData()
                            videoData.setData(rData: video)
                            feed.vDataList.append(videoData)
                        }
                    }
                    feed.vCV?.reloadData()
                    
                    //test
                    if(l.isEmpty) {
                        print("postpanelscroll footer reuse configure")
                        feed.setFooterAaText(text: "No followers yet.")
                        feed.configureFooterUI(data: "na")
                    }
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    print("api fail")
                    cell?.aSpinner.stopAnimating()
                    
                    cell?.configureFooterUI(data: "e")
                }
                break
            }
        }
    }

    func asyncPaginateFetchFeed(cell: ScrollFeedHResultListCell?, id: String) {

        cell?.bSpinner.startAnimating()

        let id_ = "u"
        let isPaginate = true
        DataFetchManager.shared.fetchFeedData(id: id, isPaginate: isPaginate) { [weak self]result in
//        DataFetchManager.shared.fetchFeedData(id: id_, isPaginate: isPaginate) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("mefollowlistpanel api paginate success \(id), \(l), \(l.isEmpty)")

                    guard let feed = cell else {
                        return
                    }
                    if(l.isEmpty) {
                        feed.dataPaginateStatus = "end"
                    }

                    //test
                    feed.bSpinner.stopAnimating()
                    
                    //*test 3 > reload only appended data, not entire dataset
                    let dataCount = feed.vDataList.count
                    var indexPaths = [IndexPath]()
                    var j = 1
                    
                    //test 2 > new method
                    for i in l {
                        if let u = i as? UserDataset {
                            let uData = UserData()
                            uData.setData(rData: u)
                            feed.vDataList.append(uData)
                            
                            let idx = IndexPath(item: dataCount - 1 + j, section: 0)
                            indexPaths.append(idx)
                            j += 1
                        }
                        else if let p = i as? PlaceDataset {
                            let pData = PlaceData()
                            pData.setData(rData: p)
                            feed.vDataList.append(pData)
                            
                            let idx = IndexPath(item: dataCount - 1 + j, section: 0)
                            indexPaths.append(idx)
                            j += 1
                        }
                        else if let s = i as? SoundDataset {
                            let sData = SoundData()
                            sData.setData(rData: s)
                            feed.vDataList.append(sData)
                            
                            let idx = IndexPath(item: dataCount - 1 + j, section: 0)
                            indexPaths.append(idx)
                            j += 1
                        }
                        else if let post = i as? PostDataset {
                            let postData = PostData()
                            postData.setData(rData: post)
                            feed.vDataList.append(postData)
                            
                            let idx = IndexPath(item: dataCount - 1 + j, section: 0)
                            indexPaths.append(idx)
                            j += 1
                        }
                        else if let photo = i as? PhotoDataset {
                            let photoData = PhotoData()
                            photoData.setData(rData: photo)
                            feed.vDataList.append(photoData)
                            
                            let idx = IndexPath(item: dataCount - 1 + j, section: 0)
                            indexPaths.append(idx)
                            j += 1
                        }
                        else if let video = i as? VideoDataset {
                            let videoData = VideoData()
                            videoData.setData(rData: video)
                            feed.vDataList.append(videoData)
                            
                            let idx = IndexPath(item: dataCount - 1 + j, section: 0)
                            indexPaths.append(idx)
                            j += 1
                        }
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
    
    func asyncFetchSigninStatus() {
        SignInManager.shared.fetchStatus(id: "fetch_status") { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("mefollowlistpanel api success: \(l)")
                    guard let self = self else {
                        return
                    }
                    
                    let isSignedIn = l
                    
                    if(self.isInitialized) {
                        if(self.isUserLoggedIn != isSignedIn) {
                            self.isUserLoggedIn = isSignedIn
                            
                            self.deconfigurePanel()
                    
                            self.isInitialized = false
                            self.initializePanel()
                        }
                    } else {
                        self.isUserLoggedIn = isSignedIn
                        self.initializePanel()
                    }
                }

                case .failure(_):
                    print("api fail")
                    break
            }
        }
    }
}

extension MeListPanelView: UIScrollViewDelegate {
    
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
        }
        //*
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView == feedScrollView) {
            let xOffset = scrollView.contentOffset.x
            let viewWidth = self.frame.width
            let currentIndex = round(xOffset/viewWidth)

            if(!self.tabList.isEmpty) {
                let currentItemIndex = tempCurrentIndex
                let currentX = panel.frame.width * CGFloat(currentItemIndex)
                let currentTabWidth = tabList[currentItemIndex].frame.width
                var hOffsetX = 0.0
                if(xOffset >= currentX) {
                    var nextTabWidth = tabList[currentItemIndex].frame.width
                    if(currentItemIndex < tabList.count - 1) {
                        nextTabWidth = tabList[currentItemIndex + 1].frame.width
                    }
                    hOffsetX = (xOffset - currentX)/(panel.frame.width) * currentTabWidth + currentTabSelectLeadingCons
                    tabSelectLeadingCons?.constant = hOffsetX

                    let hWidth = (xOffset - currentX)/(panel.frame.width) * (nextTabWidth - currentTabWidth) + currentTabWidth
                    tabSelectWidthCons?.constant = hWidth
                }
                else if (xOffset < currentX) {
                    var prevTabWidth = tabList[currentItemIndex].frame.width
                    if(currentItemIndex > 0) {
                        prevTabWidth = tabList[currentItemIndex - 1].frame.width
                    }

                    hOffsetX = (xOffset - currentX)/(panel.frame.width) * prevTabWidth + currentTabSelectLeadingCons
                    tabSelectLeadingCons?.constant = hOffsetX

                    let hWidth = (xOffset - currentX)/(panel.frame.width) * (currentTabWidth - prevTabWidth) + currentTabWidth
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
                let feed = self.feedList[rIndex]
                if(feed.dataPaginateStatus == "") {
                    if(isUserLoggedIn) {
//                        self.asyncFetchFeed(cell: feed, id: "notify_feed")
                        asyncFetchFeed(cell: feed, id: getDataType(feedcode: feed.feedCode))
                    }
                }
            }
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if(scrollView == feedScrollView) {
            let xOffset = scrollView.contentOffset.x
            let viewWidth = self.frame.width
            print("mefollowlistpanel scroll decelerate \(xOffset), \(viewWidth)")
            
            currentIndex = Int(xOffset/viewWidth)

            reactToTabSectionChange(index: currentIndex)
        }
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if(scrollView == feedScrollView) {
            let xOffset = scrollView.contentOffset.x
            let viewWidth = self.frame.width
            
            currentIndex = Int(xOffset/viewWidth)
            
            //test > change tab title font opacity when scrolled
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
}

extension MeListPanelView: ScrollFeedCellDelegate {
    func sfcWillBeginDragging(offsetY: CGFloat) {

    }
    func sfcScrollViewDidScroll(offsetY: CGFloat) {

    }
    func sfcSrollViewDidEndDecelerating(offsetY: CGFloat) {

    }
    func sfcScrollViewDidEndDragging(offsetY: CGFloat, decelerate: Bool) {

        if(offsetY < -80) {
            if(isUserLoggedIn) {
                self.refreshFetchData()
            }
        }
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
    }
    func sfcDidClickVcvLove() {
        print("fcDidClickVcvLike ")
    }
    func sfcDidClickVcvShare(id: String, dataType: String) {
        print("fcDidClickVcvShare ")
    }

    func sfcDidClickVcvClickUser(id: String) {
        //test
        print("sfcDidClickVcvClickUser ")
        delegate?.didMeListClickUser(id: id)
    }
    func sfcDidClickVcvClickPlace(id: String) {
        delegate?.didMeListClickPlace(id: id)
    }
    func sfcDidClickVcvClickSound(id: String) {
        delegate?.didMeListClickSound(id: id)
    }
    func sfcDidClickVcvClickPost(id: String, dataType: String, pointX: CGFloat, pointY: CGFloat) {
        //test
        if(!feedList.isEmpty) {
            let b = self.feedList[self.currentIndex]
            let originInRootView = feedScrollView.convert(b.frame.origin, to: self)
            
            let adjustY = pointY + originInRootView.y
            delegate?.didMeListClickPost(id: id, dataType: dataType, pointX: pointX, pointY: adjustY)
        }
    }
    func sfcDidClickVcvClickPhoto(id: String, pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String) {
        //test
        if(!feedList.isEmpty) {
            let b = self.feedList[self.currentIndex]
            let originInRootView = feedScrollView.convert(b.frame.origin, to: self)
            
            let adjustY = pointY + originInRootView.y
            delegate?.didMeListClickPhoto(id: id, pointX: pointX, pointY: adjustY, view: view, mode: mode)
        }
    }
    func sfcDidClickVcvClickVideo(id: String, pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String) {
        //test
        if(!feedList.isEmpty) {
            let b = self.feedList[self.currentIndex]
            let originInRootView = feedScrollView.convert(b.frame.origin, to: self)
            
            let adjustY = pointY + originInRootView.y
            delegate?.didMeListClickVideo(id: id, pointX: pointX, pointY: adjustY, view: view, mode: mode)
        }
    }

    //test
    func sfcAsyncFetchFeed() {

    }
    func sfcAsyncPaginateFeed(cell: ScrollFeedCell?) {
        //test
        print("feedhresultlistcell real paginate async")
        if let d = cell as? ScrollFeedHResultListCell {
            if(isUserLoggedIn) {
                self.asyncPaginateFetchFeed(cell: d, id: "notify_feed_end")
            }
        }
    }
    
    func sfcIsScrollCarousel(isScroll: Bool) {
        isCarouselScrolled = isScroll
    }
    
    func sfcAutoplayVideo(cell: ScrollFeedCell?, vCCell: UICollectionViewCell?) {
//    func sfcAutoplayVideo(cell: ScrollFeedCell?, vCCell: HPostListAViewCell?) {
        
    }
}

//test > additional delegate
extension MeListPanelView: ScrollFeedHResultListCellDelegate {
    func didScrollFeedHResultClickSignIn() {
        delegate?.didMeListClickSignIn()
    }
    
    func didScrollFeedHResultResignKeyboard(){
    }
}

extension MeListPanelView: TabStackDelegate {
    func didClickTabStack(tabCode: String, isSelected: Bool) {
        if let index = tabDataList.firstIndex(of: tabCode) {
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

//test
extension ViewController: MeListPanelDelegate{

    func didMeListClickUser(id: String) {
        print("mefollow openuserpanel ")
//        openUserPanel()
        //test > real id for fetching data
        openUserPanel(id: id)
    }
    func didMeListClickClose() {
//        backPage(isCurrentPageScrollable: false)
    }
    func didMeListClickSignIn(){
        openLoginPanel()
    }
    func didMeListClickPost(id: String, dataType: String, pointX: CGFloat, pointY: CGFloat) {
        //test > new method
        let offsetX = pointX - self.view.frame.width/2
        let offsetY = pointY - self.view.frame.height/2
        openPostDetailPanel(id: id, dataType: dataType, scrollToComment: false, offX: offsetX, offY: offsetY)
    }
    func didMeListClickPhoto(id: String, pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String){
        let offsetX = pointX - self.view.frame.width/2
        let offsetY = pointY - self.view.frame.height/2
        
        if(mode == PhotoTypes.P_SHOT_DETAIL) {
//        if(mode == PhotoTypes.P_SHOT) {
            //test 2 > animated open and close panel
            openPhotoDetailPanel(id: id, offX: offsetX, offY: offsetY)
        } else if(mode == PhotoTypes.P_0){
            openPhotoZoomPanel(offX: offsetX, offY: offsetY)
        }
    }
    func didMeListClickVideo(id: String, pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String){
        let offsetX = pointX - self.view.frame.width/2
        let offsetY = pointY - self.view.frame.height/2

        //test 1 > for video only
        var dataset = [String]()
//        dataset.append("a")
        dataset.append("a")
        self.openVideoPanel(offX: offsetX, offY: offsetY, originatorView: view, originatorViewType: OriginatorTypes.UIVIEW, id: 0, originatorViewId: "", preterminedDatasets: dataset, mode: mode)
    }
    func didMeListClickPlace(id: String){
        //test > real id for fetching data
        openPlacePanel(id: id)
    }
    func didMeListClickSound(id: String){
        //test > real id for fetching data
        openSoundPanel(id: id)
    }
    
    //test > for marker animation after video closes
    func didStartMeListPanGesture(ppv : MeListPanelView) {
        
    }
    func didEndMeListPanGesture(ppv : MeListPanelView) {
        
    }
    func didStartOpenMeListPanel(){}
    func didFinishOpenMeListPanel(){}
    func didStartCloseMeListPanel(ppv : MeListPanelView) {
        ppv.offsetX = ppv.offsetX - ppv.panelLeadingCons!.constant
        ppv.offsetY = ppv.offsetY - ppv.panelTopCons!.constant

        ppv.closePanel(isAnimated: true)
    }
    func didFinishCloseMeListPanel(ppv : MeListPanelView){
        backPage(isCurrentPageScrollable: false)
    }
}

