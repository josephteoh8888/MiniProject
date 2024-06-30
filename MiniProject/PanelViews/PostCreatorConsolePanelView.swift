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
        aBtn.topAnchor.constraint(equalTo: panel.topAnchor, constant: topInset).isActive = true
        aBtn.layer.cornerRadius = 20
        aBtn.layer.opacity = 0.3
        aBtn.isUserInteractionEnabled = true
        aBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackPostCreatorPanelClicked)))

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
//        let bottomMargin = 60.0 + bottomInset
//        scrollViewBottomCons = scrollView.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -bottomMargin) //-301
        scrollViewBottomCons = scrollView.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -120)
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
        pMini.backgroundColor = .white
//        panel.addSubview(pMini)
        uView.addSubview(pMini)
        pMini.translatesAutoresizingMaskIntoConstraints = false
        pMini.topAnchor.constraint(equalTo: uView.topAnchor, constant: 20).isActive = true
        pMini.leadingAnchor.constraint(equalTo: uView.leadingAnchor, constant: 20).isActive = true
        pMini.heightAnchor.constraint(equalToConstant: 40).isActive = true
        pMini.widthAnchor.constraint(equalToConstant: 40).isActive = true
        pMini.layer.cornerRadius = 20
        pMini.layer.opacity = 1.0 //default 0.3

        let pImageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
        let pImage = SDAnimatedImageView()
        pImage.contentMode = .scaleAspectFill
        pImage.layer.masksToBounds = true
        pImage.sd_setImage(with: pImageUrl)
//        panel.addSubview(pImage)
        uView.addSubview(pImage)
        pImage.translatesAutoresizingMaskIntoConstraints = false
        pImage.centerXAnchor.constraint(equalTo: pMini.centerXAnchor).isActive = true
        pImage.centerYAnchor.constraint(equalTo: pMini.centerYAnchor).isActive = true
        pImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        pImage.widthAnchor.constraint(equalToConstant: 40).isActive = true //36
        pImage.layer.cornerRadius = 20
//        pImage.isUserInteractionEnabled = true
//        pImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onUserClicked)))
        
        //test 2 > design location 2
        let aBox = UIView()
//        aBox.backgroundColor = .ddmBlackOverlayColor
        aBox.backgroundColor = .ddmDarkColor
        stackView.addSubview(aBox)
        aBox.clipsToBounds = true
        aBox.translatesAutoresizingMaskIntoConstraints = false
        aBox.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20).isActive = true
        aBox.heightAnchor.constraint(equalToConstant: 30).isActive = true //default: 50
        aBox.topAnchor.constraint(equalTo: uView.bottomAnchor, constant: 40).isActive = true //20
        aBox.layer.cornerRadius = 5
        aBox.layer.opacity = 0.2 //0.3
        aBox.isUserInteractionEnabled = true
//        aBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPlaceClicked)))
        aBox.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -40).isActive = true //-20

        let bBox = UIView()
        bBox.backgroundColor = .clear //yellow
        stackView.addSubview(bBox)
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

        let aaText = UILabel()
        aaText.textAlignment = .left
        aaText.textColor = .white
//        aaText.textColor = .ddmDarkColor
        aaText.font = .boldSystemFont(ofSize: 12)
//        aaText.font = .systemFont(ofSize: 12)
        stackView.addSubview(aaText)
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
        stackView.addSubview(aArrowBtn)
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
        aUpload.heightAnchor.constraint(equalToConstant: 40).isActive = true //30
        aUpload.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -10).isActive = true
//        aUpload.topAnchor.constraint(equalTo: panel.topAnchor, constant: 50).isActive = true
//        aUpload.leadingAnchor.constraint(equalTo: stack2.leadingAnchor, constant: 10).isActive = true
//        aUpload.trailingAnchor.constraint(equalTo: stack2.trailingAnchor, constant: 0).isActive = true
        aUpload.centerYAnchor.constraint(equalTo: aBtn.centerYAnchor).isActive = true
        aUpload.layer.cornerRadius = 10
        aUpload.isUserInteractionEnabled = true
        aUpload.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPostUploadNextClicked)))
        aUpload.layer.opacity = 0.2

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
        aSaveDraft.heightAnchor.constraint(equalToConstant: 40).isActive = true //30
        aSaveDraft.trailingAnchor.constraint(equalTo: aUpload.leadingAnchor, constant: -10).isActive = true
        aSaveDraft.centerYAnchor.constraint(equalTo: aUpload.centerYAnchor).isActive = true
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
        
        let draftBox = UIView()
        draftBox.backgroundColor = .ddmDarkColor
        panel.addSubview(draftBox)
