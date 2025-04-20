//
//  DiscoverColumnViewCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

protocol DiscoverColumnViewCellDelegate : AnyObject {
    func discoverColumnDidClickSound()
    func discoverColumnDidClickUser()
    func discoverColumnDidClickPlace()
}

class HDiscoverUserSizeMColumnViewCell: UIView {
    static let identifier = "HDiscoverUserSizeMColumnViewCell"
    
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    let aPhoto = SDAnimatedImageView()
    let aHItemTitle = UILabel()
    let aHSubDesc = UILabel()
    
    weak var aDelegate : DiscoverColumnViewCellDelegate?
    
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
        //move to redrawUI()
    }
    
    func redrawUI() {

        let pConBg = UIView()
//        pConBg.backgroundColor = .ddmDarkColor //.ddmDarkColor
//        pConBg.backgroundColor = .ddmBlackDark
        self.addSubview(pConBg)
        pConBg.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        pConBg.translatesAutoresizingMaskIntoConstraints = false
        pConBg.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        pConBg.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true //0
        pConBg.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true  //280
        pConBg.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true  //280
//        pConBg.layer.cornerRadius = 10
        pConBg.isUserInteractionEnabled = true
        pConBg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onRectClicked)))
        
//        let aPhoto = SDAnimatedImageView()
//        aHLightRect1.addSubview(aPhoto)
        pConBg.addSubview(aPhoto)
        aPhoto.translatesAutoresizingMaskIntoConstraints = false
        aPhoto.widthAnchor.constraint(equalToConstant: viewHeight).isActive = true //ori: 80
        aPhoto.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        aPhoto.leadingAnchor.constraint(equalTo: pConBg.leadingAnchor, constant: 10).isActive = true
        aPhoto.topAnchor.constraint(equalTo: pConBg.topAnchor, constant: 0).isActive = true
//        let imageUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
        aPhoto.contentMode = .scaleAspectFill
        aPhoto.layer.masksToBounds = true
        aPhoto.layer.cornerRadius = viewHeight/2
//        aPhoto.sd_setImage(with: imageUrl)
        aPhoto.backgroundColor = .ddmDarkColor
        
//        let aHItemTitle = UILabel()
        aHItemTitle.textAlignment = .left
        aHItemTitle.textColor = .white
        aHItemTitle.font = .boldSystemFont(ofSize: 13) //13
//        aHLightRect1.addSubview(aHItemTitle)
        pConBg.addSubview(aHItemTitle)
        aHItemTitle.translatesAutoresizingMaskIntoConstraints = false
        aHItemTitle.topAnchor.constraint(equalTo: aPhoto.topAnchor, constant: 10).isActive = true //5
        aHItemTitle.leadingAnchor.constraint(equalTo: aPhoto.trailingAnchor, constant: 10).isActive = true
        aHItemTitle.trailingAnchor.constraint(equalTo: pConBg.trailingAnchor, constant: -10).isActive = true
        aHItemTitle.text = "-"

//        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .left
        aHSubDesc.textColor = .ddmDarkGrayColor
        aHSubDesc.font = .systemFont(ofSize: 11)
//        aHLightRect1.addSubview(aHSubDesc)
        pConBg.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.topAnchor.constraint(equalTo: aHItemTitle.bottomAnchor, constant: 0).isActive = true //20
        aHSubDesc.leadingAnchor.constraint(equalTo: aPhoto.trailingAnchor, constant: 10).isActive = true
        aHSubDesc.trailingAnchor.constraint(equalTo: pConBg.trailingAnchor, constant: -10).isActive = true
        aHSubDesc.text = "-"
    }

    func configure(data: String) {
        asyncConfigure(data: "")
    }

    //*test > async load photo
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

                    let imageUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
                    self.aPhoto.sd_setImage(with: imageUrl)
                    
                    self.aHItemTitle.text = "Vicky Chia"
                    self.aHSubDesc.text = "@vickych"
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    
                    guard let self = self else {
                        return
                    }
                    let imageUrl = URL(string: "")
                    self.aPhoto.sd_setImage(with: imageUrl)
                    
                    self.aHItemTitle.text = "-"
                    self.aHSubDesc.text = "-"
                }
                break
            }
        }
    }
    
    @objc func onRectClicked(gesture: UITapGestureRecognizer) {
        self.aDelegate?.discoverColumnDidClickUser()
    }
}

