//
//  PostCreatorConsolePanelView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage
import PhotosUI
import Photos

protocol PostCreatorPanelDelegate : AnyObject {
    func didInitializePostCreator()
    func didClickFinishPostCreator()
    func didPostCreatorClickLocationSelectScrollable()
    
    func didPostCreatorClickSignIn()
    func didPostCreatorClickUpload(payload: String)
}

class PostClip {
    var tBox : UIView?
    var tBoxTopCons: NSLayoutConstraint?
    var tBoxBottomCons: NSLayoutConstraint?
    var tBoxHeightCons: NSLayoutConstraint?
    var tvBoxHint : UIView?
    var tBoxType = ""
}

class PostCreatorConsolePanelView: CreatorPanelView{
    
    var panel = UIView()
    var currentPanelTopCons : CGFloat = 0.0
    var panelTopCons: NSLayoutConstraint?
    
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    let bTextView = UITextView()
    let pText = UILabel()
    
    let scrollView = UIScrollView()
    
    weak var delegate : PostCreatorPanelDelegate?
    
    let stackView = UIView()
    let uView = UIView()
//    var boxList = [UIView]()
    var bTextBottomCons: NSLayoutConstraint?
    var bTextHeightCons: NSLayoutConstraint?
    
    let aUpload = UIView()
    let aSaveDraft = UIView()
    let aSpinner = SpinLoader()
    let bSpinner = SpinLoader()
    
    let aText = UILabel()
    
    //test > for stacking multiple media in sequence
    let pMini = UIView()
    let pImage = SDAnimatedImageView()
    let pNameText = UILabel()
    let aBox = UIView() //add location btn
    var aTestArray = [UIView]()
    var pcList = [PostClip]()
    
    let toolPanel = UIView()
    let mainEditPanel = UIView()
    let textEditPanel = UIView()
    let photoEditPanel = UIView()
    
    var scrollViewBottomCons: NSLayoutConstraint?
    
    var selectedPcIndex = -1 //post clip selected index, -1 => not selected
    var isKeyboardUp = false
    
    var textBeforeCursor = ""
    var textAfterCursor = ""
    
    //test > user login/out status
    var isUserLoggedIn = false
    
    var maxSelectLimit = 5
    let maxLimitErrorPanel = UIView()
    let maxLimitText = UILabel()
    
    //test > use pre-designated sound or location
    var predesignatedPlaceList = [String]()
    let aaText = UILabel()
    
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
        aBtn.topAnchor.constraint(equalTo: panel.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        aBtn.layer.cornerRadius = 20
//        aBtn.layer.opacity = 0.3
        aBtn.isUserInteractionEnabled = true
        aBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackPostCreatorPanelClicked)))

//        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_arrow_down_a")?.withRenderingMode(.alwaysTemplate))
        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_close")?.withRenderingMode(.alwaysTemplate))
        bMiniBtn.tintColor = .ddmDarkGrayColor
        panel.addSubview(bMiniBtn)
        bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        bMiniBtn.centerXAnchor.constraint(equalTo: aBtn.centerXAnchor).isActive = true
        bMiniBtn.centerYAnchor.constraint(equalTo: aBtn.centerYAnchor).isActive = true
        bMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        bMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        
        //test > add a scrollview
//        let scrollView = UIScrollView()
        panel.addSubview(scrollView)
//        scrollView.backgroundColor = .blue
        scrollView.backgroundColor = .clear
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let topMargin = 50.0 + topInset
        scrollView.topAnchor.constraint(equalTo: panel.topAnchor, constant: topMargin).isActive = true
//        scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        scrollView.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        let bottomMargin = 90.0 + bottomInset //90 => tool panel height
        scrollViewBottomCons = scrollView.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -bottomMargin)
//        scrollViewBottomCons = scrollView.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -120)
        scrollViewBottomCons?.isActive = true
//        scrollView.showsVerticalScrollIndicator = false
//        scrollView.contentSize = CGSize(width: viewWidth, height: viewHeight - 150)
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = true
        
//        let stackView = UIView()
//        stackView.backgroundColor = .blue
        stackView.backgroundColor = .clear
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        
        stackView.addSubview(uView)
        uView.backgroundColor = .clear
        uView.translatesAutoresizingMaskIntoConstraints = false
        uView.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        uView.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        //test
//        uView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -100).isActive = true //0
        
        //test > composing post
//        let pMini = UIView()
//        eMini.backgroundColor = .ddmBlackOverlayColor
//        pMini.backgroundColor = .white
//        panel.addSubview(pMini)
        uView.addSubview(pMini)
        pMini.translatesAutoresizingMaskIntoConstraints = false
        pMini.topAnchor.constraint(equalTo: uView.topAnchor, constant: 20).isActive = true
        pMini.leadingAnchor.constraint(equalTo: uView.leadingAnchor, constant: 20).isActive = true
        pMini.heightAnchor.constraint(equalToConstant: 40).isActive = true
        pMini.widthAnchor.constraint(equalToConstant: 40).isActive = true
        pMini.layer.cornerRadius = 20
        pMini.layer.opacity = 1.0 //default 0.3

//        let pImageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
//        let pImage = SDAnimatedImageView()
        pImage.contentMode = .scaleAspectFill
        pImage.layer.masksToBounds = true
//        pImage.sd_setImage(with: pImageUrl)
        uView.addSubview(pImage)
        pImage.translatesAutoresizingMaskIntoConstraints = false
        pImage.centerXAnchor.constraint(equalTo: pMini.centerXAnchor).isActive = true
        pImage.centerYAnchor.constraint(equalTo: pMini.centerYAnchor).isActive = true
        pImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        pImage.widthAnchor.constraint(equalToConstant: 40).isActive = true //36
        pImage.layer.cornerRadius = 20
        pImage.backgroundColor = .ddmDarkColor
//        pImage.isUserInteractionEnabled = true
//        pImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onUserClicked)))
        
////        let aGridNameText = UILabel()
//        pNameText.textAlignment = .left
//        pNameText.textColor = .white
////        pNameText.font = .boldSystemFont(ofSize: 14)
//        pNameText.font = .systemFont(ofSize: 14)
////        contentView.addSubview(aGridNameText)
//        uView.addSubview(pNameText)
//        pNameText.translatesAutoresizingMaskIntoConstraints = false
////        aGridNameText.bottomAnchor.constraint(equalTo: aUserPhoto.bottomAnchor).isActive = true
//        pNameText.centerYAnchor.constraint(equalTo: pMini.centerYAnchor).isActive = true
////        pNameText.topAnchor.constraint(equalTo: pMini.topAnchor).isActive = true
//        pNameText.leadingAnchor.constraint(equalTo: pMini.trailingAnchor, constant: 10).isActive = true
////        aGridNameText.text = "Mic1809"
////        pNameText.text = "Michael Kins"
//        pNameText.text = "-"
        
        let abBox = UIView()
//        abBox.backgroundColor = .ddmBlackDark
//        stackView.addSubview(abBox)
        uView.addSubview(abBox)
        abBox.clipsToBounds = true
        abBox.translatesAutoresizingMaskIntoConstraints = false
        abBox.leadingAnchor.constraint(equalTo: pMini.trailingAnchor, constant: 10).isActive = true
        abBox.heightAnchor.constraint(equalToConstant: 30).isActive = true //default: 50
        abBox.centerYAnchor.constraint(equalTo: pMini.centerYAnchor, constant: 0).isActive = true //20
        abBox.layer.cornerRadius = 5
//        abBox.layer.opacity = 0.2 //0.3
        abBox.isUserInteractionEnabled = true
//        abBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPlaceClicked)))
//        abBox.isHidden = true
        
        let bPublicBox = UIView()
        bPublicBox.backgroundColor = .clear //yellow
        abBox.addSubview(bPublicBox)
        bPublicBox.clipsToBounds = true
        bPublicBox.translatesAutoresizingMaskIntoConstraints = false
        bPublicBox.widthAnchor.constraint(equalToConstant: 16).isActive = true //ori: 40
        bPublicBox.heightAnchor.constraint(equalToConstant: 16).isActive = true
//        bPublicBox.centerYAnchor.constraint(equalTo: abBox.centerYAnchor).isActive = true
        bPublicBox.bottomAnchor.constraint(equalTo: abBox.bottomAnchor).isActive = true
        bPublicBox.leadingAnchor.constraint(equalTo: abBox.leadingAnchor, constant: 5).isActive = true //10
        bPublicBox.layer.cornerRadius = 5 //6

        let bGridIcon = UIImageView(image: UIImage(named:"icon_round_lock_open")?.withRenderingMode(.alwaysTemplate))
        bGridIcon.tintColor = .white
//        panel.addSubview(bGridIcon)
        bPublicBox.addSubview(bGridIcon)
        bGridIcon.translatesAutoresizingMaskIntoConstraints = false
        bGridIcon.centerXAnchor.constraint(equalTo: bPublicBox.centerXAnchor).isActive = true
        bGridIcon.centerYAnchor.constraint(equalTo: bPublicBox.centerYAnchor).isActive = true
        bGridIcon.heightAnchor.constraint(equalToConstant: 16).isActive = true
        bGridIcon.widthAnchor.constraint(equalToConstant: 16).isActive = true

        let aPublicText = UILabel()
        aPublicText.textAlignment = .left
        aPublicText.textColor = .white
        aPublicText.font = .boldSystemFont(ofSize: 12)
//        aPublicText.font = .systemFont(ofSize: 12)
//        contentView.addSubview(aGridNameText)
        abBox.addSubview(aPublicText)
        aPublicText.translatesAutoresizingMaskIntoConstraints = false
//        aPublicText.bottomAnchor.constraint(equalTo: aUserPhoto.bottomAnchor).isActive = true
        aPublicText.centerYAnchor.constraint(equalTo: bPublicBox.centerYAnchor).isActive = true
//        aPublicText.topAnchor.constraint(equalTo: pMini.topAnchor).isActive = true
//        aPublicText.trailingAnchor.constraint(equalTo: uView.trailingAnchor, constant: -20).isActive = true
        aPublicText.leadingAnchor.constraint(equalTo: bPublicBox.trailingAnchor, constant: 5).isActive = true
        aPublicText.text = "Public"
        
        let bArrowBtn = UIImageView()
        bArrowBtn.image = UIImage(named:"icon_round_arrow_down")?.withRenderingMode(.alwaysTemplate)
        bArrowBtn.tintColor = .white
        abBox.addSubview(bArrowBtn)
        bArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        bArrowBtn.leadingAnchor.constraint(equalTo: aPublicText.trailingAnchor).isActive = true
        bArrowBtn.centerYAnchor.constraint(equalTo: aPublicText.centerYAnchor).isActive = true
        bArrowBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true //ori 26
        bArrowBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        bArrowBtn.trailingAnchor.constraint(equalTo: abBox.trailingAnchor, constant: 0).isActive = true //-10
        
        //test 2 > design location 2
//        let aBox = UIView()
//        aBox.backgroundColor = .ddmBlackOverlayColor
        aBox.backgroundColor = .ddmBlackDark
        stackView.addSubview(aBox)
        aBox.clipsToBounds = true
        aBox.translatesAutoresizingMaskIntoConstraints = false
        aBox.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20).isActive = true
        aBox.heightAnchor.constraint(equalToConstant: 30).isActive = true //default: 50
        aBox.topAnchor.constraint(equalTo: uView.bottomAnchor, constant: 40).isActive = true //20
        aBox.layer.cornerRadius = 5
//        aBox.layer.opacity = 0.2 //0.3
        aBox.isUserInteractionEnabled = true
//        aBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPlaceClicked)))
        aBox.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -40).isActive = true //-20
        aBox.isHidden = true
        
        let bBox = UIView()
        bBox.backgroundColor = .clear //yellow
        aBox.addSubview(bBox)
        bBox.clipsToBounds = true
        bBox.translatesAutoresizingMaskIntoConstraints = false
        bBox.widthAnchor.constraint(equalToConstant: 16).isActive = true //ori: 40
        bBox.heightAnchor.constraint(equalToConstant: 16).isActive = true
        bBox.centerYAnchor.constraint(equalTo: aBox.centerYAnchor).isActive = true
        bBox.leadingAnchor.constraint(equalTo: aBox.leadingAnchor, constant: 5).isActive = true //10
        bBox.layer.cornerRadius = 5 //6

        let gridViewBtn = UIImageView(image: UIImage(named:"icon_location")?.withRenderingMode(.alwaysTemplate))
//        let gridViewBtn = UIImageView(image: UIImage(named:"icon_round_location")?.withRenderingMode(.alwaysTemplate))
//        gridViewBtn.tintColor = .black
        gridViewBtn.tintColor = .white
        bBox.addSubview(gridViewBtn)
        gridViewBtn.translatesAutoresizingMaskIntoConstraints = false
        gridViewBtn.centerXAnchor.constraint(equalTo: bBox.centerXAnchor).isActive = true
        gridViewBtn.centerYAnchor.constraint(equalTo: bBox.centerYAnchor).isActive = true
        gridViewBtn.heightAnchor.constraint(equalToConstant: 16).isActive = true
        gridViewBtn.widthAnchor.constraint(equalToConstant: 16).isActive = true
