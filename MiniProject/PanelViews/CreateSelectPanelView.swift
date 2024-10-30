//
//  CreateSelectPanelView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit

protocol CreateSelectPanelDelegate : AnyObject {
    func didClickCreatePlace()
    func didClickPlaceDraft()
    func didClickCreateShortVideo()
    func didClickShortVideoDraft()
    func didClickCreateShortPost()
    func didClickShortPostDraft()
    func didClickCreatePhoto()
    func didClickPhotoDraft()
    
    func didClickOpenLogin()
    
    func didClickClosePanel(revertLastAppMenuMode: String)
}

class CreateSelectPanelView: PanelView, UIGestureRecognizerDelegate{
    
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    var panel = UIView()
    
    var panelTopCons: NSLayoutConstraint?
    var currentPanelTopCons : CGFloat = 0.0
    
    var currentPanelMode = ""
    let PANEL_MODE_HALF: String = "half"
    let PANEL_MODE_EMPTY: String = "empty"
    let PANEL_MODE_FULL: String = "full"
    
    weak var delegate : CreateSelectPanelDelegate?
    
    var scrollablePanelHeight : CGFloat = 350.0
    
    var lastAppMenuMode = ""
    
    //test > user login/out status
    var isUserLoggedIn = false
    let aLoggedOutBox = UIView()
    
    let aView = UIView()
    let bView = UIView()
    let cView = UIView()
    let dView = UIView()
    
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
        let aBoxUnder = UIView()
        self.addSubview(aBoxUnder)
//        aBoxUnder.backgroundColor = .ddmBlackOverlayColor
//        aBoxUnder.backgroundColor = .clear
        aBoxUnder.translatesAutoresizingMaskIntoConstraints = false
        aBoxUnder.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        aBoxUnder.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
//        aBoxUnder.layer.opacity = 0.3
//        aBoxUnder.isHidden = true
        aBoxUnder.isUserInteractionEnabled = true
        aBoxUnder.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackPanelClicked)))
        aBoxUnder.backgroundColor = .black //test
        aBoxUnder.layer.opacity = 0.4 //0.2
        
        panel.backgroundColor = .ddmBlackOverlayColor
        self.addSubview(panel)
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        panel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        panel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //default 0
        panel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        panel.layer.masksToBounds = true
        panel.layer.cornerRadius = 10 //10
//        panel.heightAnchor.constraint(equalToConstant: scrollablePanelHeight).isActive = true
        panelTopCons = panel.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -scrollablePanelHeight) //default: 0
//        panelTopCons = panel.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -gap)
        panelTopCons?.isActive = true
        
        let exitView = UIView()
        exitView.backgroundColor = .ddmBlackDark
//        exitView.backgroundColor = .ddmDarkColor
        panel.addSubview(exitView)
        exitView.translatesAutoresizingMaskIntoConstraints = false
//        exitView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        exitView.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -50).isActive = true
        exitView.heightAnchor.constraint(equalToConstant: 45).isActive = true //ori 60
        exitView.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 15).isActive = true
        exitView.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -15).isActive = true
//        exitView.layer.opacity = 0.2 //0.3
        exitView.layer.cornerRadius = 10
        exitView.isUserInteractionEnabled = true
        exitView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onExitViewClicked)))
        
        let exitViewText = UILabel()
        exitViewText.textAlignment = .center
        exitViewText.textColor = .white
        exitViewText.font = .boldSystemFont(ofSize: 14)
//        panel.addSubview(aSaveDraftText)
        panel.addSubview(exitViewText)
        exitViewText.translatesAutoresizingMaskIntoConstraints = false
        exitViewText.centerXAnchor.constraint(equalTo: exitView.centerXAnchor).isActive = true
        exitViewText.centerYAnchor.constraint(equalTo: exitView.centerYAnchor).isActive = true
        exitViewText.text = "Back" //Cancel
//        exitViewText.layer.opacity = 0.5

        let dTextView = UIView()
        panel.addSubview(dTextView)
//        dTextView.backgroundColor = .red
        dTextView.translatesAutoresizingMaskIntoConstraints = false
//        dTextView.leadingAnchor.constraint(equalTo: cGrid.trailingAnchor, constant: 20).isActive = true //10
        dTextView.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 15).isActive = true //10
        dTextView.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -15).isActive = true
//        dTextView.centerYAnchor.constraint(equalTo: cGrid.centerYAnchor).isActive = true
        dTextView.bottomAnchor.constraint(equalTo: exitView.topAnchor, constant: -20).isActive = true
        dTextView.heightAnchor.constraint(equalToConstant: 40).isActive = true //ori 30
//        dTextView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        dTextView.isUserInteractionEnabled = true
        dTextView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCreatePhotoClicked)))
        
        let dGrid = UIView()
        dGrid.backgroundColor = .ddmDarkColor
//        dGrid.backgroundColor = .white
//        dGrid.layer.opacity = 0.8
        panel.addSubview(dGrid)
        dGrid.translatesAutoresizingMaskIntoConstraints = false
        dGrid.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 15).isActive = true
        dGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        dGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
        dGrid.centerYAnchor.constraint(equalTo: dTextView.centerYAnchor, constant: 0).isActive = true
        dGrid.layer.cornerRadius = 5 //20

        //test > icon for create post
//        let dMiniImage = UIImageView(image: UIImage(named:"flaticon_freepik_post_64x"))
//        let dMiniImage = UIImageView(image: UIImage(named:"flaticon_soremba_post_a"))
        let dMiniImage = UIImageView(image: UIImage(named:"flaticon_icon_home_photo"))
