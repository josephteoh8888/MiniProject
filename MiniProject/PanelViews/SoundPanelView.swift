//
//  MeLocationListPanelView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 20/07/2024.
//

import Foundation
import UIKit
import SDWebImage
import GoogleMaps

protocol SoundPanelDelegate : AnyObject {
    func didSoundClickUser(id: String)
    func didSoundClickPlace(id: String)
    func didSoundClickSound(id: String, pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String)
    func didSoundClickPost(id: String, dataType: String, scrollToComment: Bool, pointX: CGFloat, pointY: CGFloat)
    func didStartOpenSoundPanel()
    func didFinishOpenSoundPanel()
    func didStartCloseSoundPanel(spv : SoundPanelView)
    func didFinishCloseSoundPanel(spv : SoundPanelView)

    //test > for marker animation after video closes
    func didStartSoundPanGesture(spv : SoundPanelView)
    func didEndSoundPanGesture(spv : SoundPanelView)
    
    func didClickSoundPanelClickPhoto(id: String, pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String) //try
    func didClickSoundPanelClickVideo(id: String, pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String) //try
    
    //test > click to create new post
    func didClickSoundPanelVcvClickCreate(type: String, objectType: String, objectId: String)
}

class SoundPanelView: PanelView, UIGestureRecognizerDelegate{
    
    var soundPanel = UIView()
    var vcDataList = [String]()
    
    weak var delegate : SoundPanelDelegate?

    var soundPanelTopCons: NSLayoutConstraint?
    var soundPanelLeadingCons: NSLayoutConstraint?
    var currentSoundTopCons : CGFloat = 0.0
    var currentSoundLeadingCons : CGFloat = 0.0

    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0

    var offsetX: CGFloat = 0.0
    var offsetY: CGFloat = 0.0

    let aStickyHeader = UIView()

    //test > black out
    let blackBox = UIView()
    var isTypeBlackOut = false //default: not blackout when close()

    //test > coordinates realignment when close video due to random user swiping
    var coordinateLocation : CLLocationCoordinate2D?
    var id = -1 //queue Id
    var originatorViewType = ""
    var adjustmentX: CGFloat = 0.0
    var adjustmentY: CGFloat = 0.0

    //test > comment textview
    var aView = UIView()
    var textPanelBottomCons: NSLayoutConstraint?
    var aTextBoxHeightCons: NSLayoutConstraint?
    let aTextBox = UITextView()
    var aaViewTrailingCons: NSLayoutConstraint?
    let sendAaView = UIView()
    var sendAaViewTrailingCons: NSLayoutConstraint?
    let textPanel = UIView()
    var currentFirstResponder : UITextView?
    var isKeyboardUp = false
    let bottomBox = UIView()
    let sendBox = UIView()
    let aaView = UIView()
    let xGrid = UIView()
    let bbText = UILabel()
    let addCommentContainer = UIView()
    let sendCommentContainer = UIView()
    let sendASpinner = SpinLoader()
    let sendBText = UILabel()
    let sendBBox = UIView()
    
    //test > circle mask
    var cView = UIView()
    
    //test > marker id
    var originatorViewId = ""

    //test > check whether video panel is opened
    var isPanelOpen = false
    
    //test > section tabs
    var tabList = [TabStack]()
    let tabSelect = UIView()
    var tabSelectLeadingCons: NSLayoutConstraint?
    var tabSelectWidthCons: NSLayoutConstraint?
    var stackviewUsableLength = 0.0
    let tabScrollView = UIScrollView()
    let stackView = UIView()
    let tabScrollMargin = 90.0
    
    var currentTabSelectLeadingCons = 0.0
    var tempCurrentIndex = 0
    
    let feedScrollView = UIScrollView()
    var feedList = [ScrollFeedSoundCell]()
    var currentIndex = 0

    let tabScrollLHSBtn = UIView()
    let tabScrollRHSBtn = UIView()
    
    var isMultipleTab = false
    var predeterminedDatasets = [SoundDataset]() //test > real data structure
    var uiMode = SoundTypes.S_VOICE
    
    //test > track comment scrollable view
    var pageList = [PanelView]()
    
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
//        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        soundPanel.layer.addSublayer(shapeLayer)

        soundPanel.layer.mask = shapeLayer
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

        soundPanel.backgroundColor = .ddmBlackOverlayColor
        self.addSubview(soundPanel)
        soundPanel.translatesAutoresizingMaskIntoConstraints = false
        soundPanel.layer.masksToBounds = true
        //test
        soundPanel.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        soundPanel.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        soundPanelTopCons = soundPanel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        soundPanelTopCons?.isActive = true
        soundPanelLeadingCons = soundPanel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
        soundPanelLeadingCons?.isActive = true
        
        soundPanel.addSubview(feedScrollView)
        feedScrollView.backgroundColor = .ddmBlackOverlayColor
//        feedScrollView.backgroundColor = .black
        feedScrollView.translatesAutoresizingMaskIntoConstraints = false
        feedScrollView.topAnchor.constraint(equalTo: soundPanel.topAnchor).isActive = true
//        feedScrollView.bottomAnchor.constraint(equalTo: videoPanel.bottomAnchor, constant: -94).isActive = true
        feedScrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true //-60 is bottom container for entering comment etc
        feedScrollView.leadingAnchor.constraint(equalTo: soundPanel.leadingAnchor, constant: 0).isActive = true
        feedScrollView.trailingAnchor.constraint(equalTo: soundPanel.trailingAnchor, constant: 0).isActive = true
        feedScrollView.showsHorizontalScrollIndicator = false
        feedScrollView.alwaysBounceHorizontal = true //test
        feedScrollView.isPagingEnabled = true
        feedScrollView.delegate = self
        
        //test > sticky header => for "for you", "following", "subscribing"
        aStickyHeader.backgroundColor = .clear
        soundPanel.addSubview(aStickyHeader)
        aStickyHeader.translatesAutoresizingMaskIntoConstraints = false
        aStickyHeader.trailingAnchor.constraint(equalTo: soundPanel.trailingAnchor).isActive = true
        aStickyHeader.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        aStickyHeader.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        aStickyHeader.leadingAnchor.constraint(equalTo: soundPanel.leadingAnchor, constant: 0).isActive = true
        
        //**test bottom comment box => fake edittext
//        setupCommentTextboxUI()
        //**

        //test > black out when close
//        let blackBox = UIView()
        blackBox.backgroundColor = .white
        soundPanel.addSubview(blackBox)
        blackBox.clipsToBounds = true
        blackBox.translatesAutoresizingMaskIntoConstraints = false
        blackBox.leadingAnchor.constraint(equalTo: soundPanel.leadingAnchor, constant: 0).isActive = true
        blackBox.trailingAnchor.constraint(equalTo: soundPanel.trailingAnchor, constant: 0).isActive = true
        blackBox.topAnchor.constraint(equalTo: soundPanel.topAnchor, constant: 0).isActive = true
        blackBox.bottomAnchor.constraint(equalTo: soundPanel.bottomAnchor, constant: 0).isActive = true
        blackBox.isUserInteractionEnabled = false
        blackBox.layer.opacity = 0
        