//        gridViewBtn.layer.opacity = 0.5

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
        aaText.leadingAnchor.constraint(equalTo: bBox.trailingAnchor, constant: 5).isActive = true //10
//        aaText.trailingAnchor.constraint(equalTo: aBox.trailingAnchor, constant: -10).isActive = true
        aaText.text = "Add Location"
//        aaText.layer.opacity = 0.5

        let aArrowBtn = UIImageView()
        aArrowBtn.image = UIImage(named:"icon_round_arrow_down")?.withRenderingMode(.alwaysTemplate)
        aArrowBtn.tintColor = .white
        aBox.addSubview(aArrowBtn)
        aArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        aArrowBtn.leadingAnchor.constraint(equalTo: aaText.trailingAnchor).isActive = true
        aArrowBtn.centerYAnchor.constraint(equalTo: bBox.centerYAnchor).isActive = true
        aArrowBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true //ori 26
        aArrowBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        aArrowBtn.trailingAnchor.constraint(equalTo: aBox.trailingAnchor, constant: 0).isActive = true //-10
//        aArrowBtn.isHidden = true
        
        //test > post upload btn
//        let aUpload = UIView()
        aUpload.backgroundColor = .yellow
        panel.addSubview(aUpload)
//        stack2.addSubview(aUpload)
        aUpload.translatesAutoresizingMaskIntoConstraints = false
        aUpload.heightAnchor.constraint(equalToConstant: 30).isActive = true //30
        aUpload.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -10).isActive = true
//        aUpload.topAnchor.constraint(equalTo: panel.topAnchor, constant: 50).isActive = true
//        aUpload.leadingAnchor.constraint(equalTo: stack2.leadingAnchor, constant: 10).isActive = true
//        aUpload.trailingAnchor.constraint(equalTo: stack2.trailingAnchor, constant: 0).isActive = true
        aUpload.centerYAnchor.constraint(equalTo: aBtn.centerYAnchor).isActive = true
        aUpload.layer.cornerRadius = 10
        aUpload.isUserInteractionEnabled = true
        aUpload.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPostUploadNextClicked)))

        let aUploadText = UILabel()
        aUploadText.textAlignment = .center
        aUploadText.textColor = .black
        aUploadText.font = .boldSystemFont(ofSize: 13)
        panel.addSubview(aUploadText)
//        aUpload.addSubview(aUploadText)
        aUploadText.translatesAutoresizingMaskIntoConstraints = false
//        aUploadText.centerXAnchor.constraint(equalTo: aUpload.centerXAnchor).isActive = true
        aUploadText.centerYAnchor.constraint(equalTo: aUpload.centerYAnchor).isActive = true
        aUploadText.leadingAnchor.constraint(equalTo: aUpload.leadingAnchor, constant: 25).isActive = true
        aUploadText.trailingAnchor.constraint(equalTo: aUpload.trailingAnchor, constant: -25).isActive = true
        aUploadText.text = "Post"
        
        panel.addSubview(aSpinner)
        aSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        aSpinner.translatesAutoresizingMaskIntoConstraints = false
        aSpinner.centerYAnchor.constraint(equalTo: aUpload.centerYAnchor).isActive = true
        aSpinner.centerXAnchor.constraint(equalTo: aUpload.centerXAnchor).isActive = true
        aSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        aSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        aSpinner.isUserInteractionEnabled = false
        
//        let aSaveDraft = UIView()
        aSaveDraft.backgroundColor = .ddmDarkColor
        panel.addSubview(aSaveDraft)
//        stack1.addSubview(aSaveDraft)
        aSaveDraft.translatesAutoresizingMaskIntoConstraints = false
        aSaveDraft.heightAnchor.constraint(equalToConstant: 30).isActive = true //30
        aSaveDraft.trailingAnchor.constraint(equalTo: aUpload.leadingAnchor, constant: -10).isActive = true
        aSaveDraft.centerYAnchor.constraint(equalTo: aUpload.centerYAnchor).isActive = true
        aSaveDraft.layer.cornerRadius = 10
        aSaveDraft.isUserInteractionEnabled = true
        aSaveDraft.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSaveDraftNextClicked)))
        aSaveDraft.isHidden = true

        let aSaveDraftText = UILabel()
        aSaveDraftText.textAlignment = .center
        aSaveDraftText.textColor = .white
        aSaveDraftText.font = .boldSystemFont(ofSize: 13)
//        panel.addSubview(aSaveDraftText)
        aSaveDraft.addSubview(aSaveDraftText)
        aSaveDraftText.translatesAutoresizingMaskIntoConstraints = false
//        aSaveDraftText.centerXAnchor.constraint(equalTo: aSaveDraft.centerXAnchor).isActive = true
        aSaveDraftText.centerYAnchor.constraint(equalTo: aSaveDraft.centerYAnchor).isActive = true
        aSaveDraftText.leadingAnchor.constraint(equalTo: aSaveDraft.leadingAnchor, constant: 15).isActive = true
        aSaveDraftText.trailingAnchor.constraint(equalTo: aSaveDraft.trailingAnchor, constant: -15).isActive = true
        aSaveDraftText.text = "Save Draft"
        
        panel.addSubview(bSpinner)
        bSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        bSpinner.translatesAutoresizingMaskIntoConstraints = false
        bSpinner.centerYAnchor.constraint(equalTo: aSaveDraft.centerYAnchor).isActive = true
        bSpinner.centerXAnchor.constraint(equalTo: aSaveDraft.centerXAnchor).isActive = true
        bSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        bSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        bSpinner.isUserInteractionEnabled = false
        
        let draftBox = UIView()
        draftBox.backgroundColor = .ddmDarkColor
        panel.addSubview(draftBox)
//        stack1.addSubview(aSaveDraft)
        draftBox.translatesAutoresizingMaskIntoConstraints = false
        draftBox.heightAnchor.constraint(equalToConstant: 30).isActive = true //30
        draftBox.trailingAnchor.constraint(equalTo: aSaveDraft.leadingAnchor, constant: -10).isActive = true
        draftBox.centerYAnchor.constraint(equalTo: aSaveDraft.centerYAnchor).isActive = true
        draftBox.layer.cornerRadius = 10
        draftBox.isUserInteractionEnabled = true
        draftBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onDraftBoxClicked)))
        draftBox.isHidden = true
        
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
        
        //**test > tools panel
        toolPanel.backgroundColor = .ddmBlackOverlayColor //black
//        toolPanel.backgroundColor = .black //black
        panel.addSubview(toolPanel)
        toolPanel.translatesAutoresizingMaskIntoConstraints = false
//        toolPanel.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: 0).isActive = true
//        toolPanel.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -bottomInset).isActive = true
        toolPanel.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 0).isActive = true
        toolPanel.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: 0).isActive = true
        toolPanel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        toolPanel.layer.cornerRadius = 0
        toolPanel.heightAnchor.constraint(equalToConstant: 90).isActive = true //120
        
        let toolPanelBg = UIView()
//        toolPanelBg.backgroundColor = .ddmDarkColor //black
//        toolPanelBg.layer.opacity = 0.1
        toolPanel.addSubview(toolPanelBg)
        toolPanelBg.translatesAutoresizingMaskIntoConstraints = false
        toolPanelBg.bottomAnchor.constraint(equalTo: toolPanel.bottomAnchor, constant: 0).isActive = true
        toolPanelBg.topAnchor.constraint(equalTo: toolPanel.topAnchor, constant: 0).isActive = true
        toolPanelBg.leadingAnchor.constraint(equalTo: toolPanel.leadingAnchor, constant: 0).isActive = true
        toolPanelBg.trailingAnchor.constraint(equalTo: toolPanel.trailingAnchor, constant: 0).isActive = true
        
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
        mainXGrid.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMainAddTextClicked)))

        let mainXGridIcon = UIImageView(image: UIImage(named:"icon_round_textfield")?.withRenderingMode(.alwaysTemplate))
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
        mainXGridText.text = "Text"
        
        let mainYGrid = UIView()
        mainEditPanel.addSubview(mainYGrid)
        mainYGrid.backgroundColor = .ddmDarkColor
        mainYGrid.translatesAutoresizingMaskIntoConstraints = false
        mainYGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        mainYGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
        mainYGrid.leadingAnchor.constraint(equalTo: mainXGrid.trailingAnchor, constant: 20).isActive = true //10
        mainYGrid.topAnchor.constraint(equalTo: mainEditPanel.topAnchor, constant: 10).isActive = true
//        mainYGrid.centerYAnchor.constraint(equalTo: mainXGrid.centerYAnchor, constant: 0).isActive = true
        mainYGrid.layer.cornerRadius = 20 //10
        mainYGrid.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMainAddPhotoClicked)))

        let mainYGridIcon = UIImageView(image: UIImage(named:"icon_outline_photo")?.withRenderingMode(.alwaysTemplate))
        mainYGridIcon.tintColor = .white
//        uView.addSubview(xGridIcon)
        mainEditPanel.addSubview(mainYGridIcon)
        mainYGridIcon.translatesAutoresizingMaskIntoConstraints = false
        mainYGridIcon.centerXAnchor.constraint(equalTo: mainYGrid.centerXAnchor, constant: 0).isActive = true
        mainYGridIcon.centerYAnchor.constraint(equalTo: mainYGrid.centerYAnchor, constant: 0).isActive = true
        mainYGridIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true //26
        mainYGridIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let mainYGridText = UILabel()
        mainYGridText.textAlignment = .center
        mainYGridText.textColor = .white
        mainYGridText.font = .boldSystemFont(ofSize: 10)
        mainEditPanel.addSubview(mainYGridText)
        mainYGridText.translatesAutoresizingMaskIntoConstraints = false
        mainYGridText.topAnchor.constraint(equalTo: mainYGrid.bottomAnchor, constant: 2).isActive = true
        mainYGridText.centerXAnchor.constraint(equalTo: mainYGrid.centerXAnchor).isActive = true
        mainYGridText.text = "Photo"
        
        let mainZGrid = UIView()
        mainEditPanel.addSubview(mainZGrid)
        mainZGrid.backgroundColor = .ddmDarkColor
        mainZGrid.translatesAutoresizingMaskIntoConstraints = false
        mainZGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        mainZGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
        mainZGrid.leadingAnchor.constraint(equalTo: mainYGrid.trailingAnchor, constant: 20).isActive = true //10
        mainZGrid.topAnchor.constraint(equalTo: mainEditPanel.topAnchor, constant: 10).isActive = true
//        mainZGrid.centerYAnchor.constraint(equalTo: mainXGrid.centerYAnchor, constant: 0).isActive = true
        mainZGrid.layer.cornerRadius = 20 //10
        mainZGrid.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMainEmbedClicked)))
        
        let mainZGridIcon = UIImageView(image: UIImage(named:"icon_round_code")?.withRenderingMode(.alwaysTemplate))
        mainZGridIcon.tintColor = .white
//        uView.addSubview(xGridIcon)
        mainEditPanel.addSubview(mainZGridIcon)
        mainZGridIcon.translatesAutoresizingMaskIntoConstraints = false
        mainZGridIcon.centerXAnchor.constraint(equalTo: mainZGrid.centerXAnchor, constant: 0).isActive = true
        mainZGridIcon.centerYAnchor.constraint(equalTo: mainZGrid.centerYAnchor, constant: 0).isActive = true
        mainZGridIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true //26
        mainZGridIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let mainZGridText = UILabel()
        mainZGridText.textAlignment = .center
        mainZGridText.textColor = .white
        mainZGridText.font = .boldSystemFont(ofSize: 10)
        mainEditPanel.addSubview(mainZGridText)
        mainZGridText.translatesAutoresizingMaskIntoConstraints = false
        mainZGridText.topAnchor.constraint(equalTo: mainZGrid.bottomAnchor, constant: 2).isActive = true
        mainZGridText.centerXAnchor.constraint(equalTo: mainZGrid.centerXAnchor).isActive = true
        mainZGridText.text = "Embed"
        
//        let photoEditPanel = UIView()
        toolPanel.addSubview(photoEditPanel)
        photoEditPanel.translatesAutoresizingMaskIntoConstraints = false
        photoEditPanel.bottomAnchor.constraint(equalTo: toolPanel.bottomAnchor, constant: 0).isActive = true
        photoEditPanel.topAnchor.constraint(equalTo: toolPanel.topAnchor, constant: 0).isActive = true
        photoEditPanel.leadingAnchor.constraint(equalTo: toolPanel.leadingAnchor, constant: 0).isActive = true
        photoEditPanel.trailingAnchor.constraint(equalTo: toolPanel.trailingAnchor, constant: 0).isActive = true
        photoEditPanel.isHidden = true
        
        let backVcGrid = UIView() //edit vc
        backVcGrid.backgroundColor = .ddmDarkColor
        photoEditPanel.addSubview(backVcGrid)
        backVcGrid.translatesAutoresizingMaskIntoConstraints = false
        backVcGrid.leadingAnchor.constraint(equalTo: photoEditPanel.leadingAnchor, constant: 20).isActive = true
        backVcGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backVcGrid.widthAnchor.constraint(equalToConstant: 25).isActive = true
        backVcGrid.topAnchor.constraint(equalTo: photoEditPanel.topAnchor, constant: 10).isActive = true