//        stack1.addSubview(aSaveDraft)
        draftBox.translatesAutoresizingMaskIntoConstraints = false
        draftBox.heightAnchor.constraint(equalToConstant: 40).isActive = true //30
        draftBox.trailingAnchor.constraint(equalTo: aSaveDraft.leadingAnchor, constant: -10).isActive = true
        draftBox.centerYAnchor.constraint(equalTo: aSaveDraft.centerYAnchor).isActive = true
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
        
        //**test > tools panel
        toolPanel.backgroundColor = .ddmBlackOverlayColor //black
//        toolPanel.backgroundColor = .black //black
        panel.addSubview(toolPanel)
        toolPanel.translatesAutoresizingMaskIntoConstraints = false
        toolPanel.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: 0).isActive = true
//        toolPanel.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -bottomInset).isActive = true
        toolPanel.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 0).isActive = true
        toolPanel.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: 0).isActive = true
        toolPanel.layer.cornerRadius = 0
        toolPanel.heightAnchor.constraint(equalToConstant: 120).isActive = true //60
        
        let toolPanelBg = UIView()
        toolPanelBg.backgroundColor = .ddmDarkColor //black
//        toolPanelBg.backgroundColor = .black //black
        toolPanelBg.layer.opacity = 0.1
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
        
        textEditPanel.backgroundColor = .ddmBlackOverlayColor //black
//        toolPanel.backgroundColor = .black //black
        panel.addSubview(textEditPanel)
        textEditPanel.translatesAutoresizingMaskIntoConstraints = false
        textEditPanel.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: 0).isActive = true
//        textEditPanel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        textEditPanel.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 0).isActive = true
        textEditPanel.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: 0).isActive = true
        textEditPanel.layer.cornerRadius = 0
        textEditPanel.heightAnchor.constraint(equalToConstant: 60).isActive = true //60
        
        let textToolPanelBg = UIView()
        textToolPanelBg.backgroundColor = .ddmDarkColor //black
