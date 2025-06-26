//
//  GridPhotoViewCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

//test > grid viewcell for user panel
class GridPhotoViewCell: UICollectionViewCell {
    static let identifier = "GridPhotoViewCell"
    var gifImage = SDAnimatedImageView()
    
    let aCountText = UILabel()
    let bMiniBtn = UIImageView()
    let cMiniBtn = UIImageView()
    
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
        
        self.backgroundColor = .ddmDarkColor
        self.layer.cornerRadius = 5
        
//        let imageUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
        gifImage.contentMode = .scaleAspectFill
        gifImage.clipsToBounds = true
//        gifImage.sd_setImage(with: imageUrl)
//        gifImage.layer.cornerRadius = 10
        gifImage.layer.cornerRadius = 5
        contentView.addSubview(gifImage)
        gifImage.translatesAutoresizingMaskIntoConstraints = false
        gifImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        gifImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        gifImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        gifImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        gifImage.isUserInteractionEnabled = true
        gifImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onGifImageClicked)))
        gifImage.backgroundColor = .ddmDarkColor
        
//        let aCountText = UILabel()
        aCountText.textAlignment = .left
        aCountText.textColor = .white
//        aCountText.textColor = .ddmDarkGrayColor
//        aCountText.font = .systemFont(ofSize: 11) //12
        aCountText.font = .boldSystemFont(ofSize: 10)
        aCountText.numberOfLines = 1
        contentView.addSubview(aCountText)
        aCountText.text = ""
        aCountText.translatesAutoresizingMaskIntoConstraints = false
        aCountText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        aCountText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        
//        let bMiniBtn = UIImageView(image: UIImage(named:"icon_love")?.withRenderingMode(.alwaysTemplate))
//        bMiniBtn.image = UIImage(named:"icon_love")?.withRenderingMode(.alwaysTemplate)
        bMiniBtn.tintColor = .white
//        bMiniBtn.tintColor = .ddmDarkGrayColor
//        bMiniBtn.tintColor = .red
//        contentView.addSubview(bMiniBtn)
//        aCon.addSubview(bMiniBtn)
        contentView.addSubview(bMiniBtn)
        bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        bMiniBtn.trailingAnchor.constraint(equalTo: aCountText.leadingAnchor, constant: -2).isActive = true
        bMiniBtn.centerYAnchor.constraint(equalTo: aCountText.centerYAnchor).isActive = true
        bMiniBtn.heightAnchor.constraint(equalToConstant: 12).isActive = true //14
        bMiniBtn.widthAnchor.constraint(equalToConstant: 12).isActive = true
        
//        let cMiniBtn = UIImageView(image: UIImage(named:"icon_round_folder_close")?.withRenderingMode(.alwaysTemplate))
//        cMiniBtn.image = UIImage(named:"icon_love")?.withRenderingMode(.alwaysTemplate)
        cMiniBtn.tintColor = .white
//        bMiniBtn.tintColor = .ddmDarkGrayColor
//        bMiniBtn.tintColor = .red
//        contentView.addSubview(bMiniBtn)
//        aCon.addSubview(bMiniBtn)
        contentView.addSubview(cMiniBtn)
        cMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        cMiniBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true //-2
        cMiniBtn.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        cMiniBtn.heightAnchor.constraint(equalToConstant: 14).isActive = true //14
        cMiniBtn.widthAnchor.constraint(equalToConstant: 14).isActive = true
    }
    
    func hideCell() {
//        gifImage.isHidden = true
        
        //test 2 > try opacity
        self.layer.opacity = 0.1
    }

    func dehideCell() {
//        gifImage.isHidden = false
        
        //test 2 > try opacity
        self.layer.opacity = 1.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("upv gridphoto prepare for reuse")
        
        //test > clear id
        setId(id: "")
        
        let imageUrl = URL(string: "")
        gifImage.sd_setImage(with: imageUrl)
        
        gifImage.isHidden = false
        
        aCountText.text = ""
        bMiniBtn.image = nil
        
        cMiniBtn.image = nil
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
//            asyncConfigure(data: "")
            
            let imageUrl = URL(string: a.coverPhotoString)
            self.gifImage.sd_setImage(with: imageUrl)
            
            aCountText.text = "54"
            bMiniBtn.image = UIImage(named:"icon_love")?.withRenderingMode(.alwaysTemplate)
        } 
        else if(l == "na") {
            
        }
        else if(l == "us") {
            
        }
    }
//    func asyncConfigure(data: PostData) {
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

//                    let imageUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
//                    self.gifImage.sd_setImage(with: imageUrl)
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    
                    guard let self = self else {
                        return
                    }
                    
//                    let imageUrl = URL(string: "")
//                    self.gifImage.sd_setImage(with: imageUrl)
                    
                }
                break
            }
        }
    }
    @objc func onGifImageClicked(gesture: UITapGestureRecognizer) {
        let pFrame = gifImage.frame.origin
//        let pointX = pFrame.x
//        let pointY = pFrame.y
        //test > new computation
        let pointX = pFrame.x + gifImage.frame.width/2
        let pointY = pFrame.y + gifImage.frame.height/2
        aDelegate?.gridViewClick(id: id, vc: self, pointX: pointX, pointY: pointY, view: gifImage, mode:PhotoTypes.P_SHOT)
    }
}