//        dMiniImage.contentMode = .scaleAspectFill
//        dMiniImage.layer.masksToBounds = true
        panel.addSubview(dMiniImage)
        dMiniImage.translatesAutoresizingMaskIntoConstraints = false
        dMiniImage.centerXAnchor.constraint(equalTo: dGrid.centerXAnchor).isActive = true
        dMiniImage.centerYAnchor.constraint(equalTo: dGrid.centerYAnchor).isActive = true
        dMiniImage.heightAnchor.constraint(equalToConstant: 24).isActive = true //ori 28
        dMiniImage.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        let dText = UILabel()
        dText.textAlignment = .left
        dText.textColor = .white
//        dText.textColor = .yellow
        dText.font = .boldSystemFont(ofSize: 14)
        panel.addSubview(dText)
        dText.translatesAutoresizingMaskIntoConstraints = false
        dText.centerYAnchor.constraint(equalTo: dGrid.centerYAnchor, constant: 0).isActive = true
//        dText.topAnchor.constraint(equalTo: aText.bottomAnchor, constant: 15).isActive = true
        dText.leadingAnchor.constraint(equalTo: dGrid.trailingAnchor, constant: 20).isActive = true //10
//        dText.leadingAnchor.constraint(equalTo: cTextView.leadingAnchor, constant: 0).isActive = true //10
//        dText.trailingAnchor.constraint(equalTo: cTextView.trailingAnchor, constant: 0).isActive = true //10
        dText.text = "Share Nice Photo" //*share nice shot
//        dText.isUserInteractionEnabled = true
//        dText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCreateShortPostClicked)))
        
        //test > draft icon and number of drafts
        let dArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        dArrowBtn.tintColor = .ddmDarkGrayColor
//        aHLightSection.addSubview(rArrowBtn)
        panel.addSubview(dArrowBtn)
        dArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        dArrowBtn.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20).isActive = true
        dArrowBtn.centerYAnchor.constraint(equalTo: dGrid.centerYAnchor).isActive = true
        dArrowBtn.heightAnchor.constraint(equalToConstant: 24).isActive = true
        dArrowBtn.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
//        let dView = UIView()
        panel.addSubview(dView)
        dView.translatesAutoresizingMaskIntoConstraints = false
//        dView.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20).isActive = true
        dView.trailingAnchor.constraint(equalTo: dArrowBtn.leadingAnchor, constant: 0).isActive = true
        dView.centerYAnchor.constraint(equalTo: dGrid.centerYAnchor).isActive = true
        dView.heightAnchor.constraint(equalToConstant: 40).isActive = true //ori 30
//        dView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        dView.isUserInteractionEnabled = true
        dView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onDraftPhotoClicked)))
        dView.isHidden = true
        
//        let dDraftBtn = UIImageView()
////        dDraftBtn.image = UIImage(named:"icon_round_folder_open")?.withRenderingMode(.alwaysTemplate)
//        dDraftBtn.image = UIImage(named:"icon_round_folder_close")?.withRenderingMode(.alwaysTemplate)
//        dDraftBtn.tintColor = .white
////        panel.addSubview(dDraftBtn)
//        dView.addSubview(dDraftBtn)
//        dDraftBtn.translatesAutoresizingMaskIntoConstraints = false
////        dDraftBtn.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20).isActive = true
////        dDraftBtn.centerYAnchor.constraint(equalTo: bGrid.centerYAnchor).isActive = true
//        dDraftBtn.trailingAnchor.constraint(equalTo: dView.trailingAnchor, constant: -10).isActive = true
//        dDraftBtn.centerYAnchor.constraint(equalTo: dView.centerYAnchor).isActive = true
//        dDraftBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true //ori 30
//        dDraftBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        
//        let dDraftQView = UIView()
////        dDraftQView.backgroundColor = .red
//        dDraftQView.backgroundColor = .yellow
////        panel.addSubview(dDraftQView)
//        dView.addSubview(dDraftQView)
//        dDraftQView.translatesAutoresizingMaskIntoConstraints = false
//        dDraftQView.trailingAnchor.constraint(equalTo: dDraftBtn.leadingAnchor, constant: -5).isActive = true
////        dDraftQView.centerYAnchor.constraint(equalTo: bGrid.centerYAnchor).isActive = true
//        dDraftQView.centerYAnchor.constraint(equalTo: dView.centerYAnchor).isActive = true
//        dDraftQView.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        dDraftQView.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        dDraftQView.layer.cornerRadius = 10
////        dDraftQView.isHidden = true
//        
//        let dDraftQText = UILabel()
//        dDraftQText.textAlignment = .center
////        dDraftQText.textColor = .white
//        dDraftQText.textColor = .black
//        dDraftQText.font = .boldSystemFont(ofSize: 12)
////        panel.addSubview(dDraftQText)
//        dView.addSubview(dDraftQText)
//        dDraftQText.translatesAutoresizingMaskIntoConstraints = false
//        dDraftQText.centerYAnchor.constraint(equalTo: dDraftQView.centerYAnchor, constant: 0).isActive = true
//        dDraftQText.centerXAnchor.constraint(equalTo: dDraftQView.centerXAnchor, constant: 0).isActive = true //10
//        dDraftQText.text = "5"
        
        let dNotifiedBox = UIView()
//        eUserCover.backgroundColor = .ddmBlackOverlayColor
        dNotifiedBox.backgroundColor = .red
        dView.addSubview(dNotifiedBox)
        dNotifiedBox.translatesAutoresizingMaskIntoConstraints = false
        dNotifiedBox.centerYAnchor.constraint(equalTo: dView.centerYAnchor, constant: 0).isActive = true
        dNotifiedBox.trailingAnchor.constraint(equalTo: dView.trailingAnchor, constant: 0).isActive = true
        dNotifiedBox.heightAnchor.constraint(equalToConstant: 10).isActive = true //40
        dNotifiedBox.widthAnchor.constraint(equalToConstant: 10).isActive = true
        dNotifiedBox.layer.cornerRadius = 5
        
        let dDraftQText = UILabel()
        dDraftQText.textAlignment = .center
        dDraftQText.textColor = .white
