//
//  PhotoPanelView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage
import GoogleMaps

protocol PhotoPanelDelegate : AnyObject {
    func didStartOpenPhotoPanel()
    func didFinishOpenPhotoPanel()
    func didStartClosePhotoPanel(ppv : PhotoPanelView)
    func didFinishClosePhotoPanel(ppv : PhotoPanelView)

    func didClickPhotoPanelVcvComment() //try
    func didClickPhotoPanelVcvLove() //try
    func didClickPhotoPanelVcvShare() //try
    func didClickPhotoPanelVcvClickUser() //try
    func didClickPhotoPanelVcvClickPlace() //try
    func didClickPhotoPanelVcvClickSound() //try
    func didClickPhotoPanelVcvClickPost() //try
    func didClickPhotoPanelVcvClickPhoto(pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String) //try

    //test > for marker animation after video closes
    func didStartPhotoPanGesture(ppv : PhotoPanelView)
    func didEndPhotoPanGesture(ppv : PhotoPanelView)
}

class PhotoPanelView: PanelView, UIGestureRecognizerDelegate{
    
    var photoPanel = UIView()
    var vcDataList = [String]()

    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0

    var photoPanelTopCons: NSLayoutConstraint?
    var photoPanelLeadingCons: NSLayoutConstraint?
    var currentPhotoTopCons : CGFloat = 0.0
    var currentPhotoLeadingCons : CGFloat = 0.0

    let aStickyHeader = UIView()

    //test > circle mask
    var cView = UIView()

    var offsetX: CGFloat = 0.0
    var offsetY: CGFloat = 0.0
    
    //test > black out
    let blackBox = UIView()
    var isTypeBlackOut = false //default: not blackout when close()

    //test > coordinates realignment when close video due to random user swiping
    var coordinateLocation : CLLocationCoordinate2D?
    var id = -1 //queue Id
    var originatorViewType = ""
    var adjustmentX: CGFloat = 0.0
    var adjustmentY: CGFloat = 0.0
    //test > marker id
    var originatorViewId = ""

    weak var delegate : PhotoPanelDelegate?
    
    //test > scroll view for carousel
    var isCarouselScrolled = false
    
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
    var feedList = [ScrollFeedHPhotoListCell]()
    var currentIndex = 0
    
    let tabScrollLHSBtn = UIView()
    let tabScrollRHSBtn = UIView()
    
    let bottomBox = UIView()
    //test > comment textbox
    let bTextBtn = UIImageView()
    let lTextBtn = UIImageView()
    let mTextBtn = UIImageView()
    let nTextBtn = UIImageView()
    
    //test page transition => track user journey in creating short video
    var pageList = [PanelView]()
    
    var predeterminedDatasets = [String]()
    
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
        photoPanel.layer.addSublayer(shapeLayer)

        photoPanel.layer.mask = shapeLayer
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)

        print("circle mask layout sublayer")

        //isSubLayerSet is to prevent repeated calling of layoutSublayers()
        if(!isSubLayerSet) {
            let width = viewWidth
            let height = viewHeight + 100
    //        let height = 200.0

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
        
        photoPanel.backgroundColor = .ddmBlackOverlayColor
        self.addSubview(photoPanel)
        photoPanel.translatesAutoresizingMaskIntoConstraints = false
        photoPanel.layer.masksToBounds = true
        photoPanel.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        photoPanel.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        photoPanelTopCons = photoPanel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        photoPanelTopCons?.isActive = true
        photoPanelLeadingCons = photoPanel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
        photoPanelLeadingCons?.isActive = true

        //test > sticky header => for "for you", "following", "subscribing"
        aStickyHeader.backgroundColor = .ddmBlackOverlayColor
        photoPanel.addSubview(aStickyHeader)
        aStickyHeader.translatesAutoresizingMaskIntoConstraints = false
        aStickyHeader.trailingAnchor.constraint(equalTo: photoPanel.trailingAnchor).isActive = true
        aStickyHeader.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        aStickyHeader.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        aStickyHeader.leadingAnchor.constraint(equalTo: photoPanel.leadingAnchor, constant: 0).isActive = true
        
        let aBtn = UIView()
        aBtn.backgroundColor = .ddmDarkColor
//        aBtn.backgroundColor = .red
        aStickyHeader.addSubview(aBtn)
        aBtn.translatesAutoresizingMaskIntoConstraints = false
        aBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
        aBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        aBtn.leadingAnchor.constraint(equalTo: aStickyHeader.leadingAnchor, constant: 10).isActive = true
    //        aBtn.topAnchor.constraint(equalTo: userPanel.topAnchor, constant: 30).isActive = true
        aBtn.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        aBtn.layer.cornerRadius = 20
        aBtn.layer.opacity = 0.4 //0.3
        aBtn.isUserInteractionEnabled = true
        aBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackPostPanelClicked)))
        aBtn.isHidden = true
        
        let bBoxBtn = UIImageView()
        bBoxBtn.image = UIImage(named:"icon_round_arrow_left")?.withRenderingMode(.alwaysTemplate)
        bBoxBtn.tintColor = .white
        aStickyHeader.addSubview(bBoxBtn)
        bBoxBtn.translatesAutoresizingMaskIntoConstraints = false
        bBoxBtn.centerXAnchor.constraint(equalTo: aBtn.centerXAnchor).isActive = true
        bBoxBtn.centerYAnchor.constraint(equalTo: aBtn.centerYAnchor).isActive = true
        bBoxBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        bBoxBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        bBoxBtn.isHidden = true
        
//        //test > try uicollectionview
////        vcDataList.append("a")
////        vcDataList.append("a")
////        vcDataList.append("a")
////        vcDataList.append("a")
////        vcDataList.append("a")
//        vcDataList.append("fy") //for you
//        vcDataList.append("f") //following
//        vcDataList.append("e") //eats
//        vcDataList.append("t") //tesla
////        vcDataList.append("e") //eats
////        vcDataList.append("t") //tesla
        
        //test > add sections tab
