//
//  VideoFinalizePanelView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage
import AVFoundation

protocol VideoFinalizePanelDelegate : AnyObject {
    func didInitializeVideoFinalize()
    func didClickFinishVideoFinalize()
    func didVideoFinalizeClickUpload(payload: String)
    //test
    func didVideoFinalizeClickLocationSelectScrollable()
}
class VideoFinalizePanelView: PanelView{
    var panel = UIView()
    var currentPanelTopCons : CGFloat = 0.0
    var panelTopCons: NSLayoutConstraint?
    
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    weak var delegate : VideoFinalizePanelDelegate?
    
    let bTextView = UITextView()
    let pText = UILabel()
    let aBoxUnder = UIView()
    
    let aUpload = UIView()
    let aSpinner = SpinLoader()
    
    let aText = UILabel()
    
    var maxSelectLimit = 5
    let maxLimitErrorPanel = UIView()
    let maxLimitText = UILabel()
    let pMiniError = UIView()
    let lMiniError = UIView()

    private let fileManager = FileManager.default
    private lazy var mainDirectoryUrl: URL = {
        let documentsUrl = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            return documentsUrl
        //.cachesDirectory is only for short term storage
    }()
    
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
        panel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        panel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        panel.layer.masksToBounds = true
        panel.layer.cornerRadius = 10 //10
        panel.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        panel.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        panelTopCons = panel.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -viewHeight)
        panelTopCons?.isActive = true

        let aBtn = UIView()
//        aBtn.backgroundColor = .ddmDarkColor
        panel.addSubview(aBtn)
        aBtn.translatesAutoresizingMaskIntoConstraints = false
        aBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
        aBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        aBtn.leadingAnchor.constraint(equalTo: aStickyHeader.leadingAnchor, constant: 10).isActive = true
        aBtn.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 10).isActive = true
    //        aBtn.topAnchor.constraint(equalTo: userPanel.topAnchor, constant: 30).isActive = true
        aBtn.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
//        let topInsetMargin = panel.safeAreaInsets.top + 10
//        aBtn.topAnchor.constraint(equalTo: panel.topAnchor, constant: 50).isActive = true
        aBtn.layer.cornerRadius = 20
//        aBtn.layer.opacity = 0.3
        aBtn.isUserInteractionEnabled = true
        aBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackVideoFinalizePanelClicked)))

        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_arrow_down_a")?.withRenderingMode(.alwaysTemplate))
//        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_close")?.withRenderingMode(.alwaysTemplate))
        bMiniBtn.tintColor = .white
//        aStickyHeader.addSubview(bMiniBtn)
        panel.addSubview(bMiniBtn)
        bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        bMiniBtn.centerXAnchor.constraint(equalTo: aBtn.centerXAnchor).isActive = true
        bMiniBtn.centerYAnchor.constraint(equalTo: aBtn.centerYAnchor).isActive = true
        bMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        bMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        
        let scrollView = UIScrollView()
        panel.addSubview(scrollView)
        scrollView.backgroundColor = .clear
//        scrollView.backgroundColor = .red
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: aBtn.bottomAnchor, constant: 10).isActive = true
        scrollView.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: 0).isActive = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize(width: viewWidth, height: viewHeight - 150)
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = true
        scrollView.centerXAnchor.constraint(equalTo: panel.centerXAnchor).isActive = true
        
        let stackView = UIView()
        stackView.backgroundColor = .clear
//        stackView.backgroundColor = .blue
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        
        //test > preview GIF and thumbnail for compressed video
        let gifUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
        let gifImage = SDAnimatedImageView()
        gifImage.contentMode = .scaleAspectFill
        gifImage.layer.masksToBounds = true
        gifImage.sd_setImage(with: gifUrl)
//        gifImage.sd_setImage(with: getGifOutputURL()) //test
//        gifImage.sd_setImage(with: getCoverImageOutputURL()) //test
        stackView.addSubview(gifImage) //test
        gifImage.translatesAutoresizingMaskIntoConstraints = false
//        gifImage.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20).isActive = true
//        gifImage.topAnchor.constraint(equalTo: aBtn.bottomAnchor, constant: 30).isActive = true
        gifImage.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20).isActive = true //test
        gifImage.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 20).isActive = true //test
        gifImage.heightAnchor.constraint(equalToConstant: 150).isActive = true //ori 30
        gifImage.widthAnchor.constraint(equalToConstant: 90).isActive = true
        gifImage.layer.cornerRadius = 10
        gifImage.isUserInteractionEnabled = true
//        gifImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPreviewVideoClicked)))
        
        let vPreviewBox = UIView()
