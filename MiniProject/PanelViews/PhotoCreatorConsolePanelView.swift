//
//  PhotoCreatorConsolePanelView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage
import PhotosUI
import Photos

protocol PhotoCreatorPanelDelegate : AnyObject {
    func didInitializePhotoCreator()
    func didClickFinishPhotoCreator()
    func didPhotoCreatorClickLocationSelectScrollable()
    
    func didPhotoCreatorClickSignIn()
}

//test > photo cells in photo creator panel
class PhotoClip: SDAnimatedImageView {
    var pFrameLeadingCons: NSLayoutConstraint?
}

class PhotoCreatorConsolePanelView: CreatorPanelView{
    
    var panel = UIView()
    var currentPanelTopCons : CGFloat = 0.0
    var panelTopCons: NSLayoutConstraint?
    
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    let aUpload = UIView()
    let aSaveDraft = UIView()
    let aSpinner = SpinLoader()
    let bSpinner = SpinLoader()
    
    weak var delegate : PhotoCreatorPanelDelegate?
    
    let scrollView = UIScrollView()
    var photoUrlDataList = [URL]()
//    var photoViewList = [SDAnimatedImageView]()
    var photoViewList = [PhotoClip]()
    
    let aaText = UILabel()
    let acText = UILabel()
    
    let aBox = UIView()
    let aPromptBox = UIView()
    var scrollViewHeightCons: NSLayoutConstraint?
    
    //test > user login/out status
    var isUserLoggedIn = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewWidth = frame.width
        viewHeight = frame.height
//        setupViews()

    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
//        setupViews()
    }
    
    func redrawUI() {
        panel.backgroundColor = .ddmBlackOverlayColor
        self.addSubview(panel)
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        panel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        panel.layer.masksToBounds = true
        panel.layer.cornerRadius = 10 //10
//        panel.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        panel.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        panelTopCons = panel.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -viewHeight)
        panelTopCons?.isActive = true
        
        let aBtn = UIView()
//        aBtn.backgroundColor = .ddmDarkColor
        aBtn.backgroundColor = .clear
//        aStickyHeader.addSubview(aBtn)
        panel.addSubview(aBtn)
        aBtn.translatesAutoresizingMaskIntoConstraints = false
        aBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
        aBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        aBtn.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 10).isActive = true
//        aBtn.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
//        let topInsetMargin = panel.safeAreaInsets.top + 10
//        aBtn.topAnchor.constraint(equalTo: panel.topAnchor, constant: topInset).isActive = true
        aBtn.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        aBtn.layer.cornerRadius = 20
//        aBtn.layer.opacity = 0.3
        aBtn.isUserInteractionEnabled = true
        aBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackPhotoCreatorPanelClicked)))

//        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_arrow_down_a")?.withRenderingMode(.alwaysTemplate))
        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_close")?.withRenderingMode(.alwaysTemplate))
        bMiniBtn.tintColor = .ddmDarkGrayColor
//        aStickyHeader.addSubview(bMiniBtn)
        panel.addSubview(bMiniBtn)
        bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        bMiniBtn.centerXAnchor.constraint(equalTo: aBtn.centerXAnchor).isActive = true
        bMiniBtn.centerYAnchor.constraint(equalTo: aBtn.centerYAnchor).isActive = true
        bMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        bMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        
        //test
        let aCreateTitleText = UILabel()
        aCreateTitleText.textAlignment = .center
        aCreateTitleText.textColor = .white
//        aCreateTitleText.textColor = .ddmBlackOverlayColor
        aCreateTitleText.font = .boldSystemFont(ofSize: 14) //16
        panel.addSubview(aCreateTitleText)
        aCreateTitleText.translatesAutoresizingMaskIntoConstraints = false
        aCreateTitleText.centerYAnchor.constraint(equalTo: aBtn.centerYAnchor, constant: 0).isActive = true
        aCreateTitleText.centerXAnchor.constraint(equalTo: panel.centerXAnchor, constant: 0).isActive = true
        aCreateTitleText.text = "New Shot"
        
//        let aBox = UIView()
        aBox.backgroundColor = .ddmBlackDark
        panel.addSubview(aBox)
        aBox.clipsToBounds = true
        aBox.translatesAutoresizingMaskIntoConstraints = false
        aBox.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -10).isActive = true
//        aBox.centerXAnchor.constraint(equalTo: panel.centerXAnchor, constant: 0).isActive = true
        aBox.heightAnchor.constraint(equalToConstant: 30).isActive = true //default: 50
        aBox.centerYAnchor.constraint(equalTo: aBtn.centerYAnchor, constant: 0).isActive = true