//        dDraftQText.textColor = .black
        dDraftQText.font = .boldSystemFont(ofSize: 12)
//        dDraftQText.font = .systemFont(ofSize: 12)
//        panel.addSubview(dDraftQText)
        dView.addSubview(dDraftQText)
        dDraftQText.translatesAutoresizingMaskIntoConstraints = false
        dDraftQText.leadingAnchor.constraint(equalTo: dView.leadingAnchor, constant: 10).isActive = true
        dDraftQText.trailingAnchor.constraint(equalTo: dNotifiedBox.leadingAnchor, constant: -5).isActive = true
        dDraftQText.centerYAnchor.constraint(equalTo: dView.centerYAnchor).isActive = true
        dDraftQText.text = "5 Drafts"
        
        let cTextView = UIView()
        panel.addSubview(cTextView)
//        cTextView.backgroundColor = .red
        cTextView.translatesAutoresizingMaskIntoConstraints = false
//        cTextView.leadingAnchor.constraint(equalTo: cGrid.trailingAnchor, constant: 20).isActive = true //10
        cTextView.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 15).isActive = true //10
        cTextView.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -15).isActive = true
//        cTextView.centerYAnchor.constraint(equalTo: cGrid.centerYAnchor).isActive = true
        cTextView.bottomAnchor.constraint(equalTo: dTextView.topAnchor, constant: -20).isActive = true
        cTextView.heightAnchor.constraint(equalToConstant: 40).isActive = true //ori 30
//        cTextView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        cTextView.isUserInteractionEnabled = true
        cTextView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCreateShortPostClicked)))
        
        let cGrid = UIView()
        cGrid.backgroundColor = .ddmDarkColor
//        cGrid.backgroundColor = .white
//        cGrid.layer.opacity = 0.8
        panel.addSubview(cGrid)
        cGrid.translatesAutoresizingMaskIntoConstraints = false
        cGrid.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 15).isActive = true
        cGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
        cGrid.centerYAnchor.constraint(equalTo: cTextView.centerYAnchor, constant: 0).isActive = true
        cGrid.layer.cornerRadius = 5 //20

        //test > icon for create post
//        let cMiniImage = UIImageView(image: UIImage(named:"flaticon_soremba_post_a"))
//        let cMiniImage = UIImageView(image: UIImage(named:"flaticon_freepik_post_b"))
        let cMiniImage = UIImageView(image: UIImage(named:"flaticon_freepik_article"))
//        cMiniImage.contentMode = .scaleAspectFill
//        cMiniImage.layer.masksToBounds = true
        panel.addSubview(cMiniImage)
        cMiniImage.translatesAutoresizingMaskIntoConstraints = false
        cMiniImage.centerXAnchor.constraint(equalTo: cGrid.centerXAnchor).isActive = true
        cMiniImage.centerYAnchor.constraint(equalTo: cGrid.centerYAnchor).isActive = true
        cMiniImage.heightAnchor.constraint(equalToConstant: 24).isActive = true //ori 28
        cMiniImage.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        let cText = UILabel()
        cText.textAlignment = .left
        cText.textColor = .white
//        cText.textColor = .yellow
        cText.font = .boldSystemFont(ofSize: 14)
        panel.addSubview(cText)
        cText.translatesAutoresizingMaskIntoConstraints = false
        cText.centerYAnchor.constraint(equalTo: cGrid.centerYAnchor, constant: 0).isActive = true
//        bText.topAnchor.constraint(equalTo: aText.bottomAnchor, constant: 15).isActive = true
        cText.leadingAnchor.constraint(equalTo: cGrid.trailingAnchor, constant: 20).isActive = true //10
//        cText.leadingAnchor.constraint(equalTo: cTextView.leadingAnchor, constant: 0).isActive = true //10
//        cText.trailingAnchor.constraint(equalTo: cTextView.trailingAnchor, constant: 0).isActive = true //10
        cText.text = "Write Post"
//        cText.isUserInteractionEnabled = true
//        cText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCreateShortPostClicked)))
        
        //test > draft icon and number of drafts
        let cArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        cArrowBtn.tintColor = .ddmDarkGrayColor
//        aHLightSection.addSubview(rArrowBtn)
        panel.addSubview(cArrowBtn)
        cArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        cArrowBtn.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20).isActive = true
        cArrowBtn.centerYAnchor.constraint(equalTo: cGrid.centerYAnchor).isActive = true
        cArrowBtn.heightAnchor.constraint(equalToConstant: 24).isActive = true
        cArrowBtn.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
//        let cView = UIView()
        panel.addSubview(cView)
        cView.translatesAutoresizingMaskIntoConstraints = false
//        cView.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20).isActive = true
        cView.trailingAnchor.constraint(equalTo: cArrowBtn.leadingAnchor, constant: 0).isActive = true
        cView.centerYAnchor.constraint(equalTo: cGrid.centerYAnchor).isActive = true
        cView.heightAnchor.constraint(equalToConstant: 40).isActive = true //ori 30
//        cView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        cView.isUserInteractionEnabled = true
        cView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onDraftShortPostClicked)))
        cView.isHidden = true
        
