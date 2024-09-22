//
//  HNotifyInboxListViewCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

protocol HNotifyListViewDelegate : AnyObject {

    //test > connect to other panel
    func didHNotifyClickUser()
    func didHNotifyClickPlace()
    func didHNotifyClickSound()
    func didHNotifyClickHashtag()
    func didHNotifyClickPhoto()
    func didHNotifyClickVideo()
    func didHNotifyClickPost()
}
//test > horizontal list viewcell for sound panel
class HNotifyInboxListViewCell: UICollectionViewCell {
    static let identifier = "HNotifyInboxListViewCell"
    
    weak var aDelegate : HNotifyListViewDelegate?
    
    let aUserPhoto = SDAnimatedImageView()
    let aNameText = UILabel()
    let contentText = UILabel()
    
    let aFollowA = UIView()
    let aFollowAText = UILabel()
    
    var isAction = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)

//        contentView.backgroundColor = .black
        contentView.clipsToBounds = true

        addSubViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {

        //test > result vertical panel layout
        let aResult = UIView()
//        aResult.backgroundColor = .ddmDarkColor
        aResult.backgroundColor = .ddmDarkBlack
        contentView.addSubview(aResult)
        aResult.translatesAutoresizingMaskIntoConstraints = false
        aResult.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        aResult.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        aResult.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        aResult.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
//        aResult.layer.cornerRadius = 10
//        aResult.layer.opacity = 0.1 //0.3
        aResult.isUserInteractionEnabled = true
        aResult.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onUserClicked)))
        ////////////////////
        ///
        let eUserCover = UIView()
//        eUserCover.backgroundColor = .ddmBlackOverlayColor
        eUserCover.backgroundColor = .clear
        contentView.addSubview(eUserCover)
        eUserCover.translatesAutoresizingMaskIntoConstraints = false
        eUserCover.topAnchor.constraint(equalTo: aResult.topAnchor, constant: 10).isActive = true
        eUserCover.leadingAnchor.constraint(equalTo: aResult.leadingAnchor, constant: 20).isActive = true
        eUserCover.heightAnchor.constraint(equalToConstant: 40).isActive = true //40
        eUserCover.widthAnchor.constraint(equalToConstant: 40).isActive = true
        eUserCover.layer.cornerRadius = 20
//        eUserCover.layer.opacity = 1.0 //default 0.3
        
//        let aUserPhoto = SDAnimatedImageView()
        contentView.addSubview(aUserPhoto)
        aUserPhoto.translatesAutoresizingMaskIntoConstraints = false
        aUserPhoto.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 24
        aUserPhoto.heightAnchor.constraint(equalToConstant: 40).isActive = true
        aUserPhoto.centerXAnchor.constraint(equalTo: eUserCover.centerXAnchor).isActive = true
        aUserPhoto.centerYAnchor.constraint(equalTo: eUserCover.centerYAnchor).isActive = true
//        aUserPhoto.topAnchor.constraint(equalTo: aResult.topAnchor, constant: 10).isActive = true
//        aUserPhoto.leadingAnchor.constraint(equalTo: aResult.leadingAnchor, constant: 20).isActive = true
        aUserPhoto.contentMode = .scaleAspectFill
        aUserPhoto.layer.masksToBounds = true
        aUserPhoto.layer.cornerRadius = 20
//        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
//        aUserPhoto.sd_setImage(with: imageUrl)
        aUserPhoto.backgroundColor = .ddmDarkColor
        aUserPhoto.isUserInteractionEnabled = true
        aUserPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onUserClicked)))
        
//        let aFollowA = UIView()
        aFollowA.backgroundColor = .yellow
        contentView.addSubview(aFollowA)
        aFollowA.translatesAutoresizingMaskIntoConstraints = false
//        aFollowA.leadingAnchor.constraint(equalTo: aPanelView.leadingAnchor, constant: 20).isActive = true
        aFollowA.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        aFollowA.heightAnchor.constraint(equalToConstant: 30).isActive = true //30
//        aFollowA.bottomAnchor.constraint(equalTo: aPhoto.bottomAnchor, constant: 0).isActive = true
        aFollowA.topAnchor.constraint(equalTo: eUserCover.topAnchor, constant: 5).isActive = true
        aFollowA.layer.cornerRadius = 10
        aFollowA.isUserInteractionEnabled = true
        aFollowA.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onFollowClicked)))
        aFollowA.isHidden = true

//        let aFollowAText = UILabel()
        aFollowAText.textAlignment = .center
        aFollowAText.textColor = .black
        aFollowAText.font = .boldSystemFont(ofSize: 13) //default 14
