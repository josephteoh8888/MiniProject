//
//  GridPhoto2xViewCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

//test > grid viewcell for user panel
class GridPhoto2xViewCell: UICollectionViewCell {
    static let identifier = "GridPhoto2xViewCell"
    var gifImage = SDAnimatedImageView()
    
    var descHeight: CGFloat = 60.0 //70
    let aUserPhoto = SDAnimatedImageView()
    let aUserNameText = UILabel()
    let aaText = UILabel()
    
    let bMiniBtn = UIImageView()
    let aCountText = UILabel()
    let bCountText = UILabel()
    
    weak var aDelegate : GridViewCellDelegate?
    
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
//        self.backgroundColor = .ddmDarkColor
//        self.layer.cornerRadius = 5
        
        let vConBg = UIView()
//        vConBg.backgroundColor = .ddmDarkBlack //ddmBlackDark
        self.addSubview(vConBg)
        vConBg.translatesAutoresizingMaskIntoConstraints = false
        vConBg.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        vConBg.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true //0
        vConBg.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        vConBg.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        vConBg.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true  //280
//        vConBg.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true  //280
        vConBg.layer.cornerRadius = 5
        
        let videoContainerBg = UIView()
        self.addSubview(videoContainerBg)
        videoContainerBg.translatesAutoresizingMaskIntoConstraints = false
        videoContainerBg.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        videoContainerBg.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        videoContainerBg.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -descHeight).isActive = true
        videoContainerBg.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        videoContainerBg.clipsToBounds = true
        videoContainerBg.layer.cornerRadius = 5
        videoContainerBg.backgroundColor = .ddmDarkColor
        
//        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
//        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        gifImage.contentMode = .scaleAspectFill
        gifImage.clipsToBounds = true
//        gifImage.sd_setImage(with: imageUrl)
        gifImage.layer.cornerRadius = 5 //10
//        gifImage.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.addSubview(gifImage)
        gifImage.translatesAutoresizingMaskIntoConstraints = false
        gifImage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        gifImage.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        gifImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -descHeight).isActive = true
        gifImage.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        gifImage.isUserInteractionEnabled = true
        gifImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onGifImageClicked)))
        gifImage.backgroundColor = .ddmDarkColor
        
        //*test > stat count inside video image
////        let aCountText = UILabel()
//        aCountText.textAlignment = .left
//        aCountText.textColor = .white
////        aCountText.textColor = .ddmDarkGrayColor
////        aCountText.font = .systemFont(ofSize: 12)
//        aCountText.font = .boldSystemFont(ofSize: 10)
//        aCountText.numberOfLines = 1
//        self.addSubview(aCountText)
//        aCountText.text = ""
//        aCountText.translatesAutoresizingMaskIntoConstraints = false
//        aCountText.bottomAnchor.constraint(equalTo: videoContainerBg.bottomAnchor, constant: -5).isActive = true
//        aCountText.trailingAnchor.constraint(equalTo: videoContainerBg.trailingAnchor, constant: -5).isActive = true
//        
////        let bMiniBtn = UIImageView(image: UIImage(named:"icon_love")?.withRenderingMode(.alwaysTemplate))
////        bMiniBtn.image = UIImage(named:"icon_love")?.withRenderingMode(.alwaysTemplate)
////        bMiniBtn.tintColor = .ddmDarkGrayColor
//        bMiniBtn.tintColor = .white
////        bMiniBtn.tintColor = .red
////        contentView.addSubview(bMiniBtn)
////        aCon.addSubview(bMiniBtn)
//        self.addSubview(bMiniBtn)
//        bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
//        bMiniBtn.trailingAnchor.constraint(equalTo: aCountText.leadingAnchor, constant: -2).isActive = true
//        bMiniBtn.centerYAnchor.constraint(equalTo: aCountText.centerYAnchor).isActive = true
//        bMiniBtn.heightAnchor.constraint(equalToConstant: 12).isActive = true //14
//        bMiniBtn.widthAnchor.constraint(equalToConstant: 12).isActive = true
//        //*
        
        let vConBottom = UIView()
//        pConBottom.frame = CGRect(x: 0, y: 0, width: 370, height: 40)
        self.addSubview(vConBottom)
        vConBottom.translatesAutoresizingMaskIntoConstraints = false
        vConBottom.leadingAnchor.constraint(equalTo: vConBg.leadingAnchor, constant: 0).isActive = true
        vConBottom.heightAnchor.constraint(equalToConstant: descHeight).isActive = true
        vConBottom.trailingAnchor.constraint(equalTo: vConBg.trailingAnchor, constant: 0).isActive = true
        vConBottom.bottomAnchor.constraint(equalTo: vConBg.bottomAnchor, constant: 0).isActive = true //0
        vConBottom.isUserInteractionEnabled = true
        vConBottom.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onGifImageClicked)))
        
