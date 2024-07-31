//
//  HNotifyChatListViewCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

protocol NotifyHListCellDelegate : AnyObject {

    func fcNotifyHListDidClickVcvClickUser()
    func fcNotifyHListDidClickVcvClickPlace()
    func fcNotifyHListDidClickVcvClickSound()
    func fcNotifyHListDidClickVcvClickPost()
}

//test > horizontal list viewcell for notify
class HNotifyChatListViewCell: UICollectionViewCell {
    static let identifier = "HNotifyChatListViewCell"
    
    weak var aDelegate : NotifyHListCellDelegate?
    
    let messageText = UILabel()
    let messageCountBox = UIView()
    let timeText = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true

        addSubViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        
        //test > result vertical panel layout
        let aResult = UIView()
        aResult.backgroundColor = .ddmDarkColor
        contentView.addSubview(aResult)
        aResult.translatesAutoresizingMaskIntoConstraints = false
        aResult.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        aResult.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        aResult.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        aResult.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
//        aResult.layer.cornerRadius = 10
        aResult.layer.opacity = 0.1 //0.3
        
        let eUserCover = UIView()
//        eUserCover.backgroundColor = .ddmBlackOverlayColor
        eUserCover.backgroundColor = .white
        contentView.addSubview(eUserCover)
        eUserCover.translatesAutoresizingMaskIntoConstraints = false
        eUserCover.topAnchor.constraint(equalTo: aResult.topAnchor, constant: 10).isActive = true
        eUserCover.leadingAnchor.constraint(equalTo: aResult.leadingAnchor, constant: 20).isActive = true
        eUserCover.heightAnchor.constraint(equalToConstant: 50).isActive = true //40
        eUserCover.widthAnchor.constraint(equalToConstant: 50).isActive = true
        eUserCover.layer.cornerRadius = 25
        eUserCover.layer.opacity = 1.0 //default 0.3
        
        let aUserPhoto = SDAnimatedImageView()
        contentView.addSubview(aUserPhoto)
        aUserPhoto.translatesAutoresizingMaskIntoConstraints = false
        aUserPhoto.widthAnchor.constraint(equalToConstant: 50).isActive = true //ori: 24
        aUserPhoto.heightAnchor.constraint(equalToConstant: 50).isActive = true
        aUserPhoto.centerXAnchor.constraint(equalTo: eUserCover.centerXAnchor).isActive = true
        aUserPhoto.centerYAnchor.constraint(equalTo: eUserCover.centerYAnchor).isActive = true
//        aUserPhoto.topAnchor.constraint(equalTo: aResult.topAnchor, constant: 10).isActive = true
//        aUserPhoto.leadingAnchor.constraint(equalTo: aResult.leadingAnchor, constant: 20).isActive = true
        aUserPhoto.contentMode = .scaleAspectFill
        aUserPhoto.layer.masksToBounds = true
        aUserPhoto.layer.cornerRadius = 25
        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        aUserPhoto.sd_setImage(with: imageUrl)
        aUserPhoto.isUserInteractionEnabled = true
        aUserPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onUserClicked)))

        let aNameText = UILabel()
        aNameText.textAlignment = .left
        aNameText.textColor = .white
        aNameText.font = .boldSystemFont(ofSize: 13)
        contentView.addSubview(aNameText)
        aNameText.translatesAutoresizingMaskIntoConstraints = false
//        aNameText.topAnchor.constraint(equalTo: aResult.topAnchor, constant: 10).isActive = true
        aNameText.topAnchor.constraint(equalTo: eUserCover.topAnchor, constant: 0).isActive = true //5
        aNameText.leadingAnchor.constraint(equalTo: aUserPhoto.trailingAnchor, constant: 10).isActive = true
        aNameText.text = "Michael Kins"
        
        //test > verified badge
        let vBtn = UIImageView(image: UIImage(named:"icon_round_verified")?.withRenderingMode(.alwaysTemplate))
//        vBtn.tintColor = .yellow //ddmGoldenYellowColor
        vBtn.tintColor = .ddmGoldenYellowColor
//        vBtn.tintColor = .white //darkGray
        contentView.addSubview(vBtn)
        vBtn.translatesAutoresizingMaskIntoConstraints = false
        vBtn.leadingAnchor.constraint(equalTo: aNameText.trailingAnchor, constant: 5).isActive = true
        vBtn.centerYAnchor.constraint(equalTo: aNameText.centerYAnchor, constant: 0).isActive = true
        vBtn.heightAnchor.constraint(equalToConstant: 14).isActive = true
        vBtn.widthAnchor.constraint(equalToConstant: 14).isActive = true
        