        //test > vcv gesture
        let vPanelPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onVCVPanGesture))
        vPanelPanGesture.delegate = self //for simultaneous pan recognizer for uicollectionview
        feedScrollView.addGestureRecognizer(vPanelPanGesture)
    }
    
    //test
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer is UIPanGestureRecognizer) {
            return true
        } else {
            return false
        }
    }
    
    //test > another variable for threshold to shrink postpanel, instead of normal scroll
    var direction = "na"
    var isToPostPan = false
    @objc func onVCVPanGesture(gesture: UIPanGestureRecognizer) {
        if(gesture.state == .began) {
//            if(vcDataList.count > 1) {
                if(currentIndex == 0 || currentIndex == vcDataList.count - 1) {
                    
                    currentSoundTopCons = soundPanelTopCons!.constant
                    currentSoundLeadingCons = soundPanelLeadingCons!.constant

                    //test
                    self.delegate?.didStartSoundPanGesture(spv: self)
                }
//            }
        } else if(gesture.state == .changed) {
            let translation = gesture.translation(in: self)
            let x = translation.x
            let y = translation.y

            let velocity = gesture.velocity(in: self)
            
            if(vcDataList.count > 1) {
                if(currentIndex == 0) {
                    //test > determine direction of scroll
                    if(direction == "na") {
                        if(abs(x) > abs(y)) {
                            direction = "x"
                        } else {
                            direction = "y"
                        }
                    }
                    if(direction == "x") {
//                        if(abs(x) > 40) {
                        if(x > 40) {
                            print("postpanel vcv panning exit")
                            isToPostPan = true
                        } else {
                            print("postpanel vcv panning no exit")
                        }
                    }
                }
                else if (currentIndex == vcDataList.count - 1) {
                    if(direction == "na") {
                        if(abs(x) > abs(y)) {
                            direction = "x"
                        } else {
                            direction = "y"
                        }
                    }
                    if(direction == "x") {
//                        if(abs(x) > 40) {
                        if(x < -40) {
                            print("postpanel vcv panning exit")
                            isToPostPan = true
                        } else {
                            print("postpanel vcv panning no exit")
                        }
                    }
                }
            }
            else {
                if(currentIndex == 0) {
                    //test > determine direction of scroll
                    if(direction == "na") {
                        if(abs(x) > abs(y)) {
                            direction = "x"
                        } else {
                            direction = "y"
                        }
                    }
                    if(direction == "x") {
                        if(abs(x) > 40) {
//                        if(x > 40) {
                            print("postpanel vcv panning exit")
                            isToPostPan = true
                        } else {
                            print("postpanel vcv panning no exit")
                        }
                    }
                }
            }
            if(isToPostPan) {
                let distLimit = 100.0
                let minScale = 0.5
                let maxCornerRadius = 200.0
                let x2 = pow(x, 2)
                let y2 = pow(y, 2)
                let dist = sqrt(x2 + y2)
                print("onPan change circle mask: \(dist), \(currentSoundTopCons), \(currentSoundLeadingCons)")

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
                    soundPanelTopCons?.constant = currentSoundTopCons + y
                    soundPanelLeadingCons?.constant = currentSoundLeadingCons + x
                } else {
                    //test > move back to 0, 0
                    soundPanelTopCons?.constant = 0.0
                    soundPanelLeadingCons?.constant = 0.0
                }
            }
        }
        else if(gesture.state == .ended){
           
           //test => if count == 1, onsoundpanelgesture will be triggered too, then conflict, video panel will pause
//           if(vcDataList.count > 1) {
               if(currentIndex == 0 || currentIndex == vcDataList.count - 1) {

                   let width = viewWidth
                   let height = viewHeight + 100 //+100 for big circle mask

                   let distLimit = 100.0 //default : 50
                   let x2 = pow(soundPanelLeadingCons!.constant, 2)
                   let y2 = pow(soundPanelTopCons!.constant, 2)
                   let dist = sqrt(x2 + y2)

                   if(dist >= distLimit) {
                       self.delegate?.didStartCloseSoundPanel(spv: self)
                   } else {
                       let oriX = width/2 - height/2 //default 200
                       let oriY = viewHeight/2 - height/2
                       let circlePath = UIBezierPath(ovalIn: CGRect(x: oriX, y: oriY, width: height, height: height))
                       shapeLayer.path = circlePath.cgPath

                       //test > move back to 0, 0
                       soundPanelTopCons?.constant = 0.0
                       soundPanelLeadingCons?.constant = 0.0


                       //test
                       self.delegate?.didEndSoundPanGesture(spv: self)
                   }
               }
               
               //test > determine direction of scroll
               direction = "na"
               
               //test
               isToPostPan = false
//           }
       }
    }
    
    //test > redraw UI based on originator(from marker or mini app)
    func defineDataset() {
        if(isMultipleTab) {
            vcDataList.append("fy") //for you
//            vcDataList.append("f") //following
            vcDataList.append("e") //eats
        } else {
            vcDataList.append("a")
        }
    }
    
    func redrawUI() {
        if(isMultipleTab) {
//        if(originatorViewType == OriginatorTypes.MAP_VIDEO_MINIAPP_UIVIEW) {
            
            //test ** > uiscrollview
//            let tabScrollView = UIScrollView()
//            videoPanel.addSubview(tabScrollView)
            aStickyHeader.addSubview(tabScrollView)
            tabScrollView.backgroundColor = .clear //clear
            tabScrollView.translatesAutoresizingMaskIntoConstraints = false
            tabScrollView.heightAnchor.constraint(equalToConstant: 40).isActive = true //ori 60
            tabScrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
    //        tabScrollView.topAnchor.constraint(equalTo: aFollow.bottomAnchor, constant: 20).isActive = true
            tabScrollView.leadingAnchor.constraint(equalTo: soundPanel.leadingAnchor, constant: tabScrollMargin).isActive = true //70
            tabScrollView.trailingAnchor.constraint(equalTo: soundPanel.trailingAnchor, constant: -tabScrollMargin).isActive = true
            tabScrollView.showsHorizontalScrollIndicator = false
            tabScrollView.alwaysBounceHorizontal = true //test
    //        tabScrollView.isHidden = true
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
            aHighlightInner.widthAnchor.constraint(equalToConstant: 30).isActive = true
            aHighlightInner.centerYAnchor.constraint(equalTo: tabSelect.centerYAnchor).isActive = true
            aHighlightInner.centerXAnchor.constraint(equalTo: tabSelect.centerXAnchor).isActive = true
            
    //        let tabScrollLHSBtn = UIView()
            tabScrollLHSBtn.backgroundColor = .white
    //        tabScrollLHSBtn.backgroundColor = .red
//            videoPanel.addSubview(tabScrollLHSBtn)
            aStickyHeader.addSubview(tabScrollLHSBtn)
            tabScrollLHSBtn.translatesAutoresizingMaskIntoConstraints = false
            tabScrollLHSBtn.widthAnchor.constraint(equalToConstant: 14).isActive = true //ori: 40
            tabScrollLHSBtn.heightAnchor.constraint(equalToConstant: 14).isActive = true
            tabScrollLHSBtn.trailingAnchor.constraint(equalTo: tabScrollView.leadingAnchor, constant: -2).isActive = true
            tabScrollLHSBtn.centerYAnchor.constraint(equalTo: tabScrollView.centerYAnchor, constant: 0).isActive = true
            tabScrollLHSBtn.isUserInteractionEnabled = true
            tabScrollLHSBtn.layer.cornerRadius = 7
            tabScrollLHSBtn.isHidden = true
            tabScrollLHSBtn.layer.shadowColor = UIColor.gray.cgColor
            tabScrollLHSBtn.layer.shadowRadius = 3.0  //ori 3
            tabScrollLHSBtn.layer.shadowOpacity = 0.5 //ori 1
            tabScrollLHSBtn.layer.shadowOffset = CGSize(width: 1, height: 1) //2
            tabScrollLHSBtn.layer.opacity = 0.5
            
            let tabScrollLHSBoxBtn = UIImageView()
            tabScrollLHSBoxBtn.image = UIImage(named:"icon_round_arrow_left")?.withRenderingMode(.alwaysTemplate)
            tabScrollLHSBoxBtn.tintColor = .ddmBlackOverlayColor
            tabScrollLHSBtn.addSubview(tabScrollLHSBoxBtn)
            tabScrollLHSBoxBtn.translatesAutoresizingMaskIntoConstraints = false
            tabScrollLHSBoxBtn.centerXAnchor.constraint(equalTo: tabScrollLHSBtn.centerXAnchor).isActive = true
            tabScrollLHSBoxBtn.centerYAnchor.constraint(equalTo: tabScrollLHSBtn.centerYAnchor).isActive = true
            tabScrollLHSBoxBtn.heightAnchor.constraint(equalToConstant: 14).isActive = true
            tabScrollLHSBoxBtn.widthAnchor.constraint(equalToConstant: 14).isActive = true
            
    //        let tabScrollRHSBtn = UIView()
            tabScrollRHSBtn.backgroundColor = .white
    //        tabScrollRHSBtn.backgroundColor = .red
//            videoPanel.addSubview(tabScrollRHSBtn)
            aStickyHeader.addSubview(tabScrollRHSBtn)
            tabScrollRHSBtn.translatesAutoresizingMaskIntoConstraints = false
            tabScrollRHSBtn.widthAnchor.constraint(equalToConstant: 14).isActive = true //ori: 40
            tabScrollRHSBtn.heightAnchor.constraint(equalToConstant: 14).isActive = true
            tabScrollRHSBtn.leadingAnchor.constraint(equalTo: tabScrollView.trailingAnchor, constant: 2).isActive = true
            tabScrollRHSBtn.centerYAnchor.constraint(equalTo: tabScrollView.centerYAnchor, constant: 0).isActive = true
            tabScrollRHSBtn.isUserInteractionEnabled = true
            tabScrollRHSBtn.layer.cornerRadius = 7
            tabScrollRHSBtn.isHidden = true
            tabScrollRHSBtn.layer.shadowColor = UIColor.gray.cgColor
            tabScrollRHSBtn.layer.shadowRadius = 3.0  //ori 3
            tabScrollRHSBtn.layer.shadowOpacity = 0.5 //ori 1
            tabScrollRHSBtn.layer.shadowOffset = CGSize(width: 1, height: 1) //2
            tabScrollRHSBtn.layer.opacity = 0.5
            
            let tabScrollRHSBoxBtn = UIImageView()
            tabScrollRHSBoxBtn.image = UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate)
            tabScrollRHSBoxBtn.tintColor = .ddmBlackOverlayColor
            tabScrollRHSBtn.addSubview(tabScrollRHSBoxBtn)
            tabScrollRHSBoxBtn.translatesAutoresizingMaskIntoConstraints = false
            tabScrollRHSBoxBtn.centerXAnchor.constraint(equalTo: tabScrollRHSBtn.centerXAnchor).isActive = true
            tabScrollRHSBoxBtn.centerYAnchor.constraint(equalTo: tabScrollRHSBtn.centerYAnchor).isActive = true
            tabScrollRHSBoxBtn.heightAnchor.constraint(equalToConstant: 14).isActive = true
            tabScrollRHSBoxBtn.widthAnchor.constraint(equalToConstant: 14).isActive = true
            
            let addFeedBtn = UIView()
            addFeedBtn.backgroundColor = .clear
//            videoPanel.addSubview(addFeedBtn)
            aStickyHeader.addSubview(addFeedBtn)
            addFeedBtn.translatesAutoresizingMaskIntoConstraints = false
            addFeedBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
            addFeedBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
            addFeedBtn.trailingAnchor.constraint(equalTo: soundPanel.trailingAnchor, constant: -10).isActive = true
            addFeedBtn.centerYAnchor.constraint(equalTo: tabScrollView.centerYAnchor, constant: 0).isActive = true
            addFeedBtn.isUserInteractionEnabled = true
            addFeedBtn.isHidden = true
            
            let addBoxBtn = UIImageView()
            addBoxBtn.image = UIImage(named:"icon_outline_add_circle")?.withRenderingMode(.alwaysTemplate)
            addBoxBtn.tintColor = .white
            addFeedBtn.addSubview(addBoxBtn)
            addBoxBtn.translatesAutoresizingMaskIntoConstraints = false
            addBoxBtn.centerXAnchor.constraint(equalTo: addFeedBtn.centerXAnchor).isActive = true
            addBoxBtn.centerYAnchor.constraint(equalTo: addFeedBtn.centerYAnchor).isActive = true
            addBoxBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
            addBoxBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        }
    }
    
    //test
    func setDatasetUI(isMultiTab: Bool){
        
        isMultipleTab = isMultiTab
        
        //test > redraw UI based on originator(from marker or mini app)
        defineDataset()
        redrawUI()
        
        //test
        redrawScrollFeedUI()
    }
    
    func setPreterminedDatasets(datasets: [String]){
        //ori
//        predeterminedDatasets.append(contentsOf: datasets)
        
        //test 2
        for r in datasets {
            let vData = SoundDataset()
            vData.setupData(data: r)
            predeterminedDatasets.append(vData)
        }
    }
    
    func setUiMode(mode : String){
        uiMode = mode
        
        if(mode == SoundTypes.S_0) {
            bottomBox.isHidden = true
        }
    }
    
    func setOriginatorViewType(type : String){
        originatorViewType = type
    }
    func getOriginatorViewType() -> String {
        return originatorViewType
    }
    func setCoordinateLocation(coord: CLLocationCoordinate2D){
        coordinateLocation = coord
    }
    func setAdjustmentY(adY : CGFloat){
        adjustmentY = adY
    }
    func setTypeBlackOut(){
        isTypeBlackOut = true
    }
    func setId(id : Int){
        self.id = id
    }
    func getId() -> Int{
        return id
    }
    //test > marker id
    func setOriginatorId(originatorId : String){
        self.originatorViewId = originatorId
    }
    func getOriginatorId() -> String{
        return originatorViewId
    }
    
    func open(offX: CGFloat, offY: CGFloat, delay: CGFloat, isAnimated: Bool) {

        //test > make video panel return to original size
        self.soundPanel.transform = CGAffineTransform.identity
        soundPanelTopCons?.constant = 0
        soundPanelLeadingCons?.constant = 0
        self.soundPanel.layer.cornerRadius = 10

        if(isAnimated) {
            self.delegate?.didStartOpenSoundPanel()

            offsetX = offX
            offsetY = offY

            self.soundPanel.layer.cornerRadius = 200 //default: 10
            self.soundPanel.transform = CGAffineTransform(scaleX: 0.001, y: 0.001).concatenating(CGAffineTransform(translationX: offX, y: offY))
            UIView.animate(withDuration: 0.2, delay: delay, options: [.curveEaseInOut], //default: 0.2
                animations: {
                self.soundPanel.transform = CGAffineTransform.identity
                self.soundPanel.layer.cornerRadius = 10
                
                //test > single video view
                if(!self.predeterminedDatasets.isEmpty) {
                    self.asyncInitPredeterminedDatasets(dataset: self.predeterminedDatasets)
                }
            }, completion: { finished in
                self.delegate?.didFinishOpenSoundPanel()

                self.isPanelOpen = true

                print("soundCVpanel open video panel")

                //test > single video view
                if(self.predeterminedDatasets.isEmpty) {
                    self.initialize()
                }
            })
        }
    }

    func close(isAnimated: Bool) {
        //test > shrink video panel when touch
        if(isAnimated) {

            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
                self.soundPanel.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
//                self.videoPanel.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
                    .concatenating(CGAffineTransform(translationX: self.offsetX, y: self.offsetY))
                self.soundPanel.layer.cornerRadius = 200

                if(self.isTypeBlackOut) {
                    self.blackBox.layer.opacity = 1 //test
                }

            }, completion: { finished in
                //test > stop video before closing panel
                print("videopanel close anim")
//                self.stopPlayingMedia()
                self.destroyCell()
                //

                self.removeFromSuperview()

                self.delegate?.didFinishCloseSoundPanel(spv : self)

                self.isPanelOpen = false //test
            })
        } else {
            //test > stop video before closing panel
            print("videopanel close")
//            self.stopPlayingMedia()
            self.destroyCell()
            //

            self.removeFromSuperview()

            delegate?.didFinishCloseSoundPanel(spv : self)

            self.isPanelOpen = false //test
        }
    }
    
    //test > initialization state
    var isInitialized = false
    func initialize() {
        
        if(!isInitialized) {
            
            //redraw UI
            layoutTabUI()
            
            //start fetch data
            self.asyncInit(id: "search_term")
        }
        
        isInitialized = true
    }
    
    func layoutTabUI() {
        
        for d in vcDataList {
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
            if(!tabList.isEmpty && tabList.count == vcDataList.count) {
                stack.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0).isActive = true
            }
            //test > if less than 3 tabs, can split width of tab to two equal parts
            let tabCount = vcDataList.count
            var isTabWidthFixed = false
            if(tabCount < 3) {
                let tabWidth = (viewWidth - tabScrollMargin*2)/CGFloat(tabCount)
                stack.widthAnchor.constraint(equalToConstant: tabWidth).isActive = true
                isTabWidthFixed = true
            }
            stack.setTabTextMargin(isTabWidthFixed: isTabWidthFixed)
            
            stack.setShadow()
            stack.delegate = self
            
            if(d == "fy") {
                stack.setText(code: d, d: "For You")
            } else if(d == "f") {
                stack.setText(code: d, d: "Following")
            } else if(d == "t") {
                stack.setText(code: d, d: "Tesla")
            } else if(d == "e") {
                stack.setText(code: d, d: "Eats")
            }
        }
    }
    
    func redrawScrollFeedUI() {
        let bottomInset = self.safeAreaInsets.bottom
        print("vpanel bottominset: \(bottomInset)")
        
        let viewWidth = viewWidth
        let feedHeight = viewHeight - bottomInset
//        let feedHeight = viewHeight - bottomInset - 60 //60 is bottom box for entering comment
        for _ in vcDataList {
            
            let stack = ScrollFeedSoundCell()
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

            stack.aDelegate = self
            
            //*test > add loading spinner before fetch data
            let vData = SoundData()
            vData.setDataStatus(data: "b")
            stack.vcDataList.append(vData)
            //*
        }

        let tabCount = vcDataList.count
        feedScrollView.contentSize = CGSize(width: viewWidth * CGFloat(tabCount), height: feedHeight)
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
    func activateTabUI() {
        if(!self.tabList.isEmpty) {
            for l in self.tabList {
                self.stackviewUsableLength += l.frame.width
            }
//                        self.stackviewUsableLength += 10.0 //leading constraint on tabscrollview
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
    
    func asyncInit(id: String) {
        //use fetchdata() for time delay to get width for layout
        DataFetchManager.shared.fetchData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("postpanel init api success \(id), \(l)")

                    guard let self = self else {
                        return
                    }
                    
                    //test > init tabscroll UI e.g. measure width
                    self.activateTabUI()
                    
                    //test > async fetch feed
                    if(!self.feedList.isEmpty) {
                        let feed = self.feedList[self.currentIndex]
                        if(!feed.isInitialized) {
                            
                            self.asyncFetchFeed(cell: feed, id: "sound_feed")
                            feed.isInitialized = true
                        }
                    }
                }

                case .failure(_):
                    print("api fail")
                    break
            }
        }
    }
    
    func asyncInitPredeterminedDatasets(dataset: [SoundDataset]) {
        if(!self.feedList.isEmpty) {
            let feed = feedList[currentIndex]
            
            feed.vcDataList.removeAll() //remove spinner "b"

            var tempDataList = [SoundData]()
            for i in dataset {
                let vData = SoundData()
                vData.setData(rData: i)
                
                if(uiMode == SoundTypes.S_0) {
                    vData.setUIMode(mode: uiMode)
                }
                tempDataList.append(vData)
            }
            feed.vcDataList.append(contentsOf: tempDataList)

            feed.videoCV?.reloadData()

            feed.dataFetchState = "end"
            feed.isInitialized = true
            
            isInitialized = true
        }
    }
    
    //test > fetch data => temp fake data => try refresh data first
    func refreshFetchData() {
        if(!self.feedList.isEmpty) {
            let feed = feedList[currentIndex]
            feed.dataFetchState = ""
            feed.vcDataList.removeAll()

            //add loading spinner
            let vData = SoundData()
            vData.setDataStatus(data: "b")
            feed.vcDataList.append(vData)
            //
            
            feed.videoCV?.reloadData()
            feed.currentIndexPath = IndexPath(item: 0, section: 0) //to play video when willDisplay()

            feed.dataPaginateStatus = ""
            feed.pageNumber = 0

            asyncFetchFeed(cell: feed, id: "sound_feed")
            
            //test > clear comment textbox when scroll to another video
//            clearBottomCommentBox()
        }
    }

    //**test > remove elements from dataset n uicollectionview
    func removeData(cell: ScrollFeedSoundCell?, idxToRemove: Int) {
        guard let feed = cell else {
            return
        }
        if(!feed.vcDataList.isEmpty) {
            if(idxToRemove > -1 && idxToRemove < feed.vcDataList.count) {
                var indexPaths = [IndexPath]()
                let idx = IndexPath(item: idxToRemove, section: 0)
                indexPaths.append(idx)
                
                feed.vcDataList.remove(at: idxToRemove)
                
                //test > footer to show msg when no more data
                if(feed.vcDataList.isEmpty) {
                    let vData = SoundData()
                    vData.setDataStatus(data: "d")
                    feed.vcDataList.append(vData)
                    
                    feed.videoCV?.reloadData()
                } else {
                    feed.videoCV?.deleteItems(at: indexPaths)
                }
                
                feed.unselectItemData()
            }
        }
    }
    
    func asyncFetchFeed(cell: ScrollFeedSoundCell?, id: String) {

        cell?.dataFetchState = "start"

        let id_ = "post"
        let isPaginate = false
        DataFetchManager.shared.fetchSoundFeedData(id: id_, isPaginate: isPaginate) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("api success sound asyncFetchFeed \(id), \(l.count)")

                    //test 2 > insert array to idx[0], not just append
                    guard let feed = cell else {
                        return
                    }

                    //test 2 > new append method
                    var tempDataList = [SoundData]()
                    if(!l.isEmpty) {
                        for i in l {
                            let vData = SoundData()
                            vData.setData(rData: i)
                            tempDataList.append(vData)
                        }
                    } else {
                        feed.vcDataList.remove(at: 0) //remove loading spinner
                        
                        let vData = SoundData()
                        vData.setDataStatus(data: "d")
                        tempDataList.append(vData)
                    }
                    feed.vcDataList.insert(contentsOf: tempDataList, at: 0)

                    feed.videoCV?.reloadData()
                    
                    feed.dataFetchState = "end"
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    print("api fail")
                    guard let feed = cell else {
                        return
                    }
                    
                    var tempDataList = [SoundData]()
                    feed.vcDataList.remove(at: 0) //remove loading spinner
                    
                    let vData = SoundData()
                    vData.setDataStatus(data: "e")
                    tempDataList.append(vData)
                    
                    feed.vcDataList.insert(contentsOf: tempDataList, at: 0)

                    feed.videoCV?.reloadData()
                    
                    feed.dataFetchState = "end"
                }
                break
            }
        }
    }

    func asyncPaginateFetchFeed(cell: ScrollFeedSoundCell?, id: String) {

        cell?.pageNumber += 1
        cell?.dataPaginateStatus = "start"

        let id_ = "post"
        let isPaginate = true
        DataFetchManager.shared.fetchSoundFeedData(id: id_, isPaginate: isPaginate) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {

                    guard let feed = cell else {
                        return
                    }

                    let w = feed.vcDataList.count - 1
                    let x = feed.currentIndexPath.row
                    let y = feed.vcDataList[w].dataCode
                    let z = feed.vcDataList[x].dataCode

                    print("api success asyncPaginateFetchFeed: \(w), \(x), \(y), \(z)")

                    //test > if current index at loading spinner
                    if(y == "b") {
                        if(l.isEmpty) {
                            //no more data => END
                            feed.dataPaginateStatus = "end"

                            let vData = SoundData()
                            vData.setDataStatus(data: "c")
                            feed.vcDataList[feed.vcDataList.count - 1] = vData
                            
                            //test 2 > new reload method
                            var indexPaths = [IndexPath]()
                            let idx = IndexPath(item: w, section: 0)
                            indexPaths.append(idx)
                            
                            feed.videoCV?.reloadItems(at: indexPaths)
                        } else {
                            feed.dataPaginateStatus = ""
                            
                            //test 2 > new append method
                            var indexPaths = [IndexPath]()
                            var j = 0
                            
                            var tempDataList = [SoundData]()
                            for i in l {
                                let vData = SoundData()
                                vData.setData(rData: i)
                                tempDataList.append(vData)
                                
                                let idx = IndexPath(item: w + j, section: 0)
                                indexPaths.append(idx)
                                j += 1
                            }
                            feed.vcDataList.insert(contentsOf: tempDataList, at: feed.vcDataList.count - 1)
//                            feed.videoCV?.reloadData()
                            
                            //test 2 > new reload method
                            if(w == x) {
                                //if current cell is the loading spinner
                                feed.videoCV?.reloadData()
                            } else {
                                feed.videoCV?.insertItems(at: indexPaths)
                            }
                        }
                    }
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    print("api fail")
                    guard let feed = cell else {
                        return
                    }
 
                    let vData = SoundData()
                    vData.setDataStatus(data: "e")
                    feed.vcDataList[feed.vcDataList.count - 1] = vData

                    //test > new reload method
                    var indexPaths = [IndexPath]()
                    let idx = IndexPath(item: feed.vcDataList.count - 1, section: 0)
                    indexPaths.append(idx)
                    feed.videoCV?.reloadItems(at: indexPaths)
                    
                    feed.dataPaginateStatus = "end"
                }
                break
            }
        }
    }
    
    //test > start play video
    func startPlayingMedia() {
        if(!self.feedList.isEmpty) {
            let b = feedList[currentIndex]
            b.startPlayMedia()
        }
    }
    //test > resume current video
    func resumePlayingMedia() {
        if(!self.feedList.isEmpty) {
            let b = feedList[currentIndex]
            b.resumePlayingMedia()
        }
    }
    //test > stop current video for closing
    func stopPlayingMedia() {
        if(!self.feedList.isEmpty) {
            let b = feedList[currentIndex]
            b.stopPlayingMedia()
        }
    }
    //test > pause current video for closing
    func pausePlayingMedia() {
        if(!self.feedList.isEmpty) {
            let b = feedList[currentIndex]
            b.pausePlayingMedia()
        }
    }
    
    //**test > destroy cell
    func destroyCell() {
        if(!self.feedList.isEmpty) {
            let b = feedList[currentIndex]
            b.destroyCell()
        }
    }
    func dehideCell() {
        if(!self.feedList.isEmpty) {
            let b = feedList[currentIndex]
            b.dehideCell()
        }
    }
    
    //test
    override func resumeActiveState() {
        //test > only resume video if no comment scrollable view/any other view
        if(pageList.isEmpty) {
            resumePlayingMedia()
            //test
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
    override func resumeMedia() {
        if(pageList.isEmpty) {
            resumePlayingMedia()
        }
        else {
            if let c = pageList[pageList.count - 1] as? CommentScrollableView {
                c.resumePlayingMedia()
            }
        }
    }
    override func pauseMedia() {
        if(pageList.isEmpty) {
            pausePlayingMedia()
        }
        else {
            if let c = pageList[pageList.count - 1] as? CommentScrollableView {
                c.pausePlayingMedia()
            }
        }
    }
    
    //test > add comment panel
    func openComment() {
        let commentPanel = CommentScrollableView(frame: CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.height))
//        videoPanel.insertSubview(commentPanel, belowSubview: bottomBox)
        soundPanel.addSubview(commentPanel)
        commentPanel.translatesAutoresizingMaskIntoConstraints = false
        commentPanel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        commentPanel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        commentPanel.delegate = self
        commentPanel.initialize()
        
        //test > track comment scrollable view
        pageList.append(commentPanel)
    }

    func openShareSheet(oType: String, oId: String) {
        let sharePanel = ShareSheetScrollableView(frame: CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.height))
        soundPanel.addSubview(sharePanel)
        sharePanel.translatesAutoresizingMaskIntoConstraints = false
        sharePanel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        sharePanel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        sharePanel.delegate = self
        sharePanel.initialize()
        sharePanel.setObject(oType: oType, oId: oId)
        
        //test > track comment scrollable view
        pageList.append(sharePanel)
    }
    
    //test > upload comment error
    func openErrorUploadMsg() {
        let errorPanel = ErrorUploadCommentMsgView(frame: CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.height))
        self.addSubview(errorPanel)
        errorPanel.translatesAutoresizingMaskIntoConstraints = false
        errorPanel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        errorPanel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        errorPanel.delegate = self
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
}

