//
//  HSingleLocationViewCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 14/07/2024.
//

import Foundation
import UIKit
import SDWebImage

protocol HSingleLocationDelegate : AnyObject {
    func didClickSinglePlaceLocation()
}
class HSingleLocationViewCell: UICollectionViewCell {
    static let identifier = "HSingleLocationViewCell"
//    var gifImage = SDAnimatedImageView()
    
    let rGridBG = SDAnimatedImageView()
    let aHSubDesc = UILabel()
    let aHSubDesc2 = UILabel()
    
    weak var aDelegate : HSingleLocationDelegate?
    
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
        aResult.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true //20
        aResult.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        aResult.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        aResult.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        aResult.layer.cornerRadius = 10
//        aResult.layer.opacity = 0.3 //0.3
        aResult.isUserInteractionEnabled = true
        aResult.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPlaceLocationClicked)))
        ////////////////////
        ///

//        let rGridBG = SDAnimatedImageView()
//        aHLightSection.addSubview(rGridBG)
        contentView.addSubview(rGridBG)
        rGridBG.translatesAutoresizingMaskIntoConstraints = false
        rGridBG.leadingAnchor.constraint(equalTo: aResult.leadingAnchor, constant: 10).isActive = true
//        rGridBG.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        rGridBG.heightAnchor.constraint(equalToConstant: 40).isActive = true //30
        rGridBG.widthAnchor.constraint(equalToConstant: 40).isActive = true
        rGridBG.topAnchor.constraint(equalTo: aResult.topAnchor, constant: 10).isActive = true //20
        rGridBG.layer.cornerRadius = 5 //20
        rGridBG.contentMode = .scaleAspectFill
        rGridBG.layer.masksToBounds = true
        rGridBG.layer.cornerRadius = 5
//        rGridBG.sd_setImage(with: imageUrl)
        rGridBG.bottomAnchor.constraint(equalTo: aResult.bottomAnchor, constant: -10).isActive = true
        rGridBG.backgroundColor = .ddmDarkColor
        
//        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .left
        aHSubDesc.textColor = .white //white
//        aHSubDesc.font = .boldSystemFont(ofSize: 13)
        aHSubDesc.font = .systemFont(ofSize: 13)
//        aHLightSection.addSubview(aHSubDesc)
        contentView.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.topAnchor.constraint(equalTo: rGridBG.topAnchor, constant: 5).isActive = true //0
//        aHSubDesc.centerYAnchor.constraint(equalTo: rGridBG.centerYAnchor, constant: 0).isActive = true //20
        aHSubDesc.leadingAnchor.constraint(equalTo: rGridBG.trailingAnchor, constant: 10).isActive = true
        aHSubDesc.text = "-"
        
//        let aHSubDesc2 = UILabel()
        aHSubDesc2.textAlignment = .left
        aHSubDesc2.textColor = .ddmDarkGrayColor
        aHSubDesc2.font = .systemFont(ofSize: 12) //11
//        aHLightSection.addSubview(aHSubDesc2)
        contentView.addSubview(aHSubDesc2)
        aHSubDesc2.translatesAutoresizingMaskIntoConstraints = false
//        aHSubDesc2.centerYAnchor.constraint(equalTo: aHSubDesc.centerYAnchor).isActive = true
        aHSubDesc2.topAnchor.constraint(equalTo: aHSubDesc.bottomAnchor, constant: 0).isActive = true //5
        aHSubDesc2.leadingAnchor.constraint(equalTo: rGridBG.trailingAnchor, constant: 10).isActive = true
//                aHSubDesc2.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
//        aHSubDesc2.text = "87k saves"
        aHSubDesc2.text = "-"
//        aHSubDesc2.layer.opacity = 0.4
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        print("sfvideo prepare for reuse")
        
        aHSubDesc.text = "-"
        aHSubDesc2.text = "-"
        
        let imageUrl = URL(string: "")
        rGridBG.sd_setImage(with: imageUrl)
    }
    
    func configure(data: String) {
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

                    self.aHSubDesc.text = "DinoDreamTgX"
                    self.aHSubDesc2.text = "United States"
                    
                    let imageUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
                    self.rGridBG.sd_setImage(with: imageUrl)
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    
                    guard let self = self else {
                        return
                    }
                    
                    self.aHSubDesc.text = "-"
                    self.aHSubDesc2.text = "-"
                    
                    let imageUrl = URL(string: "")
                    self.rGridBG.sd_setImage(with: imageUrl)
                    
                }
                break
            }
        }
    }
    //*
    
    @objc func onPlaceLocationClicked(gesture: UITapGestureRecognizer) {
        aDelegate?.didClickSinglePlaceLocation()
    }
}
