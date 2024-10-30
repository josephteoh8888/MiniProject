//
//  VideoPreviewPanelView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage
import AVFoundation

protocol VideoPreviewPanelDelegate : AnyObject {
    func didClickCloseVideoPreviewPanel()
}

class VideoPreviewPanelView: PanelView{
    
    var panel = UIView()
    let vPreviewContainer = UIView()
    var vPreviewPlayer: AVPlayer!
    private let fileManager = FileManager.default
    private lazy var mainDirectoryUrl: URL = {
        let documentsUrl = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            return documentsUrl
        //.cachesDirectory is only for short term storage
    }()
    let sBox = UIView()
    let sText = UILabel()
    
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    var panelLeadingCons: NSLayoutConstraint?
    var currentPanelLeadingCons : CGFloat = 0.0
    weak var delegate : VideoPreviewPanelDelegate?
    
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
        panel.backgroundColor = .ddmBlackOverlayColor
        self.addSubview(panel)
        panel.translatesAutoresizingMaskIntoConstraints = false
//        panel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        panel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        panel.layer.masksToBounds = true
        panel.layer.cornerRadius = 10 //10
        panel.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        panel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        panel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //default 0
        panelLeadingCons = panel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
        panelLeadingCons?.isActive = true
        
        panel.addSubview(vPreviewContainer)
        vPreviewContainer.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight - 94)
        vPreviewContainer.translatesAutoresizingMaskIntoConstraints = false
        vPreviewContainer.topAnchor.constraint(equalTo: panel.topAnchor, constant: 0).isActive = true
        vPreviewContainer.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -94).isActive = true
        vPreviewContainer.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 0).isActive = true
        vPreviewContainer.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: 0).isActive = true
        vPreviewContainer.clipsToBounds = true
        vPreviewContainer.layer.cornerRadius = 10
        vPreviewContainer.backgroundColor = .black
        
        let pBtn = UIView()
//        aBtn.backgroundColor = .ddmDarkColor
        panel.addSubview(pBtn)
        pBtn.translatesAutoresizingMaskIntoConstraints = false
        pBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
        pBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        pBtn.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 10).isActive = true
//        pBtn.topAnchor.constraint(equalTo: panel.topAnchor, constant: 50).isActive = true
        pBtn.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        pBtn.layer.cornerRadius = 20
//        pBtn.layer.opacity = 0.3
        pBtn.isUserInteractionEnabled = true
        pBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackVideoPreviewPanelClicked)))
        
        let pMiniBtn = UIImageView(image: UIImage(named:"icon_round_arrow_left")?.withRenderingMode(.alwaysTemplate))
        pMiniBtn.tintColor = .white
//        aStickyHeader.addSubview(bMiniBtn)
        panel.addSubview(pMiniBtn)
        pMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        pMiniBtn.centerXAnchor.constraint(equalTo: pBtn.centerXAnchor).isActive = true
        pMiniBtn.centerYAnchor.constraint(equalTo: pBtn.centerYAnchor).isActive = true
        pMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        pMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        
        let vStack1 = UIView()
        let vStack2 = UIView()
        
        let vBackBtn = UIView()
        vBackBtn.backgroundColor = .ddmDarkColor
//        panel.addSubview(aSaveDraft)
        vStack1.addSubview(vBackBtn)
        vBackBtn.translatesAutoresizingMaskIntoConstraints = false
        vBackBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        vBackBtn.leadingAnchor.constraint(equalTo: vStack1.leadingAnchor, constant: 0).isActive = true
        vBackBtn.trailingAnchor.constraint(equalTo: vStack1.trailingAnchor, constant: -10).isActive = true
        vBackBtn.centerYAnchor.constraint(equalTo: vStack1.centerYAnchor).isActive = true
        vBackBtn.layer.cornerRadius = 10
        vBackBtn.isUserInteractionEnabled = true
        vBackBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackVideoPreviewPanelClicked)))
        
        let vBackText = UILabel()
        vBackText.textAlignment = .center
        vBackText.textColor = .white
        vBackText.font = .boldSystemFont(ofSize: 13)