//        let aaText = UILabel()
        aaText.textAlignment = .left
        aaText.textColor = .white
        aaText.font = .systemFont(ofSize: 13)
//        aaText.font = .boldSystemFont(ofSize: 12)
        aaText.numberOfLines = 1 //2
        vConBottom.addSubview(aaText)
        aaText.text = "-"
        aaText.translatesAutoresizingMaskIntoConstraints = false
        aaText.topAnchor.constraint(equalTo: vConBottom.topAnchor, constant: 5).isActive = true
        aaText.leadingAnchor.constraint(equalTo: vConBottom.leadingAnchor, constant: 5).isActive = true //10
        aaText.trailingAnchor.constraint(equalTo: vConBottom.trailingAnchor, constant: -5).isActive = true //-30
        
        //test 2 > just user photo at desc
        let e2UserCover = UIView()
        e2UserCover.backgroundColor = .clear
        vConBottom.addSubview(e2UserCover)
        e2UserCover.translatesAutoresizingMaskIntoConstraints = false
        e2UserCover.topAnchor.constraint(equalTo: aaText.bottomAnchor, constant: 5).isActive = true
        e2UserCover.leadingAnchor.constraint(equalTo: vConBottom.leadingAnchor, constant: 5).isActive = true
        e2UserCover.heightAnchor.constraint(equalToConstant: 24).isActive = true //20
        e2UserCover.widthAnchor.constraint(equalToConstant: 24).isActive = true //20
        e2UserCover.layer.cornerRadius = 12
        e2UserCover.layer.opacity = 1.0 //default 0.3

//        let a2UserPhoto = SDAnimatedImageView()
        vConBottom.addSubview(aUserPhoto)
        aUserPhoto.translatesAutoresizingMaskIntoConstraints = false
        aUserPhoto.widthAnchor.constraint(equalToConstant: 24).isActive = true //20
        aUserPhoto.heightAnchor.constraint(equalToConstant: 24).isActive = true
        aUserPhoto.centerXAnchor.constraint(equalTo: e2UserCover.centerXAnchor).isActive = true
        aUserPhoto.centerYAnchor.constraint(equalTo: e2UserCover.centerYAnchor).isActive = true
        aUserPhoto.contentMode = .scaleAspectFill
        aUserPhoto.layer.masksToBounds = true
        aUserPhoto.layer.cornerRadius = 12
        aUserPhoto.backgroundColor = .ddmDarkColor
        aUserPhoto.isUserInteractionEnabled = true
        aUserPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onUserImageClicked)))
        
//        let aCountText = UILabel()
        aCountText.textAlignment = .left
//        aCountText.textColor = .white
        aCountText.textColor = .ddmDarkGrayColor
//        aCountText.font = .systemFont(ofSize: 12)
        aCountText.font = .boldSystemFont(ofSize: 10)
        aCountText.numberOfLines = 1
        vConBottom.addSubview(aCountText)
        aCountText.text = ""
        aCountText.translatesAutoresizingMaskIntoConstraints = false
        aCountText.centerYAnchor.constraint(equalTo: e2UserCover.centerYAnchor, constant: 0).isActive = true
        aCountText.trailingAnchor.constraint(equalTo: vConBottom.trailingAnchor, constant: -5).isActive = true
        
//        let bMiniBtn = UIImageView(image: UIImage(named:"icon_love")?.withRenderingMode(.alwaysTemplate))
//        bMiniBtn.image = UIImage(named:"icon_love")?.withRenderingMode(.alwaysTemplate)
        bMiniBtn.tintColor = .ddmDarkGrayColor
//        bMiniBtn.tintColor = .red
//        contentView.addSubview(bMiniBtn)
//        aCon.addSubview(bMiniBtn)
        vConBottom.addSubview(bMiniBtn)
        bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        bMiniBtn.trailingAnchor.constraint(equalTo: aCountText.leadingAnchor, constant: -2).isActive = true
        bMiniBtn.centerYAnchor.constraint(equalTo: aCountText.centerYAnchor).isActive = true
        bMiniBtn.heightAnchor.constraint(equalToConstant: 12).isActive = true //16
        bMiniBtn.widthAnchor.constraint(equalToConstant: 12).isActive = true
        
//        let aUserNameText = UILabel()
        aUserNameText.textAlignment = .left