//        aBox.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10).isActive = true //20
        aBox.layer.cornerRadius = 15
//        aBox.layer.opacity = 0.2 //0.3
        aBox.isHidden = true

//        let aaText = UILabel()
        aaText.textAlignment = .left
        aaText.textColor = .white
//        aaText.textColor = .ddmDarkColor
        aaText.font = .boldSystemFont(ofSize: 12)
//        aaText.font = .systemFont(ofSize: 12)
        aBox.addSubview(aaText)
        aaText.clipsToBounds = true
        aaText.translatesAutoresizingMaskIntoConstraints = false
        aaText.topAnchor.constraint(equalTo: aBox.topAnchor, constant: 5).isActive = true
        aaText.bottomAnchor.constraint(equalTo: aBox.bottomAnchor, constant: -5).isActive = true
        aaText.leadingAnchor.constraint(equalTo: aBox.leadingAnchor, constant: 10).isActive = true //10
//        aaText.trailingAnchor.constraint(equalTo: aBox.trailingAnchor, constant: -10).isActive = true
        aaText.text = ""
        
        let abText = UILabel()
        abText.textAlignment = .left
        abText.textColor = .white
//        aaText.textColor = .ddmDarkColor
        abText.font = .boldSystemFont(ofSize: 12)
//        aaText.font = .systemFont(ofSize: 12)
        aBox.addSubview(abText)
        abText.clipsToBounds = true
        abText.translatesAutoresizingMaskIntoConstraints = false
        abText.topAnchor.constraint(equalTo: aBox.topAnchor, constant: 5).isActive = true
        abText.bottomAnchor.constraint(equalTo: aBox.bottomAnchor, constant: -5).isActive = true
        abText.leadingAnchor.constraint(equalTo: aaText.trailingAnchor, constant: 10).isActive = true //10
//        abText.trailingAnchor.constraint(equalTo: aBox.trailingAnchor, constant: -10).isActive = true
        abText.text = "/"
        
//        let acText = UILabel()
        acText.textAlignment = .left
        acText.textColor = .white
//        aaText.textColor = .ddmDarkColor
        acText.font = .boldSystemFont(ofSize: 12)
//        aaText.font = .systemFont(ofSize: 12)
        aBox.addSubview(acText)
        acText.clipsToBounds = true
        acText.translatesAutoresizingMaskIntoConstraints = false
        acText.topAnchor.constraint(equalTo: aBox.topAnchor, constant: 5).isActive = true
        acText.bottomAnchor.constraint(equalTo: aBox.bottomAnchor, constant: -5).isActive = true
        acText.leadingAnchor.constraint(equalTo: abText.trailingAnchor, constant: 10).isActive = true //10
        acText.trailingAnchor.constraint(equalTo: aBox.trailingAnchor, constant: -10).isActive = true
        acText.text = ""
        
        //carousel of images
//        let scrollView = UIScrollView()
        panel.addSubview(scrollView)
//        scrollView.backgroundColor = .clear
        scrollView.backgroundColor = .ddmDarkColor
        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        let topMargin = 50.0 + topInset + 20.0
//        scrollView.topAnchor.constraint(equalTo: panel.topAnchor, constant: topMargin).isActive = true
        scrollView.topAnchor.constraint(equalTo: aBtn.bottomAnchor, constant: 20).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 0).isActive = true //0
        scrollView.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: 0).isActive = true
//        scrollView.heightAnchor.constraint(equalToConstant: 400.0).isActive = true  //280
        scrollViewHeightCons = scrollView.heightAnchor.constraint(equalToConstant: viewWidth)
        scrollViewHeightCons?.isActive = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
//        let contentWidth = viewWidth * 2
//        scrollView.contentSize = CGSize(width: contentWidth, height: 400.0) //800, 280
        scrollView.isPagingEnabled = true //false
        scrollView.delegate = self
        scrollView.layer.cornerRadius = 10
        
//        let aPromptBox = UIView()
//        aPromptBox.backgroundColor = .ddmDarkColor
        panel.addSubview(aPromptBox)
        aPromptBox.clipsToBounds = true
        aPromptBox.translatesAutoresizingMaskIntoConstraints = false
        aPromptBox.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0).isActive = true
        aPromptBox.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
//        aPromptBox.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor, constant: 0).isActive = true
        aPromptBox.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        aPromptBox.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true