//        vPreviewBox.backgroundColor = .ddmDarkColor
        stackView.addSubview(vPreviewBox)
        vPreviewBox.clipsToBounds = true
        vPreviewBox.translatesAutoresizingMaskIntoConstraints = false
        vPreviewBox.centerXAnchor.constraint(equalTo: gifImage.centerXAnchor, constant: 0).isActive = true
        vPreviewBox.topAnchor.constraint(equalTo: gifImage.bottomAnchor, constant: 10).isActive = true
        vPreviewBox.layer.cornerRadius = 5 //10
//        vPreviewBox.layer.opacity = 0.3
        vPreviewBox.isUserInteractionEnabled = true
        vPreviewBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPreviewVideoClicked)))
        vPreviewBox.isHidden = true
        
        let vPreviewText = UILabel()
        vPreviewText.textAlignment = .left
        vPreviewText.textColor = .white
        vPreviewText.font = .systemFont(ofSize: 10) //14
        vPreviewBox.addSubview(vPreviewText)
        vPreviewText.clipsToBounds = true
        vPreviewText.translatesAutoresizingMaskIntoConstraints = false
        vPreviewText.leadingAnchor.constraint(equalTo: vPreviewBox.leadingAnchor, constant: 10).isActive = true
        vPreviewText.trailingAnchor.constraint(equalTo: vPreviewBox.trailingAnchor, constant: -10).isActive = true
        vPreviewText.topAnchor.constraint(equalTo: vPreviewBox.topAnchor, constant: 10).isActive = true //5
        vPreviewText.bottomAnchor.constraint(equalTo: vPreviewBox.bottomAnchor, constant: -10).isActive = true //-5
        vPreviewText.text = "Preview"
//        vPreviewText.numberOfLines = 1
        
        bTextView.textAlignment = .left
        bTextView.textColor = .white
        bTextView.backgroundColor = .clear
        bTextView.font = .systemFont(ofSize: 13)
//        panel.addSubview(bTextView)
        stackView.addSubview(bTextView)
        bTextView.translatesAutoresizingMaskIntoConstraints = false
//        bTextView.leadingAnchor.constraint(equalTo: aBtn.leadingAnchor, constant: 20).isActive = true
        bTextView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20).isActive = true
        bTextView.trailingAnchor.constraint(equalTo: gifImage.leadingAnchor, constant: -20).isActive = true
        bTextView.topAnchor.constraint(equalTo: gifImage.topAnchor, constant: 0).isActive = true
        bTextView.bottomAnchor.constraint(equalTo: gifImage.bottomAnchor, constant: 0).isActive = true
//        bTextView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        bTextView.text = ""
        bTextView.tintColor = .yellow
//        bTextView.isHidden = true
        bTextView.delegate = self
        
//        let pText = UILabel()
        pText.textAlignment = .left
//        pText.textColor = .white
        pText.textColor = .ddmDarkGrayColor
        pText.font = .boldSystemFont(ofSize: 14)
//        panel.addSubview(pText)
        stackView.addSubview(pText)
        pText.translatesAutoresizingMaskIntoConstraints = false
//        pText.leadingAnchor.constraint(equalTo: aBtn.leadingAnchor, constant: 30).isActive = true
        pText.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 30).isActive = true
        pText.trailingAnchor.constraint(equalTo: gifImage.leadingAnchor, constant: -20).isActive = true
        pText.topAnchor.constraint(equalTo: gifImage.topAnchor, constant: 8).isActive = true
        pText.text = "Caption your Video Loop..."
//        pText.layer.opacity = 0.5
        
        pMiniError.backgroundColor = .red
        stackView.addSubview(pMiniError)
        pMiniError.translatesAutoresizingMaskIntoConstraints = false
        pMiniError.leadingAnchor.constraint(equalTo: pText.leadingAnchor, constant: 0).isActive = true
        pMiniError.bottomAnchor.constraint(equalTo: pText.topAnchor, constant: -5).isActive = true
//        pMiniError.topAnchor.constraint(equalTo: bTextView.bottomAnchor, constant: 5).isActive = true
        pMiniError.heightAnchor.constraint(equalToConstant: 20).isActive = true
        pMiniError.widthAnchor.constraint(equalToConstant: 20).isActive = true
        pMiniError.layer.cornerRadius = 10
        pMiniError.isHidden = true

        let pMiniBtn = UIImageView(image: UIImage(named:"icon_round_priority")?.withRenderingMode(.alwaysTemplate))
        pMiniBtn.tintColor = .white
        pMiniError.addSubview(pMiniBtn)
        pMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        pMiniBtn.centerXAnchor.constraint(equalTo: pMiniError.centerXAnchor).isActive = true
        pMiniBtn.centerYAnchor.constraint(equalTo: pMiniError.centerYAnchor).isActive = true
        pMiniBtn.heightAnchor.constraint(equalToConstant: 12).isActive = true
        pMiniBtn.widthAnchor.constraint(equalToConstant: 12).isActive = true
        
        //test > line divider for different sections
        let divider = UIView()
        divider.backgroundColor = .ddmDarkGrayColor //.ddmDarkColor
