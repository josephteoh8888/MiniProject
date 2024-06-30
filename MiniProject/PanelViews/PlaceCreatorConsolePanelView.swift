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
}
class PlaceCreatorConsolePanelView: CreatorPanelView{
//class PlaceCreatorConsolePanelView: PanelView{
    
    var panel = UIView()
    var currentPanelTopCons : CGFloat = 0.0
    var panelTopCons: NSLayoutConstraint?
    
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    weak var delegate : PlaceCreatorPanelDelegate?
    
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
        aBtn.topAnchor.constraint(equalTo: panel.topAnchor, constant: 50).isActive = true
        aBtn.layer.cornerRadius = 20
        aBtn.layer.opacity = 0.3
        aBtn.isUserInteractionEnabled = true
        aBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackPlaceCreatorPanelClicked)))

//        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_arrow_down_a")?.withRenderingMode(.alwaysTemplate))
        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_close")?.withRenderingMode(.alwaysTemplate))
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
        
        let aPhotoB = SDAnimatedImageView()
        stackView.addSubview(aPhotoB)
        aPhotoB.translatesAutoresizingMaskIntoConstraints = false
        aPhotoB.widthAnchor.constraint(equalToConstant: 100).isActive = true
        aPhotoB.heightAnchor.constraint(equalToConstant: 100).isActive = true
        aPhotoB.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 40).isActive = true
        aPhotoB.leadingAnchor.constraint(equalTo: aBtn.leadingAnchor, constant: 10).isActive = true //default: 100
        let bImageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        aPhotoB.contentMode = .scaleAspectFill
        aPhotoB.layer.masksToBounds = true
        aPhotoB.layer.cornerRadius = 10
        aPhotoB.sd_setImage(with: bImageUrl)
        aPhotoB.isUserInteractionEnabled = true
        aPhotoB.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onAddPhotoClicked)))
        
        //test 2 > design 2
        let pResult = UIView()
        pResult.backgroundColor = .ddmDarkColor
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
        pResult.layer.opacity = 0.1 //0.1
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
        
        let qResult = UIView()
        qResult.backgroundColor = .ddmDarkColor
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
        qResult.layer.opacity = 0.1
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
        rResult.backgroundColor = .ddmDarkColor
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
        rResult.layer.opacity = 0.1
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
        rText.text = "Location"
//        rText.layer.opacity = 0.5
        
//        let bGrid = UIView()
//        bGrid.backgroundColor = .ddmDarkColor
////        panel.addSubview(bGrid)
//        stackView.addSubview(bGrid)
//        bGrid.translatesAutoresizingMaskIntoConstraints = false
//        bGrid.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20).isActive = true
////        bGrid.leadingAnchor.constraint(equalTo: aPhotoB.leadingAnchor, constant: 0).isActive = true
//        bGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        bGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        bGrid.topAnchor.constraint(equalTo: rResult.bottomAnchor, constant: 40).isActive = true //10
////        bGrid.layer.cornerRadius = 10
//        bGrid.layer.cornerRadius = 20
//        bGrid.layer.opacity = 0.4 //0.4
//        bGrid.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 0).isActive = true //10
//
//        let bGridIcon = UIImageView(image: UIImage(named:"icon_round_lock_open")?.withRenderingMode(.alwaysTemplate))
//        bGridIcon.tintColor = .white
//        bGrid.addSubview(bGridIcon)
//        bGridIcon.translatesAutoresizingMaskIntoConstraints = false
//        bGridIcon.centerXAnchor.constraint(equalTo: bGrid.centerXAnchor).isActive = true
//        bGridIcon.centerYAnchor.constraint(equalTo: bGrid.centerYAnchor).isActive = true
//        bGridIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        bGridIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
//
//        let bText = UILabel()
//        bText.textAlignment = .left
//        bText.textColor = .white
//        bText.font = .boldSystemFont(ofSize: 14)
////        panel.addSubview(bText)
//        stackView.addSubview(bText)
//        bText.translatesAutoresizingMaskIntoConstraints = false
//        bText.centerYAnchor.constraint(equalTo: bGrid.centerYAnchor, constant: 0).isActive = true
//        bText.leadingAnchor.constraint(equalTo: bGrid.trailingAnchor, constant: 10).isActive = true
////        bText.text = "Everyone Can See"
//        bText.text = "Public Location"
//        bText.layer.opacity = 0.5
        
        let bGrid = UIView()
        bGrid.backgroundColor = .ddmDarkColor
        stackView.addSubview(bGrid)
        bGrid.translatesAutoresizingMaskIntoConstraints = false
        bGrid.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20).isActive = true
        bGrid.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20).isActive = true
        bGrid.topAnchor.constraint(equalTo: rResult.bottomAnchor, constant: 40).isActive = true //10
        bGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        bGrid.layer.cornerRadius = 5
        bGrid.layer.opacity = 0.1
        bGrid.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 0).isActive = true //10
        
        let bGridBG = UIView()
        bGridBG.backgroundColor = .ddmDarkColor
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
        bText.font = .boldSystemFont(ofSize: 14)
