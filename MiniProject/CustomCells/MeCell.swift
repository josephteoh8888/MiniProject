//
//  MeCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

protocol MeCellDelegate : AnyObject {
    
    func didMeCellClickUser()
    func didMeCellClickBase()
    func didMeCellClickEditProfile()
    func didMeCellClickAccountSetting()
    func didMeCellClickFollow()
    func didMeCellClickHistory()
    func didMeCellClickLike()
    func didMeCellClickBookmark()
    func didMeCellClickLocations()
    func didMeCellClickComments()
    func didMeCellClickPosts()
    func didMeCellClickPhotos()
    func didMeCellClickVideos()
    func didMeCellClickSignout()
}

class MeCell: UIView {
    weak var aDelegate : MeCellDelegate?
}

class MultiPhotosMeCell: MeCell {
    
    let aHLightRect1 = UIView()
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    let aScroll1 = UIScrollView()
    let bSpinner = SpinLoader()
    
    let errorText = UILabel()
    let errorRefreshBtn = UIView()
    
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
        
        self.addSubview(aHLightRect1)
        aHLightRect1.translatesAutoresizingMaskIntoConstraints = false
        aHLightRect1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        aHLightRect1.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //5
        aHLightRect1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        aHLightRect1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        let aHLightRectBG = UIView()
        aHLightRectBG.backgroundColor = .ddmDarkBlack //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.1 //0.2
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        aHLightRectBG.isUserInteractionEnabled = true
        aHLightRectBG.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onRectClicked)))
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "Shots"
//        aHLightTitle.isHidden = true
        
        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .ddmDarkGrayColor
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
//        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightTitle.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        rArrowBtn.layer.opacity = 0.5
        
//        let scrollViewWidth = viewWidth - 20.0*2
//        let aScroll1 = UIView()
        aHLightRect1.addSubview(aScroll1)
        aScroll1.translatesAutoresizingMaskIntoConstraints = false
//        aScroll1.widthAnchor.constraint(equalToConstant: scrollViewWidth).isActive = true //ori: 80
        aScroll1.heightAnchor.constraint(equalToConstant: 70).isActive = true //60
        aScroll1.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aScroll1.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        aScroll1.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true //20
        aScroll1.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        aScroll1.showsHorizontalScrollIndicator = false
        aScroll1.showsVerticalScrollIndicator = false
        
        bSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        self.addSubview(bSpinner)
        bSpinner.translatesAutoresizingMaskIntoConstraints = false
        bSpinner.centerYAnchor.constraint(equalTo: aScroll1.centerYAnchor, constant: 0).isActive = true
//        bSpinner.topAnchor.constraint(equalTo: footer.topAnchor, constant: 20).isActive = true
        bSpinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        bSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        bSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        //test > error handling
        errorText.textAlignment = .center //left
        errorText.textColor = .white
        errorText.font = .systemFont(ofSize: 13)
        self.addSubview(errorText)
        errorText.clipsToBounds = true
        errorText.translatesAutoresizingMaskIntoConstraints = false
//        errorText.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -20).isActive = true
        errorText.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 20).isActive = true //test
        errorText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        errorText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        errorText.text = ""
        errorText.numberOfLines = 0
        errorText.isHidden = true
        
//        errorRefreshBtn.backgroundColor = .ddmDarkColor //test to remove color
        self.addSubview(errorRefreshBtn)
        errorRefreshBtn.translatesAutoresizingMaskIntoConstraints = false
        errorRefreshBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
        errorRefreshBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        errorRefreshBtn.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        errorRefreshBtn.topAnchor.constraint(equalTo: errorText.bottomAnchor, constant: 0).isActive = true
        errorRefreshBtn.layer.cornerRadius = 20
        errorRefreshBtn.isUserInteractionEnabled = true
        errorRefreshBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onErrorRefreshClicked)))
        errorRefreshBtn.isHidden = true
        
        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_refresh")?.withRenderingMode(.alwaysTemplate))
//        bMiniBtn.tintColor = .black
        bMiniBtn.tintColor = .white
        errorRefreshBtn.addSubview(bMiniBtn)
        bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        bMiniBtn.centerXAnchor.constraint(equalTo: errorRefreshBtn.centerXAnchor).isActive = true
        bMiniBtn.centerYAnchor.constraint(equalTo: errorRefreshBtn.centerYAnchor).isActive = true
        bMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true //26
        bMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        
    }
    
    //test > initialization state
    var isInitialized = false
    func initialize() {
        if(!isInitialized) {
            redrawUI()
            
            bSpinner.startAnimating()
            asyncConfigure(data: "")
        }

        isInitialized = true
    }
    
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

                    self.bSpinner.stopAnimating()
                    self.configure(data: "a")
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    
                    guard let self = self else {
                        return
                    }
                    
                    self.bSpinner.stopAnimating()
                    
                    //error handling e.g. refetch button
                    self.errorText.text = "Unable to load. Retry."
                    self.errorText.isHidden = false
                    self.errorRefreshBtn.isHidden = false
                }
                break
            }
        }
    }
    
    var vDataList = [String]()
    var aHLightViewArray = [UIView]()
    func configure(data: String) {
        let scrollViewWidth = 70.0
        let scrollViewHeight = 70.0
        
        if(data == "a") {
            vDataList.append("p")
            vDataList.append("p")
            vDataList.append("p")

            for _ in vDataList {
            
                let hd = SDAnimatedImageView()
                aScroll1.addSubview(hd)
                hd.translatesAutoresizingMaskIntoConstraints = false
                hd.widthAnchor.constraint(equalToConstant: scrollViewWidth).isActive = true //180
                hd.heightAnchor.constraint(equalToConstant: scrollViewHeight).isActive = true //280
                hd.topAnchor.constraint(equalTo: aScroll1.topAnchor, constant: 0).isActive = true
                if(aHLightViewArray.isEmpty) {
                    hd.leadingAnchor.constraint(equalTo: aScroll1.leadingAnchor, constant: 10).isActive = true
                } else {
                    let lastArrayE = aHLightViewArray[aHLightViewArray.count - 1]
                    hd.leadingAnchor.constraint(equalTo: lastArrayE.trailingAnchor, constant: 4).isActive = true
                }
                aHLightViewArray.append(hd)
                hd.contentMode = .scaleAspectFill
                hd.layer.masksToBounds = true
                hd.layer.cornerRadius = 3 //5
                
                let imageUrl2 = URL(string: "https://i3.ytimg.com/vi/2mcGhpbWlyg/maxresdefault.jpg")
                hd.sd_setImage(with: imageUrl2) //temp disable picture
            }
            
            let dataCount = vDataList.count
            
            let totalWidth = CGFloat(dataCount) * scrollViewWidth
            aScroll1.contentSize = CGSize(width: totalWidth, height: scrollViewHeight) //800, 280
        }
    }
    
    @objc func onRectClicked(gesture: UITapGestureRecognizer) {
        aDelegate?.didMeCellClickPhotos()
    }
    
    @objc func onErrorRefreshClicked(gesture: UITapGestureRecognizer) {
        self.errorText.isHidden = true
        self.errorRefreshBtn.isHidden = true
        
        bSpinner.startAnimating()
        asyncConfigure(data: "")
    }
}

class MultiLoopsMeCell: MeCell {
    
    let aHLightRect1 = UIView()
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    let aScroll1 = UIScrollView()
    let bSpinner = SpinLoader()
    