class HDiscoverSoundSizeMColumnViewCell: UIView {
    static let identifier = "HDiscoverSoundSizeMColumnViewCell"
    
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    let aPhoto = SDAnimatedImageView()
    let aHItemTitle = UILabel()
    let aHSubDesc = UILabel()
    
    weak var aDelegate : DiscoverColumnViewCellDelegate?
    
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
        //move to redrawUI()
    }
    
    func redrawUI() {

        let pConBg = UIView()
//        pConBg.backgroundColor = .ddmDarkColor //.ddmDarkColor
//        pConBg.backgroundColor = .ddmBlackDark
        self.addSubview(pConBg)
        pConBg.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        pConBg.translatesAutoresizingMaskIntoConstraints = false
        pConBg.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        pConBg.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true //0
        pConBg.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true  //280
        pConBg.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true  //280
//        pConBg.layer.cornerRadius = 10
        pConBg.isUserInteractionEnabled = true
        pConBg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onRectClicked)))
        
//        let aPhoto = SDAnimatedImageView()
//        aHLightRect1.addSubview(aPhoto)
        pConBg.addSubview(aPhoto)
        aPhoto.translatesAutoresizingMaskIntoConstraints = false
        aPhoto.widthAnchor.constraint(equalToConstant: viewHeight).isActive = true //ori: 80
        aPhoto.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        aPhoto.leadingAnchor.constraint(equalTo: pConBg.leadingAnchor, constant: 10).isActive = true
        aPhoto.topAnchor.constraint(equalTo: pConBg.topAnchor, constant: 0).isActive = true
//        let imageUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
        aPhoto.contentMode = .scaleAspectFill
        aPhoto.layer.masksToBounds = true
        aPhoto.layer.cornerRadius = 5
//        aPhoto.sd_setImage(with: imageUrl)
        aPhoto.backgroundColor = .ddmDarkColor
        
//        let aHItemTitle = UILabel()
        aHItemTitle.textAlignment = .left
        aHItemTitle.textColor = .white
        aHItemTitle.font = .boldSystemFont(ofSize: 13) //13
//        aHLightRect1.addSubview(aHItemTitle)
        pConBg.addSubview(aHItemTitle)
        aHItemTitle.translatesAutoresizingMaskIntoConstraints = false
        aHItemTitle.topAnchor.constraint(equalTo: aPhoto.topAnchor, constant: 10).isActive = true //5
        aHItemTitle.leadingAnchor.constraint(equalTo: aPhoto.trailingAnchor, constant: 10).isActive = true
        aHItemTitle.trailingAnchor.constraint(equalTo: pConBg.trailingAnchor, constant: -10).isActive = true
        aHItemTitle.text = "-"

//        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .left
        aHSubDesc.textColor = .ddmDarkGrayColor
        aHSubDesc.font = .systemFont(ofSize: 11)
//        aHLightRect1.addSubview(aHSubDesc)
        pConBg.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.topAnchor.constraint(equalTo: aHItemTitle.bottomAnchor, constant: 0).isActive = true //20
        aHSubDesc.leadingAnchor.constraint(equalTo: aPhoto.trailingAnchor, constant: 10).isActive = true
        aHSubDesc.trailingAnchor.constraint(equalTo: pConBg.trailingAnchor, constant: -10).isActive = true
        aHSubDesc.text = "-"
    }

    func configure(data: String) {
        asyncConfigure(data: "")
    }

    //*test > async load photo
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

                    let imageUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
                    self.aPhoto.sd_setImage(with: imageUrl)
                    
                    self.aHItemTitle.text = "反對無效"
                    self.aHSubDesc.text = "MC 張天賦"
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    
                    guard let self = self else {
                        return
                    }
                    let imageUrl = URL(string: "")
                    self.aPhoto.sd_setImage(with: imageUrl)
                    
                    self.aHItemTitle.text = "-"
                    self.aHSubDesc.text = "-"
                }
                break
            }
        }
    }
    
    @objc func onRectClicked(gesture: UITapGestureRecognizer) {
        self.aDelegate?.discoverColumnDidClickSound()
    }
}

