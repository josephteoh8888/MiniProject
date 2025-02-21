//
//  PlaceCreatorConsolePanelView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage
import PhotosUI
import Photos

protocol PlaceCreatorPanelDelegate : AnyObject {
    func didInitializePlaceCreator()
    func didClickFinishPlaceCreator()
    
    //test > select location with map
    func didPlaceCreatorClickLocationSelectScrollable()
    
    func didPlaceCreatorClickSignIn()
    func didPlaceCreatorClickUpload(payload: String)
}

class PlaceCreatorConsolePanelView: CreatorPanelView{
    
    var panel = UIView()
    var currentPanelTopCons : CGFloat = 0.0
    var panelTopCons: NSLayoutConstraint?
    
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    weak var delegate : PlaceCreatorPanelDelegate?
    
    let aPhotoB = SDAnimatedImageView()
//    let pTextField = UITextView()
    let pTextField = UITextField()
    let qTextField = UITextView()
//    let rTextField = UITextView()
    let rTextField = UITextField()
    let pHint = UILabel()
    let qHint = UILabel()
    let rHint = UILabel()
    
    let aBoxUnder = UIView()
    
    let aUpload = UIView()
    let aSaveDraft = UIView()
    let aSpinner = SpinLoader()
    let bSpinner = SpinLoader()
    
    let rHintText = UILabel()
    
    //test > user login/out status
    var isUserLoggedIn = false
    
    var maxSelectLimit = 5
    let maxLimitErrorPanel = UIView()
    let maxLimitText = UILabel()
    let pMiniError = UIView()
    let lMiniError = UIView()
    let mMiniError = UIView()
    
    //test > use pre-designated sound or location
    var predesignatedPlaceList = [String]()
    let aText = UILabel()
    let aGrid = UIView()
    
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
        aBtn.backgroundColor = .clear
        panel.addSubview(aBtn)
        aBtn.translatesAutoresizingMaskIntoConstraints = false
        aBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
        aBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        aBtn.leadingAnchor.constraint(equalTo: aStickyHeader.leadingAnchor, constant: 10).isActive = true
        aBtn.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 10).isActive = true
    //        aBtn.topAnchor.constraint(equalTo: userPanel.topAnchor, constant: 30).isActive = true
//        aBtn.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
//        let topInsetMargin = panel.safeAreaInsets.top + 10
        aBtn.topAnchor.constraint(equalTo: panel.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
//        aBtn.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        aBtn.layer.cornerRadius = 20
//        aBtn.layer.opacity = 0.3
        aBtn.isUserInteractionEnabled = true
        aBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackPlaceCreatorPanelClicked)))

//        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_arrow_down_a")?.withRenderingMode(.alwaysTemplate))
        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_close")?.withRenderingMode(.alwaysTemplate))
        bMiniBtn.tintColor = .ddmDarkGrayColor
//        bMiniBtn.tintColor = .ddmBlackDark
//        aStickyHeader.addSubview(bMiniBtn)
        panel.addSubview(bMiniBtn)
        bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        bMiniBtn.centerXAnchor.constraint(equalTo: aBtn.centerXAnchor).isActive = true
        bMiniBtn.centerYAnchor.constraint(equalTo: aBtn.centerYAnchor).isActive = true
        bMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true //26
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
        aCreateTitleText.text = "New Location"
        
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
        //test
        scrollView.isUserInteractionEnabled = true
        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBoxUnderClicked)))
        
        let stackView = UIView()
        stackView.backgroundColor = .clear
//        stackView.backgroundColor = .blue
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
//        stackView.isUserInteractionEnabled = true
//        stackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBoxUnderClicked)))
        
//        let aCreateTitleText = UILabel()
//        aCreateTitleText.textAlignment = .center
//        aCreateTitleText.textColor = .white
////        aCreateTitleText.textColor = .ddmBlackOverlayColor
//        aCreateTitleText.font = .boldSystemFont(ofSize: 14) //16
//        stackView.addSubview(aCreateTitleText)
//        aCreateTitleText.translatesAutoresizingMaskIntoConstraints = false
//        aCreateTitleText.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 30).isActive = true
//        aCreateTitleText.centerXAnchor.constraint(equalTo: stackView.centerXAnchor, constant: 0).isActive = true
//        aCreateTitleText.text = "New Location"
        
//        let aPhotoB = SDAnimatedImageView()
        stackView.addSubview(aPhotoB)
        aPhotoB.translatesAutoresizingMaskIntoConstraints = false
        aPhotoB.widthAnchor.constraint(equalToConstant: 100).isActive = true
        aPhotoB.heightAnchor.constraint(equalToConstant: 100).isActive = true
        aPhotoB.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 40).isActive = true