//        backVcGrid.centerYAnchor.constraint(equalTo: photoEditPanel.centerYAnchor, constant: 0).isActive = true
        backVcGrid.layer.cornerRadius = 10
        backVcGrid.isUserInteractionEnabled = true
        backVcGrid.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPhotoNextClicked)))
        
        let backVcMiniBtn = UIImageView(image: UIImage(named:"icon_round_arrow_left")?.withRenderingMode(.alwaysTemplate))
        backVcMiniBtn.tintColor = .white
        photoEditPanel.addSubview(backVcMiniBtn)
        backVcMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        backVcMiniBtn.centerXAnchor.constraint(equalTo: backVcGrid.centerXAnchor).isActive = true
        backVcMiniBtn.centerYAnchor.constraint(equalTo: backVcGrid.centerYAnchor).isActive = true
        backVcMiniBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        backVcMiniBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let photoXGrid = UIView()
        photoEditPanel.addSubview(photoXGrid)
        photoXGrid.backgroundColor = .ddmDarkColor
        photoXGrid.translatesAutoresizingMaskIntoConstraints = false
        photoXGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        photoXGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
        photoXGrid.leadingAnchor.constraint(equalTo: backVcGrid.trailingAnchor, constant: 40).isActive = true
        photoXGrid.topAnchor.constraint(equalTo: photoEditPanel.topAnchor, constant: 10).isActive = true
//        photoXGrid.centerYAnchor.constraint(equalTo: photoEditPanel.centerYAnchor, constant: 0).isActive = true
        photoXGrid.layer.cornerRadius = 20 //10
        photoXGrid.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPhotoAddTextClicked)))

//        let photoXGridIcon = UIImageView(image: UIImage(named:"icon_round_textfield")?.withRenderingMode(.alwaysTemplate))
        let photoXGridIcon = UIImageView(image: UIImage(named:"icon_round_swap")?.withRenderingMode(.alwaysTemplate))
        photoXGridIcon.tintColor = .white
//        uView.addSubview(xGridIcon)
        photoEditPanel.addSubview(photoXGridIcon)
        photoXGridIcon.translatesAutoresizingMaskIntoConstraints = false
//        photoXGridIcon.centerXAnchor.constraint(equalTo: pMini.centerXAnchor, constant: 0).isActive = true
//        photoXGridIcon.bottomAnchor.constraint(equalTo: divider.topAnchor, constant: 0).isActive = true
        photoXGridIcon.centerXAnchor.constraint(equalTo: photoXGrid.centerXAnchor, constant: 0).isActive = true
        photoXGridIcon.centerYAnchor.constraint(equalTo: photoXGrid.centerYAnchor, constant: 0).isActive = true
        photoXGridIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true //26
        photoXGridIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let photoXGridText = UILabel()
        photoXGridText.textAlignment = .center
        photoXGridText.textColor = .white
        photoXGridText.font = .boldSystemFont(ofSize: 10)
        photoEditPanel.addSubview(photoXGridText)
        photoXGridText.translatesAutoresizingMaskIntoConstraints = false
        photoXGridText.topAnchor.constraint(equalTo: photoXGrid.bottomAnchor, constant: 2).isActive = true
        photoXGridText.centerXAnchor.constraint(equalTo: photoXGrid.centerXAnchor).isActive = true
        photoXGridText.text = "Layout"
        
        let photoYGrid = UIView()
        photoEditPanel.addSubview(photoYGrid)
        photoYGrid.backgroundColor = .ddmDarkColor
        photoYGrid.translatesAutoresizingMaskIntoConstraints = false
        photoYGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        photoYGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
        photoYGrid.leadingAnchor.constraint(equalTo: photoXGrid.trailingAnchor, constant: 20).isActive = true //0
        photoYGrid.topAnchor.constraint(equalTo: photoEditPanel.topAnchor, constant: 10).isActive = true
//        photoYGrid.centerYAnchor.constraint(equalTo: photoXGrid.centerYAnchor, constant: 0).isActive = true
        photoYGrid.layer.cornerRadius = 20 //10
        photoYGrid.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPhotoAddPhotoClicked)))

//        let photoYGridIcon = UIImageView(image: UIImage(named:"icon_outline_photo")?.withRenderingMode(.alwaysTemplate))
        let photoYGridIcon = UIImageView(image: UIImage(named:"icon_round_add_v")?.withRenderingMode(.alwaysTemplate))
        photoYGridIcon.tintColor = .white
//        uView.addSubview(xGridIcon)
        photoEditPanel.addSubview(photoYGridIcon)
        photoYGridIcon.translatesAutoresizingMaskIntoConstraints = false
        photoYGridIcon.centerXAnchor.constraint(equalTo: photoYGrid.centerXAnchor, constant: 0).isActive = true
        photoYGridIcon.centerYAnchor.constraint(equalTo: photoYGrid.centerYAnchor, constant: 0).isActive = true
        photoYGridIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true //26
        photoYGridIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let photoYGridText = UILabel()
        photoYGridText.textAlignment = .center
        photoYGridText.textColor = .white
        photoYGridText.font = .boldSystemFont(ofSize: 10)
        photoEditPanel.addSubview(photoYGridText)
        photoYGridText.translatesAutoresizingMaskIntoConstraints = false
        photoYGridText.topAnchor.constraint(equalTo: photoYGrid.bottomAnchor, constant: 2).isActive = true
        photoYGridText.centerXAnchor.constraint(equalTo: photoYGrid.centerXAnchor).isActive = true
        photoYGridText.text = "Add Photo"
        
        let photoVGrid = UIView() //delete vc
//        photoVGrid.backgroundColor = .ddmDarkColor
        photoVGrid.backgroundColor = .red
        photoEditPanel.addSubview(photoVGrid)
        photoVGrid.translatesAutoresizingMaskIntoConstraints = false
        photoVGrid.trailingAnchor.constraint(equalTo: photoEditPanel.trailingAnchor, constant: -20).isActive = true
//        photoVGrid.leadingAnchor.constraint(equalTo: photoYGrid.trailingAnchor, constant: 10).isActive = true //0
        photoVGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        photoVGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
        photoVGrid.topAnchor.constraint(equalTo: photoEditPanel.topAnchor, constant: 10).isActive = true
//        photoVGrid.centerYAnchor.constraint(equalTo: photoEditPanel.centerYAnchor, constant: 0).isActive = true
        photoVGrid.layer.cornerRadius = 20 //10
        photoVGrid.layer.opacity = 0.5
        photoVGrid.isUserInteractionEnabled = true
        photoVGrid.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPhotoDeleteSectionClicked)))

        let photoVGridIcon = UIImageView(image: UIImage(named:"icon_round_delete")?.withRenderingMode(.alwaysTemplate))
        photoVGridIcon.tintColor = .white
        photoEditPanel.addSubview(photoVGridIcon)
        photoVGridIcon.translatesAutoresizingMaskIntoConstraints = false
        photoVGridIcon.centerXAnchor.constraint(equalTo: photoVGrid.centerXAnchor).isActive = true
        photoVGridIcon.centerYAnchor.constraint(equalTo: photoVGrid.centerYAnchor).isActive = true
        photoVGridIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        photoVGridIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let photoVGridText = UILabel()
        photoVGridText.textAlignment = .center
        photoVGridText.textColor = .white
        photoVGridText.font = .boldSystemFont(ofSize: 10)
        photoEditPanel.addSubview(photoVGridText)
        photoVGridText.translatesAutoresizingMaskIntoConstraints = false
        photoVGridText.topAnchor.constraint(equalTo: photoVGrid.bottomAnchor, constant: 2).isActive = true
        photoVGridText.centerXAnchor.constraint(equalTo: photoVGrid.centerXAnchor).isActive = true
        photoVGridText.text = "Delete"
        
        let aPhotoOK = UIView()
        aPhotoOK.backgroundColor = .yellow
        photoEditPanel.addSubview(aPhotoOK)
        aPhotoOK.translatesAutoresizingMaskIntoConstraints = false
        aPhotoOK.trailingAnchor.constraint(equalTo: photoEditPanel.trailingAnchor, constant: -20).isActive = true
        aPhotoOK.heightAnchor.constraint(equalToConstant: 30).isActive = true
        aPhotoOK.widthAnchor.constraint(equalToConstant: 30).isActive = true
        aPhotoOK.topAnchor.constraint(equalTo: photoEditPanel.topAnchor, constant: 10).isActive = true
//        aPhotoOK.centerYAnchor.constraint(equalTo: photoEditPanel.centerYAnchor, constant: 0).isActive = true
        aPhotoOK.layer.cornerRadius = 15
        aPhotoOK.isUserInteractionEnabled = true
        aPhotoOK.isHidden = true
        aPhotoOK.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPhotoNextClicked)))
        
        let aPhotoOKMiniBtn = UIImageView(image: UIImage(named:"icon_round_done")?.withRenderingMode(.alwaysTemplate))
        aPhotoOKMiniBtn.tintColor = .black
        aPhotoOK.addSubview(aPhotoOKMiniBtn)
        aPhotoOKMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        aPhotoOKMiniBtn.centerXAnchor.constraint(equalTo: aPhotoOK.centerXAnchor).isActive = true
        aPhotoOKMiniBtn.centerYAnchor.constraint(equalTo: aPhotoOK.centerYAnchor).isActive = true
        aPhotoOKMiniBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        aPhotoOKMiniBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
//        textEditPanel.backgroundColor = .ddmBlackOverlayColor //black
//        textEditPanel.backgroundColor = .ddmBlackDark
        panel.addSubview(textEditPanel)
        textEditPanel.translatesAutoresizingMaskIntoConstraints = false
        textEditPanel.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: 0).isActive = true
//        textEditPanel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        textEditPanel.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 0).isActive = true
        textEditPanel.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: 0).isActive = true
        textEditPanel.layer.cornerRadius = 0
        textEditPanel.heightAnchor.constraint(equalToConstant: 60).isActive = true //60
        textEditPanel.isHidden = true
        
//        let textToolPanelBg = UIView()
//        textToolPanelBg.backgroundColor = .ddmDarkColor //black
////        textToolPanelBg.backgroundColor = .black //black
//        textToolPanelBg.layer.opacity = 0.1
//        textEditPanel.addSubview(textToolPanelBg)
//        textToolPanelBg.translatesAutoresizingMaskIntoConstraints = false
//        textToolPanelBg.bottomAnchor.constraint(equalTo: textEditPanel.bottomAnchor, constant: 0).isActive = true
//        textToolPanelBg.topAnchor.constraint(equalTo: textEditPanel.topAnchor, constant: 0).isActive = true
//        textToolPanelBg.leadingAnchor.constraint(equalTo: textEditPanel.leadingAnchor, constant: 0).isActive = true
//        textToolPanelBg.trailingAnchor.constraint(equalTo: textEditPanel.trailingAnchor, constant: 0).isActive = true
        
        //test 2 > like in comment => lighter, but not advanced enough
        let xGrid = UIView()
        textEditPanel.addSubview(xGrid)
        xGrid.backgroundColor = .ddmDarkColor
        xGrid.translatesAutoresizingMaskIntoConstraints = false
        xGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        xGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        xGrid.centerXAnchor.constraint(equalTo: pMini.centerXAnchor, constant: 0).isActive = true
        xGrid.leadingAnchor.constraint(equalTo: textEditPanel.leadingAnchor, constant: 20).isActive = true
//        xGrid.bottomAnchor.constraint(equalTo: divider.topAnchor, constant: 0).isActive = true
        xGrid.centerYAnchor.constraint(equalTo: textEditPanel.centerYAnchor, constant: 0).isActive = true
        xGrid.layer.cornerRadius = 20 //10
        xGrid.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTextAtClicked)))

        let xGridIcon = UIImageView(image: UIImage(named:"icon_round_at")?.withRenderingMode(.alwaysTemplate))
        xGridIcon.tintColor = .white
//        uView.addSubview(xGridIcon)
        textEditPanel.addSubview(xGridIcon)
        xGridIcon.translatesAutoresizingMaskIntoConstraints = false
//        xGridIcon.centerXAnchor.constraint(equalTo: pMini.centerXAnchor, constant: 0).isActive = true
//        xGridIcon.bottomAnchor.constraint(equalTo: divider.topAnchor, constant: 0).isActive = true
        xGridIcon.centerXAnchor.constraint(equalTo: xGrid.centerXAnchor, constant: 0).isActive = true
        xGridIcon.centerYAnchor.constraint(equalTo: xGrid.centerYAnchor, constant: 0).isActive = true
        xGridIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true //26
        xGridIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        xGridIcon.layer.opacity = 0.5

        let yGrid = UIView()