//        let timeText = UILabel()
        timeText.textAlignment = .left
        timeText.textColor = .white
        timeText.font = .systemFont(ofSize: 13)
        contentView.addSubview(timeText)
        timeText.translatesAutoresizingMaskIntoConstraints = false
//        aNameText.topAnchor.constraint(equalTo: aResult.topAnchor, constant: 10).isActive = true
        timeText.centerYAnchor.constraint(equalTo: aNameText.centerYAnchor, constant: 0).isActive = true //5
        timeText.trailingAnchor.constraint(equalTo: aResult.trailingAnchor, constant: -20).isActive = true
        timeText.text = "-"
        timeText.layer.opacity = 0.5 //0.5
        
//        let messageCountBox = UIView()
//        eUserCover.backgroundColor = .ddmBlackOverlayColor
        messageCountBox.backgroundColor = .red
        contentView.addSubview(messageCountBox)
        messageCountBox.translatesAutoresizingMaskIntoConstraints = false
        messageCountBox.topAnchor.constraint(equalTo: timeText.bottomAnchor, constant: 5).isActive = true
        messageCountBox.trailingAnchor.constraint(equalTo: aResult.trailingAnchor, constant: -20).isActive = true
        messageCountBox.heightAnchor.constraint(equalToConstant: 10).isActive = true //40
        messageCountBox.widthAnchor.constraint(equalToConstant: 10).isActive = true
        messageCountBox.layer.cornerRadius = 5
//        messageCountBox.layer.opacity = 0.7 //0.5
        
//        let messageText = UILabel()
        messageText.textAlignment = .left
        messageText.textColor = .white
        messageText.font = .systemFont(ofSize: 13)
//        messageText.font = .boldSystemFont(ofSize: 13)
        contentView.addSubview(messageText)
        messageText.translatesAutoresizingMaskIntoConstraints = false
        messageText.topAnchor.constraint(equalTo: aNameText.bottomAnchor, constant: 5).isActive = true
        messageText.leadingAnchor.constraint(equalTo: aNameText.leadingAnchor, constant: 0).isActive = true
        messageText.text = "-"
//        messageText.text = "@mic1809"
//        messageText.layer.opacity = 0.3 //0.5
    }
    
    @objc func onUserClicked(gesture: UITapGestureRecognizer) {
        print("click open user panel:")
        aDelegate?.fcNotifyHListDidClickVcvClickUser()
    }
    @objc func onAPhotoClicked(gesture: UITapGestureRecognizer) {
        aDelegate?.fcNotifyHListDidClickVcvClickPlace()
    }
    @objc func onBPhotoClicked(gesture: UITapGestureRecognizer) {
        aDelegate?.fcNotifyHListDidClickVcvClickSound()
    }
    @objc func onCPhotoClicked(gesture: UITapGestureRecognizer) {
        aDelegate?.fcNotifyHListDidClickVcvClickPost()
    }
    
    func configure(data: String) {
        if(data == "a") {
            messageText.text = "Happy Birthday!!"
            messageText.layer.opacity = 1.0 //0.5
            messageText.font = .boldSystemFont(ofSize: 13)
            messageCountBox.isHidden = false
            
            timeText.text = "5s"
            timeText.textColor = .white
            timeText.layer.opacity = 1.0 //0.5
        } else if(data == "b") {
            messageText.text = "Honey, wanna come over tonight?"
            messageText.layer.opacity = 0.6 //0.5
            messageText.font = .systemFont(ofSize: 13)
            messageCountBox.isHidden = true
            
            timeText.text = "3h"
            timeText.textColor = .white
            timeText.layer.opacity = 0.5 //0.5
        }
    }
}

extension NotifyPanelView: NotifyHListCellDelegate {
    
    func fcNotifyHListDidClickVcvClickUser() {
        delegate?.didNotifyClickUser()
    }
    func fcNotifyHListDidClickVcvClickPlace() {
        
    }
    func fcNotifyHListDidClickVcvClickSound() {
        
    }
    func fcNotifyHListDidClickVcvClickPost() {
        
    }
}
