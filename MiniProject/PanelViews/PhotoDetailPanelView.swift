//
//  PhotoDetailPanelView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

protocol PhotoDetailPanelDelegate : AnyObject {
    func didClickPhotoDetailPanelVcvClickPost() //try
    func didClickPhotoDetailPanelVcvClickUser() //try
    func didClickPhotoDetailClosePanel()
    func didClickPhotoDetailPanelVcvClickPhoto(pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String)
}

class PhotoDetailPanelView: PanelView, UIGestureRecognizerDelegate{
//class PhotoDetailPanelView: PanelView {
    var panelLeadingCons: NSLayoutConstraint?
    var currentPanelLeadingCons : CGFloat = 0.0
    var panel = UIView()
    
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    let aStickyHeader = UIView()
    let aMoreCBtn = UIView()
    var photoCV : UICollectionView?
//    var vcDataList = [PhotoData]()
    var vcDataList = [BaseData]()
    
    var isScrollViewAtTop = true
    var scrollViewInitialY : CGFloat = 0.0
    let aSpinner = SpinLoader()
    let bSpinner = SpinLoader()
    let footerView = UIView()
    let aaText = UILabel()
    var dataFetchState = ""
    var dataPaginateStatus = "" //test
    var pageNumber = 0
    let errorText = UILabel()
    let errorRefreshBtn = UIView()
    
    weak var delegate : PhotoDetailPanelDelegate?
    
    var postHeight = 0.0
    var stickyH1TopCons: NSLayoutConstraint?
    var stickyH2TopCons: NSLayoutConstraint?
    
    //test
    var hideCellIndex = -1
    //test > record which cell video is playing
//    var currentPlayingVidIndex = -1
    //test > for video autoplay when user opens
    var isFeedDisplayed = false
    
    //test > track comment scrollable view
    var pageList = [PanelView]()
    
    //test > comment textview
    var aView = UIView()
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
    let sendBox = UIView()
    let aaView = UIView()
    let xGrid = UIView()
    let bbText = UILabel()
    let addCommentContainer = UIView()
    let sendCommentContainer = UIView()
    let sendASpinner = SpinLoader()
    let sendBText = UILabel()
    let sendBBox = UIView()
    
    //test > scroll view for carousel
    var isCarouselScrolled = false
    
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
        //test 1 > list view of videos
        panel.backgroundColor = .ddmBlackOverlayColor
//        soundPanel.backgroundColor = .blue
        self.addSubview(panel)
        panel.translatesAutoresizingMaskIntoConstraints = false
//        soundPanel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        panel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        panel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //default 0
//        soundPanel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        panel.layer.masksToBounds = true
        panel.layer.cornerRadius = 10 //10
        //test
        panel.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        panelLeadingCons = panel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
        panelLeadingCons?.isActive = true
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: self.frame.size.width, height: self.frame.size.height)
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10 //20
//        let videoCV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        photoCV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        guard let photoCV = photoCV else {
            return
        }
        photoCV.register(HCommentListViewCell.self, forCellWithReuseIdentifier: HCommentListViewCell.identifier)
//        photoCV.register(HPhotoListViewCell.self, forCellWithReuseIdentifier: HPhotoListViewCell.identifier)
        photoCV.register(HPhotoListBViewCell.self, forCellWithReuseIdentifier: HPhotoListBViewCell.identifier)
//        photoCV.isPagingEnabled = true
        photoCV.dataSource = self
        photoCV.delegate = self
        photoCV.showsVerticalScrollIndicator = false //false
//        photoCV.backgroundColor = .blue
        photoCV.backgroundColor = .clear
        panel.addSubview(photoCV)
        photoCV.translatesAutoresizingMaskIntoConstraints = false
        photoCV.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        photoCV.leadingAnchor.constraint(equalTo: panel.leadingAnchor).isActive = true
//        photoCV.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: 0).isActive = true
        photoCV.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        photoCV.trailingAnchor.constraint(equalTo: panel.trailingAnchor).isActive = true
        photoCV.contentInsetAdjustmentBehavior = .never
        //test
        photoCV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        //test > top spinner
        photoCV.addSubview(aSpinner)
        aSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        aSpinner.translatesAutoresizingMaskIntoConstraints = false
//        aSpinner.topAnchor.constraint(equalTo: postCV.topAnchor, constant: CGFloat(-35)).isActive = true
        aSpinner.topAnchor.constraint(equalTo: photoCV.topAnchor, constant: CGFloat(35)).isActive = true
        aSpinner.centerXAnchor.constraint(equalTo: photoCV.centerXAnchor).isActive = true
        aSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        aSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        //test > add footer ***
        photoCV.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer")
        //***
        
        //test > sticky header
        aStickyHeader.backgroundColor = .ddmBlackOverlayColor
        panel.addSubview(aStickyHeader)
        aStickyHeader.translatesAutoresizingMaskIntoConstraints = false
        aStickyHeader.trailingAnchor.constraint(equalTo: panel.trailingAnchor).isActive = true
        aStickyHeader.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        aStickyHeader.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        aStickyHeader.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 0).isActive = true
//        aStickyHeader.layer.opacity = 0.3
        aStickyHeader.isUserInteractionEnabled = true
        aStickyHeader.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onStickyHeaderClicked)))
        aStickyHeader.clipsToBounds = true
        
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
        
        //test > more action btn
//        let aMoreCBtn = UIView()
//        aMoreCBtn.backgroundColor = .ddmBlackDark
        aStickyHeader.addSubview(aMoreCBtn)
        aMoreCBtn.translatesAutoresizingMaskIntoConstraints = false
        aMoreCBtn.trailingAnchor.constraint(equalTo: aStickyHeader.trailingAnchor, constant: -10).isActive = true
        aMoreCBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true //30
        aMoreCBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true //30
        aMoreCBtn.centerYAnchor.constraint(equalTo: aBtn.centerYAnchor, constant: 0).isActive = true
        aMoreCBtn.layer.cornerRadius = 10
        //test > for sharing
        aMoreCBtn.isUserInteractionEnabled = true
        aMoreCBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onAClicked)))
        aMoreCBtn.isHidden = true
        
        let eMiniCBtn = UIImageView(image: UIImage(named:"icon_round_share")?.withRenderingMode(.alwaysTemplate).withHorizontallyFlippedOrientation())
        eMiniCBtn.tintColor = .white
//        eMiniBtn.tintColor = .ddmDarkGrayColor
        aMoreCBtn.addSubview(eMiniCBtn)
        eMiniCBtn.translatesAutoresizingMaskIntoConstraints = false
        eMiniCBtn.centerXAnchor.constraint(equalTo: aMoreCBtn.centerXAnchor).isActive = true
        eMiniCBtn.centerYAnchor.constraint(equalTo: aMoreCBtn.centerYAnchor, constant: -2).isActive = true //-2
        eMiniCBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true //22
        eMiniCBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
        
        let stickyHLight = UIView()
//        stickyHLight.backgroundColor = .ddmDarkColor
        aStickyHeader.addSubview(stickyHLight)
        stickyHLight.translatesAutoresizingMaskIntoConstraints = false
        stickyHLight.centerXAnchor.constraint(equalTo: aStickyHeader.centerXAnchor, constant: 0).isActive = true
        stickyHLight.heightAnchor.constraint(equalToConstant: 40).isActive = true //30
        stickyH1TopCons = stickyHLight.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0)
        stickyH1TopCons?.isActive = true
        
        let aTabText = UILabel()
        aTabText.textAlignment = .center
        aTabText.textColor = .white
        aTabText.font = .boldSystemFont(ofSize: 15) //default 14
        aTabText.text = "Shot"
        stickyHLight.addSubview(aTabText)
        aTabText.translatesAutoresizingMaskIntoConstraints = false
        aTabText.leadingAnchor.constraint(equalTo: stickyHLight.leadingAnchor, constant: 0).isActive = true
        aTabText.trailingAnchor.constraint(equalTo: stickyHLight.trailingAnchor, constant: 0).isActive = true
        aTabText.centerYAnchor.constraint(equalTo: stickyHLight.centerYAnchor).isActive = true
        
        let stickyHLight2 = UIView()
//        stickyHLight.backgroundColor = .ddmDarkColor
        aStickyHeader.addSubview(stickyHLight2)
        stickyHLight2.translatesAutoresizingMaskIntoConstraints = false
        stickyHLight2.centerXAnchor.constraint(equalTo: aStickyHeader.centerXAnchor, constant: 0).isActive = true
        stickyHLight2.heightAnchor.constraint(equalToConstant: 40).isActive = true //30
        stickyH2TopCons = stickyHLight2.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 50)
        stickyH2TopCons?.isActive = true
        
        let aTabText2 = UILabel()
        aTabText2.textAlignment = .center
        aTabText2.textColor = .white
        aTabText2.font = .boldSystemFont(ofSize: 13) //default 14
        aTabText2.text = "358 Comments"
        stickyHLight2.addSubview(aTabText2)
        aTabText2.translatesAutoresizingMaskIntoConstraints = false
        aTabText2.leadingAnchor.constraint(equalTo: stickyHLight2.leadingAnchor, constant: 0).isActive = true
        aTabText2.centerYAnchor.constraint(equalTo: stickyHLight2.centerYAnchor).isActive = true
        
        let aTabText2Btn = UIImageView(image: UIImage(named:"icon_round_arrow_down")?.withRenderingMode(.alwaysTemplate))
//            aArrowBtn.image = UIImage(named:"icon_round_arrow_down")?.withRenderingMode(.alwaysTemplate)
        aTabText2Btn.tintColor = .white
        stickyHLight2.addSubview(aTabText2Btn)
        aTabText2Btn.translatesAutoresizingMaskIntoConstraints = false
        aTabText2Btn.leadingAnchor.constraint(equalTo: aTabText2.trailingAnchor).isActive = true
        aTabText2Btn.trailingAnchor.constraint(equalTo: stickyHLight2.trailingAnchor, constant: 0).isActive = true
        aTabText2Btn.centerYAnchor.constraint(equalTo: aTabText2.centerYAnchor).isActive = true
        aTabText2Btn.heightAnchor.constraint(equalToConstant: 26).isActive = true //ori 26
        aTabText2Btn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        
        //**test bottom comment box => fake edittext
        setupCommentTextboxUI()
        //**
        
        //test > gesture recognizer for dragging user panel
        let panelPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onPanelPanGesture))
//        self.addGestureRecognizer(panelPanGesture)
        
        //test
        panelPanGesture.delegate = self //for simultaneous pan recognizer for uicollectionview
        self.addGestureRecognizer(panelPanGesture)