//        uView.addSubview(yGrid)
        textEditPanel.addSubview(yGrid)
        yGrid.backgroundColor = .ddmDarkColor
        yGrid.translatesAutoresizingMaskIntoConstraints = false
        yGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        yGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
        yGrid.leadingAnchor.constraint(equalTo: xGrid.trailingAnchor, constant: 10).isActive = true //0
        yGrid.centerYAnchor.constraint(equalTo: xGrid.centerYAnchor, constant: 0).isActive = true
        yGrid.layer.cornerRadius = 20 //10
        yGrid.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTextHashtagClicked)))
        
        let yGridIcon = UIImageView(image: UIImage(named:"icon_round_hashtag")?.withRenderingMode(.alwaysTemplate))
        yGridIcon.tintColor = .white
//        uView.addSubview(yGridIcon)
        textEditPanel.addSubview(yGridIcon)
        yGridIcon.translatesAutoresizingMaskIntoConstraints = false
//        yGridIcon.leadingAnchor.constraint(equalTo: xGridIcon.trailingAnchor, constant: 15).isActive = true
//        yGridIcon.centerYAnchor.constraint(equalTo: xGridIcon.centerYAnchor, constant: 0).isActive = true
        yGridIcon.centerXAnchor.constraint(equalTo: yGrid.centerXAnchor, constant: 0).isActive = true
        yGridIcon.centerYAnchor.constraint(equalTo: yGrid.centerYAnchor, constant: 0).isActive = true
        yGridIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true //26
        yGridIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        yGridIcon.layer.opacity = 0.5

        let zGrid = UIView()
//        uView.addSubview(zGrid)
        textEditPanel.addSubview(zGrid)
        zGrid.backgroundColor = .ddmDarkColor
        zGrid.translatesAutoresizingMaskIntoConstraints = false
        zGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        zGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
        zGrid.leadingAnchor.constraint(equalTo: yGrid.trailingAnchor, constant: 10).isActive = true //0
        zGrid.centerYAnchor.constraint(equalTo: yGrid.centerYAnchor, constant: 0).isActive = true
        zGrid.layer.cornerRadius = 20 //10
        zGrid.isUserInteractionEnabled = true
        zGrid.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTextAddPhotoClicked)))

//        let zGridIcon = UIImageView(image: UIImage(named:"icon_round_photo")?.withRenderingMode(.alwaysTemplate))
        let zGridIcon = UIImageView(image: UIImage(named:"icon_outline_photo")?.withRenderingMode(.alwaysTemplate))
        zGridIcon.tintColor = .white
//        uView.addSubview(zGridIcon)
        textEditPanel.addSubview(zGridIcon)
        zGridIcon.translatesAutoresizingMaskIntoConstraints = false
//        zGridIcon.leadingAnchor.constraint(equalTo: yGridIcon.trailingAnchor, constant: 15).isActive = true
//        zGridIcon.centerYAnchor.constraint(equalTo: xGridIcon.centerYAnchor, constant: 0).isActive = true
        zGridIcon.centerXAnchor.constraint(equalTo: zGrid.centerXAnchor, constant: 0).isActive = true
        zGridIcon.centerYAnchor.constraint(equalTo: zGrid.centerYAnchor, constant: 0).isActive = true
        zGridIcon.heightAnchor.constraint(equalToConstant: 22).isActive = true //28
        zGridIcon.widthAnchor.constraint(equalToConstant: 22).isActive = true
//        zGridIcon.layer.opacity = 0.5
        
        let aTextOK = UIView()
        aTextOK.backgroundColor = .yellow
        textEditPanel.addSubview(aTextOK)
        aTextOK.translatesAutoresizingMaskIntoConstraints = false
        aTextOK.trailingAnchor.constraint(equalTo: textEditPanel.trailingAnchor, constant: -20).isActive = true
        aTextOK.heightAnchor.constraint(equalToConstant: 30).isActive = true
        aTextOK.widthAnchor.constraint(equalToConstant: 30).isActive = true
        aTextOK.centerYAnchor.constraint(equalTo: textEditPanel.centerYAnchor, constant: 0).isActive = true
        aTextOK.layer.cornerRadius = 15
        aTextOK.isUserInteractionEnabled = true
        aTextOK.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTextNextClicked)))
//        aTextOK.isHidden = true
        
        let aTextOKMiniBtn = UIImageView(image: UIImage(named:"icon_round_done")?.withRenderingMode(.alwaysTemplate))
        aTextOKMiniBtn.tintColor = .black
        aTextOK.addSubview(aTextOKMiniBtn)
        aTextOKMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        aTextOKMiniBtn.centerXAnchor.constraint(equalTo: aTextOK.centerXAnchor).isActive = true
        aTextOKMiniBtn.centerYAnchor.constraint(equalTo: aTextOK.centerYAnchor).isActive = true
        aTextOKMiniBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        aTextOKMiniBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        //test > error handling max selected limit