//        aPromptBox.isHidden = true
        aPromptBox.isUserInteractionEnabled = true
        aPromptBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onAddPhotoClicked)))
        
        let aPromptBoxInner = UIView()
        aPromptBox.addSubview(aPromptBoxInner)
        aPromptBoxInner.translatesAutoresizingMaskIntoConstraints = false
//        aPromptBoxInner.centerXAnchor.constraint(equalTo: aPromptBox.centerXAnchor, constant: 0).isActive = true
        aPromptBoxInner.centerYAnchor.constraint(equalTo: aPromptBox.centerYAnchor, constant: 0).isActive = true
        aPromptBoxInner.trailingAnchor.constraint(equalTo: aPromptBox.trailingAnchor, constant: 0).isActive = true
        aPromptBoxInner.leadingAnchor.constraint(equalTo: aPromptBox.leadingAnchor, constant: 0).isActive = true
      
        let lhsAddBtn = UIImageView(image: UIImage(named:"icon_round_add_circle")?.withRenderingMode(.alwaysTemplate))
        lhsAddBtn.tintColor = .white //.ddmBlackOverlayColor
        aPromptBoxInner.addSubview(lhsAddBtn)
        lhsAddBtn.translatesAutoresizingMaskIntoConstraints = false
        lhsAddBtn.centerXAnchor.constraint(equalTo: aPromptBoxInner.centerXAnchor, constant: 0).isActive = true
        lhsAddBtn.topAnchor.constraint(equalTo: aPromptBoxInner.topAnchor, constant: 0).isActive = true
        lhsAddBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true //ori 30
        lhsAddBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let aPhotoPromptText = UILabel()
        aPhotoPromptText.textAlignment = .left
        aPhotoPromptText.textColor = .white
//        aPhotoPromptText.textColor = .ddmDarkColor
        aPhotoPromptText.font = .boldSystemFont(ofSize: 12)
//        aaText.font = .systemFont(ofSize: 12)
        aPromptBoxInner.addSubview(aPhotoPromptText)
        aPhotoPromptText.clipsToBounds = true
        aPhotoPromptText.translatesAutoresizingMaskIntoConstraints = false
        aPhotoPromptText.centerXAnchor.constraint(equalTo: aPromptBoxInner.centerXAnchor, constant: 0).isActive = true
        aPhotoPromptText.bottomAnchor.constraint(equalTo: aPromptBoxInner.bottomAnchor, constant: 0).isActive = true
        aPhotoPromptText.topAnchor.constraint(equalTo: lhsAddBtn.bottomAnchor, constant: 10).isActive = true
        aPhotoPromptText.text = "Add Photo"
        
        //test > add sound bar
        let audioFrame = UIView()
        panel.addSubview(audioFrame)
        audioFrame.backgroundColor = .ddmDarkColor
        audioFrame.translatesAutoresizingMaskIntoConstraints = false
//        audioFrame.topAnchor.constraint(equalTo: aBox.bottomAnchor, constant: 20).isActive = true
        audioFrame.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 20).isActive = true
        audioFrame.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 20).isActive = true
        audioFrame.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20).isActive = true
        audioFrame.heightAnchor.constraint(equalToConstant: 50).isActive = true
        audioFrame.layer.cornerRadius = 10
        audioFrame.isUserInteractionEnabled = true
//        audioFrame.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSelectAudioClicked)))
        
        let audioMiniBtn = UIImageView(image: UIImage(named:"icon_round_music")?.withRenderingMode(.alwaysTemplate))
//        audioMiniBtn.image = UIImage(named:"icon_round_music")?.withRenderingMode(.alwaysTemplate)
        audioMiniBtn.tintColor = .white
        audioFrame.addSubview(audioMiniBtn)
        audioMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        audioMiniBtn.leadingAnchor.constraint(equalTo: audioFrame.leadingAnchor, constant: 5).isActive = true
        audioMiniBtn.centerYAnchor.constraint(equalTo: audioFrame.centerYAnchor).isActive = true
        audioMiniBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        audioMiniBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let audioMiniText = UILabel()
        audioMiniText.textAlignment = .left
        audioMiniText.textColor = .white
        audioMiniText.font = .boldSystemFont(ofSize: 10)
        audioFrame.addSubview(audioMiniText)
        audioMiniText.translatesAutoresizingMaskIntoConstraints = false
        audioMiniText.leadingAnchor.constraint(equalTo: audioMiniBtn.trailingAnchor, constant: 5).isActive = true
        audioMiniText.centerYAnchor.constraint(equalTo: audioFrame.centerYAnchor).isActive = true
        audioMiniText.trailingAnchor.constraint(equalTo: audioFrame.trailingAnchor, constant: -10).isActive = true
        audioMiniText.text = "Tap to Add Sound"
        
        //**test > tools panel
        let toolPanel = UIView()
        toolPanel.backgroundColor = .ddmBlackOverlayColor //black