//        photoCV.addGestureRecognizer(panelPanGesture)
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
    @objc func onAClicked(gesture: UITapGestureRecognizer) {
        pausePlayingMedia()
        
        if let a = photoCV {
            openShareSheet()
            selectedItemIdx = 0
        }
    }
    @objc func onStickyHeaderClicked(gesture: UITapGestureRecognizer) {
        print("sticky header clicked")
        
        //test
        photoCV?.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
    }
    
    var direction = "na"
    @objc func onPanelPanGesture(gesture: UIPanGestureRecognizer) {
        if(gesture.state == .began) {
            
            print("t1 onPanelPanGesture begin: ")
            self.currentPanelLeadingCons = self.panelLeadingCons!.constant
        } else if(gesture.state == .changed) {
            let translation = gesture.translation(in: self)
            let x = translation.x
            let y = translation.y
            
            //test > determine direction of scroll
//            print("t1 onSoundPanelPanGesture changed: \(x), \(self.soundPanelLeadingCons!.constant)")
            if(direction == "na") {
                if(abs(x) > abs(y)) {
                    direction = "x"
                } else {
                    direction = "y"
                }
            }
            if(direction == "x") {
//                var newX = self.currentPanelLeadingCons + x
//                if(newX < 0) {
//                    newX = 0
//                }
//                self.panelLeadingCons?.constant = newX
                
                //test > avoid accidental close panel
                if(!isCarouselScrolled) {
                    var newX = self.currentPanelLeadingCons + x
                    if(newX < 0) {
                        newX = 0
                    }
                    self.panelLeadingCons?.constant = newX
                }
            }
        } else if(gesture.state == .ended){
            
            print("t1 onPanelPanGesture ended: ")
            if(self.panelLeadingCons!.constant - self.currentPanelLeadingCons < 75) {
                UIView.animate(withDuration: 0.2, animations: {
                    self.panelLeadingCons?.constant = 0
                    self.layoutIfNeeded()
                }, completion: { _ in
                })
            } else {
                closePanel(isAnimated: true)
            }
            
            //test > determine direction of scroll
            direction = "na"
        }
    }
    
    //test > setup comment textbox
    func setupCommentTextboxUI() {
//        bottomBox.backgroundColor = .black
        bottomBox.backgroundColor = .ddmBlackOverlayColor
        panel.addSubview(bottomBox)
        bottomBox.clipsToBounds = true
        bottomBox.translatesAutoresizingMaskIntoConstraints = false
        bottomBox.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 0).isActive = true
        bottomBox.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: 0).isActive = true
//        bottomBox.heightAnchor.constraint(equalToConstant: 94).isActive = true //default: 50
//        bottomBox.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: 0).isActive = true
        bottomBox.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        bottomBox.heightAnchor.constraint(equalToConstant: 60).isActive = true //default: 50
        bottomBox.isUserInteractionEnabled = true
        let aPanelPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onTextViewPanGesture))
        bottomBox.addGestureRecognizer(aPanelPanGesture)
//        bottomBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onOpenTextBoxClicked)))

//        let addCommentContainer = UIView()
        bottomBox.addSubview(addCommentContainer)
        addCommentContainer.translatesAutoresizingMaskIntoConstraints = false
        addCommentContainer.leadingAnchor.constraint(equalTo: bottomBox.leadingAnchor, constant: 0).isActive = true
        addCommentContainer.trailingAnchor.constraint(equalTo: bottomBox.trailingAnchor, constant: 0).isActive = true
        addCommentContainer.topAnchor.constraint(equalTo: bottomBox.topAnchor, constant: 0).isActive = true //default: 50
        addCommentContainer.bottomAnchor.constraint(equalTo: bottomBox.bottomAnchor, constant: 0).isActive = true
        addCommentContainer.isHidden = false
        addCommentContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onOpenTextBoxClicked)))
        
        let bText = UILabel()
        bText.textAlignment = .left
//        bText.textColor = .white
        bText.textColor = .ddmDarkGrayColor
        bText.font = .boldSystemFont(ofSize: 13)
        addCommentContainer.addSubview(bText)
//        bottomBox.addSubview(bText)
        bText.clipsToBounds = true
        bText.translatesAutoresizingMaskIntoConstraints = false
        bText.leadingAnchor.constraint(equalTo: addCommentContainer.leadingAnchor, constant: 15).isActive = true
        bText.trailingAnchor.constraint(equalTo: addCommentContainer.trailingAnchor, constant: -60).isActive = true
//        bText.topAnchor.constraint(equalTo: addCommentContainer.topAnchor, constant: 15).isActive = true
        bText.centerYAnchor.constraint(equalTo: addCommentContainer.centerYAnchor, constant: 0).isActive = true
//        bText.leadingAnchor.constraint(equalTo: bottomBox.leadingAnchor, constant: 15).isActive = true
//        bText.trailingAnchor.constraint(equalTo: bottomBox.trailingAnchor, constant: -60).isActive = true
//        bText.topAnchor.constraint(equalTo: bottomBox.topAnchor, constant: 15).isActive = true
        bText.text = "Add comment..."
//        bText.layer.opacity = 0.5
        
        let lTextBtn = UIImageView()
        lTextBtn.image = UIImage(named:"icon_outline_photo")?.withRenderingMode(.alwaysTemplate)
//        lTextBtn.tintColor = .white
        lTextBtn.tintColor = .ddmDarkGrayColor
//        bottomBox.addSubview(lTextBtn)
        addCommentContainer.addSubview(lTextBtn)
        lTextBtn.translatesAutoresizingMaskIntoConstraints = false
//        lTextBtn.trailingAnchor.constraint(equalTo: bottomBox.trailingAnchor, constant: -15).isActive = true
        lTextBtn.trailingAnchor.constraint(equalTo: addCommentContainer.trailingAnchor, constant: -15).isActive = true
        lTextBtn.centerYAnchor.constraint(equalTo: bText.centerYAnchor).isActive = true
        lTextBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        lTextBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        lTextBtn.isHidden = false

        let mTextBtn = UIImageView()
        mTextBtn.image = UIImage(named:"icon_round_emoji")?.withRenderingMode(.alwaysTemplate)
//        mTextBtn.tintColor = .white
        mTextBtn.tintColor = .ddmDarkGrayColor
//        mTextBtn.layer.opacity = 0.5
//        bottomBox.addSubview(mTextBtn)
        addCommentContainer.addSubview(mTextBtn)
        mTextBtn.translatesAutoresizingMaskIntoConstraints = false
        mTextBtn.trailingAnchor.constraint(equalTo: lTextBtn.leadingAnchor, constant: -10).isActive = true
        mTextBtn.centerYAnchor.constraint(equalTo: bText.centerYAnchor).isActive = true
        mTextBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        mTextBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        mTextBtn.isHidden = false

        let nTextBtn = UIImageView()
        nTextBtn.image = UIImage(named:"icon_round_at")?.withRenderingMode(.alwaysTemplate)
//        nTextBtn.tintColor = .white
        nTextBtn.tintColor = .ddmDarkGrayColor
//        nTextBtn.layer.opacity = 0.5
//        bottomBox.addSubview(nTextBtn)
        addCommentContainer.addSubview(nTextBtn)
        nTextBtn.translatesAutoresizingMaskIntoConstraints = false
        nTextBtn.trailingAnchor.constraint(equalTo: mTextBtn.leadingAnchor, constant: -10).isActive = true
        nTextBtn.centerYAnchor.constraint(equalTo: bText.centerYAnchor).isActive = true
        nTextBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        nTextBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        nTextBtn.isHidden = false
        
        bottomBox.addSubview(sendCommentContainer)
        sendCommentContainer.translatesAutoresizingMaskIntoConstraints = false
        sendCommentContainer.leadingAnchor.constraint(equalTo: bottomBox.leadingAnchor, constant: 0).isActive = true
        sendCommentContainer.trailingAnchor.constraint(equalTo: bottomBox.trailingAnchor, constant: 0).isActive = true
        sendCommentContainer.topAnchor.constraint(equalTo: bottomBox.topAnchor, constant: 0).isActive = true //default: 50
        sendCommentContainer.bottomAnchor.constraint(equalTo: bottomBox.bottomAnchor, constant: 0).isActive = true
        sendCommentContainer.isHidden = true
        
        let sendAaView = UIView()
        sendAaView.backgroundColor = .ddmBlackDark
        sendCommentContainer.addSubview(sendAaView)
        sendAaView.translatesAutoresizingMaskIntoConstraints = false
        sendAaView.topAnchor.constraint(equalTo: sendCommentContainer.topAnchor, constant: 10).isActive = true
//        sendAaView.bottomAnchor.constraint(equalTo: sendCommentContainer.bottomAnchor, constant: -10).isActive = true //-10
        sendAaView.leadingAnchor.constraint(equalTo: sendCommentContainer.leadingAnchor, constant: 15).isActive = true
        sendAaView.trailingAnchor.constraint(equalTo: sendCommentContainer.trailingAnchor, constant: -50).isActive = true
        sendAaView.heightAnchor.constraint(equalToConstant: 40).isActive = true //36
        sendAaView.layer.cornerRadius = 10
        sendAaView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onOpenTextBoxClicked)))
        
//        let sendBText = UILabel()
        sendBText.textAlignment = .left
        sendBText.textColor = .white
//        bText.textColor = .ddmDarkGrayColor
        sendBText.font = .systemFont(ofSize: 13)
        sendAaView.addSubview(sendBText)
//        bottomBox.addSubview(bText)
        sendBText.clipsToBounds = true
        sendBText.translatesAutoresizingMaskIntoConstraints = false
        sendBText.leadingAnchor.constraint(equalTo: sendAaView.leadingAnchor, constant: 15).isActive = true
        sendBText.trailingAnchor.constraint(equalTo: sendAaView.trailingAnchor, constant: -60).isActive = true
//        sendBText.topAnchor.constraint(equalTo: sendAaView.topAnchor, constant: 15).isActive = true
        sendBText.centerYAnchor.constraint(equalTo: sendAaView.centerYAnchor, constant: 0).isActive = true
        sendBText.text = ""
        
        sendASpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        sendCommentContainer.addSubview(sendASpinner)
        sendASpinner.translatesAutoresizingMaskIntoConstraints = false
        sendASpinner.trailingAnchor.constraint(equalTo: sendCommentContainer.trailingAnchor, constant: -15).isActive = true
        sendASpinner.centerYAnchor.constraint(equalTo: sendAaView.centerYAnchor).isActive = true
        sendASpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        sendASpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true

        sendCommentContainer.addSubview(sendBBox)
        sendBBox.translatesAutoresizingMaskIntoConstraints = false
        sendBBox.widthAnchor.constraint(equalToConstant: 30).isActive = true //20
        sendBBox.heightAnchor.constraint(equalToConstant: 30).isActive = true
        sendBBox.centerYAnchor.constraint(equalTo: sendAaView.centerYAnchor).isActive = true
        sendBBox.centerXAnchor.constraint(equalTo: sendASpinner.centerXAnchor).isActive = true
        sendBBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClearTextBoxClicked)))
        sendBBox.isHidden = true
        
        let sendBBoxBg = UIView()
        sendBBoxBg.backgroundColor = .white
        sendBBox.addSubview(sendBBoxBg)
        sendBBoxBg.clipsToBounds = true
        sendBBoxBg.translatesAutoresizingMaskIntoConstraints = false
        sendBBoxBg.widthAnchor.constraint(equalToConstant: 20).isActive = true //20
        sendBBoxBg.heightAnchor.constraint(equalToConstant: 20).isActive = true
        sendBBoxBg.centerYAnchor.constraint(equalTo: sendBBox.centerYAnchor).isActive = true
        sendBBoxBg.centerXAnchor.constraint(equalTo: sendBBox.centerXAnchor).isActive = true