//        maxLimitErrorPanel.backgroundColor = .ddmBlackOverlayColor //black
        maxLimitErrorPanel.backgroundColor = .white //black
        panel.addSubview(maxLimitErrorPanel)
        maxLimitErrorPanel.translatesAutoresizingMaskIntoConstraints = false
        maxLimitErrorPanel.centerXAnchor.constraint(equalTo: panel.centerXAnchor, constant: 0).isActive = true
        maxLimitErrorPanel.layer.cornerRadius = 10
        maxLimitErrorPanel.topAnchor.constraint(equalTo: aUpload.bottomAnchor, constant: 10).isActive = true
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
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(onKeyboardWillChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        //**
    
    }
    
    //test
    override func showLocationSelected() {
        aText.text = mapPinString
        print("showLocationSelected")
    }
    
    //test
    override func resumeActiveState() {
        print("postcreatorpanelview resume active")
        
        //test > check for signin status when in active state
        asyncFetchSigninStatus()
    }
    
    //test > initialization state
    var isInitialized = false
    var topInset = 0.0
    var bottomInset = 0.0
    func initialize(topInset: CGFloat, bottomInset: CGFloat) {
        
        //test 2 > without isInitialized
        self.topInset = topInset
        self.bottomInset = bottomInset
        
        redrawUI()

        //test
        asyncFetchSigninStatus()
    }
    
    //test
    func initialize() {
        if(!isInitialized) {
            if(isUserLoggedIn) {
                let pImageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
                pImage.sd_setImage(with: pImageUrl)
                pNameText.text = "Michael Kins"
                
                //test > add first textview
                addTextSection(i: 0, extraContentSize: 0.0, textToAdd: "")
                
                aBox.isHidden = false //show add location
            } else {
                let pImageUrl = URL(string: "")
                pImage.sd_setImage(with: pImageUrl)
                pNameText.text = "-"
                
                aBox.isHidden = true //hide add location
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
    
    func setPredesignatedPlace(p: String) {
        predesignatedPlaceList.append("p")
        refreshTitleUI()
    }
    
    func refreshTitleUI(){
        aaText.text = "Add Location"
        
        if(!predesignatedPlaceList.isEmpty) {
            aaText.text = "Petronas Twin Tower"
        }
    }

    func setFirstResponder(textView: UITextView) {
        textView.becomeFirstResponder()
    }
    
    func resignResponder() {
        self.endEditing(true)
        
        //test > change toolpanel UI
//        self.toolPanel.transform = CGAffineTransform(translationX: 0, y: 0)
        self.textEditPanel.transform = CGAffineTransform(translationX: 0, y: 0)
        
        //shift scrollview down
        let bottomMargin = 90.0 + bottomInset //60
        scrollViewBottomCons?.constant = -bottomMargin
//        scrollViewBottomCons?.constant = -120
        
        isKeyboardUp = false
//        keyboardHeight = 0.0 //test > save keyboardheight as constant
        
        mainEditPanel.isHidden = false
        textEditPanel.isHidden = true
        photoEditPanel.isHidden = true
        
        //test
        textBeforeCursor = ""
        textAfterCursor = ""
    }
    
    func closePostCreatorPanel(isAnimated: Bool) {
        if(isAnimated) {
            UIView.animate(withDuration: 0.2, animations: { //default: 0.2
                self.panelTopCons?.constant = 0
                self.layoutIfNeeded()
            }, completion: { _ in
                self.removeFromSuperview()
                
                self.delegate?.didClickFinishPostCreator()
            })
        } else {
            self.removeFromSuperview()
            
            self.delegate?.didClickFinishPostCreator()
        }
    }
    
    @objc func onAGridClicked(gesture: UITapGestureRecognizer) {
        //test 2
        clearErrorUI()
        resignResponder()
        delegate?.didPostCreatorClickLocationSelectScrollable()
    }
    
    @objc func onMainAddTextClicked(gesture: UITapGestureRecognizer) {
        
        clearErrorUI()
        
        let isSignedIn = SignInManager.shared.getStatus()
        if(isSignedIn) {
            if(!pcList.isEmpty) {
                if(pcList[pcList.count - 1].tBoxType != "t") {
                    addTextSection(i: pcList.count - 1, extraContentSize: 0.0, textToAdd: "")
                } else {
                    if let aTBox = pcList[pcList.count - 1].tBox as? UITextView {
                        setFirstResponder(textView: aTBox)
                    }
                }
            }
        }
        else {
            delegate?.didPostCreatorClickSignIn()
        }
    }
    @objc func onMainAddPhotoClicked(gesture: UITapGestureRecognizer) {
        //test 3 > add photo at the end
        clearErrorUI()
        
        let isSignedIn = SignInManager.shared.getStatus()
        if(isSignedIn) {
            //test > ori method
//            if(!pcList.isEmpty) {
//                let initialSelectedIndex = pcList.count - 1
////                addPhotoSection(i: initialSelectedIndex, textToAdd: "")
//                
//                //test > new url method
////                let url = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
////                if let u = url {
////                    addPhotoSection(i: initialSelectedIndex, textToAdd: "", url: u)
////                }
//                let urls = [URL]()
//                let assetSize = computePhotoSize()
//                addPhotoSection(i: initialSelectedIndex, textToAdd: "", urls: urls, cSize: assetSize)
//                
//                if(pcList[initialSelectedIndex].tBoxType == "t") {
//                    if let tBoxTv = pcList[initialSelectedIndex].tBox as? UITextView {
//                        if(tBoxTv.text == "") {
//                            removeTextSection(i: initialSelectedIndex)
//                        }
//                    }
//                }
//            }
            
            //test 2 > open camera to select photo
//            openCameraPhotoRoll()
            openCameraVideoRoll()
        }
        else {
            delegate?.didPostCreatorClickSignIn()
        }
    }
    @objc func onMainEmbedClicked(gesture: UITapGestureRecognizer) {
        
        clearErrorUI()
        
        let isSignedIn = SignInManager.shared.getStatus()
        if(isSignedIn) {
            
        }
        else {
            delegate?.didPostCreatorClickSignIn()
        }
    }
    
    @objc func onTextAtClicked(gesture: UITapGestureRecognizer) {

    }
    
    @objc func onTextHashtagClicked(gesture: UITapGestureRecognizer) {

    }
    
    @objc func onTextAddPhotoClicked(gesture: UITapGestureRecognizer) {
        print("post create addphoto")
        
        clearErrorUI()
        
        //test 2 > open camera
        let aTextBeforeCursor = textBeforeCursor //test > save text as resignresponder() cancel out textbeforecursor
        let aTextAfterCursor = textAfterCursor
        
        //*test 1 > open camera to add photo
        resignResponder()
//        openCameraPhotoRoll()
        openCameraVideoRoll()
        //*
        
        textBeforeCursor = aTextBeforeCursor
        textAfterCursor = aTextAfterCursor
        
        //****test > ori => directly add photo
//        clearErrorUI()
//        
//        print("xy txt+Photo a: \(selectedPcIndex), \(computePcPosition(index: selectedPcIndex, isInclusive: true)), \(stackView.frame.height)")
//        let currentYPosition = computePcPosition(index: selectedPcIndex, isInclusive: true)
//        let stackViewH = stackView.frame.height
//        
//        //test 2 > textbeforecursor, textaftercursor
//        let aTextBeforeCursor = textBeforeCursor
//        let aTextAfterCursor = textAfterCursor
////        print("xy addphoto: \(selectedPcIndex), \(textBeforeCursor), \(textAfterCursor)")
//        
//        //test 3 > add photo in index i
//        let initialSelectedIndex = selectedPcIndex
//        
//        let assetSize = computePhotoSize()
//        let urls = [URL]()
////        addPhotoSection(i: selectedPcIndex, textToAdd: aTextAfterCursor)
//        addPhotoSection(i: selectedPcIndex, textToAdd: aTextAfterCursor, urls: urls, cSize: assetSize)
//        
//        //TODO 1: remove empty text section when adding photo
//        //case 1: textbeforecursor "", add photo and textview with text below, remove current textview
//        //case 2: textaftercursor "", add photo only, no need to add textview
//        //case 3: cursor in middle, add photo and textview, repopulate both textviews
//        //case 4: empty text, add photo only
//        if(pcList[initialSelectedIndex].tBoxType == "t") {
//            if let tBoxTv = pcList[initialSelectedIndex].tBox as? UITextView {
//                //case 4
//                if(tBoxTv.text == "") {
////                    print("xy addphoto case 4")
//                    if(initialSelectedIndex > 0) { //test > prevent index 0 from being removed
//                        removeTextSection(i: initialSelectedIndex)
//                        
//                        //the new selectedindex of appended textview has to be deducted -1 coz removal of empty tv
//                        if(selectedPcIndex > initialSelectedIndex) {
//                            selectedPcIndex = selectedPcIndex - 1
//                        }
//                    }
//                }
//                else {
//                    //case 3
////                    let oldH = tBoxTv.contentSize.height
//                    tBoxTv.text = aTextBeforeCursor
//                    let newH = tBoxTv.contentSize.height
//                    pcList[initialSelectedIndex].tBoxHeightCons?.constant = newH //update tbox height
////                    print("xy addphoto case 3, \(stackView.frame.height)")
//                    
//                    let currentString: NSString = (tBoxTv.text ?? "") as NSString
//                    let length = currentString.length
//                    if(length > 0) {
//                        pcList[initialSelectedIndex].tvBoxHint?.isHidden = true
//                    } else {
//                        pcList[initialSelectedIndex].tvBoxHint?.isHidden = false
//                    }
//                    
//                    //case 1
//                    if(aTextBeforeCursor == "") {
////                        print("xy addphoto case 1")
//                        removeTextSection(i: initialSelectedIndex)
//                        
//                        //the new selectedindex of appended textview has to be deducted -1 coz removal of empty tv
//                        if(selectedPcIndex > initialSelectedIndex) {
//                            selectedPcIndex = selectedPcIndex - 1
//                        }
//                    }
//                }
//            }
//        }
//        
//        
//        //test > scroll to position if not visible
////        let y = scrollView.contentOffset.y
//        let scrollViewBottomMargin = keyboardHeight + 60.0 //60
//        let stackViewHeight = stackViewH + 280.0 + 20.0
//        let scrollViewHeight = viewHeight - (50.0 + topInset) - scrollViewBottomMargin
//        var scrollGap = stackViewHeight - scrollViewHeight
//        if(scrollGap <= 0) {
//            scrollGap = 0.0
//        }
//
//        let yHeight = currentYPosition + 280.0 + 20.0
//        let yContentOffset = yHeight/stackViewHeight * scrollGap
//        scrollView.setContentOffset(CGPoint(x: 0, y: yContentOffset), animated: false)
//        print("xy txt+Photo b: \(selectedPcIndex), \(stackViewHeight)")
        //****
    }
    
    @objc func onTextNextClicked(gesture: UITapGestureRecognizer) {
        
        print("ontextnext \(selectedPcIndex)")
        clearErrorUI()
//        resignResponder()
//        selectedPcIndex = -1

        //test
        if(pcList[selectedPcIndex].tBoxType == "t") {
            if let tBoxTv = pcList[selectedPcIndex].tBox as? UITextView {
                if(selectedPcIndex > 0 && selectedPcIndex < pcList.count - 1) {
                    if(tBoxTv.text == "") {
                        //test > delete text section
                        resignResponder()
                        removeTextSection(i: selectedPcIndex)
                        //test
                        selectedPcIndex = -1
                    }
                    else {
                        resignResponder()
                        selectedPcIndex = -1
                    }
                } else {
                    resignResponder()
                    selectedPcIndex = -1
                }
            }
        }
    }
    
    @objc func onPhotoAddTextClicked(gesture: UITapGestureRecognizer) {
        
    }
    @objc func onPhotoAddPhotoClicked(gesture: UITapGestureRecognizer) {

        
    }
    @objc func onPhotoDeleteSectionClicked(gesture: UITapGestureRecognizer) {
        
        clearErrorUI()
        
        unselectPostClipCell(i: selectedPcIndex)
        mainEditPanel.isHidden = false
        textEditPanel.isHidden = true
        photoEditPanel.isHidden = true
        
        removeContentSection(i: selectedPcIndex)
//        selectedPcIndex = -1
    }
    @objc func onPhotoNextClicked(gesture: UITapGestureRecognizer) {
        
        clearErrorUI()
        
        unselectPostClipCell(i: selectedPcIndex)
        selectedPcIndex = -1
        
        mainEditPanel.isHidden = false
        textEditPanel.isHidden = true
        photoEditPanel.isHidden = true
    }

    //test > add photo/video section => in multiple format/layout
    func addContentSection(i: Int, textToAdd: String, urls: [URL], cSize: CGSize, dataType: String) {
        //if index is last member
        var isIndexLastElement = false
        var isToAppendText = false
        if(i == pcList.count - 1) {
            pcList[i].tBoxBottomCons?.isActive = false
            isIndexLastElement = true
        }
        
        //*test 2 > with reusable cell
        let a = PostClip()
        a.tBoxType = dataType //p for photo
        let cell = PostClipPhotoCell(frame: CGRect(x: 0 , y: 0, width: viewWidth, height: viewHeight))
        uView.addSubview(cell)
        cell.translatesAutoresizingMaskIntoConstraints = false
        cell.trailingAnchor.constraint(equalTo: uView.trailingAnchor, constant: 0).isActive = true
        cell.leadingAnchor.constraint(equalTo: uView.leadingAnchor, constant: 0).isActive = true
        cell.redrawUI()
        a.tBox = cell
        cell.aDelegate = self
        
        //test > insert url for selected photo
//        cell.setImage(url: url)//ori
//        cell.configure(data: "a", cSize: cSize)
        cell.configure(data: "a", dataType: dataType, cSize: cSize)
        //*
        
        if let currentTBox = pcList[i].tBox {
            //insert photo section below current selected index
            a.tBoxTopCons = cell.topAnchor.constraint(equalTo: currentTBox.bottomAnchor, constant: 10) //20
            a.tBoxTopCons?.isActive = true
            
            if(i < pcList.count - 1) {
                if let nextTBox = pcList[i + 1].tBox {
                    pcList[i + 1].tBoxTopCons?.isActive = false
                    pcList[i + 1].tBoxTopCons = nextTBox.topAnchor.constraint(equalTo: cell.bottomAnchor, constant: 10) //20
                    pcList[i + 1].tBoxTopCons?.isActive = true
                }
                
                if(pcList[i + 1].tBoxType != "t" && textToAdd != "") {
                    isToAppendText = true
                }
            }
        }

        pcList.insert(a, at: i + 1) //means "append" behind selectedindex
        
        //to append text section if last element
        if(isIndexLastElement || isToAppendText) {
//            let extraSize = 280.0 + 20.0
            let extraSize = cSize.height + 20.0
            addTextSection(i: i + 1, extraContentSize: extraSize, textToAdd: textToAdd)
        }
        else {
            let sHeight = stackView.frame.height
//            let newHeight = sHeight + 280.0 + 20.0
            let newHeight = sHeight + cSize.height + 20.0
            scrollView.contentSize = CGSize(width: stackView.frame.width, height: newHeight)
            
            //test > if no text section to add, then keyboard down
            resignResponder()
            selectedPcIndex = -1
        }
    }
    
    //test > add photo or video
    func addContentAtText(urls: [URL], dataType: String) {
        let currentYPosition = computePcPosition(index: selectedPcIndex, isInclusive: true)
        print("addcontent at text a: \(selectedPcIndex), \(currentYPosition), \(stackView.frame.height)")
        let stackViewH = stackView.frame.height
        
        //test 2 > textbeforecursor, textaftercursor
        let aTextBeforeCursor = textBeforeCursor
        let aTextAfterCursor = textAfterCursor
//        print("xy addphoto: \(selectedPcIndex), \(textBeforeCursor), \(textAfterCursor)")
        
        //*test > compute asset size beforehand
        let assetSize = computeContentSize(dataType: dataType)
        print("addcontent at text: \(assetSize)")
        //*
        
        //test 3 > add photo in index i
        let initialSelectedIndex = selectedPcIndex
        //test > new url method
        addContentSection(i: selectedPcIndex, textToAdd: aTextAfterCursor, urls: urls, cSize: assetSize, dataType: dataType)
        
        //TODO 1: remove empty text section when adding photo
        //case 1: textbeforecursor "", add photo and textview with text below, remove current textview
        //case 2: textaftercursor "", add photo only, no need to add textview
        //case 3: cursor in middle, add photo and textview, repopulate both textviews
        //case 4: empty text, add photo only
        if(pcList[initialSelectedIndex].tBoxType == "t") {
            if let tBoxTv = pcList[initialSelectedIndex].tBox as? UITextView {
                //case 4
                if(tBoxTv.text == "") {
//                    print("xy addphoto case 4")
                    if(initialSelectedIndex > 0) { //test > prevent index 0 from being removed
                        removeTextSection(i: initialSelectedIndex)
                        
                        //the new selectedindex of appended textview has to be deducted -1 coz removal of empty tv
                        if(selectedPcIndex > initialSelectedIndex) {
                            selectedPcIndex = selectedPcIndex - 1
                        }
                    }
                }
                else {
                    //case 3
//                    let oldH = tBoxTv.contentSize.height
                    tBoxTv.text = aTextBeforeCursor
                    let newH = tBoxTv.contentSize.height
                    pcList[initialSelectedIndex].tBoxHeightCons?.constant = newH //update tbox height
//                    print("xy addphoto case 3, \(stackView.frame.height)")
                    
                    let currentString: NSString = (tBoxTv.text ?? "") as NSString
                    let length = currentString.length
                    if(length > 0) {
                        pcList[initialSelectedIndex].tvBoxHint?.isHidden = true
                    } else {
                        pcList[initialSelectedIndex].tvBoxHint?.isHidden = false
                    }
                    
                    //case 1
                    if(aTextBeforeCursor == "") {
//                        print("xy addphoto case 1")
                        removeTextSection(i: initialSelectedIndex)
                        
                        //the new selectedindex of appended textview has to be deducted -1 coz removal of empty tv
                        if(selectedPcIndex > initialSelectedIndex) {
                            selectedPcIndex = selectedPcIndex - 1
                        }
                    }
                }
            }
        }
        
        
        //test > scroll to position if not visible
//        let y = scrollView.contentOffset.y
        let scrollViewBottomMargin = keyboardHeight + 60.0 //60 => texteditpanel height
        let stackViewHeight = stackViewH + assetSize.height + 20.0
        let scrollViewHeight = viewHeight - (50.0 + topInset) - scrollViewBottomMargin
        var scrollGap = stackViewHeight - scrollViewHeight
        if(scrollGap <= 0) {
            scrollGap = 0.0
        }

        let yHeight = currentYPosition + assetSize.height + 20.0
        let yContentOffset = yHeight/stackViewHeight * scrollGap
        scrollView.setContentOffset(CGPoint(x: 0, y: yContentOffset), animated: false)
        print("xy txt+Photo b: \(selectedPcIndex), \(stackViewHeight), \(scrollViewHeight), \(scrollViewBottomMargin)")
    }
    
    func addContentAtMain(urls: [URL], dataType: String) {
        if(!pcList.isEmpty) {
            let initialSelectedIndex = pcList.count - 1
//                addPhotoSection(i: initialSelectedIndex, textToAdd: "")

            //test > new url method
//            let url = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
//            if let u = url {
//                addPhotoSection(i: initialSelectedIndex, textToAdd: "", url: u)
//            }
            
            let assetSize = computeContentSize(dataType: dataType)
            addContentSection(i: initialSelectedIndex, textToAdd: "", urls: urls, cSize: assetSize, dataType: dataType)

            if(pcList[initialSelectedIndex].tBoxType == "t") {
                if let tBoxTv = pcList[initialSelectedIndex].tBox as? UITextView {
                    if(tBoxTv.text == "") {
                        //ori => fatal error
//                        removeTextSection(i: initialSelectedIndex)
                        
                        //test 1 > prevent fatal error
                        if(initialSelectedIndex > 0) { //test > prevent index 0 from being removed
                            removeTextSection(i: initialSelectedIndex)
                            
                            //new selectedindex of appended textview has to be deducted -1 coz removal of empty tv
                            if(selectedPcIndex > initialSelectedIndex) {
                                selectedPcIndex = selectedPcIndex - 1
                            }
                        }
                    }
                }
            }
        }
    }
    
    //test > to be replaced with multiple urls computation
    func computeContentSize(dataType: String) -> CGSize {
        var cSize = CGSize(width: 0, height: 0)
        
        if(dataType == "p") {
            let cellWidth = self.frame.width
            let lhsMargin = 20.0
            let rhsMargin = 20.0
            let availableWidth = cellWidth - lhsMargin - rhsMargin
            
    //        let assetSize = CGSize(width: 4, height: 3) //landscape
            let assetSize = CGSize(width: 3, height: 4)
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
        } else if(dataType == "p_s") {
            let cellWidth = self.frame.width
            let lhsMargin = 20.0
            let rhsMargin = 20.0
            let descHeight = 40.0
            let availableWidth = cellWidth - lhsMargin - rhsMargin
            
            let assetSize = CGSize(width: 4, height: 3)
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
        } else if(dataType == "v") {
            let cellWidth = self.frame.width
            let lhsMargin = 20.0
            let rhsMargin = 20.0
            let availableWidth = cellWidth - lhsMargin - rhsMargin
            
            let assetSize = CGSize(width: 3, height: 4)
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
        } else if(dataType == "v_l") {//loop videos
            let cellWidth = self.frame.width
            let lhsMargin = 20.0
            let rhsMargin = 20.0
            let descHeight = 40.0
            let availableWidth = cellWidth - lhsMargin - rhsMargin
            
            let assetSize = CGSize(width: 3, height: 4)
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
        } else if(dataType == "q") { //quote cell
            //**test > fake data for quote post
            var qDataArray = [String]()
            qDataArray.append("t")
//                qDataArray.append("p")
//                qDataArray.append("p_s")
            qDataArray.append("v")
//                qDataArray.append("v_l")
            //**

            let cellWidth = self.frame.width
            let qLhsMargin = 20.0
            let qRhsMargin = 20.0
            let quoteWidth = cellWidth - qLhsMargin - qRhsMargin
            var contentHeight = 0.0
            
            for i in qDataArray {
                if(i == "t") {
                    let tTopMargin = 20.0
                    let text = "Nice food, nice environment! Worth a visit. \nSo Good."
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
//            let qTopMargin = 20.0
            let qUserPhotoHeight = 28.0
            let qUserPhotoTopMargin = 20.0 //10
            let qFrameBottomMargin = 20.0 //10
            let qHeight = qUserPhotoHeight + qUserPhotoTopMargin + qFrameBottomMargin
            contentHeight += qHeight
            
            cSize = CGSize(width: quoteWidth, height: contentHeight)
        }

        return cSize
    }
    
    private func estimateHeight(text: String, textWidth: CGFloat, fontSize: CGFloat) -> CGFloat {
        if(text == ""){
            return 0
        } else {
            let size = CGSize(width: textWidth, height: 1000) //1000 height is dummy
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]
            let estimatedFrame = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            
            return estimatedFrame.height
        }
    }
    
    func addTextSection(i: Int, extraContentSize: CGFloat, textToAdd: String) {
        if(pcList.isEmpty) {
            let a = PostClip()
            a.tBoxType = "t"
            let bTv = UITextView()
            bTv.textAlignment = .left
            bTv.textColor = .white
            bTv.backgroundColor = .clear
            bTv.font = .systemFont(ofSize: 14) //13
            uView.addSubview(bTv)
            bTv.translatesAutoresizingMaskIntoConstraints = false
            bTv.leadingAnchor.constraint(equalTo: uView.leadingAnchor, constant: 20).isActive = true
            bTv.trailingAnchor.constraint(equalTo: uView.trailingAnchor, constant: -20).isActive = true
//            bTv.text = ""
            bTv.text = textToAdd
            bTv.tintColor = .yellow
            bTv.delegate = self
            bTv.textContainerInset = UIEdgeInsets.zero
            a.tBox = bTv
            a.tBoxTopCons = bTv.topAnchor.constraint(equalTo: pMini.bottomAnchor, constant: 20) //20
            a.tBoxTopCons?.isActive = true
            a.tBoxHeightCons = bTv.heightAnchor.constraint(equalToConstant: 17) //36
            a.tBoxHeightCons?.isActive = true
            a.tBoxBottomCons = bTv.bottomAnchor.constraint(equalTo: uView.bottomAnchor, constant: 0)
            a.tBoxBottomCons?.isActive = true
            
            //test ** > add hint text
            let hintText = UILabel()
            a.tvBoxHint = hintText
            hintText.textAlignment = .left
//            hintText.textColor = .white
            hintText.textColor = .ddmDarkGrayColor
            hintText.font = .boldSystemFont(ofSize: 14)
            uView.addSubview(hintText)
            hintText.translatesAutoresizingMaskIntoConstraints = false
            hintText.leadingAnchor.constraint(equalTo: bTv.leadingAnchor, constant: 10).isActive = true
            hintText.trailingAnchor.constraint(equalTo: uView.trailingAnchor, constant: -20).isActive = true
            hintText.topAnchor.constraint(equalTo: bTv.topAnchor, constant: 0).isActive = true //8
            hintText.text = "What's happening?..."
//            hintText.layer.opacity = 0.5
            // **
            
            pcList.append(a)
            
            setFirstResponder(textView: bTv)
            
            let sHeight = stackView.frame.height
            let newHeight = sHeight + 17.0 + 20.0 + extraContentSize
            scrollView.contentSize = CGSize(width: stackView.frame.width, height: newHeight)
        }
        else {
            if(pcList[i].tBoxType != "t") {
                if(i < pcList.count - 1) {
                    if(pcList[i + 1].tBoxType != "t") {
                        
                        print("addtextsection A")
                        
                        let a = PostClip()
                        a.tBoxType = "t"
                        let bTv = UITextView()
                        bTv.textAlignment = .left
                        bTv.textColor = .white
                        bTv.backgroundColor = .clear
                        bTv.font = .systemFont(ofSize: 14) //13
                        uView.addSubview(bTv)
                        bTv.translatesAutoresizingMaskIntoConstraints = false
                        bTv.leadingAnchor.constraint(equalTo: uView.leadingAnchor, constant: 20).isActive = true
                        bTv.trailingAnchor.constraint(equalTo: uView.trailingAnchor, constant: -20).isActive = true
//                        bTv.text = ""
                        bTv.text = textToAdd
                        bTv.tintColor = .yellow
                        bTv.delegate = self
                        bTv.textContainerInset = UIEdgeInsets.zero
                        a.tBox = bTv
                        if let currentTBox = pcList[i].tBox {
                            a.tBoxTopCons = bTv.topAnchor.constraint(equalTo: currentTBox.bottomAnchor, constant: 10) //20
                            a.tBoxTopCons?.isActive = true
                        }
                        a.tBoxHeightCons = bTv.heightAnchor.constraint(equalToConstant: 17) //36
                        a.tBoxHeightCons?.isActive = true
                        if let nextTBox = pcList[i + 1].tBox {
                            pcList[i + 1].tBoxTopCons?.isActive = false
                            pcList[i + 1].tBoxTopCons = nextTBox.topAnchor.constraint(equalTo: bTv.bottomAnchor, constant: 10) //20
                            pcList[i + 1].tBoxTopCons?.isActive = true
                        }
                        
                        //test ** > add hint text
                        let hintText = UILabel()
                        a.tvBoxHint = hintText
                        hintText.textAlignment = .left
//                        hintText.textColor = .white
                        hintText.textColor = .ddmDarkGrayColor
                        hintText.font = .boldSystemFont(ofSize: 14)
                        uView.addSubview(hintText)
                        hintText.translatesAutoresizingMaskIntoConstraints = false
                        hintText.leadingAnchor.constraint(equalTo: bTv.leadingAnchor, constant: 10).isActive = true //20
                        hintText.trailingAnchor.constraint(equalTo: uView.trailingAnchor, constant: -20).isActive = true
                        hintText.topAnchor.constraint(equalTo: bTv.topAnchor, constant: 0).isActive = true //8
                        hintText.text = "Add more..."
//                        hintText.layer.opacity = 0.5
                        // **
                        
                        pcList.insert(a, at: i + 1) //means "append" behind selectedindex
                        
                        setFirstResponder(textView: bTv)
                        //test > move cursor to beginning of textview
                        let beginningPosition = bTv.beginningOfDocument
                        let newRange = bTv.textRange(from: beginningPosition, to: beginningPosition)
                        bTv.selectedTextRange = newRange
                        
                        //update scrollview content size
                        let sHeight = stackView.frame.height
                        let newHeight = sHeight + 17.0 + 20.0 + extraContentSize
                        scrollView.contentSize = CGSize(width: stackView.frame.width, height: newHeight)
                    }
                }
                else if(i == pcList.count - 1) {
                    
                    print("addtextsection B")
                    
                    pcList[i].tBoxBottomCons?.isActive = false
                    
                    let a = PostClip()
                    a.tBoxType = "t"
                    let bTv = UITextView()
                    bTv.textAlignment = .left
                    bTv.textColor = .white
                    bTv.backgroundColor = .clear
                    bTv.font = .systemFont(ofSize: 14) //13
                    uView.addSubview(bTv)
                    bTv.translatesAutoresizingMaskIntoConstraints = false
                    bTv.leadingAnchor.constraint(equalTo: uView.leadingAnchor, constant: 20).isActive = true
                    bTv.trailingAnchor.constraint(equalTo: uView.trailingAnchor, constant: -20).isActive = true
//                    bTv.text = ""
                    bTv.text = textToAdd
                    bTv.tintColor = .yellow
                    bTv.delegate = self
                    bTv.textContainerInset = UIEdgeInsets.zero
                    a.tBox = bTv
                    if let currentTBox = pcList[i].tBox {
                        a.tBoxTopCons = bTv.topAnchor.constraint(equalTo: currentTBox.bottomAnchor, constant: 10) //20
                        a.tBoxTopCons?.isActive = true
                    }
                    a.tBoxHeightCons = bTv.heightAnchor.constraint(equalToConstant: 17) //36
                    a.tBoxHeightCons?.isActive = true
                    a.tBoxBottomCons = bTv.bottomAnchor.constraint(equalTo: uView.bottomAnchor, constant: 0)
                    a.tBoxBottomCons?.isActive = true
                    
                    //test ** > add hint text
                    let hintText = UILabel()
                    a.tvBoxHint = hintText
                    hintText.textAlignment = .left
                    hintText.textColor = .white
                    hintText.font = .boldSystemFont(ofSize: 14)
                    uView.addSubview(hintText)
                    hintText.translatesAutoresizingMaskIntoConstraints = false
                    hintText.leadingAnchor.constraint(equalTo: bTv.leadingAnchor, constant: 10).isActive = true //20
                    hintText.trailingAnchor.constraint(equalTo: uView.trailingAnchor, constant: -20).isActive = true
                    hintText.topAnchor.constraint(equalTo: bTv.topAnchor, constant: 0).isActive = true //8
                    hintText.text = "Add more..."
                    hintText.layer.opacity = 0.5
                    // **
                    
                    pcList.append(a)
                    
                    setFirstResponder(textView: bTv)
                    //test > move cursor to beginning of textview
                    let beginningPosition = bTv.beginningOfDocument
                    let newRange = bTv.textRange(from: beginningPosition, to: beginningPosition)
                    bTv.selectedTextRange = newRange
                    
                    let sHeight = stackView.frame.height
                    let newHeight = sHeight + 17.0 + 20.0 + extraContentSize
                    scrollView.contentSize = CGSize(width: stackView.frame.width, height: newHeight)
                }
            }
        }
    }
    
    func removeContentSection(i: Int) {
        if(i > 0) { //means i-1 element exists, first element must be textview
//            if(pcList[i].tBoxType == "p") {
                
                //*test > compute asset size
                var tBoxSizeH = 0.0
                if let tBoxTv = pcList[i].tBox {
                    tBoxSizeH = tBoxTv.frame.height
                    print("removePhotoSection \(tBoxSizeH)")
                }
                //*
                
                pcList[i].tBox?.removeFromSuperview()
                
                if let prevTBox = pcList[i - 1].tBox {
                    
                    if(i == pcList.count - 1) { //if current pc is last element
                        pcList[i].tBoxBottomCons?.isActive = false
                        pcList[i - 1].tBoxBottomCons = prevTBox.bottomAnchor.constraint(equalTo: uView.bottomAnchor, constant: 0)
                        pcList[i - 1].tBoxBottomCons?.isActive = true
                    }
                    else{
                        if let nextTBox = pcList[i + 1].tBox {
                            pcList[i + 1].tBoxTopCons?.isActive = false
                            pcList[i + 1].tBoxTopCons = nextTBox.topAnchor.constraint(equalTo: prevTBox.bottomAnchor, constant: 10) //20
                            pcList[i + 1].tBoxTopCons?.isActive = true
                        }
                    }
                }
                
                pcList.remove(at: i)
                
                //test *> unselect selectedindex
                selectedPcIndex = -1
                //*
                
                //if previous pc is text section, and next pc is also text section, then combine texts
                if(i <= pcList.count - 1) {
                    if(pcList[i - 1].tBoxType == "t" && pcList[i].tBoxType == "t") {
                        removeTextSection(i: i)
                    }
                }
                
                //test > update scrollview content size since photo removed
                let sHeight = stackView.frame.height
//                let newHeight = sHeight - 280.0 - 20.0
                let newHeight = sHeight - tBoxSizeH
                scrollView.contentSize = CGSize(width: stackView.frame.width, height: newHeight)
//            }
        }
    }
    
    func removeTextSection(i: Int) {
//        if(i > -1) {
        if(i > 0) {
            var currentT = ""
            var prevT = ""
            if(pcList[i].tBoxType == "t") {
                if let currentTBox = pcList[i].tBox as? UITextView {
                    currentT = currentTBox.text
                }
                
                pcList[i].tBox?.removeFromSuperview()
                pcList[i].tvBoxHint?.removeFromSuperview()
                
                if(i > 0) { //means i-1 element exists
                    if let prevTBox = pcList[i - 1].tBox {
                        //if previous pc is text section, then combine texts
                        if(pcList[i - 1].tBoxType == "t") {
                            if let prevTBoxTv = pcList[i - 1].tBox as? UITextView {
                                prevT = prevTBoxTv.text
                                if let text = prevT as NSString? {
                                    let l = text.length
                                    
                                    prevT = prevTBoxTv.text
                                    let newT = prevT + "" + currentT
                                    prevTBoxTv.text = newT
                                    
                                    //test > shift cursor to prev textview
                                    setFirstResponder(textView: prevTBoxTv)
                                    
                                    //move cursor to new position, not end of textview
                                    if let newPosition = prevTBoxTv.position(from: prevTBoxTv.beginningOfDocument, offset: l) {
                                        let newRange = prevTBoxTv.textRange(from: newPosition, to: newPosition)
                                        prevTBoxTv.selectedTextRange = newRange
                                    }
                                }
                                
                                //old method > without cursor move to new position
//                                prevT = prevTBoxTv.text
//                                let newT = prevT + "" + currentT
//                                prevTBoxTv.text = newT
//
//                                //test > shift cursor to prev textview
//                                setFirstResponder(textView: prevTBoxTv)
                            }
                        }
                        
                        if(i == pcList.count - 1) { //if current pc is last element
                            pcList[i].tBoxBottomCons?.isActive = false
                            pcList[i - 1].tBoxBottomCons = prevTBox.bottomAnchor.constraint(equalTo: uView.bottomAnchor, constant: 0)
                            pcList[i - 1].tBoxBottomCons?.isActive = true
                        }
                        else{
                            if let nextTBox = pcList[i + 1].tBox {
                                pcList[i + 1].tBoxTopCons?.isActive = false
                                pcList[i + 1].tBoxTopCons = nextTBox.topAnchor.constraint(equalTo: prevTBox.bottomAnchor, constant: 10) //20
                                pcList[i + 1].tBoxTopCons?.isActive = true
                            }
                        }
                    }
                }
            
                pcList.remove(at: i)
            }
        }
    }
    
    func openSavePostDraftPromptMsg() {
        let saveDraftPanel = SavePostDraftMsgView(frame: CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.height))
        panel.addSubview(saveDraftPanel)
        saveDraftPanel.translatesAutoresizingMaskIntoConstraints = false
        saveDraftPanel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        saveDraftPanel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        saveDraftPanel.delegate = self
    }
    //test > try exit creator instead of save draft for now
    func openExitVideoEditorPromptMsg() {
        let exitVideoPanel = ExitVideoEditorMsgView(frame: CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.height))
        panel.addSubview(exitVideoPanel)
        exitVideoPanel.translatesAutoresizingMaskIntoConstraints = false
        exitVideoPanel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        exitVideoPanel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        exitVideoPanel.delegate = self
        exitVideoPanel.setType(t: "post")
    }
    
    func openCameraPhotoRoll() {
        let cameraRollPanel = CameraPhotoRollPanelView(frame: CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.height))
        panel.addSubview(cameraRollPanel)
        cameraRollPanel.translatesAutoresizingMaskIntoConstraints = false
        cameraRollPanel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        cameraRollPanel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        cameraRollPanel.delegate = self
        //test > set multi selection
        cameraRollPanel.setMultiSelection(limit: maxSelectLimit)
    }
    
    func openCameraVideoRoll() {
        let cameraRollPanel = CameraVideoRollPanelView(frame: CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.height))
        panel.addSubview(cameraRollPanel)
        cameraRollPanel.translatesAutoresizingMaskIntoConstraints = false
        cameraRollPanel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        cameraRollPanel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        cameraRollPanel.delegate = self
        //test > set multi selection
//        cameraRollPanel.setMultiSelection(limit: maxSelectLimit)
        let maxDurationLimit = 60.0
        cameraRollPanel.setDurationLimit(limit: maxDurationLimit)
    }
    
    func unselectPostClipCell(i : Int) {
//        if(pcList[i].tBoxType == "p") {
//            if let currentTBox = pcList[i].tBox as? PostClipPhotoCell {
//                currentTBox.unselectCell()
//            }
//        }
        
        //test 1 > not limited to "p" content only
        if let currentTBox = pcList[i].tBox as? PostClipPhotoCell {
            currentTBox.unselectCell()
        }
    }
    
    @objc func onBackPostCreatorPanelClicked(gesture: UITapGestureRecognizer) {
        resignResponder()
//        openSavePostDraftPromptMsg()

        //test
//        openExitVideoEditorPromptMsg()
        
        //test 2
        let isSignedIn = SignInManager.shared.getStatus()
        if(isSignedIn) {
            openExitVideoEditorPromptMsg()
        }
        else {
            closePostCreatorPanel(isAnimated: true)
        }
    }
    
    @objc func onPostUploadNextClicked(gesture: UITapGestureRecognizer) {
        clearErrorUI()
        resignResponder()
        
        let isSignedIn = SignInManager.shared.getStatus()
        if(isSignedIn) {
//            if(true) {
//                configureErrorUI(data: "na-location")
//            } else {
                aUpload.isHidden = true
                aSpinner.startAnimating()

                //test 1 > upload data
//                DataUploadManager.shared.sendData(id: "u") { [weak self]result in
//                    switch result {
//                        case .success(let l):
//
//                        //update UI on main thread
//                        DispatchQueue.main.async {
//
//                            self?.closePostCreatorPanel(isAnimated: true)
//                        }
//
//                        case .failure(_):
//                            print("api fail")
//                            break
//                    }
//                }
            
                //test 2 > new method to upload data => for in-app msg view
                self.closePostCreatorPanel(isAnimated: true)
                delegate?.didPostCreatorClickUpload(payload: "cc") //payload e.g. location name
//            }
        }
        else {
            delegate?.didPostCreatorClickSignIn()
        }
    }
    
    @objc func onDraftBoxClicked(gesture: UITapGestureRecognizer) {
        resignResponder()
//        openPostDraftPanel()
    }
    
    @objc func onSaveDraftNextClicked(gesture: UITapGestureRecognizer) {
        clearErrorUI()
        resignResponder()
        aSaveDraft.isHidden = true
        bSpinner.startAnimating()

        DataUploadManager.shared.sendData(id: "u") { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {

                    self?.closePostCreatorPanel(isAnimated: true)
                }

                case .failure(_):
                    print("api fail")
                    break
            }
        }
    }
    
    var keyboardHeight = 0.0
    var currentTextViewHeight = 0.0
    @objc func onKeyboardWillChange(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            let bottomInsetMargin = self.safeAreaInsets.bottom
            print("postcreator tool up \(keyboardSize.height), \(bottomInsetMargin) ")

//            keyboardHeight = keyboardSize.height
            //test 2 > only assign keyboardheight if it is > 0
            if(keyboardSize.height > 0) {
                keyboardHeight = keyboardSize.height
            }
            
            if(!isKeyboardUp) {
                UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut],
                    animations: {
                    self.textEditPanel.transform = CGAffineTransform(translationX: 0, y: -self.keyboardHeight)
                }, completion: { finished in
                })
            } else {
                self.textEditPanel.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
            }
            
            //test > adjust scrollview height when keyboard up
            let scrollViewMargin = keyboardHeight + 60.0 //60
            self.scrollViewBottomCons?.constant = -scrollViewMargin
            
            isKeyboardUp = true
        }
    }
    
    //compute relative position of pc view vs stackview
    func computePcPosition(index : Int, isInclusive: Bool) -> CGFloat {
        let initialYHeight = 40.0 + 20.0 //pMini => profile image size & top margin
        var yHeight = 0.0 + initialYHeight
        var i = 0
        if(!self.pcList.isEmpty) {
            for l in self.pcList {
                if(!isInclusive) {
                    if(i == index) {
                        break
                    }
                }

                if let tBoxTv = l.tBox {
                    print("computePCposition \(i), \(tBoxTv.frame.height)")
                    yHeight += tBoxTv.frame.height
                    if(i == 0) {
                        yHeight += 20.0 //top margin
                    } else {
                        yHeight += 10.0 //top margin
                    }
                }
                
                if(isInclusive) {
                    if(i == index) {
                        break
                    }
                }
                
                i += 1
            }
        }
        
        return yHeight
    }
    
    func configureErrorUI(data: String) {
        if(data == "e") {
            maxLimitText.text = "Error occurred. Try again"
        }
        else if(data == "na-location") {
            maxLimitText.text = "Location is required"
        }
        
        maxLimitErrorPanel.isHidden = false
    }
    
    func clearErrorUI() {
        maxLimitText.text = ""
        maxLimitErrorPanel.isHidden = true
    }
}

