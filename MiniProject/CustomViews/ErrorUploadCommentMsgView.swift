//
//  CommentChainCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 15/08/2024.
//

import Foundation
import UIKit
import SDWebImage

protocol ErrorUploadCommentMsgDelegate : AnyObject {
    func didEUCommentClickProceed()
    func didEUCommentClickDeny()
}

//test > custom cell for chaining comments
class ErrorUploadCommentMsgView: UIView {
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    let promptMsg = UIView()
    weak var delegate : ErrorUploadCommentMsgDelegate?

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
        self.addSubview(promptMsg)
        promptMsg.translatesAutoresizingMaskIntoConstraints = false
        promptMsg.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        promptMsg.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        promptMsg.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        promptMsg.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        promptMsg.isHidden = true

        let promptMsgBG = UIView()
        promptMsg.addSubview(promptMsgBG)
        promptMsgBG.backgroundColor = .ddmBlackOverlayColor
        promptMsgBG.layer.opacity = 0.3
        promptMsgBG.translatesAutoresizingMaskIntoConstraints = false
        promptMsgBG.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        promptMsgBG.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        promptMsgBG.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        promptMsgBG.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

        let gBox = UIView()
        promptMsg.addSubview(gBox)
        gBox.translatesAutoresizingMaskIntoConstraints = false
        gBox.centerXAnchor.constraint(equalTo: promptMsg.centerXAnchor).isActive = true
        gBox.centerYAnchor.constraint(equalTo: promptMsg.centerYAnchor, constant: -60).isActive = true
        gBox.leadingAnchor.constraint(equalTo: promptMsg.leadingAnchor, constant: 50).isActive = true
        gBox.trailingAnchor.constraint(equalTo: promptMsg.trailingAnchor, constant: -50).isActive = true
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
//        gTitleText.text = "Error Uploading Comment."
        gTitleText.text = "Retry Uploading?"
        
        let gDetailText = UILabel()
        gDetailText.textAlignment = .center
//        gDetailText.textColor = .white
        gDetailText.textColor = .ddmBlackOverlayColor
        gDetailText.font = .systemFont(ofSize: 13)
        gBox.addSubview(gDetailText)
        gDetailText.translatesAutoresizingMaskIntoConstraints = false
//        gTitleText.centerYAnchor.constraint(equalTo: gBox.centerYAnchor).isActive = true
        gDetailText.topAnchor.constraint(equalTo: gTitleText.bottomAnchor, constant: 10).isActive = true
//        gDetailText.bottomAnchor.constraint(equalTo: gBox.bottomAnchor, constant: -30).isActive = true
        gDetailText.leadingAnchor.constraint(equalTo: gBox.leadingAnchor, constant: 60).isActive = true
        gDetailText.trailingAnchor.constraint(equalTo: gBox.trailingAnchor, constant: -60).isActive = true
        gDetailText.numberOfLines = 0
//        gDetailText.text = "Try again?"
        gDetailText.text = "Error sending comment."

        let gBtn = UIView()
        gBox.addSubview(gBtn)
        gBtn.backgroundColor = .yellow
        gBtn.translatesAutoresizingMaskIntoConstraints = false
        gBtn.leadingAnchor.constraint(equalTo: gBox.leadingAnchor, constant: 50).isActive = true
        gBtn.trailingAnchor.constraint(equalTo: gBox.trailingAnchor, constant: -50).isActive = true
        gBtn.topAnchor.constraint(equalTo: gDetailText.bottomAnchor, constant: 30).isActive = true
//        gBtn.bottomAnchor.constraint(equalTo: gBox.bottomAnchor, constant: -30).isActive = true
        gBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        gBtn.layer.cornerRadius = 10
        gBtn.isUserInteractionEnabled = true
        gBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onEUCommentProceedClicked)))

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
        gBtnText.text = "Retry"

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
        gDenyText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onEUCommentDenyClicked)))
    }

    @objc func onEUCommentProceedClicked(gesture: UITapGestureRecognizer) {
        self.removeFromSuperview()
        self.delegate?.didEUCommentClickProceed()
    }
    @objc func onEUCommentDenyClicked(gesture: UITapGestureRecognizer) {
        self.removeFromSuperview()
        self.delegate?.didEUCommentClickDeny()
    }
}