//        bText.font = .systemFont(ofSize: 14)
        stackView.addSubview(bText)
        bText.translatesAutoresizingMaskIntoConstraints = false
        bText.centerYAnchor.constraint(equalTo: bGrid.centerYAnchor, constant: 0).isActive = true
        bText.leadingAnchor.constraint(equalTo: bGridBG.trailingAnchor, constant: 10).isActive = true
        bText.text = "Everyone Can See"
//        bText.text = "Public Location"
//        bText.layer.opacity = 0.5
        
        let bArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        bArrowBtn.tintColor = .white
        stackView.addSubview(bArrowBtn)
        bArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        bArrowBtn.trailingAnchor.constraint(equalTo: bGrid.trailingAnchor).isActive = true
        bArrowBtn.centerYAnchor.constraint(equalTo: bGrid.centerYAnchor).isActive = true
        bArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        bArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        bArrowBtn.layer.opacity = 0.5
        
        //test > upload button/save draft btn
        let draftBox = UIView()
        draftBox.backgroundColor = .ddmDarkColor
        panel.addSubview(draftBox)
//        stack1.addSubview(aSaveDraft)
        draftBox.translatesAutoresizingMaskIntoConstraints = false
        draftBox.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        draftBox.trailingAnchor.constraint(equalTo: aSaveDraft.leadingAnchor, constant: -10).isActive = true
//        draftBox.centerYAnchor.constraint(equalTo: aSaveDraft.centerYAnchor).isActive = true
        draftBox.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -60).isActive = true
        draftBox.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 20).isActive = true
//        draftBox.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20).isActive = true
        draftBox.layer.cornerRadius = 10
        draftBox.isUserInteractionEnabled = true
        draftBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onDraftBoxClicked)))
        
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
        aSaveDraft.heightAnchor.constraint(equalToConstant: 40).isActive = true
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
        
//        let aUpload = UIView()
        aUpload.backgroundColor = .yellow
//        panel.addSubview(aUpload)
        stack2.addSubview(aUpload)
        aUpload.translatesAutoresizingMaskIntoConstraints = false
        aUpload.heightAnchor.constraint(equalToConstant: 40).isActive = true
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
        
        let stackViewA = UIStackView(arrangedSubviews: [stack1, stack2])
        stackViewA.distribution = .fillEqually
//        stackViewA.backgroundColor = .black
//        stackViewA.backgroundColor = .blue
        panel.addSubview(stackViewA)
        stackViewA.translatesAutoresizingMaskIntoConstraints = false
        stackViewA.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -60).isActive = true //-50
        stackViewA.heightAnchor.constraint(equalToConstant: 40).isActive = true //ori 60
//        stackViewA.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 20).isActive = true
        stackViewA.leadingAnchor.constraint(equalTo: draftBox.trailingAnchor, constant: 20).isActive = true
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
//        pTextField.delegate = self
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
        rTextField.placeholder = "Where's your new place at..."
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
        rHintText.text = "Where's your new place at..."
        rHintText.layer.opacity = 0.3
        
        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .white