//        aPhotoB.topAnchor.constraint(equalTo: aCreateTitleText.topAnchor, constant: 30).isActive = true //test
        aPhotoB.centerXAnchor.constraint(equalTo: stackView.centerXAnchor, constant: 0).isActive = true
//        let bImageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        aPhotoB.contentMode = .scaleAspectFill
        aPhotoB.layer.masksToBounds = true
        aPhotoB.layer.cornerRadius = 10
//        aPhotoB.sd_setImage(with: bImageUrl)
        aPhotoB.backgroundColor = .ddmDarkColor
        aPhotoB.isUserInteractionEnabled = true
        aPhotoB.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onAddPhotoClicked)))
        
        let lhsAddBtn = UIImageView(image: UIImage(named:"icon_round_add_circle")?.withRenderingMode(.alwaysTemplate))
        lhsAddBtn.tintColor = .white //.ddmBlackOverlayColor
        stackView.addSubview(lhsAddBtn)
        lhsAddBtn.translatesAutoresizingMaskIntoConstraints = false
        lhsAddBtn.leadingAnchor.constraint(equalTo: aPhotoB.trailingAnchor, constant: -10).isActive = true
        lhsAddBtn.bottomAnchor.constraint(equalTo: aPhotoB.bottomAnchor, constant: 10).isActive = true
        lhsAddBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true //ori 30
        lhsAddBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        lhsAddBtn.isUserInteractionEnabled = true
        lhsAddBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onAddPhotoClicked)))
        
        mMiniError.backgroundColor = .red
        stackView.addSubview(mMiniError)
        mMiniError.translatesAutoresizingMaskIntoConstraints = false
        mMiniError.leadingAnchor.constraint(equalTo: lhsAddBtn.trailingAnchor, constant: 5).isActive = true
        mMiniError.centerYAnchor.constraint(equalTo: lhsAddBtn.centerYAnchor, constant: 0).isActive = true
//        mMiniError.topAnchor.constraint(equalTo: maxLimitErrorPanel.topAnchor, constant: 5).isActive = true
//        mMiniError.bottomAnchor.constraint(equalTo: pText.topAnchor, constant: -5).isActive = true
        mMiniError.heightAnchor.constraint(equalToConstant: 20).isActive = true
        mMiniError.widthAnchor.constraint(equalToConstant: 20).isActive = true
        mMiniError.layer.cornerRadius = 10
        mMiniError.isHidden = true

        let mMiniBtn = UIImageView(image: UIImage(named:"icon_round_priority")?.withRenderingMode(.alwaysTemplate))
        mMiniBtn.tintColor = .white
        mMiniError.addSubview(mMiniBtn)
        mMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        mMiniBtn.centerXAnchor.constraint(equalTo: mMiniError.centerXAnchor).isActive = true
        mMiniBtn.centerYAnchor.constraint(equalTo: mMiniError.centerYAnchor).isActive = true
        mMiniBtn.heightAnchor.constraint(equalToConstant: 12).isActive = true
        mMiniBtn.widthAnchor.constraint(equalToConstant: 12).isActive = true
        
        //test 2 > design 2
        let pResult = UIView()
//        pResult.backgroundColor = .ddmDarkColor
        pResult.backgroundColor = .ddmDarkBlack
        stackView.addSubview(pResult)
        pResult.translatesAutoresizingMaskIntoConstraints = false
//        pResult.leadingAnchor.constraint(equalTo: pText.leadingAnchor, constant: 0).isActive = true
//        pResult.trailingAnchor.constraint(equalTo: pText.trailingAnchor, constant: 0).isActive = true
//        pResult.topAnchor.constraint(equalTo: pText.bottomAnchor, constant: 10).isActive = true
//        pResult.leadingAnchor.constraint(equalTo: aPhotoB.leadingAnchor, constant: 0).isActive = true
        pResult.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20).isActive = true
        pResult.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20).isActive = true
        pResult.topAnchor.constraint(equalTo: aPhotoB.bottomAnchor, constant: 20).isActive = true
        pResult.heightAnchor.constraint(equalToConstant: 40).isActive = true
        pResult.layer.cornerRadius = 5
//        pResult.layer.opacity = 0.1 //0.1
        pResult.isUserInteractionEnabled = true
        pResult.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onAddPTextClicked)))
        
        let pText = UILabel()
        pText.textAlignment = .left
        pText.textColor = .white
        pText.font = .boldSystemFont(ofSize: 14)
        stackView.addSubview(pText)
        pText.translatesAutoresizingMaskIntoConstraints = false
        pText.leadingAnchor.constraint(equalTo: pResult.leadingAnchor, constant: 10).isActive = true
