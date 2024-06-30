//
//  ExitVideoEditorMsg.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

protocol ExitVideoEditorMsgDelegate : AnyObject {
    func didSVDClickProceed()
    func didSVDClickDeny()
    func didSVDInitialize()
}
class ExitVideoEditorMsgView: UIView{
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    let exitVideoEditorPromptMsg = UIView()
    weak var delegate : ExitVideoEditorMsgDelegate?

    var isExitVideoInitialized = false

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
        self.addSubview(exitVideoEditorPromptMsg)
        exitVideoEditorPromptMsg.translatesAutoresizingMaskIntoConstraints = false
        exitVideoEditorPromptMsg.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        exitVideoEditorPromptMsg.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        exitVideoEditorPromptMsg.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        exitVideoEditorPromptMsg.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

        let exitVideoEditorPromptMsgBG = UIView()
        exitVideoEditorPromptMsg.addSubview(exitVideoEditorPromptMsgBG)
        exitVideoEditorPromptMsgBG.backgroundColor = .ddmBlackOverlayColor
        exitVideoEditorPromptMsgBG.layer.opacity = 0.3
        exitVideoEditorPromptMsgBG.translatesAutoresizingMaskIntoConstraints = false
        exitVideoEditorPromptMsgBG.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        exitVideoEditorPromptMsgBG.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        exitVideoEditorPromptMsgBG.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        exitVideoEditorPromptMsgBG.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

        let gBox = UIView()
        exitVideoEditorPromptMsg.addSubview(gBox)
        gBox.translatesAutoresizingMaskIntoConstraints = false
        gBox.centerXAnchor.constraint(equalTo: exitVideoEditorPromptMsg.centerXAnchor).isActive = true
        gBox.centerYAnchor.constraint(equalTo: exitVideoEditorPromptMsg.centerYAnchor, constant: -60).isActive = true
        gBox.leadingAnchor.constraint(equalTo: exitVideoEditorPromptMsg.leadingAnchor, constant: 50).isActive = true
        gBox.trailingAnchor.constraint(equalTo: exitVideoEditorPromptMsg.trailingAnchor, constant: -50).isActive = true
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
        gTitleText.text = "Discard Changes to Video?"

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
        gBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onExitVideoEditorProceedClicked)))

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
        gBtnText.text = "Discard"

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
        gDenyText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onExitVideoEditorDenyClicked)))
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        print("exitvideo layoutsubview: ")

        //test > initialize prompt
        if(!isExitVideoInitialized) {
            isExitVideoInitialized = true

            delegate?.didSVDInitialize()
        }
    }

    @objc func onExitVideoEditorProceedClicked(gesture: UITapGestureRecognizer) {
        print("exit video editor proceed")
        self.removeFromSuperview()

        delegate?.didSVDClickProceed()
    }

    @objc func onExitVideoEditorDenyClicked(gesture: UITapGestureRecognizer) {
        print("exit video editor deny")
        self.removeFromSuperview()

        delegate?.didSVDClickDeny()
    }
}

extension VideoEditorPanelView: ExitVideoEditorMsgDelegate{
    func didSVDClickProceed() {
        closeVideoEditorPanel(isAnimated: true)
    }
    func didSVDClickDeny() {
        delegate?.didDenyExitVideoEditor()
    }
    func didSVDInitialize() {
        delegate?.didPromptExitVideoEditor()
    }
}