//        sendBBox.trailingAnchor.constraint(equalTo: sendCommentContainer.trailingAnchor, constant: -15).isActive = true
        sendBBoxBg.layer.cornerRadius = 10

        let aBtn = UIImageView(image: UIImage(named:"icon_round_close")?.withRenderingMode(.alwaysTemplate))
        aBtn.tintColor = .ddmDarkColor
        sendBBox.addSubview(aBtn)
        aBtn.translatesAutoresizingMaskIntoConstraints = false
        aBtn.centerXAnchor.constraint(equalTo: sendBBox.centerXAnchor).isActive = true
        aBtn.centerYAnchor.constraint(equalTo: sendBBox.centerYAnchor).isActive = true
        aBtn.heightAnchor.constraint(equalToConstant: 16).isActive = true
        aBtn.widthAnchor.constraint(equalToConstant: 16).isActive = true
        
        //test > real textview edittext for comment
        panel.addSubview(aView)
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
        panel.addSubview(textPanel)
        textPanel.translatesAutoresizingMaskIntoConstraints = false
        textPanel.leadingAnchor.constraint(equalTo: panel.leadingAnchor).isActive = true
        textPanel.trailingAnchor.constraint(equalTo: panel.trailingAnchor).isActive = true
        textPanelBottomCons = textPanel.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: 0)
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
        sendBox.bottomAnchor.constraint(equalTo: textPanel.bottomAnchor, constant: -13).isActive = true //-10
        sendBox.layer.cornerRadius = 15
        sendBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSendBtnClicked)))

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

//        aaView.backgroundColor = .ddmDarkColor
        aaView.backgroundColor = .ddmBlackDark
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
//        zGridIcon.tintColor = .white
        zGridIcon.tintColor = .ddmDarkGrayColor
        textPanel.addSubview(zGridIcon)
        zGridIcon.translatesAutoresizingMaskIntoConstraints = false
//        zGridIcon.centerXAnchor.constraint(equalTo: pMini.centerXAnchor, constant: 0).isActive = true
//        zGridIcon.bottomAnchor.constraint(equalTo: divider.topAnchor, constant: 0).isActive = true
        zGridIcon.centerXAnchor.constraint(equalTo: zGrid.centerXAnchor, constant: 0).isActive = true
        zGridIcon.centerYAnchor.constraint(equalTo: zGrid.centerYAnchor, constant: 0).isActive = true
        zGridIcon.heightAnchor.constraint(equalToConstant: 26).isActive = true //20
        zGridIcon.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        zGridIcon.layer.opacity = 0.5
        
        let yGrid = UIView()
        textPanel.addSubview(yGrid)
//        yGrid.backgroundColor = .red
        yGrid.translatesAutoresizingMaskIntoConstraints = false
        yGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        yGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
        yGrid.trailingAnchor.constraint(equalTo: zGrid.leadingAnchor, constant: 0).isActive = true
        yGrid.bottomAnchor.constraint(equalTo: aaView.bottomAnchor, constant: 0).isActive = true

        let yGridIcon = UIImageView(image: UIImage(named:"icon_round_emoji")?.withRenderingMode(.alwaysTemplate))
//        yGridIcon.tintColor = .white
        yGridIcon.tintColor = .ddmDarkGrayColor
        textPanel.addSubview(yGridIcon)
        yGridIcon.translatesAutoresizingMaskIntoConstraints = false
//        yGridIcon.centerXAnchor.constraint(equalTo: pMini.centerXAnchor, constant: 0).isActive = true
//        yGridIcon.bottomAnchor.constraint(equalTo: divider.topAnchor, constant: 0).isActive = true
        yGridIcon.centerXAnchor.constraint(equalTo: yGrid.centerXAnchor, constant: 0).isActive = true
        yGridIcon.centerYAnchor.constraint(equalTo: yGrid.centerYAnchor, constant: 0).isActive = true
        yGridIcon.heightAnchor.constraint(equalToConstant: 26).isActive = true //20
        yGridIcon.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        yGridIcon.layer.opacity = 0.5

//        let xGrid = UIView()
        textPanel.addSubview(xGrid)
//        xGrid.backgroundColor = .red
        xGrid.translatesAutoresizingMaskIntoConstraints = false
        xGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        xGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
        xGrid.trailingAnchor.constraint(equalTo: yGrid.leadingAnchor, constant: 0).isActive = true
        xGrid.bottomAnchor.constraint(equalTo: aaView.bottomAnchor, constant: 0).isActive = true

        let xGridIcon = UIImageView(image: UIImage(named:"icon_round_at")?.withRenderingMode(.alwaysTemplate))
        xGridIcon.tintColor = .ddmDarkGrayColor
        textPanel.addSubview(xGridIcon)
        xGridIcon.translatesAutoresizingMaskIntoConstraints = false
//        xGridIcon.centerXAnchor.constraint(equalTo: pMini.centerXAnchor, constant: 0).isActive = true
//        xGridIcon.bottomAnchor.constraint(equalTo: divider.topAnchor, constant: 0).isActive = true
        xGridIcon.centerXAnchor.constraint(equalTo: xGrid.centerXAnchor, constant: 0).isActive = true
        xGridIcon.centerYAnchor.constraint(equalTo: xGrid.centerYAnchor, constant: 0).isActive = true
        xGridIcon.heightAnchor.constraint(equalToConstant: 26).isActive = true //20
        xGridIcon.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        xGridIcon.layer.opacity = 0.5

        aTextBox.textAlignment = .left
        aTextBox.textColor = .white
        aTextBox.backgroundColor = .clear
        aTextBox.font = .systemFont(ofSize: 13)
        textPanel.addSubview(aTextBox)
        aTextBox.translatesAutoresizingMaskIntoConstraints = false
        aTextBottomCons = aTextBox.bottomAnchor.constraint(equalTo: aaView.bottomAnchor, constant: 0)
        aTextBottomCons?.isActive = true
        aTextBox.leadingAnchor.constraint(equalTo: aaView.leadingAnchor, constant: 10).isActive = true
        aTextTrailingCons = aTextBox.trailingAnchor.constraint(equalTo: xGrid.leadingAnchor, constant: 0)
        aTextTrailingCons?.isActive = true
        aTextBox.topAnchor.constraint(equalTo: aaView.topAnchor, constant: 4).isActive = true
        aTextBoxHeightCons = aTextBox.heightAnchor.constraint(equalToConstant: 36)
        aTextBoxHeightCons?.isActive = true
        aTextBox.text = ""
        aTextBox.delegate = self
        aTextBox.tintColor = .yellow

//        let bbText = UILabel()
        bbText.textAlignment = .left
//        bbText.textColor = .white
        bbText.textColor = .ddmDarkGrayColor
        bbText.font = .boldSystemFont(ofSize: 13)
        textPanel.addSubview(bbText)
        bbText.clipsToBounds = true
        bbText.translatesAutoresizingMaskIntoConstraints = false
        bbText.leadingAnchor.constraint(equalTo: aTextBox.leadingAnchor, constant: 10).isActive = true
//        bbText.trailingAnchor.constraint(equalTo: xGrid.leadingAnchor, constant: -10).isActive = true
        bbText.topAnchor.constraint(equalTo: aTextBox.topAnchor, constant: 8).isActive = true
        bbText.text = "Say something nice..."