//test > link delegate implementation in SoundPanelView with VC
extension ViewController: SoundPanelDelegate{
    func didSoundClickUser(id: String) {
        deactivateQueueState()
        //test > real id for fetching data
        openUserPanel(id: id)
    }

    func didSoundClickPlace(id: String) {
        deactivateQueueState()
//        openPlacePanel()
        //test > real id for fetching data
        openPlacePanel(id: id)
    }

    func didSoundClickSound(id: String, pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String) {
//        deactivateQueueState()
        //test > real id for fetching data
//        openSoundPanel(id: id)
        
        //test > new method
        let offsetX = pointX - self.view.frame.width/2
        let offsetY = pointY - self.view.frame.height/2

        //test 1 > for video only
        var dataset = [String]()
//        dataset.append("a")
        dataset.append("a")
        self.openSoundPanel(offX: offsetX, offY: offsetY, originatorView: view, originatorViewType: OriginatorTypes.UIVIEW, id: 0, originatorViewId: "", preterminedDatasets: dataset, mode: mode)
    }
    
    func didSoundClickPost(id: String, dataType: String, scrollToComment: Bool, pointX: CGFloat, pointY: CGFloat){
        //test > real id for fetching data
//        openPostDetailPanel(id: id, dataType: dataType, scrollToComment: scrollToComment)
        
        //test > new method
        let offsetX = pointX - self.view.frame.width/2
        let offsetY = pointY - self.view.frame.height/2
        openPostDetailPanel(id: id, dataType: dataType, scrollToComment: scrollToComment, offX: offsetX, offY: offsetY)
    }

