//
//  VideoPanelView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage
import GoogleMaps

protocol VideoPanelDelegate : AnyObject {
    func didClickUser()
    func didClickPlace()
    func didClickSound()
    func didClickPost()
    func didStartOpenVideoPanel()
    func didFinishOpenVideoPanel()
    func didStartCloseVideoPanel(vpv : VideoPanelView)
    func didFinishCloseVideoPanel(vpv : VideoPanelView)

    //test > for marker animation after video closes
    func didStartVideoPanGesture(vpv : VideoPanelView)
    func didEndVideoPanGesture(vpv : VideoPanelView)
    
    func didClickVideoPanelClickPhoto(pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String) //try
    func didClickVideoPanelClickVideo(pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String) //try
}

class VideoPanelView: PanelView, UIGestureRecognizerDelegate{
    var videoPanel = UIView()
    var vcDataList = [String]()
    
    weak var delegate : VideoPanelDelegate?

    var videoPanelTopCons: NSLayoutConstraint?
    var videoPanelLeadingCons: NSLayoutConstraint?
    var currentVideoTopCons : CGFloat = 0.0
    var currentVideoLeadingCons : CGFloat = 0.0

    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0

    var offsetX: CGFloat = 0.0
    var offsetY: CGFloat = 0.0

    //test > comment panel
    var panelTopCons: NSLayoutConstraint?
    var currentPanelTopCons : CGFloat = 0.0
    var aView = UIView()

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
    var textPanelBottomCons: NSLayoutConstraint?
    var aTextBoxHeightCons: NSLayoutConstraint?
    var aTextTrailingCons: NSLayoutConstraint?
    var aTextBottomCons: NSLayoutConstraint?
    let aTextBox = UITextView()
    var aaViewTrailingCons: NSLayoutConstraint?
    let textPanel = UIView()
    var currentFirstResponder : UITextView?
    var isKeyboardUp = false
    let bottomBox = UIView()

    //test > circle mask
    var cView = UIView()

    //test > comment textbox
    let bTextBtn = UIImageView()
    let lTextBtn = UIImageView()
    let mTextBtn = UIImageView()
    let nTextBtn = UIImageView()

    //test > marker id
    var originatorViewId = ""

    //test > check whether video panel is opened
    var isPanelOpen = false

    let sendBox = UIView()
    let aaView = UIView()
    let xGrid = UIView()
    let bbText = UILabel()
    
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
    var feedList = [ScrollFeedVideoCell]()
    var currentIndex = 0

    let tabScrollLHSBtn = UIView()
    let tabScrollRHSBtn = UIView()
    
    var isMultipleTab = false
    var predeterminedDatasets = [String]()
    var uiMode = VideoTypes.V_LOOP //"loop", "video"
    
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
        videoPanel.layer.addSublayer(shapeLayer)

        videoPanel.layer.mask = shapeLayer
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

        videoPanel.backgroundColor = .black
//        videoPanel.backgroundColor = .ddmBlackOverlayColor
        self.addSubview(videoPanel)
        videoPanel.translatesAutoresizingMaskIntoConstraints = false
//        videoPanel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        videoPanel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        videoPanel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //default 0
//        videoPanel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        videoPanel.layer.masksToBounds = true
        //test
        videoPanel.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        videoPanel.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        videoPanelTopCons = videoPanel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        videoPanelTopCons?.isActive = true
        videoPanelLeadingCons = videoPanel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
        videoPanelLeadingCons?.isActive = true

        //test > try uicollectionview instead of static image
//        vcDataList.append("a")
//        vcDataList.append("a")//nil
//        vcDataList.append("a")//nil
        
        videoPanel.addSubview(feedScrollView)
        feedScrollView.backgroundColor = .ddmBlackOverlayColor
        feedScrollView.translatesAutoresizingMaskIntoConstraints = false
        feedScrollView.topAnchor.constraint(equalTo: videoPanel.topAnchor).isActive = true
        feedScrollView.bottomAnchor.constraint(equalTo: videoPanel.bottomAnchor, constant: -94).isActive = true
        feedScrollView.leadingAnchor.constraint(equalTo: videoPanel.leadingAnchor, constant: 0).isActive = true
        feedScrollView.trailingAnchor.constraint(equalTo: videoPanel.trailingAnchor, constant: 0).isActive = true
        feedScrollView.showsHorizontalScrollIndicator = false
        feedScrollView.alwaysBounceHorizontal = true //test
        feedScrollView.isPagingEnabled = true
        feedScrollView.delegate = self
        
        //test bottom comment box => fake edittext
        bottomBox.backgroundColor = .black
        videoPanel.addSubview(bottomBox)
        bottomBox.clipsToBounds = true
        bottomBox.translatesAutoresizingMaskIntoConstraints = false
        bottomBox.leadingAnchor.constraint(equalTo: videoPanel.leadingAnchor, constant: 0).isActive = true
        bottomBox.trailingAnchor.constraint(equalTo: videoPanel.trailingAnchor, constant: 0).isActive = true
        bottomBox.heightAnchor.constraint(equalToConstant: 94).isActive = true //default: 50
        bottomBox.bottomAnchor.constraint(equalTo: videoPanel.bottomAnchor, constant: 0).isActive = true
        bottomBox.isUserInteractionEnabled = true
        let aPanelPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onTextViewPanGesture))
        bottomBox.addGestureRecognizer(aPanelPanGesture)
        bottomBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onOpenTextBoxClicked)))

        let bText = UILabel()
        bText.textAlignment = .left
        bText.textColor = .white
        bText.font = .boldSystemFont(ofSize: 13)
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

        //test > real textview edittext for comment
        videoPanel.addSubview(aView)
        aView.translatesAutoresizingMaskIntoConstraints = false
        aView.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        aView.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        aView.isUserInteractionEnabled = true
        aView.isHidden = true
//        aView.backgroundColor = .clear
//        aView.backgroundColor = .ddmBlackOverlayColor
        aView.backgroundColor = .black
        aView.layer.opacity = 0.3 //0.2
        let cPanelPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onTextViewPanGesture))
        aView.addGestureRecognizer(cPanelPanGesture)
        aView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCloseTextBoxClicked)))

