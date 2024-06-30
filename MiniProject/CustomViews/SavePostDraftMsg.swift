//
//  SavePostDraftMsg.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

protocol SavePostDraftMsgDelegate : AnyObject {
    func didSPDClickProceed()
    func didSPDClickDeny()
}
class SavePostDraftMsgView: UIView{

    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    let savePostDraftPromptMsg = UIView()
    weak var delegate : SavePostDraftMsgDelegate?

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
        self.addSubview(savePostDraftPromptMsg)
        savePostDraftPromptMsg.translatesAutoresizingMaskIntoConstraints = false
        savePostDraftPromptMsg.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        savePostDraftPromptMsg.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        savePostDraftPromptMsg.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        savePostDraftPromptMsg.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

        let savePostDraftPromptMsgBG = UIView()
        savePostDraftPromptMsg.addSubview(savePostDraftPromptMsgBG)
        savePostDraftPromptMsgBG.backgroundColor = .ddmBlackOverlayColor
        savePostDraftPromptMsgBG.layer.opacity = 0.3
        savePostDraftPromptMsgBG.translatesAutoresizingMaskIntoConstraints = false
        savePostDraftPromptMsgBG.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        savePostDraftPromptMsgBG.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        savePostDraftPromptMsgBG.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        savePostDraftPromptMsgBG.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

        let gBox = UIView()
        savePostDraftPromptMsg.addSubview(gBox)
        gBox.translatesAutoresizingMaskIntoConstraints = false
        gBox.centerXAnchor.constraint(equalTo: savePostDraftPromptMsg.centerXAnchor).isActive = true
        gBox.centerYAnchor.constraint(equalTo: savePostDraftPromptMsg.centerYAnchor, constant: -60).isActive = true
        gBox.leadingAnchor.constraint(equalTo: savePostDraftPromptMsg.leadingAnchor, constant: 50).isActive = true
        gBox.trailingAnchor.constraint(equalTo: savePostDraftPromptMsg.trailingAnchor, constant: -50).isActive = true
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
        gTitleText.text = "Save Post in Draft?"

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
        gBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSavePostDraftProceedClicked)))

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
        gDenyText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSavePostDraftDenyClicked)))

    }

    @objc func onSavePostDraftProceedClicked(gesture: UITapGestureRecognizer) {
        print("save post draft proceed")
        self.removeFromSuperview()

        delegate?.didSPDClickProceed()
    }

    @objc func onSavePostDraftDenyClicked(gesture: UITapGestureRecognizer) {
        print("save post draft deny")
        self.removeFromSuperview()

        delegate?.didSPDClickDeny()
    }
}

extension PostCreatorConsolePanelView: SavePostDraftMsgDelegate{
    func didSPDClickProceed() {
        closePostCreatorPanel(isAnimated: true)
        
//        DataFetchManager.shared.saveData(id: "u") { [weak self]result in
//            switch result {
//                case .success(let l):
//
//                //update UI on main thread
//                DispatchQueue.main.async {
//                    self?.closePostCreatorPanel(isAnimated: true)
//                }
//
//                case .failure(_):
//                    print("api fail")
//                    break
//            }
//        }
    }
    func didSPDClickDeny() {
//        activate()
    }
}