//        photoPanel.addSubview(tabScrollView)
//        tabScrollView.backgroundColor = .clear //clear
//        tabScrollView.translatesAutoresizingMaskIntoConstraints = false
//        tabScrollView.heightAnchor.constraint(equalToConstant: 40).isActive = true //ori 60
////        tabScrollView.topAnchor.constraint(equalTo: aStickyHeader.bottomAnchor, constant: 0).isActive = true
//        tabScrollView.centerYAnchor.constraint(equalTo: aBtn.centerYAnchor, constant: 0).isActive = true
//        tabScrollView.leadingAnchor.constraint(equalTo: photoPanel.leadingAnchor, constant: tabScrollMargin).isActive = true //20
//        tabScrollView.trailingAnchor.constraint(equalTo: photoPanel.trailingAnchor, constant: -tabScrollMargin).isActive = true
//        tabScrollView.showsHorizontalScrollIndicator = false
//        tabScrollView.alwaysBounceHorizontal = true //test
//        tabScrollView.delegate = self
//
//        stackView.backgroundColor = .clear //clear
//        tabScrollView.addSubview(stackView)
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.heightAnchor.constraint(equalToConstant: 40).isActive = true //ori 30
//        stackView.topAnchor.constraint(equalTo: tabScrollView.topAnchor).isActive = true
//        stackView.leadingAnchor.constraint(equalTo: tabScrollView.leadingAnchor, constant: 0).isActive = true //10
//
//        tabSelect.backgroundColor = .clear
//        stackView.addSubview(tabSelect)
//        tabSelect.translatesAutoresizingMaskIntoConstraints = false
//        tabSelectLeadingCons = tabSelect.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0)
//        tabSelectLeadingCons?.isActive = true
//        tabSelect.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
//        tabSelect.heightAnchor.constraint(equalToConstant: 2).isActive = true //ori 60
////        tabSelect.widthAnchor.constraint(equalToConstant: hWidth).isActive = true
//        tabSelectWidthCons = tabSelect.widthAnchor.constraint(equalToConstant: 0)
//        tabSelectWidthCons?.isActive = true
////        aHighlight.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        tabSelect.isHidden = true
//
//        let aHighlightInner = UIView()
//        aHighlightInner.backgroundColor = .yellow
//        tabSelect.addSubview(aHighlightInner)
//        aHighlightInner.translatesAutoresizingMaskIntoConstraints = false
//        aHighlightInner.heightAnchor.constraint(equalToConstant: 2).isActive = true //ori 60
//        aHighlightInner.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        aHighlightInner.centerYAnchor.constraint(equalTo: tabSelect.centerYAnchor).isActive = true
//        aHighlightInner.centerXAnchor.constraint(equalTo: tabSelect.centerXAnchor).isActive = true
//
////        let tabScrollLHSBtn = UIView()
//        tabScrollLHSBtn.backgroundColor = .white
////        tabScrollLHSBtn.backgroundColor = .red
//        photoPanel.addSubview(tabScrollLHSBtn)
//        tabScrollLHSBtn.translatesAutoresizingMaskIntoConstraints = false
//        tabScrollLHSBtn.widthAnchor.constraint(equalToConstant: 14).isActive = true //ori: 40
//        tabScrollLHSBtn.heightAnchor.constraint(equalToConstant: 14).isActive = true
//        tabScrollLHSBtn.trailingAnchor.constraint(equalTo: tabScrollView.leadingAnchor, constant: -2).isActive = true
//        tabScrollLHSBtn.centerYAnchor.constraint(equalTo: tabScrollView.centerYAnchor, constant: 0).isActive = true
//        tabScrollLHSBtn.isUserInteractionEnabled = true
//        tabScrollLHSBtn.layer.cornerRadius = 7
//        tabScrollLHSBtn.isHidden = true
//        tabScrollLHSBtn.layer.opacity = 0.5
//
//        let tabScrollLHSBoxBtn = UIImageView()
//        tabScrollLHSBoxBtn.image = UIImage(named:"icon_round_arrow_left")?.withRenderingMode(.alwaysTemplate)
//        tabScrollLHSBoxBtn.tintColor = .ddmBlackOverlayColor
//        tabScrollLHSBtn.addSubview(tabScrollLHSBoxBtn)
//        tabScrollLHSBoxBtn.translatesAutoresizingMaskIntoConstraints = false
//        tabScrollLHSBoxBtn.centerXAnchor.constraint(equalTo: tabScrollLHSBtn.centerXAnchor).isActive = true
//        tabScrollLHSBoxBtn.centerYAnchor.constraint(equalTo: tabScrollLHSBtn.centerYAnchor).isActive = true
//        tabScrollLHSBoxBtn.heightAnchor.constraint(equalToConstant: 14).isActive = true
//        tabScrollLHSBoxBtn.widthAnchor.constraint(equalToConstant: 14).isActive = true
//
////        let tabScrollRHSBtn = UIView()
//        tabScrollRHSBtn.backgroundColor = .white
////        tabScrollRHSBtn.backgroundColor = .red
//        photoPanel.addSubview(tabScrollRHSBtn)
//        tabScrollRHSBtn.translatesAutoresizingMaskIntoConstraints = false
//        tabScrollRHSBtn.widthAnchor.constraint(equalToConstant: 14).isActive = true //ori: 40
//        tabScrollRHSBtn.heightAnchor.constraint(equalToConstant: 14).isActive = true
//        tabScrollRHSBtn.leadingAnchor.constraint(equalTo: tabScrollView.trailingAnchor, constant: 2).isActive = true
//        tabScrollRHSBtn.centerYAnchor.constraint(equalTo: tabScrollView.centerYAnchor, constant: 0).isActive = true
//        tabScrollRHSBtn.isUserInteractionEnabled = true
//        tabScrollRHSBtn.layer.cornerRadius = 7
//        tabScrollRHSBtn.isHidden = true
//        tabScrollRHSBtn.layer.opacity = 0.5
//
//        let tabScrollRHSBoxBtn = UIImageView()
//        tabScrollRHSBoxBtn.image = UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate)
//        tabScrollRHSBoxBtn.tintColor = .ddmBlackOverlayColor
//        tabScrollRHSBtn.addSubview(tabScrollRHSBoxBtn)
//        tabScrollRHSBoxBtn.translatesAutoresizingMaskIntoConstraints = false
//        tabScrollRHSBoxBtn.centerXAnchor.constraint(equalTo: tabScrollRHSBtn.centerXAnchor).isActive = true
//        tabScrollRHSBoxBtn.centerYAnchor.constraint(equalTo: tabScrollRHSBtn.centerYAnchor).isActive = true
//        tabScrollRHSBoxBtn.heightAnchor.constraint(equalToConstant: 14).isActive = true
//        tabScrollRHSBoxBtn.widthAnchor.constraint(equalToConstant: 14).isActive = true
//        //

        photoPanel.addSubview(feedScrollView)
        feedScrollView.backgroundColor = .clear //clear
        feedScrollView.translatesAutoresizingMaskIntoConstraints = false
        feedScrollView.topAnchor.constraint(equalTo: aStickyHeader.bottomAnchor, constant: 0).isActive = true //10
        feedScrollView.bottomAnchor.constraint(equalTo: photoPanel.bottomAnchor, constant: 0).isActive = true
        feedScrollView.leadingAnchor.constraint(equalTo: photoPanel.leadingAnchor, constant: 0).isActive = true
        feedScrollView.trailingAnchor.constraint(equalTo: photoPanel.trailingAnchor, constant: 0).isActive = true
        feedScrollView.showsHorizontalScrollIndicator = false
        feedScrollView.alwaysBounceHorizontal = true //test
        feedScrollView.isPagingEnabled = true
        feedScrollView.delegate = self
        