//        panel.addSubview(aUploadText)
        vBackBtn.addSubview(vBackText)
        vBackText.translatesAutoresizingMaskIntoConstraints = false
        vBackText.centerXAnchor.constraint(equalTo: vBackBtn.centerXAnchor).isActive = true
        vBackText.centerYAnchor.constraint(equalTo: vBackBtn.centerYAnchor).isActive = true
        vBackText.text = "Back"
        
        let vEditVid = UIView()
        vEditVid.backgroundColor = .ddmDarkColor
//        panel.addSubview(aUpload)
        vStack2.addSubview(vEditVid)
        vEditVid.translatesAutoresizingMaskIntoConstraints = false
        vEditVid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        vEditVid.leadingAnchor.constraint(equalTo: vStack2.leadingAnchor, constant: 10).isActive = true
        vEditVid.trailingAnchor.constraint(equalTo: vStack2.trailingAnchor, constant: 0).isActive = true
        vEditVid.centerYAnchor.constraint(equalTo: vStack2.centerYAnchor).isActive = true
        vEditVid.layer.cornerRadius = 10
        
        let vEditText = UILabel()
        vEditText.textAlignment = .center
        vEditText.textColor = .white
        vEditText.font = .boldSystemFont(ofSize: 13)
//        panel.addSubview(aUploadText)
        vEditVid.addSubview(vEditText)
        vEditText.translatesAutoresizingMaskIntoConstraints = false
        vEditText.centerXAnchor.constraint(equalTo: vEditVid.centerXAnchor).isActive = true
        vEditText.centerYAnchor.constraint(equalTo: vEditVid.centerYAnchor).isActive = true
        vEditText.text = "Edit Video"
        
        let vStackView = UIStackView(arrangedSubviews: [vStack1, vStack2])
        vStackView.distribution = .fillEqually
        panel.addSubview(vStackView)
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        vStackView.topAnchor.constraint(equalTo: vPreviewContainer.bottomAnchor, constant: 10).isActive = true
        vStackView.heightAnchor.constraint(equalToConstant: 40).isActive = true //ori 60
        vStackView.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 20).isActive = true
        vStackView.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20).isActive = true
        
        //test > final video symbols positions
        let mBtn = UIImageView(image: UIImage(named:"icon_round_music")?.withRenderingMode(.alwaysTemplate))
//        mBtn.tintColor = .black
        mBtn.tintColor = .white
        panel.addSubview(mBtn)
        mBtn.translatesAutoresizingMaskIntoConstraints = false
        mBtn.leadingAnchor.constraint(equalTo: vPreviewContainer.leadingAnchor, constant: 10).isActive = true
//        mBtn.bottomAnchor.constraint(equalTo: videoPanel.bottomAnchor, constant: -30).isActive = true
        mBtn.bottomAnchor.constraint(equalTo: vPreviewContainer.bottomAnchor, constant: -30).isActive = true
        mBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        mBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        mBtn.layer.shadowColor = UIColor.gray.cgColor
        mBtn.layer.shadowRadius = 1.0  //ori 3
        mBtn.layer.shadowOpacity = 0.5 //ori 1
        mBtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        mBtn.layer.opacity = 0.6
        
        let mText = UILabel()
        mText.textAlignment = .left
        mText.textColor = .white
        mText.font = .boldSystemFont(ofSize: 13)
        panel.addSubview(mText)
        mText.translatesAutoresizingMaskIntoConstraints = false
        mText.centerYAnchor.constraint(equalTo: mBtn.centerYAnchor).isActive = true
        mText.leadingAnchor.constraint(equalTo: mBtn.trailingAnchor, constant: 10).isActive = true
        mText.text = "Original Sound - @Michelle8899"
        mText.layer.opacity = 0.6
        mText.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        
        let aTitleText = UILabel()
        aTitleText.textAlignment = .left
        aTitleText.textColor = .white
        aTitleText.font = .systemFont(ofSize: 14)
        panel.addSubview(aTitleText)
        aTitleText.translatesAutoresizingMaskIntoConstraints = false