//        let cDraftBtn = UIImageView()
////        cDraftBtn.image = UIImage(named:"icon_round_folder_open")?.withRenderingMode(.alwaysTemplate)
//        cDraftBtn.image = UIImage(named:"icon_round_folder_close")?.withRenderingMode(.alwaysTemplate)
//        cDraftBtn.tintColor = .white
////        panel.addSubview(cDraftBtn)
//        cView.addSubview(cDraftBtn)
//        cDraftBtn.translatesAutoresizingMaskIntoConstraints = false
////        cDraftBtn.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20).isActive = true
////        cDraftBtn.centerYAnchor.constraint(equalTo: bGrid.centerYAnchor).isActive = true
//        cDraftBtn.trailingAnchor.constraint(equalTo: cView.trailingAnchor, constant: 0).isActive = true
//        cDraftBtn.centerYAnchor.constraint(equalTo: cView.centerYAnchor).isActive = true
//        cDraftBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true //ori 30
//        cDraftBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        
//        let cDraftQView = UIView()
////        cDraftQView.backgroundColor = .red
//        cDraftQView.backgroundColor = .yellow
////        panel.addSubview(cDraftQView)
//        cView.addSubview(cDraftQView)
//        cDraftQView.translatesAutoresizingMaskIntoConstraints = false
//        cDraftQView.trailingAnchor.constraint(equalTo: cDraftBtn.leadingAnchor, constant: -5).isActive = true
////        cDraftQView.centerYAnchor.constraint(equalTo: bGrid.centerYAnchor).isActive = true
//        cDraftQView.centerYAnchor.constraint(equalTo: cView.centerYAnchor).isActive = true
//        cDraftQView.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        cDraftQView.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        cDraftQView.layer.cornerRadius = 10
////        cDraftQView.isHidden = true
//        
//        let cDraftQText = UILabel()
//        cDraftQText.textAlignment = .center
////        cDraftQText.textColor = .white
//        cDraftQText.textColor = .black
//        cDraftQText.font = .boldSystemFont(ofSize: 12)
////        panel.addSubview(cDraftQText)
//        cView.addSubview(cDraftQText)
//        cDraftQText.translatesAutoresizingMaskIntoConstraints = false
//        cDraftQText.centerYAnchor.constraint(equalTo: cDraftQView.centerYAnchor, constant: 0).isActive = true
//        cDraftQText.centerXAnchor.constraint(equalTo: cDraftQView.centerXAnchor, constant: 0).isActive = true //10
//        cDraftQText.text = "2"
        
        let cNotifiedBox = UIView()
//        eUserCover.backgroundColor = .ddmBlackOverlayColor
        cNotifiedBox.backgroundColor = .red
        cView.addSubview(cNotifiedBox)
        cNotifiedBox.translatesAutoresizingMaskIntoConstraints = false
        cNotifiedBox.centerYAnchor.constraint(equalTo: cView.centerYAnchor, constant: 0).isActive = true
        cNotifiedBox.trailingAnchor.constraint(equalTo: cView.trailingAnchor, constant: 0).isActive = true
        cNotifiedBox.heightAnchor.constraint(equalToConstant: 10).isActive = true //40
        cNotifiedBox.widthAnchor.constraint(equalToConstant: 10).isActive = true
        cNotifiedBox.layer.cornerRadius = 5
        
        let cDraftQText = UILabel()
        cDraftQText.textAlignment = .center
        cDraftQText.textColor = .white
//        cDraftQText.textColor = .black
        cDraftQText.font = .boldSystemFont(ofSize: 12)
//        cDraftQText.font = .systemFont(ofSize: 12)
//        panel.addSubview(cDraftQText)
        cView.addSubview(cDraftQText)
        cDraftQText.translatesAutoresizingMaskIntoConstraints = false
        cDraftQText.leadingAnchor.constraint(equalTo: cView.leadingAnchor, constant: 10).isActive = true
        cDraftQText.trailingAnchor.constraint(equalTo: cNotifiedBox.leadingAnchor, constant: -5).isActive = true
        cDraftQText.centerYAnchor.constraint(equalTo: cView.centerYAnchor).isActive = true
        cDraftQText.text = "2 Drafts"

        let bTextView = UIView()
        panel.addSubview(bTextView)
//        bTextView.backgroundColor = .red
        bTextView.translatesAutoresizingMaskIntoConstraints = false
//        bTextView.leadingAnchor.constraint(equalTo: bGrid.trailingAnchor, constant: 20).isActive = true //10
        bTextView.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 15).isActive = true //10
        bTextView.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -15).isActive = true
//        bTextView.centerYAnchor.constraint(equalTo: bGrid.centerYAnchor).isActive = true
        bTextView.bottomAnchor.constraint(equalTo: cTextView.topAnchor, constant: -20).isActive = true
        bTextView.heightAnchor.constraint(equalToConstant: 40).isActive = true //ori 30
//        bTextView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        bTextView.isUserInteractionEnabled = true
        bTextView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCreateShortVideoClicked)))
        
        let bGrid = UIView()
        bGrid.backgroundColor = .ddmDarkColor
//        bGrid.backgroundColor = .white
//        bGrid.layer.opacity = 0.8
        panel.addSubview(bGrid)
        bGrid.translatesAutoresizingMaskIntoConstraints = false
        bGrid.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 15).isActive = true
        bGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        bGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
        bGrid.centerYAnchor.constraint(equalTo: bTextView.centerYAnchor, constant: 0).isActive = true
        bGrid.layer.cornerRadius = 5 //20

        //test > icon for create video
        let bMiniImageCircleBg = UIView()
        bMiniImageCircleBg.backgroundColor = .systemYellow