//        toolPanel.backgroundColor = .black //black
        panel.addSubview(toolPanel)
        toolPanel.translatesAutoresizingMaskIntoConstraints = false
//        toolPanel.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: 0).isActive = true
        toolPanel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
//        toolPanel.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -bottomInset).isActive = true
        toolPanel.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 0).isActive = true
        toolPanel.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: 0).isActive = true
        toolPanel.layer.cornerRadius = 0
        toolPanel.heightAnchor.constraint(equalToConstant: 90).isActive = true //120

        let mainEditPanel = UIView()
        toolPanel.addSubview(mainEditPanel)
        mainEditPanel.translatesAutoresizingMaskIntoConstraints = false
        mainEditPanel.bottomAnchor.constraint(equalTo: toolPanel.bottomAnchor, constant: 0).isActive = true
        mainEditPanel.topAnchor.constraint(equalTo: toolPanel.topAnchor, constant: 0).isActive = true
        mainEditPanel.leadingAnchor.constraint(equalTo: toolPanel.leadingAnchor, constant: 0).isActive = true
        mainEditPanel.trailingAnchor.constraint(equalTo: toolPanel.trailingAnchor, constant: 0).isActive = true

        let mainXGrid = UIView()
        mainEditPanel.addSubview(mainXGrid)
        mainXGrid.backgroundColor = .ddmDarkColor
        mainXGrid.translatesAutoresizingMaskIntoConstraints = false
        mainXGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        mainXGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
        mainXGrid.leadingAnchor.constraint(equalTo: mainEditPanel.leadingAnchor, constant: 20).isActive = true
        mainXGrid.topAnchor.constraint(equalTo: mainEditPanel.topAnchor, constant: 10).isActive = true
//        mainXGrid.centerYAnchor.constraint(equalTo: mainEditPanel.centerYAnchor, constant: 0).isActive = true
        mainXGrid.layer.cornerRadius = 20 //10
        mainXGrid.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onAddPhotoClicked)))

        let mainXGridIcon = UIImageView(image: UIImage(named:"icon_round_music")?.withRenderingMode(.alwaysTemplate))
//        let mainXGridIcon = UIImageView(image: UIImage(named:"icon_round_add_v")?.withRenderingMode(.alwaysTemplate))
        mainXGridIcon.tintColor = .white
//        uView.addSubview(xGridIcon)
        mainEditPanel.addSubview(mainXGridIcon)
        mainXGridIcon.translatesAutoresizingMaskIntoConstraints = false
        mainXGridIcon.centerXAnchor.constraint(equalTo: mainXGrid.centerXAnchor, constant: 0).isActive = true
        mainXGridIcon.centerYAnchor.constraint(equalTo: mainXGrid.centerYAnchor, constant: 0).isActive = true
        mainXGridIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true //26
        mainXGridIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true

        let mainXGridText = UILabel()
        mainXGridText.textAlignment = .center
        mainXGridText.textColor = .white
        mainXGridText.font = .boldSystemFont(ofSize: 10)
        mainEditPanel.addSubview(mainXGridText)
        mainXGridText.translatesAutoresizingMaskIntoConstraints = false
        mainXGridText.topAnchor.constraint(equalTo: mainXGrid.bottomAnchor, constant: 2).isActive = true
        mainXGridText.centerXAnchor.constraint(equalTo: mainXGrid.centerXAnchor).isActive = true
        mainXGridText.text = "Add Sound"
        
        let fGrid = UIView() //add vc
        fGrid.backgroundColor = .ddmDarkColor
//        panel.addSubview(fGrid)
        mainEditPanel.addSubview(fGrid)
        fGrid.translatesAutoresizingMaskIntoConstraints = false