//        panel.addSubview(divider)
        stackView.addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 2).isActive = true
//        divider.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 20).isActive = true
//        divider.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20).isActive = true
        divider.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20).isActive = true
        divider.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20).isActive = true
        divider.topAnchor.constraint(equalTo: gifImage.bottomAnchor, constant: 50).isActive = true
//        divider.layer.cornerRadius = 20
//        divider.layer.opacity = 0.3
        divider.isHidden = true
        
        //**test > add photo, @, # functions for writing post
        let xGrid = UIView()
//        panel.addSubview(xGrid)
        stackView.addSubview(xGrid)
        xGrid.translatesAutoresizingMaskIntoConstraints = false
        xGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        xGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        xGrid.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 20).isActive = true
        xGrid.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20).isActive = true
        xGrid.topAnchor.constraint(equalTo: gifImage.bottomAnchor, constant: 10).isActive = true
        
        let xGridIcon = UIImageView(image: UIImage(named:"icon_round_at")?.withRenderingMode(.alwaysTemplate))
//        xGridIcon.tintColor = .white
        xGridIcon.tintColor = .ddmDarkGrayColor
//        panel.addSubview(xGridIcon)
        stackView.addSubview(xGridIcon)
        xGridIcon.translatesAutoresizingMaskIntoConstraints = false
        xGridIcon.centerXAnchor.constraint(equalTo: xGrid.centerXAnchor, constant: 0).isActive = true
        xGridIcon.centerYAnchor.constraint(equalTo: xGrid.centerYAnchor, constant: 0).isActive = true
        xGridIcon.heightAnchor.constraint(equalToConstant: 26).isActive = true //20
        xGridIcon.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        xGridIcon.layer.opacity = 0.5
        
        let yGrid = UIView()
//        panel.addSubview(yGrid)
        stackView.addSubview(yGrid)
        yGrid.translatesAutoresizingMaskIntoConstraints = false
        yGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        yGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
        yGrid.leadingAnchor.constraint(equalTo: xGrid.trailingAnchor, constant: 0).isActive = true
        yGrid.centerYAnchor.constraint(equalTo: xGrid.centerYAnchor, constant: 0).isActive = true
        
        let yGridIcon = UIImageView(image: UIImage(named:"icon_round_hashtag")?.withRenderingMode(.alwaysTemplate))
//        yGridIcon.tintColor = .white
        yGridIcon.tintColor = .ddmDarkGrayColor
//        panel.addSubview(yGridIcon)
        stackView.addSubview(yGridIcon)
        yGridIcon.translatesAutoresizingMaskIntoConstraints = false
//        yGridIcon.leadingAnchor.constraint(equalTo: xGridIcon.trailingAnchor, constant: 15).isActive = true
//        yGridIcon.centerYAnchor.constraint(equalTo: xGridIcon.centerYAnchor, constant: 0).isActive = true
        yGridIcon.centerXAnchor.constraint(equalTo: yGrid.centerXAnchor, constant: 0).isActive = true
        yGridIcon.centerYAnchor.constraint(equalTo: yGrid.centerYAnchor, constant: 0).isActive = true
        yGridIcon.heightAnchor.constraint(equalToConstant: 26).isActive = true
        yGridIcon.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        yGridIcon.layer.opacity = 0.5
        
        //test > setting for video upload
        let aGrid = UIView()
        aGrid.backgroundColor = .ddmDarkBlack
//        panel.addSubview(aGrid)
        stackView.addSubview(aGrid)
        aGrid.translatesAutoresizingMaskIntoConstraints = false
//        aGrid.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 20).isActive = true
//        aGrid.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20).isActive = true
        aGrid.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20).isActive = true
        aGrid.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20).isActive = true
        aGrid.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 20).isActive = true //10
        aGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        aGrid.layer.cornerRadius = 5
//        aGrid.layer.opacity = 0.1
        aGrid.isUserInteractionEnabled = true
        aGrid.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onAGridClicked)))
        
        let aGridBG = UIView()
//        aGridBG.backgroundColor = .ddmDarkColor
//        panel.addSubview(aGridBG)
        stackView.addSubview(aGridBG)
        aGridBG.translatesAutoresizingMaskIntoConstraints = false
        aGridBG.leadingAnchor.constraint(equalTo: aGrid.leadingAnchor, constant: 10).isActive = true
        aGridBG.heightAnchor.constraint(equalToConstant: 30).isActive = true
        aGridBG.widthAnchor.constraint(equalToConstant: 30).isActive = true
        aGridBG.centerYAnchor.constraint(equalTo: aGrid.centerYAnchor, constant: 0).isActive = true
        aGridBG.layer.cornerRadius = 5 //20
        
        let aGridIcon = UIImageView(image: UIImage(named:"icon_location")?.withRenderingMode(.alwaysTemplate))
        aGridIcon.tintColor = .white
