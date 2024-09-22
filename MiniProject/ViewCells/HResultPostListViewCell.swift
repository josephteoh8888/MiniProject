//
//  HResultPostListViewCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

class HResultPostListViewCell: UICollectionViewCell {
    static let identifier = "HResultPostListViewCell"
    
    weak var aDelegate : HResultListViewDelegate?
    
    let aUserPhoto = SDAnimatedImageView()
    let aNameText = UILabel()
    let vBtn = UIImageView()
    let aUserNameText = UILabel()
    let contentPhoto = SDAnimatedImageView()
    let contentText = UILabel()
    
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
        eUserCover.heightAnchor.constraint(equalToConstant: 30).isActive = true
        eUserCover.widthAnchor.constraint(equalToConstant: 30).isActive = true
        eUserCover.layer.cornerRadius = 15
//        eUserCover.layer.opacity = 1.0 //default 0.3
        
//        let aUserPhoto = SDAnimatedImageView()
        contentView.addSubview(aUserPhoto)
        aUserPhoto.translatesAutoresizingMaskIntoConstraints = false
        aUserPhoto.widthAnchor.constraint(equalToConstant: 30).isActive = true //36
        aUserPhoto.heightAnchor.constraint(equalToConstant: 30).isActive = true
        aUserPhoto.centerXAnchor.constraint(equalTo: eUserCover.centerXAnchor).isActive = true
        aUserPhoto.centerYAnchor.constraint(equalTo: eUserCover.centerYAnchor).isActive = true
//        aUserPhoto.topAnchor.constraint(equalTo: aResult.topAnchor, constant: 10).isActive = true
//        aUserPhoto.leadingAnchor.constraint(equalTo: aResult.leadingAnchor, constant: 20).isActive = true
        aUserPhoto.contentMode = .scaleAspectFill
        aUserPhoto.layer.masksToBounds = true
        aUserPhoto.layer.cornerRadius = 15
//        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
//        aUserPhoto.sd_setImage(with: imageUrl)
//        aUserPhoto.backgroundColor = .ddmDarkGreyColor
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
//        aFollowAText.text = "Follow"
        
//        let aNameText = UILabel()
        aNameText.textAlignment = .left
        aNameText.textColor = .white
        aNameText.font = .boldSystemFont(ofSize: 13)
        contentView.addSubview(aNameText)
        aNameText.translatesAutoresizingMaskIntoConstraints = false
//        aNameText.topAnchor.constraint(equalTo: aResult.topAnchor, constant: 10).isActive = true
        aNameText.topAnchor.constraint(equalTo: eUserCover.topAnchor, constant: 0).isActive = true
        aNameText.leadingAnchor.constraint(equalTo: aUserPhoto.trailingAnchor, constant: 10).isActive = true
        aNameText.text = "-"
        
        //test > verified badge
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
        
//        let contentPhoto = SDAnimatedImageView()
        contentView.addSubview(contentPhoto)
        contentPhoto.translatesAutoresizingMaskIntoConstraints = false
        contentPhoto.widthAnchor.constraint(equalToConstant: 50).isActive = true //36
        contentPhoto.heightAnchor.constraint(equalToConstant: 50).isActive = true
        contentPhoto.trailingAnchor.constraint(equalTo: aResult.trailingAnchor, constant: -20).isActive = true //-30
        contentPhoto.topAnchor.constraint(equalTo: eUserCover.bottomAnchor, constant: 20).isActive = true
        contentPhoto.contentMode = .scaleAspectFill
        contentPhoto.layer.masksToBounds = true
        contentPhoto.layer.cornerRadius = 5
//        let imageUrl1 = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
//        contentPhoto.sd_setImage(with: imageUrl1)
        contentPhoto.backgroundColor = .ddmDarkColor
        
//        let contentText = UILabel()
        contentText.textAlignment = .left
        contentText.textColor = .white
        contentText.font = .systemFont(ofSize: 14)
        contentView.addSubview(contentText)
        contentText.translatesAutoresizingMaskIntoConstraints = false
        contentText.topAnchor.constraint(equalTo: eUserCover.bottomAnchor, constant: 20).isActive = true
        contentText.leadingAnchor.constraint(equalTo: eUserCover.leadingAnchor, constant: 0).isActive = true
//        contentText.trailingAnchor.constraint(equalTo: aResult.trailingAnchor, constant: -20).isActive = true //-30
        contentText.trailingAnchor.constraint(equalTo: contentPhoto.leadingAnchor, constant: -20).isActive = true //-30
//        contentText.text = "A defiant Vladimir Putin said Russia won’t be stopped from pursuing its goals after he swept to a record victory in a presidential election whose outcome was pre-determined."
        contentText.numberOfLines = 3 //0
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        print("HResultUserListViewCell prepare for reuse")
        
        let imageUrl = URL(string: "")
        aUserPhoto.sd_setImage(with: imageUrl)
        let imageUrl1 = URL(string: "")
        contentPhoto.sd_setImage(with: imageUrl1)
        
        aNameText.text = "-"
        aUserNameText.text = "-"
        vBtn.image = nil

        contentText.text = "-"
    }
    func configure(data: PostData) {
        asyncConfigure(data: "")
    }
    //*test > async fetch images/names/videos
    func asyncConfigure(data: String) {
        let id = "p"
        DataFetchManager.shared.fetchPlaceData(id: id) { [weak self]result in
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
                    let imageUrl1 = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
                    self.contentPhoto.sd_setImage(with: imageUrl1)
                    
                    self.aNameText.text = "Michael Kins"
                    self.aUserNameText.text = "2hr"
                    self.contentText.text = "A defiant Vladimir Putin said Russia won’t be stopped from pursuing its goals after he swept to a record victory in a presidential election whose outcome was pre-determined."
                    
                    self.vBtn.image = UIImage(named:"icon_round_verified")?.withRenderingMode(.alwaysTemplate)
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    
                    guard let self = self else {
                        return
                    }
                    
                    self.aNameText.text = "-"
                    self.aUserNameText.text = "-"
                    self.vBtn.image = nil
                    self.contentText.text = "-"
                    
                    let imageUrl = URL(string: "")
                    self.aUserPhoto.sd_setImage(with: imageUrl)
                    
                    let imageUrl1 = URL(string: "")
                    self.contentPhoto.sd_setImage(with: imageUrl1)
                }
                break
            }
        }
    }
    //*
    @objc func onUserClicked(gesture: UITapGestureRecognizer) {
        aDelegate?.didHResultClickPost()
    }
}