//        let addFeedBtn = UIView()
//        addFeedBtn.backgroundColor = .clear
////        addFeedBtn.backgroundColor = .red
//        photoPanel.addSubview(addFeedBtn)
//        addFeedBtn.translatesAutoresizingMaskIntoConstraints = false
//        addFeedBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
//        addFeedBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        addFeedBtn.trailingAnchor.constraint(equalTo: photoPanel.trailingAnchor, constant: -10).isActive = true
//        addFeedBtn.centerYAnchor.constraint(equalTo: tabScrollView.centerYAnchor, constant: 0).isActive = true
//        addFeedBtn.isUserInteractionEnabled = true
//        addFeedBtn.isHidden = true
//
//        let addBoxBtn = UIImageView()
//        addBoxBtn.image = UIImage(named:"icon_outline_add_circle")?.withRenderingMode(.alwaysTemplate)
//        addBoxBtn.tintColor = .white
//        addFeedBtn.addSubview(addBoxBtn)
//        addBoxBtn.translatesAutoresizingMaskIntoConstraints = false
//        addBoxBtn.centerXAnchor.constraint(equalTo: addFeedBtn.centerXAnchor).isActive = true
//        addBoxBtn.centerYAnchor.constraint(equalTo: addFeedBtn.centerYAnchor).isActive = true
//        addBoxBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
//        addBoxBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        addBoxBtn.layer.opacity = 0.5
////        addBoxBtn.isHidden = true
//
//        let searchFeedBtn = UIView()
//        searchFeedBtn.backgroundColor = .clear
////        addFeedBtn.backgroundColor = .red
//        photoPanel.addSubview(searchFeedBtn)
//        searchFeedBtn.translatesAutoresizingMaskIntoConstraints = false
//        searchFeedBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
//        searchFeedBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        searchFeedBtn.leadingAnchor.constraint(equalTo: photoPanel.leadingAnchor, constant: 10).isActive = true
//        searchFeedBtn.centerYAnchor.constraint(equalTo: tabScrollView.centerYAnchor, constant: 0).isActive = true
//        searchFeedBtn.isUserInteractionEnabled = true
//        searchFeedBtn.isHidden = true
//
//        let searchBoxBtn = UIImageView()
//        searchBoxBtn.image = UIImage(named:"icon_round_search")?.withRenderingMode(.alwaysTemplate)
//        searchBoxBtn.tintColor = .white
//        searchFeedBtn.addSubview(searchBoxBtn)
//        searchBoxBtn.translatesAutoresizingMaskIntoConstraints = false
//        searchBoxBtn.centerXAnchor.constraint(equalTo: searchFeedBtn.centerXAnchor).isActive = true
//        searchBoxBtn.centerYAnchor.constraint(equalTo: searchFeedBtn.centerYAnchor).isActive = true
//        searchBoxBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
//        searchBoxBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        searchBoxBtn.layer.opacity = 0.5
////        addBoxBtn.isHidden = true
        
        //test bottom comment box => fake edittext
        bottomBox.backgroundColor = .black
        photoPanel.addSubview(bottomBox)
        bottomBox.clipsToBounds = true
        bottomBox.translatesAutoresizingMaskIntoConstraints = false
        bottomBox.leadingAnchor.constraint(equalTo: photoPanel.leadingAnchor, constant: 0).isActive = true
        bottomBox.trailingAnchor.constraint(equalTo: photoPanel.trailingAnchor, constant: 0).isActive = true
        bottomBox.heightAnchor.constraint(equalToConstant: 94).isActive = true //default: 50
        bottomBox.bottomAnchor.constraint(equalTo: photoPanel.bottomAnchor, constant: 0).isActive = true
        bottomBox.isUserInteractionEnabled = true
//        let aPanelPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onTextViewPanGesture))
//        bottomBox.addGestureRecognizer(aPanelPanGesture)
//        bottomBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onOpenTextBoxClicked)))
        bottomBox.isHidden = true

        let bText = UILabel()
        bText.textAlignment = .left
        bText.textColor = .white
        bText.font = .boldSystemFont(ofSize: 13)
//        photoPanel.addSubview(bText)
        bottomBox.addSubview(bText)
        bText.clipsToBounds = true
        bText.translatesAutoresizingMaskIntoConstraints = false
//        bText.bottomAnchor.constraint(equalTo: bottomBox.bottomAnchor, constant: -30).isActive = true
//        bText.leadingAnchor.constraint(equalTo: mImage.trailingAnchor, constant: 10).isActive = true
        bText.leadingAnchor.constraint(equalTo: bottomBox.leadingAnchor, constant: 15).isActive = true
        bText.trailingAnchor.constraint(equalTo: bottomBox.trailingAnchor, constant: -60).isActive = true
        bText.topAnchor.constraint(equalTo: bottomBox.topAnchor, constant: 15).isActive = true
        bText.text = "Add comment..."
        bText.layer.opacity = 0.5
        
//        let bTextBtn = UIImageView()
        bTextBtn.image = UIImage(named:"icon_round_send")?.withRenderingMode(.alwaysTemplate)
        bTextBtn.tintColor = .white
        bTextBtn.layer.opacity = 0.5
        bottomBox.addSubview(bTextBtn)
        bTextBtn.translatesAutoresizingMaskIntoConstraints = false
        bTextBtn.trailingAnchor.constraint(equalTo: bottomBox.trailingAnchor, constant: -15).isActive = true
        bTextBtn.centerYAnchor.constraint(equalTo: bText.centerYAnchor).isActive = true
        bTextBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        bTextBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        bTextBtn.isHidden = true
        
        lTextBtn.image = UIImage(named:"icon_outline_photo")?.withRenderingMode(.alwaysTemplate)
        lTextBtn.tintColor = .white
        lTextBtn.layer.opacity = 0.5
        bottomBox.addSubview(lTextBtn)
        lTextBtn.translatesAutoresizingMaskIntoConstraints = false
        lTextBtn.trailingAnchor.constraint(equalTo: bottomBox.trailingAnchor, constant: -15).isActive = true
        lTextBtn.centerYAnchor.constraint(equalTo: bText.centerYAnchor).isActive = true
        lTextBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        lTextBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        lTextBtn.isHidden = false

        mTextBtn.image = UIImage(named:"icon_round_emoji")?.withRenderingMode(.alwaysTemplate)
        mTextBtn.tintColor = .white
        mTextBtn.layer.opacity = 0.5
        bottomBox.addSubview(mTextBtn)
        mTextBtn.translatesAutoresizingMaskIntoConstraints = false
        mTextBtn.trailingAnchor.constraint(equalTo: lTextBtn.leadingAnchor, constant: -10).isActive = true
        mTextBtn.centerYAnchor.constraint(equalTo: bText.centerYAnchor).isActive = true
        mTextBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        mTextBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        mTextBtn.isHidden = false

        nTextBtn.image = UIImage(named:"icon_round_at")?.withRenderingMode(.alwaysTemplate)
        nTextBtn.tintColor = .white
        nTextBtn.layer.opacity = 0.5
        bottomBox.addSubview(nTextBtn)
        nTextBtn.translatesAutoresizingMaskIntoConstraints = false
        nTextBtn.trailingAnchor.constraint(equalTo: mTextBtn.leadingAnchor, constant: -10).isActive = true
        nTextBtn.centerYAnchor.constraint(equalTo: bText.centerYAnchor).isActive = true
        nTextBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        nTextBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        nTextBtn.isHidden = false
        
        //test > gesture recognizer for dragging user panel
//        let panelPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onPostPanelPanGesture))
//        self.addGestureRecognizer(panelPanGesture)
        
        //test > vcv gesture
        let vPanelPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onVCVPanGesture))
        vPanelPanGesture.delegate = self //for simultaneous pan recognizer for uicollectionview