//        aPanelView.addSubview(aFollowAText)
        aFollowA.addSubview(aFollowAText)
        aFollowAText.translatesAutoresizingMaskIntoConstraints = false
        aFollowAText.leadingAnchor.constraint(equalTo: aFollowA.leadingAnchor, constant: 15).isActive = true //20
        aFollowAText.trailingAnchor.constraint(equalTo: aFollowA.trailingAnchor, constant: -15).isActive = true
        aFollowAText.centerYAnchor.constraint(equalTo: aFollowA.centerYAnchor).isActive = true
        aFollowAText.text = "Follow"
        
//        let aNameText = UILabel()
        aNameText.textAlignment = .left
        aNameText.textColor = .white
        aNameText.font = .boldSystemFont(ofSize: 13)
        contentView.addSubview(aNameText)
        aNameText.translatesAutoresizingMaskIntoConstraints = false
//        aNameText.topAnchor.constraint(equalTo: aResult.topAnchor, constant: 10).isActive = true
        aNameText.topAnchor.constraint(equalTo: eUserCover.topAnchor, constant: 0).isActive = true //5
        aNameText.leadingAnchor.constraint(equalTo: aUserPhoto.trailingAnchor, constant: 10).isActive = true
        aNameText.text = "-"
        
//        let contentText = UILabel()
        contentText.textAlignment = .left
        contentText.textColor = .white
        contentText.font = .systemFont(ofSize: 13)
        contentView.addSubview(contentText)
        contentText.translatesAutoresizingMaskIntoConstraints = false
        contentText.topAnchor.constraint(equalTo: aNameText.bottomAnchor, constant: 5).isActive = true
        contentText.leadingAnchor.constraint(equalTo: aNameText.leadingAnchor, constant: 0).isActive = true
        contentText.trailingAnchor.constraint(equalTo: aResult.trailingAnchor, constant: -20).isActive = true //-30
//        contentText.trailingAnchor.constraint(equalTo: aUserPhoto.leadingAnchor, constant: -20).isActive = true //-30
        contentText.text = "-"
        contentText.numberOfLines = 2 //0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("sfvideo prepare for reuse")
        
        self.aNameText.text = "-"
        contentText.text = "-"
        
        let imageUrl = URL(string: "")
        self.aUserPhoto.sd_setImage(with: imageUrl)
        
        //test
        aFollowA.isHidden = true
        
        actionUI(doneState: false)
    }
    
    @objc func onUserClicked(gesture: UITapGestureRecognizer) {
        aDelegate?.didHNotifyClickUser()
    }
    
    @objc func onFollowClicked(gesture: UITapGestureRecognizer) {
        
        let isSignedIn = SignInManager.shared.getStatus()
        if(isSignedIn) {
            if(isAction) {
                actionUI(doneState: false)
                isAction = false
            } else {
                actionUI(doneState: true)
                isAction = true
            }
        }
        else {
//            aDelegate?.didHResultClickSignIn()
        }
    }
    func actionUI(doneState: Bool) {
        if(doneState) {
            aFollowA.backgroundColor = .ddmDarkColor
            aFollowAText.text = "Following"
            aFollowAText.textColor = .white
        }
        else {
            aFollowA.backgroundColor = .yellow
            aFollowAText.text = "Follow"
            aFollowAText.textColor = .black
        }
    }
    func configure(data: String) {
        
        asyncConfigure(data: "")
        
        if(data == "a") {
            aNameText.text = "YikCai"
            contentText.text = "started following you."
        } else if(data == "b") {
            aNameText.text = "Evelyn"
            contentText.text = "liked your recent comment."
        } else if(data == "c") {
            aNameText.text = "Teacher Isa"
            contentText.text = "shared a loop 5s ago."
        } else if(data == "d") {
            aNameText.text = "Sis Ning"
            contentText.text = "just commented on your post."
        }
        
        actionUI(doneState: isAction)
    }
    //*test > async fetch images/names/videos
    func asyncConfigure(data: String) {
        let id = "u"
        DataFetchManager.shared.fetchUserData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("pdp api success \(id), \(l)")
                    
                    guard let self = self else {
                        return
                    }

                    let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
                    self.aUserPhoto.sd_setImage(with: imageUrl)
                    
                    self.aFollowA.isHidden = false
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    
                    guard let self = self else {
                        return
                    }
                    
                    let imageUrl = URL(string: "")
                    self.aUserPhoto.sd_setImage(with: imageUrl)
                    
                    self.aFollowA.isHidden = true
                }
                break
            }
        }
    }
    //*
}