//        textPanel.backgroundColor = .black
        textPanel.backgroundColor = .ddmBlackOverlayColor
        videoPanel.addSubview(textPanel)
        textPanel.translatesAutoresizingMaskIntoConstraints = false
        textPanel.leadingAnchor.constraint(equalTo: videoPanel.leadingAnchor).isActive = true
        textPanel.trailingAnchor.constraint(equalTo: videoPanel.trailingAnchor).isActive = true
        textPanelBottomCons = textPanel.bottomAnchor.constraint(equalTo: videoPanel.bottomAnchor, constant: 0)
        textPanelBottomCons?.isActive = true
//        textPanelHeightCons = textPanel.heightAnchor.constraint(equalToConstant: 60)
//        textPanelHeightCons?.isActive = true
        textPanel.isHidden = true
        textPanel.isUserInteractionEnabled = true
//        textPanel.layer.cornerRadius = 10
//        textPanel.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
//        let bPanelPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onTextViewPanGesture))
//        textPanel.addGestureRecognizer(bPanelPanGesture)

//        let sendBox = UIView()
//        sendBox.backgroundColor = .clear //yellow
        sendBox.backgroundColor = .yellow //yellow
        textPanel.addSubview(sendBox)
        sendBox.translatesAutoresizingMaskIntoConstraints = false
//        sendBox.widthAnchor.constraint(equalToConstant: 30).isActive = true
        sendBox.heightAnchor.constraint(equalToConstant: 30).isActive = true //30
        sendBox.trailingAnchor.constraint(equalTo: textPanel.trailingAnchor, constant: -15).isActive = true //-15
//        sendBox.topAnchor.constraint(equalTo: textPanel.topAnchor, constant: 10).isActive = true
        sendBox.bottomAnchor.constraint(equalTo: textPanel.bottomAnchor, constant: -10).isActive = true
        sendBox.layer.cornerRadius = 15
        sendBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCloseTextBoxClicked)))

        let sendBoxText = UILabel()
        sendBoxText.textAlignment = .center
        sendBoxText.textColor = .black
        sendBoxText.font = .boldSystemFont(ofSize: 13)
        sendBox.addSubview(sendBoxText)
        sendBoxText.translatesAutoresizingMaskIntoConstraints = false
//        gBtnText.topAnchor.constraint(equalTo: gBtn.topAnchor, constant: 10).isActive = true
//        gBtnText.bottomAnchor.constraint(equalTo: gBtn.bottomAnchor, constant: -10).isActive = true
        sendBoxText.centerYAnchor.constraint(equalTo: sendBox.centerYAnchor).isActive = true
        sendBoxText.leadingAnchor.constraint(equalTo: sendBox.leadingAnchor, constant: 10).isActive = true
        sendBoxText.trailingAnchor.constraint(equalTo: sendBox.trailingAnchor, constant: -10).isActive = true
        sendBoxText.text = "Post"

        //**test > try a container for textview
//        let aView = UIView()
//        aView.backgroundColor = .blue
        aaView.backgroundColor = .ddmDarkColor
        textPanel.addSubview(aaView)
        aaView.translatesAutoresizingMaskIntoConstraints = false
        aaView.topAnchor.constraint(equalTo: textPanel.topAnchor, constant: 10).isActive = true
        aaView.bottomAnchor.constraint(equalTo: textPanel.bottomAnchor, constant: -10).isActive = true //-10
        aaView.leadingAnchor.constraint(equalTo: textPanel.leadingAnchor, constant: 15).isActive = true
//        aView.trailingAnchor.constraint(equalTo: textPanel.trailingAnchor, constant: -15).isActive = true
        aaViewTrailingCons = aaView.trailingAnchor.constraint(equalTo: textPanel.trailingAnchor, constant: -15)
        aaViewTrailingCons?.isActive = true
        aaView.layer.cornerRadius = 10

        //test > add icons for adding photo etc
        let zGrid = UIView()
        textPanel.addSubview(zGrid)
//        zGrid.backgroundColor = .red
        zGrid.translatesAutoresizingMaskIntoConstraints = false
        zGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        zGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
        zGrid.trailingAnchor.constraint(equalTo: aaView.trailingAnchor, constant: 0).isActive = true
        zGrid.bottomAnchor.constraint(equalTo: aaView.bottomAnchor, constant: 0).isActive = true

        let zGridIcon = UIImageView(image: UIImage(named:"icon_outline_photo")?.withRenderingMode(.alwaysTemplate))
        zGridIcon.tintColor = .white
        textPanel.addSubview(zGridIcon)
        zGridIcon.translatesAutoresizingMaskIntoConstraints = false
//        zGridIcon.centerXAnchor.constraint(equalTo: pMini.centerXAnchor, constant: 0).isActive = true
//        zGridIcon.bottomAnchor.constraint(equalTo: divider.topAnchor, constant: 0).isActive = true
        zGridIcon.centerXAnchor.constraint(equalTo: zGrid.centerXAnchor, constant: 0).isActive = true
        zGridIcon.centerYAnchor.constraint(equalTo: zGrid.centerYAnchor, constant: 0).isActive = true
        zGridIcon.heightAnchor.constraint(equalToConstant: 26).isActive = true //20
        zGridIcon.widthAnchor.constraint(equalToConstant: 26).isActive = true
        zGridIcon.layer.opacity = 0.5
        
        let yGrid = UIView()
        textPanel.addSubview(yGrid)
//        yGrid.backgroundColor = .red
        yGrid.translatesAutoresizingMaskIntoConstraints = false
        yGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        yGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
        yGrid.trailingAnchor.constraint(equalTo: zGrid.leadingAnchor, constant: 0).isActive = true
        yGrid.bottomAnchor.constraint(equalTo: aaView.bottomAnchor, constant: 0).isActive = true

        let yGridIcon = UIImageView(image: UIImage(named:"icon_round_emoji")?.withRenderingMode(.alwaysTemplate))
        yGridIcon.tintColor = .white
        textPanel.addSubview(yGridIcon)
        yGridIcon.translatesAutoresizingMaskIntoConstraints = false