extension PostCreatorConsolePanelView: PostClipPhotoCellDelegate {
    func didClickPostClipCell(cell: PostClipPhotoCell) {
        
        var i = 0
        for pc in pcList {
//            if(pc.tBoxType == "p") {
                if(pc.tBox == cell) {
//                    print("xy click pc: \(i), \(cell)")
                    
                    if(selectedPcIndex != i) {
                        if(selectedPcIndex > -1) {
                            unselectPostClipCell(i: selectedPcIndex)
                        }
                        cell.selectCell()
                        selectedPcIndex = i
                        
                        //test > scroll to position if not visible
                        let stackViewHeight = stackView.frame.height
                        let topMargin = 50.0 + topInset
                        let bottomMargin = 90.0 + bottomInset
                        let scrollViewHeight = viewHeight - topMargin - bottomMargin //in full mode(keyboard down)
                        var scrollGap = stackViewHeight - scrollViewHeight
                        if(scrollGap <= 0) {
                            scrollGap = 0.0
                        }
                        
                        if let h = pc.tBox?.frame.height{
                            let yHeight = computePcPosition(index: selectedPcIndex, isInclusive: false) + h/2
                            let yHeight2 = computePcPosition(index: selectedPcIndex, isInclusive: false) + h
                            print("xy yheight: \(yHeight), \(yHeight2), \(stackViewHeight)")
                            let yContentOffset = yHeight/stackViewHeight * scrollGap
                            scrollView.setContentOffset(CGPoint(x: 0, y: yContentOffset), animated: false)
                        }
                    }
                    else {
//                        cell.unselectCell()
//                        selectedPcIndex = -1
                    }
                    
                    resignResponder()
                    
                    mainEditPanel.isHidden = true
                    textEditPanel.isHidden = true
                    photoEditPanel.isHidden = false
                    
                    break
                }
//            }
            i += 1
        }
    }
}