//        textToolPanelBg.backgroundColor = .black //black
        textToolPanelBg.layer.opacity = 0.1
        textEditPanel.addSubview(textToolPanelBg)
        textToolPanelBg.translatesAutoresizingMaskIntoConstraints = false
        textToolPanelBg.bottomAnchor.constraint(equalTo: textEditPanel.bottomAnchor, constant: 0).isActive = true
        textToolPanelBg.topAnchor.constraint(equalTo: textEditPanel.topAnchor, constant: 0).isActive = true
        textToolPanelBg.leadingAnchor.constraint(equalTo: textEditPanel.leadingAnchor, constant: 0).isActive = true
        textToolPanelBg.trailingAnchor.constraint(equalTo: textEditPanel.trailingAnchor, constant: 0).isActive = true
        
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
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(onKeyboardWillChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        //**
    }
    
    //test
    override func showLocationSelected() {
        aText.text = mapPinString
        print("showLocationSelected")
    }
    
    //test > initialization state
    var isInitialized = false
    var topInset = 0.0
    var bottomInset = 0.0
    func initialize(topInset: CGFloat, bottomInset: CGFloat) {

        if(!isInitialized) {
            self.topInset = topInset
            self.bottomInset = bottomInset
            
            redrawUI()
            
            //test > add first textview
            addTextSection(i: 0, extraContentSize: 0.0, textToAdd: "")
        }

        isInitialized = true
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
//        let bottomMargin = 60.0 + bottomInset //60
//        scrollViewBottomCons?.constant = -bottomMargin
        scrollViewBottomCons?.constant = -120
        
        isKeyboardUp = false
        keyboardHeight = 0.0
        
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
        resignResponder()
        delegate?.didPostCreatorClickLocationSelectScrollable()
    }
    
    @objc func onMainAddTextClicked(gesture: UITapGestureRecognizer) {
        if(pcList[pcList.count - 1].tBoxType != "t") {
            addTextSection(i: pcList.count - 1, extraContentSize: 0.0, textToAdd: "")
        } else {
            if let aTBox = pcList[pcList.count - 1].tBox as? UITextView {
                setFirstResponder(textView: aTBox)
            }
        }
    }
    @objc func onMainAddPhotoClicked(gesture: UITapGestureRecognizer) {
        //test 3 > add photo at the end
        let initialSelectedIndex = pcList.count - 1
        addPhotoSection(i: initialSelectedIndex, textToAdd: "")
        
        if(pcList[initialSelectedIndex].tBoxType == "t") {
            if let tBoxTv = pcList[initialSelectedIndex].tBox as? UITextView {
                if(tBoxTv.text == "") {
                    removeTextSection(i: initialSelectedIndex)
                }
            }
        }
    }
    @objc func onMainEmbedClicked(gesture: UITapGestureRecognizer) {

    }
    
    @objc func onTextAtClicked(gesture: UITapGestureRecognizer) {

    }
    
    @objc func onTextHashtagClicked(gesture: UITapGestureRecognizer) {

    }
    
    @objc func onTextAddPhotoClicked(gesture: UITapGestureRecognizer) {
        print("post create addphoto")
        //test 1 > open camera to add photo
//        resignResponder()
//        openCameraRoll()
        
        print("xy txt+Photo a: \(selectedPcIndex), \(computePcPosition(index: selectedPcIndex, isInclusive: true)), \(stackView.frame.height)")
        let currentYPosition = computePcPosition(index: selectedPcIndex, isInclusive: true)
        let stackViewH = stackView.frame.height
        
        //test 2 > textbeforecursor, textaftercursor
        let aTextBeforeCursor = textBeforeCursor
        let aTextAfterCursor = textAfterCursor
//        print("xy addphoto: \(selectedPcIndex), \(textBeforeCursor), \(textAfterCursor)")
        
        //test 3 > add photo in index i
        let initialSelectedIndex = selectedPcIndex
        addPhotoSection(i: selectedPcIndex, textToAdd: aTextAfterCursor)
        
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
        let scrollViewBottomMargin = keyboardHeight + 60.0 //60
        let stackViewHeight = stackViewH + 280.0 + 20.0
        let scrollViewHeight = viewHeight - (50.0 + topInset) - scrollViewBottomMargin
        var scrollGap = stackViewHeight - scrollViewHeight
        if(scrollGap <= 0) {
            scrollGap = 0.0
        }

        let yHeight = currentYPosition + 280.0 + 20.0
        let yContentOffset = yHeight/stackViewHeight * scrollGap
        scrollView.setContentOffset(CGPoint(x: 0, y: yContentOffset), animated: false)
        print("xy txt+Photo b: \(selectedPcIndex), \(stackViewHeight)")
    }
    
    @objc func onTextNextClicked(gesture: UITapGestureRecognizer) {
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
        
        unselectPostClipPhotoCell(i: selectedPcIndex)
        mainEditPanel.isHidden = false
        textEditPanel.isHidden = true
        photoEditPanel.isHidden = true
        
        removePhotoSection(i: selectedPcIndex)
//        selectedPcIndex = -1
    }
    @objc func onPhotoNextClicked(gesture: UITapGestureRecognizer) {
        unselectPostClipPhotoCell(i: selectedPcIndex)
        selectedPcIndex = -1
        
        mainEditPanel.isHidden = false
        textEditPanel.isHidden = true
        photoEditPanel.isHidden = true
    }

    //test > add photo/video section => in multiple format/layout
    func addPhotoSection(i: Int, textToAdd: String) {
        //if index is last member
        var isIndexLastElement = false
        var isToAppendText = false
        if(i == pcList.count - 1) {
            pcList[i].tBoxBottomCons?.isActive = false
            isIndexLastElement = true
        }
        
        //*test 2 > with reusable cell
        let a = PostClip()
        a.tBoxType = "p" //p for photo
        let cell = PostClipPhotoCell(frame: CGRect(x: 0 , y: 0, width: viewWidth, height: viewHeight))
        uView.addSubview(cell)
        cell.translatesAutoresizingMaskIntoConstraints = false
        cell.trailingAnchor.constraint(equalTo: uView.trailingAnchor, constant: 0).isActive = true
        cell.leadingAnchor.constraint(equalTo: uView.leadingAnchor, constant: 0).isActive = true
        cell.redrawUI()
        a.tBox = cell
        cell.aDelegate = self
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
            let extraSize = 280.0 + 20.0
            addTextSection(i: i + 1, extraContentSize: extraSize, textToAdd: textToAdd)
        }
        else {
            let sHeight = stackView.frame.height
            let newHeight = sHeight + 280.0 + 20.0
            scrollView.contentSize = CGSize(width: stackView.frame.width, height: newHeight)
            
            //test > if no text section to add, then keyboard down
            resignResponder()
            selectedPcIndex = -1
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
            hintText.textColor = .white
            hintText.font = .boldSystemFont(ofSize: 14)
            uView.addSubview(hintText)
            hintText.translatesAutoresizingMaskIntoConstraints = false
            hintText.leadingAnchor.constraint(equalTo: bTv.leadingAnchor, constant: 10).isActive = true
            hintText.trailingAnchor.constraint(equalTo: uView.trailingAnchor, constant: -20).isActive = true
            hintText.topAnchor.constraint(equalTo: bTv.topAnchor, constant: 0).isActive = true //8
            hintText.text = "What's happening?..."
            hintText.layer.opacity = 0.5
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
    
    func removePhotoSection(i: Int) {
        if(i > 0) { //means i-1 element exists, first element must be textview
            if(pcList[i].tBoxType == "p") {
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
                let newHeight = sHeight - 280.0 - 20.0
                scrollView.contentSize = CGSize(width: stackView.frame.width, height: newHeight)
            }
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
    
    func openCameraRoll() {
        let cameraRollPanel = CameraPhotoRollPanelView(frame: CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.height))
        panel.addSubview(cameraRollPanel)
        cameraRollPanel.translatesAutoresizingMaskIntoConstraints = false
        cameraRollPanel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        cameraRollPanel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        cameraRollPanel.delegate = self
    }
    
    func openPostDraftPanel() {
        let draftPanel = PostDraftPanelView(frame: CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.height))
        panel.addSubview(draftPanel)
        draftPanel.translatesAutoresizingMaskIntoConstraints = false
        draftPanel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        draftPanel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        draftPanel.delegate = self
        draftPanel.initialize()
    }
    
    func unselectPostClipPhotoCell(i : Int) {
        if(pcList[i].tBoxType == "p") {
            if let currentTBox = pcList[i].tBox as? PostClipPhotoCell {
                currentTBox.unselectCell()
            }
        }
    }
    
    @objc func onBackPostCreatorPanelClicked(gesture: UITapGestureRecognizer) {
        resignResponder()
        openSavePostDraftPromptMsg()
//        closePostCreatorPanel(isAnimated: true)
    }
    
    @objc func onPostUploadNextClicked(gesture: UITapGestureRecognizer) {
        resignResponder()
        aUpload.isHidden = true
        aSpinner.startAnimating()

        DataFetchManager.shared.sendData(id: "u") { [weak self]result in
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
    
    @objc func onDraftBoxClicked(gesture: UITapGestureRecognizer) {
        resignResponder()
        openPostDraftPanel()
        
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

            keyboardHeight = keyboardSize.height
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
        let initialYHeight = 40.0 + 20.0
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
}

extension PostCreatorConsolePanelView: PostClipPhotoCellDelegate {
    func didClickPostClipCell(cell: PostClipPhotoCell) {
        
        var i = 0
        for pc in pcList {
            if(pc.tBoxType == "p") {
                if(pc.tBox == cell) {
//                    print("xy click pc: \(i), \(cell)")
                    
                    if(selectedPcIndex != i) {
                        if(selectedPcIndex > -1) {
                            unselectPostClipPhotoCell(i: selectedPcIndex)
                        }
                        cell.selectCell()
                        selectedPcIndex = i
                        
                        //test > scroll to position if not visible
                        let stackViewHeight = stackView.frame.height
                        let scrollViewHeight = viewHeight - (50.0 + topInset) - 120.0 //in full mode(keyboard down)
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
            }
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
                            unselectPostClipPhotoCell(i: selectedPcIndex)
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


extension PostCreatorConsolePanelView: PostDraftPanelDelegate{
    func didClickClosePostDraftPanel() {
        
//        backPage(isCurrentPageScrollable: false)
    }
}

extension PostCreatorConsolePanelView: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("xxpc scrollview begin: \(scrollView.contentOffset.y)")
        let scrollOffsetY = scrollView.contentOffset.y
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