//        panel.addSubview(aGridIcon)
        stackView.addSubview(aGridIcon)
        aGridIcon.translatesAutoresizingMaskIntoConstraints = false
        aGridIcon.centerXAnchor.constraint(equalTo: aGridBG.centerXAnchor).isActive = true
        aGridIcon.centerYAnchor.constraint(equalTo: aGridBG.centerYAnchor).isActive = true
        aGridIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        aGridIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
//        let aText = UILabel()
        aText.textAlignment = .left
        aText.textColor = .white
//        aText.font = .boldSystemFont(ofSize: 14)
        aText.font = .systemFont(ofSize: 14)
//        panel.addSubview(aText)
        stackView.addSubview(aText)
        aText.translatesAutoresizingMaskIntoConstraints = false
        aText.centerYAnchor.constraint(equalTo: aGrid.centerYAnchor, constant: 0).isActive = true
        aText.leadingAnchor.constraint(equalTo: aGridBG.trailingAnchor, constant: 10).isActive = true
//        aText.text = "Everyone Can See"
        aText.text = "Add Location"
//        aText.layer.opacity = 0.5
        
        let aArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
//        aArrowBtn.tintColor = .white
        aArrowBtn.tintColor = .ddmDarkGrayColor
//        panel.addSubview(aArrowBtn)
        stackView.addSubview(aArrowBtn)
        aArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        aArrowBtn.trailingAnchor.constraint(equalTo: aGrid.trailingAnchor).isActive = true
        aArrowBtn.centerYAnchor.constraint(equalTo: aGrid.centerYAnchor).isActive = true
        aArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        aArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        aArrowBtn.layer.opacity = 0.5
        
        lMiniError.backgroundColor = .red
        stackView.addSubview(lMiniError)
        lMiniError.translatesAutoresizingMaskIntoConstraints = false
        lMiniError.trailingAnchor.constraint(equalTo: aArrowBtn.leadingAnchor, constant: -5).isActive = true
        lMiniError.centerYAnchor.constraint(equalTo: aGrid.centerYAnchor, constant: 0).isActive = true
//        lMiniError.topAnchor.constraint(equalTo: maxLimitErrorPanel.topAnchor, constant: 5).isActive = true
//        lMiniError.bottomAnchor.constraint(equalTo: pText.topAnchor, constant: -5).isActive = true
        lMiniError.heightAnchor.constraint(equalToConstant: 20).isActive = true
        lMiniError.widthAnchor.constraint(equalToConstant: 20).isActive = true
        lMiniError.layer.cornerRadius = 10
        lMiniError.isHidden = true
        
        let lMiniBtn = UIImageView(image: UIImage(named:"icon_round_priority")?.withRenderingMode(.alwaysTemplate))
        lMiniBtn.tintColor = .white
        lMiniError.addSubview(lMiniBtn)
        lMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        lMiniBtn.centerXAnchor.constraint(equalTo: lMiniError.centerXAnchor).isActive = true
        lMiniBtn.centerYAnchor.constraint(equalTo: lMiniError.centerYAnchor).isActive = true
        lMiniBtn.heightAnchor.constraint(equalToConstant: 12).isActive = true
        lMiniBtn.widthAnchor.constraint(equalToConstant: 12).isActive = true
        
        let bGrid = UIView()
//        bGrid.backgroundColor = .ddmDarkColor
        bGrid.backgroundColor = .ddmDarkBlack
//        panel.addSubview(bGrid)
        stackView.addSubview(bGrid)
        bGrid.translatesAutoresizingMaskIntoConstraints = false
//        bGrid.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 20).isActive = true
//        bGrid.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20).isActive = true
        bGrid.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20).isActive = true
        bGrid.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20).isActive = true
        bGrid.topAnchor.constraint(equalTo: aGrid.bottomAnchor, constant: 10).isActive = true //10
        bGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        bGrid.layer.cornerRadius = 5
//        bGrid.layer.opacity = 0.1
        bGrid.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 0).isActive = true //10
        
        let bGridBG = UIView()