//        fGrid.leadingAnchor.constraint(equalTo: eFGrid.trailingAnchor, constant: 20).isActive = true
        fGrid.leadingAnchor.constraint(equalTo: mainXGrid.trailingAnchor, constant: 20).isActive = true
        fGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        fGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        fGrid.topAnchor.constraint(equalTo: eGrid.topAnchor, constant: 0).isActive = true
        fGrid.topAnchor.constraint(equalTo: mainEditPanel.topAnchor, constant: 10).isActive = true
        fGrid.layer.cornerRadius = 20 //10
        fGrid.isUserInteractionEnabled = true
        fGrid.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onAddSoundClicked)))
        
        let fMiniBtn = UIImageView(image: UIImage(named:"icon_round_add_v")?.withRenderingMode(.alwaysTemplate))
//        let fMiniBtn = UIImageView(image: UIImage(named:"icon_outline_photo")?.withRenderingMode(.alwaysTemplate))
        fMiniBtn.tintColor = .white
        mainEditPanel.addSubview(fMiniBtn)
        fMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        fMiniBtn.centerXAnchor.constraint(equalTo: fGrid.centerXAnchor).isActive = true
        fMiniBtn.centerYAnchor.constraint(equalTo: fGrid.centerYAnchor).isActive = true
        fMiniBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        fMiniBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true

        let fMiniText = UILabel()
        fMiniText.textAlignment = .center
        fMiniText.textColor = .white
        fMiniText.font = .boldSystemFont(ofSize: 10)
        mainEditPanel.addSubview(fMiniText)
        fMiniText.translatesAutoresizingMaskIntoConstraints = false
        fMiniText.topAnchor.constraint(equalTo: fGrid.bottomAnchor, constant: 2).isActive = true
        fMiniText.centerXAnchor.constraint(equalTo: fGrid.centerXAnchor).isActive = true
        fMiniText.text = "Add Photo"
        
        let vGrid = UIView() //delete vc
//        vGrid.backgroundColor = .ddmDarkColor
        vGrid.backgroundColor = .red
//        panel.addSubview(eGrid)
        mainEditPanel.addSubview(vGrid)
        vGrid.translatesAutoresizingMaskIntoConstraints = false
        vGrid.leadingAnchor.constraint(equalTo: fGrid.trailingAnchor, constant: 20).isActive = true
        vGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        vGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        vGrid.topAnchor.constraint(equalTo: pauseBtn.bottomAnchor, constant: 20).isActive = true
        vGrid.topAnchor.constraint(equalTo: mainEditPanel.topAnchor, constant: 10).isActive = true
        vGrid.layer.cornerRadius = 20 //10
        vGrid.layer.opacity = 0.5
        vGrid.isUserInteractionEnabled = true
//        vGrid.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onVPhotoClicked)))
        
        let vMiniBtn = UIImageView(image: UIImage(named:"icon_round_delete")?.withRenderingMode(.alwaysTemplate))
        vMiniBtn.tintColor = .white
        mainEditPanel.addSubview(vMiniBtn)
        vMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        vMiniBtn.centerXAnchor.constraint(equalTo: vGrid.centerXAnchor).isActive = true
        vMiniBtn.centerYAnchor.constraint(equalTo: vGrid.centerYAnchor).isActive = true
        vMiniBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        vMiniBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let vMiniText = UILabel()
        vMiniText.textAlignment = .center
        vMiniText.textColor = .white
        vMiniText.font = .boldSystemFont(ofSize: 10)
        mainEditPanel.addSubview(vMiniText)
        vMiniText.translatesAutoresizingMaskIntoConstraints = false
        vMiniText.topAnchor.constraint(equalTo: vGrid.bottomAnchor, constant: 2).isActive = true
        vMiniText.centerXAnchor.constraint(equalTo: vGrid.centerXAnchor).isActive = true
        vMiniText.text = "Delete"
        
        let aNext = UIView()
        aNext.backgroundColor = .yellow
    //        aFollow.backgroundColor = .ddmGoldenYellowColor
        panel.addSubview(aNext)
        aNext.translatesAutoresizingMaskIntoConstraints = false
        aNext.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20).isActive = true
        aNext.heightAnchor.constraint(equalToConstant: 40).isActive = true
        aNext.widthAnchor.constraint(equalToConstant: 40).isActive = true
        aNext.centerYAnchor.constraint(equalTo: mainXGrid.centerYAnchor, constant: 0).isActive = true
        aNext.layer.cornerRadius = 20
        aNext.isUserInteractionEnabled = true
        aNext.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPhotoEditorNextClicked)))