//        pText.trailingAnchor.constraint(equalTo: pResult.trailingAnchor, constant: -20).isActive = true
        pText.centerYAnchor.constraint(equalTo: pResult.centerYAnchor, constant: 0).isActive = true
//        pText.topAnchor.constraint(equalTo: pResult.bottomAnchor, constant: 20).isActive = true
        pText.text = "Name"
//        pText.layer.opacity = 0.5
        
//        let pMiniError = UIView()
        pMiniError.backgroundColor = .red
        stackView.addSubview(pMiniError)
        pMiniError.translatesAutoresizingMaskIntoConstraints = false
        pMiniError.trailingAnchor.constraint(equalTo: pResult.trailingAnchor, constant: -5).isActive = true
        pMiniError.centerYAnchor.constraint(equalTo: pResult.centerYAnchor, constant: 0).isActive = true
//        pMiniError.topAnchor.constraint(equalTo: maxLimitErrorPanel.topAnchor, constant: 5).isActive = true
//        pMiniError.bottomAnchor.constraint(equalTo: maxLimitErrorPanel.bottomAnchor, constant: -5).isActive = true
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
        
        let qResult = UIView()
//        qResult.backgroundColor = .ddmDarkColor
        qResult.backgroundColor = .ddmDarkBlack
        stackView.addSubview(qResult)
        qResult.translatesAutoresizingMaskIntoConstraints = false
//        qResult.leadingAnchor.constraint(equalTo: pText.leadingAnchor, constant: 0).isActive = true
//        qResult.trailingAnchor.constraint(equalTo: pText.trailingAnchor, constant: 0).isActive = true
//        qResult.topAnchor.constraint(equalTo: pText.bottomAnchor, constant: 10).isActive = true
        qResult.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20).isActive = true
//        qResult.leadingAnchor.constraint(equalTo: aPhotoB.leadingAnchor, constant: 0).isActive = true
        qResult.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20).isActive = true
        qResult.topAnchor.constraint(equalTo: pResult.bottomAnchor, constant: 10).isActive = true
        qResult.heightAnchor.constraint(equalToConstant: 80).isActive = true //40
        qResult.layer.cornerRadius = 5
//        qResult.layer.opacity = 0.1
        qResult.isUserInteractionEnabled = true
        qResult.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onAddQTextClicked)))
        qResult.isHidden = true
        
        let qText = UILabel()
        qText.textAlignment = .left
        qText.textColor = .white
        qText.font = .boldSystemFont(ofSize: 14)
        stackView.addSubview(qText)
        qText.translatesAutoresizingMaskIntoConstraints = false
        qText.leadingAnchor.constraint(equalTo: qResult.leadingAnchor, constant: 10).isActive = true
//        qText.trailingAnchor.constraint(equalTo: pResult.trailingAnchor, constant: -20).isActive = true
//        qText.centerYAnchor.constraint(equalTo: qResult.centerYAnchor, constant: 0).isActive = true
        qText.topAnchor.constraint(equalTo: qResult.topAnchor, constant: 10).isActive = true
        qText.text = "Bio"
//        qText.layer.opacity = 0.5
        qText.isHidden = true
        
        let rResult = UIView()
//        rResult.backgroundColor = .ddmDarkColor
        rResult.backgroundColor = .ddmDarkBlack
        stackView.addSubview(rResult)
        rResult.translatesAutoresizingMaskIntoConstraints = false
//        rResult.leadingAnchor.constraint(equalTo: pText.leadingAnchor, constant: 0).isActive = true
//        rResult.trailingAnchor.constraint(equalTo: pText.trailingAnchor, constant: 0).isActive = true
//        rResult.topAnchor.constraint(equalTo: pText.bottomAnchor, constant: 10).isActive = true
        rResult.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20).isActive = true
//        rResult.leadingAnchor.constraint(equalTo: aPhotoB.leadingAnchor, constant: 0).isActive = true
        rResult.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20).isActive = true
        rResult.topAnchor.constraint(equalTo: pResult.bottomAnchor, constant: 10).isActive = true
        rResult.heightAnchor.constraint(equalToConstant: 40).isActive = true
        rResult.layer.cornerRadius = 5
//        rResult.layer.opacity = 0.1
        rResult.isUserInteractionEnabled = true
        rResult.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onAddRTextClicked)))
        
        let rText = UILabel()
        rText.textAlignment = .left
        rText.textColor = .white
        rText.font = .boldSystemFont(ofSize: 14)
        stackView.addSubview(rText)
        rText.translatesAutoresizingMaskIntoConstraints = false
        rText.leadingAnchor.constraint(equalTo: rResult.leadingAnchor, constant: 10).isActive = true