//        aTitleText.bottomAnchor.constraint(equalTo: videoPanel.bottomAnchor, constant: -30).isActive = true
        aTitleText.bottomAnchor.constraint(equalTo: mText.topAnchor, constant: -10).isActive = true
        aTitleText.leadingAnchor.constraint(equalTo: vPreviewContainer.leadingAnchor, constant: 15).isActive = true
        aTitleText.text = "caption"
        aTitleText.layer.opacity = 0.6
        aTitleText.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        aTitleText.numberOfLines = 2
        
        let aNameText = UILabel()
        aNameText.textAlignment = .left
        aNameText.textColor = .white
        aNameText.font = .boldSystemFont(ofSize: 15)
        panel.addSubview(aNameText)
        aNameText.translatesAutoresizingMaskIntoConstraints = false
        aNameText.bottomAnchor.constraint(equalTo: aTitleText.topAnchor, constant: -5).isActive = true
        aNameText.leadingAnchor.constraint(equalTo: vPreviewContainer.leadingAnchor, constant: 15).isActive = true
        aNameText.text = "@Michelle8899"
        aNameText.layer.opacity = 0.6
        aNameText.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        
        let aBox = UIView()
        aBox.backgroundColor = .ddmBlackOverlayColor
        panel.addSubview(aBox)
        aBox.clipsToBounds = true
        aBox.translatesAutoresizingMaskIntoConstraints = false
        aBox.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 15).isActive = true
//        aBox.heightAnchor.constraint(equalToConstant: 35).isActive = true //default: 50
        aBox.bottomAnchor.constraint(equalTo: aNameText.topAnchor, constant: -10).isActive = true
        aBox.layer.cornerRadius = 10
        aBox.layer.opacity = 0.3
        aBox.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        
        //test > white location btn => simpler version
        let bBox = UIView()
        panel.addSubview(bBox)
        bBox.clipsToBounds = true
        bBox.translatesAutoresizingMaskIntoConstraints = false
        bBox.widthAnchor.constraint(equalToConstant: 18).isActive = true //20
        bBox.heightAnchor.constraint(equalToConstant: 18).isActive = true
//        bBox.centerYAnchor.constraint(equalTo: aBox.centerYAnchor).isActive = true
        bBox.topAnchor.constraint(equalTo: aBox.topAnchor, constant: 4).isActive = true
        bBox.leadingAnchor.constraint(equalTo: aBox.leadingAnchor, constant: 6).isActive = true //10
        bBox.layer.cornerRadius = 5 //6

        let gridViewBtn = UIImageView(image: UIImage(named:"icon_location")?.withRenderingMode(.alwaysTemplate))
        gridViewBtn.tintColor = .white
        bBox.addSubview(gridViewBtn)
        gridViewBtn.translatesAutoresizingMaskIntoConstraints = false
        gridViewBtn.centerXAnchor.constraint(equalTo: bBox.centerXAnchor).isActive = true
        gridViewBtn.centerYAnchor.constraint(equalTo: bBox.centerYAnchor).isActive = true
        gridViewBtn.heightAnchor.constraint(equalToConstant: 18).isActive = true//16
        gridViewBtn.widthAnchor.constraint(equalToConstant: 18).isActive = true
        gridViewBtn.layer.opacity = 0.6
        
        let aText = UILabel()
        aText.textAlignment = .left
        aText.textColor = .white
        aText.font = .boldSystemFont(ofSize: 13)
        panel.addSubview(aText)
        aText.clipsToBounds = true
        aText.translatesAutoresizingMaskIntoConstraints = false
        aText.topAnchor.constraint(equalTo: aBox.topAnchor, constant: 5).isActive = true
        aText.bottomAnchor.constraint(equalTo: aBox.bottomAnchor, constant: -5).isActive = true
        aText.leadingAnchor.constraint(equalTo: bBox.trailingAnchor, constant: 5).isActive = true //10
