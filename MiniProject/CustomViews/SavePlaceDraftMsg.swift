//
//  SavePlaceDraftMsg.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

protocol SavePlaceDraftMsgDelegate : AnyObject {
    func didSPlDClickProceed()
    func didSPlDClickDeny()
}
class SavePlaceDraftMsgView: UIView{
    
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    let savePlaceDraftPromptMsg = UIView()
    weak var delegate : SavePlaceDraftMsgDelegate?
    
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
        self.addSubview(savePlaceDraftPromptMsg)
        savePlaceDraftPromptMsg.translatesAutoresizingMaskIntoConstraints = false
        savePlaceDraftPromptMsg.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        savePlaceDraftPromptMsg.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        savePlaceDraftPromptMsg.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        savePlaceDraftPromptMsg.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        let savePostDraftPromptMsgBG = UIView()
        savePlaceDraftPromptMsg.addSubview(savePostDraftPromptMsgBG)
        savePostDraftPromptMsgBG.backgroundColor = .ddmBlackOverlayColor
        savePostDraftPromptMsgBG.layer.opacity = 0.3
        savePostDraftPromptMsgBG.translatesAutoresizingMaskIntoConstraints = false
        savePostDraftPromptMsgBG.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        savePostDraftPromptMsgBG.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        savePostDraftPromptMsgBG.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        savePostDraftPromptMsgBG.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        let gBox = UIView()
        savePlaceDraftPromptMsg.addSubview(gBox)
        gBox.translatesAutoresizingMaskIntoConstraints = false
        gBox.centerXAnchor.constraint(equalTo: savePlaceDraftPromptMsg.centerXAnchor).isActive = true
        gBox.centerYAnchor.constraint(equalTo: savePlaceDraftPromptMsg.centerYAnchor, constant: -60).isActive = true
        gBox.leadingAnchor.constraint(equalTo: savePlaceDraftPromptMsg.leadingAnchor, constant: 50).isActive = true
        gBox.trailingAnchor.constraint(equalTo: savePlaceDraftPromptMsg.trailingAnchor, constant: -50).isActive = true
//        gBox.backgroundColor = .ddmBlackOverlayColor
        gBox.backgroundColor = .white
        gBox.layer.cornerRadius = 15
        
        let gTitleText = UILabel()
        gTitleText.textAlignment = .center
//        gTitleText.textColor = .white
        gTitleText.textColor = .ddmBlackOverlayColor
        gTitleText.font = .boldSystemFont(ofSize: 16)
        gBox.addSubview(gTitleText)
        gTitleText.translatesAutoresizingMaskIntoConstraints = false
//        gTitleText.centerYAnchor.constraint(equalTo: gBox.centerYAnchor).isActive = true
        gTitleText.topAnchor.constraint(equalTo: gBox.topAnchor, constant: 30).isActive = true
//        gTitleText.bottomAnchor.constraint(equalTo: gBox.bottomAnchor, constant: -10).isActive = true
        gTitleText.leadingAnchor.constraint(equalTo: gBox.leadingAnchor, constant: 20).isActive = true
        gTitleText.trailingAnchor.constraint(equalTo: gBox.trailingAnchor, constant: -20).isActive = true
        gTitleText.numberOfLines = 0
        gTitleText.text = "Save Place in Draft?"
        
        let gBtn = UIView()
        gBox.addSubview(gBtn)
        gBtn.backgroundColor = .yellow
        gBtn.translatesAutoresizingMaskIntoConstraints = false
        gBtn.leadingAnchor.constraint(equalTo: gBox.leadingAnchor, constant: 50).isActive = true
        gBtn.trailingAnchor.constraint(equalTo: gBox.trailingAnchor, constant: -50).isActive = true
        gBtn.topAnchor.constraint(equalTo: gTitleText.bottomAnchor, constant: 30).isActive = true
//        gBtn.bottomAnchor.constraint(equalTo: gBox.bottomAnchor, constant: -30).isActive = true
        gBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        gBtn.layer.cornerRadius = 10
        gBtn.isUserInteractionEnabled = true
        gBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSavePlaceDraftProceedClicked)))
        
        let gBtnText = UILabel()
        gBtnText.textAlignment = .center
        gBtnText.textColor = .black
        gBtnText.font = .boldSystemFont(ofSize: 13)
        gBox.addSubview(gBtnText)
        gBtnText.translatesAutoresizingMaskIntoConstraints = false
//        gBtnText.topAnchor.constraint(equalTo: gBtn.topAnchor, constant: 10).isActive = true
//        gBtnText.bottomAnchor.constraint(equalTo: gBtn.bottomAnchor, constant: -10).isActive = true
        gBtnText.centerYAnchor.constraint(equalTo: gBtn.centerYAnchor).isActive = true
        gBtnText.leadingAnchor.constraint(equalTo: gBtn.leadingAnchor, constant: 20).isActive = true
        gBtnText.trailingAnchor.constraint(equalTo: gBtn.trailingAnchor, constant: -20).isActive = true
        gBtnText.text = "Save"
        
        let gDenyText = UILabel()
        gDenyText.textAlignment = .center
//        gDenyText.textColor = .white
        gDenyText.textColor = .ddmBlackOverlayColor
        gDenyText.font = .systemFont(ofSize: 13)
        gBox.addSubview(gDenyText)
        gDenyText.translatesAutoresizingMaskIntoConstraints = false
        gDenyText.topAnchor.constraint(equalTo: gBtn.bottomAnchor, constant: 15).isActive = true
        gDenyText.bottomAnchor.constraint(equalTo: gBox.bottomAnchor, constant: -30).isActive = true
        gDenyText.centerXAnchor.constraint(equalTo: gBox.centerXAnchor, constant: 0).isActive = true
        gDenyText.text = "Cancel"
        gDenyText.isUserInteractionEnabled = true
        gDenyText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSavePlaceDraftDenyClicked)))
        
    }
    
    @objc func onSavePlaceDraftProceedClicked(gesture: UITapGestureRecognizer) {
        print("save place draft proceed")
        self.removeFromSuperview()
        
        delegate?.didSPlDClickProceed()
    }
    
    @objc func onSavePlaceDraftDenyClicked(gesture: UITapGestureRecognizer) {
        print("save place draft deny")
        self.removeFromSuperview()
        
        delegate?.didSPlDClickDeny()
    }
}

extension PlaceCreatorConsolePanelView: SavePlaceDraftMsgDelegate{
    func didSPlDClickProceed() {
        closePlaceCreatorPanel(isAnimated: true)
        
    }
    func didSPlDClickDeny() {
        
    }
}