//        rText.trailingAnchor.constraint(equalTo: pResult.trailingAnchor, constant: -20).isActive = true
        rText.centerYAnchor.constraint(equalTo: rResult.centerYAnchor, constant: 0).isActive = true
//        rText.topAnchor.constraint(equalTo: pResult.bottomAnchor, constant: 20).isActive = true
//        rText.text = "Location"
        rText.text = "Where"
//        rText.layer.opacity = 0.5
        
        let bGrid = UIView()
//        bGrid.backgroundColor = .ddmDarkColor
        bGrid.backgroundColor = .ddmDarkBlack
        stackView.addSubview(bGrid)
        bGrid.translatesAutoresizingMaskIntoConstraints = false
        bGrid.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20).isActive = true
        bGrid.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20).isActive = true
        bGrid.topAnchor.constraint(equalTo: rResult.bottomAnchor, constant: 40).isActive = true //10
        bGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        bGrid.layer.cornerRadius = 5
//        bGrid.layer.opacity = 0.1
        bGrid.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 0).isActive = true //10
        
        let bGridBG = UIView()
//        bGridBG.backgroundColor = .ddmDarkColor
        stackView.addSubview(bGridBG)
        bGridBG.translatesAutoresizingMaskIntoConstraints = false
        bGridBG.leadingAnchor.constraint(equalTo: bGrid.leadingAnchor, constant: 10).isActive = true
        bGridBG.heightAnchor.constraint(equalToConstant: 30).isActive = true
        bGridBG.widthAnchor.constraint(equalToConstant: 30).isActive = true
        bGridBG.centerYAnchor.constraint(equalTo: bGrid.centerYAnchor, constant: 0).isActive = true
        bGridBG.layer.cornerRadius = 5 //20
        
        let bGridIcon = UIImageView(image: UIImage(named:"icon_round_lock_open")?.withRenderingMode(.alwaysTemplate))
        bGridIcon.tintColor = .white
        stackView.addSubview(bGridIcon)
        bGridIcon.translatesAutoresizingMaskIntoConstraints = false
        bGridIcon.centerXAnchor.constraint(equalTo: bGridBG.centerXAnchor).isActive = true
        bGridIcon.centerYAnchor.constraint(equalTo: bGridBG.centerYAnchor).isActive = true
        bGridIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        bGridIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let bText = UILabel()
        bText.textAlignment = .left
        bText.textColor = .white
//        bText.font = .boldSystemFont(ofSize: 13)
        bText.font = .systemFont(ofSize: 14)
        stackView.addSubview(bText)
        bText.translatesAutoresizingMaskIntoConstraints = false
        bText.centerYAnchor.constraint(equalTo: bGrid.centerYAnchor, constant: 0).isActive = true
        bText.leadingAnchor.constraint(equalTo: bGridBG.trailingAnchor, constant: 10).isActive = true
//        bText.text = "Everyone Can See"
//        bText.text = "Public Location"
//        bText.layer.opacity = 0.5
        bText.text = "Public"
        
        let bArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
//        bArrowBtn.tintColor = .white
        bArrowBtn.tintColor = .ddmDarkGrayColor
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
//        draftBox.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -60).isActive = true
        draftBox.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        draftBox.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 20).isActive = true
//        draftBox.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20).isActive = true
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
        
        let stack1 = UIView()
        let stack2 = UIView()
        
//        let aSaveDraft = UIView()
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
        
        stack1.addSubview(bSpinner)
        bSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        bSpinner.translatesAutoresizingMaskIntoConstraints = false
        bSpinner.centerYAnchor.constraint(equalTo: aSaveDraft.centerYAnchor).isActive = true
        bSpinner.centerXAnchor.constraint(equalTo: aSaveDraft.centerXAnchor).isActive = true
        bSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        bSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        bSpinner.isUserInteractionEnabled = false
        
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
        aUpload.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPlaceUploadNextClicked)))

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
        aUploadText.text = "Create"
        
        stack2.addSubview(aSpinner)
        aSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        aSpinner.translatesAutoresizingMaskIntoConstraints = false
        aSpinner.centerYAnchor.constraint(equalTo: aUpload.centerYAnchor).isActive = true
        aSpinner.centerXAnchor.constraint(equalTo: aUpload.centerXAnchor).isActive = true
        aSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        aSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        aSpinner.isUserInteractionEnabled = false
        