    let errorText = UILabel()
    let errorRefreshBtn = UIView()
    
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
        
        self.addSubview(aHLightRect1)
        aHLightRect1.translatesAutoresizingMaskIntoConstraints = false
        aHLightRect1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        aHLightRect1.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //5
        aHLightRect1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        aHLightRect1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        let aHLightRectBG = UIView()
        aHLightRectBG.backgroundColor = .ddmDarkBlack //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.1 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        aHLightRectBG.isUserInteractionEnabled = true
        aHLightRectBG.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onRectClicked)))
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "Loops"
//        aHLightTitle.isHidden = true
        
        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .ddmDarkGrayColor
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
//        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightTitle.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        rArrowBtn.layer.opacity = 0.5
        
//        let scrollViewWidth = viewWidth - 20.0*2
//        let aScroll1 = UIView()
        aHLightRect1.addSubview(aScroll1)
        aScroll1.translatesAutoresizingMaskIntoConstraints = false
//        aScroll1.widthAnchor.constraint(equalToConstant: scrollViewWidth).isActive = true //ori: 80
        aScroll1.heightAnchor.constraint(equalToConstant: 90).isActive = true //60
        aScroll1.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aScroll1.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        aScroll1.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true //20
        aScroll1.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        aScroll1.showsHorizontalScrollIndicator = false
        aScroll1.showsVerticalScrollIndicator = false
        
        bSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        self.addSubview(bSpinner)
        bSpinner.translatesAutoresizingMaskIntoConstraints = false
        bSpinner.centerYAnchor.constraint(equalTo: aScroll1.centerYAnchor, constant: 0).isActive = true
//        bSpinner.topAnchor.constraint(equalTo: footer.topAnchor, constant: 20).isActive = true
        bSpinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        bSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        bSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        //test > error handling
        errorText.textAlignment = .center //left
        errorText.textColor = .white
        errorText.font = .systemFont(ofSize: 13)
        self.addSubview(errorText)
        errorText.clipsToBounds = true
        errorText.translatesAutoresizingMaskIntoConstraints = false
//        errorText.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -20).isActive = true
        errorText.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 20).isActive = true //test
        errorText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        errorText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        errorText.text = ""
        errorText.numberOfLines = 0
        errorText.isHidden = true
        
//        errorRefreshBtn.backgroundColor = .ddmDarkColor //test to remove color
        self.addSubview(errorRefreshBtn)
        errorRefreshBtn.translatesAutoresizingMaskIntoConstraints = false
        errorRefreshBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
        errorRefreshBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        errorRefreshBtn.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        errorRefreshBtn.topAnchor.constraint(equalTo: errorText.bottomAnchor, constant: 0).isActive = true
        errorRefreshBtn.layer.cornerRadius = 20
        errorRefreshBtn.isUserInteractionEnabled = true
        errorRefreshBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onErrorRefreshClicked)))
        errorRefreshBtn.isHidden = true
        
        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_refresh")?.withRenderingMode(.alwaysTemplate))
//        bMiniBtn.tintColor = .black
        bMiniBtn.tintColor = .white
        errorRefreshBtn.addSubview(bMiniBtn)
        bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        bMiniBtn.centerXAnchor.constraint(equalTo: errorRefreshBtn.centerXAnchor).isActive = true
        bMiniBtn.centerYAnchor.constraint(equalTo: errorRefreshBtn.centerYAnchor).isActive = true
        bMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true //26
        bMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true

    }
    
    //test > initialization state
    var isInitialized = false
    func initialize() {
        if(!isInitialized) {
            redrawUI()
            
            bSpinner.startAnimating()
            asyncConfigure(data: "")
        }

        isInitialized = true
    }
    
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

                    self.bSpinner.stopAnimating()
                    self.configure(data: "a")
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    
                    guard let self = self else {
                        return
                    }
                    self.bSpinner.stopAnimating()
                    
                    //error handling e.g. refetch button
                    self.errorText.text = "Unable to load. Retry."
                    self.errorText.isHidden = false
                    self.errorRefreshBtn.isHidden = false
                }
                break
            }
        }
    }
    
    var vDataList = [String]()
    var aHLightViewArray = [UIView]()
    func configure(data: String) {
        let scrollViewWidth = 70.0
        let scrollViewHeight = 90.0
        
        if(data == "a") {
            vDataList.append("p")
            vDataList.append("p")
            vDataList.append("p")

            for _ in vDataList {
            
                let hd = SDAnimatedImageView()
                aScroll1.addSubview(hd)
                hd.translatesAutoresizingMaskIntoConstraints = false
                hd.widthAnchor.constraint(equalToConstant: scrollViewWidth).isActive = true //180
                hd.heightAnchor.constraint(equalToConstant: scrollViewHeight).isActive = true //280
                hd.topAnchor.constraint(equalTo: aScroll1.topAnchor, constant: 0).isActive = true
                if(aHLightViewArray.isEmpty) {
                    hd.leadingAnchor.constraint(equalTo: aScroll1.leadingAnchor, constant: 10).isActive = true
                } else {
                    let lastArrayE = aHLightViewArray[aHLightViewArray.count - 1]
                    hd.leadingAnchor.constraint(equalTo: lastArrayE.trailingAnchor, constant: 4).isActive = true
                }
                aHLightViewArray.append(hd)
                hd.contentMode = .scaleAspectFill
                hd.layer.masksToBounds = true
                hd.layer.cornerRadius = 3 //5
                
                let imageUrl2 = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
                hd.sd_setImage(with: imageUrl2) //temp disable picture
            }
            
            let dataCount = vDataList.count
            
            let totalWidth = CGFloat(dataCount) * scrollViewWidth
            aScroll1.contentSize = CGSize(width: totalWidth, height: scrollViewHeight) //800, 280
        }
    }
    
    @objc func onRectClicked(gesture: UITapGestureRecognizer) {
        aDelegate?.didMeCellClickVideos()
    }
    
    @objc func onErrorRefreshClicked(gesture: UITapGestureRecognizer) {
        self.errorText.isHidden = true
        self.errorRefreshBtn.isHidden = true
        
        bSpinner.startAnimating()
        asyncConfigure(data: "")
    }
}

class MultiPostsMeCell: MeCell {
    
    let aHLightRect1 = UIView()
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    let aScroll1 = UIView()
    let aHItem1ATitle = UILabel()
    let aGrid = UIView()
    let gifImage = SDAnimatedImageView()
    
    let bSpinner = SpinLoader()
    
    let errorText = UILabel()
    let errorRefreshBtn = UIView()
    
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
        
        self.addSubview(aHLightRect1)
        aHLightRect1.translatesAutoresizingMaskIntoConstraints = false
        aHLightRect1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        aHLightRect1.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //5
        aHLightRect1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        aHLightRect1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        let aHLightRectBG = UIView()
        aHLightRectBG.backgroundColor = .ddmDarkBlack //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.1 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        aHLightRectBG.isUserInteractionEnabled = true
        aHLightRectBG.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onRectClicked)))
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "Posts"
//        aHLightTitle.isHidden = true
        
        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .ddmDarkGrayColor
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
//        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightTitle.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        rArrowBtn.layer.opacity = 0.5
        
//        let scrollViewWidth = viewWidth - 20.0*2
//        let aScroll1 = UIView()
        aHLightRect1.addSubview(aScroll1)
        aScroll1.translatesAutoresizingMaskIntoConstraints = false