    func didStartOpenSoundPanel() {
        //activate queue object video state when video opens
        activateQueueState()
    }
    func didFinishOpenSoundPanel() {
        //test > stop any pulsewave if video opens
        stopPulseWave()
    }
    func didStartCloseSoundPanel(spv : SoundPanelView) {

        //test > dequeue object deactivate video active state
        deactivateQueueState()

        if(spv.originatorViewType == OriginatorTypes.MARKER) {
            guard let mapView = self.mapView else {
                return
            }
            guard let coord = spv.coordinateLocation else {
                return
            }
            let point = mapView.projection.point(for: coord)
            spv.offsetX = point.x - self.view.frame.width/2
            spv.offsetY = point.y - self.view.frame.height/2
            spv.offsetX = spv.offsetX - spv.soundPanelLeadingCons!.constant
            spv.offsetY = spv.offsetY - spv.soundPanelTopCons!.constant + spv.adjustmentY

            spv.close(isAnimated: true)

        } else if(spv.originatorViewType == OriginatorTypes.PULSEWAVE){
            guard let mapView = self.mapView else {
                return
            }
            guard let coord = spv.coordinateLocation else {
                return
            }
            let point = mapView.projection.point(for: coord)
            spv.offsetX = point.x - self.view.frame.width/2
            spv.offsetY = point.y - self.view.frame.height/2
            spv.offsetX = spv.offsetX - spv.soundPanelLeadingCons!.constant
            spv.offsetY = spv.offsetY - spv.soundPanelTopCons!.constant

            spv.close(isAnimated: true)
        } else {
            spv.offsetX = spv.offsetX - spv.soundPanelLeadingCons!.constant
            spv.offsetY = spv.offsetY - spv.soundPanelTopCons!.constant

            spv.close(isAnimated: true)
        }
    }