//        bMiniImageCircleBg.backgroundColor = .white
        panel.addSubview(bMiniImageCircleBg)
        bMiniImageCircleBg.translatesAutoresizingMaskIntoConstraints = false
        bMiniImageCircleBg.centerXAnchor.constraint(equalTo: bGrid.centerXAnchor).isActive = true
        bMiniImageCircleBg.centerYAnchor.constraint(equalTo: bGrid.centerYAnchor).isActive = true
        bMiniImageCircleBg.heightAnchor.constraint(equalToConstant: 24).isActive = true //28
        bMiniImageCircleBg.widthAnchor.constraint(equalToConstant: 24).isActive = true
        bMiniImageCircleBg.layer.cornerRadius = 12
        
        let bMiniImage = UIImageView(image: UIImage(named:"flaticon_freepik_video_b"))
        panel.addSubview(bMiniImage)
        bMiniImage.translatesAutoresizingMaskIntoConstraints = false
        bMiniImage.centerXAnchor.constraint(equalTo: bGrid.centerXAnchor).isActive = true
        bMiniImage.centerYAnchor.constraint(equalTo: bGrid.centerYAnchor).isActive = true
        bMiniImage.heightAnchor.constraint(equalToConstant: 24).isActive = true //ori 28
        bMiniImage.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        let bText = UILabel()
        bText.textAlignment = .left
        bText.textColor = .white
        bText.font = .boldSystemFont(ofSize: 14)
        panel.addSubview(bText)
        bText.translatesAutoresizingMaskIntoConstraints = false
        bText.centerYAnchor.constraint(equalTo: bTextView.centerYAnchor, constant: 0).isActive = true
//        bText.topAnchor.constraint(equalTo: aText.bottomAnchor, constant: 15).isActive = true
        bText.leadingAnchor.constraint(equalTo: bGrid.trailingAnchor, constant: 20).isActive = true //10
//        bText.trailingAnchor.constraint(equalTo: bTextView.trailingAnchor, constant: 0).isActive = true //10
        bText.text = "Create Short Video"
//        bText.isUserInteractionEnabled = true
//        bText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCreateShortVideoClicked)))
        
        //test > draft icon and number of drafts
        let bArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        bArrowBtn.tintColor = .ddmDarkGrayColor
//        aHLightSection.addSubview(rArrowBtn)
        panel.addSubview(bArrowBtn)
        bArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        bArrowBtn.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20).isActive = true
        bArrowBtn.centerYAnchor.constraint(equalTo: bGrid.centerYAnchor).isActive = true
        bArrowBtn.heightAnchor.constraint(equalToConstant: 24).isActive = true
        bArrowBtn.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
//        let bView = UIView()
        panel.addSubview(bView)
        bView.translatesAutoresizingMaskIntoConstraints = false
//        bView.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20).isActive = true
        bView.trailingAnchor.constraint(equalTo: bArrowBtn.leadingAnchor, constant: 0).isActive = true
        bView.centerYAnchor.constraint(equalTo: bGrid.centerYAnchor).isActive = true
        bView.heightAnchor.constraint(equalToConstant: 40).isActive = true //ori 30
//        bView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        bView.isUserInteractionEnabled = true
        bView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onDraftShortVideoClicked)))
        bView.isHidden = true
        
//        let bDraftBtn = UIImageView()
////        bDraftBtn.image = UIImage(named:"icon_round_folder_open")?.withRenderingMode(.alwaysTemplate)
//        bDraftBtn.image = UIImage(named:"icon_round_folder_close")?.withRenderingMode(.alwaysTemplate)
//        bDraftBtn.tintColor = .white
////        panel.addSubview(bDraftBtn)
//        bView.addSubview(bDraftBtn)
//        bDraftBtn.translatesAutoresizingMaskIntoConstraints = false
////        bDraftBtn.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20).isActive = true
////        bDraftBtn.centerYAnchor.constraint(equalTo: bGrid.centerYAnchor).isActive = true
//        bDraftBtn.trailingAnchor.constraint(equalTo: bView.trailingAnchor, constant: 0).isActive = true
//        bDraftBtn.centerYAnchor.constraint(equalTo: bView.centerYAnchor).isActive = true
//        bDraftBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true //ori 30
//        bDraftBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        
//        let bDraftQView = UIView()
////        bDraftQView.backgroundColor = .red
//        bDraftQView.backgroundColor = .yellow
////        panel.addSubview(bDraftQView)
//        bView.addSubview(bDraftQView)
//        bDraftQView.translatesAutoresizingMaskIntoConstraints = false
//        bDraftQView.trailingAnchor.constraint(equalTo: bDraftBtn.leadingAnchor, constant: -5).isActive = true
////        bDraftQView.centerYAnchor.constraint(equalTo: bGrid.centerYAnchor).isActive = true
//        bDraftQView.centerYAnchor.constraint(equalTo: bView.centerYAnchor).isActive = true
//        bDraftQView.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        bDraftQView.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        bDraftQView.layer.cornerRadius = 10
////        bDraftQView.isHidden = true
//        
//        let bDraftQText = UILabel()
//        bDraftQText.textAlignment = .center
////        bDraftQText.textColor = .white
//        bDraftQText.textColor = .black
//        bDraftQText.font = .boldSystemFont(ofSize: 12)
////        panel.addSubview(bDraftQText)
//        bView.addSubview(bDraftQText)
//        bDraftQText.translatesAutoresizingMaskIntoConstraints = false
//        bDraftQText.centerYAnchor.constraint(equalTo: bDraftQView.centerYAnchor, constant: 0).isActive = true
//        bDraftQText.centerXAnchor.constraint(equalTo: bDraftQView.centerXAnchor, constant: 0).isActive = true //10
//        bDraftQText.text = "3"
        
        let bNotifiedBox = UIView()
//        eUserCover.backgroundColor = .ddmBlackOverlayColor
        bNotifiedBox.backgroundColor = .red
        bView.addSubview(bNotifiedBox)
        bNotifiedBox.translatesAutoresizingMaskIntoConstraints = false
        bNotifiedBox.centerYAnchor.constraint(equalTo: bView.centerYAnchor, constant: 0).isActive = true
        bNotifiedBox.trailingAnchor.constraint(equalTo: bView.trailingAnchor, constant: 0).isActive = true
        bNotifiedBox.heightAnchor.constraint(equalToConstant: 10).isActive = true //40
        bNotifiedBox.widthAnchor.constraint(equalToConstant: 10).isActive = true
        bNotifiedBox.layer.cornerRadius = 5
        
        let bDraftQText = UILabel()
        bDraftQText.textAlignment = .center
        bDraftQText.textColor = .white