//        aNext.isHidden = true
        
        let aNextMiniBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right_next")?.withRenderingMode(.alwaysTemplate))
        aNextMiniBtn.tintColor = .black
        panel.addSubview(aNextMiniBtn)
        aNextMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        aNextMiniBtn.centerXAnchor.constraint(equalTo: aNext.centerXAnchor).isActive = true
        aNextMiniBtn.centerYAnchor.constraint(equalTo: aNext.centerYAnchor).isActive = true
        aNextMiniBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        aNextMiniBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let aNextText = UILabel()
        aNextText.textAlignment = .center
        aNextText.textColor = .white
        aNextText.font = .boldSystemFont(ofSize: 10)
        mainEditPanel.addSubview(aNextText)
        aNextText.translatesAutoresizingMaskIntoConstraints = false
        aNextText.topAnchor.constraint(equalTo: aNext.bottomAnchor, constant: 2).isActive = true
        aNextText.centerXAnchor.constraint(equalTo: aNext.centerXAnchor).isActive = true
        aNextText.text = "Next"
    }
    
    //test
    override func resumeActiveState() {
        print("photocreatorpanelview resume active")
        
        //test > check for signin status when in active state
        asyncFetchSigninStatus()
    }
    
    //test > initialization state
    var isInitialized = false
    var topInset = 0.0
    var bottomInset = 0.0
    func initialize(topInset: CGFloat, bottomInset: CGFloat) {

//        if(!isInitialized) {
            self.topInset = topInset
            self.bottomInset = bottomInset
            
            redrawUI()
       
            //test
//            let isToOpen = true
//            if(isToOpen) {
//                openCameraRoll()
//            }
            
            //test
            asyncFetchSigninStatus()
//        }
//
//        isInitialized = true
    }
    
    //test
    func initialize() {
        if(!isInitialized) {
            if(isUserLoggedIn) {
                openCameraRoll()
            } else {

            }
        }
        isInitialized = true
    }
    
    //test > check sign in status before allowing user to create
    func asyncFetchSigninStatus() {
        //test > simple get method
        let isSignedIn = SignInManager.shared.getStatus()
        if(self.isInitialized) {
            if(self.isUserLoggedIn != isSignedIn) {
                self.isUserLoggedIn = isSignedIn
        
                self.isInitialized = false
                self.initialize()
            }
            else {
                if(self.isUserLoggedIn) {
                    
                } else {
                    
                }
            }
        } else {
            self.isUserLoggedIn = isSignedIn
            self.initialize()
        }
    }
    
    func closePhotoCreatorPanel(isAnimated: Bool) {
        if(isAnimated) {
            UIView.animate(withDuration: 0.2, animations: { //default: 0.2
                self.panelTopCons?.constant = 0
                self.layoutIfNeeded()
            }, completion: { _ in
                self.removeFromSuperview()
                
                self.delegate?.didClickFinishPhotoCreator()
            })
        } else {
            self.removeFromSuperview()
            
            self.delegate?.didClickFinishPhotoCreator()
        }
    }
    
    @objc func onBackPhotoCreatorPanelClicked(gesture: UITapGestureRecognizer) {
//        resignResponder()
//        openSavePostDraftPromptMsg()
        
        closePhotoCreatorPanel(isAnimated: true)
    }
    
    @objc func onAddPhotoClicked(gesture: UITapGestureRecognizer) {
//        openCameraRoll()
        
        let isSignedIn = SignInManager.shared.getStatus()
        if(isSignedIn) {
            openCameraRoll()
        }
        else {
            delegate?.didPhotoCreatorClickSignIn()
        }
    }
    
    @objc func onAddSoundClicked(gesture: UITapGestureRecognizer) {
        
        let isSignedIn = SignInManager.shared.getStatus()
        if(isSignedIn) {
            
        }
        else {
            delegate?.didPhotoCreatorClickSignIn()
        }
    }
    
    @objc func onPhotoEditorNextClicked(gesture: UITapGestureRecognizer) {
//        openPhotoFinalize()
        
        let isSignedIn = SignInManager.shared.getStatus()
        if(isSignedIn) {
            openPhotoFinalize()
        }
        else {
            delegate?.didPhotoCreatorClickSignIn()
        }
    }
    
    //test > check storage permission
    func checkCameraRollPermission(isToOpen: Bool) -> Bool {
        
        switch PHPhotoLibrary.authorizationStatus() {
            
        case .notDetermined:
            print("storage permission not determined")
            return false
        case .restricted:
            print("storage permission restricted")
            return false
        case .limited:
            print("storage permission limited")
            return false
        case .denied:
            print("storage permission denied")
            return false
        case .authorized:
            print("storage permission authorized")
            
            //test => open video album directly
            if(isToOpen) {
                openCameraRoll()
            }

            return true
        @unknown default:
            return false
        }
    }
    
    func openCameraRoll() {
        let cameraRollPanel = CameraPhotoRollPanelView(frame: CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.height))
        panel.addSubview(cameraRollPanel)
        cameraRollPanel.translatesAutoresizingMaskIntoConstraints = false
        cameraRollPanel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        cameraRollPanel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        cameraRollPanel.delegate = self
        cameraRollPanel.setMultiSelection()
    }
    
    func openPhotoFinalize() {
        let photoFinalizePanel = PhotoFinalizePanelView(frame: CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.height))
        panel.addSubview(photoFinalizePanel)
        photoFinalizePanel.translatesAutoresizingMaskIntoConstraints = false
        photoFinalizePanel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        photoFinalizePanel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        photoFinalizePanel.delegate = self
        