//        aText.leadingAnchor.constraint(equalTo: gridViewBtn.trailingAnchor, constant: 10).isActive = true //10
        aText.trailingAnchor.constraint(equalTo: aBox.trailingAnchor, constant: -10).isActive = true
        aText.text = "Location"
        aText.layer.opacity = 0.6
        aText.numberOfLines = 2
        
        let mMini = UIView()
        mMini.backgroundColor = .ddmBlackOverlayColor
        panel.addSubview(mMini)
        mMini.translatesAutoresizingMaskIntoConstraints = false
        mMini.bottomAnchor.constraint(equalTo: vPreviewContainer.bottomAnchor, constant: -30).isActive = true
        mMini.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -15).isActive = true
        mMini.heightAnchor.constraint(equalToConstant: 44).isActive = true //default 40
        mMini.widthAnchor.constraint(equalToConstant: 44).isActive = true
        mMini.layer.cornerRadius = 22
        mMini.layer.opacity = 0.6
        
        let mImageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
        let mImage = SDAnimatedImageView()
        mImage.contentMode = .scaleAspectFill
        mImage.layer.masksToBounds = true
        mImage.sd_setImage(with: mImageUrl)
        panel.addSubview(mImage)
        mImage.translatesAutoresizingMaskIntoConstraints = false
        mImage.centerXAnchor.constraint(equalTo: mMini.centerXAnchor).isActive = true
        mImage.centerYAnchor.constraint(equalTo: mMini.centerYAnchor).isActive = true
        mImage.heightAnchor.constraint(equalToConstant: 26).isActive = true
        mImage.widthAnchor.constraint(equalToConstant: 26).isActive = true
        mImage.layer.cornerRadius = 13
        mImage.layer.opacity = 0.6
        
        let bMini = UIView()
        bMini.backgroundColor = .ddmBlackOverlayColor
        panel.addSubview(bMini)
        bMini.translatesAutoresizingMaskIntoConstraints = false
        bMini.bottomAnchor.constraint(equalTo: mMini.topAnchor, constant: -30).isActive = true
        bMini.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -15).isActive = true
        bMini.heightAnchor.constraint(equalToConstant: 40).isActive = true
        bMini.widthAnchor.constraint(equalToConstant: 40).isActive = true
        bMini.layer.cornerRadius = 20
        bMini.layer.opacity = 0.3
        
        let bMini2Btn = UIImageView(image: UIImage(named:"icon_round_share")?.withRenderingMode(.alwaysTemplate).withHorizontallyFlippedOrientation())
        bMini2Btn.tintColor = .white
        panel.addSubview(bMini2Btn)
        bMini2Btn.translatesAutoresizingMaskIntoConstraints = false
        bMini2Btn.centerXAnchor.constraint(equalTo: bMini.centerXAnchor).isActive = true
        bMini2Btn.centerYAnchor.constraint(equalTo: bMini.centerYAnchor, constant: -2).isActive = true
        bMini2Btn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        bMini2Btn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        bMini2Btn.layer.opacity = 0.6
        
        let cMini = UIView()
        cMini.backgroundColor = .ddmBlackOverlayColor
        panel.addSubview(cMini)
        cMini.translatesAutoresizingMaskIntoConstraints = false
        cMini.bottomAnchor.constraint(equalTo: bMini.topAnchor, constant: -30).isActive = true
        cMini.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -15).isActive = true
        cMini.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cMini.widthAnchor.constraint(equalToConstant: 40).isActive = true
        cMini.layer.cornerRadius = 20
        cMini.layer.opacity = 0.3
        
        let cMiniBtn = UIImageView(image: UIImage(named:"icon_comment")?.withRenderingMode(.alwaysTemplate))
        cMiniBtn.tintColor = .white
        panel.addSubview(cMiniBtn)
        cMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        cMiniBtn.centerXAnchor.constraint(equalTo: cMini.centerXAnchor).isActive = true
        cMiniBtn.centerYAnchor.constraint(equalTo: cMini.centerYAnchor).isActive = true
        cMiniBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true
        cMiniBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
        cMiniBtn.layer.opacity = 0.6
        
        let dMini = UIView()
        dMini.backgroundColor = .ddmBlackOverlayColor
        panel.addSubview(dMini)
        dMini.translatesAutoresizingMaskIntoConstraints = false
        dMini.bottomAnchor.constraint(equalTo: cMini.topAnchor, constant: -30).isActive = true
        dMini.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -15).isActive = true
        dMini.heightAnchor.constraint(equalToConstant: 40).isActive = true
        dMini.widthAnchor.constraint(equalToConstant: 40).isActive = true
        dMini.layer.cornerRadius = 20
        dMini.layer.opacity = 0.3
        
        let dMiniBtn = UIImageView(image: UIImage(named:"icon_love")?.withRenderingMode(.alwaysTemplate))
        dMiniBtn.tintColor = .white
        panel.addSubview(dMiniBtn)
        dMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        dMiniBtn.centerXAnchor.constraint(equalTo: dMini.centerXAnchor).isActive = true
        dMiniBtn.centerYAnchor.constraint(equalTo: dMini.centerYAnchor).isActive = true
        dMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        dMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        dMiniBtn.layer.opacity = 0.6
        
        let eMini = UIView()
        eMini.backgroundColor = .white
        panel.addSubview(eMini)
        eMini.translatesAutoresizingMaskIntoConstraints = false
        eMini.bottomAnchor.constraint(equalTo: dMini.topAnchor, constant: -30).isActive = true
        eMini.centerXAnchor.constraint(equalTo: dMini.centerXAnchor).isActive = true
        eMini.heightAnchor.constraint(equalToConstant: 44).isActive = true
        eMini.widthAnchor.constraint(equalToConstant: 44).isActive = true
        eMini.layer.cornerRadius = 22
        eMini.layer.opacity = 0.6

        let eImageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
        let eImage = SDAnimatedImageView()
        eImage.contentMode = .scaleAspectFill
        eImage.layer.masksToBounds = true
        eImage.sd_setImage(with: eImageUrl)
        panel.addSubview(eImage)
        eImage.translatesAutoresizingMaskIntoConstraints = false
        eImage.centerXAnchor.constraint(equalTo: eMini.centerXAnchor).isActive = true
        eImage.centerYAnchor.constraint(equalTo: eMini.centerYAnchor).isActive = true
        eImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        eImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        eImage.layer.cornerRadius = 20
        eImage.layer.opacity = 0.6
        
        //test dynamic caption/subtitle