//        bbText.layer.opacity = 0.5
    }
    
    //test > initialization state
    var isInitialized = false
    func initialize() {
        
        if(!isInitialized) {
//            self.asyncFetchFeed(id: "comment_feed")
            self.asyncFetchPost(id: "post_")
        }
        
        isInitialized = true
        
        print("pdpv init")
    }
    
    func closePanel(isAnimated: Bool) {
        if(isAnimated) {
            UIView.animate(withDuration: 0.2, animations: {
                self.panelLeadingCons?.constant = self.frame.width
                self.layoutIfNeeded()
            }, completion: { _ in
                //test > stop video before closing panel
                self.destroyCell()
//                self.pausePlayingMedia()
                
                self.removeFromSuperview()
                
                //move back to origin
                self.panelLeadingCons?.constant = 0
                self.delegate?.didClickPhotoDetailClosePanel()
            })
        } else {
            //test > stop video before closing panel
            self.destroyCell()
//            self.pausePlayingMedia()
            
            self.removeFromSuperview()
            
            self.delegate?.didClickPhotoDetailClosePanel()
        }
    }
    
    //helper function: top and bottom margin to accomodate spinners while fetching data
    func adjustContentInset(topInset: CGFloat, bottomInset: CGFloat) {
        self.photoCV?.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
    }
    func adjustContentOffset(x: CGFloat, y: CGFloat, animated: Bool) {
        self.photoCV?.setContentOffset(CGPoint(x: x, y: y), animated: true)
    }
    
    //*test > remove one comment
    var selectedItemIdx = -1
    func removeData(idxToRemove: Int) {
        if(!vcDataList.isEmpty) {
            if(idxToRemove > -1 && idxToRemove < vcDataList.count) {
                if(idxToRemove == 0) {
                    var indexPaths = [IndexPath]()
                    var i = 0
                    for _ in vcDataList {
                        let idx = IndexPath(item: i, section: 0)
                        indexPaths.append(idx)
                        i += 1
                    }
                    vcDataList.removeAll()
                    self.photoCV?.deleteItems(at: indexPaths)
                } else {
                    var indexPaths = [IndexPath]()
                    let idx = IndexPath(item: idxToRemove, section: 0)
                    indexPaths.append(idx)
                    
                    vcDataList.remove(at: idxToRemove)
                    self.photoCV?.deleteItems(at: indexPaths)
                }
            
                unselectItemData()
                
                //test
                if(vcDataList.isEmpty) {
                    //entire post is deleted
                    self.setFooterAaText(text: "Shot no longer exists.")
                    self.configureFooterUI(data: "na")
//                    self.aaText.text = "Shot no longer exists."
                }
                else if(vcDataList.count == 1) {
                    //no more comments
                    self.setFooterAaText(text: "No comments yet.")
                    self.configureFooterUI(data: "na")
//                    self.aaText.text = "No comments yet."
                }
            }
        }
    }

    func unselectItemData() {
        selectedItemIdx = -1
    }
    
    func addData() {
        var indexPaths = [IndexPath]()
        
        let i = "b"
        let postData = PostData()
        postData.setDataType(data: i)
        postData.setData(data: i)
        postData.setTextString(data: i)
        self.vcDataList.insert(postData, at: 1) //second item
        
        let idx = IndexPath(item: 1, section: 0) //second item
        indexPaths.append(idx)
        self.photoCV?.insertItems(at: indexPaths)
    }
    //*
    
    func configureUI(data: String) {
        if(data == "a") {
            aMoreCBtn.isHidden = false
        } else {
            deconfigureUI()
        }
    }
    func deconfigureUI(){
        aMoreCBtn.isHidden = true
    }
    
    //test > fetch post before comments
    func asyncFetchPost(id: String) {
        aSpinner.startAnimating()
        
        DataFetchManager.shared.fetchPostData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("pdp api success \(id), \(l)")
                    
                    guard let self = self else {
                        return
                    }
                    
                    self.aSpinner.stopAnimating()
                    
                    if(!l.isEmpty) {
                        let l_ = l[0]
                        
                        //test 2 > new append method
                        let postData = PhotoData()
                        postData.setDataType(data: l_) //"a"
                        postData.setData(data: l_)
                        postData.setTextString(data: l_)
                        self.vcDataList.append(postData)
                        self.photoCV?.reloadData()
                        
                        //test
                        self.configureUI(data: l_)
                    }
                    
                    self.asyncFetchFeed(id: "comment_feed")
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    print("api fail \(error)")
                    guard let self = self else {
                        return
                    }
                    
                    self.aSpinner.stopAnimating()
                    
                    //test
                    self.configureUI(data: "ep")
                    self.configureFooterUI(data: "ep")
                }
                break
            }
        }
    }
    
    //test > fetch data => temp fake data => try refresh data first
    func asyncFetchFeed(id: String) {
        print("pdp asyncfetch")
        dataFetchState = "start"
        bSpinner.startAnimating()
        
        let id_ = "post"
        let isPaginate = false
        DataFetchManager.shared.fetchFeedData(id: id_, isPaginate: isPaginate) { [weak self]result in
//        DataFetchManager.shared.fetchData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("pdp api success \(id), \(l)")
                    
                    guard let self = self else {
                        return
                    }
                    
                    self.bSpinner.stopAnimating()
                    self.dataFetchState = "end"
                    
                    //*test 3 > reload only appended data, not entire dataset
                    let dataCount = self.vcDataList.count
                    var indexPaths = [IndexPath]()
                    var j = 1
                    for i in l {
//                        let photoData = PhotoData()
                        let postData = PostData()
                        postData.setDataType(data: i)
                        postData.setData(data: i)
                        postData.setTextString(data: i)
                        self.vcDataList.append(postData)

                        let idx = IndexPath(item: dataCount - 1 + j, section: 0)
                        indexPaths.append(idx)
                        j += 1
                    }
                    self.photoCV?.insertItems(at: indexPaths)
                    //*
                    
                    //test
                    if(l.isEmpty) {
                        self.setFooterAaText(text: "No comments yet.")
                        self.configureFooterUI(data: "na")
//                        self.aaText.text = "No comments yet."
                    }
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    print("pdp api fail")
                    self?.bSpinner.stopAnimating()
                    
                    self?.configureFooterUI(data: "e")
                }
                break
            }
        }
    }
    
    func asyncPaginateFetchFeed(id: String) {
        print("pdpv asyncpaginate")
        bSpinner.startAnimating()
        
        pageNumber += 1
        
        let id_ = "post"
        let isPaginate = true
        DataFetchManager.shared.fetchFeedData(id: id_, isPaginate: isPaginate) { [weak self]result in
//        DataFetchManager.shared.fetchData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("pdp api success \(id), \(l), \(l.isEmpty)")
                    
                    guard let self = self else {
                        return
                    }
                    
                    if(l.isEmpty) {
                        self.dataPaginateStatus = "end"
                    }
                    //test
                    self.bSpinner.stopAnimating()
                    
                    //*test 3 > reload only appended data, not entire dataset
                    let dataCount = self.vcDataList.count
                    var indexPaths = [IndexPath]()
                    var j = 1
                    for i in l {
//                        let photoData = PhotoData()
                        let postData = PostData()
                        postData.setDataType(data: i)
                        postData.setData(data: i)
                        postData.setTextString(data: i)
                        self.vcDataList.append(postData)

                        let idx = IndexPath(item: dataCount - 1 + j, section: 0)
                        indexPaths.append(idx)
                        j += 1
                    }
                    self.photoCV?.insertItems(at: indexPaths)
                    //*
                    
                    //test
                    if(l.isEmpty) {
                        self.configureFooterUI(data: "end")
                    }
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    print("pdp api fail")
                    self?.bSpinner.stopAnimating()
                    
                    self?.configureFooterUI(data: "e")
                }
                break
            }
        }
    }
    
    //test > fetch data => temp fake data => try refresh data first
    func refreshFetchData() {
        self.vcDataList.removeAll()
        self.photoCV?.reloadData()
        
        configureFooterUI(data: "")
        configureUI(data: "")
        
        dataFetchState = ""
        dataPaginateStatus = ""
        
        asyncFetchPost(id: "post")
    }
    func refreshFetchCommentData() {
        if(self.vcDataList.count > 1) {
            let dataCount = self.vcDataList.count
            var indexPaths = [IndexPath]()
            let endIndex = dataCount - 1
            for i in 1...endIndex { //loop from 1 to endindex
                let idx = IndexPath(item: i, section: 0)
                indexPaths.append(idx)
            }
            self.vcDataList.removeSubrange(1..<endIndex + 1) //remove element from 1 to endindex
            self.photoCV?.deleteItems(at: indexPaths)
        }
        configureFooterUI(data: "")
        
        dataFetchState = ""
        dataPaginateStatus = ""
        self.asyncFetchFeed(id: "comment_feed")
    }
    
    //test > footer error handling for refresh feed
    @objc func onErrorRefreshClicked(gesture: UITapGestureRecognizer) {
        print("error refresh clicked")
        if(self.vcDataList.count > 0) {
            refreshFetchCommentData()
        } else {
            refreshFetchData()
        }
    }
    
    var footerState = ""
    var footerAaText = ""
    func setFooterAaText(text: String) {
        footerAaText = text
    }
    func configureFooterUI(data: String) {
        aaText.text = ""
        errorText.text = ""
        errorRefreshBtn.isHidden = true
        
        if(data == "end") {
            aaText.text = "End"
        }
        else if(data == "e") {
            errorText.text = "Unable to load comments. Try again"
            errorRefreshBtn.isHidden = false
        }
        else if(data == "ep") { //error loading shot
            errorText.text = "Unable to load shot. Try again"
            errorRefreshBtn.isHidden = false
        }
        else if(data == "na") {
            aaText.text = footerAaText
            //removed, text to be customized at panelview level
        }
        
        footerState = data
    }
    
    //test > sticky header title animation when scroll up and down
    var isStickyCommentTitleDisplayed = false
    func stickyCommentTitleAnimateDisplay() {
        //title appear
        if(isStickyCommentTitleDisplayed == false) {
            UIView.animate(withDuration: 0.2, animations: {
                self.stickyH1TopCons?.constant = -50.0
                self.stickyH2TopCons?.constant = 0.0
                self.layoutIfNeeded()

                self.isStickyCommentTitleDisplayed = true
            })
        }
    }
    func stickyCommentTitleAnimateHide() {
        //title hide
        if(isStickyCommentTitleDisplayed == true) {
            UIView.animate(withDuration: 0.2, animations: {
                self.stickyH1TopCons?.constant = 0.0
                self.stickyH2TopCons?.constant = 50.0
                self.layoutIfNeeded()

                self.isStickyCommentTitleDisplayed = false
            })
        }
    }
    
    //test > share sheet
    func openShareSheet() {
        let sharePanel = ShareSheetScrollableView(frame: CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.height))
        self.addSubview(sharePanel)
        sharePanel.translatesAutoresizingMaskIntoConstraints = false
        sharePanel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        sharePanel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        sharePanel.delegate = self
        
        //test > track comment scrollable view
        pageList.append(sharePanel)
    }
    
    //test > add comment panel
    func openComment() {
        let commentPanel = CommentScrollableView(frame: CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.height))
        panel.addSubview(commentPanel)
//        panel.insertSubview(commentPanel, belowSubview: bottomBox)
        commentPanel.translatesAutoresizingMaskIntoConstraints = false
        commentPanel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        commentPanel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        commentPanel.delegate = self
        commentPanel.initialize()
        commentPanel.setBackgroundDark()
        