    func didFinishCloseSoundPanel(spv : SoundPanelView) {

        //test
        backPage(isCurrentPageScrollable: false)

        //test > get marker id for marker closing animation
        if(spv.originatorViewType == OriginatorTypes.MARKER) {
            print("didFinishCloseVideoPanel \(spv.getOriginatorId())")
            if var a = self.markerGeoMarkerIdList[spv.getOriginatorId()] {
                a.animateFromVideoClose()
            }
        } else if(spv.originatorViewType == OriginatorTypes.MAP_TOP_UIVIEW){
            shutterSemiTransparentGifImage()
        } else if(spv.originatorViewType == OriginatorTypes.MAP_VIDEO_MINIAPP_UIVIEW){
//            shutterBMiniGifImage()
            if(selectedMiniAppIndex > -1) {
                miniAppViewList[selectedMiniAppIndex].shutterMiniGifImage()
            }
        }
        //test > make viewcell reappear after video panel closes
        else if(spv.originatorViewType == OriginatorTypes.UIVIEW){
            if(!pageList.isEmpty) {
//                if let c = pageList[pageList.count - 1] as? PlaceScrollablePanelView {
//                    c.dehideViewCell()
//                }
//                if let d = pageList[pageList.count - 1] as? UserScrollablePanelView {
//                    d.dehideViewCell()
//                }
//                if let e = pageList[pageList.count - 1] as? SoundScrollablePanelView {
//                    e.dehideViewCell()
//                }
            }
        }
    }