//        bGridBG.backgroundColor = .ddmDarkColor
//        panel.addSubview(bGridBG)
        stackView.addSubview(bGridBG)
        bGridBG.translatesAutoresizingMaskIntoConstraints = false
        bGridBG.leadingAnchor.constraint(equalTo: bGrid.leadingAnchor, constant: 10).isActive = true
        bGridBG.heightAnchor.constraint(equalToConstant: 30).isActive = true
        bGridBG.widthAnchor.constraint(equalToConstant: 30).isActive = true
        bGridBG.centerYAnchor.constraint(equalTo: bGrid.centerYAnchor, constant: 0).isActive = true
        bGridBG.layer.cornerRadius = 5 //20
        
        let bGridIcon = UIImageView(image: UIImage(named:"icon_round_lock_open")?.withRenderingMode(.alwaysTemplate))
        bGridIcon.tintColor = .white
//        panel.addSubview(bGridIcon)
        stackView.addSubview(bGridIcon)
        bGridIcon.translatesAutoresizingMaskIntoConstraints = false
        bGridIcon.centerXAnchor.constraint(equalTo: bGridBG.centerXAnchor).isActive = true
        bGridIcon.centerYAnchor.constraint(equalTo: bGridBG.centerYAnchor).isActive = true
        bGridIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        bGridIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let bText = UILabel()
        bText.textAlignment = .left
        bText.textColor = .white
//        bText.font = .boldSystemFont(ofSize: 14)
        bText.font = .systemFont(ofSize: 14)
//        panel.addSubview(bText)
        stackView.addSubview(bText)
        bText.translatesAutoresizingMaskIntoConstraints = false
        bText.centerYAnchor.constraint(equalTo: bGrid.centerYAnchor, constant: 0).isActive = true
        bText.leadingAnchor.constraint(equalTo: bGridBG.trailingAnchor, constant: 10).isActive = true
//        bText.text = "Everyone Can See"
        bText.text = "Public"
//        bText.layer.opacity = 0.5
        
        let bArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
//        bArrowBtn.tintColor = .white
        bArrowBtn.tintColor = .ddmDarkGrayColor
//        panel.addSubview(bArrowBtn)
        stackView.addSubview(bArrowBtn)
        bArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        bArrowBtn.trailingAnchor.constraint(equalTo: bGrid.trailingAnchor).isActive = true
        bArrowBtn.centerYAnchor.constraint(equalTo: bGrid.centerYAnchor).isActive = true
        bArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        bArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        bArrowBtn.layer.opacity = 0.5
        
        //test > upload button/save draft btn
        let draftBox = UIView()
        draftBox.backgroundColor = .ddmDarkColor
        panel.addSubview(draftBox)
//        stack1.addSubview(aSaveDraft)
        draftBox.translatesAutoresizingMaskIntoConstraints = false
        draftBox.heightAnchor.constraint(equalToConstant: 40).isActive = true //40
//        draftBox.trailingAnchor.constraint(equalTo: aSaveDraft.leadingAnchor, constant: -10).isActive = true
//        draftBox.centerYAnchor.constraint(equalTo: aSaveDraft.centerYAnchor).isActive = true
//        draftBox.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -60).isActive = true
        draftBox.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        draftBox.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 20).isActive = true
//        draftBox.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20).isActive = true
        draftBox.layer.cornerRadius = 10
        draftBox.isUserInteractionEnabled = true
        draftBox.isHidden = true
//        draftBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onDraftBoxClicked)))
        
        let draftBoxText = UILabel()
        draftBoxText.textAlignment = .center
        draftBoxText.textColor = .white
        draftBoxText.font = .boldSystemFont(ofSize: 13)
//        panel.addSubview(aSaveDraftText)
        draftBox.addSubview(draftBoxText)
        draftBoxText.translatesAutoresizingMaskIntoConstraints = false
//        aSaveDraftText.centerXAnchor.constraint(equalTo: aSaveDraft.centerXAnchor).isActive = true
        draftBoxText.centerYAnchor.constraint(equalTo: draftBox.centerYAnchor).isActive = true
        draftBoxText.leadingAnchor.constraint(equalTo: draftBox.leadingAnchor, constant: 15).isActive = true
//        draftBoxText.trailingAnchor.constraint(equalTo: draftBox.trailingAnchor, constant: -15).isActive = true
        draftBoxText.text = "3"
        
        //test > draft icon and number of drafts
        let bDraftBtn = UIImageView()
//        bDraftBtn.image = UIImage(named:"icon_round_folder_open")?.withRenderingMode(.alwaysTemplate)
        bDraftBtn.image = UIImage(named:"icon_round_folder_close")?.withRenderingMode(.alwaysTemplate)
        bDraftBtn.tintColor = .white
        draftBox.addSubview(bDraftBtn)
        bDraftBtn.translatesAutoresizingMaskIntoConstraints = false
        bDraftBtn.leadingAnchor.constraint(equalTo: draftBoxText.trailingAnchor, constant: 5).isActive = true
        bDraftBtn.trailingAnchor.constraint(equalTo: draftBox.trailingAnchor, constant: -15).isActive = true
        bDraftBtn.centerYAnchor.constraint(equalTo: draftBox.centerYAnchor).isActive = true
        bDraftBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true //ori 30
        bDraftBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let stack1 = UIView()
        let stack2 = UIView()
        
        let aSaveDraft = UIView()
        aSaveDraft.backgroundColor = .ddmDarkColor