//        bottomBox.isHidden = false
        
        //test > track comment scrollable view
        pageList.append(commentPanel)
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
    
    //test
    override func resumeActiveState() {
        print("photodetailpanelview resume active")
        
        //test > only resume video if no comment scrollable view/any other view
        if(pageList.isEmpty) {
            resumePlayingMedia()
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
    
    //test > dehide cell
    func dehideCell() {
        guard let a = self.photoCV else {
            return
        }

        if(hideCellIndex > -1){
            let idxPath = IndexPath(item: hideCellIndex, section: 0)
            let currentVc = a.cellForItem(at: idxPath)

            if let b = currentVc as? HPhotoListBViewCell {
                b.dehideCell()
                hideCellIndex = -1
            } else if let b1 = currentVc as? HCommentListViewCell {
                b1.dehideCell()
                hideCellIndex = -1
            }
        }
    }
    
    //test > stop current video for closing
    func pausePlayingMedia() {
        //test 2 > new method for cell-asset idx
        pauseMediaAsset(cellAssetIdx: playingCellMediaAssetIdx)
    }
    //test > resume current video
    func resumePlayingMedia() {
        //test 2 > new method for cell-asset idx
        resumeMediaAsset(cellAssetIdx: playingCellMediaAssetIdx)
    }
    
    //test > destroy cell
    func destroyCell() {
        guard let a = self.photoCV else {
            return
        }
        for cell in a.visibleCells {
            if let c = cell as? HCommentListViewCell {
                c.destroyCell()
            }
            else if let b = cell as? HPhotoListBViewCell {
                b.destroyCell()
            }
        }
    }
    
    //test 2 > new method for pausing video with cell-asset idx
    func pauseMediaAsset(cellAssetIdx: [Int]) {
        guard let a = self.photoCV else {
            return
        }
        if(cellAssetIdx.count == 2) {
            let cIdx = cellAssetIdx[0] //cell index
            let aIdx = cellAssetIdx[1] //asset index
            if(cIdx > -1 && aIdx > -1) {
                let cIdxPath = IndexPath(item: cIdx, section: 0)
                let cell = a.cellForItem(at: cIdxPath)
                if let c = cell as? HCommentListViewCell {
                    if(!c.aTestArray.isEmpty && aIdx < c.aTestArray.count) {
                        c.pauseMedia(aIdx: aIdx)
//                        playingCellMediaAssetIdx = [-1, -1] //disabled for pauseCurrentVideo() and resume
                    }
                } else if let b = cell as? HPhotoListBViewCell {
                    if(!b.aTestArray.isEmpty && aIdx < b.aTestArray.count) {
                        b.pauseMedia(aIdx: aIdx)
//                        playingCellMediaAssetIdx = [-1, -1] //disabled for pauseCurrentVideo() and resume
                    }
                }
            }
        }
    }
    
    func resumeMediaAsset(cellAssetIdx: [Int]) {
        guard let a = self.photoCV else {
            return
        }
        if(cellAssetIdx.count == 2) {
            let cIdx = cellAssetIdx[0]
            let aIdx = cellAssetIdx[1]
            if(cIdx > -1 && aIdx > -1) {
                let cIdxPath = IndexPath(item: cIdx, section: 0)
                let cell = a.cellForItem(at: cIdxPath)
                if let c = cell as? HCommentListViewCell {
                    if(!c.aTestArray.isEmpty && aIdx < c.aTestArray.count) {
                        c.resumeMedia(aIdx: aIdx)
                    }
                } else if let b = cell as? HPhotoListBViewCell {
                    if(!b.aTestArray.isEmpty && aIdx < b.aTestArray.count) {
                        b.resumeMedia(aIdx: aIdx)
                    }
                }
            }
        }
    }
    
    //test 2 > new intersect func() for multi-video/audio assets play on/off
    //try autoplay OFF first, then only autoplay
    var playingCellMediaAssetIdx = [-1, -1] //none playing initially
//    var isMediaAutoplayEnabled = true
    var isMediaAutoplayEnabled = false
    func getIntersect2() {
        guard let v = self.photoCV else {
            return
        }
        
        //fixed dummy area
        let dummyTopMargin = 100.0
//        let panelRectY = panelView.frame.origin.y
        let vCvRectY = v.frame.origin.y
        let dummyOriginY = vCvRectY + dummyTopMargin
        let dummyView = CGRect(x: 0, y: dummyOriginY, width: self.frame.width, height: 500) //400, not tall enough
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
            
            let cellRect = v.convert(cell.frame, to: self)
            
            if let b = cell as? HCommentListViewCell {
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
            } else if let c = cell as? HPhotoListBViewCell {
                let aTestRect = c.aTest.frame
                
                let p = c.mediaArray
                if(!p.isEmpty) {
                    for m in p {
                        let mFrame = m.frame
                        if let j = c.aTestArray.firstIndex(of: m) {
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
 
        print("getintersect2 x: \(cellAssetIdxArray); \(playingCellMediaAssetIdx)")
        
        //test > pause media when playingMedia is no longer intersected inside dummy view
        let t = cellAssetIdxArray.contains(playingCellMediaAssetIdx)
        if(!t) {
            pauseMediaAsset(cellAssetIdx: playingCellMediaAssetIdx)
            playingCellMediaAssetIdx = [-1, -1] //reset state
        }
        
        //test > autoplay video when intersected
        if(isMediaAutoplayEnabled) {
            if(!cellAssetIdxArray.isEmpty) {
                let iCellAssetIdx = cellAssetIdxArray[0]
                print("getintersect2 x: \(iCellAssetIdx); \(playingCellMediaAssetIdx) => \(iCellAssetIdx == playingCellMediaAssetIdx)")
                if(iCellAssetIdx != playingCellMediaAssetIdx) {
                    
                    //autostop playing media to prevent multi-video playing together
                    if(playingCellMediaAssetIdx != [-1, -1]) {
                        pauseMediaAsset(cellAssetIdx: playingCellMediaAssetIdx)
                        playingCellMediaAssetIdx = [-1, -1]
                    }
                    
                    //autoplay media when intersected
                    if(iCellAssetIdx.count == 2) {
                        let cIdx = iCellAssetIdx[0]
                        let aIdx = iCellAssetIdx[1]
                        if(cIdx > -1 && aIdx > -1) {
                            playingCellMediaAssetIdx = [cIdx, aIdx]
                            resumeMediaAsset(cellAssetIdx: playingCellMediaAssetIdx)
                        }
                    }
                }
            }
        }
    }
    
    //test > add a timer before checking intersected video index
    func asyncAutoplay(id: String) {
        DataFetchManager.shared.fetchData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("asyncLayoutVc post detail api success \(id), \(l)")

                    guard let self = self else {
                        return
                    }

                    self.getIntersect2()
                }

                case .failure(_):
                    print("api fail")
                    break
            }
        }
    }
    
    //test > adjust textview bottom margin when keyboard up
    override func keyboardUp(margin: CGFloat) {
        
        //test 2 > check pagelist first
        if(pageList.isEmpty) {
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
        else {
            let c = pageList[pageList.count - 1]
            c.keyboardUp(margin: margin)
        }
    }

    @objc func onOpenTextBoxClicked(gesture: UITapGestureRecognizer) {
        if(getVCDataType() == "a") {
            if(!isStatusUploading) {
                setFirstResponder(textView: aTextBox)
            }
        }
    }
    @objc func onCloseTextBoxClicked(gesture: UITapGestureRecognizer) {
        //test > check if textbox is empty
        if(aTextBox.text != "") {
            sendBText.text = aTextBox.text
            addCommentContainer.isHidden = true
            sendCommentContainer.isHidden = false
            sendBBox.isHidden = false
        } else {
            sendBText.text = ""
            addCommentContainer.isHidden = false
            sendCommentContainer.isHidden = true
            sendBBox.isHidden = true
            
            clearTextbox()
        }
        
        resignResponder()

        self.textPanel.transform = CGAffineTransform(translationX: 0, y: 0)
    }
    @objc func onClearTextBoxClicked(gesture: UITapGestureRecognizer) {
        
        sendBBox.isHidden = true
        addCommentContainer.isHidden = false
        sendCommentContainer.isHidden = true
        
        clearTextbox()
    }
    @objc func onSendBtnClicked(gesture: UITapGestureRecognizer) {
        
        sendBText.text = aTextBox.text
        
        resignResponder()
        asyncSendNewData()
        
        self.textPanel.transform = CGAffineTransform(translationX: 0, y: 0)
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
    
    var isStatusUploading = false
    func asyncSendNewData() {
        addCommentContainer.isHidden = true
        sendCommentContainer.isHidden = false
        
        sendASpinner.startAnimating()
        sendBBox.isHidden = true
        
        isStatusUploading = true
        
        let id = "c_"
        DataFetchManager.shared.sendCommentData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                DispatchQueue.main.async {
                    guard let self = self else {
                        return
                    }
                    
                    self.addCommentContainer.isHidden = false
                    self.sendCommentContainer.isHidden = true
                    
                    self.sendASpinner.stopAnimating()
                    
                    self.addData()
                    self.photoCV?.setContentOffset(CGPoint(x: 0.0, y: self.postHeight), animated: false)
                    self.clearTextbox()
                    
                    self.isStatusUploading = false
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    guard let self = self else {
                        return
                    }
                    
                    self.sendASpinner.stopAnimating()
                    self.sendBBox.isHidden = false
                    self.openErrorUploadMsg()
                    
                    self.isStatusUploading = false
                }
                break
            }
        }
    }
    
    func clearTextbox() {
        aTextBox.text = ""
        sendBText.text = ""
        
        aaViewTrailingCons?.isActive = false
        aaViewTrailingCons = aaView.trailingAnchor.constraint(equalTo: textPanel.trailingAnchor, constant: -15)
        aaViewTrailingCons?.isActive = true

        aTextTrailingCons?.isActive = false
        aTextTrailingCons = aTextBox.trailingAnchor.constraint(equalTo: xGrid.leadingAnchor, constant: 0)
        aTextTrailingCons?.isActive = true

        aTextBottomCons?.isActive = false
        aTextBottomCons = aTextBox.bottomAnchor.constraint(equalTo: aaView.bottomAnchor, constant: 0)
        aTextBottomCons?.isActive = true

        let minHeight = 36.0
        aTextBoxHeightCons?.constant = minHeight
        
        bbText.isHidden = false
    }
    //test > view pan gesture to prevent video panel move by panning textview
    @objc func onTextViewPanGesture(gesture: UIPanGestureRecognizer) {
        print("onPan start A: ")
    }
    //test > helper function to get current viewcell datatype
    func getVCDataType() -> String {
        let postIdx = 0
        if(!self.vcDataList.isEmpty) {
            let d = self.vcDataList[postIdx].dataType
            return d
        }
        
        return ""
    }
}

extension PhotoDetailPanelView: UICollectionViewDelegateFlowLayout {
    
    private func estimateHeight(text: String, textWidth: CGFloat, fontSize: CGFloat) -> CGFloat {
        if(text == "") {
            return 0
        } else {
            let size = CGSize(width: textWidth, height: 1000)
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]
            let estimatedFrame = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            
            return estimatedFrame.height
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                   layout collectionViewLayout: UICollectionViewLayout,
                   sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("postpanel collection 2: \(indexPath)")
//        let lay = collectionViewLayout as! UICollectionViewFlowLayout
//        let widthPerItem = collectionView.frame.width / 3 - lay.minimumInteritemSpacing
        
        if(indexPath.item == 0) {
            
            let text = vcDataList[indexPath.row].dataTextString
            let dataL = vcDataList[indexPath.row].dataArray
            let dataCL = vcDataList[indexPath.row].contentDataArray
            let d = vcDataList[indexPath.row].dataType
            
            let statText = "1.2m views . 3hr"
            var contentHeight = 0.0
            
            if(d == "a") {
                for cl in dataCL {
                    let l = cl.dataType

                    let availableWidth = self.frame.width
                    let bubbleHeight = 3.0
                    let bubbleTopMargin = 10.0
                    let totalBubbleH = bubbleHeight + bubbleTopMargin

                    let assetSize = CGSize(width: 3, height: 4) //4:3
                    var cSize = CGSize(width: 0, height: 0)
                    if(assetSize.width > assetSize.height) {
                        //1 > landscape photo 4:3 w:h
                        let aRatio = CGSize(width: 4, height: 3) //aspect ratio
                        let cHeight = availableWidth * aRatio.height / aRatio.width + totalBubbleH
                        cSize = CGSize(width: availableWidth, height: cHeight)
                    }
                    else if (assetSize.width < assetSize.height){
                        //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                        let aRatio = CGSize(width: 5, height: 6) //aspect ratio 2:3, 3:4
                        let cWidth = availableWidth
                        let cHeight = cWidth * aRatio.height / aRatio.width + totalBubbleH
                        cSize = CGSize(width: cWidth, height: cHeight)
                    } else {
                        //square
                        let cWidth = availableWidth
                        cSize = CGSize(width: cWidth, height: cWidth + totalBubbleH)
                    }
                    
                    let pTopMargin = 0.0
        //                let pContentHeight = 400.0 //280.0
                    let pContentHeight = cSize.height
                    let tTopMargin = 10.0
        //                let tText = "Nice food, nice environment! Worth a visit. \nSo good!"
                    let tContentHeight = estimateHeight(text: text, textWidth: collectionView.frame.width - 20.0 - 20.0, fontSize: 14)
                    print("photo p text size: \(tContentHeight), \(text)")
                    let pHeight = pTopMargin + pContentHeight + tTopMargin + tContentHeight
                    contentHeight += pHeight
                    
                    if(l == "m") {
                        let soundTopMargin = 10.0
                        let soundHeight = 30.0
                        let pHeight = soundTopMargin + soundHeight
                        contentHeight += pHeight
                    }
                    else if(l == "p") {

                    }
                }
            }
            else if(d == "na") {
                let npTopMargin = 20.0
                let npTTopMargin = 20.0 //10
                let npTBottomMargin = 20.0
                let npText = "Shot does not exist."
                let npContentHeight = estimateHeight(text: npText, textWidth: collectionView.frame.width - 20.0 - 20.0, fontSize: 13)
                let npHeight = npTTopMargin + npContentHeight + npTBottomMargin + npTopMargin
                contentHeight += npHeight
                
                //test > add margin for text
                let tTopMargin = 10.0
                let t = "-"
                let tContentHeight = estimateHeight(text: t, textWidth: collectionView.frame.width - 20.0 - 20.0, fontSize: 14)
                let tHeight = tTopMargin + tContentHeight
                contentHeight += tHeight
            }
            else if(d == "us") {
                let npTopMargin = 20.0
                let npTTopMargin = 20.0 //10
                let npTBottomMargin = 20.0
                let npText = "Shot violated community rules."
                let npContentHeight = estimateHeight(text: npText, textWidth: collectionView.frame.width - 20.0 - 20.0, fontSize: 13)
                let npHeight = npTTopMargin + npContentHeight + npTBottomMargin + npTopMargin
                contentHeight += npHeight
                
                //test > add margin for text
                let tTopMargin = 10.0
                let t = "-"
                let tContentHeight = estimateHeight(text: t, textWidth: collectionView.frame.width - 20.0 - 20.0, fontSize: 14)
                let tHeight = tTopMargin + tContentHeight
                contentHeight += tHeight
            }
            
            let userPhotoHeight = 40.0
            let userPhotoTopMargin = 10.0 //10
            let statTopMargin = 10.0 //number of views
            let statContentHeight = estimateHeight(text: statText, textWidth: collectionView.frame.width - 20.0 - 20.0, fontSize: 12)
            let actionBtnTopMargin = 10.0
            let actionBtnHeight = 30.0
            let frameBottomMargin = 20.0 //10
            let locationTopMargin = 10.0
            let locationHeight = estimateHeight(text: "Petronas", textWidth: collectionView.frame.width - 20.0 - 20.0, fontSize: 14) + 10
            let sortCommentBtnTopMargin = 30.0
            let sortCommentBtnHeight = 26.0

            let miscHeight = userPhotoHeight + userPhotoTopMargin + statTopMargin + statContentHeight + actionBtnTopMargin + actionBtnHeight + locationHeight + locationTopMargin + frameBottomMargin + sortCommentBtnTopMargin + sortCommentBtnHeight
            let totalHeight = contentHeight + miscHeight
            
            postHeight = totalHeight
            
            return CGSize(width: collectionView.frame.width, height: totalHeight)
            
        } else {
            let text = vcDataList[indexPath.row].dataTextString
            let dataL = vcDataList[indexPath.row].dataArray
            let dataCL = vcDataList[indexPath.row].contentDataArray
            let d = vcDataList[indexPath.row].dataType
            
            var contentHeight = 0.0
            
            let photoSize = 28.0
            let photoLhsMargin = 20.0
            let usernameLhsMargin = 5.0
            let indentSize = photoSize + photoLhsMargin + usernameLhsMargin
            
            if(d == "a") {
                for cl in dataCL {
                    let l = cl.dataType

                    if(l == "t") {
                        let tTopMargin = 20.0
                        let tContentHeight = estimateHeight(text: text, textWidth: collectionView.frame.width - indentSize - 30.0, fontSize: 13)
                        let tHeight = tTopMargin + tContentHeight
                        contentHeight += tHeight
                    }
                    else if(l == "p") {
                        let cellWidth = self.frame.width
                        let lhsMargin = indentSize
                        let rhsMargin = 20.0
                        let availableWidth = cellWidth - lhsMargin - rhsMargin
                        
                        let assetSize = CGSize(width: 3, height: 4) //4:3
                        var cSize = CGSize(width: 0, height: 0)
                        if(assetSize.width > assetSize.height) {
                            //1 > landscape photo 4:3 w:h
                            let aRatio = CGSize(width: 4, height: 3) //aspect ratio
                            let cHeight = availableWidth * aRatio.height / aRatio.width
                            cSize = CGSize(width: availableWidth, height: cHeight)
                        }
                        else if (assetSize.width < assetSize.height){
                            //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                            let aRatio = CGSize(width: 2, height: 3) //aspect ratio
                            let cWidth = availableWidth * 2 / 3
                            let cHeight = cWidth * aRatio.height / aRatio.width
                            cSize = CGSize(width: cWidth, height: cHeight)
                        } else {
                            //square
                            let cWidth = availableWidth
                            cSize = CGSize(width: cWidth, height: cWidth)
                        }
                        
                        let pTopMargin = 20.0
                        let pContentHeight = cSize.height //280
                        let pHeight = pTopMargin + pContentHeight
                        contentHeight += pHeight
                    }
                    else if(l == "p_s") {
                        let cellWidth = self.frame.width
                        let lhsMargin = indentSize
                        let rhsMargin = 20.0
                        let descHeight = 40.0
                        let availableWidth = cellWidth - lhsMargin - rhsMargin
                        
                        let assetSize = CGSize(width: 4, height: 3)
                        var cSize = CGSize(width: 0, height: 0)
                        if(assetSize.width > assetSize.height) {
                            //1 > landscape photo 4:3 w:h
                            let aRatio = CGSize(width: 4, height: 3) //aspect ratio
                            let cHeight = availableWidth * aRatio.height / aRatio.width + descHeight
                            cSize = CGSize(width: availableWidth, height: cHeight)
                        }
                        else if (assetSize.width < assetSize.height){
                            //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                            let aRatio = CGSize(width: 2, height: 3) //aspect ratio
                            let cWidth = availableWidth * 2 / 3
                            let cHeight = cWidth * aRatio.height / aRatio.width + descHeight
                            cSize = CGSize(width: cWidth, height: cHeight)
                        } else {
                            //square
                            let cWidth = availableWidth
                            cSize = CGSize(width: cWidth, height: cWidth + descHeight)
                        }
                        
                        let pTopMargin = 20.0
                        let pContentHeight = cSize.height //280
                        let pHeight = pTopMargin + pContentHeight
                        contentHeight += pHeight
                    }
                    else if(l == "v") {
                        let cellWidth = self.frame.width
                        let lhsMargin = indentSize
                        let rhsMargin = 20.0
                        let availableWidth = cellWidth - lhsMargin - rhsMargin
                        
                        let assetSize = CGSize(width: 3, height: 4)
                        var cSize = CGSize(width: 0, height: 0)
                        if(assetSize.width > assetSize.height) {
                            //1 > landscape photo 4:3 w:h
                            let aRatio = CGSize(width: 4, height: 3) //aspect ratio
                            let cHeight = availableWidth * aRatio.height / aRatio.width
                            cSize = CGSize(width: availableWidth, height: cHeight)
                        }
                        else if (assetSize.width < assetSize.height){
                            //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                            let aRatio = CGSize(width: 2, height: 3) //aspect ratio
                            let cWidth = availableWidth * 2 / 3
                            let cHeight = cWidth * aRatio.height / aRatio.width
                            cSize = CGSize(width: cWidth, height: cHeight)
                        } else {
                            //square
                            let cWidth = availableWidth
                            cSize = CGSize(width: cWidth, height: cWidth)
                        }
                        
                        let vTopMargin = 20.0
                        let vContentHeight = cSize.height //350
                        let vHeight = vTopMargin + vContentHeight
                        contentHeight += vHeight
                    }
                    else if(l == "v_l") {
                        let cellWidth = self.frame.width
                        let lhsMargin = indentSize
                        let rhsMargin = 20.0
                        let descHeight = 40.0
                        let availableWidth = cellWidth - lhsMargin - rhsMargin
                        
                        let assetSize = CGSize(width: 3, height: 4)
                        var cSize = CGSize(width: 0, height: 0)
                        if(assetSize.width > assetSize.height) {
                            //1 > landscape photo 4:3 w:h
                            let aRatio = CGSize(width: 4, height: 3) //aspect ratio
                            let cHeight = availableWidth * aRatio.height / aRatio.width + descHeight
                            cSize = CGSize(width: availableWidth, height: cHeight)
                        }
                        else if (assetSize.width < assetSize.height){
                            //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                            let aRatio = CGSize(width: 2, height: 3) //aspect ratio
                            let cWidth = availableWidth * 2 / 3
                            let cHeight = cWidth * aRatio.height / aRatio.width + descHeight
                            cSize = CGSize(width: cWidth, height: cHeight)
                        } else {
                            //square
                            let cWidth = availableWidth
                            cSize = CGSize(width: cWidth, height: cWidth + descHeight)
                        }
                        
                        let vTopMargin = 20.0
                        let vContentHeight = cSize.height //350
                        let vHeight = vTopMargin + vContentHeight
                        contentHeight += vHeight
                    }
                    else if(l == "q") {
                        //**test > fake data for quote post
                        var qDataArray = [String]()
                        qDataArray.append("t")
        //                qDataArray.append("p")
        //                qDataArray.append("p_s")
                        qDataArray.append("v")
    //                    qDataArray.append("v_l")
                        //**

                        let qLhsMargin = indentSize
                        let qRhsMargin = 20.0
                        let quoteWidth = self.frame.width - qLhsMargin - qRhsMargin
                        
                        for i in qDataArray {
                            if(i == "t") {
                                let tTopMargin = 20.0
                                let tContentHeight = estimateHeight(text: text, textWidth: quoteWidth - 20.0 - 20.0, fontSize: 14)
                                let tHeight = tTopMargin + tContentHeight
                                contentHeight += tHeight
                            }
                            else if(i == "p") {
                                let lhsMargin = 20.0
                                let rhsMargin = 20.0
                                let availableWidth = quoteWidth - lhsMargin - rhsMargin
                                
                                let assetSize = CGSize(width: 4, height: 3)//landscape
        //                        let assetSize = CGSize(width: 3, height: 4)
                                var cSize = CGSize(width: 0, height: 0)
                                if(assetSize.width > assetSize.height) {
                                    //1 > landscape photo 4:3 w:h
                                    let aRatio = CGSize(width: 4, height: 3) //aspect ratio
                                    let cHeight = availableWidth * aRatio.height / aRatio.width
                                    cSize = CGSize(width: availableWidth, height: cHeight)
                                }
                                else if (assetSize.width < assetSize.height){
                                    //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                                    let aRatio = CGSize(width: 2, height: 3) //aspect ratio
                                    let cWidth = availableWidth * 2 / 3
                //                    let cWidth = availableWidth //test full width for portrait
                                    let cHeight = cWidth * aRatio.height / aRatio.width
                                    cSize = CGSize(width: cWidth, height: cHeight)
                                } else {
                                    //square
                                    let cWidth = availableWidth
                                    cSize = CGSize(width: cWidth, height: cWidth)
                                }

                                let pTopMargin = 20.0
                //                let pContentHeight = 280.0
                                let pContentHeight = cSize.height
                                let pHeight = pTopMargin + pContentHeight
                                contentHeight += pHeight
                            }
                            else if(i == "p_s") {
                                let lhsMargin = 20.0
                                let rhsMargin = 20.0
                                let descHeight = 40.0
                                let availableWidth = quoteWidth - lhsMargin - rhsMargin
                                
                                let assetSize = CGSize(width: 4, height: 3)
                                var cSize = CGSize(width: 0, height: 0)
                                if(assetSize.width > assetSize.height) {
                                    //1 > landscape photo 4:3 w:h
                                    let aRatio = CGSize(width: 4, height: 3) //aspect ratio
                                    let cHeight = availableWidth * aRatio.height / aRatio.width + descHeight
                                    cSize = CGSize(width: availableWidth, height: cHeight)
                                }
                                else if (assetSize.width < assetSize.height){
                                    //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                                    let aRatio = CGSize(width: 2, height: 3) //aspect ratio
                                    let cWidth = availableWidth * 2 / 3
                                    let cHeight = cWidth * aRatio.height / aRatio.width + descHeight
                                    cSize = CGSize(width: cWidth, height: cHeight)
                                } else {
                                    //square
                                    let cWidth = availableWidth
                                    cSize = CGSize(width: cWidth, height: cWidth + descHeight)
                                }
                                
                                let pTopMargin = 20.0
                //                let pContentHeight = 280.0
                                let pContentHeight = cSize.height
                                let pHeight = pTopMargin + pContentHeight
                                contentHeight += pHeight
                            }
                            else if(i == "v") {
                                let lhsMargin = 20.0
                                let rhsMargin = 20.0
                                let availableWidth = quoteWidth - lhsMargin - rhsMargin
                                
                                let assetSize = CGSize(width: 3, height: 4)
                                var cSize = CGSize(width: 0, height: 0)
                                if(assetSize.width > assetSize.height) {
                                    //1 > landscape photo 4:3 w:h
                                    let aRatio = CGSize(width: 4, height: 3) //aspect ratio
                                    let cHeight = availableWidth * aRatio.height / aRatio.width
                                    cSize = CGSize(width: availableWidth, height: cHeight)
                                }
                                else if (assetSize.width < assetSize.height){
                                    //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                                    let aRatio = CGSize(width: 2, height: 3) //aspect ratio
                                    let cWidth = availableWidth * 2 / 3
                                    let cHeight = cWidth * aRatio.height / aRatio.width
                                    cSize = CGSize(width: cWidth, height: cHeight)
                                } else {
                                    //square
                                    let cWidth = availableWidth
                                    cSize = CGSize(width: cWidth, height: cWidth)
                                }
                                
                                let vTopMargin = 20.0
                //                let vContentHeight = 350.0 //250
                                let vContentHeight = cSize.height
                                let vHeight = vTopMargin + vContentHeight
                                contentHeight += vHeight
                            }
                            else if(i == "v_l") {
                                let lhsMargin = 20.0
                                let rhsMargin = 20.0
                                let descHeight = 40.0
                                let availableWidth = quoteWidth - lhsMargin - rhsMargin
                                
                                let assetSize = CGSize(width: 3, height: 4)
                                var cSize = CGSize(width: 0, height: 0)
                                if(assetSize.width > assetSize.height) {
                                    //1 > landscape photo 4:3 w:h
                                    let aRatio = CGSize(width: 4, height: 3) //aspect ratio
                                    let cHeight = availableWidth * aRatio.height / aRatio.width + descHeight
                                    cSize = CGSize(width: availableWidth, height: cHeight)
                                }
                                else if (assetSize.width < assetSize.height){
                                    //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                                    let aRatio = CGSize(width: 2, height: 3) //aspect ratio
                                    let cWidth = availableWidth * 2 / 3
                                    let cHeight = cWidth * aRatio.height / aRatio.width + descHeight
                                    cSize = CGSize(width: cWidth, height: cHeight)
                                } else {
                                    //square
                                    let cWidth = availableWidth
                                    cSize = CGSize(width: cWidth, height: cWidth + descHeight)
                                }
                                
                                let vTopMargin = 20.0
                //                let vContentHeight = 350.0 //250
                                let vContentHeight = cSize.height
                                let vHeight = vTopMargin + vContentHeight
                //                let vHeight = vTopMargin + vContentHeight + 40.0 //40.0 for bottom container for description
                                contentHeight += vHeight
                            }
                        }
                        let qTopMargin = 20.0
                        let qUserPhotoHeight = 28.0
                        let qUserPhotoTopMargin = 20.0 //10
        //                let qContentTopMargin = 10.0
        //                let qText = "Nice food, nice environment! Worth a visit. \nSo good!\n\n\n\n...\n...\n..."
        //                let qContentHeight = estimateHeight(text: qText, textWidth: collectionView.frame.width - 20.0 - 20.0, fontSize: 14)
                        let qFrameBottomMargin = 20.0 //10
                        let qHeight = qTopMargin + qUserPhotoHeight + qUserPhotoTopMargin + qFrameBottomMargin
                        contentHeight += qHeight
                    }
                }
            }
            else if(d == "na") {
                let npTopMargin = 20.0 //20
                let npTTopMargin = 10.0 //10
                let npTBottomMargin = 10.0
                let npText = "Post does not exist."
                let npContentHeight = estimateHeight(text: npText, textWidth: collectionView.frame.width - 20.0 - 20.0, fontSize: 13)
                let npHeight = npTTopMargin + npContentHeight + npTBottomMargin + npTopMargin
                contentHeight += npHeight
            }
            else if(d == "us") {
                let npTopMargin = 20.0 //20
                let npTTopMargin = 10.0 //10
                let npTBottomMargin = 10.0
                let npText = "Post violated community rules."
                let npContentHeight = estimateHeight(text: npText, textWidth: collectionView.frame.width - 20.0 - 20.0, fontSize: 13)
                let npHeight = npTTopMargin + npContentHeight + npTBottomMargin + npTopMargin
                contentHeight += npHeight
            }
            
            let userPhotoHeight = 28.0
            let userPhotoTopMargin = 10.0 //10
            let actionBtnTopMargin = 20.0
            let actionBtnHeight = 26.0
            let frameBottomMargin = 20.0 //10
            let miscHeight = userPhotoHeight + userPhotoTopMargin + actionBtnTopMargin + actionBtnHeight + frameBottomMargin
            let totalHeight = contentHeight + miscHeight
            
            return CGSize(width: collectionView.frame.width, height: totalHeight)
        }
    }
    
    //test > add footer
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        print("pdp footer reuse")
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
//            header.addSubview(headerView)
            return header
        case UICollectionView.elementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)
//            footer.addSubview(footerView)
            
            footerView.frame = CGRect(x: 0, y: 0, width: collectionView.frame.width, height: 100)
//            footerView.backgroundColor = .ddmDarkColor
//            footerView.backgroundColor = .blue
            footer.addSubview(footerView)
//            footerView.isHidden = true

            aaText.textAlignment = .left
            aaText.textColor = .white
            aaText.font = .systemFont(ofSize: 12)
            footerView.addSubview(aaText)
            aaText.clipsToBounds = true
            aaText.translatesAutoresizingMaskIntoConstraints = false
//            aaText.centerYAnchor.constraint(equalTo: footerView.centerYAnchor, constant: 0).isActive = true
            aaText.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 20).isActive = true
            aaText.centerXAnchor.constraint(equalTo: footerView.centerXAnchor, constant: 0).isActive = true
            aaText.layer.opacity = 0.5
            
            bSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
            footer.addSubview(bSpinner)
            bSpinner.translatesAutoresizingMaskIntoConstraints = false
//            bSpinner.centerYAnchor.constraint(equalTo: footer.centerYAnchor).isActive = true
            bSpinner.topAnchor.constraint(equalTo: footer.topAnchor, constant: 20).isActive = true
            bSpinner.centerXAnchor.constraint(equalTo: footer.centerXAnchor).isActive = true
            bSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
            bSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
//            bSpinner.isHidden = true
            
            //test > error handling
            errorText.textAlignment = .center //left
            errorText.textColor = .white
            errorText.font = .systemFont(ofSize: 13)
            footerView.addSubview(errorText)
            errorText.clipsToBounds = true
            errorText.translatesAutoresizingMaskIntoConstraints = false
//            errorText.centerYAnchor.constraint(equalTo: footerView.centerYAnchor, constant: 0).isActive = true
            errorText.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 20).isActive = true
            errorText.centerXAnchor.constraint(equalTo: footerView.centerXAnchor, constant: 0).isActive = true
            errorText.text = ""
            
            errorRefreshBtn.backgroundColor = .ddmDarkColor //test to remove color
            footerView.addSubview(errorRefreshBtn)
            errorRefreshBtn.translatesAutoresizingMaskIntoConstraints = false
            errorRefreshBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
            errorRefreshBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
            errorRefreshBtn.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
            errorRefreshBtn.topAnchor.constraint(equalTo: errorText.bottomAnchor, constant: 10).isActive = true
            errorRefreshBtn.layer.cornerRadius = 20
            errorRefreshBtn.isUserInteractionEnabled = true
            errorRefreshBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onErrorRefreshClicked)))
            errorRefreshBtn.isHidden = true
            
            let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_refresh")?.withRenderingMode(.alwaysTemplate))
    //        bMiniBtn.tintColor = .black
            bMiniBtn.tintColor = .white
            errorRefreshBtn.addSubview(bMiniBtn)
            bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
            bMiniBtn.centerXAnchor.constraint(equalTo: errorRefreshBtn.centerXAnchor).isActive = true
            bMiniBtn.centerYAnchor.constraint(equalTo: errorRefreshBtn.centerYAnchor).isActive = true
            bMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
            bMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
            
            configureFooterUI(data: footerState)
            
            return footer
        default:
            fatalError("Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        print("postpanel referencesize: \(section)")
        return CGSize(width: collectionView.bounds.size.width, height: 100)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == vcDataList.count - 1 {
            print("pdp willdisplay: \(indexPath.row)")

            //test 2 > added a check for dataFetchState == "end" to avoid fetch paginate when init()
            if(dataFetchState == "end") {
                if(dataPaginateStatus != "end") {
                    if(pageNumber >= 3) {
                        asyncPaginateFetchFeed(id: "comment_feed_end")
                    } else {
                        asyncPaginateFetchFeed(id: "comment_feed")
                    }
                }
            }
        }
        
        //test > for video autoplay when user opens
        if(!isFeedDisplayed) {
            if(indexPath.row == 0) {
                if let c = cell as? HPhotoListBViewCell {
                    asyncAutoplay(id: "search_term")
                }

                isFeedDisplayed = true
            }
        }
    }
}