//        cDraftQText.textColor = .black
        bDraftQText.font = .boldSystemFont(ofSize: 12)
//        cDraftQText.font = .systemFont(ofSize: 12)
//        panel.addSubview(cDraftQText)
        bView.addSubview(bDraftQText)
        bDraftQText.translatesAutoresizingMaskIntoConstraints = false
        bDraftQText.leadingAnchor.constraint(equalTo: bView.leadingAnchor, constant: 10).isActive = true
        bDraftQText.trailingAnchor.constraint(equalTo: bNotifiedBox.leadingAnchor, constant: -5).isActive = true
        bDraftQText.centerYAnchor.constraint(equalTo: bView.centerYAnchor).isActive = true
        bDraftQText.text = "2 Drafts"

        let aTextView = UIView()
        panel.addSubview(aTextView)
//        aTextView.backgroundColor = .red
        aTextView.translatesAutoresizingMaskIntoConstraints = false
//        aTextView.leadingAnchor.constraint(equalTo: aGrid.trailingAnchor, constant: 20).isActive = true //10
//        aTextView.centerYAnchor.constraint(equalTo: aGrid.centerYAnchor).isActive = true
        aTextView.bottomAnchor.constraint(equalTo: bTextView.topAnchor, constant: -20).isActive = true
        aTextView.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 15).isActive = true //10
        aTextView.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -15).isActive = true
        aTextView.heightAnchor.constraint(equalToConstant: 40).isActive = true //ori 30
//        aTextView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        aTextView.isUserInteractionEnabled = true
        aTextView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCreatePlaceClicked)))
        aTextView.topAnchor.constraint(equalTo: panel.topAnchor, constant: 20).isActive = true
        
        let aGrid = UIView()
        aGrid.backgroundColor = .ddmDarkColor
//        aGrid.backgroundColor = .white
//        aGrid.layer.opacity = 0.8
        panel.addSubview(aGrid)
        aGrid.translatesAutoresizingMaskIntoConstraints = false
        aGrid.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 15).isActive = true
        aGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true //50
        aGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        aGrid.topAnchor.constraint(equalTo: panel.topAnchor, constant: 20).isActive = true
        aGrid.centerYAnchor.constraint(equalTo: aTextView.centerYAnchor, constant: 0).isActive = true
        aGrid.layer.cornerRadius = 5 //20

        //icon for create places
        let aMiniImage = UIImageView(image: UIImage(named:"flaticon_srip_places"))
//        aMiniImage.contentMode = .scaleAspectFill
//        aMiniImage.layer.masksToBounds = true
        panel.addSubview(aMiniImage)
        aMiniImage.translatesAutoresizingMaskIntoConstraints = false
        aMiniImage.centerXAnchor.constraint(equalTo: aGrid.centerXAnchor).isActive = true
        aMiniImage.centerYAnchor.constraint(equalTo: aGrid.centerYAnchor).isActive = true
        aMiniImage.heightAnchor.constraint(equalToConstant: 24).isActive = true //28
        aMiniImage.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        let aText = UILabel()
        aText.textAlignment = .left
        aText.textColor = .white
        aText.font = .boldSystemFont(ofSize: 14)
        panel.addSubview(aText)
        aText.translatesAutoresizingMaskIntoConstraints = false
        aText.centerYAnchor.constraint(equalTo: aGrid.centerYAnchor, constant: 0).isActive = true
//        aText.topAnchor.constraint(equalTo: aTextBox.bottomAnchor, constant: 30).isActive = true
        aText.leadingAnchor.constraint(equalTo: aGrid.trailingAnchor, constant: 20).isActive = true //10
//        aText.leadingAnchor.constraint(equalTo: aTextView.leadingAnchor, constant: 0).isActive = true //10
//        aText.trailingAnchor.constraint(equalTo: aTextView.trailingAnchor, constant: 0).isActive = true //10
        aText.text = "Create Location" //Create Place
//        aText.isUserInteractionEnabled = true
//        aText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCreatePlaceClicked)))
        
        //test > draft icon and number of drafts
        let aArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        aArrowBtn.tintColor = .ddmDarkGrayColor
//        aHLightSection.addSubview(rArrowBtn)
        panel.addSubview(aArrowBtn)
        aArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        aArrowBtn.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20).isActive = true
        aArrowBtn.centerYAnchor.constraint(equalTo: aGrid.centerYAnchor).isActive = true
        aArrowBtn.heightAnchor.constraint(equalToConstant: 24).isActive = true
        aArrowBtn.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
//        let aView = UIView()
        panel.addSubview(aView)
        aView.translatesAutoresizingMaskIntoConstraints = false
//        aView.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20).isActive = true
        aView.trailingAnchor.constraint(equalTo: aArrowBtn.leadingAnchor, constant: 0).isActive = true
        aView.centerYAnchor.constraint(equalTo: aGrid.centerYAnchor).isActive = true
        aView.heightAnchor.constraint(equalToConstant: 40).isActive = true //ori 30
//        aView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        aView.isUserInteractionEnabled = true
        aView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onDraftPlaceClicked)))
        aView.isHidden = true
        