//        postCV.addGestureRecognizer(vPanelPanGesture)
        feedScrollView.addGestureRecognizer(vPanelPanGesture)
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
    
    var direction = "na"
    //test > another variable for threshold to shrink postpanel, instead of normal scroll
    var isToPostPan = false
    @objc func onVCVPanGesture(gesture: UIPanGestureRecognizer) {
        if(gesture.state == .began) {
//            if(vcDataList.count > 1) {
                if(currentIndex == 0 || currentIndex == vcDataList.count - 1) {
                    
                    //test
                    currentPhotoTopCons = photoPanelTopCons!.constant
                    currentPhotoLeadingCons = photoPanelLeadingCons!.constant

                    //test
                    self.delegate?.didStartPhotoPanGesture(ppv: self)
                }
//            }
        } else if(gesture.state == .changed) {
            let translation = gesture.translation(in: self)
            let x = translation.x
            var y = translation.y

            let velocity = gesture.velocity(in: self)

//            print("postpanel vcv panning: \(isCarouselScrolled), \(x), \(currentIndexPath)")
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
                else if (currentIndex == vcDataList.count - 1) {
                    if(direction == "na") {
                        if(abs(x) > abs(y)) {
                            direction = "x"
                        } else {
                            direction = "y"
                        }
                    }
                    if(direction == "x") {
                        if(x < -40) {
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
            }
            //test > minimize even when not multiple tab
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
                            if(!isCarouselScrolled) {
                                isToPostPan = true
                            }
                        } else {
                            print("postpanel vcv panning no exit")
                        }
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
                print("onPan change circle mask: \(dist), \(currentPhotoTopCons), \(currentPhotoLeadingCons)")

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
                    photoPanelTopCons?.constant = currentPhotoTopCons + y
                    photoPanelLeadingCons?.constant = currentPhotoLeadingCons + x
                } else {
                    //test > move back to 0, 0
                    photoPanelTopCons?.constant = 0.0
                    photoPanelLeadingCons?.constant = 0.0
                }
            }
            
        } else if(gesture.state == .ended){
            
            //test => if count == 1, onsoundpanelgesture will be triggered too, then conflict, video panel will pause
//            if(vcDataList.count > 1) {
                if(currentIndex == 0 || currentIndex == vcDataList.count - 1) {
                    //test
                    let width = viewWidth
                    let height = viewHeight + 100

                    let distLimit = 100.0 //default : 50
                    let x2 = pow(photoPanelLeadingCons!.constant, 2)
                    let y2 = pow(photoPanelTopCons!.constant, 2)
                    let dist = sqrt(x2 + y2)

                    if(dist >= distLimit) {
                        self.delegate?.didStartClosePhotoPanel(ppv: self)

                    } else {
                        let oriX = width/2 - height/2 //default 200
                        let oriY = viewHeight/2 - height/2
                        let circlePath = UIBezierPath(ovalIn: CGRect(x: oriX, y: oriY, width: height, height: height))
                        shapeLayer.path = circlePath.cgPath

                        //test > move back to 0, 0
                        photoPanelTopCons?.constant = 0.0
                        photoPanelLeadingCons?.constant = 0.0

                        //test
                        self.delegate?.didEndPhotoPanGesture(ppv: self)
                    }
                }
                
                //test > determine direction of scroll
                direction = "na"
                
                //test
                isToPostPan = false
//            }
        }
    }

    @objc func onBackPostPanelClicked(gesture: UITapGestureRecognizer) {

        //test
        self.delegate?.didStartClosePhotoPanel(ppv: self)
    }

    func close(isAnimated: Bool) {
        //test > shrink video panel when touch
        if(isAnimated) {

            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
                self.photoPanel.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                    .concatenating(CGAffineTransform(translationX: self.offsetX, y: self.offsetY))
                self.photoPanel.layer.cornerRadius = 200

            }, completion: { finished in
                //test > stop video before closing panel
                self.pauseCurrentAudio()
                //
                
                self.removeFromSuperview()

                self.delegate?.didFinishClosePhotoPanel(ppv : self)
            })
        } else {
            //test > stop video before closing panel
            self.pauseCurrentAudio()
            //
            
            self.removeFromSuperview()

            self.delegate?.didFinishClosePhotoPanel(ppv : self)
        }
    }

    func open(offX: CGFloat, offY: CGFloat, delay: CGFloat, isAnimated: Bool) {

        //test > make video panel return to original size
        self.photoPanel.transform = CGAffineTransform.identity
        photoPanelTopCons?.constant = 0
        photoPanelLeadingCons?.constant = 0
        self.photoPanel.layer.cornerRadius = 10

        if(isAnimated) {
//            self.delegate?.didStartOpenVideoPanel()

            offsetX = offX
            offsetY = offY

            self.photoPanel.layer.cornerRadius = 200 //default: 10
            self.photoPanel.transform = CGAffineTransform(scaleX: 0.001, y: 0.001).concatenating(CGAffineTransform(translationX: offX, y: offY))
            UIView.animate(withDuration: 0.2, delay: delay, options: [.curveEaseInOut], //default: 0.2
                animations: {
                self.photoPanel.transform = CGAffineTransform.identity
                self.photoPanel.layer.cornerRadius = 10
                
                //test > single photo view
//                if(!self.predeterminedDatasets.isEmpty) {
//                    self.asyncInitPredeterminedDatasets(dataset: self.predeterminedDatasets)
//                }
            }, completion: { finished in
//                self.delegate?.didFinishOpenVideoPanel()

                //test > play video
//                self.startPlayVideo()

                //test
                self.initialize()
                
                //test > single video view
//                if(self.predeterminedDatasets.isEmpty) {
//                    self.initialize()
//                }
            })
        }
    }
    
    //test > redraw UI based on originator(from marker or mini app)
    func defineDataset() {
        if(isMultipleTab) {
            vcDataList.append("fy") //for you
//            vcDataList.append("f") //following
            vcDataList.append("e") //eats
            vcDataList.append("t") //tesla
        } else{
            vcDataList.append("a")
        }
    }
    
    func redrawUI() {
        //test > add sections tab
        if(isMultipleTab) {
            photoPanel.addSubview(tabScrollView)
            tabScrollView.backgroundColor = .clear //clear
            tabScrollView.translatesAutoresizingMaskIntoConstraints = false
            tabScrollView.heightAnchor.constraint(equalToConstant: 40).isActive = true //ori 60
    //        tabScrollView.topAnchor.constraint(equalTo: aStickyHeader.bottomAnchor, constant: 0).isActive = true
//            tabScrollView.centerYAnchor.constraint(equalTo: aBtn.centerYAnchor, constant: 0).isActive = true
            tabScrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            tabScrollView.leadingAnchor.constraint(equalTo: photoPanel.leadingAnchor, constant: tabScrollMargin).isActive = true //20
            tabScrollView.trailingAnchor.constraint(equalTo: photoPanel.trailingAnchor, constant: -tabScrollMargin).isActive = true
            tabScrollView.showsHorizontalScrollIndicator = false
            tabScrollView.alwaysBounceHorizontal = true //test
            tabScrollView.delegate = self
            
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
            photoPanel.addSubview(tabScrollLHSBtn)
            tabScrollLHSBtn.translatesAutoresizingMaskIntoConstraints = false
            tabScrollLHSBtn.widthAnchor.constraint(equalToConstant: 14).isActive = true //ori: 40
            tabScrollLHSBtn.heightAnchor.constraint(equalToConstant: 14).isActive = true
            tabScrollLHSBtn.trailingAnchor.constraint(equalTo: tabScrollView.leadingAnchor, constant: -2).isActive = true
            tabScrollLHSBtn.centerYAnchor.constraint(equalTo: tabScrollView.centerYAnchor, constant: 0).isActive = true
            tabScrollLHSBtn.isUserInteractionEnabled = true
            tabScrollLHSBtn.layer.cornerRadius = 7
            tabScrollLHSBtn.isHidden = true
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
            photoPanel.addSubview(tabScrollRHSBtn)
            tabScrollRHSBtn.translatesAutoresizingMaskIntoConstraints = false
            tabScrollRHSBtn.widthAnchor.constraint(equalToConstant: 14).isActive = true //ori: 40
            tabScrollRHSBtn.heightAnchor.constraint(equalToConstant: 14).isActive = true
            tabScrollRHSBtn.leadingAnchor.constraint(equalTo: tabScrollView.trailingAnchor, constant: 2).isActive = true
            tabScrollRHSBtn.centerYAnchor.constraint(equalTo: tabScrollView.centerYAnchor, constant: 0).isActive = true
            tabScrollRHSBtn.isUserInteractionEnabled = true
            tabScrollRHSBtn.layer.cornerRadius = 7
            tabScrollRHSBtn.isHidden = true
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
            //

            let addFeedBtn = UIView()
            addFeedBtn.backgroundColor = .clear
    //        addFeedBtn.backgroundColor = .red
            photoPanel.addSubview(addFeedBtn)
            addFeedBtn.translatesAutoresizingMaskIntoConstraints = false
            addFeedBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
            addFeedBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
            addFeedBtn.trailingAnchor.constraint(equalTo: photoPanel.trailingAnchor, constant: -10).isActive = true
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
            addBoxBtn.layer.opacity = 0.5
    //        addBoxBtn.isHidden = true

            let searchFeedBtn = UIView()
            searchFeedBtn.backgroundColor = .clear
    //        addFeedBtn.backgroundColor = .red
            photoPanel.addSubview(searchFeedBtn)
            searchFeedBtn.translatesAutoresizingMaskIntoConstraints = false
            searchFeedBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
            searchFeedBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
            searchFeedBtn.leadingAnchor.constraint(equalTo: photoPanel.leadingAnchor, constant: 10).isActive = true
            searchFeedBtn.centerYAnchor.constraint(equalTo: tabScrollView.centerYAnchor, constant: 0).isActive = true
            searchFeedBtn.isUserInteractionEnabled = true
            searchFeedBtn.isHidden = true
            
            let searchBoxBtn = UIImageView()
            searchBoxBtn.image = UIImage(named:"icon_round_search")?.withRenderingMode(.alwaysTemplate)
            searchBoxBtn.tintColor = .white
            searchFeedBtn.addSubview(searchBoxBtn)
            searchBoxBtn.translatesAutoresizingMaskIntoConstraints = false
            searchBoxBtn.centerXAnchor.constraint(equalTo: searchFeedBtn.centerXAnchor).isActive = true
            searchBoxBtn.centerYAnchor.constraint(equalTo: searchFeedBtn.centerYAnchor).isActive = true
            searchBoxBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
            searchBoxBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
            searchBoxBtn.layer.opacity = 0.5
    //        addBoxBtn.isHidden = true
        } else {
            let stickyHLight = UIView()
            photoPanel.addSubview(stickyHLight)
            stickyHLight.translatesAutoresizingMaskIntoConstraints = false
            stickyHLight.centerXAnchor.constraint(equalTo: photoPanel.centerXAnchor, constant: 0).isActive = true
            stickyHLight.heightAnchor.constraint(equalToConstant: 40).isActive = true //30
            stickyHLight.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            
            let aTabText = UILabel()
            aTabText.textAlignment = .center
            aTabText.textColor = .white
            aTabText.font = .boldSystemFont(ofSize: 15) //default 14
            aTabText.text = "Shots"
            stickyHLight.addSubview(aTabText)
            aTabText.translatesAutoresizingMaskIntoConstraints = false
            aTabText.leadingAnchor.constraint(equalTo: stickyHLight.leadingAnchor, constant: 0).isActive = true
            aTabText.trailingAnchor.constraint(equalTo: stickyHLight.trailingAnchor, constant: 0).isActive = true
            aTabText.centerYAnchor.constraint(equalTo: stickyHLight.centerYAnchor).isActive = true
        }
    }
    
    func setPreterminedDatasets(datasets: [String]){
        predeterminedDatasets.append(contentsOf: datasets)
    }
    
    var isMultipleTab = false
    func setDatasetUI(isMultiTab: Bool){
        
        isMultipleTab = isMultiTab
        
        //test > redraw UI based on originator(from marker or mini app)
        defineDataset()
        redrawUI()
        
        //test
//        redrawScrollFeedUI()
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
        let viewWidth = self.frame.width
        let feedHeight = feedScrollView.frame.height
        for _ in vcDataList {
            let stack = ScrollFeedHPhotoListCell()
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
            stack.setShowVerticalScroll(isShowVertical: false)
        }
        
        let tabCount = vcDataList.count
        feedScrollView.contentSize = CGSize(width: viewWidth * CGFloat(tabCount), height: feedHeight)
        print("postpanel contentsize \(viewWidth * CGFloat(tabCount)), \(feedHeight)")
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
    
    func asyncInit(id: String) {
        DataFetchManager.shared.fetchData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("postpanel init api success \(id), \(l)")

                    guard let self = self else {
                        return
                    }
                    
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
                    
                    self.redrawScrollFeedUI()
                    
                    //test > async fetch feed
//                    let feed = self.feedList[self.currentIndex]
//                    self.asyncFetchFeed(cell: feed, id: "photo_feed")
                    
                    //test > predetermined datasets
                    if(self.predeterminedDatasets.isEmpty) {
                        let feed = self.feedList[self.currentIndex]
                        self.asyncFetchFeed(cell: feed, id: "photo_feed")
                    } else {
                        self.asyncInitPredeterminedDatasets(dataset: self.predeterminedDatasets)
                    }
                }

                case .failure(_):
                    print("api fail")
                    break
            }
        }
    }
    
    func asyncInitPredeterminedDatasets(dataset: [String]) {
        
        let feed = feedList[currentIndex]
        
        feed.vDataList.removeAll() //remove spinner "b"

        var tempDataList = [PhotoData]()
        for i in dataset {
            let photoData = PhotoData()
            photoData.setDataType(data: i)
            photoData.setData(data: i)
            photoData.setTextString(data: i)
            tempDataList.append(photoData)
        }
        feed.vDataList.append(contentsOf: tempDataList)

        feed.vCV?.reloadData()

        feed.dataPaginateStatus = "end"
//        feed.isInitialized = true
        
//        isInitialized = true
        
        print("photopanel asyncinitdetermined \(dataset)")
    }

    //test > fetch data => temp fake data => try refresh data first
    func refreshFetchData() {
        print("photopanel refreshpanel")
        let feed = feedList[currentIndex]
        feed.dataPaginateStatus = ""
        asyncFetchFeed(cell: feed, id: "photo_feed")
    }
    
    func asyncFetchFeed(cell: ScrollFeedHPhotoListCell?, id: String) {
        print("photopanel asyncFetchFeed")
        cell?.vDataList.removeAll()
        cell?.vCV?.reloadData()

        cell?.aSpinner.startAnimating()
        cell?.bSpinner.stopAnimating()
        
        cell?.dataPaginateStatus = "fetch"

        DataFetchManager.shared.fetchData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("userscrollable api success \(id), \(l)")

                    guard let self = self else {
                        return
                    }

                    guard let feed = cell else {
                        return
                    }
                    
                    //test 2 > new append method
                    for i in l {
                        
                        let photoData = PhotoData()
                        photoData.setDataType(data: i)
                        photoData.setData(data: i)
                        photoData.setTextString(data: i)
                        feed.vDataList.append(photoData)
                    }
                    
                    feed.vCV?.reloadData()

                    //test
                    feed.aSpinner.stopAnimating()
                }

                case .failure(_):
                    print("api fail")
                    break
            }
        }
    }

    func asyncPaginateFetchFeed(cell: ScrollFeedHPhotoListCell?, id: String) {

        cell?.bSpinner.startAnimating()

        DataFetchManager.shared.fetchData(id: id) { [weak self]result in
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
                    
                    //test 2 > new append method
//                    for i in l {
//
//                        let photoData = PhotoData()
//                        photoData.setDataType(data: i)
//                        photoData.setData(data: i)
//                        photoData.setTextString(data: i)
//                        feed.vDataList.append(photoData)
//                    }
//
//                    feed.vCV?.reloadData()
                    
                    //*test 3 > reload only appended data, not entire dataset
                    let dataCount = feed.vDataList.count
                    var indexPaths = [IndexPath]()
                    var j = 1
                    for i in l {
                        let photoData = PhotoData()
                        photoData.setDataType(data: i)
                        photoData.setData(data: i)
                        photoData.setTextString(data: i)
                        feed.vDataList.append(photoData)

                        let idx = IndexPath(item: dataCount - 1 + j, section: 0)
                        indexPaths.append(idx)
                        j += 1
                    }
                    feed.vCV?.insertItems(at: indexPaths)
                    //*

                    //test
                    feed.bSpinner.stopAnimating()
                }

                case .failure(_):
                    print("api fail")
                    break
            }
        }
    }

    //test > share sheet
    func openShareSheet() {
        let sharePanel = ShareSheetScrollableView(frame: CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.height))
        self.addSubview(sharePanel)
        sharePanel.translatesAutoresizingMaskIntoConstraints = false
        sharePanel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        sharePanel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
