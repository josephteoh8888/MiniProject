//
//  HResultSoundListViewCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

protocol HResultListViewDelegate : AnyObject {

    //test > connect to other panel
    func didHResultClickUser(id: String)
    func didHResultClickPlace(id: String)
    func didHResultClickSound(id: String)
    func didHResultClickHashtag()
    func didHResultClickPhoto(id: String)
    func didHResultClickVideo(id: String)
    func didHResultClickPost(id: String, dataType: String)
    
    func didHResultClickSignIn()
}
class HResultSoundListViewCell: UICollectionViewCell {
    static let identifier = "HResultSoundListViewCell"
    
    weak var aDelegate : HResultListViewDelegate?
    
    let aUserPhoto = SDAnimatedImageView()
    let aFollowA = UIView()
    let aFollowAText = UILabel()
    let aNameText = UILabel()
    let aUserNameText = UILabel()
    let playBtn = UIImageView()
    let vBtn = UIImageView()
    
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

        let eUserCover = UIView()
//        eUserCover.backgroundColor = .ddmBlackOverlayColor
//        eUserCover.backgroundColor = .white
        eUserCover.backgroundColor = .clear
        contentView.addSubview(eUserCover)
        eUserCover.translatesAutoresizingMaskIntoConstraints = false
        eUserCover.topAnchor.constraint(equalTo: aResult.topAnchor, constant: 10).isActive = true //10
        eUserCover.leadingAnchor.constraint(equalTo: aResult.leadingAnchor, constant: 20).isActive = true //20
        eUserCover.heightAnchor.constraint(equalToConstant: 40).isActive = true
        eUserCover.widthAnchor.constraint(equalToConstant: 40).isActive = true
        eUserCover.layer.cornerRadius = 20
//        eUserCover.layer.opacity = 1.0 //default 0.3
        
//        let aUserPhoto = SDAnimatedImageView()
        contentView.addSubview(aUserPhoto)
        aUserPhoto.translatesAutoresizingMaskIntoConstraints = false
        aUserPhoto.widthAnchor.constraint(equalToConstant: 40).isActive = true //36
        aUserPhoto.heightAnchor.constraint(equalToConstant: 40).isActive = true
        aUserPhoto.centerXAnchor.constraint(equalTo: eUserCover.centerXAnchor).isActive = true
        aUserPhoto.centerYAnchor.constraint(equalTo: eUserCover.centerYAnchor).isActive = true
//        aUserPhoto.topAnchor.constraint(equalTo: aResult.topAnchor, constant: 10).isActive = true
//        aUserPhoto.leadingAnchor.constraint(equalTo: aResult.leadingAnchor, constant: 20).isActive = true
        aUserPhoto.contentMode = .scaleAspectFill
        aUserPhoto.layer.masksToBounds = true
        aUserPhoto.layer.cornerRadius = 5
//        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
//        let imageUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
//        aUserPhoto.sd_setImage(with: imageUrl)
        aUserPhoto.backgroundColor = .ddmDarkColor
        
//        let aFollowA = UIView()
//        aFollowA.backgroundColor = .yellow
//        contentView.addSubview(aFollowA)
//        aFollowA.translatesAutoresizingMaskIntoConstraints = false
////        aFollowA.leadingAnchor.constraint(equalTo: aPanelView.leadingAnchor, constant: 20).isActive = true
//        aFollowA.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
//        aFollowA.heightAnchor.constraint(equalToConstant: 30).isActive = true //30
////        aFollowA.bottomAnchor.constraint(equalTo: aPhoto.bottomAnchor, constant: 0).isActive = true
//        aFollowA.topAnchor.constraint(equalTo: eUserCover.topAnchor, constant: 5).isActive = true
//        aFollowA.layer.cornerRadius = 10
//        aFollowA.isUserInteractionEnabled = true
////        aFollowA.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onFollowClicked)))
////        aFollowA.isHidden = true
//
//        let aFollowAText = UILabel()
//        aFollowAText.textAlignment = .center
//        aFollowAText.textColor = .black
//        aFollowAText.font = .boldSystemFont(ofSize: 13) //default 14
////        aPanelView.addSubview(aFollowAText)
//        aFollowA.addSubview(aFollowAText)
//        aFollowAText.translatesAutoresizingMaskIntoConstraints = false
//        aFollowAText.leadingAnchor.constraint(equalTo: aFollowA.leadingAnchor, constant: 15).isActive = true //20
//        aFollowAText.trailingAnchor.constraint(equalTo: aFollowA.trailingAnchor, constant: -15).isActive = true
//        aFollowAText.centerYAnchor.constraint(equalTo: aFollowA.centerYAnchor).isActive = true
//        aFollowAText.text = "Save"
        
//        let playBtn = UIImageView(image: UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate))
        playBtn.image = UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate)
        playBtn.tintColor = .white
        contentView.addSubview(playBtn)
        playBtn.translatesAutoresizingMaskIntoConstraints = false
//        playBtn.centerYAnchor.constraint(equalTo: aFollowA.centerYAnchor, constant: 0).isActive = true
        playBtn.topAnchor.constraint(equalTo: eUserCover.topAnchor, constant: 5).isActive = true