//        pageList.append(photoFinalizePanel)
    }
    
//    func getCurrentItemIndex(scrollView: UIScrollView) -> Int? {
//        let contentOffsetX = scrollView.contentOffset.x
//        let scrollViewWidth = scrollView.bounds.width
//        
//        // Calculate the current item index based on the content offset and the scroll view's subviews
//        for (index, subview) in scrollView.subviews.enumerated() {
//            let subviewX = subview.frame.origin.x
//            let subviewWidth = subview.frame.width
//            
//            if contentOffsetX >= subviewX && contentOffsetX < (subviewX + subviewWidth) {
//                return index
//            }
//        }
//        
//        return nil // If the current item index cannot be determined
//    }
    
    //test > hide prompt if user has selected photo beforehand
    func reactPhotoUIChange() {
//        if(photoUrlDataList.isEmpty) {
        if(photoViewList.isEmpty) {
            aPromptBox.isHidden = false
        } else {
            aPromptBox.isHidden = true
        }
    }
    
    //test > compute adaptive height according to photo asset aspect ratio and size
    func getPhotoHeight() -> CGFloat{
        let availableWidth = self.frame.width
        let assetSize = CGSize(width: 3, height: 4) //4:3
        var cSize = CGSize(width: 0, height: 0)
        if(assetSize.width > assetSize.height) {
            //1 > landscape photo 4:3 w:h
            let aRatio = CGSize(width: 4, height: 3) //aspect ratio
            let cHeight = availableWidth * aRatio.height / aRatio.width
            return cHeight
        }
        else if (assetSize.width < assetSize.height){
            //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
            let aRatio = CGSize(width: 5, height: 6) //aspect ratio 2:3, 3:4
//            let aRatio = CGSize(width: 3, height: 4)
            let cWidth = availableWidth
            let cHeight = cWidth * aRatio.height / aRatio.width
            return cHeight
        } else {
            //square
            let cWidth = availableWidth
            return cWidth
        }
    }
}

extension PhotoCreatorConsolePanelView: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollview begin: \(scrollView.contentOffset.y)")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollview scroll: ")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        let xOffset = scrollView.contentOffset.x
        let viewWidth = self.frame.width
        let currentIndex = round(xOffset/viewWidth)
        let tempCurrentIndex = Int(currentIndex)
        aaText.text = String(tempCurrentIndex + 1)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("photocreator scrollview animation ended")
        
        let xOffset = scrollView.contentOffset.x
        let viewWidth = self.frame.width
        let currentIndex = round(xOffset/viewWidth)
        let tempCurrentIndex = Int(currentIndex)
        aaText.text = String(tempCurrentIndex + 1)
    }
}

extension PhotoCreatorConsolePanelView: PhotoFinalizePanelDelegate{
    func didInitializePhotoFinalize(){
        
    }
    func didClickFinishPhotoFinalize(){
        
    }
    func didPhotoFinalizeClickUploadSuccess(){
        closePhotoCreatorPanel(isAnimated: true)
    }
}