//        let stackViewA = UIStackView(arrangedSubviews: [stack1, stack2])
        let stackViewA = UIStackView(arrangedSubviews: [stack2])
        stackViewA.distribution = .fillEqually
//        stackViewA.backgroundColor = .black
//        stackViewA.backgroundColor = .blue
        panel.addSubview(stackViewA)
        stackViewA.translatesAutoresizingMaskIntoConstraints = false
//        stackViewA.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -60).isActive = true //-50
        stackViewA.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        stackViewA.heightAnchor.constraint(equalToConstant: 40).isActive = true //ori 40
        stackViewA.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 20).isActive = true
//        stackViewA.leadingAnchor.constraint(equalTo: draftBox.trailingAnchor, constant: 20).isActive = true
        stackViewA.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20).isActive = true
        
        pTextField.textAlignment = .left
        pTextField.textColor = .white
        pTextField.backgroundColor = .clear
//        pTextField.backgroundColor = .red
        pTextField.font = .systemFont(ofSize: 14)
//        panel.addSubview(pTextField)
        stackView.addSubview(pTextField)
        pTextField.translatesAutoresizingMaskIntoConstraints = false
        pTextField.leadingAnchor.constraint(equalTo: pResult.leadingAnchor, constant: 100).isActive = true //105
        pTextField.trailingAnchor.constraint(equalTo: pResult.trailingAnchor, constant: -10).isActive = true
        pTextField.topAnchor.constraint(equalTo: pResult.topAnchor, constant: 2).isActive = true //2
        pTextField.bottomAnchor.constraint(equalTo: pResult.bottomAnchor, constant: -2).isActive = true //-2
//        pTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true //test
        pTextField.text = ""
        pTextField.tintColor = .yellow
        pTextField.delegate = self
        pTextField.placeholder = "Give it a nice name"
        
        qTextField.textAlignment = .left
        qTextField.textColor = .white
        qTextField.backgroundColor = .clear
//        qTextField.backgroundColor = .red
        qTextField.font = .systemFont(ofSize: 14)
//        panel.addSubview(qTextField)
        stackView.addSubview(qTextField)
        qTextField.translatesAutoresizingMaskIntoConstraints = false
        qTextField.leadingAnchor.constraint(equalTo: qResult.leadingAnchor, constant: 100).isActive = true
        qTextField.trailingAnchor.constraint(equalTo: qResult.trailingAnchor, constant: -10).isActive = true
        qTextField.topAnchor.constraint(equalTo: qResult.topAnchor, constant: 2).isActive = true
        qTextField.bottomAnchor.constraint(equalTo: qResult.bottomAnchor, constant: -2).isActive = true
//        qTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true //test
        qTextField.text = ""
        qTextField.tintColor = .yellow
//        qTextField.delegate = self
        qTextField.isHidden = true
        
        rTextField.textAlignment = .left
        rTextField.textColor = .white
        rTextField.backgroundColor = .clear
//        rTextField.backgroundColor = .red
        rTextField.font = .systemFont(ofSize: 14)
//        panel.addSubview(rTextField)
        stackView.addSubview(rTextField)
        rTextField.translatesAutoresizingMaskIntoConstraints = false
        rTextField.leadingAnchor.constraint(equalTo: rResult.leadingAnchor, constant: 110).isActive = true //105
        rTextField.trailingAnchor.constraint(equalTo: rResult.trailingAnchor, constant: -10).isActive = true
        rTextField.topAnchor.constraint(equalTo: rResult.topAnchor, constant: 2).isActive = true
        rTextField.bottomAnchor.constraint(equalTo: rResult.bottomAnchor, constant: -2).isActive = true
//        rTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        rTextField.text = ""
        rTextField.tintColor = .yellow
        rTextField.placeholder = "Where's your new place..."
        rTextField.isHidden = true
        
//        let rHintText = UILabel()
        rHintText.textAlignment = .left
        rHintText.textColor = .white
        rHintText.font = .systemFont(ofSize: 14)
//        panel.addSubview(aUploadText)
        stackView.addSubview(rHintText)
        rHintText.translatesAutoresizingMaskIntoConstraints = false
        rHintText.leadingAnchor.constraint(equalTo: rResult.leadingAnchor, constant: 100).isActive = true
        rHintText.trailingAnchor.constraint(equalTo: rResult.trailingAnchor, constant: -10).isActive = true
        rHintText.topAnchor.constraint(equalTo: rResult.topAnchor, constant: 2).isActive = true
        rHintText.bottomAnchor.constraint(equalTo: rResult.bottomAnchor, constant: -2).isActive = true
        rHintText.text = "Locate your new place..."
        rHintText.layer.opacity = 0.3