//        playBtn.trailingAnchor.constraint(equalTo: aFollowA.leadingAnchor, constant: -5).isActive = true //0
        playBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        playBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true //20
        playBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
        playBtn.isHidden = true
//        playBtn.isUserInteractionEnabled = true
//        playBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onResumeAudioClicked)))
        
//        let aNameText = UILabel()
        aNameText.textAlignment = .left
        aNameText.textColor = .white
        aNameText.font = .boldSystemFont(ofSize: 13)
        contentView.addSubview(aNameText)
        aNameText.translatesAutoresizingMaskIntoConstraints = false
//        aNameText.topAnchor.constraint(equalTo: aResult.topAnchor, constant: 10).isActive = true
        aNameText.topAnchor.constraint(equalTo: eUserCover.topAnchor, constant: 5).isActive = true
        aNameText.leadingAnchor.constraint(equalTo: aUserPhoto.trailingAnchor, constant: 10).isActive = true
        aNameText.text = "-"
//        aNameText.trailingAnchor.constraint(equalTo: playBtn.trailingAnchor, constant: -10).isActive = true
        aNameText.trailingAnchor.constraint(lessThanOrEqualTo: playBtn.leadingAnchor, constant: -50).isActive = true
        
        //test > verified badge
//        let vBtn = UIImageView(image: UIImage(named:"icon_round_verified")?.withRenderingMode(.alwaysTemplate))
//        vBtn.image = UIImage(named:"icon_round_verified")?.withRenderingMode(.alwaysTemplate)
//        vBtn.tintColor = .yellow //ddmGoldenYellowColor
        vBtn.tintColor = .ddmGoldenYellowColor
//        vBtn.tintColor = .white //darkGray
        contentView.addSubview(vBtn)
        vBtn.translatesAutoresizingMaskIntoConstraints = false
        vBtn.leadingAnchor.constraint(equalTo: aNameText.trailingAnchor, constant: 5).isActive = true
        vBtn.centerYAnchor.constraint(equalTo: aNameText.centerYAnchor, constant: 0).isActive = true
        vBtn.heightAnchor.constraint(equalToConstant: 14).isActive = true
        vBtn.widthAnchor.constraint(equalToConstant: 14).isActive = true
        //
        
//        let aUserNameText = UILabel()
        aUserNameText.textAlignment = .left
        aUserNameText.textColor = .ddmDarkGrayColor
        aUserNameText.font = .systemFont(ofSize: 12)
        contentView.addSubview(aUserNameText)
        aUserNameText.translatesAutoresizingMaskIntoConstraints = false
        aUserNameText.topAnchor.constraint(equalTo: aNameText.bottomAnchor).isActive = true
        aUserNameText.leadingAnchor.constraint(equalTo: aNameText.leadingAnchor, constant: 0).isActive = true
        aUserNameText.text = "-"
//        aUserNameText.text = "@mic1809"
//        aUserNameText.layer.opacity = 0.3 //0.5
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("sfvideo prepare for reuse")
        
        //test > clear id
        setId(id: "")
        
        vBtn.image = nil
        aNameText.text = "-"
        aUserNameText.text = "-"
        
        let imageUrl = URL(string: "")
        aUserPhoto.sd_setImage(with: imageUrl)
        
        playBtn.isHidden = true
    }
    
    //test > set id for init
    var id = ""
    func setId(id: String) {
        self.id = id
    }
    
    func configure(data: BaseData) {
        guard let a = data as? SoundData else {
            return
        }
        
        setId(id: data.id)
        
        let l = a.dataCode
        
        if(l == "a") {
            asyncConfigure(data: "")
            
            self.aNameText.text = a.dataTextString
            let imageUrl = URL(string: a.coverPhotoString)
            self.aUserPhoto.sd_setImage(with: imageUrl)
            
            if(a.isAccountVerified) {
                self.vBtn.image = UIImage(named:"icon_round_verified")?.withRenderingMode(.alwaysTemplate)
            }
        }
        else if(l == "na") {
            
        }
        else if(l == "us") {
            
        }
    }
    
    //*test > async fetch images/names/videos
    func asyncConfigure(data: String) {
        let id = "a"
        DataFetchManager.shared.fetchDummyDataTimeDelay(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("pdp api success \(id), \(l)")
                    
                    guard let self = self else {
                        return
                    }

                    self.aUserNameText.text = "Hubert Wu"
//                    self.vBtn.image = UIImage(named:"icon_round_verified")?.withRenderingMode(.alwaysTemplate)
                    
//                    let imageUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
//                    self.aUserPhoto.sd_setImage(with: imageUrl)
                    
                    self.playBtn.isHidden = false
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    
                    guard let self = self else {
                        return
                    }
                    
//                    self.aNameText.text = "-"
                    self.aUserNameText.text = "-"
//                    self.vBtn.image = nil
                    
//                    let imageUrl = URL(string: "")
//                    self.aUserPhoto.sd_setImage(with: imageUrl)
                    
                    self.playBtn.isHidden = true
                }
                break
            }
        }
    }
    //*
    
    @objc func onUserClicked(gesture: UITapGestureRecognizer) {
        aDelegate?.didHResultClickSound(id: id)
    }
}