//        yGridIcon.centerXAnchor.constraint(equalTo: pMini.centerXAnchor, constant: 0).isActive = true
//        yGridIcon.bottomAnchor.constraint(equalTo: divider.topAnchor, constant: 0).isActive = true
        yGridIcon.centerXAnchor.constraint(equalTo: yGrid.centerXAnchor, constant: 0).isActive = true
        yGridIcon.centerYAnchor.constraint(equalTo: yGrid.centerYAnchor, constant: 0).isActive = true
        yGridIcon.heightAnchor.constraint(equalToConstant: 26).isActive = true //20
        yGridIcon.widthAnchor.constraint(equalToConstant: 26).isActive = true
        yGridIcon.layer.opacity = 0.5

//        let xGrid = UIView()
        textPanel.addSubview(xGrid)
//        xGrid.backgroundColor = .red
        xGrid.translatesAutoresizingMaskIntoConstraints = false
        xGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        xGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
        xGrid.trailingAnchor.constraint(equalTo: yGrid.leadingAnchor, constant: 0).isActive = true
        xGrid.bottomAnchor.constraint(equalTo: aaView.bottomAnchor, constant: 0).isActive = true

        let xGridIcon = UIImageView(image: UIImage(named:"icon_round_at")?.withRenderingMode(.alwaysTemplate))
        xGridIcon.tintColor = .white
        textPanel.addSubview(xGridIcon)
        xGridIcon.translatesAutoresizingMaskIntoConstraints = false
//        xGridIcon.centerXAnchor.constraint(equalTo: pMini.centerXAnchor, constant: 0).isActive = true
//        xGridIcon.bottomAnchor.constraint(equalTo: divider.topAnchor, constant: 0).isActive = true
        xGridIcon.centerXAnchor.constraint(equalTo: xGrid.centerXAnchor, constant: 0).isActive = true
        xGridIcon.centerYAnchor.constraint(equalTo: xGrid.centerYAnchor, constant: 0).isActive = true
        xGridIcon.heightAnchor.constraint(equalToConstant: 26).isActive = true //20
        xGridIcon.widthAnchor.constraint(equalToConstant: 26).isActive = true
        xGridIcon.layer.opacity = 0.5

        aTextBox.textAlignment = .left
        aTextBox.textColor = .white
//        aTextBox.backgroundColor = .ddmDarkColor
//        aTextBox.backgroundColor = .green
        aTextBox.backgroundColor = .clear
        aTextBox.font = .systemFont(ofSize: 13)
        textPanel.addSubview(aTextBox)
        aTextBox.translatesAutoresizingMaskIntoConstraints = false
//        aTextBox.bottomAnchor.constraint(equalTo: aaView.bottomAnchor, constant: 0).isActive = true //-10
//        aTextBox.bottomAnchor.constraint(equalTo: xGrid.topAnchor, constant: 0).isActive = true //-10
        aTextBottomCons = aTextBox.bottomAnchor.constraint(equalTo: aaView.bottomAnchor, constant: 0)
        aTextBottomCons?.isActive = true
        aTextBox.leadingAnchor.constraint(equalTo: aaView.leadingAnchor, constant: 10).isActive = true
//        aTextBox.trailingAnchor.constraint(equalTo: xGrid.leadingAnchor, constant: -10).isActive = true
        aTextTrailingCons = aTextBox.trailingAnchor.constraint(equalTo: xGrid.leadingAnchor, constant: -10)
        aTextTrailingCons?.isActive = true
        aTextBox.topAnchor.constraint(equalTo: aaView.topAnchor, constant: 4).isActive = true
        aTextBoxHeightCons = aTextBox.heightAnchor.constraint(equalToConstant: 36)
        aTextBoxHeightCons?.isActive = true
        aTextBox.text = ""
        aTextBox.delegate = self
        aTextBox.tintColor = .yellow
//        aTextBox.layer.opacity = 0.5
//        aTextBox.layer.cornerRadius = 10

//        let bbText = UILabel()
        bbText.textAlignment = .left
        bbText.textColor = .white
        bbText.font = .boldSystemFont(ofSize: 13)
        textPanel.addSubview(bbText)
        bbText.clipsToBounds = true
        bbText.translatesAutoresizingMaskIntoConstraints = false
        bbText.leadingAnchor.constraint(equalTo: aTextBox.leadingAnchor, constant: 10).isActive = true
//        bbText.trailingAnchor.constraint(equalTo: xGrid.leadingAnchor, constant: -10).isActive = true
        bbText.topAnchor.constraint(equalTo: aTextBox.topAnchor, constant: 8).isActive = true
        bbText.text = "Say something nice..."
        bbText.layer.opacity = 0.5
        //**

        //test > black out when close
//        let blackBox = UIView()
        blackBox.backgroundColor = .white
        videoPanel.addSubview(blackBox)
        blackBox.clipsToBounds = true
        blackBox.translatesAutoresizingMaskIntoConstraints = false
        blackBox.leadingAnchor.constraint(equalTo: videoPanel.leadingAnchor, constant: 0).isActive = true
        blackBox.trailingAnchor.constraint(equalTo: videoPanel.trailingAnchor, constant: 0).isActive = true
        blackBox.topAnchor.constraint(equalTo: videoPanel.topAnchor, constant: 0).isActive = true
        blackBox.bottomAnchor.constraint(equalTo: videoPanel.bottomAnchor, constant: 0).isActive = true
        blackBox.isUserInteractionEnabled = false
        blackBox.layer.opacity = 0

        //test > gesture recognizer for dragging user panel