//        panel.addSubview(aSaveDraft)
        stack1.addSubview(aSaveDraft)
        aSaveDraft.translatesAutoresizingMaskIntoConstraints = false
        aSaveDraft.heightAnchor.constraint(equalToConstant: 40).isActive = true //40
//        aSaveDraft.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 20).isActive = true
//        aSaveDraft.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -50).isActive = true
        aSaveDraft.leadingAnchor.constraint(equalTo: stack1.leadingAnchor, constant: 0).isActive = true
        aSaveDraft.trailingAnchor.constraint(equalTo: stack1.trailingAnchor, constant: -10).isActive = true
        aSaveDraft.centerYAnchor.constraint(equalTo: stack1.centerYAnchor).isActive = true
        aSaveDraft.layer.cornerRadius = 10
        aSaveDraft.isUserInteractionEnabled = true
        aSaveDraft.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSaveDraftNextClicked)))

        let aSaveDraftText = UILabel()
        aSaveDraftText.textAlignment = .center
        aSaveDraftText.textColor = .white
        aSaveDraftText.font = .boldSystemFont(ofSize: 13)
//        panel.addSubview(aSaveDraftText)
        aSaveDraft.addSubview(aSaveDraftText)
        aSaveDraftText.translatesAutoresizingMaskIntoConstraints = false
        aSaveDraftText.centerXAnchor.constraint(equalTo: aSaveDraft.centerXAnchor).isActive = true
        aSaveDraftText.centerYAnchor.constraint(equalTo: aSaveDraft.centerYAnchor).isActive = true
//        aSaveDraftText.leadingAnchor.constraint(equalTo: aSaveDraft.leadingAnchor, constant: 15).isActive = true
//        aSaveDraftText.trailingAnchor.constraint(equalTo: aSaveDraft.trailingAnchor, constant: -15).isActive = true
        aSaveDraftText.text = "Save Draft"
        
//        let aUpload = UIView()
        aUpload.backgroundColor = .yellow
//        panel.addSubview(aUpload)
        stack2.addSubview(aUpload)
        aUpload.translatesAutoresizingMaskIntoConstraints = false
        aUpload.heightAnchor.constraint(equalToConstant: 40).isActive = true //40
//        aUpload.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20).isActive = true
//        aUpload.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -50).isActive = true
        aUpload.leadingAnchor.constraint(equalTo: stack2.leadingAnchor, constant: 10).isActive = true
        aUpload.trailingAnchor.constraint(equalTo: stack2.trailingAnchor, constant: 0).isActive = true
        aUpload.centerYAnchor.constraint(equalTo: stack2.centerYAnchor).isActive = true
        aUpload.layer.cornerRadius = 10
        aUpload.isUserInteractionEnabled = true
        aUpload.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onVideoUploadNextClicked)))

        let aUploadText = UILabel()
        aUploadText.textAlignment = .center
        aUploadText.textColor = .black
        aUploadText.font = .boldSystemFont(ofSize: 13)
//        panel.addSubview(aUploadText)
        aUpload.addSubview(aUploadText)
        aUploadText.translatesAutoresizingMaskIntoConstraints = false
        aUploadText.centerXAnchor.constraint(equalTo: aUpload.centerXAnchor).isActive = true
        aUploadText.centerYAnchor.constraint(equalTo: aUpload.centerYAnchor).isActive = true
//        aUploadText.leadingAnchor.constraint(equalTo: aUpload.leadingAnchor, constant: 15).isActive = true
//        aUploadText.trailingAnchor.constraint(equalTo: aUpload.trailingAnchor, constant: -15).isActive = true
        aUploadText.text = "Post"
        
        stack2.addSubview(aSpinner)
        aSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        aSpinner.translatesAutoresizingMaskIntoConstraints = false
        aSpinner.centerYAnchor.constraint(equalTo: aUpload.centerYAnchor).isActive = true
        aSpinner.centerXAnchor.constraint(equalTo: aUpload.centerXAnchor).isActive = true
        aSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        aSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let stack1View = UIStackView(arrangedSubviews: [stack1, stack2])
        stack1View.distribution = .fillEqually
        panel.addSubview(stack1View)
        stack1View.translatesAutoresizingMaskIntoConstraints = false
//        stack1View.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -60).isActive = true //-50
        stack1View.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        stack1View.heightAnchor.constraint(equalToConstant: 40).isActive = true //ori 60
        stack1View.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 20).isActive = true
        stack1View.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20).isActive = true
        
        //test > error handling max selected limit