extension ViewController: PostCreatorPanelDelegate{
    func didInitializePostCreator() {
        
    }
    
    func didClickFinishPostCreator() {
        //test 1 > as not scrollable
        backPage(isCurrentPageScrollable: false)
        
        //test 2 > as scrollable
//        backPage(isCurrentPageScrollable: true)
    }
    
    func didPostCreatorClickLocationSelectScrollable() {
        openLocationSelectScrollablePanel()
    }
    
    func didPostCreatorClickSignIn(){
        openLoginPanel()
    }
    
    func didPostCreatorClickUpload(payload: String){
        DataUploadManager.shared.sendData(id: "a") { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    guard let self = self else {
                        return
                    }
                    
                    if(!self.inAppMsgList.isEmpty) {
                        let a = self.inAppMsgList[self.inAppMsgList.count - 1]
                        a.updateConfigUI(data: "up_post", taskId: "a")
                    }
                }

                case .failure(_):
                //update UI on main thread
                DispatchQueue.main.async {
                    guard let self = self else {
                        return
                    }
                    print("api fail")
                    
                    if(!self.inAppMsgList.isEmpty) {
                        let a = self.inAppMsgList[self.inAppMsgList.count - 1]
                        a.updateConfigUI(data: "up_post", taskId: "a")
                    }
                }
                break
            }
        }
        
        openInAppMsgView(data: "up_post")
    }
}

extension PostCreatorConsolePanelView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        //test > detect which textview is currently at
        var i = 0
        for pc in pcList {
            if(pc.tBoxType == "t") {
                if(pc.tBox == textView) {
                    
                    //*test > update textview height when merge multiline textview with another textview
                    let h = textView.contentSize.height
                    pc.tBoxHeightCons?.constant = h
                    let currentString: NSString = (textView.text ?? "") as NSString
                    let length = currentString.length
                    if(length > 0) {
                        pc.tvBoxHint?.isHidden = true
                    } else {
                        pc.tvBoxHint?.isHidden = false
                    }
                    //*
                    
                    if(selectedPcIndex != i) {
                        if(selectedPcIndex > -1) {
                            unselectPostClipCell(i: selectedPcIndex)
                        }
                        selectedPcIndex = i
                    }
                    else {
                        //same selectedindex
                    }
                    
                    mainEditPanel.isHidden = true
                    textEditPanel.isHidden = false
                    photoEditPanel.isHidden = true
                    
                    break
                }
            }
            i += 1
        }
        