//        rHintText.textColor = .ddmDarkBlack
        
//        let aGrid = UIView()
        stackView.addSubview(aGrid)
        aGrid.translatesAutoresizingMaskIntoConstraints = false
        aGrid.leadingAnchor.constraint(equalTo: rResult.leadingAnchor, constant: 100).isActive = true
        aGrid.centerYAnchor.constraint(equalTo: rResult.centerYAnchor, constant: 0).isActive = true
        aGrid.isHidden = true
        
        let aGridBG = UIView()
//        aGridBG.backgroundColor = .ddmDarkColor
//        panel.addSubview(aGridBG)
        aGrid.addSubview(aGridBG)
        aGridBG.translatesAutoresizingMaskIntoConstraints = false
        aGridBG.leadingAnchor.constraint(equalTo: aGrid.leadingAnchor, constant: 0).isActive = true
        aGridBG.heightAnchor.constraint(equalToConstant: 20).isActive = true
        aGridBG.widthAnchor.constraint(equalToConstant: 20).isActive = true
        aGridBG.topAnchor.constraint(equalTo: aGrid.topAnchor, constant: 0).isActive = true
        aGridBG.bottomAnchor.constraint(equalTo: aGrid.bottomAnchor, constant: 0).isActive = true
//        aGridBG.layer.cornerRadius = 5 //20
        
        let aGridIcon = UIImageView(image: UIImage(named:"icon_location")?.withRenderingMode(.alwaysTemplate))
        aGridIcon.tintColor = .white
//        panel.addSubview(aGridIcon)
        aGridBG.addSubview(aGridIcon)
        aGridIcon.translatesAutoresizingMaskIntoConstraints = false
        aGridIcon.centerXAnchor.constraint(equalTo: aGridBG.centerXAnchor).isActive = true
        aGridIcon.centerYAnchor.constraint(equalTo: aGridBG.centerYAnchor).isActive = true
        aGridIcon.heightAnchor.constraint(equalToConstant: 16).isActive = true
        aGridIcon.widthAnchor.constraint(equalToConstant: 16).isActive = true
        
//        let aText = UILabel()
        aText.textAlignment = .left
        aText.textColor = .white
//        aText.font = .boldSystemFont(ofSize: 14)
        aText.font = .systemFont(ofSize: 14)
//        panel.addSubview(aText)
        aGrid.addSubview(aText)
        aText.translatesAutoresizingMaskIntoConstraints = false
        aText.centerYAnchor.constraint(equalTo: aGrid.centerYAnchor, constant: 0).isActive = true
        aText.leadingAnchor.constraint(equalTo: aGridBG.trailingAnchor, constant: 0).isActive = true
        aText.trailingAnchor.constraint(equalTo: aGrid.trailingAnchor, constant: 0).isActive = true
//        aText.text = "Everyone Can See"
//        aText.text = "Petronas Twin Tower"
        
        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .ddmDarkGrayColor
//        aStickyHeader.addSubview(bMiniBtn)
        stackView.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: rResult.trailingAnchor).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: rResult.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        rArrowBtn.layer.opacity = 0.5
        
        lMiniError.backgroundColor = .red
        stackView.addSubview(lMiniError)
        lMiniError.translatesAutoresizingMaskIntoConstraints = false
        lMiniError.trailingAnchor.constraint(equalTo: rArrowBtn.leadingAnchor, constant: -5).isActive = true
        lMiniError.centerYAnchor.constraint(equalTo: rResult.centerYAnchor, constant: 0).isActive = true
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
        
        //test > error handling max selected limit
//        maxLimitErrorPanel.backgroundColor = .ddmBlackOverlayColor //black
        maxLimitErrorPanel.backgroundColor = .white //black
        panel.addSubview(maxLimitErrorPanel)
        maxLimitErrorPanel.translatesAutoresizingMaskIntoConstraints = false
        maxLimitErrorPanel.centerXAnchor.constraint(equalTo: panel.centerXAnchor, constant: 0).isActive = true