//        let panelPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onVideoPanelPanGesture))
//        self.addGestureRecognizer(panelPanGesture)
        
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
                    
                    currentVideoTopCons = videoPanelTopCons!.constant
                    currentVideoLeadingCons = videoPanelLeadingCons!.constant

                    //test
                    self.delegate?.didStartVideoPanGesture(vpv: self)
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
                print("onPan change circle mask: \(dist), \(currentVideoTopCons), \(currentVideoLeadingCons)")

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
                    videoPanelTopCons?.constant = currentVideoTopCons + y
                    videoPanelLeadingCons?.constant = currentVideoLeadingCons + x
                } else {
                    //test > move back to 0, 0
                    videoPanelTopCons?.constant = 0.0
                    videoPanelLeadingCons?.constant = 0.0
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
                   let x2 = pow(videoPanelLeadingCons!.constant, 2)
                   let y2 = pow(videoPanelTopCons!.constant, 2)
                   let dist = sqrt(x2 + y2)

                   if(dist >= distLimit) {
                       self.delegate?.didStartCloseVideoPanel(vpv: self)
                   } else {
                       let oriX = width/2 - height/2 //default 200
                       let oriY = viewHeight/2 - height/2
                       let circlePath = UIBezierPath(ovalIn: CGRect(x: oriX, y: oriY, width: height, height: height))
                       shapeLayer.path = circlePath.cgPath

                       //test > move back to 0, 0
                       videoPanelTopCons?.constant = 0.0
                       videoPanelLeadingCons?.constant = 0.0


                       //test
                       self.delegate?.didEndVideoPanGesture(vpv: self)
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
//        if(originatorViewType == OriginatorTypes.MAP_VIDEO_MINIAPP_UIVIEW) {
//            vcDataList.append("fy") //for you
//            vcDataList.append("f") //following
//            vcDataList.append("e") //eats
//        } else {
//            vcDataList.append("a")
//        }
    }
    
    func redrawUI() {
        if(isMultipleTab) {
//        if(originatorViewType == OriginatorTypes.MAP_VIDEO_MINIAPP_UIVIEW) {
            
            //test ** > uiscrollview
//            let tabScrollView = UIScrollView()
            videoPanel.addSubview(tabScrollView)
            tabScrollView.backgroundColor = .clear //clear
            tabScrollView.translatesAutoresizingMaskIntoConstraints = false
            tabScrollView.heightAnchor.constraint(equalToConstant: 40).isActive = true //ori 60
            tabScrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
    //        tabScrollView.topAnchor.constraint(equalTo: aFollow.bottomAnchor, constant: 20).isActive = true
            tabScrollView.leadingAnchor.constraint(equalTo: videoPanel.leadingAnchor, constant: tabScrollMargin).isActive = true //70
            tabScrollView.trailingAnchor.constraint(equalTo: videoPanel.trailingAnchor, constant: -tabScrollMargin).isActive = true
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
            videoPanel.addSubview(tabScrollLHSBtn)
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
            videoPanel.addSubview(tabScrollRHSBtn)
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
            videoPanel.addSubview(addFeedBtn)
            addFeedBtn.translatesAutoresizingMaskIntoConstraints = false
            addFeedBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
            addFeedBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
            addFeedBtn.trailingAnchor.constraint(equalTo: videoPanel.trailingAnchor, constant: -10).isActive = true
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
        predeterminedDatasets.append(contentsOf: datasets)
    }
    
    func setUiMode(mode : String){
        uiMode = mode
        
        if(mode == VideoTypes.V_0) {
            bottomBox.isHidden = true
        }
    }
    
    func setOriginatorViewType(type : String){
        originatorViewType = type
        
        //test > redraw UI based on originator(from marker or mini app)
//        defineDataset()
//        redrawUI()
//
//        //test
//        redrawScrollFeedUI()
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
        self.videoPanel.transform = CGAffineTransform.identity
        videoPanelTopCons?.constant = 0
        videoPanelLeadingCons?.constant = 0
        self.videoPanel.layer.cornerRadius = 10

        if(isAnimated) {
            self.delegate?.didStartOpenVideoPanel()

            offsetX = offX
            offsetY = offY

            self.videoPanel.layer.cornerRadius = 200 //default: 10
            self.videoPanel.transform = CGAffineTransform(scaleX: 0.001, y: 0.001).concatenating(CGAffineTransform(translationX: offX, y: offY))
            UIView.animate(withDuration: 0.2, delay: delay, options: [.curveEaseInOut], //default: 0.2
                animations: {
                self.videoPanel.transform = CGAffineTransform.identity
                self.videoPanel.layer.cornerRadius = 10
                
                //test > single video view
                if(!self.predeterminedDatasets.isEmpty) {
                    self.asyncInitPredeterminedDatasets(dataset: self.predeterminedDatasets)
                }
            }, completion: { finished in
                self.delegate?.didFinishOpenVideoPanel()

                self.isPanelOpen = true

                //test > play video
//                self.startPlayVideo()

                //test > async fetch data
//                self.asyncFetchFeed(id: "post_feed")

                print("videoCVpanel open video panel")
                
                //test > fetch data when open
//                let feed = self.feedList[self.currentIndex]
//                if(!feed.isInitialized) {
//                    self.asyncFetchFeed(cell: feed, id: "video_feed")
//                    feed.isInitialized = true
//                }
                
                //test > init panel
//                self.initialize()
                
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
                self.videoPanel.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
//                self.videoPanel.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
                    .concatenating(CGAffineTransform(translationX: self.offsetX, y: self.offsetY))
                self.videoPanel.layer.cornerRadius = 200

                if(self.isTypeBlackOut) {
                    self.blackBox.layer.opacity = 1 //test
                }

            }, completion: { finished in
                //test > stop video before closing panel
                self.stopCurrentVideo()
                //

                self.removeFromSuperview()

                self.delegate?.didFinishCloseVideoPanel(vpv : self)

                self.isPanelOpen = false //test
            })
        } else {
            //test > stop video before closing panel
            self.stopCurrentVideo()
            //

            self.removeFromSuperview()

            delegate?.didFinishCloseVideoPanel(vpv : self)

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
        let viewWidth = viewWidth
        let feedHeight = viewHeight - 94
        for _ in vcDataList {
            
            let stack = ScrollFeedVideoCell()
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

//            stack.initialize()
            stack.aDelegate = self
            
            //*test > add loading spinner before fetch data
            let vData = VideoData()
            vData.setDataType(data: "b")
            vData.setData(data: "b")
            vData.setTextString(data: "b")
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
                            
                            self.asyncFetchFeed(cell: feed, id: "video_feed")
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
    
    func asyncInitPredeterminedDatasets(dataset: [String]) {
        if(!self.feedList.isEmpty) {
            let feed = feedList[currentIndex]
            
            feed.vcDataList.removeAll() //remove spinner "b"

            var tempDataList = [VideoData]()
            for i in dataset {
                let vData = VideoData()
                vData.setDataType(data: i)
                vData.setData(data: i)
                vData.setTextString(data: i)
                
                if(uiMode == VideoTypes.V_0) {
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
            let vData = VideoData()
            vData.setDataType(data: "b")
            vData.setData(data: "b")
            vData.setTextString(data: "b")
            feed.vcDataList.append(vData)
            //
            
            feed.videoCV?.reloadData()
            feed.currentIndexPath = IndexPath(item: 0, section: 0) //to play video when willDisplay()

//            feed.bufferDataList.removeAll()
            feed.dataPaginateStatus = ""
            feed.pageNumber = 0

            asyncFetchFeed(cell: feed, id: "video_feed")
        }
    }

    //**test > remove elements from dataset n uicollectionview
    func removeData(cell: ScrollFeedVideoCell?, idxToRemove: Int) {
        guard let feed = cell else {
            return
        }
        if(!feed.vcDataList.isEmpty) {
            if(idxToRemove > -1 && idxToRemove < feed.vcDataList.count) {
                var indexPaths = [IndexPath]()
                let idx = IndexPath(item: idxToRemove, section: 0)
                indexPaths.append(idx)
                
                //*test > recalibrate currentindexpath
//                var newIdx = 0
//                if(idxToRemove > 0) {
//                    newIdx = idxToRemove - 1
//                }
                //*
                
                feed.vcDataList.remove(at: idxToRemove)
                
                //test > footer to show msg when no more data
                if(feed.vcDataList.isEmpty) {
                    let vData = VideoData()
                    vData.setDataType(data: "d")
                    vData.setData(data: "d")
                    vData.setTextString(data: "d")
                    feed.vcDataList.append(vData)
                    
                    feed.videoCV?.reloadData()
                    
                    //test > recalibrate currentindexpath
//                    feed.currentIndexPath = IndexPath(item: 0, section: 0) //to play video when willDisplay()
                } else {
                    feed.videoCV?.deleteItems(at: indexPaths)
                    
                    //test > recalibrate currentindexpath
//                    feed.currentIndexPath = IndexPath(item: newIdx, section: 0)
                }
                
                feed.unselectItemData()
            }
        }
    }
//    func removeDataSet(cell: ScrollFeedVideoCell?, idxToRemove: [Int]) {
//        guard let feed = cell else {
//            return
//        }
//        var indexPaths = [IndexPath]()
//        for i in idxToRemove {
//            feed.vcDataList.remove(at: i)
//            
//            let idx = IndexPath(item: i, section: 0)
//            indexPaths.append(idx)
//        }
//        feed.videoCV?.deleteItems(at: indexPaths)
//    }
    //**
    
    func asyncFetchFeed(cell: ScrollFeedVideoCell?, id: String) {

        cell?.dataFetchState = "start"

        let id_ = "video"
        let isPaginate = false
        DataFetchManager.shared.fetchVideoData(id: id_, isPaginate: isPaginate) { [weak self]result in
//        DataFetchManager.shared.fetchData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("api success asyncFetchFeed \(id), \(l.count)")

                    //test 2 > insert array to idx[0], not just append
                    guard let feed = cell else {
                        return
                    }

                    //test 2 > new append method
                    var tempDataList = [VideoData]()
                    if(!l.isEmpty) {
                        // push loading spinner to bottom if still need to load more data
                        // otherwise, remove loading spinner
//                        feed.vcDataList.remove(at: 0) //remove loading spinner
                        
                        for i in l {
                            let vData = VideoData()
                            vData.setDataType(data: i)
                            vData.setData(data: i)
                            vData.setTextString(data: i)
                            tempDataList.append(vData)
                        }
                    } else {
                        feed.vcDataList.remove(at: 0) //remove loading spinner
                        
                        let vData = VideoData()
                        vData.setDataType(data: "d")
                        vData.setData(data: "d")
                        vData.setTextString(data: "d")
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
                    
                    var tempDataList = [VideoData]()
                    feed.vcDataList.remove(at: 0) //remove loading spinner
                    
                    let vData = VideoData()
                    vData.setDataType(data: "e")
                    vData.setData(data: "e")
                    vData.setTextString(data: "e")
                    tempDataList.append(vData)
                    
                    feed.vcDataList.insert(contentsOf: tempDataList, at: 0)

                    feed.videoCV?.reloadData()
                    
                    feed.dataFetchState = "end"
                }
                break
            }
        }
    }

    func asyncPaginateFetchFeed(cell: ScrollFeedVideoCell?, id: String) {

        cell?.pageNumber += 1
        cell?.dataPaginateStatus = "start"

        let id_ = "video"
        let isPaginate = true
//        let isPaginate = false
        DataFetchManager.shared.fetchVideoData(id: id_, isPaginate: isPaginate) { [weak self]result in
//        DataFetchManager.shared.fetchData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {

                    guard let feed = cell else {
                        return
                    }

                    let w = feed.vcDataList.count - 1
                    let x = feed.currentIndexPath.row
                    let y = feed.vcDataList[w].dataType
                    let z = feed.vcDataList[x].dataType

                    print("api success asyncPaginateFetchFeed: \(w), \(x), \(y), \(z)")

                    //test > if current index at loading spinner
                    if(y == "b") {
                        if(l.isEmpty) {
                            //no more data => END
                            feed.dataPaginateStatus = "end"

                            let vData = VideoData()
                            vData.setDataType(data: "c")
                            vData.setData(data: "c")
                            vData.setTextString(data: "c")
                            feed.vcDataList[feed.vcDataList.count - 1] = vData
                            
                            //test 2 > new reload method
//                            feed.videoCV?.reloadData()
                            var indexPaths = [IndexPath]()
                            let idx = IndexPath(item: w, section: 0)
                            indexPaths.append(idx)
                            
                            feed.videoCV?.reloadItems(at: indexPaths)
                        } else {
                            feed.dataPaginateStatus = ""
                            
                            //test 2 > new append method
                            var indexPaths = [IndexPath]()
                            var j = 0
                            
                            var tempDataList = [VideoData]()
                            for i in l {
                                let vData = VideoData()
                                vData.setDataType(data: i)
                                vData.setData(data: i)
                                vData.setTextString(data: i)
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
                    
//                    var tempDataList = [VideoData]()
                    
                    let vData = VideoData()
                    vData.setDataType(data: "e")
                    vData.setData(data: "e")
                    vData.setTextString(data: "e")
                    feed.vcDataList[feed.vcDataList.count - 1] = vData

//                    feed.videoCV?.reloadData()
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


    //test > adjust textview bottom margin when keyboard up
    override func keyboardUp(margin: CGFloat) {
        guard let firstResponder = self.currentFirstResponder else {
            return
        }
        if(firstResponder == aTextBox) {
            print("currentfirstresponder true : \(firstResponder)")

            textPanel.isHidden = false
            aView.isHidden = false

            if(!isKeyboardUp) {
                UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut],
                    animations: {
                    self.textPanel.transform = CGAffineTransform(translationX: 0, y: -margin)
                }, completion: { finished in
                })
            } else {
                self.textPanel.transform = CGAffineTransform(translationX: 0, y: -margin)
            }

            isKeyboardUp = true
        }
    }

    @objc func onCloseTextBoxClicked(gesture: UITapGestureRecognizer) {
        resignResponder()

        self.textPanel.transform = CGAffineTransform(translationX: 0, y: 0)
    }

    @objc func onOpenTextBoxClicked(gesture: UITapGestureRecognizer) {
        setFirstResponder(textView: aTextBox)
    }

    func setFirstResponder(textView: UITextView) {
        currentFirstResponder = textView
        textView.becomeFirstResponder()
    }

    func resignResponder() {
        self.endEditing(true)
        currentFirstResponder = nil

        isKeyboardUp = false
        textPanel.isHidden = true
        aView.isHidden = true
    }

    //test > view pan gesture to prevent video panel move by panning textview
    @objc func onTextViewPanGesture(gesture: UIPanGestureRecognizer) {
        print("onPan start A: ")
    }

    //test > start play video
    func startPlayVideo() {
        if(!self.feedList.isEmpty) {
            let b = feedList[currentIndex]
            b.startPlayVideo()
        }
    }
    //test > resume current video
    func resumeCurrentVideo() {
        if(!self.feedList.isEmpty) {
            let b = feedList[currentIndex]
            b.resumeCurrentVideo()
        }
    }
    //test > stop current video for closing
    func stopCurrentVideo() {
        if(!self.feedList.isEmpty) {
            let b = feedList[currentIndex]
            b.stopCurrentVideo()
        }
    }
    //test > pause current video for closing
    func pauseCurrentVideo() {
        if(!self.feedList.isEmpty) {
            let b = feedList[currentIndex]
            b.pauseCurrentVideo()
        }
    }

    //test
    override func resumeActiveState() {
//        resumeCurrentVideo()
        
        //test > only resume video if no comment scrollable view/any other view
        if(pageList.isEmpty) {
            resumeCurrentVideo()
        }
        else {
            //dehide cell for commment view
            if let c = pageList[pageList.count - 1] as? CommentScrollableView {
                c.dehideCell()
            }
        }
    }

    //test > add comment panel
    func openComment() {
        let commentPanel = CommentScrollableView(frame: CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.height))
        videoPanel.insertSubview(commentPanel, belowSubview: bottomBox)
        commentPanel.translatesAutoresizingMaskIntoConstraints = false
        commentPanel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        commentPanel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        commentPanel.delegate = self
        commentPanel.initialize()
        
        //test > track comment scrollable view
        pageList.append(commentPanel)
    }

    func openShareSheet() {
        let sharePanel = ShareSheetScrollableView(frame: CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.height))
        videoPanel.addSubview(sharePanel)
        sharePanel.translatesAutoresizingMaskIntoConstraints = false
        sharePanel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        sharePanel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        sharePanel.delegate = self
        
        //test > track comment scrollable view
        pageList.append(sharePanel)
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

//test > link delegate implementation in VideoPanelView with VC
extension ViewController: VideoPanelDelegate{
    func didClickUser() {
        deactivateQueueState()
        openUserPanel()
    }

    func didClickPlace() {
        deactivateQueueState()
        openPlacePanel()
    }

    func didClickSound() {
        deactivateQueueState()
        openSoundPanel()
    }
    
    func didClickPost(){
        openPostDetailPanel()
    }

    func didStartOpenVideoPanel() {
        //activate queue object video state when video opens
        activateQueueState()
    }
    func didFinishOpenVideoPanel() {
        //test > stop any pulsewave if video opens
        stopPulseWave()
    }
    func didStartCloseVideoPanel(vpv : VideoPanelView) {

        //test > dequeue object deactivate video active state
        deactivateQueueState()

        if(vpv.originatorViewType == OriginatorTypes.MARKER) {
            guard let mapView = self.mapView else {
                return
            }
            guard let coord = vpv.coordinateLocation else {
                return
            }
            let point = mapView.projection.point(for: coord)
            vpv.offsetX = point.x - self.view.frame.width/2
            vpv.offsetY = point.y - self.view.frame.height/2
            vpv.offsetX = vpv.offsetX - vpv.videoPanelLeadingCons!.constant
            vpv.offsetY = vpv.offsetY - vpv.videoPanelTopCons!.constant + vpv.adjustmentY

            vpv.close(isAnimated: true)

        } else if(vpv.originatorViewType == OriginatorTypes.PULSEWAVE){
            guard let mapView = self.mapView else {
                return
            }
            guard let coord = vpv.coordinateLocation else {
                return
            }
            let point = mapView.projection.point(for: coord)
            vpv.offsetX = point.x - self.view.frame.width/2
            vpv.offsetY = point.y - self.view.frame.height/2
            vpv.offsetX = vpv.offsetX - vpv.videoPanelLeadingCons!.constant
            vpv.offsetY = vpv.offsetY - vpv.videoPanelTopCons!.constant

            vpv.close(isAnimated: true)
        } else {
            vpv.offsetX = vpv.offsetX - vpv.videoPanelLeadingCons!.constant
            vpv.offsetY = vpv.offsetY - vpv.videoPanelTopCons!.constant

            vpv.close(isAnimated: true)
        }
    }

    func didFinishCloseVideoPanel(vpv : VideoPanelView) {

        //test
        backPage(isCurrentPageScrollable: false)

        //test > get marker id for marker closing animation
        if(vpv.originatorViewType == OriginatorTypes.MARKER) {
            print("didFinishCloseVideoPanel \(vpv.getOriginatorId())")
            if var a = self.markerGeoMarkerIdList[vpv.getOriginatorId()] {
                a.animateFromVideoClose()
            }
        } else if(vpv.originatorViewType == OriginatorTypes.MAP_TOP_UIVIEW){
            shutterSemiTransparentGifImage()
        } else if(vpv.originatorViewType == OriginatorTypes.MAP_VIDEO_MINIAPP_UIVIEW){
//            shutterBMiniGifImage()
            if(selectedMiniAppIndex > -1) {
                miniAppViewList[selectedMiniAppIndex].shutterMiniGifImage()
            }
        }
        //test > make viewcell reappear after video panel closes
        else if(vpv.originatorViewType == OriginatorTypes.UIVIEW){
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

    func didStartVideoPanGesture(vpv : VideoPanelView) {
        //test > hide marker ready for shutter after video closes
        if(vpv.originatorViewType == OriginatorTypes.MARKER) {
            if var a = self.markerGeoMarkerIdList[vpv.getOriginatorId()] {
                a.hideForShutter()
            }
        } else if(vpv.originatorViewType == OriginatorTypes.MAP_TOP_UIVIEW){
            hideSemiTransparentGifImage()
        } else if(vpv.originatorViewType == OriginatorTypes.MAP_VIDEO_MINIAPP_UIVIEW){
//            hideBMiniGifImage()
            if(selectedMiniAppIndex > -1) {
                miniAppViewList[selectedMiniAppIndex].hideMiniGifImage()
            }
        }
    }
    func didEndVideoPanGesture(vpv : VideoPanelView) {
        //test > de-hide marker ready for shutter if video NOT close, resume play
        if(vpv.originatorViewType == OriginatorTypes.MARKER) {
            if var a = self.markerGeoMarkerIdList[vpv.getOriginatorId()] {
                a.dehideForShutter()
            }
        } else if(vpv.originatorViewType == OriginatorTypes.MAP_TOP_UIVIEW){
            dehideSemiTransparentGifImage()
        } else if(vpv.originatorViewType == OriginatorTypes.MAP_VIDEO_MINIAPP_UIVIEW){
//            dehideBMiniGifImage()
            if(selectedMiniAppIndex > -1) {
                miniAppViewList[selectedMiniAppIndex].dehideMiniGifImage()
            }
        }
    }
    
    func didClickVideoPanelClickPhoto(pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String) {
        let offsetX = pointX - self.view.frame.width/2 + view.frame.width/2
        let offsetY = pointY - self.view.frame.height/2 + view.frame.height/2
        
        if(mode == PhotoTypes.P_SHOT_DETAIL) {
            openPhotoDetailPanel()
        } else if(mode == PhotoTypes.P_0){
            openPhotoZoomPanel(offX: offsetX, offY: offsetY)
        }
    }
    func didClickVideoPanelClickVideo(pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String) {
        
    }
}

//test > textview delegate for comment
extension VideoPanelView: UITextViewDelegate {
//    func textView(_ textView: UITextView, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let maxLength = 20
//        let currentString: NSString = (textView.text ?? "") as NSString
//        let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
//
//        return newString.length <= maxLength
//    }

    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: self.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)

        print("textviewdelegate: \(estimatedSize), \(textView.contentSize.height)")

        //test 1
//        if(textView.contentSize.height < 100) {
//            textPanelHeightCons?.constant = textView.contentSize.height + 50
//        } else {
//            textPanelHeightCons?.constant = 100 + 50
//        }

        //tets 2 > check length of textview text
        let currentString: NSString = (textView.text ?? "") as NSString
        print("textviewchange: \(currentString.length)")
        if(currentString.length > 0) {
            aaViewTrailingCons?.isActive = false
            aaViewTrailingCons = aaView.trailingAnchor.constraint(equalTo: sendBox.leadingAnchor, constant: -10)
            aaViewTrailingCons?.isActive = true

            aTextTrailingCons?.isActive = false
            aTextTrailingCons = aTextBox.trailingAnchor.constraint(equalTo: aaView.trailingAnchor, constant: -10)
            aTextTrailingCons?.isActive = true

            aTextBottomCons?.isActive = false
            aTextBottomCons = aTextBox.bottomAnchor.constraint(equalTo: xGrid.topAnchor, constant: 0)
            aTextBottomCons?.isActive = true

            aTextBoxHeightCons?.constant = 70

            bbText.isHidden = true
        } else {
            aaViewTrailingCons?.isActive = false
            aaViewTrailingCons = aaView.trailingAnchor.constraint(equalTo: textPanel.trailingAnchor, constant: -15)
            aaViewTrailingCons?.isActive = true

            aTextTrailingCons?.isActive = false
            aTextTrailingCons = aTextBox.trailingAnchor.constraint(equalTo: xGrid.trailingAnchor, constant: -10)
            aTextTrailingCons?.isActive = true

            aTextBottomCons?.isActive = false
            aTextBottomCons = aTextBox.bottomAnchor.constraint(equalTo: aaView.bottomAnchor, constant: 0)
            aTextBottomCons?.isActive = true

            aTextBoxHeightCons?.constant = 36

            bbText.isHidden = false
        }

    }
}

extension VideoPanelView: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        let x = scrollView.contentOffset.x
//        let totalXLength = (viewWidth) * CGFloat(vcDataList.count)
//        let hOffsetX = x/totalXLength*(stackviewUsableLength)
////        let hOffsetX = x/totalXLength*(500)
//        tabSelectLeadingCons?.constant = hOffsetX
        
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
                let currentX = videoPanel.frame.width * CGFloat(currentItemIndex)
                let currentTabWidth = tabList[currentItemIndex].frame.width
                var hOffsetX = 0.0
                if(xOffset >= currentX) {
                    var nextTabWidth = tabList[currentItemIndex].frame.width
                    if(currentItemIndex < tabList.count - 1) {
                        nextTabWidth = tabList[currentItemIndex + 1].frame.width
                    }
                    hOffsetX = (xOffset - currentX)/(videoPanel.frame.width) * currentTabWidth + currentTabSelectLeadingCons
                    tabSelectLeadingCons?.constant = hOffsetX

                    let hWidth = (xOffset - currentX)/(videoPanel.frame.width) * (nextTabWidth - currentTabWidth) + currentTabWidth
                    tabSelectWidthCons?.constant = hWidth
                }
                else if (xOffset < currentX) {
                    var prevTabWidth = tabList[currentItemIndex].frame.width
                    if(currentItemIndex > 0) {
                        prevTabWidth = tabList[currentItemIndex - 1].frame.width
                    }

                    hOffsetX = (xOffset - currentX)/(videoPanel.frame.width) * prevTabWidth + currentTabSelectLeadingCons
                    tabSelectLeadingCons?.constant = hOffsetX

                    let hWidth = (xOffset - currentX)/(videoPanel.frame.width) * (currentTabWidth - prevTabWidth) + currentTabWidth
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
                    asyncFetchFeed(cell: feed, id: "video_feed")
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
                    currentFeed.startPlayVideo()
                    previousFeed.stopCurrentVideo()
                }
            }
            
            //test > change tab title font opacity when scrolled
            reactToTabSectionChange(index: currentIndex)
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
                    currentFeed.startPlayVideo()
                    previousFeed.stopCurrentVideo()
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

extension VideoPanelView: ScrollFeedVideoCellDelegate {
    func sfvcWillBeginDragging(offsetY: CGFloat) {

    }
    func sfvcScrollViewDidScroll(offsetY: CGFloat){

    }
    func sfvcSrollViewDidEndDecelerating(offsetY: CGFloat){

    }
    func sfvcScrollViewDidEndDragging(offsetY: CGFloat, decelerate: Bool){
//        if(offsetY < -100) {
//            self.refreshFetchData()
//        }
        
        //test > open single video
        if(offsetY < -100) {
            if(self.predeterminedDatasets.isEmpty) {
                self.refreshFetchData()
            }
        }
    }

    func sfvcAsyncFetchFeed(){

    }
    func sfvcAsyncPaginateFeed(cell: ScrollFeedVideoCell?){
//        asyncPaginateFetchFeed(cell: cell, id: "video_feed_end")
        
        //test > open single video
        if(self.predeterminedDatasets.isEmpty) {
            asyncPaginateFetchFeed(cell: cell, id: "video_feed_end")
        }
    }
    
    func sfvcAutoplayVideo(cell: ScrollFeedVideoCell?, vCCell: VCViewCell?) {
        if(!self.feedList.isEmpty) {
            let aVc = feedList[currentIndex]
            print("fvcAutoplayVideo \(aVc == cell), \(cell)")
            if(aVc == cell) {
                vCCell?.playVideo()
            }
        }
    }
    
    func sfvcDidClickUser() {
        delegate?.didClickUser()
        
        //test > try pause video when transition to user panel
        pauseCurrentVideo()
    }
    func sfvcDidClickPlace(){
        delegate?.didClickPlace()
        
        //test > try pause video when transition to user panel
        pauseCurrentVideo()
    }
    func sfvcDidClickSound(){
        delegate?.didClickSound()
        
        //test > try pause video when transition to user panel
        pauseCurrentVideo()
    }
    func sfvcDidClickComment(){
        openComment()
        
        //test > try pause video when transition to user panel
        pauseCurrentVideo()
    }
    func sfvcDidClickShare(){
        openShareSheet()
        
        //test > try pause video when transition to user panel
        pauseCurrentVideo()
    }
    func sfvcDidClickRefresh(){
        //test
        if(self.predeterminedDatasets.isEmpty) {
            self.refreshFetchData()
        }
    }
}

extension VideoPanelView: ShareSheetScrollableDelegate{
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
                    a.unselectItemData()
                }
                else if let b = lastPage as? ShareSheetScrollableView {
                    print("lastpagelist d")
                }
            } else {
                resumeCurrentVideo()
                
                if(!self.feedList.isEmpty) {
                    let feed = feedList[currentIndex]
                    feed.unselectItemData()
                }
            }
        } else {
//            resumeCurrentVideo()
        }
    }
}

extension VideoPanelView: CommentScrollableDelegate{
    func didCClickUser(){
        delegate?.didClickUser()
    }
    func didCClickPlace(){
        delegate?.didClickPlace()
    }
    func didCClickSound(){
        delegate?.didClickSound()
    }
    func didCClickClosePanel(){
        
    }
    func didCFinishClosePanel() {
//        resumeCurrentVideo()
        
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
                resumeCurrentVideo()
            }
        } else {
//            resumeCurrentVideo()
        }
    }
    func didCClickComment(){
 
    }
    func didCClickShare(){
        //test
        openShareSheet()
    }
    func didCClickPost(){
        delegate?.didClickPost()
    }
    func didCClickClickPhoto(pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
        delegate?.didClickVideoPanelClickPhoto(pointX: pointX, pointY: pointY, view: view, mode: mode)
    }
    func didCClickClickVideo(pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
        
    }
}

extension VideoPanelView: TabStackDelegate {
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