//        aScroll1.widthAnchor.constraint(equalToConstant: scrollViewWidth).isActive = true //ori: 80
        aScroll1.heightAnchor.constraint(equalToConstant: 50).isActive = true //60
        aScroll1.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aScroll1.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        aScroll1.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true //20
        aScroll1.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        
        bSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        self.addSubview(bSpinner)
        bSpinner.translatesAutoresizingMaskIntoConstraints = false
        bSpinner.centerYAnchor.constraint(equalTo: aScroll1.centerYAnchor, constant: 0).isActive = true
//        bSpinner.topAnchor.constraint(equalTo: footer.topAnchor, constant: 20).isActive = true
        bSpinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        bSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        bSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
//        let aGrid = UIView()
//        aGrid.backgroundColor = .ddmDarkColor
        aHLightRect1.addSubview(aGrid)
        aGrid.translatesAutoresizingMaskIntoConstraints = false
//        aGrid.trailingAnchor.constraint(equalTo: aScroll1.trailingAnchor, constant: -40).isActive = true //-10
        aGrid.leadingAnchor.constraint(equalTo: aScroll1.leadingAnchor, constant: 10).isActive = true //-10
        aGrid.heightAnchor.constraint(equalToConstant: 50).isActive = true //60
        aGrid.widthAnchor.constraint(equalToConstant: 50).isActive = true //40
//        aGrid.topAnchor.constraint(equalTo: aPhoto.bottomAnchor, constant: 20).isActive = true
        aGrid.topAnchor.constraint(equalTo: aScroll1.topAnchor, constant: 0).isActive = true //30
        aGrid.layer.cornerRadius = 5 //10

//        let gifImage = SDAnimatedImageView()
        gifImage.contentMode = .scaleAspectFill
        gifImage.layer.masksToBounds = true
        gifImage.layer.cornerRadius = 5 //10
//        gifImage.sd_setImage(with: imageUrl) //temp disable picture
        aGrid.addSubview(gifImage)
        gifImage.translatesAutoresizingMaskIntoConstraints = false
        gifImage.topAnchor.constraint(equalTo: aGrid.topAnchor).isActive = true
        gifImage.leadingAnchor.constraint(equalTo: aGrid.leadingAnchor).isActive = true
        gifImage.bottomAnchor.constraint(equalTo: aGrid.bottomAnchor).isActive = true
        gifImage.trailingAnchor.constraint(equalTo: aGrid.trailingAnchor).isActive = true
        
//        let aHItem1ATitle = UILabel()
        aHItem1ATitle.textAlignment = .left
        aHItem1ATitle.textColor = .white
        aHItem1ATitle.font = .systemFont(ofSize: 13) //13
//        aHItem1ATitle.font = .systemFont(ofSize: 13) //13
        aHLightRect1.addSubview(aHItem1ATitle)
        aHItem1ATitle.translatesAutoresizingMaskIntoConstraints = false
        aHItem1ATitle.topAnchor.constraint(equalTo: aScroll1.topAnchor, constant: 0).isActive = true //5
        aHItem1ATitle.leadingAnchor.constraint(equalTo: aScroll1.leadingAnchor, constant: 10).isActive = true
//        aHItem1ATitle.leadingAnchor.constraint(equalTo: aGrid.trailingAnchor, constant: 10).isActive = true
//        aHItem1ATitle.trailingAnchor.constraint(equalTo: aGrid.leadingAnchor, constant: -20).isActive = true
        aHItem1ATitle.trailingAnchor.constraint(equalTo: aScroll1.trailingAnchor, constant: -40).isActive = true
        aHItem1ATitle.text = ""
        aHItem1ATitle.numberOfLines = 3
        
        //test > error handling
        errorText.textAlignment = .center //left
        errorText.textColor = .white
        errorText.font = .systemFont(ofSize: 13)
        aHLightRect1.addSubview(errorText)
        errorText.clipsToBounds = true
        errorText.translatesAutoresizingMaskIntoConstraints = false
//        errorText.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor, constant: -20).isActive = true
//        errorText.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true //test
        errorText.centerYAnchor.constraint(equalTo: aScroll1.centerYAnchor, constant: 0).isActive = true
//        errorText.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 20).isActive = true
//        errorText.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -20).isActive = true
        errorText.centerXAnchor.constraint(equalTo: aHLightRect1.centerXAnchor, constant: -20).isActive = true
        errorText.text = ""
        errorText.numberOfLines = 0
        errorText.isHidden = true
        
//        errorRefreshBtn.backgroundColor = .ddmDarkColor //test to remove color
        aHLightRect1.addSubview(errorRefreshBtn)
        errorRefreshBtn.translatesAutoresizingMaskIntoConstraints = false
        errorRefreshBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
        errorRefreshBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        errorRefreshBtn.centerXAnchor.constraint(equalTo: aHLightRect1.centerXAnchor).isActive = true
//        errorRefreshBtn.topAnchor.constraint(equalTo: errorText.bottomAnchor, constant: 0).isActive = true
        errorRefreshBtn.centerYAnchor.constraint(equalTo: errorText.centerYAnchor, constant: 0).isActive = true //test
        errorRefreshBtn.leadingAnchor.constraint(equalTo: errorText.trailingAnchor).isActive = true
        errorRefreshBtn.layer.cornerRadius = 20
        errorRefreshBtn.isUserInteractionEnabled = true
        errorRefreshBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onErrorRefreshClicked)))
        errorRefreshBtn.isHidden = true
        
        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_refresh")?.withRenderingMode(.alwaysTemplate))
//        bMiniBtn.tintColor = .black
        bMiniBtn.tintColor = .white
        errorRefreshBtn.addSubview(bMiniBtn)
        bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        bMiniBtn.centerXAnchor.constraint(equalTo: errorRefreshBtn.centerXAnchor).isActive = true
        bMiniBtn.centerYAnchor.constraint(equalTo: errorRefreshBtn.centerYAnchor).isActive = true
        bMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true //26
        bMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
    }
    
    //test > initialization state
    var isInitialized = false
    func initialize() {
        if(!isInitialized) {
            redrawUI()
            
            self.bSpinner.startAnimating()
            asyncConfigure(data: "")
        }

        isInitialized = true
    }
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

                    self.bSpinner.stopAnimating()
                    
                    self.aHItem1ATitle.text = "往年的这个时候，iPhone 虽然也是位列销量榜榜首，但那都是上一代的旧机型呀...\n只能说这次 11.11 各家给的优惠都太给力了."
                    
//                    let imageUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
//                    self.gifImage.sd_setImage(with: imageUrl) //temp disable picture
//                    self.aGrid.isHidden = true
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    
                    guard let self = self else {
                        return
                    }
                    self.bSpinner.stopAnimating()
                    
                    //error handling e.g. refetch button
                    self.errorText.text = "Unable to load. Retry."
                    self.errorText.isHidden = false
                    self.errorRefreshBtn.isHidden = false
                }
                break
            }
        }
    }
    
    @objc func onRectClicked(gesture: UITapGestureRecognizer) {
        aDelegate?.didMeCellClickPosts()
    }
    
    @objc func onErrorRefreshClicked(gesture: UITapGestureRecognizer) {
        self.errorText.isHidden = true
        self.errorRefreshBtn.isHidden = true
        
        bSpinner.startAnimating()
        asyncConfigure(data: "")
    }
}

class MultiCommentsMeCell: MeCell {
    
    let aHLightRect1 = UIView()
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
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
        
