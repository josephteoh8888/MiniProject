//
//  HUsersListViewCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

protocol HUsersListDelegate : AnyObject {
    func didHUsersClickUser(id: String)
    func didHUsersClickVideo()
}
class HUsersListViewCell: UICollectionViewCell {
    static let identifier = "HUsersListViewCell"
    
    weak var aDelegate : HUsersListDelegate?
    
    let aUserPhoto = SDAnimatedImageView()
    let aNameText = UILabel()
    let aUserNameText = UILabel()
    let vBtn = UIImageView()
    
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
        aUserPhoto.layer.cornerRadius = 20
//        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
//        aUserPhoto.sd_setImage(with: imageUrl)
        aUserPhoto.backgroundColor = .ddmDarkColor
        
//        let aNameText = UILabel()
        aNameText.textAlignment = .left
        aNameText.textColor = .white
        aNameText.font = .boldSystemFont(ofSize: 13)
        contentView.addSubview(aNameText)
        aNameText.translatesAutoresizingMaskIntoConstraints = false
        aNameText.topAnchor.constraint(equalTo: aResult.topAnchor, constant: 10).isActive = true
        aNameText.leadingAnchor.constraint(equalTo: aUserPhoto.trailingAnchor, constant: 10).isActive = true
        aNameText.text = "-"
        
        //test > verified badge
//        let vBtn = UIImageView(image: UIImage(named:"icon_round_verified")?.withRenderingMode(.alwaysTemplate))
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
        
        let aGrid = UIView()
        aGrid.backgroundColor = .ddmDarkColor
        contentView.addSubview(aGrid)
        aGrid.translatesAutoresizingMaskIntoConstraints = false
        aGrid.leadingAnchor.constraint(equalTo: aResult.leadingAnchor, constant: 20).isActive = true
        aGrid.heightAnchor.constraint(equalToConstant: 70).isActive = true
        aGrid.widthAnchor.constraint(equalToConstant: 50).isActive = true
        aGrid.topAnchor.constraint(equalTo: eUserCover.bottomAnchor, constant: 10).isActive = true
//        aGrid.topAnchor.constraint(equalTo: aNameText.bottomAnchor, constant: 20).isActive = true
        aGrid.layer.cornerRadius = 10

//        let aImageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
        let gifImage = SDAnimatedImageView()
        gifImage.contentMode = .scaleAspectFill
        gifImage.layer.masksToBounds = true
        gifImage.layer.cornerRadius = 10
//        gifImage.sd_setImage(with: aImageUrl)
        aGrid.addSubview(gifImage)
        gifImage.translatesAutoresizingMaskIntoConstraints = false
        gifImage.topAnchor.constraint(equalTo: aGrid.topAnchor).isActive = true
        gifImage.leadingAnchor.constraint(equalTo: aGrid.leadingAnchor).isActive = true
        gifImage.bottomAnchor.constraint(equalTo: aGrid.bottomAnchor).isActive = true
        gifImage.trailingAnchor.constraint(equalTo: aGrid.trailingAnchor).isActive = true

        let bGrid = UIView()
        bGrid.backgroundColor = .ddmDarkColor
        contentView.addSubview(bGrid)
        bGrid.translatesAutoresizingMaskIntoConstraints = false
        bGrid.leadingAnchor.constraint(equalTo: aGrid.trailingAnchor, constant: 10).isActive = true
        bGrid.heightAnchor.constraint(equalToConstant: 70).isActive = true
        bGrid.widthAnchor.constraint(equalToConstant: 50).isActive = true
        bGrid.topAnchor.constraint(equalTo: aGrid.topAnchor).isActive = true
        bGrid.layer.cornerRadius = 10

        let cGrid = UIView()
        cGrid.backgroundColor = .ddmDarkColor
        contentView.addSubview(cGrid)
        cGrid.translatesAutoresizingMaskIntoConstraints = false
        cGrid.leadingAnchor.constraint(equalTo: bGrid.trailingAnchor, constant: 10).isActive = true
        cGrid.heightAnchor.constraint(equalToConstant: 70).isActive = true
        cGrid.widthAnchor.constraint(equalToConstant: 50).isActive = true
        cGrid.topAnchor.constraint(equalTo: aGrid.topAnchor).isActive = true
//        cGrid.bottomAnchor.constraint(equalTo: aPanelView.bottomAnchor).isActive = true //
        cGrid.layer.cornerRadius = 10
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("HResultUserListViewCell prepare for reuse")
        
        let imageUrl = URL(string: "")
        aUserPhoto.sd_setImage(with: imageUrl)
        
        aNameText.text = "-"
        aUserNameText.text = "-"
        vBtn.image = nil
    }
    
//    func configure(data: String) {
    func configure(data: BaseData) {
        guard let a = data as? UserData else {
            return
        }
        
        let l = a.dataCode
        
        if(l == "a") {
            asyncConfigure(data: "")
            
            self.aNameText.text = a.dataTextString
            self.aUserNameText.text = "140k followers" //"@mic1809"
            
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

//                    let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
//                    self.aUserPhoto.sd_setImage(with: imageUrl)
                    
//                    self.aNameText.text = "Michael Kins"
//                    self.aUserNameText.text = "140k followers" //"@mic1809"
                    
//                    self.vBtn.image = UIImage(named:"icon_round_verified")?.withRenderingMode(.alwaysTemplate)
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    
                    guard let self = self else {
                        return
                    }
                    
//                    self.aNameText.text = "-"
//                    self.aUserNameText.text = "-"
//                    self.vBtn.image = nil
                    
//                    let imageUrl = URL(string: "")
//                    self.aUserPhoto.sd_setImage(with: imageUrl)
                    
                }
                break
            }
        }
    }
    
    @objc func onUserClicked(gesture: UITapGestureRecognizer) {
        aDelegate?.didHUsersClickUser(id: "")
    }
}

extension UsersMiniScrollablePanelView: HUsersListDelegate{
    func didHUsersClickUser(id: String){
        delegate?.didUsersMiniClickUser(id: id)
    }
    func didHUsersClickVideo(){

    }
}