//        let sBox = UIView()
        sBox.backgroundColor = .ddmBlackOverlayColor
//        sBox.backgroundColor = .yellow
//        contentView.addSubview(sBox)
        panel.addSubview(sBox)
        sBox.clipsToBounds = true
        sBox.translatesAutoresizingMaskIntoConstraints = false
        sBox.leadingAnchor.constraint(equalTo: vPreviewContainer.leadingAnchor, constant: 15).isActive = true
//        sBox.heightAnchor.constraint(equalToConstant: 35).isActive = true //default: 50
//        sBox.widthAnchor.constraint(equalToConstant: 35).isActive = true //default: 50
        sBox.bottomAnchor.constraint(equalTo: aBox.topAnchor, constant: -10).isActive = true
        sBox.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        sBox.layer.cornerRadius = 10
        sBox.layer.opacity = 0.3
        sBox.isHidden = true

//        let sText = UILabel()
        sText.textAlignment = .left
        sText.textColor = .white
//        sText.textColor = .ddmBlackOverlayColor
        sText.font = .boldSystemFont(ofSize: 14) //15
//        contentView.addSubview(sText)
        panel.addSubview(sText)
        sText.clipsToBounds = true
        sText.translatesAutoresizingMaskIntoConstraints = false
        sText.topAnchor.constraint(equalTo: sBox.topAnchor, constant: 10).isActive = true //5
        sText.bottomAnchor.constraint(equalTo: sBox.bottomAnchor, constant: -10).isActive = true //-5
        sText.leadingAnchor.constraint(equalTo: sBox.leadingAnchor, constant: 10).isActive = true
        sText.trailingAnchor.constraint(equalTo: sBox.trailingAnchor, constant: -10).isActive = true
        sText.text = ""
        sText.layer.opacity = 0.6
        //**
        
        //test > video progress bar
        let progress = UIView()
        panel.addSubview(progress)
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.leadingAnchor.constraint(equalTo: vPreviewContainer.leadingAnchor, constant: 15).isActive = true
        progress.bottomAnchor.constraint(equalTo: vPreviewContainer.bottomAnchor, constant: 0).isActive = true
        progressWidthCons = progress.widthAnchor.constraint(equalToConstant: 0)
        progressWidthCons?.isActive = true
        progress.heightAnchor.constraint(equalToConstant: 4).isActive = true
        progress.layer.cornerRadius = 2
        progress.backgroundColor = .white
        progress.layer.opacity = 0.8
        
        //test > gesture recognizer for dragging panel
        let panelPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onVPreviewPanelPanGesture))
        self.addGestureRecognizer(panelPanGesture)
    }
    var progressWidthCons: NSLayoutConstraint?
    override func layoutSubviews() {
        super.layoutSubviews()
//        print("videopreview layoutsubview: \(vPreviewContainer.bounds)")
//
//        //test > initialize video editor
        if(!isInitialized) {
            playVideoPreview()
            isInitialized = true
        }
    }
    
    @objc func onBackVideoPreviewPanelClicked(gesture: UITapGestureRecognizer) {
        
        closePanel(isAnimated: true)
    }
    
    var direction = "na"
    @objc func onVPreviewPanelPanGesture(gesture: UIPanGestureRecognizer) {
        if(gesture.state == .began) {
            
            print("t1 onVPreviewPanelPanGesture begin: ")
            self.currentPanelLeadingCons = self.panelLeadingCons!.constant
        } else if(gesture.state == .changed) {
            let translation = gesture.translation(in: self)
            let x = translation.x
            let y = translation.y
            
            //test > determine direction of scroll
//            print("t1 onVPreviewPanelPanGesture changed: \(x), \(self.soundPanelLeadingCons!.constant)")
            if(direction == "na") {
                if(abs(x) > abs(y)) {
                    direction = "x"
                } else {
                    direction = "y"
                }
            }
            if(direction == "x") {
                var newX = self.currentPanelLeadingCons + x
                if(newX < 0) {
                    newX = 0
                }
                self.panelLeadingCons?.constant = newX
            }
        } else if(gesture.state == .ended){
            
            print("t1 onVPreviewPanelPanGesture ended: ")
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
    
    //test > initialization state
    var isInitialized = false
    func initialize() {
        
    }
    
    func closePanel(isAnimated: Bool) {
        if(isAnimated) {
            UIView.animate(withDuration: 0.2, animations: {
                self.panelLeadingCons?.constant = self.frame.width
                self.layoutIfNeeded()
            }, completion: { _ in
                self.removeFromSuperview()
                
                self.removeTimeObserver()
                
                //move back to origin
                self.panelLeadingCons?.constant = 0
                self.delegate?.didClickCloseVideoPreviewPanel()
            })
        } else {
            self.removeFromSuperview()
            
            self.removeTimeObserver()
            
            self.delegate?.didClickCloseVideoPreviewPanel()
        }
    }
    
    func removeTimeObserver() {
        //remove video observer
        if let tokenV = timeObserverToken {
            vPreviewPlayer?.removeTimeObserver(tokenV)
            timeObserverToken = nil
        }
    }
    
    //test > video preview
    var playerLooper: AVPlayerLooper!
    var queuePlayer: AVQueuePlayer!
    func playVideoPreview() {
//        let asset2 = AVAsset(url: getVideoOutputURL())
//        let item2 = AVPlayerItem(asset: asset2)
//        vPreviewPlayer = AVPlayer(playerItem: item2)
//        let layer2 = AVPlayerLayer(player: vPreviewPlayer)
//        layer2.frame = vPreviewContainer.bounds
////        layer2.frame = CGRect(x: 0 , y: 0, width: viewWidth, height: viewHeight - 94)
//        layer2.videoGravity = .resizeAspectFill
//        vPreviewContainer.layer.addSublayer(layer2)
//        vPreviewPlayer?.seek(to: .zero)
        
        self.queuePlayer = AVQueuePlayer()
        let playerView = AVPlayerLayer(player: queuePlayer)
        let playerItem = AVPlayerItem(url: getVideoOutputURL())
        playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
        playerView.frame = vPreviewContainer.bounds
        playerView.videoGravity = .resizeAspectFill
        vPreviewContainer.layer.addSublayer(playerView)
        videoDuration = getDuration(ofVideoAt: getVideoOutputURL())
        
        addTimeObserver()
        
//        vPreviewPlayer?.play()
        queuePlayer?.play()
    }
    func getVideoOutputURL() -> URL {
        let documentsURL = mainDirectoryUrl.appendingPathComponent(VideoCreatorFileTypes.DRAFT_VIDEO_FILES_FOLDER_NAME)
        let url = documentsURL.appendingPathComponent(VideoCreatorFileTypes.DRAFT_VIDEO_FILE_OUTPUT_NAME)
        return url
    }
    func getDuration(ofVideoAt videoURL: URL) -> Double {
        let asset = AVURLAsset(url: videoURL)
        let duration = asset.duration
        let durationInSeconds = CMTimeGetSeconds(duration)
        
        if durationInSeconds.isNaN {
            return 0.0
        } else {
            return durationInSeconds
        }
    }
    //***test > add time observer for progresslistener
    var timeObserverToken: Any?
    var videoDuration = 0.0
    func addTimeObserver() {
        //test > time observer
        let timeInterval = CMTime(seconds: 0.02, preferredTimescale: CMTimeScale(1000)) //0.01 sec intervalc
        timeObserverToken = queuePlayer.addPeriodicTimeObserver(forInterval: timeInterval, queue: DispatchQueue.main) {[weak self] time in
//        timeObserverToken = vPreviewPlayer.addPeriodicTimeObserver(forInterval: timeInterval, queue: DispatchQueue.main) {[weak self] time in
                
            let currentTime = time.seconds
            print("Current time: \(currentTime)")
            
            guard let s = self else {
                return
            }
            
            let x = CGFloat((currentTime) / (s.videoDuration)) * (s.viewWidth - 30.0)
            s.progressWidthCons?.constant = x
                
            // Update UI with current time
            if(currentTime < 0.0) {
                self?.sText.text = ""
            } else if(currentTime < 1.0) {
//                self?.sText.text = "LOL....Hahaha✅"
                self?.sText.text = "馬克宏稱挺台海"
            } else if(currentTime < 2.0) {
//                self?.sText.text = "😈😈Oopss!!! OMG we gotta GO!!"
                self?.sText.text = "被爆料阻援烏"
            } else if(currentTime < 3.0) {
//                self?.sText.text = "Bye for now Cya🤖"
//                self?.sText.text = "｜宋國誠｜桑普｜"
                self?.sText.text = ""
            } else if(currentTime < 4.0) {
//                self?.sText.text = "LOL✌️....Hahaha"
                self?.sText.text = "總統沒什麼好道歉的"
            } else if(currentTime < 5.0) {
//                self?.sText.text = "🤡Oopss!!! OMG we gotta GO!!"
                self?.sText.text = "質疑馬克宏阻擋歐盟援助20億!!"
            } else if(currentTime < 6.0) {
//                self?.sText.text = "😻Bye for now Cya"
//                self?.sText.text = "另外印度有媒體12日爆料"
                self?.sText.text = ""
            } else if(currentTime < 7.0) {
//                self?.sText.text = "LOL..👻..Hahaha"
                self?.sText.text = "百萬發砲彈給烏克蘭的進度"
            } else {
//                self?.sText.text = "💩"
                self?.sText.text = "#馬克宏 #范德賴恩 #新聞大破解"
            }
            
            if(self?.sText.text == "") {
                self?.sBox.isHidden = true
            } else {
                self?.sBox.isHidden = false
            }
        }
    }
}

extension VideoFinalizePanelView: VideoPreviewPanelDelegate{
    func didClickCloseVideoPreviewPanel() {

    }
}