extension PhotoDetailPanelView: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("p scrollview begin: \(scrollView.contentOffset.y)")
        let scrollOffsetY = scrollView.contentOffset.y
        scrollViewInitialY = scrollOffsetY
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("p scrollview scroll: \(scrollView.contentOffset.y)")

        let scrollOffsetY = scrollView.contentOffset.y
        let y = scrollViewInitialY - scrollOffsetY

        //test > change title to comments when scrolled to comment section
        if(scrollOffsetY < postHeight) {
            stickyCommentTitleAnimateHide()
        } else {
            stickyCommentTitleAnimateDisplay()
        }
        print("p scrollview scroll: \(isStickyCommentTitleDisplayed), \(scrollView.contentOffset.y)")
        
        //test > react to intersected index
//        reactToIntersectedAudio(intersectedIdx: getIntersectedIdx())
        
        //test 2 > try new intersect
        getIntersect2()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("p scrollview end: \(scrollView.contentOffset.y)")
        
        //test
        let scrollOffsetY = scrollView.contentOffset.y
        if(scrollOffsetY == 0) {
            isScrollViewAtTop = true
        } else {
            isScrollViewAtTop = false
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        let scrollOffsetY = scrollView.contentOffset.y
        
        //test > refresh dataset
        if(isScrollViewAtTop) {
            if(scrollOffsetY < -80) {

//                self.asyncFetchFeed(id: "comment_feed")
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

        print("p scrollview animation ended")
        
        //test > reset contentInset to origin of y = 0
        self.adjustContentInset(topInset: CGFloat(0), bottomInset: CGFloat(50))
    }
}

extension PhotoDetailPanelView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vcDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //test
        if(indexPath.item == 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HPhotoListBViewCell.identifier, for: indexPath) as! HPhotoListBViewCell
            cell.aDelegate = self
            
            //test > configure cell
            cell.configure(data: vcDataList[indexPath.row], width: self.frame.width)
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCommentListViewCell.identifier, for: indexPath) as! HCommentListViewCell
            
            cell.aDelegate = self
            
            //test > configure cell
            let data = vcDataList[indexPath.row]
            cell.configure(data: data)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

     }
}