//        aStickyHeader.addSubview(bMiniBtn)
        stackView.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: rResult.trailingAnchor).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: rResult.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.layer.opacity = 0.5
    }
    
    @objc func onBackPlaceCreatorPanelClicked(gesture: UITapGestureRecognizer) {
        
        resignResponder()
        openSavePlaceDraftPromptMsg()
    }
    
    @objc func onPlaceUploadNextClicked(gesture: UITapGestureRecognizer) {
        resignResponder()
        aUpload.isHidden = true
        aSpinner.startAnimating()
        
        //test > close panel when upload
//        closePlaceCreatorPanel(isAnimated: true)
        
        DataFetchManager.shared.sendData(id: "u") { [weak self]result in
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
    
    @objc func onSaveDraftNextClicked(gesture: UITapGestureRecognizer) {
        resignResponder()
        aSaveDraft.isHidden = true
        bSpinner.startAnimating()
        
        DataFetchManager.shared.sendData(id: "u") { [weak self]result in
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
    
    @objc func onBoxUnderClicked(gesture: UITapGestureRecognizer) {
        print("box under")
        resignResponder()
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
//        activate(textField: rTextField) //test
        
        //test > init add location panel
//        self.isHidden = true
        
        //test 2
        delegate?.didPlaceCreatorClickLocationSelectScrollable()
    }
    @objc func onAddPhotoClicked(gesture: UITapGestureRecognizer) {
        resignResponder()
        openCameraRoll()
    }
    @objc func onDraftBoxClicked(gesture: UITapGestureRecognizer) {
        resignResponder()
        openPlaceDraftPanel()
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
    func openCameraRoll() {
        let cameraRollPanel = CameraPhotoRollPanelView(frame: CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.height))
        panel.addSubview(cameraRollPanel)
        cameraRollPanel.translatesAutoresizingMaskIntoConstraints = false
        cameraRollPanel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        cameraRollPanel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        cameraRollPanel.delegate = self
    }
    
    func openPlaceDraftPanel() {
        let draftPanel = PlaceDraftPanelView(frame: CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.height))
        panel.addSubview(draftPanel)
        draftPanel.translatesAutoresizingMaskIntoConstraints = false
        draftPanel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        draftPanel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        draftPanel.delegate = self
        draftPanel.initialize()
    }
    
    //test
    override func showLocationSelected() {
        rHintText.text = mapPinString
        print("showLocationSelected")
    }
}

extension PlaceCreatorConsolePanelView: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("xx2 scrollview begin: \(scrollView.contentOffset.y)")
        let scrollOffsetY = scrollView.contentOffset.y
        
        resignResponder()
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
}

extension PlaceCreatorConsolePanelView: CameraPhotoRollPanelDelegate{
    func didInitializeCameraPhotoRoll() {
        //test to turn off camera
//        session?.removeInput(videoDeviceInput!) //test
//        self.session?.stopRunning()
    }
    func didClickFinishCameraPhotoRoll() {
//        backPage()
    }
    func didClickPhotoSelect(photo: PHAsset) {
//        openVideoEditor()
        
        //test > convert PHAsset to image for image editor/insert to post
//        PHCachingImageManager.default().requestAVAsset(forVideo: video, options: nil) { [weak self] (video, _, _) in
//
//            if let avVid = video
//            {
//                DispatchQueue.main.async {
//                    //test 1 > open with video asset => tested OK
////                    self?.openVideoEditor(video: avVid)
//
//                    //test 2 > open with url => tested OK
//                    //try get url from avasset
//                    if let strURL = (video as? AVURLAsset)?.url.absoluteString {
//                        print("VIDEO URL: ", strURL)
//                        self?.openVideoEditor(videoUrl: URL(fileURLWithPath: strURL))
//                    }
//                }
//            }
//        }
    }
    func didClickMultiPhotoSelect(urls: [URL]){
        
    }
}

extension PlaceCreatorConsolePanelView: PlaceDraftPanelDelegate{
    func didClickClosePlaceDraftPanel() {
        
//        backPage(isCurrentPageScrollable: false)
    }
}