//        sharePanel.delegate = self
    }
    
    //test > add comment panel
    func openComment() {
        let commentPanel = CommentScrollableView(frame: CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.height))
//        self.addSubview(commentPanel)
        photoPanel.insertSubview(commentPanel, belowSubview: bottomBox)
        commentPanel.translatesAutoresizingMaskIntoConstraints = false
        commentPanel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        commentPanel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        commentPanel.delegate = self
        commentPanel.initialize()
        
        bottomBox.isHidden = false
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
    
    //test > stop current video for closing
    func pauseCurrentAudio() {
        let b = feedList[currentIndex]
        b.pauseCurrentAudio()
    }
    //test > resume current video
    func resumeCurrentAudio() {
        let b = feedList[currentIndex]
        b.resumeCurrentAudio()
    }
    func dehideCurrentCell() {
        let b = feedList[currentIndex]
        b.dehideCell()
    }
    //test
    override func resumeActiveState() {
        print("photopanelview resume active")
        resumeCurrentAudio()
        
        //test > dehide cell
        dehideCurrentCell()
    }
    
    //test > check for intersected dummy view with video while user scroll
    func getIntersectedIdx() -> Int {
        let aVc = feedList[currentIndex]
        var intersectedIdx = -1
        if let v = aVc.vCV {
            print("sfvideo ppv start \(v.visibleCells)")
            for cell in v.visibleCells {
                guard let indexPath = v.indexPath(for: cell) else {
                    continue
                }
                guard let b = cell as? HPhotoListAViewCell else {
                    return -1
                }

                let cellRect = v.convert(b.frame, to: aVc)
                let aTestRect = b.aTest.frame
                let feedScrollViewRect = feedScrollView.frame
                print("sfvideo ppv scroll \(indexPath), \(feedScrollViewRect)")
                if(!b.musicConArray.isEmpty) {
                    let vidC = b.musicConArray[0]
                    let vidCFrame = vidC.frame
//                    let convertedVidCOriginY = cellRect.origin.y + aTestRect.origin.y + vidCFrame.origin.y
                    let convertedVidCOriginY = feedScrollViewRect.origin.y + cellRect.origin.y + aTestRect.origin.y + vidCFrame.origin.y
                    let convertedVidCRect = CGRect(x: 0, y: convertedVidCOriginY, width: vidCFrame.size.width, height: vidCFrame.size.height)
                    //size can be changed
//                    let dummyView = CGRect(x: 0, y: 100, width: self.frame.width, height: vidCFrame.size.height)
                    let dummyView = CGRect(x: 0, y: 100, width: self.frame.width, height: 400) //y:200, h:300
//                    let dV = UIView(frame: dummyView)
//                    dV.backgroundColor = .blue
//                    self.addSubview(dV)
                    
                    let isIntersect = dummyView.intersects(convertedVidCRect)
                    let intersectArea = dummyView.intersection(convertedVidCRect)

                    print("sfvideo x ppv 3.0 collectionView index: \(indexPath), \(isIntersect), \(intersectArea)")
                    
                    //test > play video if intersect
                    if(isIntersect) {
                        intersectedIdx = indexPath.item
                    }
                }
            }
        }
        print("getIntersectedIdx: \(intersectedIdx)")
        return intersectedIdx
    }
    
    func asyncAutoplay(id: String) {
        DataFetchManager.shared.fetchData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    guard let self = self else {
                        return
                    }
                    print("asyncLayoutVc api success \(id), \(l), \(self.getIntersectedIdx())")
                    let aVc = self.feedList[self.currentIndex]
                    aVc.reactToIntersectedAudio(intersectedIdx: self.getIntersectedIdx())
                }

                case .failure(_):
                    print("api fail")
                    break
            }
        }
    }
}