//        maxLimitErrorPanel.leadingAnchor.constraint(equalTo: panelView.leadingAnchor, constant: 0).isActive = true
//        maxLimitErrorPanel.trailingAnchor.constraint(equalTo: panelView.trailingAnchor, constant: 0).isActive = true
        maxLimitErrorPanel.layer.cornerRadius = 10
        maxLimitErrorPanel.bottomAnchor.constraint(equalTo: stackViewA.topAnchor, constant: -10).isActive = true
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
    
    @objc func onBackPlaceCreatorPanelClicked(gesture: UITapGestureRecognizer) {
        
        resignResponder()
//        openSavePlaceDraftPromptMsg()
        
        //test
//        openExitVideoEditorPromptMsg()
        
        //test 2
        let isSignedIn = SignInManager.shared.getStatus()
        if(isSignedIn) {
            openExitVideoEditorPromptMsg()
        }
        else {
            closePlaceCreatorPanel(isAnimated: true)
        }
    }
    
    @objc func onPlaceUploadNextClicked(gesture: UITapGestureRecognizer) {
        clearErrorUI()
        resignResponder()
        
        let isSignedIn = SignInManager.shared.getStatus()
        if(isSignedIn) {

            if(pTextField.text == "") {
                configureErrorUI(data: "na-name")
            } else {
                if(selectedPlaceList.isEmpty) {
                    configureErrorUI(data: "na-location")
                }
                else {
                    aUpload.isHidden = true
                    aSpinner.startAnimating()
                    
                    //test 2 > new method to upload data => for in-app msg view
                    self.closePlaceCreatorPanel(isAnimated: true)
                    delegate?.didPlaceCreatorClickUpload(payload: "cc") //payload e.g. location name
                }
            }
        }
        else {
            delegate?.didPlaceCreatorClickSignIn()
        }
    }
    
    @objc func onSaveDraftNextClicked(gesture: UITapGestureRecognizer) {
        clearErrorUI()
        resignResponder()
        
        let isSignedIn = SignInManager.shared.getStatus()
        if(isSignedIn) {
            
            aSaveDraft.isHidden = true
            bSpinner.startAnimating()
            
            DataUploadManager.shared.sendData(id: "u") { [weak self]result in
                switch result {
                    case .success(let l):

                    //update UI on main thread
                    DispatchQueue.main.async {

                        self?.closePlaceCreatorPanel(isAnimated: true)
                    }

                    case .failure(_):
                        print("api fail")
                        break
                }
            }
        }
        else {
            delegate?.didPlaceCreatorClickSignIn()
        }
    }
    
    @objc func onBoxUnderClicked(gesture: UITapGestureRecognizer) {
        print("box under")
        resignResponder()
    }
    
    //test
    override func resumeActiveState() {
        print("placecreatorpanelview resume active")
        
        //test > check for signin status when in active state
        asyncFetchSigninStatus()
    }
    
    //test > initialization state => !!already exist in layoutsubview
    var isInitialized = false
    func initialize(topInset: CGFloat, bottomInset: CGFloat) {
        //test
        asyncFetchSigninStatus()
    }
    //test
    func initialize() {
        if(!isInitialized) {
            if(isUserLoggedIn) {

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
    
    func setPredesignatedPlace(p: String) {
        predesignatedPlaceList.append("p")
//        refreshTitleUI()
        
        if(!predesignatedPlaceList.isEmpty) {
            setSelectedLocation(l: "p")
        }
    }
    
    //test
    override func showLocationSelected() {
        print("showLocationSelected")
        
//        rHintText.isHidden = true
//        
//        aGrid.isHidden = false
//        aText.text = mapPinString
        
        setSelectedLocation(l: mapPinString)
    }
    
    var selectedPlaceList = [String]()
    func setSelectedLocation(l : String) {
        removeSelectedLocation()
        
        rHintText.isHidden = true
        
        aGrid.isHidden = false
        
        if(selectedPlaceList.isEmpty) {
            selectedPlaceList.append("p")
            aText.text = l
        }
    }
    
    func removeSelectedLocation() {
        rHintText.isHidden = false
        
        aGrid.isHidden = true
        
        if(!selectedPlaceList.isEmpty) {
            selectedPlaceList.removeLast()
            aText.text = ""
        }
    }
    
    func resignResponder() {
        self.endEditing(true)
    }
    
    func activate(textView: UITextView) {
        setFirstResponder(textView: textView)
    }
    
    func setFirstResponder(textView: UITextView) {
        textView.becomeFirstResponder()
    }
    
    func activate(textField: UITextField) {
        setFirstResponder(textField: textField)
    }
    func setFirstResponder(textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    @objc func onAddPTextClicked(gesture: UITapGestureRecognizer) {
//        activate(textField: pTextField) //test
    }
    
    @objc func onAddQTextClicked(gesture: UITapGestureRecognizer) {
//        activate(textView: qTextField)
    }
    @objc func onAddRTextClicked(gesture: UITapGestureRecognizer) {
        clearErrorUI()
        resignResponder()
        
//        activate(textField: rTextField) //test
        
        //test > init add location panel
//        self.isHidden = true
        
        //test 2
        let isSignedIn = SignInManager.shared.getStatus()
        if(isSignedIn) {
            delegate?.didPlaceCreatorClickLocationSelectScrollable()
        }
        else {
            delegate?.didPlaceCreatorClickSignIn()
        }
    }
    @objc func onAddPhotoClicked(gesture: UITapGestureRecognizer) {
        
        clearErrorUI()
        resignResponder()
        
        let isSignedIn = SignInManager.shared.getStatus()
        if(isSignedIn) {
            openCameraRoll()
        }
        else {
            delegate?.didPlaceCreatorClickSignIn()
        }
    }
    @objc func onDraftBoxClicked(gesture: UITapGestureRecognizer) {

    }
    
    func closePlaceCreatorPanel(isAnimated: Bool) {
        if(isAnimated) {
            UIView.animate(withDuration: 0.2, animations: { //default: 0.2
                self.panelTopCons?.constant = 0
                self.layoutIfNeeded()
            }, completion: { _ in
                self.removeFromSuperview()

                self.delegate?.didClickFinishPlaceCreator()
            })
        } else {
            self.removeFromSuperview()
            
            self.delegate?.didClickFinishPlaceCreator()
        }
    }
    
    func openSavePlaceDraftPromptMsg() {
        let saveDraftPanel = SavePlaceDraftMsgView(frame: CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.height))
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
        exitVideoPanel.setType(t: "place")
    }
    func openCameraRoll() {
        let cameraRollPanel = CameraPhotoRollPanelView(frame: CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.height))
        panel.addSubview(cameraRollPanel)
        cameraRollPanel.translatesAutoresizingMaskIntoConstraints = false
        cameraRollPanel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        cameraRollPanel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        cameraRollPanel.delegate = self
    }
    
    func configureErrorUI(data: String) {
        if(data == "e") {
            maxLimitText.text = "Error occurred. Try again"
        }
        else if(data == "na-photo") {
            maxLimitText.text = "Photo is required"
            mMiniError.isHidden = false
        }
        else if(data == "na-name") {
            maxLimitText.text = "Name is required"
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
        mMiniError.isHidden = true
    }
}

extension PlaceCreatorConsolePanelView: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("xx2 scrollview begin: \(scrollView.contentOffset.y)")
        let scrollOffsetY = scrollView.contentOffset.y
        
        resignResponder()
        
        clearErrorUI()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("xx2 scrollview scroll: \(scrollView.contentOffset.y)")

        let scrollOffsetY = scrollView.contentOffset.y
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("xx2 scrollview end: \(scrollView.contentOffset.y)")
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("xx2 scrollview end drag: \(scrollView.contentOffset.y)")
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("xx2 scrollview animation ended")
    }
}