//        maxLimitErrorPanel.backgroundColor = .ddmBlackOverlayColor //black
        maxLimitErrorPanel.backgroundColor = .white //black
        panel.addSubview(maxLimitErrorPanel)
        maxLimitErrorPanel.translatesAutoresizingMaskIntoConstraints = false
        maxLimitErrorPanel.centerXAnchor.constraint(equalTo: panel.centerXAnchor, constant: 0).isActive = true
//        maxLimitErrorPanel.leadingAnchor.constraint(equalTo: panelView.leadingAnchor, constant: 0).isActive = true
//        maxLimitErrorPanel.trailingAnchor.constraint(equalTo: panelView.trailingAnchor, constant: 0).isActive = true
        maxLimitErrorPanel.layer.cornerRadius = 10
        maxLimitErrorPanel.bottomAnchor.constraint(equalTo: stack1View.topAnchor, constant: -10).isActive = true
        maxLimitErrorPanel.isHidden = true
        
        let miniError = UIView()
        miniError.backgroundColor = .red
        maxLimitErrorPanel.addSubview(miniError)
        miniError.translatesAutoresizingMaskIntoConstraints = false
        miniError.leadingAnchor.constraint(equalTo: maxLimitErrorPanel.leadingAnchor, constant: 15).isActive = true
//        miniError.centerYAnchor.constraint(equalTo: maxLimitErrorPanel.centerYAnchor, constant: 0).isActive = true
        miniError.topAnchor.constraint(equalTo: maxLimitErrorPanel.topAnchor, constant: 5).isActive = true
        miniError.bottomAnchor.constraint(equalTo: maxLimitErrorPanel.bottomAnchor, constant: -5).isActive = true
        miniError.heightAnchor.constraint(equalToConstant: 20).isActive = true
        miniError.widthAnchor.constraint(equalToConstant: 20).isActive = true
        miniError.layer.cornerRadius = 10
//        micMiniError.isHidden = true

        let miniBtn = UIImageView(image: UIImage(named:"icon_round_priority")?.withRenderingMode(.alwaysTemplate))
        miniBtn.tintColor = .white
        miniError.addSubview(miniBtn)
        miniBtn.translatesAutoresizingMaskIntoConstraints = false
        miniBtn.centerXAnchor.constraint(equalTo: miniError.centerXAnchor).isActive = true
        miniBtn.centerYAnchor.constraint(equalTo: miniError.centerYAnchor).isActive = true
        miniBtn.heightAnchor.constraint(equalToConstant: 12).isActive = true
        miniBtn.widthAnchor.constraint(equalToConstant: 12).isActive = true
        
//        let maxLimitText = UILabel()
        maxLimitText.textAlignment = .center
//        maxLimitText.textColor = .white
        maxLimitText.textColor = .black
        maxLimitText.font = .boldSystemFont(ofSize: 13)
//        panel.addSubview(aUploadText)
        maxLimitErrorPanel.addSubview(maxLimitText)
        maxLimitText.translatesAutoresizingMaskIntoConstraints = false