        self.addSubview(aHLightRect1)
        aHLightRect1.translatesAutoresizingMaskIntoConstraints = false
        aHLightRect1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        aHLightRect1.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //5
        aHLightRect1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        aHLightRect1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        let aHLightRectBG = UIView()
        aHLightRectBG.backgroundColor = .ddmDarkBlack //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.1 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        aHLightRectBG.isUserInteractionEnabled = true
        aHLightRectBG.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onRectClicked)))
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "Comments"
//        aHLightTitle.isHidden = true
        
        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .ddmDarkGrayColor
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
//        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightTitle.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        rArrowBtn.layer.opacity = 0.5
        
//        let scrollViewWidth = viewWidth - 20.0*2
        let aScroll1 = UIView()
        aHLightRect1.addSubview(aScroll1)
        aScroll1.translatesAutoresizingMaskIntoConstraints = false
//        aScroll1.widthAnchor.constraint(equalToConstant: scrollViewWidth).isActive = true //ori: 80
        aScroll1.heightAnchor.constraint(equalToConstant: 50).isActive = true //60
        aScroll1.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aScroll1.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        aScroll1.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true //20
        aScroll1.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        
        let aHItem1ATitle = UILabel()
        aHItem1ATitle.textAlignment = .left
        aHItem1ATitle.textColor = .white
        aHItem1ATitle.font = .systemFont(ofSize: 13) //13
//        aHItem1ATitle.font = .systemFont(ofSize: 13) //13
        aHLightRect1.addSubview(aHItem1ATitle)
        aHItem1ATitle.translatesAutoresizingMaskIntoConstraints = false
        aHItem1ATitle.topAnchor.constraint(equalTo: aScroll1.topAnchor, constant: 0).isActive = true //5
        aHItem1ATitle.leadingAnchor.constraint(equalTo: aScroll1.leadingAnchor, constant: 10).isActive = true
        aHItem1ATitle.trailingAnchor.constraint(equalTo: aScroll1.trailingAnchor, constant: -10).isActive = true
        aHItem1ATitle.text = "Nice food, nice environment! Worth a visit."
        aHItem1ATitle.numberOfLines = 3
    }
    
    //test > initialization state
    var isInitialized = false
    func initialize() {
        if(!isInitialized) {
            redrawUI()
            asyncConfigure(data: "")
        }

        isInitialized = true
    }
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

                }

                case .failure(let error):
                DispatchQueue.main.async {
                    
                    guard let self = self else {
                        return
                    }
                    
                }
                break
            }
        }
    }
    
    @objc func onRectClicked(gesture: UITapGestureRecognizer) {
        aDelegate?.didMeCellClickComments()
    }
}

class HistoryMeCell: MeCell {
    
    let aHLightRect1 = UIView()
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
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
        
        self.addSubview(aHLightRect1)
        aHLightRect1.translatesAutoresizingMaskIntoConstraints = false
        aHLightRect1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        aHLightRect1.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //5
        aHLightRect1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        aHLightRect1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        let aHLightRectBG = UIView()
        aHLightRectBG.backgroundColor = .ddmDarkBlack //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.1 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        aHLightRectBG.isUserInteractionEnabled = true
        aHLightRectBG.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onRectClicked)))
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "History"
//        aHLightTitle.isHidden = true
        aHLightTitle.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        
        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .ddmDarkGrayColor
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
//        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightTitle.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        rArrowBtn.layer.opacity = 0.5
    }
    
    //test > initialization state
    var isInitialized = false
    func initialize() {
        if(!isInitialized) {
            redrawUI()
//            asyncConfigure(data: "")
        }

        isInitialized = true
    }
    
    @objc func onRectClicked(gesture: UITapGestureRecognizer) {
        aDelegate?.didMeCellClickHistory()
    }
}

class LikeMeCell: MeCell {
    
    let aHLightRect1 = UIView()
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
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
        
        self.addSubview(aHLightRect1)
        aHLightRect1.translatesAutoresizingMaskIntoConstraints = false
        aHLightRect1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        aHLightRect1.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //5
        aHLightRect1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        aHLightRect1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        let aHLightRectBG = UIView()
        aHLightRectBG.backgroundColor = .ddmDarkBlack //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.1 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        aHLightRectBG.isUserInteractionEnabled = true
        aHLightRectBG.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onRectClicked)))
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "Likes"
//        aHLightTitle.isHidden = true
        aHLightTitle.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        
        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .ddmDarkGrayColor
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
//        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightTitle.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        rArrowBtn.layer.opacity = 0.5
    }
    
    //test > initialization state
    var isInitialized = false
    func initialize() {
        if(!isInitialized) {
            redrawUI()
//            asyncConfigure(data: "")
        }

        isInitialized = true
    }
    
    @objc func onRectClicked(gesture: UITapGestureRecognizer) {
        aDelegate?.didMeCellClickLike()
    }
}

class BookmarkMeCell: MeCell {
    
    let aHLightRect1 = UIView()
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
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
        
        self.addSubview(aHLightRect1)
        aHLightRect1.translatesAutoresizingMaskIntoConstraints = false
        aHLightRect1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        aHLightRect1.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //5
        aHLightRect1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        aHLightRect1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        let aHLightRectBG = UIView()
        aHLightRectBG.backgroundColor = .ddmDarkBlack //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.1 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        aHLightRectBG.isUserInteractionEnabled = true
        aHLightRectBG.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onRectClicked)))
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "Bookmarks"
//        aHLightTitle.isHidden = true
        aHLightTitle.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        
        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .ddmDarkGrayColor
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
//        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightTitle.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        rArrowBtn.layer.opacity = 0.5
    }
    
    //test > initialization state
    var isInitialized = false
    func initialize() {
        if(!isInitialized) {
            redrawUI()
//            asyncConfigure(data: "")
        }

        isInitialized = true
    }
    
    @objc func onRectClicked(gesture: UITapGestureRecognizer) {
        aDelegate?.didMeCellClickBookmark()
    }
}

class AccountMeCell: MeCell {
    
    let aHLightRect1 = UIView()
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
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
        
        self.addSubview(aHLightRect1)
        aHLightRect1.translatesAutoresizingMaskIntoConstraints = false
        aHLightRect1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        aHLightRect1.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //5
        aHLightRect1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        aHLightRect1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        let aHLightRectBG = UIView()
        aHLightRectBG.backgroundColor = .ddmDarkBlack //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.1 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        aHLightRectBG.isUserInteractionEnabled = true
        aHLightRectBG.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onRectClicked)))
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "Account Settings" //Identity Verification
//        aHLightTitle.isHidden = true
        aHLightTitle.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        
        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .ddmDarkGrayColor
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
//        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightTitle.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        rArrowBtn.layer.opacity = 0.5
        
        let notifiedBox = UIView()
//        eUserCover.backgroundColor = .ddmBlackOverlayColor
        notifiedBox.backgroundColor = .red
        aHLightRect1.addSubview(notifiedBox)
        notifiedBox.translatesAutoresizingMaskIntoConstraints = false
        notifiedBox.centerYAnchor.constraint(equalTo: rArrowBtn.centerYAnchor, constant: 0).isActive = true
        notifiedBox.trailingAnchor.constraint(equalTo: rArrowBtn.leadingAnchor, constant: 0).isActive = true
        notifiedBox.heightAnchor.constraint(equalToConstant: 10).isActive = true //40
        notifiedBox.widthAnchor.constraint(equalToConstant: 10).isActive = true
        notifiedBox.layer.cornerRadius = 5
    }
    
    //test > initialization state
    var isInitialized = false
    func initialize() {
        if(!isInitialized) {
            redrawUI()
//            asyncConfigure(data: "")
        }

        isInitialized = true
    }
    
    @objc func onRectClicked(gesture: UITapGestureRecognizer) {
        aDelegate?.didMeCellClickAccountSetting()
    }
}