extension PhotoDetailPanelView: HListCellDelegate {
    func hListDidClickVcvComment(vc: UICollectionViewCell) {
        print("PostDetailPanelView comment clicked")
   
        if let b = vc as? HPhotoListBViewCell {
            photoCV?.setContentOffset(CGPoint(x: 0.0, y: postHeight), animated: true)
        } else if let b1 = vc as? HCommentListViewCell {
            pausePlayingMedia()
            openComment()
        }
    }
    func hListDidClickVcvLove() {
        print("PostDetailPanelView love clicked")
    }
    func hListDidClickVcvShare(vc: UICollectionViewCell) {
        print("PostDetailPanelView share clicked")
  
        pausePlayingMedia()
        
        if let a = photoCV {
            for cell in a.visibleCells {
                
                if(cell == vc) {
                    let selectedIndexPath = a.indexPath(for: cell)
                    openShareSheet()
                    
                    if let c = selectedIndexPath {
                        selectedItemIdx = c.row
                    }
                    
                    break
                }
            }
        }
    }
    func hListDidClickVcvClickUser(){
        print("PostDetailPanelView user clicked")
        
        pausePlayingMedia()
        delegate?.didClickPhotoDetailPanelVcvClickUser()
    }
    func hListDidClickVcvClickPlace(){
//        delegate?.didClickPostPanelVcvClickPlace()
    }
    func hListDidClickVcvClickSound(){
//        delegate?.didClickPostPanelVcvClickSound()
    }
    func hListDidClickVcvClickPost() {
        print("PostDetailPanelView post clicked")

        pausePlayingMedia()
        delegate?.didClickPhotoDetailPanelVcvClickPost()
    }
    func hListDidClickVcvClickPhoto(vc: UICollectionViewCell, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
        
        pausePlayingMedia()
        
        if let a = photoCV {

            for cell in a.visibleCells {
                
                if(cell == vc) {
                    
                    let originInRootView = a.convert(cell.frame.origin, to: self)
                    let visibleIndexPath = a.indexPath(for: cell)
                    let pointX1 = originInRootView.x + pointX
                    let pointY1 = originInRootView.y + pointY
                    
                    //already converted cell origin to self, no need to add margin of scrollview
                    delegate?.didClickPhotoDetailPanelVcvClickPhoto(pointX: pointX1, pointY: pointY1, view: view, mode: mode)
                    
                    if let c = visibleIndexPath {
                        hideCellIndex = c.row
                    }
                    
                    break
                }
            }
        }
    }
    func hListDidClickVcvClickVideo(vc: UICollectionViewCell, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
        
    }
    