    func didStartSoundPanGesture(spv : SoundPanelView) {
        //test > hide marker ready for shutter after video closes
        if(spv.originatorViewType == OriginatorTypes.MARKER) {
            if var a = self.markerGeoMarkerIdList[spv.getOriginatorId()] {
                a.hideForShutter()
            }
        } else if(spv.originatorViewType == OriginatorTypes.MAP_TOP_UIVIEW){
            hideSemiTransparentGifImage()
        } else if(spv.originatorViewType == OriginatorTypes.MAP_VIDEO_MINIAPP_UIVIEW){
//            hideBMiniGifImage()
            if(selectedMiniAppIndex > -1) {
                miniAppViewList[selectedMiniAppIndex].hideMiniGifImage()
            }
        }
    }
    func didEndSoundPanGesture(spv : SoundPanelView) {
        //test > de-hide marker ready for shutter if video NOT close, resume play
        if(spv.originatorViewType == OriginatorTypes.MARKER) {
            if var a = self.markerGeoMarkerIdList[spv.getOriginatorId()] {
                a.dehideForShutter()
            }
        } else if(spv.originatorViewType == OriginatorTypes.MAP_TOP_UIVIEW){
            dehideSemiTransparentGifImage()
        } else if(spv.originatorViewType == OriginatorTypes.MAP_VIDEO_MINIAPP_UIVIEW){
//            dehideBMiniGifImage()
            if(selectedMiniAppIndex > -1) {
                miniAppViewList[selectedMiniAppIndex].dehideMiniGifImage()
            }
        }
    }
    