//        aUserNameText.textColor = .white
        aUserNameText.textColor = .ddmDarkGrayColor
        aUserNameText.font = .systemFont(ofSize: 12)
//        aUserNameText.font = .boldSystemFont(ofSize: 12)
        aUserNameText.numberOfLines = 1
        vConBottom.addSubview(aUserNameText)
        aUserNameText.text = "-"
        aUserNameText.translatesAutoresizingMaskIntoConstraints = false
        aUserNameText.centerYAnchor.constraint(equalTo: e2UserCover.centerYAnchor, constant: 0).isActive = true
        aUserNameText.leadingAnchor.constraint(equalTo: e2UserCover.trailingAnchor, constant: 5).isActive = true
        aUserNameText.trailingAnchor.constraint(lessThanOrEqualTo: bMiniBtn.leadingAnchor, constant: -20).isActive = true
        
        //test > time created
        bCountText.textAlignment = .left
//        bCountText.textColor = .white
        bCountText.textColor = .ddmDarkGrayColor
        bCountText.font = .systemFont(ofSize: 12)
//        bCountText.font = .boldSystemFont(ofSize: 12)
        bCountText.numberOfLines = 1
        vConBottom.addSubview(bCountText)
        bCountText.text = ""
        bCountText.translatesAutoresizingMaskIntoConstraints = false
        bCountText.centerYAnchor.constraint(equalTo: e2UserCover.centerYAnchor, constant: 0).isActive = true
        bCountText.trailingAnchor.constraint(equalTo: vConBottom.trailingAnchor, constant: -5).isActive = true
    }
    
    func hideCell() {
        gifImage.isHidden = true
    }

    func dehideCell() {
        gifImage.isHidden = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("upv gridphoto prepare for reuse")
        
        //test > clear id
        setId(id: "")
        
        let imageUrl = URL(string: "")
        gifImage.sd_setImage(with: imageUrl)
        
        let imageUrl2 = URL(string: "")
        self.aUserPhoto.sd_setImage(with: imageUrl2)
        
        gifImage.isHidden = false
        
        aaText.text = "-"
        aUserNameText.text = "-"
        
        aCountText.text = ""
        bMiniBtn.image = nil
        
        bCountText.text = ""
    }
    
    //test > set id for init
    var id = ""
    func setId(id: String) {
        self.id = id
    }
    
    func configure(data: BaseData) {

        guard let a = data as? PhotoData else {
            return
        }
        
        setId(id: a.id)
        
        let l = a.dataCode
        
        if(l == "a") {
            let u = a.userId
            asyncConfigure(data: u)
            
//            aaText.text = "#Tokyo trip"
            aaText.text = a.dataTextString
            
//            let imageUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
            let imageUrl = URL(string: a.coverPhotoString)
            self.gifImage.sd_setImage(with: imageUrl)
            
            aCountText.text = "52"
            bMiniBtn.image = UIImage(named:"icon_love")?.withRenderingMode(.alwaysTemplate) //icon_round_play
        }
        else if(l == "na") {
            
        }
        else if(l == "us") {
            
        }
    }
//    func asyncConfigure(data: PostData) {
    func asyncConfigure(data: String) {
        let id = data //u1
        DataFetchManager.shared.fetchUserData2(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("pdp api success \(id), \(l)")
                    
                    guard let self = self else {
                        return
                    }
                    
//                    if(!l.isEmpty) {
//                        let l_0 = l[0]
                        let uData = UserData()
                        uData.setData(rData: l)
                        let l_ = uData.dataCode
                        
                        if(l_ == "a") {
                            self.aUserNameText.text = uData.dataTextString
                            
                            let imageUrl2 = URL(string: uData.coverPhotoString)
                            self.aUserPhoto.sd_setImage(with: imageUrl2)
                        }
//                    }
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    
                    guard let self = self else {
                        return
                    }
                    
//                    let imageUrl = URL(string: "")
//                    self.gifImage.sd_setImage(with: imageUrl)
                    
                    self.aUserNameText.text = "-"
                    
                    let imageUrl2 = URL(string: "")
                    self.aUserPhoto.sd_setImage(with: imageUrl2)
                }
                break
            }
        }
    }
    @objc func onGifImageClicked(gesture: UITapGestureRecognizer) {
        let pFrame = gifImage.frame.origin
        let pointX = pFrame.x
        let pointY = pFrame.y
        aDelegate?.gridViewClick(id: id, vc: self, pointX: pointX, pointY: pointY, view: gifImage, mode:PhotoTypes.P_SHOT)
    }
    @objc func onUserImageClicked(gesture: UITapGestureRecognizer) {
        aDelegate?.gridViewClickUser(id: "")
    }
}
