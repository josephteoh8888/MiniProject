//
//  GridVideoViewCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

protocol GridViewCellDelegate : AnyObject {
    func gridViewClick(vc: UICollectionViewCell, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String)
    func gridViewClickUser()
}
//test > grid viewcell for user panel
class GridVideoViewCell: UICollectionViewCell {
    static let identifier = "GridVideoViewCell"
    var gifImage = SDAnimatedImageView()
    
    let aCountText = UILabel()
    let bMiniBtn = UIImageView()
    
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
        
//        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
        gifImage.contentMode = .scaleAspectFill
        gifImage.clipsToBounds = true
//        gifImage.sd_setImage(with: imageUrl)
        gifImage.layer.cornerRadius = 5
        contentView.addSubview(gifImage)
        gifImage.translatesAutoresizingMaskIntoConstraints = false
        gifImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        gifImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        gifImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        gifImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        gifImage.isUserInteractionEnabled = true
        gifImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPhotoClicked)))
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
        bMiniBtn.trailingAnchor.constraint(equalTo: aCountText.leadingAnchor, constant: 0).isActive = true //-2
        bMiniBtn.centerYAnchor.constraint(equalTo: aCountText.centerYAnchor).isActive = true
        bMiniBtn.heightAnchor.constraint(equalToConstant: 16).isActive = true //14
        bMiniBtn.widthAnchor.constraint(equalToConstant: 16).isActive = true
    }
    
    func hideCell() {
        gifImage.isHidden = true
    }

    func dehideCell() {
        gifImage.isHidden = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("upv gridvideo prepare for reuse")
        
        let imageUrl = URL(string: "")
        gifImage.sd_setImage(with: imageUrl)
        
        gifImage.isHidden = false
        
        aCountText.text = ""
        bMiniBtn.image = nil
    }
    
    func configure(data: PostData) {
        
//        aCountText.text = "395" //3.9m
//        bMiniBtn.image = UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate) //icon_round_play
        let l = data.dataType
//        let s = data.dataTextString
        
        if(l == "a") {
            asyncConfigure(data: data)
            
            aCountText.text = "395"
            bMiniBtn.image = UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate)
        } 
        else if(l == "na") {
            
        }
        else if(l == "us") {
            
        }
//        else if(l == "b") {
//            aCountText.text = "7.8m"
//            bMiniBtn.image = UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate)
//        } else if(l == "c") {
//            aCountText.text = "34k"
//            bMiniBtn.image = UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate)
//        } else if(l == "d") {
//            aCountText.text = "981"
//            bMiniBtn.image = UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate)
//        }
    }
    
    func asyncConfigure(data: PostData) {
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

                    let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
                    self.gifImage.sd_setImage(with: imageUrl)
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    
                    guard let self = self else {
                        return
                    }
                    
                    let imageUrl = URL(string: "")
                    self.gifImage.sd_setImage(with: imageUrl)
                    
                }
                break
            }
        }
    }
    
    @objc func onPhotoClicked(gesture: UITapGestureRecognizer) {
        let pFrame = gifImage.frame.origin
        let pointX = pFrame.x
        let pointY = pFrame.y
        aDelegate?.gridViewClick(vc: self, pointX: pointX, pointY: pointY, view: gifImage, mode:VideoTypes.V_LOOP)
    }
    
}