class EditProfileMeCell: MeCell {
    
    let aHLightRect1 = UIView()
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
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
        
        self.addSubview(aHLightRect1)
        aHLightRect1.translatesAutoresizingMaskIntoConstraints = false
        aHLightRect1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        aHLightRect1.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //5
        aHLightRect1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        aHLightRect1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        let aHLightRectBG = UIView()
        aHLightRectBG.backgroundColor = .ddmDarkBlack //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.1 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        aHLightRectBG.isUserInteractionEnabled = true
        aHLightRectBG.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onRectClicked)))
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "Edit Profile"
//        aHLightTitle.isHidden = true
        aHLightTitle.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        
        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .ddmDarkGrayColor
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
//        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightTitle.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        rArrowBtn.layer.opacity = 0.5
        
//        let notifiedBox = UIView()
////        eUserCover.backgroundColor = .ddmBlackOverlayColor
//        notifiedBox.backgroundColor = .red
//        aHLightRect1.addSubview(notifiedBox)
//        notifiedBox.translatesAutoresizingMaskIntoConstraints = false
//        notifiedBox.centerYAnchor.constraint(equalTo: rArrowBtn.centerYAnchor, constant: 0).isActive = true
//        notifiedBox.trailingAnchor.constraint(equalTo: rArrowBtn.leadingAnchor, constant: 0).isActive = true
//        notifiedBox.heightAnchor.constraint(equalToConstant: 10).isActive = true //40
//        notifiedBox.widthAnchor.constraint(equalToConstant: 10).isActive = true
//        notifiedBox.layer.cornerRadius = 5
    }
    
    //test > initialization state
    var isInitialized = false
    func initialize() {
        if(!isInitialized) {
            redrawUI()
//            asyncConfigure(data: "")
        }

        isInitialized = true
    }
    
    @objc func onRectClicked(gesture: UITapGestureRecognizer) {
        
        aDelegate?.didMeCellClickEditProfile()
    }
}

class FollowerMeCell: MeCell {
    
    let aHLightRect1 = UIView()
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
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
        
        self.addSubview(aHLightRect1)
        aHLightRect1.translatesAutoresizingMaskIntoConstraints = false
        aHLightRect1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        aHLightRect1.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //5
        aHLightRect1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        aHLightRect1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        let aHLightRectBG = UIView()
        aHLightRectBG.backgroundColor = .ddmDarkBlack //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.1 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        aHLightRectBG.isUserInteractionEnabled = true
        aHLightRectBG.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onRectClicked)))
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
//        aHLightTitle.text = "Followers"
        aHLightTitle.text = "Followers & Followings"
//        aHLightTitle.isHidden = true
        aHLightTitle.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        
        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .ddmDarkGrayColor
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
//        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightTitle.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        rArrowBtn.layer.opacity = 0.5
    }
    
    //test > initialization state
    var isInitialized = false
    func initialize() {
        if(!isInitialized) {
            redrawUI()
//            asyncConfigure(data: "")
        }

        isInitialized = true
    }
    
    @objc func onRectClicked(gesture: UITapGestureRecognizer) {
        aDelegate?.didMeCellClickFollow()
    }
}

class BaseMeCell: MeCell {
    
    let aHLightRect1 = UIView()
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    let rGridBG = SDAnimatedImageView()
    let aHSubDesc = UILabel()
    let aHSubDesc2 = UILabel()
    
    let bSpinner = SpinLoader()
    let errorText = UILabel()
    let errorRefreshBtn = UIView()
    
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
        
        self.addSubview(aHLightRect1)
        aHLightRect1.translatesAutoresizingMaskIntoConstraints = false
        aHLightRect1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        aHLightRect1.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //5
        aHLightRect1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        aHLightRect1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        let aHLightRectBG = UIView()
        aHLightRectBG.backgroundColor = .ddmDarkBlack //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.1 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        aHLightRectBG.isUserInteractionEnabled = true
        aHLightRectBG.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onRectClicked)))
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "Base"
//        aHLightTitle.isHidden = true
//        aHLightTitle.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        
        bSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        self.addSubview(bSpinner)
        bSpinner.translatesAutoresizingMaskIntoConstraints = false
//        bSpinner.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        bSpinner.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true //20
//        bSpinner.topAnchor.constraint(equalTo: footer.topAnchor, constant: 20).isActive = true
        bSpinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        bSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        bSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .ddmDarkGrayColor
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
//        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightTitle.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        rArrowBtn.layer.opacity = 0.5
        
//        let rGridBG = SDAnimatedImageView()
//        aHLightSection.addSubview(rGridBG)
        aHLightRect1.addSubview(rGridBG)
        rGridBG.translatesAutoresizingMaskIntoConstraints = false
        rGridBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
//        rGridBG.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        rGridBG.heightAnchor.constraint(equalToConstant: 30).isActive = true //60
        rGridBG.widthAnchor.constraint(equalToConstant: 30).isActive = true
        rGridBG.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true //20
//        rGridBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -20).isActive = true //-10
//        rGridBG.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true //5
//        rGridBG.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        rGridBG.layer.cornerRadius = 5 //20
        rGridBG.contentMode = .scaleAspectFill
        rGridBG.layer.masksToBounds = true
        rGridBG.layer.cornerRadius = 5
//        rGridBG.sd_setImage(with: imageUrl)
        rGridBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true

//        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .left
        aHSubDesc.textColor = .white //white
        aHSubDesc.font = .boldSystemFont(ofSize: 13)
//        aHSubDesc.font = .systemFont(ofSize: 13)
//        aHLightSection.addSubview(aHSubDesc)
        aHLightRect1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.topAnchor.constraint(equalTo: rGridBG.topAnchor, constant: 0).isActive = true //10
//        aHSubDesc.centerYAnchor.constraint(equalTo: rGridBG.centerYAnchor, constant: 0).isActive = true //20
        aHSubDesc.leadingAnchor.constraint(equalTo: rGridBG.trailingAnchor, constant: 10).isActive = true
        aHSubDesc.text = ""
        
//        let aHSubDesc2 = UILabel()
        aHSubDesc2.textAlignment = .left
        aHSubDesc2.textColor = .ddmDarkGrayColor
        aHSubDesc2.font = .systemFont(ofSize: 11)
//        aHLightSection.addSubview(aHSubDesc2)
        aHLightRect1.addSubview(aHSubDesc2)
        aHSubDesc2.translatesAutoresizingMaskIntoConstraints = false
//        aHSubDesc2.centerYAnchor.constraint(equalTo: aHSubDesc.centerYAnchor).isActive = true
        aHSubDesc2.topAnchor.constraint(equalTo: aHSubDesc.bottomAnchor, constant: 0).isActive = true //5
        aHSubDesc2.leadingAnchor.constraint(equalTo: rGridBG.trailingAnchor, constant: 10).isActive = true
//                aHSubDesc2.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
//        aHSubDesc2.text = "87k saves"
        aHSubDesc2.text = ""