extension PlaceCreatorConsolePanelView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textfield begin edit")
        
        //test
        clearErrorUI()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textfield end edit")
    }
}

extension ViewController: PlaceCreatorPanelDelegate{
    func didInitializePlaceCreator() {
        
    }
    
    func didClickFinishPlaceCreator() {
        print("pagelist: \(pageList)")
        //test 1 > as not scrollable
        backPage(isCurrentPageScrollable: false)
        
        //test 2 > as scrollable
//        backPage(isCurrentPageScrollable: true)
    }
    
    func didPlaceCreatorClickLocationSelectScrollable(){
        openLocationSelectScrollablePanel()
    }
    
    func didPlaceCreatorClickSignIn(){
        openLoginPanel()
    }
    
    func didPlaceCreatorClickUpload(payload: String) {
        
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
                        a.updateConfigUI(data: "up_place", taskId: "a")
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
                        a.updateConfigUI(data: "up_place", taskId: "a")
                    }
                }
                break
            }
        }
        
        openInAppMsgView(data: "up_place")
    }
}

extension PlaceCreatorConsolePanelView: CameraPhotoRollPanelDelegate{
    func didInitializeCameraPhotoRoll() {

    }
    func didClickFinishCameraPhotoRoll() {

    }
    func didClickPhotoSelect(photo: PHAsset) {

    }
    func didClickMultiPhotoSelect(urls: [URL]){
        if(!urls.isEmpty) {
            let imgUrl = urls[0]
            aPhotoB.sd_setImage(with: imgUrl)
        }
    }
}

extension PlaceCreatorConsolePanelView: ExitVideoEditorMsgDelegate{
    func didSVDClickProceed() {
        closePlaceCreatorPanel(isAnimated: true)
    }
    func didSVDClickDeny() {
//        delegate?.didDenyExitVideoEditor()
    }
    func didSVDInitialize() {
//        delegate?.didPromptExitVideoEditor()
    }
}