    func hListDidClickVcvSortComment(){
        
    }
    
    func hListIsScrollCarousel(isScroll: Bool) {
        isCarouselScrolled = isScroll
    }
    
    func hListCarouselIdx(vc: UICollectionViewCell, aIdx: Int, idx: Int) {
        if let a = photoCV {
            for cell in a.visibleCells {
                guard let indexPath = a.indexPath(for: cell) else {
                    continue
                }
                print("sfphoto idx: \(cell == vc), \(indexPath)")
                
                if(cell == vc) {
//                    vcDataList[indexPath.row].p_s = idx
                    
                    //test > new method
                    let data = vcDataList[indexPath.row]
                    let dataCL = data.contentDataArray
                    if(aIdx > -1 && aIdx < dataCL.count) {
                        dataCL[aIdx].p_s = idx
                    }
                    
                    break
                }
            }
        }
    }
    
    func hListVideoStopTime(vc: UICollectionViewCell, aIdx: Int, ts: Double){
        if let a = photoCV {
            for cell in a.visibleCells {
                guard let indexPath = a.indexPath(for: cell) else {
                    continue
                }
                
                if(cell == vc) {
//                    vDataList[indexPath.row].t_s = ts
                    
                    //test > new method
                    let data = vcDataList[indexPath.row]
                    let dataCL = data.contentDataArray
                    if(aIdx > -1 && aIdx < dataCL.count) {
                        dataCL[aIdx].t_s = ts
                    }

                    break
                }
            }
        }
    }
    
    func hListDidClickVcvPlayAudio(vc: UICollectionViewCell){
        
    }
    func hListDidClickVcvClickPlay(vc: UICollectionViewCell, isPlay: Bool){
        //test > try new method for manual play/stop video
        if let a = photoCV {
            for cell in a.visibleCells {
                guard let indexPath = a.indexPath(for: cell) else {
                    continue
                }
                
                if(cell == vc) {
                    if let s = cell as? HCommentListViewCell {
                        let mIdx = s.playingMediaAssetIdx
                        if(isPlay) {
                            pauseMediaAsset(cellAssetIdx: playingCellMediaAssetIdx) //test
                            
                            playingCellMediaAssetIdx = [indexPath.row, mIdx]
                        } else {
                            playingCellMediaAssetIdx = [-1, -1]
                        }
                    }
                    else if let c = cell as? HPhotoListBViewCell {
                        let mIdx = c.playingMediaAssetIdx
                        if(isPlay) {
                            pauseMediaAsset(cellAssetIdx: playingCellMediaAssetIdx) //test
                            
                            playingCellMediaAssetIdx = [indexPath.row, mIdx]
                        } else {
                            playingCellMediaAssetIdx = [-1, -1]
                        }
                    }
                    
                    break
                }
            }
        }
    }
}

extension PhotoDetailPanelView: ShareSheetScrollableDelegate{
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
                removeData(idxToRemove: selectedItemIdx)
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
                unselectItemData()
            }
        }
    }
}

extension PhotoDetailPanelView: CommentScrollableDelegate{
    func didCClickUser(){
        delegate?.didClickPhotoDetailPanelVcvClickUser()
    }
    func didCClickPlace(){

    }
    func didCClickSound(){

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
                resumePlayingMedia()
            }
        }
    }
    func didCClickComment(){

    }
    func didCClickShare(){
        openShareSheet()
    }
    func didCClickPost(){
        delegate?.didClickPhotoDetailPanelVcvClickPost()
    }
    func didCClickClickPhoto(pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
        delegate?.didClickPhotoDetailPanelVcvClickPhoto(pointX: pointX, pointY: pointY, view: view, mode: mode)
    }
    func didCClickClickVideo(pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
        
    }
}

extension PhotoDetailPanelView: ErrorUploadCommentMsgDelegate {
    func didEUCommentClickProceed() {
        asyncSendNewData()
    }
    func didEUCommentClickDeny(){
        //test
//        setFirstResponder(textView: aTextBox)
    }
}

//test > textview delegate for comment
extension PhotoDetailPanelView: UITextViewDelegate {
//    func textView(_ textView: UITextView, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let maxLength = 20
//        let currentString: NSString = (textView.text ?? "") as NSString
//        let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
//
//        return newString.length <= maxLength
//    }

    func textViewDidChange(_ textView: UITextView) {
        let minHeight = 36.0
        let maxHeight = 72.0
        
//        let size = CGSize(width: self.frame.width, height: .infinity)
        let emojiBtnWidth = 40.0
        let textboxMargin = 10.0
        var maxUsableTextWidth = aaView.frame.size.width - textboxMargin * 2
        var minUsableTextWidth = aaView.frame.size.width - emojiBtnWidth * 3 - textboxMargin * 2
        let size = CGSize(width: minUsableTextWidth, height: 1000)
        let estimatedSize = textView.sizeThatFits(size)
        
        let intrinsicSize = CGSize(width: maxUsableTextWidth, height: 1000)
        let estimatedIntrinsicSize = textView.sizeThatFits(intrinsicSize)
        
        //tets 2 > check length of textview text
        let currentString: NSString = (textView.text ?? "") as NSString
        print("textviewdelegate: \(currentString.length), \(estimatedSize), \(aaView.frame.size.width)")

        if(currentString.length > 0) {
            aaViewTrailingCons?.isActive = false
            aaViewTrailingCons = aaView.trailingAnchor.constraint(equalTo: sendBox.leadingAnchor, constant: -10)
            aaViewTrailingCons?.isActive = true

            bbText.isHidden = true
            
            //test 2 > check width and height
            let estimatedWidth = estimatedIntrinsicSize.width
            if(estimatedWidth < minUsableTextWidth) {
                let estimatedHeight = estimatedSize.height
                if(estimatedHeight < minHeight) {
                    aTextTrailingCons?.isActive = false
                    aTextTrailingCons = aTextBox.trailingAnchor.constraint(equalTo: xGrid.leadingAnchor, constant: 0)
                    aTextTrailingCons?.isActive = true
    
                    aTextBottomCons?.isActive = false
                    aTextBottomCons = aTextBox.bottomAnchor.constraint(equalTo: aaView.bottomAnchor, constant: 0)
                    aTextBottomCons?.isActive = true
    
                    aTextBoxHeightCons?.constant = minHeight
                } else {
                    aTextTrailingCons?.isActive = false
                    aTextTrailingCons = aTextBox.trailingAnchor.constraint(equalTo: aaView.trailingAnchor, constant: -10)
                    aTextTrailingCons?.isActive = true
    
                    aTextBottomCons?.isActive = false
                    aTextBottomCons = aTextBox.bottomAnchor.constraint(equalTo: xGrid.topAnchor, constant: 0)
                    aTextBottomCons?.isActive = true
    
                    if(estimatedHeight >= maxHeight) {
                        aTextBoxHeightCons?.constant = maxHeight
                    } else {
                        aTextBoxHeightCons?.constant = estimatedHeight
                    }
                }
            }
            else {
                let estimatedHeight = estimatedIntrinsicSize.height
                
                //make multiline when width exceed min width
                aTextTrailingCons?.isActive = false
                aTextTrailingCons = aTextBox.trailingAnchor.constraint(equalTo: aaView.trailingAnchor, constant: -10)
                aTextTrailingCons?.isActive = true
    
                aTextBottomCons?.isActive = false
                aTextBottomCons = aTextBox.bottomAnchor.constraint(equalTo: xGrid.topAnchor, constant: 0)
                aTextBottomCons?.isActive = true
                
                if(estimatedHeight >= maxHeight) {
                    aTextBoxHeightCons?.constant = maxHeight
                } else if(estimatedHeight < minHeight) {
                    aTextBoxHeightCons?.constant = minHeight
                } else {
                    aTextBoxHeightCons?.constant = estimatedHeight
                }
            }
        } else {
            aaViewTrailingCons?.isActive = false
            aaViewTrailingCons = aaView.trailingAnchor.constraint(equalTo: textPanel.trailingAnchor, constant: -15)
            aaViewTrailingCons?.isActive = true

            aTextTrailingCons?.isActive = false
            aTextTrailingCons = aTextBox.trailingAnchor.constraint(equalTo: xGrid.leadingAnchor, constant: 0)
            aTextTrailingCons?.isActive = true

            aTextBottomCons?.isActive = false
            aTextBottomCons = aTextBox.bottomAnchor.constraint(equalTo: aaView.bottomAnchor, constant: 0)
            aTextBottomCons?.isActive = true

            aTextBoxHeightCons?.constant = minHeight
            
            bbText.isHidden = false
        }
    }
}

extension ViewController: PhotoDetailPanelDelegate{
    func didClickPhotoDetailPanelVcvClickPost() {
        openPostDetailPanel()
    }
    func didClickPhotoDetailPanelVcvClickUser() {
        openUserPanel()
    }
    func didClickPhotoDetailClosePanel() {
        backPage(isCurrentPageScrollable: false)
    }
    func didClickPhotoDetailPanelVcvClickPhoto(pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String){
        let offsetX = pointX - self.view.frame.width/2 + view.frame.width/2
        let offsetY = pointY - self.view.frame.height/2 + view.frame.height/2

        if(mode == PhotoTypes.P_SHOT_DETAIL) {
            openPhotoDetailPanel()
        } else if(mode == PhotoTypes.P_0){
            openPhotoZoomPanel(offX: offsetX, offY: offsetY)
        }
    }
}