//        maxLimitText.topAnchor.constraint(equalTo: maxLimitErrorPanel.topAnchor, constant: 10).isActive = true
//        maxLimitText.bottomAnchor.constraint(equalTo: maxLimitErrorPanel.bottomAnchor, constant: -10).isActive = true
        maxLimitText.centerYAnchor.constraint(equalTo: maxLimitErrorPanel.centerYAnchor, constant: 0).isActive = true
        maxLimitText.leadingAnchor.constraint(equalTo: miniError.trailingAnchor, constant: 7).isActive = true
        maxLimitText.trailingAnchor.constraint(equalTo: maxLimitErrorPanel.trailingAnchor, constant: -15).isActive = true
        maxLimitText.text = ""
    }

    @objc func onPreviewVideoClicked(gesture: UITapGestureRecognizer) {
        //test > video preview
//        openVideoPreviewPanel()
    }
    
    @objc func onBackVideoFinalizePanelClicked(gesture: UITapGestureRecognizer) {
        closeVideoFinalizePanel(isAnimated: true)
    }
    
    @objc func onVideoUploadNextClicked(gesture: UITapGestureRecognizer) {
        clearErrorUI()
        resignResponder()
        
        let isSignedIn = SignInManager.shared.getStatus()
        if(isSignedIn) {
            
            if(bTextView.text == "") {
                configureErrorUI(data: "na-caption")
            } else {
                aUpload.isHidden = true
                aSpinner.startAnimating()
                    
                //test 1 > old method
//                DataUploadManager.shared.sendData(id: "u") { [weak self]result in
//                    switch result {
//                        case .success(let l):
//
//                        //update UI on main thread
//                        DispatchQueue.main.async {
//
//        //                    self?.closeVideoFinalizePanel(isAnimated: true)
//                            
//                            //test
//                            self?.delegate?.didVideoFinalizeClickUploadSuccess()
//                        }
//
//                        case .failure(_):
//                            print("api fail")
//                            break
//                    }
//                }
                
                //test 2 > new method to upload data for in-app msg
                delegate?.didVideoFinalizeClickUpload(payload: "cc")
            }
        }
        else {
//            delegate?.didVideoCreatorClickSignIn()
        }
    }
    
    @objc func onSaveDraftNextClicked(gesture: UITapGestureRecognizer) {
        
    }
    
    @objc func onBoxUnderClicked(gesture: UITapGestureRecognizer) {
        print("box under")
        clearErrorUI()
        resignResponder()
    }
    
    @objc func onAddCaptionClicked(gesture: UITapGestureRecognizer) {
        aBoxUnder.isHidden = false
        activate()
    }
    
    @objc func onAGridClicked(gesture: UITapGestureRecognizer) {
        //test 2
        clearErrorUI()
        delegate?.didVideoFinalizeClickLocationSelectScrollable()
    }
    
    func closeVideoFinalizePanel(isAnimated: Bool) {
        if(isAnimated) {
            UIView.animate(withDuration: 0.2, animations: { //default: 0.2
                self.panelTopCons?.constant = 0
                self.layoutIfNeeded()
            }, completion: { _ in
                self.removeFromSuperview()
                
                self.delegate?.didClickFinishVideoFinalize()
            })
        } else {
            self.removeFromSuperview()
            
            self.delegate?.didClickFinishVideoFinalize()
        }
    }
    
    func activate() {
        setFirstResponder(textView: bTextView)
    }
    
    func setFirstResponder(textView: UITextView) {
        textView.becomeFirstResponder()
    }
    
    func resignResponder() {
        self.endEditing(true)
    }
    
    var selectedPlaceList = [String]()
    func setSelectedLocation(l : String) {
        removeSelectedLocation()
        
        if(selectedPlaceList.isEmpty) {
            selectedPlaceList.append("p")
            aText.text = l
        }
    }
    
    func removeSelectedLocation() {
        if(!selectedPlaceList.isEmpty) {
            selectedPlaceList.removeLast()
            aText.text = "Add Location"
        }
    }

    func getGifOutputURL() -> URL {
        let documentsURL = mainDirectoryUrl.appendingPathComponent(VideoCreatorFileTypes.DRAFT_VIDEO_FILES_FOLDER_NAME)
        let url = documentsURL.appendingPathComponent(VideoCreatorFileTypes.DRAFT_GIF_FILE_OUTPUT_NAME)
        
        return url
    }
    func getCoverImageOutputURL() -> URL {
        let documentsURL = mainDirectoryUrl.appendingPathComponent(VideoCreatorFileTypes.DRAFT_VIDEO_FILES_FOLDER_NAME)
        let url = documentsURL.appendingPathComponent(VideoCreatorFileTypes.DRAFT_COVER_IMAGE_FILE_OUTPUT_NAME)
        
        return url
    }
    
    func configureErrorUI(data: String) {
        if(data == "e") {
            maxLimitText.text = "Error occurred. Try again"
        }
        else if(data == "na-photo") {
            maxLimitText.text = "Photo is required"
        }
        else if(data == "na-caption") {
            maxLimitText.text = "Caption is required"
            pMiniError.isHidden = false
        }
        else if(data == "na-location") {
            maxLimitText.text = "Location is required"
            lMiniError.isHidden = false
        }
        
        maxLimitErrorPanel.isHidden = false
    }
    
    func clearErrorUI() {
        maxLimitText.text = ""
        maxLimitErrorPanel.isHidden = true
        
        pMiniError.isHidden = true
        lMiniError.isHidden = true
    }
}
extension VideoFinalizePanelView: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("xx4 scrollview begin: \(scrollView.contentOffset.y)")
        let scrollOffsetY = scrollView.contentOffset.y
        
        clearErrorUI()
        resignResponder()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("xx4 scrollview scroll: \(scrollView.contentOffset.y)")

        let scrollOffsetY = scrollView.contentOffset.y
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("xx4 scrollview end: \(scrollView.contentOffset.y)")
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("xx4 scrollview end drag: \(scrollView.contentOffset.y)")
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("xx4 scrollview animation ended")
    }
}

extension VideoFinalizePanelView: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        let currentString: NSString = (textView.text ?? "") as NSString
        let length = currentString.length
        if(length > 0) {
            pText.isHidden = true
        } else {
            pText.isHidden = false
        }
        print("textView change \(length)")
    }
}