extension PhotoPanelView: UIScrollViewDelegate {
    
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
            //*
        }

    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView == feedScrollView) {
            let xOffset = scrollView.contentOffset.x
            let viewWidth = self.frame.width
            let currentIndex = round(xOffset/viewWidth)

            if(!self.tabList.isEmpty) {
                let currentItemIndex = tempCurrentIndex
                let currentX = photoPanel.frame.width * CGFloat(currentItemIndex)
                let currentTabWidth = tabList[currentItemIndex].frame.width
                var hOffsetX = 0.0
                if(xOffset >= currentX) {
                    var nextTabWidth = tabList[currentItemIndex].frame.width
                    if(currentItemIndex < tabList.count - 1) {
                        nextTabWidth = tabList[currentItemIndex + 1].frame.width
                    }
                    hOffsetX = (xOffset - currentX)/(photoPanel.frame.width) * currentTabWidth + currentTabSelectLeadingCons
                    tabSelectLeadingCons?.constant = hOffsetX

                    let hWidth = (xOffset - currentX)/(photoPanel.frame.width) * (nextTabWidth - currentTabWidth) + currentTabWidth
                    tabSelectWidthCons?.constant = hWidth
                }
                else if (xOffset < currentX) {
                    var prevTabWidth = tabList[currentItemIndex].frame.width
                    if(currentItemIndex > 0) {
                        prevTabWidth = tabList[currentItemIndex - 1].frame.width
                    }

                    hOffsetX = (xOffset - currentX)/(photoPanel.frame.width) * prevTabWidth + currentTabSelectLeadingCons
                    tabSelectLeadingCons?.constant = hOffsetX

                    let hWidth = (xOffset - currentX)/(photoPanel.frame.width) * (currentTabWidth - prevTabWidth) + currentTabWidth
                    tabSelectWidthCons?.constant = hWidth
                }
                
                //test > tabscroll move along when feedscroll scroll to next tab
                if(self.tabList.count > 1) { //otherwise tabscroll cannot contentoffset
                    var oX = hOffsetX
                    if(hOffsetX > totalTabScrollXLead) {
                        oX = totalTabScrollXLead
                    }
                    let tabXContentOffset = oX/totalTabScrollXLead * tabScrollGap
                    tabScrollView.setContentOffset(CGPoint(x: tabXContentOffset, y: 0), animated: false)
                }
            }
            
            //test > async fetch feed
            let rIndex = Int(round(currentIndex))
            let feed = self.feedList[rIndex]
            if(feed.dataPaginateStatus == "") {
                self.asyncFetchFeed(cell: feed, id: "photo_feed")
            }
        }
        else if(scrollView == tabScrollView) {
            print("ppv did scroll \(tabScrollView.contentOffset.x), \(tabScrollGap)")
            let tabXOffset = scrollView.contentOffset.x
            self.arrowReactToTabScroll(tabXOffset: tabXOffset)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if(scrollView == feedScrollView) {
            let xOffset = scrollView.contentOffset.x
            let viewWidth = self.frame.width
            
            let visibleIndex = Int(xOffset/viewWidth)
            let currentFeed = self.feedList[visibleIndex]
            let previousFeed = self.feedList[currentIndex]
            
//            currentIndex = Int(xOffset/viewWidth)
            currentIndex = visibleIndex
            
            if(currentFeed != previousFeed) {
                currentFeed.resumeCurrentAudio()
                previousFeed.pauseCurrentAudio()
            }
            
            //test > change tab title font opacity when scrolled
            reactToTabSectionChange(index: currentIndex)
        }
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if(scrollView == feedScrollView) {
            let xOffset = scrollView.contentOffset.x
            let viewWidth = self.frame.width
            
            let visibleIndex = Int(xOffset/viewWidth)
            let currentFeed = self.feedList[visibleIndex]
            let previousFeed = self.feedList[currentIndex]
            
//            currentIndex = Int(xOffset/viewWidth)
            currentIndex = visibleIndex
            
            if(currentFeed != previousFeed) {
                currentFeed.resumeCurrentAudio()
                previousFeed.pauseCurrentAudio()
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
}

//test > link delegate implementation
extension ViewController: PhotoPanelDelegate{

    func didStartOpenPhotoPanel() {
        activateQueueState()
    }
    func didFinishOpenPhotoPanel() {
        stopPulseWave()
    }
    func didStartClosePhotoPanel(ppv : PhotoPanelView) {

//        ppv.offsetX = ppv.offsetX - ppv.photoPanelLeadingCons!.constant
//        ppv.offsetY = ppv.offsetY - ppv.photoPanelTopCons!.constant
//        ppv.close(isAnimated: true)
        
        //test 2 > dequeue object deactivate video active state
        deactivateQueueState()

        if(ppv.originatorViewType == OriginatorTypes.MARKER) {
            guard let mapView = self.mapView else {
                return
            }
            guard let coord = ppv.coordinateLocation else {
                return
            }
            let point = mapView.projection.point(for: coord)
            ppv.offsetX = point.x - self.view.frame.width/2
            ppv.offsetY = point.y - self.view.frame.height/2
            ppv.offsetX = ppv.offsetX - ppv.photoPanelLeadingCons!.constant
            ppv.offsetY = ppv.offsetY - ppv.photoPanelTopCons!.constant + ppv.adjustmentY

            ppv.close(isAnimated: true)

        } else if(ppv.originatorViewType == OriginatorTypes.PULSEWAVE){
            guard let mapView = self.mapView else {
                return
            }
            guard let coord = ppv.coordinateLocation else {
                return
            }
            let point = mapView.projection.point(for: coord)
            ppv.offsetX = point.x - self.view.frame.width/2
            ppv.offsetY = point.y - self.view.frame.height/2
            ppv.offsetX = ppv.offsetX - ppv.photoPanelLeadingCons!.constant
            ppv.offsetY = ppv.offsetY - ppv.photoPanelTopCons!.constant

            ppv.close(isAnimated: true)
        } else {
            ppv.offsetX = ppv.offsetX - ppv.photoPanelLeadingCons!.constant
            ppv.offsetY = ppv.offsetY - ppv.photoPanelTopCons!.constant

            ppv.close(isAnimated: true)
        }
    }

    func didFinishClosePhotoPanel(ppv : PhotoPanelView) {

//        //test
//        backPage(isCurrentPageScrollable: false)
//
//        //test
////        shutterCMiniGifImage()
//        if(selectedMiniAppIndex > -1) {
//            miniAppViewList[selectedMiniAppIndex].shutterMiniGifImage()
//        }
        
        //test 2 > new method
        backPage(isCurrentPageScrollable: false)

        //test > get marker id for marker closing animation
        if(ppv.originatorViewType == OriginatorTypes.MARKER) {
            print("didFinishCloseVideoPanel \(ppv.getOriginatorId())")
            if var a = self.markerGeoMarkerIdList[ppv.getOriginatorId()] {
                a.animateFromVideoClose()
            }
        } else if(ppv.originatorViewType == OriginatorTypes.MAP_TOP_UIVIEW){
            shutterSemiTransparentGifImage()
        } else if(ppv.originatorViewType == OriginatorTypes.MAP_VIDEO_MINIAPP_UIVIEW){
//            shutterBMiniGifImage()
            if(selectedMiniAppIndex > -1) {
                miniAppViewList[selectedMiniAppIndex].shutterMiniGifImage()
            }
        }
        //test > make viewcell reappear after video panel closes
        else if(ppv.originatorViewType == OriginatorTypes.UIVIEW){
            if(!pageList.isEmpty) {
//                if let c = pageList[pageList.count - 1] as? PlaceScrollablePanelView {
//                    c.dehideViewCell()
//                }
//                if let d = pageList[pageList.count - 1] as? UserScrollablePanelView {
//                    d.dehideViewCell()
//                }
////                if let e = pageList[pageList.count - 1] as? SoundPanelView {
////                    e.dehideViewCell()
////                }
//                if let e = pageList[pageList.count - 1] as? SoundScrollablePanelView {
//                    e.dehideViewCell()
//                }
            }
        }
    }

    func didStartPhotoPanGesture(ppv : PhotoPanelView) {
////        hideCMiniGifImage()
//        if(selectedMiniAppIndex > -1) {
//            miniAppViewList[selectedMiniAppIndex].hideMiniGifImage()
//        }
        
        //test 2 > hide marker ready for shutter after video closes
        if(ppv.originatorViewType == OriginatorTypes.MARKER) {
            if var a = self.markerGeoMarkerIdList[ppv.getOriginatorId()] {
                a.hideForShutter()
            }
        } else if(ppv.originatorViewType == OriginatorTypes.MAP_TOP_UIVIEW){
            hideSemiTransparentGifImage()
        } else if(ppv.originatorViewType == OriginatorTypes.MAP_VIDEO_MINIAPP_UIVIEW){
//            hideBMiniGifImage()
            if(selectedMiniAppIndex > -1) {
                miniAppViewList[selectedMiniAppIndex].hideMiniGifImage()
            }
        }
    }
    func didEndPhotoPanGesture(ppv : PhotoPanelView){
////        dehideCMiniGifImage()
//        if(selectedMiniAppIndex > -1) {
//            miniAppViewList[selectedMiniAppIndex].dehideMiniGifImage()
//        }
        
        //test > de-hide marker ready for shutter if video NOT close, resume play
        if(ppv.originatorViewType == OriginatorTypes.MARKER) {
            if var a = self.markerGeoMarkerIdList[ppv.getOriginatorId()] {
                a.dehideForShutter()
            }
        } else if(ppv.originatorViewType == OriginatorTypes.MAP_TOP_UIVIEW){
            dehideSemiTransparentGifImage()
        } else if(ppv.originatorViewType == OriginatorTypes.MAP_VIDEO_MINIAPP_UIVIEW){
//            dehideBMiniGifImage()
            if(selectedMiniAppIndex > -1) {
                miniAppViewList[selectedMiniAppIndex].dehideMiniGifImage()
            }
        }
    }

    func didClickPhotoPanelVcvComment() {

    }
    func didClickPhotoPanelVcvLove() {

    }
    func didClickPhotoPanelVcvShare() {

    }
    func didClickPhotoPanelVcvClickUser() {
        deactivateQueueState()
        //test
        openUserPanel()
    }
    func didClickPhotoPanelVcvClickPlace() {
        deactivateQueueState()
        openPlacePanel()
    }
    func didClickPhotoPanelVcvClickSound() {
        deactivateQueueState()
        openSoundPanel()
    }
    func didClickPhotoPanelVcvClickPost() {

    }
    func didClickPhotoPanelVcvClickPhoto(pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String) {
//        openPhotoDetailPanel()
        
        let offsetX = pointX - self.view.frame.width/2 + view.frame.width/2
        let offsetY = pointY - self.view.frame.height/2 + view.frame.height/2
        
        if(mode == PhotoTypes.P_SHOT_DETAIL) {
            openPhotoDetailPanel()
        } else if(mode == PhotoTypes.P_0){
            openPhotoZoomPanel(offX: offsetX, offY: offsetY)
        }
    }
}

extension PhotoPanelView: CommentScrollableDelegate{
    func didCClickUser(){
//        delegate?.didClickUser()
    }
    func didCClickPlace(){
//        delegate?.didClickPlace()
    }
    func didCClickSound(){
//        delegate?.didClickSound()
    }
    func didCClickClosePanel(){
        bottomBox.isHidden = true
    }
    func didCFinishClosePanel() {
//        resumeCurrentVideo()
    }
}

extension PhotoPanelView: ScrollFeedCellDelegate {
    func sfcWillBeginDragging(offsetY: CGFloat) {

    }
    func sfcScrollViewDidScroll(offsetY: CGFloat) {
        print("ppv sfc scroll \(offsetY)")
        //test
        let aVc = feedList[currentIndex]
        aVc.reactToIntersectedAudio(intersectedIdx: getIntersectedIdx())
    }
    func sfcSrollViewDidEndDecelerating(offsetY: CGFloat) {

    }
    func sfcScrollViewDidEndDragging(offsetY: CGFloat, decelerate: Bool) {

        if(offsetY < -80) {
//            self.refreshFetchData()
            
            if(self.predeterminedDatasets.isEmpty) {
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

    func sfcDidClickVcvItem(pointX: CGFloat, pointY: CGFloat, view:UIView, itemIndex:IndexPath){

    }
    func sfcDidClickVcvComment() {
        print("fcDidClickVcvComment ")
        openComment()
    }
    func sfcDidClickVcvLove() {
        print("fcDidClickVcvLike ")
    }
    func sfcDidClickVcvShare() {
        print("fcDidClickVcvShare ")
        openShareSheet()
    }

    func sfcDidClickVcvClickUser() {
        //test
        delegate?.didClickPhotoPanelVcvClickUser()
        
        //test > pause current playing video when go to user
        pauseCurrentAudio()
    }
    func sfcDidClickVcvClickPlace() {
        delegate?.didClickPhotoPanelVcvClickPlace()
        
        //test > pause current playing video when go to user
        pauseCurrentAudio()
    }
    func sfcDidClickVcvClickSound() {
        delegate?.didClickPhotoPanelVcvClickSound()
        
        //test > pause current playing video when go to user
        pauseCurrentAudio()
    }
    func sfcDidClickVcvClickPost() {

    }
    func sfcDidClickVcvClickPhoto(pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String) {
        print("photopanelview click post")
//        openPhotoDetail()
        
        //test > pause current playing video when go to user
        pauseCurrentAudio()
        
        //test > open photo zoom panel
//        if(mode == PhotoTypes.P_SHOT) {
////            openPhotoDetail()
//            delegate?.didClickPhotoPanelVcvClickPhoto()
//        } else if(mode == PhotoTypes.P_0){
//            let b = self.feedList[self.currentIndex]
//            let originInRootView = feedScrollView.convert(b.frame.origin, to: self)
//
//            let adjustY = pointY + originInRootView.y
//
//            let offsetX = pointX - self.frame.width/2 + view.frame.width/2
//            let offsetY = adjustY - self.frame.height/2 + view.frame.height/2
//            print("open photo0: \(self.frame.width), \(view.frame.width), \(view.frame.height)")
//            openPhotoZoom(offX: offsetX, offY: offsetY)
//        }
        
        //test 2
        let b = self.feedList[self.currentIndex]
        let originInRootView = feedScrollView.convert(b.frame.origin, to: self)
        
        let adjustY = pointY + originInRootView.y
        
        delegate?.didClickPhotoPanelVcvClickPhoto(pointX: pointX, pointY: adjustY, view: view, mode: mode)
    }
    func sfcDidClickVcvClickVideo(pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String) {
        
    }

    //test
    func sfcAsyncFetchFeed() {

    }
    func sfcAsyncPaginateFeed(cell: ScrollFeedCell?) {
        //test
        print("feedhresultlistcell real paginate async")
        
        if let d = cell as? ScrollFeedHPhotoListCell {
//            self.asyncPaginateFetchFeed(cell: d, id: "photo_feed_end")
            
            //test > open single video
            if(self.predeterminedDatasets.isEmpty) {
                self.asyncPaginateFetchFeed(cell: d, id: "photo_feed_end")
            }
        }
    }
    
    func sfcIsScrollCarousel(isScroll: Bool) {
        isCarouselScrolled = isScroll
    }
    
    func sfcAutoplayVideo(cell: ScrollFeedCell?, vCCell: UICollectionViewCell?) {
//    func sfcAutoplayVideo(cell: ScrollFeedCell?, vCCell: HPostListAViewCell?) {
        //test > method 3 => add a timer before check for intersected rect first
        asyncAutoplay(id: "search_term")
    }
}

extension PhotoPanelView: TabStackDelegate {
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