//        aHSubDesc2.layer.opacity = 0.4
        
        //test > error handling
        errorText.textAlignment = .center //left
        errorText.textColor = .white
        errorText.font = .systemFont(ofSize: 13)
        aHLightRect1.addSubview(errorText)
        errorText.clipsToBounds = true
        errorText.translatesAutoresizingMaskIntoConstraints = false
//        errorText.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor, constant: -20).isActive = true
//        errorText.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true //test
        errorText.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true
//        errorText.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 20).isActive = true
//        errorText.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -20).isActive = true
        errorText.centerXAnchor.constraint(equalTo: aHLightRect1.centerXAnchor, constant: -20).isActive = true
        errorText.text = ""
        errorText.numberOfLines = 0
        errorText.isHidden = true
        
//        errorRefreshBtn.backgroundColor = .ddmDarkColor //test to remove color
        aHLightRect1.addSubview(errorRefreshBtn)
        errorRefreshBtn.translatesAutoresizingMaskIntoConstraints = false
        errorRefreshBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
        errorRefreshBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        errorRefreshBtn.centerXAnchor.constraint(equalTo: aHLightRect1.centerXAnchor).isActive = true
//        errorRefreshBtn.topAnchor.constraint(equalTo: errorText.bottomAnchor, constant: 0).isActive = true
        errorRefreshBtn.centerYAnchor.constraint(equalTo: errorText.centerYAnchor, constant: 0).isActive = true //test
        errorRefreshBtn.leadingAnchor.constraint(equalTo: errorText.trailingAnchor).isActive = true
        errorRefreshBtn.layer.cornerRadius = 20
        errorRefreshBtn.isUserInteractionEnabled = true
        errorRefreshBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onErrorRefreshClicked)))
        errorRefreshBtn.isHidden = true
        
        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_refresh")?.withRenderingMode(.alwaysTemplate))
//        bMiniBtn.tintColor = .black
        bMiniBtn.tintColor = .white
        errorRefreshBtn.addSubview(bMiniBtn)
        bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        bMiniBtn.centerXAnchor.constraint(equalTo: errorRefreshBtn.centerXAnchor).isActive = true
        bMiniBtn.centerYAnchor.constraint(equalTo: errorRefreshBtn.centerYAnchor).isActive = true
        bMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true //26
        bMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
    }
    
    //test > initialization state
    var isInitialized = false
    func initialize() {
        if(!isInitialized) {
            redrawUI()
            
            bSpinner.startAnimating()
            asyncConfigure(data: "")
        }

        isInitialized = true
    }
    
    func asyncConfigure(data: String) {
        let id = "u_"
        DataFetchManager.shared.fetchUserData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("pdp api success \(id), \(l)")
                    
                    guard let self = self else {
                        return
                    }

                    self.bSpinner.stopAnimating()
                    
                    self.aHSubDesc.text = "Petronas Twin Tower"
                    self.aHSubDesc2.text = "Malaysia"
                    
                    let imageUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
                    self.rGridBG.sd_setImage(with: imageUrl)
                    
//                    self.rArrowBtn.isHidden = false
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    
                    guard let self = self else {
                        return
                    }
                    
                    self.bSpinner.stopAnimating()
                    
                    self.aHSubDesc.text = " "
                    self.aHSubDesc2.text = ""
//                    self.linkBtn.image = nil
                    
                    let imageUrl = URL(string: "")
                    self.rGridBG.sd_setImage(with: imageUrl)
//                    self.rArrowBtn.isHidden = true
                    
                    //error handling e.g. refetch button
                    self.errorText.text = "Unable to load. Retry."
                    self.errorText.isHidden = false
                    self.errorRefreshBtn.isHidden = false
                }
                break
            }
        }
    }
    
    @objc func onRectClicked(gesture: UITapGestureRecognizer) {
        aDelegate?.didMeCellClickBase()
    }
    
    @objc func onErrorRefreshClicked(gesture: UITapGestureRecognizer) {
        self.errorText.isHidden = true
        self.errorRefreshBtn.isHidden = true
        
        bSpinner.startAnimating()
        asyncConfigure(data: "")
    }
}

class LocationMeCell: MeCell {
    
    let aHLightRect1 = UIView()
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    let rGridBG = SDAnimatedImageView()
    let aHSubDesc = UILabel()
    let aHSubDesc2 = UILabel()
    
    let bSpinner = SpinLoader()
    let errorText = UILabel()
    let errorRefreshBtn = UIView()
    
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
        
        self.addSubview(aHLightRect1)
        aHLightRect1.translatesAutoresizingMaskIntoConstraints = false
        aHLightRect1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        aHLightRect1.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //5
        aHLightRect1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        aHLightRect1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        let aHLightRectBG = UIView()
        aHLightRectBG.backgroundColor = .ddmDarkBlack //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.1 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        aHLightRectBG.isUserInteractionEnabled = true
        aHLightRectBG.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onRectClicked)))
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "Locations"
//        aHLightTitle.isHidden = true
//        aHLightTitle.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        
        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .ddmDarkGrayColor
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
//        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightTitle.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        rArrowBtn.layer.opacity = 0.5
        
        bSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        self.addSubview(bSpinner)
        bSpinner.translatesAutoresizingMaskIntoConstraints = false
//        bSpinner.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        bSpinner.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true //20
//        bSpinner.topAnchor.constraint(equalTo: footer.topAnchor, constant: 20).isActive = true
        bSpinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        bSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        bSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
//        let rGridBG = SDAnimatedImageView()
//        aHLightSection.addSubview(rGridBG)
        aHLightRect1.addSubview(rGridBG)
        rGridBG.translatesAutoresizingMaskIntoConstraints = false
        rGridBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
//        rGridBG.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        rGridBG.heightAnchor.constraint(equalToConstant: 30).isActive = true //60
        rGridBG.widthAnchor.constraint(equalToConstant: 30).isActive = true
        rGridBG.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true //20
//        rGridBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -20).isActive = true //-10
//        rGridBG.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true //5
//        rGridBG.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        rGridBG.layer.cornerRadius = 5 //20
//        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
//        let imageUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
//                let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
        rGridBG.contentMode = .scaleAspectFill
        rGridBG.layer.masksToBounds = true
        rGridBG.layer.cornerRadius = 5
//        rGridBG.sd_setImage(with: imageUrl)
        rGridBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true

//        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .left
        aHSubDesc.textColor = .white //white
//        aHSubDesc.font = .boldSystemFont(ofSize: 13)
        aHSubDesc.font = .systemFont(ofSize: 13)
//        aHLightSection.addSubview(aHSubDesc)
        aHLightRect1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.topAnchor.constraint(equalTo: rGridBG.topAnchor, constant: 0).isActive = true //10
//        aHSubDesc.centerYAnchor.constraint(equalTo: rGridBG.centerYAnchor, constant: 0).isActive = true //20
        aHSubDesc.leadingAnchor.constraint(equalTo: rGridBG.trailingAnchor, constant: 10).isActive = true
        aHSubDesc.text = ""
        
//        let aHSubDesc2 = UILabel()
        aHSubDesc2.textAlignment = .left
        aHSubDesc2.textColor = .ddmDarkGrayColor
        aHSubDesc2.font = .systemFont(ofSize: 11)
//        aHLightSection.addSubview(aHSubDesc2)
        aHLightRect1.addSubview(aHSubDesc2)
        aHSubDesc2.translatesAutoresizingMaskIntoConstraints = false