extension PhotoCreatorConsolePanelView: CameraPhotoRollPanelDelegate{
    func didInitializeCameraPhotoRoll() {

    }
    func didClickFinishCameraPhotoRoll() {
//        backPage()
    }
    func didClickPhotoSelect(photo: PHAsset) {
        print("asset didClickPhotoSelect")
        

    }
    func didClickMultiPhotoSelect(urls: [URL]){
        if(!urls.isEmpty) {
            
            let h = getPhotoHeight()
            scrollViewHeightCons?.constant = h
            
            if(photoViewList.isEmpty) {
                for url in urls {
//                    var gifImage1 = SDAnimatedImageView()
                    var gifImage1 = PhotoClip()
                    gifImage1.contentMode = .scaleAspectFill
                    gifImage1.clipsToBounds = true
                    gifImage1.sd_setImage(with: url)
                    scrollView.addSubview(gifImage1)
                    gifImage1.translatesAutoresizingMaskIntoConstraints = false
                    gifImage1.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true //180
                    gifImage1.heightAnchor.constraint(equalToConstant: h).isActive = true //280
                    gifImage1.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
                    
                    gifImage1.pFrameLeadingCons?.isActive = false
                    if(photoViewList.isEmpty) {
                        gifImage1.pFrameLeadingCons = gifImage1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0)
                    } else {
                        gifImage1.pFrameLeadingCons = gifImage1.leadingAnchor.constraint(equalTo: photoViewList[photoViewList.count - 1].trailingAnchor, constant: 0)
                    }
                    gifImage1.pFrameLeadingCons?.isActive = true
                    
                    photoViewList.append(gifImage1)
                    photoUrlDataList.append(url)
                }
                
                let contentWidth = viewWidth * CGFloat(photoViewList.count)
                scrollView.contentSize = CGSize(width: contentWidth, height: h) //800, 280
                
                aaText.text = String(1)
                acText.text = String(photoViewList.count)
//                let wOffset = viewWidth * CGFloat(photoViewList.count - 1)
//                scrollView.setContentOffset(CGPoint(x: wOffset, y: 0), animated: true)
                if(photoViewList.count > 1) {
                    aBox.isHidden = false
                }
            } else {
                let xOffset = scrollView.contentOffset.x
                let viewWidth = self.frame.width
                let currentIndex = round(xOffset/viewWidth)
                let tempCurrentIndex = Int(currentIndex)
                
                var i = 0
                for url in urls {
                    i += 1
                    
//                    var gifImage1 = SDAnimatedImageView()
                    var gifImage1 = PhotoClip()
                    gifImage1.contentMode = .scaleAspectFill
                    gifImage1.clipsToBounds = true
                    gifImage1.sd_setImage(with: url)
                    scrollView.addSubview(gifImage1)
                    gifImage1.translatesAutoresizingMaskIntoConstraints = false
                    gifImage1.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true //180
                    gifImage1.heightAnchor.constraint(equalToConstant: h).isActive = true //280
                    gifImage1.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
                    gifImage1.pFrameLeadingCons = gifImage1.leadingAnchor.constraint(equalTo: photoViewList[tempCurrentIndex + i - 1].trailingAnchor, constant: 0)
                    gifImage1.pFrameLeadingCons?.isActive = true
                    
                    photoViewList.insert(gifImage1, at: tempCurrentIndex + i)
                    photoUrlDataList.insert(url, at: tempCurrentIndex + i)
                }
                
                if(tempCurrentIndex + i < photoViewList.count - 1) {
                    photoViewList[tempCurrentIndex + i + 1].pFrameLeadingCons?.isActive = false
                    photoViewList[tempCurrentIndex + i + 1].pFrameLeadingCons = photoViewList[tempCurrentIndex + i + 1].leadingAnchor.constraint(equalTo: photoViewList[tempCurrentIndex + i].trailingAnchor, constant: 0)
                    photoViewList[tempCurrentIndex + i + 1].pFrameLeadingCons?.isActive = true
                }
                
                let contentWidth = viewWidth * CGFloat(photoViewList.count)
                scrollView.contentSize = CGSize(width: contentWidth, height: h) //800, 280
                
                acText.text = String(photoViewList.count)
                let wOffset = viewWidth * CGFloat(tempCurrentIndex + i)
                scrollView.setContentOffset(CGPoint(x: wOffset, y: 0), animated: true)
                if(photoViewList.count > 1) {
                    aBox.isHidden = false
                }
            }
        }
        
        //test > ui changes react to changes in number of photos
        reactPhotoUIChange()
    }
}

extension ViewController: PhotoCreatorPanelDelegate{
    func didInitializePhotoCreator() {
        
    }
    
    func didClickFinishPhotoCreator() {
        //test 1 > as not scrollable
        backPage(isCurrentPageScrollable: false)
        
        //test 2 > as scrollable
//        backPage(isCurrentPageScrollable: true)
    }
    
    func didPhotoCreatorClickLocationSelectScrollable() {
        openLocationSelectScrollablePanel()
    }
    
    func didPhotoCreatorClickSignIn(){
        openLoginPanel()
    }
}