//        let aDraftBtn = UIImageView()
////        aDraftBtn.image = UIImage(named:"icon_round_folder_open")?.withRenderingMode(.alwaysTemplate)
//        aDraftBtn.image = UIImage(named:"icon_round_folder_close")?.withRenderingMode(.alwaysTemplate)
//        aDraftBtn.tintColor = .white
////        panel.addSubview(aDraftBtn)
//        aView.addSubview(aDraftBtn)
//        aDraftBtn.translatesAutoresizingMaskIntoConstraints = false
////        aDraftBtn.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20).isActive = true
////        aDraftBtn.centerYAnchor.constraint(equalTo: bGrid.centerYAnchor).isActive = true
//        aDraftBtn.trailingAnchor.constraint(equalTo: aView.trailingAnchor, constant: 0).isActive = true
//        aDraftBtn.centerYAnchor.constraint(equalTo: aView.centerYAnchor).isActive = true
//        aDraftBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true //ori 30
//        aDraftBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        
//        let aDraftQView = UIView()
////        aDraftQView.backgroundColor = .red
//        aDraftQView.backgroundColor = .yellow
////        panel.addSubview(aDraftQView)
//        aView.addSubview(aDraftQView)
//        aDraftQView.translatesAutoresizingMaskIntoConstraints = false
//        aDraftQView.trailingAnchor.constraint(equalTo: aDraftBtn.leadingAnchor, constant: -5).isActive = true
////        aDraftQView.centerYAnchor.constraint(equalTo: bGrid.centerYAnchor).isActive = true
//        aDraftQView.centerYAnchor.constraint(equalTo: aView.centerYAnchor).isActive = true
//        aDraftQView.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        aDraftQView.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        aDraftQView.layer.cornerRadius = 10
////        aDraftQView.isHidden = true
//        
//        let aDraftQText = UILabel()
//        aDraftQText.textAlignment = .center
////        aDraftQText.textColor = .white
//        aDraftQText.textColor = .black
//        aDraftQText.font = .boldSystemFont(ofSize: 12)
////        panel.addSubview(aDraftQText)
//        aView.addSubview(aDraftQText)
//        aDraftQText.translatesAutoresizingMaskIntoConstraints = false
//        aDraftQText.centerYAnchor.constraint(equalTo: aDraftQView.centerYAnchor, constant: 0).isActive = true
//        aDraftQText.centerXAnchor.constraint(equalTo: aDraftQView.centerXAnchor, constant: 0).isActive = true //10
//        aDraftQText.text = "1"
        
        let aNotifiedBox = UIView()
//        eUserCover.backgroundColor = .ddmBlackOverlayColor
        aNotifiedBox.backgroundColor = .red
        aView.addSubview(aNotifiedBox)
        aNotifiedBox.translatesAutoresizingMaskIntoConstraints = false
        aNotifiedBox.centerYAnchor.constraint(equalTo: aView.centerYAnchor, constant: 0).isActive = true
        aNotifiedBox.trailingAnchor.constraint(equalTo: aView.trailingAnchor, constant: 0).isActive = true
        aNotifiedBox.heightAnchor.constraint(equalToConstant: 10).isActive = true //40
        aNotifiedBox.widthAnchor.constraint(equalToConstant: 10).isActive = true
        aNotifiedBox.layer.cornerRadius = 5
        
        let aDraftQText = UILabel()
        aDraftQText.textAlignment = .center
        aDraftQText.textColor = .white
//        cDraftQText.textColor = .black
        aDraftQText.font = .boldSystemFont(ofSize: 12)