//        aHSubDesc2.centerYAnchor.constraint(equalTo: aHSubDesc.centerYAnchor).isActive = true
        aHSubDesc2.topAnchor.constraint(equalTo: aHSubDesc.bottomAnchor, constant: 0).isActive = true //5
        aHSubDesc2.leadingAnchor.constraint(equalTo: rGridBG.trailingAnchor, constant: 10).isActive = true
//                aHSubDesc2.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
//        aHSubDesc2.text = "87k saves"
        aHSubDesc2.text = ""
//        aHSubDesc2.layer.opacity = 0.4
        
        //test > error handling
        errorText.textAlignment = .center //left
        errorText.textColor = .white
        errorText.font = .systemFont(ofSize: 13)
        aHLightRect1.addSubview(errorText)
        errorText.clipsToBounds = true
        errorText.translatesAutoresizingMaskIntoConstraints = false
//        errorText.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor, constant: -20).isActive = true
//        errorText.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true //test
        errorText.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true
//        errorText.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 20).isActive = true
//        errorText.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -20).isActive = true
        errorText.centerXAnchor.constraint(equalTo: aHLightRect1.centerXAnchor, constant: -20).isActive = true
        errorText.text = ""
        errorText.numberOfLines = 0
        errorText.isHidden = true
        
//        errorRefreshBtn.backgroundColor = .ddmDarkColor //test to remove color
        aHLightRect1.addSubview(errorRefreshBtn)
        errorRefreshBtn.translatesAutoresizingMaskIntoConstraints = false
        errorRefreshBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
        errorRefreshBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        errorRefreshBtn.centerXAnchor.constraint(equalTo: aHLightRect1.centerXAnchor).isActive = true
//        errorRefreshBtn.topAnchor.constraint(equalTo: errorText.bottomAnchor, constant: 0).isActive = true
        errorRefreshBtn.centerYAnchor.constraint(equalTo: errorText.centerYAnchor, constant: 0).isActive = true //test
        errorRefreshBtn.leadingAnchor.constraint(equalTo: errorText.trailingAnchor).isActive = true
        errorRefreshBtn.layer.cornerRadius = 20
        errorRefreshBtn.isUserInteractionEnabled = true
        errorRefreshBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onErrorRefreshClicked)))
        errorRefreshBtn.isHidden = true
        
        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_refresh")?.withRenderingMode(.alwaysTemplate))
//        bMiniBtn.tintColor = .black
        bMiniBtn.tintColor = .white
        errorRefreshBtn.addSubview(bMiniBtn)
        bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        bMiniBtn.centerXAnchor.constraint(equalTo: errorRefreshBtn.centerXAnchor).isActive = true
        bMiniBtn.centerYAnchor.constraint(equalTo: errorRefreshBtn.centerYAnchor).isActive = true
        bMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true //26
        bMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
    }
    
    //test > initialization state
    var isInitialized = false
    func initialize() {
        if(!isInitialized) {
            redrawUI()
            
            bSpinner.startAnimating()
            asyncConfigure(data: "")
        }

        isInitialized = true
    }
    
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

                    self.bSpinner.stopAnimating()
                    
                    self.aHSubDesc.text = "DinoDreamTgX"
                    self.aHSubDesc2.text = "United States"
                    
                    let imageUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
                    self.rGridBG.sd_setImage(with: imageUrl)
                    
//                    self.rArrowBtn.isHidden = false
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    
                    guard let self = self else {
                        return
                    }
                    
                    self.bSpinner.stopAnimating()
                    
                    self.aHSubDesc.text = ""
                    self.aHSubDesc2.text = ""
//                    self.linkBtn.image = nil
                    
                    let imageUrl = URL(string: "")
                    self.rGridBG.sd_setImage(with: imageUrl)
//                    self.rArrowBtn.isHidden = true
                    
                    //error handling e.g. refetch button
                    self.errorText.text = "Unable to load. Retry."
                    self.errorText.isHidden = false
                    self.errorRefreshBtn.isHidden = false
                }
                break
            }
        }
    }
    
    @objc func onRectClicked(gesture: UITapGestureRecognizer) {
        aDelegate?.didMeCellClickLocations()
    }
    
    @objc func onErrorRefreshClicked(gesture: UITapGestureRecognizer) {
        self.errorText.isHidden = true
        self.errorRefreshBtn.isHidden = true
        
        bSpinner.startAnimating()
        asyncConfigure(data: "")
    }
}

class ProfileMeCell: MeCell {
    
    let aHLightRect1 = UIView()
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    let bSpinner = SpinLoader()
    let errorText = UILabel()
    let errorRefreshBtn = UIView()
    
    let aPhoto = SDAnimatedImageView()
    let aNameText = UILabel()
    let aFollowAText = UILabel()
    
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
        
        self.addSubview(aHLightRect1)
        aHLightRect1.translatesAutoresizingMaskIntoConstraints = false
        aHLightRect1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        aHLightRect1.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //5
        aHLightRect1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        aHLightRect1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        let aHLightRectBG = UIView()
//        aHLightRectBG.backgroundColor = .ddmDarkColor //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
//        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.1 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        aHLightRectBG.isUserInteractionEnabled = true
        aHLightRectBG.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onProfileClicked)))
        
//        let aHLightTitle = UILabel()
//        aHLightTitle.textAlignment = .left
//        aHLightTitle.textColor = .white
//        aHLightTitle.font = .boldSystemFont(ofSize: 14)
//        aHLightRect1.addSubview(aHLightTitle)
//        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
//        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
//        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
//        aHLightTitle.text = "Locations"
////        aHLightTitle.isHidden = true
////        aHLightTitle.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        
        
//        let aPhoto = SDAnimatedImageView()
        aHLightRect1.addSubview(aPhoto)
        aPhoto.translatesAutoresizingMaskIntoConstraints = false
        aPhoto.widthAnchor.constraint(equalToConstant: 100).isActive = true //ori: 80
        aPhoto.heightAnchor.constraint(equalToConstant: 100).isActive = true
        aPhoto.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aPhoto.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aPhoto.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
//        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        aPhoto.contentMode = .scaleAspectFill
        aPhoto.layer.masksToBounds = true
        aPhoto.layer.cornerRadius = 100/2
//        aPhoto.sd_setImage(with: imageUrl)
        aPhoto.backgroundColor = .ddmDarkColor
        
//        let aNameText = UILabel()
        aNameText.textAlignment = .left
        aNameText.textColor = .white
        aNameText.font = .boldSystemFont(ofSize: 16)
        aHLightRect1.addSubview(aNameText)
        aNameText.translatesAutoresizingMaskIntoConstraints = false
//        aNameText.topAnchor.constraint(equalTo: aPhoto.topAnchor, constant: 10).isActive = true
//        aNameText.leadingAnchor.constraint(equalTo: aPanelView.leadingAnchor, constant: 20).isActive = true
        aNameText.leadingAnchor.constraint(equalTo: aPhoto.trailingAnchor, constant: 10).isActive = true
        aNameText.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -40).isActive = true
        aNameText.centerYAnchor.constraint(equalTo: aPhoto.centerYAnchor, constant: -15).isActive = true //0
//        aNameText.numberOfLines = 0
        aNameText.text = ""
//        aNameText.text = ""
        
//        let aFollowAText = UILabel()
        aFollowAText.textAlignment = .center
//        aFollowAText.textColor = .white
        aFollowAText.textColor = .ddmDarkGrayColor
        aFollowAText.font = .boldSystemFont(ofSize: 13) //default 14