class HDiscoverPlaceSizeMColumnViewCell: UIView {
    static let identifier = "HDiscoverPlaceSizeMColumnViewCell"
    
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    let aPhoto = SDAnimatedImageView()
    let aHItemTitle = UILabel()
    let aHSubDesc = UILabel()
    
    weak var aDelegate : DiscoverColumnViewCellDelegate?
    
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
        //move to redrawUI()
    }
    
    func redrawUI() {

        let pConBg = UIView()
//        pConBg.backgroundColor = .ddmDarkColor //.ddmDarkColor
//        pConBg.backgroundColor = .ddmBlackDark
        self.addSubview(pConBg)
        pConBg.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        pConBg.translatesAutoresizingMaskIntoConstraints = false
        pConBg.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        pConBg.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true //0
        pConBg.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true  //280
        pConBg.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true  //280
//        pConBg.layer.cornerRadius = 10
        pConBg.isUserInteractionEnabled = true
        pConBg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onRectClicked)))
        
//        let aPhoto = SDAnimatedImageView()
//        aHLightRect1.addSubview(aPhoto)
        pConBg.addSubview(aPhoto)
        aPhoto.translatesAutoresizingMaskIntoConstraints = false
        aPhoto.widthAnchor.constraint(equalToConstant: viewHeight).isActive = true //ori: 80
        aPhoto.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        aPhoto.leadingAnchor.constraint(equalTo: pConBg.leadingAnchor, constant: 10).isActive = true
        aPhoto.topAnchor.constraint(equalTo: pConBg.topAnchor, constant: 0).isActive = true
//        let imageUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
        aPhoto.contentMode = .scaleAspectFill
        aPhoto.layer.masksToBounds = true
        aPhoto.layer.cornerRadius = 5
//        aPhoto.sd_setImage(with: imageUrl)
        aPhoto.backgroundColor = .ddmDarkColor
        
//        let aHItemTitle = UILabel()
        aHItemTitle.textAlignment = .left
        aHItemTitle.textColor = .white
        aHItemTitle.font = .boldSystemFont(ofSize: 13) //13
//        aHLightRect1.addSubview(aHItemTitle)
        pConBg.addSubview(aHItemTitle)
        aHItemTitle.translatesAutoresizingMaskIntoConstraints = false
        aHItemTitle.topAnchor.constraint(equalTo: aPhoto.topAnchor, constant: 10).isActive = true //5
        aHItemTitle.leadingAnchor.constraint(equalTo: aPhoto.trailingAnchor, constant: 10).isActive = true
        aHItemTitle.trailingAnchor.constraint(equalTo: pConBg.trailingAnchor, constant: -10).isActive = true
        aHItemTitle.text = "-"

//        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .left
        aHSubDesc.textColor = .ddmDarkGrayColor
        aHSubDesc.font = .systemFont(ofSize: 11)
//        aHLightRect1.addSubview(aHSubDesc)
        pConBg.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.topAnchor.constraint(equalTo: aHItemTitle.bottomAnchor, constant: 0).isActive = true //20
        aHSubDesc.leadingAnchor.constraint(equalTo: aPhoto.trailingAnchor, constant: 10).isActive = true
        aHSubDesc.trailingAnchor.constraint(equalTo: pConBg.trailingAnchor, constant: -10).isActive = true
        aHSubDesc.text = "-"
    }

    func configure(data: String) {
        asyncConfigure(data: "")
    }

    //*test > async load photo
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

                    let imageUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
                    self.aPhoto.sd_setImage(with: imageUrl)
                    
                    self.aHItemTitle.text = "KL Tower"
                    self.aHSubDesc.text = "DBKL"
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    
                    guard let self = self else {
                        return
                    }
                    let imageUrl = URL(string: "")
                    self.aPhoto.sd_setImage(with: imageUrl)
                    
                    self.aHItemTitle.text = "-"
                    self.aHSubDesc.text = "-"
                }
                break
            }
        }
    }
    
    @objc func onRectClicked(gesture: UITapGestureRecognizer) {
        self.aDelegate?.discoverColumnDidClickPlace()
    }
}