//        cDraftQText.font = .systemFont(ofSize: 12)
//        panel.addSubview(cDraftQText)
        aView.addSubview(aDraftQText)
        aDraftQText.translatesAutoresizingMaskIntoConstraints = false
        aDraftQText.leadingAnchor.constraint(equalTo: aView.leadingAnchor, constant: 10).isActive = true
        aDraftQText.trailingAnchor.constraint(equalTo: aNotifiedBox.leadingAnchor, constant: -5).isActive = true
        aDraftQText.centerYAnchor.constraint(equalTo: aView.centerYAnchor).isActive = true
        aDraftQText.text = "1 Draft"
        
        //test > gesture recognizer for dragging user panel
        let panelPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onPanelPanGesture))
        panel.addGestureRecognizer(panelPanGesture)
    }
    
    @objc func onBackPanelClicked(gesture: UITapGestureRecognizer) {
        closePanel(isAnimated: true)
    }
    
    @objc func onCreatePlaceClicked(gesture: UITapGestureRecognizer) {
        
        delegate?.didClickCreatePlace()
        closePanel(isAnimated: true)
        
        //test > check sign in status
//        if(isUserLoggedIn) {
//            delegate?.didClickCreatePlace()
//
//            //test > close panel
//            closePanel(isAnimated: true)
//        } else {
//            delegate?.didClickOpenLogin()
//        }
    }
    
    @objc func onCreateShortPostClicked(gesture: UITapGestureRecognizer) {
        
        delegate?.didClickCreateShortPost()
        closePanel(isAnimated: true)
    }
    
    @objc func onCreateShortVideoClicked(gesture: UITapGestureRecognizer) {
        
        delegate?.didClickCreateShortVideo()
        closePanel(isAnimated: true)
    }
    
    @objc func onCreatePhotoClicked(gesture: UITapGestureRecognizer) {
        
        delegate?.didClickCreatePhoto()
        closePanel(isAnimated: true)
    }
    
    @objc func onDraftShortVideoClicked(gesture: UITapGestureRecognizer) {
        
        delegate?.didClickShortVideoDraft()
        closePanel(isAnimated: true)
    }
    
    @objc func onDraftShortPostClicked(gesture: UITapGestureRecognizer) {
        
        delegate?.didClickShortPostDraft()
        closePanel(isAnimated: true)
    }
    @objc func onDraftPhotoClicked(gesture: UITapGestureRecognizer) {
        delegate?.didClickPhotoDraft()
        closePanel(isAnimated: true)
    }
    @objc func onDraftPlaceClicked(gesture: UITapGestureRecognizer) {
        
        delegate?.didClickPlaceDraft()
        closePanel(isAnimated: true)
    }
    
    @objc func onExitViewClicked(gesture: UITapGestureRecognizer) {
        closePanel(isAnimated: true)
    }
    
    func setLastAppMenuMode(mode : String) {
        lastAppMenuMode = mode
    }
    
    func closePanel(isAnimated: Bool) {
        currentPanelMode = PANEL_MODE_EMPTY
        
        if(isAnimated) {
            UIView.animate(withDuration: 0.2, animations: {
                self.panelTopCons?.constant = 0
                self.layoutIfNeeded()
//                self.superview?.layoutIfNeeded()
            }, completion: { _ in
                
                self.delegate?.didClickClosePanel(revertLastAppMenuMode: self.lastAppMenuMode)
                
                self.removeFromSuperview()
            })
        } else {
            self.removeFromSuperview()
        }
    }
    
    //test
    override func resumeActiveState() {
        print("createselectpanelview resume active")
        
        //test > check for signin status when in active state
        asyncFetchSigninStatus()
    }
    
    var isInitialized = false
    func initialize() {
        
        //test > new init method
        if(!isInitialized) {
            
            currentPanelMode = PANEL_MODE_HALF
            
            let gap = scrollablePanelHeight
            panelTopCons?.constant = -gap
            
            if(isUserLoggedIn) {
                aView.isHidden = false
                bView.isHidden = false
                cView.isHidden = false
                dView.isHidden = false
            } else {
                aView.isHidden = true
                bView.isHidden = true
                cView.isHidden = true
                dView.isHidden = true
            }
            
            //start fetch data
            self.asyncInit(id: "search_term")
        }
        
        isInitialized = true
    }
    func initialize(width: CGFloat, height: CGFloat) {
        viewWidth = width
        viewHeight = height
        
        //test
        asyncFetchSigninStatus()
    }
    
    //test > check for drafts
    func asyncInit(id: String) {
        DataFetchManager.shared.fetchData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    guard let self = self else {
                        return
                    }
                    print("createselect init: \(self.panel.frame.height)")
                }

                case .failure(_):
                    print("api fail")
                    break
            }
        }
    }
    
    func asyncFetchSigninStatus() {
        //test > simple get method
        let isSignedIn = SignInManager.shared.getStatus()
        if(self.isInitialized) {
            if(self.isUserLoggedIn != isSignedIn) {
                self.isUserLoggedIn = isSignedIn

                self.isInitialized = false
                self.initialize()
            }
            //test > recheck UI for aLoggedOut
            else {
                if(isUserLoggedIn) {
                    aView.isHidden = false
                    bView.isHidden = false
                    cView.isHidden = false
                    dView.isHidden = false
                } else {
                    aView.isHidden = true
                    bView.isHidden = true
                    cView.isHidden = true
                    dView.isHidden = true
                }
            }
        } else {
            self.isUserLoggedIn = isSignedIn
            self.initialize()
        }
        
//        SignInManager.shared.fetchStatus(id: "fetch_status") { [weak self]result in
//            switch result {
//                case .success(let l):
//
//                //update UI on main thread
//                DispatchQueue.main.async {
//                    print("createselectpanelview api success: \(l)")
//                    guard let self = self else {
//                        return
//                    }
//                    
//                    let isSignedIn = l
//                    
//                    if(self.isInitialized) {
//                        if(self.isUserLoggedIn != isSignedIn) {
//                            self.isUserLoggedIn = isSignedIn
//                    
//                            self.isInitialized = false
//                            self.initialize()
//                        }
//                    } else {
//                        self.isUserLoggedIn = isSignedIn
//                        self.initialize()
//                    }
//                }
//
//                case .failure(_):
//                    print("api fail")
//                    break
//            }
//        }
    }
    
    @objc func onPanelPanGesture(gesture: UIPanGestureRecognizer) {
        if(gesture.state == .began) {
            if(self.currentPanelMode == self.PANEL_MODE_HALF) {
                self.currentPanelTopCons = self.panelTopCons!.constant
            }

        } else if(gesture.state == .changed) {
            let translation = gesture.translation(in: self)
            let x = translation.x
            let y = translation.y
            
            if(self.currentPanelMode == self.PANEL_MODE_HALF) {
                if(y > 0) {
                    self.panelTopCons?.constant = self.currentPanelTopCons + y
                }
            }

        } else if(gesture.state == .ended){
            if(self.currentPanelMode == self.PANEL_MODE_HALF) {
                if(self.panelTopCons!.constant - self.currentPanelTopCons < 150) {
                    print("createselect <150 \(self.currentPanelTopCons), \(self.panelTopCons!.constant)")
                    UIView.animate(withDuration: 0.2, animations: {
                        let gap = self.scrollablePanelHeight
                        self.panelTopCons?.constant = -gap
                        self.layoutIfNeeded()
                    }, completion: { _ in
                    })
                } else {
                    print("createselect >150 \(self.currentPanelTopCons), \(self.panelTopCons!.constant)")
                    closePanel(isAnimated: true)
                }
            }

        }
    }
}

extension ViewController: CreateSelectPanelDelegate{
    func didClickCreatePlace() {
        openPlaceCreatorPanel()
    }
    
    func didClickCreateShortVideo() {
        openVideoCreatorPanel()
    }
    
    func didClickCreateShortPost() {
        openPostCreatorPanel()
    }
    
    func didClickPlaceDraft() {
        openPlaceDraftPanel()
    }
    func didClickShortVideoDraft() {
        openVideoDraftPanel()
    }
    func didClickShortPostDraft() {
        openPostDraftPanel()
    }
    
    func didClickCreatePhoto() {
        openPhotoCreatorPanel()
    }
    func didClickPhotoDraft() {
        openPhotoDraftPanel()
    }
    func didClickOpenLogin() {
        openLoginPanel()
    }
    func didClickClosePanel(revertLastAppMenuMode: String) {
        changeAppMenuMode(mode: revertLastAppMenuMode)
    }
}