    func didClickSoundPanelClickPhoto(id: String, pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String) {
//        let offsetX = pointX - self.view.frame.width/2 + view.frame.width/2
//        let offsetY = pointY - self.view.frame.height/2 + view.frame.height/2
        //test > new method
        let offsetX = pointX - self.view.frame.width/2
        let offsetY = pointY - self.view.frame.height/2
        
        if(mode == PhotoTypes.P_SHOT_DETAIL) {
            //test > real id for fetching data
//            openPhotoDetailPanel(id: id)
            
            //test 2 > animated open and close panel
            openPhotoDetailPanel(id: id, offX: offsetX, offY: offsetY)
        } else if(mode == PhotoTypes.P_0){
            openPhotoZoomPanel(offX: offsetX, offY: offsetY)
        }
    }
    func didClickSoundPanelClickVideo(id: String, pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String) {
//        let offsetX = pointX - self.view.frame.width/2 + view.frame.width/2
//        let offsetY = pointY - self.view.frame.height/2 + view.frame.height/2
        //test > new method
        let offsetX = pointX - self.view.frame.width/2
        let offsetY = pointY - self.view.frame.height/2

        //test 1 > for video only
        var dataset = [String]()
//        dataset.append("a")
        dataset.append("a")
        self.openVideoPanel(offX: offsetX, offY: offsetY, originatorView: view, originatorViewType: OriginatorTypes.UIVIEW, id: 0, originatorViewId: "", preterminedDatasets: dataset, mode: mode)
    }
    
    func didClickSoundPanelVcvClickCreate(type: String, objectType: String, objectId: String){
        if(type == "post") {
//            openPostCreatorPanel()
            openPostCreatorPanel(objectType: objectType, objectId: objectId, mode: "")
        }
        
    }
}