//        print("xy begin edit: \(selectedPcIndex), \(keyboardHeight), \(isKeyboardUp)")
        //test > save height of textview to detect if any change to size
        let h = textView.contentSize.height
        currentTextViewHeight = h
        
        //test 2 > new method test get string before and after cursor
        if let selectedRange = textView.selectedTextRange {
            let cursorPosition = textView.offset(from: textView.beginningOfDocument, to: selectedRange.start)
            
            // Convert the UITextView text to NSString for correct indexing
            if let text = textView.text as NSString? {
                // Get the string before the cursor
                let beforeCursor = text.substring(to: cursorPosition)
                
                // Get the string after the cursor
                let afterCursor = text.substring(from: cursorPosition)
                textBeforeCursor = beforeCursor
                textAfterCursor = afterCursor
                
//                print("Before cursor: \(beforeCursor), After cursor: \(afterCursor)")
            }
        }
        
        //test > get current textview cursor in respect to stackview
        //=> scroll to textview when keyboard is up, which blocks the textview
        if let tBoxTv = pcList[selectedPcIndex].tBox as? UITextView {
            if let selectedRange = tBoxTv.selectedTextRange {
                let caretRect = tBoxTv.caretRect(for: selectedRange.start)
                let stackConvertedRect = tBoxTv.convert(caretRect, to: stackView) //relative to stackview
                
                //print the cursor's X and Y coordinates
                let y = scrollView.contentOffset.y
                let scrollViewBottomMargin = keyboardHeight + 60.0 //60
                let sHeight = viewHeight - (50.0 + topInset) - scrollViewBottomMargin
                let cursorOriginY = stackConvertedRect.origin.y
                let cursorY = stackConvertedRect.origin.y + caretRect.height
                
                let lowerYLimit = y
                let higherYLimit = y + sHeight
                
                print("xy begin edit: \(selectedPcIndex), \(keyboardHeight), \(isKeyboardUp), \(cursorOriginY)")
                
                if(cursorOriginY > lowerYLimit) {
                    if(cursorY < higherYLimit) {
                        print("xy detectcursor1 Yes \(cursorY)")
                    } else {
                        let yDiff = abs(cursorY - higherYLimit)
                        print("xy detectcursor1 N higher \(yDiff), \(cursorY)")
                        
                        //test > adjust y-contentoffset
                        if(yDiff <= caretRect.height) {
                            //test > simulate enter new line
                            let hDiff = h - currentTextViewHeight
                            let yOffset = y + hDiff
                            scrollView.setContentOffset(CGPoint(x: 0, y: yOffset), animated: false)
                        }
                        else {
                            //test > quick scroll to cursor position
                            let stackViewHeight = stackView.frame.height
                            var scrollGap = stackViewHeight - sHeight
                            if(scrollGap <= 0) {
                                scrollGap = 0.0
                            }
                            let yContentOffset = cursorY/stackViewHeight * scrollGap
                            scrollView.setContentOffset(CGPoint(x: 0, y: yContentOffset), animated: false)
                        }
                    }
                } else {

                    let yDiff = abs(cursorOriginY - lowerYLimit)
                    print("xy detectcursor1 N lower \(yDiff), \(cursorOriginY)")
                    
                    //test > adjust y-contentoffset
                    if(yDiff <= caretRect.height) {
                        //test > simulate enter new line
                        let hDiff = h - currentTextViewHeight
                        let yOffset = y + hDiff
                        scrollView.setContentOffset(CGPoint(x: 0, y: yOffset), animated: false)
                    }
                    else {
                        //test > quick scroll to cursor position
                        let stackViewHeight = stackView.frame.height
                        var scrollGap = stackViewHeight - sHeight
                        if(scrollGap <= 0) {
                            scrollGap = 0.0
                        }

                        let yContentOffset = cursorOriginY/stackViewHeight * scrollGap
                        scrollView.setContentOffset(CGPoint(x: 0, y: yContentOffset), animated: false)
                    }
                }
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let currentString: NSString = (textView.text ?? "") as NSString
        let length = currentString.length
        
        //test > check for textview size
        let h = textView.contentSize.height
        if(!pcList.isEmpty) {
            
            //test 2 > efficient method using selectedpcindex
            let pc = pcList[selectedPcIndex]
            if(pc.tBoxType == "t" && pc.tBox == textView) {
                pc.tBoxHeightCons?.constant = h

                if(length > 0) {
                    pc.tvBoxHint?.isHidden = true
                } else {
                    pc.tvBoxHint?.isHidden = false
                }
                
                //test > update scrollview contentsize
                scrollView.contentSize = CGSize(width: stackView.frame.width, height: stackView.frame.height)
            }
            
            //test > get current textview cursor in respect to stackview
            if let tBoxTv = pcList[selectedPcIndex].tBox as? UITextView {
                if let selectedRange = tBoxTv.selectedTextRange {
                    let caretRect = tBoxTv.caretRect(for: selectedRange.start)
                    let stackConvertedRect = tBoxTv.convert(caretRect, to: stackView) //relative to stackview
                    
                    //print the cursor's X and Y coordinates
                    let y = scrollView.contentOffset.y
                    let scrollViewBottomMargin = keyboardHeight + 60.0 //60
                    let sHeight = viewHeight - (50.0 + topInset) - scrollViewBottomMargin
                    let cursorOriginY = stackConvertedRect.origin.y
                    let cursorY = stackConvertedRect.origin.y + caretRect.height
                    
                    let lowerYLimit = y
                    let higherYLimit = y + sHeight

                    if(cursorOriginY > lowerYLimit) {
                        if(cursorY < higherYLimit) {
                            print("xy detectcursor Yes \(cursorY)")
                        } else {
                            let yDiff = abs(cursorY - higherYLimit)
//                            print("xy detectcursor N higher \(yDiff), \(cursorY)")
                            
                            //test > adjust y-contentoffset
                            if(yDiff <= caretRect.height) {
                                //test > simulate enter new line
                                let hDiff = h - currentTextViewHeight
                                print("xy detectcursor N higher A: \(yDiff), \(cursorY)")
                                let yOffset = y + hDiff
                                scrollView.setContentOffset(CGPoint(x: 0, y: yOffset), animated: false)
                            }
                            else {
                                //test > quick scroll to cursor position
                                print("xy detectcursor N higher B: \(yDiff), \(cursorY)")
                                let stackViewHeight = stackView.frame.height
                                var scrollGap = stackViewHeight - sHeight
                                if(scrollGap <= 0) {
                                    scrollGap = 0.0
                                }
                                let yContentOffset = cursorY/stackViewHeight * scrollGap
                                scrollView.setContentOffset(CGPoint(x: 0, y: yContentOffset), animated: false)
                            }
                        }
                    } else {

                        let yDiff = abs(cursorOriginY - lowerYLimit)
//                        print("xy detectcursor N lower \(yDiff), \(cursorOriginY)")
                        
                        //test > adjust y-contentoffset
                        if(yDiff <= caretRect.height) {
                            //test > simulate enter new line
                            let hDiff = h - currentTextViewHeight
                            print("xy detectcursor N lower C:\(yDiff), \(cursorOriginY)")
                            let yOffset = y + hDiff
                            scrollView.setContentOffset(CGPoint(x: 0, y: yOffset), animated: false)
                        }
                        else {
                            //test > quick scroll to cursor position
                            print("xy detectcursor N lower D:\(yDiff), \(cursorOriginY)")
                            let stackViewHeight = stackView.frame.height
                            var scrollGap = stackViewHeight - sHeight
                            if(scrollGap <= 0) {
                                scrollGap = 0.0
                            }

                            let yContentOffset = cursorOriginY/stackViewHeight * scrollGap
                            scrollView.setContentOffset(CGPoint(x: 0, y: yContentOffset), animated: false)
                        }
                    }
                }
            }
            
            //test > save height of textview to detect if any change to size
//            print("xy textview change h: \(currentTextViewHeight), \(h)")
            currentTextViewHeight = h
        }
    }
    
    //test ** > detect position of cursor at any given time
    func textViewDidChangeSelection(_ textView: UITextView) {
        
//        print("xy changeselection: \(selectedPcIndex), \(keyboardHeight)")
        
        //test 2 > get string before and after cursor
        if let selectedRange = textView.selectedTextRange {
            let cursorPosition = textView.offset(from: textView.beginningOfDocument, to: selectedRange.start)
            
            // Convert the UITextView text to NSString for correct indexing
            if let text = textView.text as NSString? {
                // Get the string before the cursor
                let beforeCursor = text.substring(to: cursorPosition)
                
                // Get the string after the cursor
                let afterCursor = text.substring(from: cursorPosition)
                textBeforeCursor = beforeCursor
                textAfterCursor = afterCursor
                
                //test > get length
                let textLength = text.length
                print("xy0 Before cursor: \(beforeCursor), After cursor: \(afterCursor); \(cursorPosition), \(textLength)")
            }
        }
    }
    //**
    
    //test > implement character limit
    //    private func textView(_ textView: UITextView, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //        let maxLength = 20
    //        let currentString: NSString = (textView.text ?? "") as NSString
    //        let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
    //
    //        return newString.length <= maxLength
    //    }

    //    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    //
    ////        if(textField == bTextField) {
    ////            print("textfielddelegate return: ")
    ////            resignResponder()
    ////        }
    //
    //        return true
    //    }
}


extension PostCreatorConsolePanelView: CameraPhotoRollPanelDelegate{
    func didInitializeCameraPhotoRoll() {
        //test to turn off camera
//        session?.removeInput(videoDeviceInput!) //test
//        self.session?.stopRunning()
    }
    func didClickFinishCameraPhotoRoll() {
//        backPage()
    }
    func didClickPhotoSelect(photo: PHAsset) {

    }
    func didClickMultiPhotoSelect(urls: [URL]){
        if(!urls.isEmpty) {
//            let imgUrl = urls[0]
//            aPhotoB.sd_setImage(with: imgUrl)
            
            print("multiphotoclick \(selectedPcIndex)")
            if(selectedPcIndex > -1) {
                addContentAtText(urls: urls, dataType: "p")
            } else {
                addContentAtMain(urls: urls, dataType: "p")
            }
        }
    }
}

extension PostCreatorConsolePanelView: CameraVideoRollPanelDelegate{
    func didInitializeCameraVideoRoll() {

    }
    func didClickFinishCameraVideoRoll() {

    }
    func didClickVideoSelect(video: PHAsset) {
        print("postcreator cameravideo click")
        //test > convert PHAsset to AVAsset
//        PHCachingImageManager.default().requestAVAsset(forVideo: video, options: nil) { [weak self] (video, _, _) in
//
//            if let avVid = video
//            {
//                DispatchQueue.main.async {
//                    
//                    //test 2 > open with url => tested OK
//                    //try get url from avasset
//                    if let strURL = (video as? AVURLAsset)?.url.absoluteString {
//                        print("VIDEO URL: ", strURL)
//
//                    }
//                }
//            }
//        }
    }
    
    func didClickMultiVideoSelect(urls: [String]){
        print("postcreator cameravideo multi click \(urls)")
        if(!urls.isEmpty) {
            var vUrls = [URL]()
            for url in urls {
                let vUrl = URL(fileURLWithPath: url)
                vUrls.append(vUrl)
            }
            
            if(selectedPcIndex > -1) {
//                addContentAtText(urls: vUrls, dataType: "v_l")
                addContentAtText(urls: vUrls, dataType: "q") //test
            } else {
//                addContentAtMain(urls: vUrls, dataType: "v_l")
                addContentAtMain(urls: vUrls, dataType: "q") //test
            }
        }
    }
}

extension PostCreatorConsolePanelView: PostDraftPanelDelegate{
    func didClickClosePostDraftPanel() {
        
//        backPage(isCurrentPageScrollable: false)
    }
}

extension PostCreatorConsolePanelView: ExitVideoEditorMsgDelegate{
    func didSVDClickProceed() {
        closePostCreatorPanel(isAnimated: true)
    }
    func didSVDClickDeny() {
//        delegate?.didDenyExitVideoEditor()
    }
    func didSVDInitialize() {
//        delegate?.didPromptExitVideoEditor()
    }
}

extension PostCreatorConsolePanelView: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("xxpc scrollview begin: \(scrollView.contentOffset.y)")
        let scrollOffsetY = scrollView.contentOffset.y
        
        clearErrorUI()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("xxpc scrollview scroll: \(scrollView.contentOffset.y), \(stackView.frame.height)")

        let scrollOffsetY = scrollView.contentOffset.y
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("xxpc scrollview end: \(scrollView.contentOffset.y)")
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("xxpc scrollview end drag: \(scrollView.contentOffset.y)")
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("xxpc scrollview animation ended")
    }
}