//        aPanelView.addSubview(aFollowAText)
        aHLightRect1.addSubview(aFollowAText)
        aFollowAText.translatesAutoresizingMaskIntoConstraints = false
        aFollowAText.leadingAnchor.constraint(equalTo: aNameText.leadingAnchor, constant: 0).isActive = true //20
//        aFollowAText.trailingAnchor.constraint(equalTo: aFollowA.trailingAnchor, constant: -15).isActive = true
        aFollowAText.topAnchor.constraint(equalTo: aNameText.bottomAnchor, constant: 5).isActive = true //10
        aFollowAText.text = "" //Go to Profile
        
//        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
//        rArrowBtn.tintColor = .ddmDarkGrayColor
////        aHLightSection.addSubview(rArrowBtn)
//        aHLightRect1.addSubview(rArrowBtn)
//        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
//        rArrowBtn.leadingAnchor.constraint(equalTo: aFollowAText.trailingAnchor, constant: 3).isActive = true
////        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
////                rArrowBtn.centerYAnchor.constraint(equalTo: rGridBG.centerYAnchor).isActive = true
//        rArrowBtn.centerYAnchor.constraint(equalTo: aFollowAText.centerYAnchor).isActive = true
//        rArrowBtn.heightAnchor.constraint(equalToConstant: 18).isActive = true
//        rArrowBtn.widthAnchor.constraint(equalToConstant: 18).isActive = true
////        rArrowBtn.layer.opacity = 0.5
//        rArrowBtn.isHidden = true
        
        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .ddmDarkGrayColor
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
//        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aNameText.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        
        bSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        self.addSubview(bSpinner)
        bSpinner.translatesAutoresizingMaskIntoConstraints = false
        bSpinner.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
//        bSpinner.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true //20
//        bSpinner.topAnchor.constraint(equalTo: footer.topAnchor, constant: 20).isActive = true
        bSpinner.centerXAnchor.constraint(equalTo: aHLightRect1.centerXAnchor).isActive = true
        bSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        bSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        //test > error handling
        errorText.textAlignment = .center //left
        errorText.textColor = .white
        errorText.font = .systemFont(ofSize: 13)
        aHLightRect1.addSubview(errorText)
        errorText.clipsToBounds = true
        errorText.translatesAutoresizingMaskIntoConstraints = false
        errorText.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor, constant: -20).isActive = true
//        errorText.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true //test
//        errorText.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true
//        errorText.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 20).isActive = true
//        errorText.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -20).isActive = true
        errorText.centerXAnchor.constraint(equalTo: aHLightRect1.centerXAnchor, constant: 0).isActive = true
        errorText.text = ""
        errorText.numberOfLines = 0
        errorText.isHidden = true
        
//        errorRefreshBtn.backgroundColor = .ddmDarkColor //test to remove color
        aHLightRect1.addSubview(errorRefreshBtn)
        errorRefreshBtn.translatesAutoresizingMaskIntoConstraints = false
        errorRefreshBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
        errorRefreshBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        errorRefreshBtn.centerXAnchor.constraint(equalTo: aHLightRect1.centerXAnchor).isActive = true
        errorRefreshBtn.topAnchor.constraint(equalTo: errorText.bottomAnchor, constant: 0).isActive = true
//        errorRefreshBtn.centerYAnchor.constraint(equalTo: errorText.centerYAnchor, constant: 0).isActive = true //test
//        errorRefreshBtn.leadingAnchor.constraint(equalTo: errorText.trailingAnchor).isActive = true
        errorRefreshBtn.layer.cornerRadius = 20
        errorRefreshBtn.isUserInteractionEnabled = true
        errorRefreshBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onErrorRefreshClicked)))
        errorRefreshBtn.isHidden = true
        
        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_refresh")?.withRenderingMode(.alwaysTemplate))
//        bMiniBtn.tintColor = .black
        bMiniBtn.tintColor = .white
        errorRefreshBtn.addSubview(bMiniBtn)
        bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        bMiniBtn.centerXAnchor.constraint(equalTo: errorRefreshBtn.centerXAnchor).isActive = true
        bMiniBtn.centerYAnchor.constraint(equalTo: errorRefreshBtn.centerYAnchor).isActive = true
        bMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true //26
        bMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
    }
    
    //test > initialization state
    var isInitialized = false
    func initialize() {
        if(!isInitialized) {
            redrawUI()
            
            bSpinner.startAnimating()
            asyncConfigure(data: "")
        }

        isInitialized = true
    }
    
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

                    self.bSpinner.stopAnimating()
                    
                    self.aNameText.text = "Michelle Lee"
                    self.aFollowAText.text = "@mic809"
                    
                    let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
                    self.aPhoto.sd_setImage(with: imageUrl)
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    
                    guard let self = self else {
                        return
                    }
                    
                    self.bSpinner.stopAnimating()
                    
                    self.aNameText.text = ""
                    self.aFollowAText.text = ""
                    
                    let imageUrl = URL(string: "")
                    self.aPhoto.sd_setImage(with: imageUrl)
                    
                    //error handling e.g. refetch button
                    self.errorText.text = "Unable to load. Retry."
                    self.errorText.isHidden = false
                    self.errorRefreshBtn.isHidden = false
                }
                break
            }
        }
    }
    
    @objc func onProfileClicked(gesture: UITapGestureRecognizer) {
        aDelegate?.didMeCellClickUser()
    }
    @objc func onErrorRefreshClicked(gesture: UITapGestureRecognizer) {
        self.errorText.isHidden = true
        self.errorRefreshBtn.isHidden = true
        
        bSpinner.startAnimating()
        asyncConfigure(data: "")
    }
}

class SignoutMeCell: MeCell {
    
    let aHLightRect1 = UIView()
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
//    weak var aDelegate : MeCellDelegate?
    
//    let aSpinner = SpinLoader()
    
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
        
        self.addSubview(aHLightRect1)
        aHLightRect1.translatesAutoresizingMaskIntoConstraints = false
        aHLightRect1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        aHLightRect1.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //5
        aHLightRect1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        aHLightRect1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        let aHLightRectBG = UIView()
        aHLightRectBG.backgroundColor = .ddmDarkBlack //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.1 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        aHLightRectBG.isUserInteractionEnabled = true
        aHLightRectBG.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onRectClicked)))
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .red
        aHLightTitle.font = .systemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
//        aHLightTitle.text = "Followers"
        aHLightTitle.text = "Sign Out"
//        aHLightTitle.isHidden = true
        aHLightTitle.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        
//        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
//        rArrowBtn.tintColor = .white
//        aHLightRect1.addSubview(rArrowBtn)
//        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
//        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
////        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
//        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightTitle.centerYAnchor).isActive = true
//        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
//        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        rArrowBtn.layer.opacity = 0.5
        
//        aHLightRect1.addSubview(aSpinner)
//        aSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
//        aSpinner.translatesAutoresizingMaskIntoConstraints = false
//        aSpinner.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor, constant: 0).isActive = true  //0
//        aSpinner.leadingAnchor.constraint(equalTo: aHLightTitle.trailingAnchor, constant: 10).isActive = true
//        aSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        aSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    //test > initialization state
    var isInitialized = false
    func initialize() {
        if(!isInitialized) {
            redrawUI()
//            asyncConfigure(data: "")
        }

        isInitialized = true
    }
    
    @objc func onRectClicked(gesture: UITapGestureRecognizer) {
        
        aDelegate?.didMeCellClickSignout()
    }
}