extension SoundPanelView: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        //test 3 > new scrollview method
        if(scrollView == feedScrollView) {
            print("vpv feed begin scroll")
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
            //*
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView == feedScrollView) {
            print("vpv feed scroll")
            let xOffset = scrollView.contentOffset.x
            let viewWidth = self.frame.width
            let currentIndex = round(xOffset/viewWidth)

            if(!self.tabList.isEmpty) {
                let currentItemIndex = tempCurrentIndex
                let currentX = soundPanel.frame.width * CGFloat(currentItemIndex)
                let currentTabWidth = tabList[currentItemIndex].frame.width
                var hOffsetX = 0.0
                if(xOffset >= currentX) {
                    var nextTabWidth = tabList[currentItemIndex].frame.width
                    if(currentItemIndex < tabList.count - 1) {
                        nextTabWidth = tabList[currentItemIndex + 1].frame.width
                    }
                    hOffsetX = (xOffset - currentX)/(soundPanel.frame.width) * currentTabWidth + currentTabSelectLeadingCons
                    tabSelectLeadingCons?.constant = hOffsetX

                    let hWidth = (xOffset - currentX)/(soundPanel.frame.width) * (nextTabWidth - currentTabWidth) + currentTabWidth
                    tabSelectWidthCons?.constant = hWidth
                }
                else if (xOffset < currentX) {
                    var prevTabWidth = tabList[currentItemIndex].frame.width
                    if(currentItemIndex > 0) {
                        prevTabWidth = tabList[currentItemIndex - 1].frame.width
                    }

                    hOffsetX = (xOffset - currentX)/(soundPanel.frame.width) * prevTabWidth + currentTabSelectLeadingCons
                    tabSelectLeadingCons?.constant = hOffsetX

                    let hWidth = (xOffset - currentX)/(soundPanel.frame.width) * (currentTabWidth - prevTabWidth) + currentTabWidth
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
                if(!feed.isInitialized) {
                    asyncFetchFeed(cell: feed, id: "sound_feed")
                    feed.isInitialized = true
                }
            }
        }
        else if(scrollView == tabScrollView) {
            let tabXOffset = scrollView.contentOffset.x
            self.arrowReactToTabScroll(tabXOffset: tabXOffset)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if(scrollView == feedScrollView) {
            print("vpv feed end scroll")
            let xOffset = scrollView.contentOffset.x
            let viewWidth = self.frame.width
            
            let visibleIndex = Int(xOffset/viewWidth)
            if(!self.feedList.isEmpty) {
                let currentFeed = self.feedList[visibleIndex]
                let previousFeed = self.feedList[currentIndex]
                
                currentIndex = visibleIndex
                
                if(currentFeed != previousFeed) {
                    currentFeed.startPlayMedia()
                    previousFeed.stopPlayingMedia()
                }
            }
            
            //test > change tab title font opacity when scrolled
            reactToTabSectionChange(index: currentIndex)
            
            //test > clear comment textbox when scroll to another video
//            clearBottomCommentBox()
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if(scrollView == feedScrollView) {
            print("vpv feed end anim")
            let xOffset = scrollView.contentOffset.x
            let viewWidth = self.frame.width
            
            let visibleIndex = Int(xOffset/viewWidth)
            if(!self.feedList.isEmpty) {
                let currentFeed = self.feedList[visibleIndex]
                let previousFeed = self.feedList[currentIndex]
                
                currentIndex = visibleIndex
                
                if(currentFeed != previousFeed) {
                    currentFeed.startPlayMedia()
                    previousFeed.stopPlayingMedia()
                }
            }
            
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

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

    }
}

extension SoundPanelView: ScrollFeedSoundCellDelegate {
    func sfscWillBeginDragging(offsetY: CGFloat) {

    }
    func sfscScrollViewDidScroll(offsetY: CGFloat){

    }
    func sfscSrollViewDidEndDecelerating(offsetY: CGFloat){
        //test > clear comment textbox when scroll to another video
//        clearBottomCommentBox()
    }
    func sfscScrollViewDidEndDragging(offsetY: CGFloat, decelerate: Bool){
        
        //test > open single video
        if(offsetY < -100) {
            if(self.predeterminedDatasets.isEmpty) {
                self.refreshFetchData()
            }
        }
    }

    func sfscAsyncFetchFeed(){

    }
    func sfscAsyncPaginateFeed(cell: ScrollFeedSoundCell?){
        //test > open single video
        if(self.predeterminedDatasets.isEmpty) {
            asyncPaginateFetchFeed(cell: cell, id: "sound_feed_end")
        }
    }
    
    func sfscAutoplayVideo(cell: ScrollFeedSoundCell?, vCCell: SCViewCell?) {
        if(!self.feedList.isEmpty) {
            let aVc = feedList[currentIndex]
            print("fvcAutoplayVideo \(aVc == cell), \(cell)")
            if(aVc == cell) {
                vCCell?.playVideo()
            }
        }
    }
    
    func sfscDidClickUser(id: String) {
        pausePlayingMedia()
        delegate?.didSoundClickUser(id: id)
    }
    func sfscDidClickPlace(id: String){
        pausePlayingMedia()
        delegate?.didSoundClickPlace(id: id)
    }
    func sfscDidClickSound(id: String, pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String){
        pausePlayingMedia()
//        delegate?.didSoundClickSound(id: id)
        
        if(!self.feedList.isEmpty) {
            let b = self.feedList[self.currentIndex]
            let originInRootView = feedScrollView.convert(b.frame.origin, to: self)
            print("sfvcDidClickSound \(originInRootView)")
            
            let adjustY = pointY + originInRootView.y
            
            delegate?.didSoundClickSound(id: id, pointX: pointX, pointY: adjustY, view: view, mode: mode)
        }
    }
    func sfscDidClickComment(){
        pausePlayingMedia()
        openComment()
    }
    func sfscDidClickShare(id: String, dataType: String){
        pausePlayingMedia()
        openShareSheet(oType: dataType, oId: id)
    }
    func sfscDidClickRefresh(){
        //test
        if(self.predeterminedDatasets.isEmpty) {
            self.refreshFetchData()
        }
    }
}

extension SoundPanelView: ShareSheetScrollableDelegate{
    func didShareSheetClickCreate(type: String, objectType: String, objectId: String){
        //test > for deleting item
        if(!pageList.isEmpty) {
            pageList.remove(at: pageList.count - 1)
            
            if(pageList.count > 0) {
                let lastPage = pageList[pageList.count - 1]
                if let a = lastPage as? CommentScrollableView {
                    print("lastpagelist e \(a.selectedItemIdx)")
                    let idx = a.selectedItemIdx
                    
                    //test > create new post
                    if(type == "post") {
                        delegate?.didClickSoundPanelVcvClickCreate(type: type, objectType: objectType, objectId: objectId)
                    }
                }
                else if let b = lastPage as? ShareSheetScrollableView {
                    print("lastpagelist f")
                }
            } else {
                if(!self.feedList.isEmpty) {
                    let feed = feedList[currentIndex]
                    
                    //test > create new post
                    if(type == "post") {
                        delegate?.didClickSoundPanelVcvClickCreate(type: type, objectType: objectType, objectId: objectId)
                    }
                }
            }
        }
    }
    func didShareSheetClickDelete(){
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
                resumePlayingMedia()
                
                if(!self.feedList.isEmpty) {
                    let feed = feedList[currentIndex]
                    feed.unselectItemData()
                }
            }
        }
    }
}

extension SoundPanelView: CommentScrollableDelegate{
    func didCClickUser(id: String){
        delegate?.didSoundClickUser(id: id)
    }
    func didCClickPlace(id: String){
        delegate?.didSoundClickPlace(id: id)
    }
    func didCClickSound(id: String, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
//        delegate?.didSoundClickSound(id: id)
        
        delegate?.didSoundClickSound(id: id, pointX: pointX, pointY: pointY, view: view, mode: mode)
    }
    func didCClickClosePanel(){
        
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
                resumePlayingMedia()
            }
        }
    }
    func didCClickComment(id: String, dataType: String, pointX: CGFloat, pointY: CGFloat){
        delegate?.didSoundClickPost(id: id, dataType: dataType, scrollToComment: true, pointX: pointX, pointY: pointY)
    }
    func didCClickShare(id: String, dataType: String){
        openShareSheet(oType: dataType, oId: id)
    }
    func didCClickPost(id: String, dataType: String, pointX: CGFloat, pointY: CGFloat){
        delegate?.didSoundClickPost(id: id, dataType: dataType, scrollToComment: false, pointX: pointX, pointY: pointY)
    }
    func didCClickClickPhoto(id: String, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
        delegate?.didClickSoundPanelClickPhoto(id: id, pointX: pointX, pointY: pointY, view: view, mode: mode)
    }
    func didCClickClickVideo(id: String, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
        delegate?.didClickSoundPanelClickVideo(id: id, pointX: pointX, pointY: pointY, view: view, mode: mode)
    }
}

extension SoundPanelView: ErrorUploadCommentMsgDelegate {
    func didEUCommentClickProceed() {
        //temp
//        asyncSendNewData()
    }
    func didEUCommentClickDeny(){

    }
}

extension SoundPanelView: TabStackDelegate {
    func didClickTabStack(tabCode: String, isSelected: Bool) {
        if let index = vcDataList.firstIndex(of: tabCode) {
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
