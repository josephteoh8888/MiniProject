//
//  HighlightBox.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

//test > another design for suggested user accounts
class DiscoverUserSizeLHighlightCell: HighlightCell {
//class DiscoverUserSizeLHighlightCell: UIView {
    
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
        aHLightRectBG.backgroundColor = .ddmDarkOverlayBlack //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.2 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "Related Creators"
        
        let aPhoto = SDAnimatedImageView()
        aHLightRect1.addSubview(aPhoto)
        aPhoto.translatesAutoresizingMaskIntoConstraints = false
        aPhoto.widthAnchor.constraint(equalToConstant: 60).isActive = true //ori: 80
        aPhoto.heightAnchor.constraint(equalToConstant: 60).isActive = true
        aPhoto.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aPhoto.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 20).isActive = true
//                aPhoto.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -20).isActive = true
//        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        let imageUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
        aPhoto.contentMode = .scaleAspectFill
        aPhoto.layer.masksToBounds = true
        aPhoto.layer.cornerRadius = 30
        aPhoto.sd_setImage(with: imageUrl)
        aPhoto.isUserInteractionEnabled = true
        aPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onUserClicked)))
        
        let aHItemTitle = UILabel()
        aHItemTitle.textAlignment = .left
        aHItemTitle.textColor = .white
        aHItemTitle.font = .boldSystemFont(ofSize: 13) //13
        aHLightRect1.addSubview(aHItemTitle)
        aHItemTitle.translatesAutoresizingMaskIntoConstraints = false
        aHItemTitle.topAnchor.constraint(equalTo: aPhoto.topAnchor, constant: 10).isActive = true //5
        aHItemTitle.leadingAnchor.constraint(equalTo: aPhoto.trailingAnchor, constant: 10).isActive = true
        aHItemTitle.text = "Vicky Chia"
        
        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .left
        aHSubDesc.textColor = .ddmDarkGrayColor
        aHSubDesc.font = .systemFont(ofSize: 11)
        aHLightRect1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.topAnchor.constraint(equalTo: aHItemTitle.bottomAnchor, constant: 0).isActive = true //20
        aHSubDesc.leadingAnchor.constraint(equalTo: aPhoto.trailingAnchor, constant: 10).isActive = true
        aHSubDesc.text = "@vickych"
//        aHSubDesc.layer.opacity = 0.4
        
        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .ddmDarkGrayColor
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHItemTitle.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        rArrowBtn.layer.opacity = 0.5
        
        let aPhoto1A = SDAnimatedImageView()
        aHLightRect1.addSubview(aPhoto1A)
        aPhoto1A.translatesAutoresizingMaskIntoConstraints = false
        aPhoto1A.widthAnchor.constraint(equalToConstant: 60).isActive = true //ori: 80
        aPhoto1A.heightAnchor.constraint(equalToConstant: 60).isActive = true
        aPhoto1A.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aPhoto1A.topAnchor.constraint(equalTo: aPhoto.bottomAnchor, constant: 20).isActive = true
        aPhoto1A.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        aPhoto1A.contentMode = .scaleAspectFill
        aPhoto1A.layer.masksToBounds = true
        aPhoto1A.layer.cornerRadius = 30
        aPhoto1A.sd_setImage(with: imageUrl)
        
        let aHItem1ATitle = UILabel()
        aHItem1ATitle.textAlignment = .left
        aHItem1ATitle.textColor = .white
        aHItem1ATitle.font = .boldSystemFont(ofSize: 13) //13
        aHLightRect1.addSubview(aHItem1ATitle)
        aHItem1ATitle.translatesAutoresizingMaskIntoConstraints = false
        aHItem1ATitle.topAnchor.constraint(equalTo: aPhoto1A.topAnchor, constant: 10).isActive = true //5
        aHItem1ATitle.leadingAnchor.constraint(equalTo: aPhoto1A.trailingAnchor, constant: 10).isActive = true
        aHItem1ATitle.text = "Micole Yan"
        
        let aHSubDesc1A = UILabel()
        aHSubDesc1A.textAlignment = .left
        aHSubDesc1A.textColor = .ddmDarkGrayColor
        aHSubDesc1A.font = .systemFont(ofSize: 11)
        aHLightRect1.addSubview(aHSubDesc1A)
        aHSubDesc1A.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc1A.topAnchor.constraint(equalTo: aHItem1ATitle.bottomAnchor, constant: 0).isActive = true //20
        aHSubDesc1A.leadingAnchor.constraint(equalTo: aPhoto1A.trailingAnchor, constant: 10).isActive = true
        aHSubDesc1A.text = "@micoley"
//        aHSubDesc1A.layer.opacity = 0.4
        
        let rArrow1ABtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrow1ABtn.tintColor = .ddmDarkGrayColor
        aHLightRect1.addSubview(rArrow1ABtn)
        rArrow1ABtn.translatesAutoresizingMaskIntoConstraints = false
        rArrow1ABtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
        rArrow1ABtn.centerYAnchor.constraint(equalTo: aHItem1ATitle.centerYAnchor).isActive = true
        rArrow1ABtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrow1ABtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        rArrow1ABtn.layer.opacity = 0.5
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
    
    @objc func onUserClicked(gesture: UITapGestureRecognizer) {
        self.delegate?.didHighlightClickUser(id: "")
    }
}

class DiscoverUserSizeMHighlightCell: HighlightCell {
//class DiscoverUserSizeMHighlightCell: UIView {
    
    let aHLightRect1 = UIView()
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    let aTab1 = UIView()
    let aTab2 = UIView()
    
    let scrollView1 = UIScrollView()
    var vDataList = [String]()
    var aHLightViewArray = [UIView]()
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
        aHLightRectBG.backgroundColor = .ddmDarkOverlayBlack
//        aHLightRectBG.backgroundColor = .ddmBlackDark
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.2 //0.2, 0.1
//        aHLightRectBG.layer.opacity = 0.0 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true //10
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "Related Creators"
//        aHLightTitle.text = "Suggested For You"
//        aHLightTitle.text = "Discover More Creators"
        
//        aTab1.backgroundColor = .white
//        aHLightRect1.addSubview(aTab1)
//        aTab1.translatesAutoresizingMaskIntoConstraints = false
//        aTab1.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -14).isActive = true //10
//        aTab1.centerYAnchor.constraint(equalTo: aHLightTitle.centerYAnchor).isActive = true
////                aTab1.trailingAnchor.constraint(equalTo: aHLightRect1.centerXAnchor, constant: 10).isActive = true //10
////                aTab1.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -4).isActive = true
//        aTab1.heightAnchor.constraint(equalToConstant: 3).isActive = true //2
//        aTab1.widthAnchor.constraint(equalToConstant: 5).isActive = true //10
//        aTab1.layer.opacity = 0.2 //0.5
//        aTab1.layer.cornerRadius = 1
//        
//        aTab2.backgroundColor = .white
//        aHLightRect1.addSubview(aTab2)
//        aTab2.translatesAutoresizingMaskIntoConstraints = false
//        aTab2.trailingAnchor.constraint(equalTo: aTab1.leadingAnchor, constant: -5).isActive = true
//        aTab2.centerYAnchor.constraint(equalTo: aTab1.centerYAnchor).isActive = true
//        aTab2.heightAnchor.constraint(equalToConstant: 3).isActive = true
//        aTab2.widthAnchor.constraint(equalToConstant: 5).isActive = true
//        aTab2.layer.opacity = 0.5 //0.5
//        aTab2.layer.cornerRadius = 1
        
        bSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        self.addSubview(bSpinner)
        bSpinner.translatesAutoresizingMaskIntoConstraints = false
        bSpinner.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        bSpinner.topAnchor.constraint(equalTo: footer.topAnchor, constant: 20).isActive = true
        bSpinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        bSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        bSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let scrollViewWidth = viewWidth - 20.0*2
//        let scrollViewWidth = 170.0
//        let totalScrollWidth = scrollViewWidth * 2
        
//        let scrollView1 = UIScrollView()
        aHLightRect1.addSubview(scrollView1)
        scrollView1.backgroundColor = .clear
        scrollView1.translatesAutoresizingMaskIntoConstraints = false
        scrollView1.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 20).isActive = true
        scrollView1.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        scrollView1.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        scrollView1.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true //-10
        scrollView1.heightAnchor.constraint(equalToConstant: 60).isActive = true //60
        scrollView1.showsHorizontalScrollIndicator = false
        scrollView1.showsVerticalScrollIndicator = false
        scrollView1.alwaysBounceHorizontal = true
//        scrollView1.contentSize = CGSize(width: totalScrollWidth, height: 60)
        scrollView1.isPagingEnabled = true
//        scrollView1.delegate = self

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
    
    func configure(data: String) {
        let scrollViewWidth = (viewWidth - 20.0*2)/2
        let scrollViewHeight = 60.0
        let totalScrollWidth = scrollViewWidth * 2
        
        if(data == "a") {
            vDataList.append("p")
            vDataList.append("p")
//            vDataList.append("p")
//            vDataList.append("p")

            for _ in vDataList {
            
                let hd = HDiscoverUserSizeMColumnViewCell(frame: CGRect(x: 0 , y: 0, width: scrollViewWidth, height: scrollViewHeight))
                scrollView1.addSubview(hd)
                hd.translatesAutoresizingMaskIntoConstraints = false
                hd.widthAnchor.constraint(equalToConstant: scrollViewWidth).isActive = true //180
                hd.heightAnchor.constraint(equalToConstant: scrollViewHeight).isActive = true //280
                hd.topAnchor.constraint(equalTo: scrollView1.topAnchor, constant: 0).isActive = true
                if(aHLightViewArray.isEmpty) {
                    hd.leadingAnchor.constraint(equalTo: scrollView1.leadingAnchor, constant: 0).isActive = true
                } else {
                    let lastArrayE = aHLightViewArray[aHLightViewArray.count - 1]
                    hd.leadingAnchor.constraint(equalTo: lastArrayE.trailingAnchor, constant: 0).isActive = true
                }
                aHLightViewArray.append(hd)
                hd.redrawUI()
                hd.configure(data: "")
                hd.aDelegate = self
            }
            
            let dataCount = vDataList.count
            
            let totalWidth = CGFloat(dataCount) * scrollViewWidth
            scrollView1.contentSize = CGSize(width: totalWidth, height: scrollViewHeight) //800, 280
        }
    }
    
    @objc func onErrorRefreshClicked(gesture: UITapGestureRecognizer) {
        self.errorText.isHidden = true
        self.errorRefreshBtn.isHidden = true
        
        bSpinner.startAnimating()
        asyncConfigure(data: "")
    }
}

extension DiscoverUserSizeMHighlightCell: DiscoverColumnViewCellDelegate {
    func discoverColumnDidClickSound() {
//        self.delegate?.didHighlightClickSound(id: "")
    }
    func discoverColumnDidClickUser(){
        self.delegate?.didHighlightClickUser(id: "")
    }
    func discoverColumnDidClickPlace(){
//        self.delegate?.didHighlightClickPlace(id: "")
    }
}

//test > suggested sounds
class DiscoverSoundSizeLHighlightCell: HighlightCell {
    
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
        aHLightRectBG.backgroundColor = .ddmDarkOverlayBlack //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.2 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "Related Creators"
        
        let aPhoto = SDAnimatedImageView()
        aHLightRect1.addSubview(aPhoto)
        aPhoto.translatesAutoresizingMaskIntoConstraints = false
        aPhoto.widthAnchor.constraint(equalToConstant: 60).isActive = true //ori: 80
        aPhoto.heightAnchor.constraint(equalToConstant: 60).isActive = true
        aPhoto.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aPhoto.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 20).isActive = true
//                aPhoto.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -20).isActive = true
//        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        let imageUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
        aPhoto.contentMode = .scaleAspectFill
        aPhoto.layer.masksToBounds = true
        aPhoto.layer.cornerRadius = 5
        aPhoto.sd_setImage(with: imageUrl)
        aPhoto.isUserInteractionEnabled = true
        aPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSoundClicked)))
        
        let aHItemTitle = UILabel()
        aHItemTitle.textAlignment = .left
        aHItemTitle.textColor = .white
        aHItemTitle.font = .boldSystemFont(ofSize: 13) //13
        aHLightRect1.addSubview(aHItemTitle)
        aHItemTitle.translatesAutoresizingMaskIntoConstraints = false
        aHItemTitle.topAnchor.constraint(equalTo: aPhoto.topAnchor, constant: 10).isActive = true //5
        aHItemTitle.leadingAnchor.constraint(equalTo: aPhoto.trailingAnchor, constant: 10).isActive = true
        aHItemTitle.text = "反對無效"
        
        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .left
        aHSubDesc.textColor = .ddmDarkGrayColor
        aHSubDesc.font = .systemFont(ofSize: 11)
        aHLightRect1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.topAnchor.constraint(equalTo: aHItemTitle.bottomAnchor, constant: 0).isActive = true //20
        aHSubDesc.leadingAnchor.constraint(equalTo: aPhoto.trailingAnchor, constant: 10).isActive = true
        aHSubDesc.text = "MC 張天賦"
//        aHSubDesc.layer.opacity = 0.4
        
        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .ddmDarkGrayColor
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHItemTitle.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        rArrowBtn.layer.opacity = 0.5
        
        let aPhoto1A = SDAnimatedImageView()
        aHLightRect1.addSubview(aPhoto1A)
        aPhoto1A.translatesAutoresizingMaskIntoConstraints = false
        aPhoto1A.widthAnchor.constraint(equalToConstant: 60).isActive = true //ori: 80
        aPhoto1A.heightAnchor.constraint(equalToConstant: 60).isActive = true
        aPhoto1A.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aPhoto1A.topAnchor.constraint(equalTo: aPhoto.bottomAnchor, constant: 20).isActive = true
        aPhoto1A.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        aPhoto1A.contentMode = .scaleAspectFill
        aPhoto1A.layer.masksToBounds = true
        aPhoto1A.layer.cornerRadius = 5
        aPhoto1A.sd_setImage(with: imageUrl)
        
        let aHItem1ATitle = UILabel()
        aHItem1ATitle.textAlignment = .left
        aHItem1ATitle.textColor = .white
        aHItem1ATitle.font = .boldSystemFont(ofSize: 13) //13
        aHLightRect1.addSubview(aHItem1ATitle)
        aHItem1ATitle.translatesAutoresizingMaskIntoConstraints = false
        aHItem1ATitle.topAnchor.constraint(equalTo: aPhoto1A.topAnchor, constant: 10).isActive = true //5
        aHItem1ATitle.leadingAnchor.constraint(equalTo: aPhoto1A.trailingAnchor, constant: 10).isActive = true
        aHItem1ATitle.text = "我为何让你走"
        
        let aHSubDesc1A = UILabel()
        aHSubDesc1A.textAlignment = .left
        aHSubDesc1A.textColor = .ddmDarkGrayColor
        aHSubDesc1A.font = .systemFont(ofSize: 11)
        aHLightRect1.addSubview(aHSubDesc1A)
        aHSubDesc1A.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc1A.topAnchor.constraint(equalTo: aHItem1ATitle.bottomAnchor, constant: 0).isActive = true //20
        aHSubDesc1A.leadingAnchor.constraint(equalTo: aPhoto1A.trailingAnchor, constant: 10).isActive = true
        aHSubDesc1A.text = "黎明 卫兰"
//        aHSubDesc1A.layer.opacity = 0.4
        
        let rArrow1ABtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrow1ABtn.tintColor = .ddmDarkGrayColor
        aHLightRect1.addSubview(rArrow1ABtn)
        rArrow1ABtn.translatesAutoresizingMaskIntoConstraints = false
        rArrow1ABtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
        rArrow1ABtn.centerYAnchor.constraint(equalTo: aHItem1ATitle.centerYAnchor).isActive = true
        rArrow1ABtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrow1ABtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        rArrow1ABtn.layer.opacity = 0.5
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
    
    @objc func onSoundClicked(gesture: UITapGestureRecognizer) {
        self.delegate?.didHighlightClickSound(id: "")
    }
}

class DiscoverSoundSizeMHighlightCell: HighlightCell {
    
    let aHLightRect1 = UIView()
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    let aTab1 = UIView()
    let aTab2 = UIView()
    
    let scrollView1 = UIScrollView()
    var vDataList = [String]()
    var aHLightViewArray = [UIView]()
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
        aHLightRectBG.backgroundColor = .ddmDarkOverlayBlack //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.2 //0.2, 0.1
//        aHLightRectBG.layer.opacity = 0.0 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true //10
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "Related Sounds"
//        aHLightTitle.text = "Suggested For You"
//        aHLightTitle.text = "Discover More Sounds"
        
//        aTab1.backgroundColor = .white
//        aHLightRect1.addSubview(aTab1)
//        aTab1.translatesAutoresizingMaskIntoConstraints = false
//        aTab1.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -14).isActive = true //10
//        aTab1.centerYAnchor.constraint(equalTo: aHLightTitle.centerYAnchor).isActive = true
////                aTab1.trailingAnchor.constraint(equalTo: aHLightRect1.centerXAnchor, constant: 10).isActive = true //10
////                aTab1.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -4).isActive = true
//        aTab1.heightAnchor.constraint(equalToConstant: 3).isActive = true //2
//        aTab1.widthAnchor.constraint(equalToConstant: 5).isActive = true //10
//        aTab1.layer.opacity = 0.2 //0.5
//        aTab1.layer.cornerRadius = 1
//        
//        aTab2.backgroundColor = .white
//        aHLightRect1.addSubview(aTab2)
//        aTab2.translatesAutoresizingMaskIntoConstraints = false
//        aTab2.trailingAnchor.constraint(equalTo: aTab1.leadingAnchor, constant: -5).isActive = true
//        aTab2.centerYAnchor.constraint(equalTo: aTab1.centerYAnchor).isActive = true
//        aTab2.heightAnchor.constraint(equalToConstant: 3).isActive = true
//        aTab2.widthAnchor.constraint(equalToConstant: 5).isActive = true
//        aTab2.layer.opacity = 0.5 //0.5
//        aTab2.layer.cornerRadius = 1
        
        bSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        self.addSubview(bSpinner)
        bSpinner.translatesAutoresizingMaskIntoConstraints = false
        bSpinner.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 20).isActive = true
//        bSpinner.topAnchor.constraint(equalTo: footer.topAnchor, constant: 20).isActive = true
        bSpinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        bSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        bSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let scrollViewWidth = viewWidth - 20.0*2
//        let scrollViewWidth = 170.0
//        let totalScrollWidth = scrollViewWidth * 2
        
//        let scrollView1 = UIScrollView()
        aHLightRect1.addSubview(scrollView1)
        scrollView1.backgroundColor = .clear
        scrollView1.translatesAutoresizingMaskIntoConstraints = false
        scrollView1.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 20).isActive = true
        scrollView1.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        scrollView1.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        scrollView1.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true //-10
        scrollView1.heightAnchor.constraint(equalToConstant: 60).isActive = true //60
        scrollView1.showsHorizontalScrollIndicator = false
        scrollView1.showsVerticalScrollIndicator = false
        scrollView1.alwaysBounceHorizontal = true
//        scrollView1.contentSize = CGSize(width: totalScrollWidth, height: 60)
        scrollView1.isPagingEnabled = true
//        scrollView1.delegate = self
        
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
    
    func configure(data: String) {
        let scrollViewWidth = (viewWidth - 20.0*2)/2
        let scrollViewHeight = 60.0
        let totalScrollWidth = scrollViewWidth * 2
        
        if(data == "a") {
            vDataList.append("p")
            vDataList.append("p")
            vDataList.append("p")

            for _ in vDataList {
            
                let hd = HDiscoverSoundSizeMColumnViewCell(frame: CGRect(x: 0 , y: 0, width: scrollViewWidth, height: scrollViewHeight))
                scrollView1.addSubview(hd)
                hd.translatesAutoresizingMaskIntoConstraints = false
                hd.widthAnchor.constraint(equalToConstant: scrollViewWidth).isActive = true //180
                hd.heightAnchor.constraint(equalToConstant: scrollViewHeight).isActive = true //280
                hd.topAnchor.constraint(equalTo: scrollView1.topAnchor, constant: 0).isActive = true
                if(aHLightViewArray.isEmpty) {
                    hd.leadingAnchor.constraint(equalTo: scrollView1.leadingAnchor, constant: 0).isActive = true
                } else {
                    let lastArrayE = aHLightViewArray[aHLightViewArray.count - 1]
                    hd.leadingAnchor.constraint(equalTo: lastArrayE.trailingAnchor, constant: 0).isActive = true
                }
                aHLightViewArray.append(hd)
                hd.redrawUI()
                hd.configure(data: "")
                hd.aDelegate = self
            }
            
            let dataCount = vDataList.count
            
            let totalWidth = CGFloat(dataCount) * scrollViewWidth
            scrollView1.contentSize = CGSize(width: totalWidth, height: scrollViewHeight) //800, 280
        }
    }
    
    @objc func onErrorRefreshClicked(gesture: UITapGestureRecognizer) {
        self.errorText.isHidden = true
        self.errorRefreshBtn.isHidden = true
        
        bSpinner.startAnimating()
        asyncConfigure(data: "")
    }
}

extension DiscoverSoundSizeMHighlightCell: DiscoverColumnViewCellDelegate {
    func discoverColumnDidClickSound() {
        self.delegate?.didHighlightClickSound(id: "")
    }
    func discoverColumnDidClickUser(){
        
    }
    func discoverColumnDidClickPlace(){
//        self.delegate?.didHighlightClickPlace(id: "")
    }
}

//test > suggested places
class DiscoverPlaceSizeLHighlightCell: HighlightCell {
    
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
        aHLightRectBG.backgroundColor = .ddmDarkOverlayBlack //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.2 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
//        aHLightRectBG.isUserInteractionEnabled = true
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "Related Locations"
        
        let aPhoto = SDAnimatedImageView()
        aHLightRect1.addSubview(aPhoto)
        aPhoto.translatesAutoresizingMaskIntoConstraints = false
        aPhoto.widthAnchor.constraint(equalToConstant: 60).isActive = true //ori: 80
        aPhoto.heightAnchor.constraint(equalToConstant: 60).isActive = true
        aPhoto.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aPhoto.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 20).isActive = true
//                aPhoto.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -20).isActive = true
        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
//        let imageUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
        aPhoto.contentMode = .scaleAspectFill
        aPhoto.layer.masksToBounds = true
        aPhoto.layer.cornerRadius = 5
        aPhoto.sd_setImage(with: imageUrl)
        aPhoto.isUserInteractionEnabled = true
        aPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPlaceClicked)))
        
        let aHItemTitle = UILabel()
        aHItemTitle.textAlignment = .left
        aHItemTitle.textColor = .white
        aHItemTitle.font = .boldSystemFont(ofSize: 13) //13
        aHLightRect1.addSubview(aHItemTitle)
        aHItemTitle.translatesAutoresizingMaskIntoConstraints = false
        aHItemTitle.topAnchor.constraint(equalTo: aPhoto.topAnchor, constant: 10).isActive = true //5
        aHItemTitle.leadingAnchor.constraint(equalTo: aPhoto.trailingAnchor, constant: 10).isActive = true
        aHItemTitle.text = "KL Tower"
        
        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .left
        aHSubDesc.textColor = .ddmDarkGrayColor
        aHSubDesc.font = .systemFont(ofSize: 11)
        aHLightRect1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.topAnchor.constraint(equalTo: aHItemTitle.bottomAnchor, constant: 0).isActive = true //20
        aHSubDesc.leadingAnchor.constraint(equalTo: aPhoto.trailingAnchor, constant: 10).isActive = true
        aHSubDesc.text = "KL Ms"
//        aHSubDesc.layer.opacity = 0.4
        
        let rArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .ddmDarkGrayColor
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHItemTitle.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        rArrowBtn.layer.opacity = 0.5
        
        let aPhoto1A = SDAnimatedImageView()
        aHLightRect1.addSubview(aPhoto1A)
        aPhoto1A.translatesAutoresizingMaskIntoConstraints = false
        aPhoto1A.widthAnchor.constraint(equalToConstant: 60).isActive = true //ori: 80
        aPhoto1A.heightAnchor.constraint(equalToConstant: 60).isActive = true
        aPhoto1A.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aPhoto1A.topAnchor.constraint(equalTo: aPhoto.bottomAnchor, constant: 20).isActive = true
        aPhoto1A.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        aPhoto1A.contentMode = .scaleAspectFill
        aPhoto1A.layer.masksToBounds = true
        aPhoto1A.layer.cornerRadius = 5
        aPhoto1A.sd_setImage(with: imageUrl)
        
        let aHItem1ATitle = UILabel()
        aHItem1ATitle.textAlignment = .left
        aHItem1ATitle.textColor = .white
        aHItem1ATitle.font = .boldSystemFont(ofSize: 13) //13
        aHLightRect1.addSubview(aHItem1ATitle)
        aHItem1ATitle.translatesAutoresizingMaskIntoConstraints = false
        aHItem1ATitle.topAnchor.constraint(equalTo: aPhoto1A.topAnchor, constant: 10).isActive = true //5
        aHItem1ATitle.leadingAnchor.constraint(equalTo: aPhoto1A.trailingAnchor, constant: 10).isActive = true
        aHItem1ATitle.text = "Cafe Borfford"
        
        let aHSubDesc1A = UILabel()
        aHSubDesc1A.textAlignment = .left
        aHSubDesc1A.textColor = .ddmDarkGrayColor
        aHSubDesc1A.font = .systemFont(ofSize: 11)
        aHLightRect1.addSubview(aHSubDesc1A)
        aHSubDesc1A.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc1A.topAnchor.constraint(equalTo: aHItem1ATitle.bottomAnchor, constant: 0).isActive = true //20
        aHSubDesc1A.leadingAnchor.constraint(equalTo: aPhoto1A.trailingAnchor, constant: 10).isActive = true
        aHSubDesc1A.text = "CB Team"
//        aHSubDesc1A.layer.opacity = 0.4
        
        let rArrow1ABtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
        rArrow1ABtn.tintColor = .ddmDarkGrayColor
        aHLightRect1.addSubview(rArrow1ABtn)
        rArrow1ABtn.translatesAutoresizingMaskIntoConstraints = false
        rArrow1ABtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
        rArrow1ABtn.centerYAnchor.constraint(equalTo: aHItem1ATitle.centerYAnchor).isActive = true
        rArrow1ABtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrow1ABtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        rArrow1ABtn.layer.opacity = 0.5
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
    
    @objc func onPlaceClicked(gesture: UITapGestureRecognizer) {
        self.delegate?.didHighlightClickPlace(id: "")
    }
}

class DiscoverPlaceSizeMHighlightCell: HighlightCell {
    
    let aHLightRect1 = UIView()
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    let aTab1 = UIView()
    let aTab2 = UIView()
    let aHLightTitle = UILabel()
    let scrollView1 = UIScrollView()
    var vDataList = [String]()
    var aHLightViewArray = [UIView]()
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
        aHLightRectBG.backgroundColor = .ddmDarkOverlayBlack //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.2 //0.2, 0.1
//        aHLightRectBG.layer.opacity = 0.0 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
//        aHLightRectBG.isUserInteractionEnabled = true
        
//        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true //10
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "Related Locations"
//        aHLightTitle.text = "Suggested For You"
//        aHLightTitle.text = "Discover More Locations"
        
//        aTab1.backgroundColor = .white
//        aHLightRect1.addSubview(aTab1)
//        aTab1.translatesAutoresizingMaskIntoConstraints = false
//        aTab1.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -14).isActive = true //10
//        aTab1.centerYAnchor.constraint(equalTo: aHLightTitle.centerYAnchor).isActive = true
////                aTab1.trailingAnchor.constraint(equalTo: aHLightRect1.centerXAnchor, constant: 10).isActive = true //10
////                aTab1.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -4).isActive = true
//        aTab1.heightAnchor.constraint(equalToConstant: 3).isActive = true //2
//        aTab1.widthAnchor.constraint(equalToConstant: 5).isActive = true //10
//        aTab1.layer.opacity = 0.2 //0.5
//        aTab1.layer.cornerRadius = 1
//        
//        aTab2.backgroundColor = .white
//        aHLightRect1.addSubview(aTab2)
//        aTab2.translatesAutoresizingMaskIntoConstraints = false
//        aTab2.trailingAnchor.constraint(equalTo: aTab1.leadingAnchor, constant: -5).isActive = true
//        aTab2.centerYAnchor.constraint(equalTo: aTab1.centerYAnchor).isActive = true
//        aTab2.heightAnchor.constraint(equalToConstant: 3).isActive = true
//        aTab2.widthAnchor.constraint(equalToConstant: 5).isActive = true
//        aTab2.layer.opacity = 0.5 //0.5
//        aTab2.layer.cornerRadius = 1
        
        bSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        self.addSubview(bSpinner)
        bSpinner.translatesAutoresizingMaskIntoConstraints = false
        bSpinner.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 20).isActive = true
//        bSpinner.topAnchor.constraint(equalTo: footer.topAnchor, constant: 20).isActive = true
        bSpinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        bSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        bSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let scrollViewWidth = viewWidth - 20.0*2
//        let scrollViewWidth = 170.0
//        let totalScrollWidth = scrollViewWidth * 2
        
//        let scrollView1 = UIScrollView()
        aHLightRect1.addSubview(scrollView1)
        scrollView1.backgroundColor = .clear
        scrollView1.translatesAutoresizingMaskIntoConstraints = false
        scrollView1.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 20).isActive = true
        scrollView1.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        scrollView1.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        scrollView1.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true //-10
        scrollView1.heightAnchor.constraint(equalToConstant: 60).isActive = true //60
        scrollView1.showsHorizontalScrollIndicator = false
        scrollView1.showsVerticalScrollIndicator = false
        scrollView1.alwaysBounceHorizontal = true
//        scrollView1.contentSize = CGSize(width: totalScrollWidth, height: 60)
        scrollView1.isPagingEnabled = true
//        scrollView1.delegate = self
        
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
    
    func configure(data: String) {
        let scrollViewWidth = (viewWidth - 20.0*2)/2
        let scrollViewHeight = 60.0
        let totalScrollWidth = scrollViewWidth * 2
        
        if(data == "a") {
            vDataList.append("p")
            vDataList.append("p")
            vDataList.append("p")

            for _ in vDataList {
            
                let hd = HDiscoverPlaceSizeMColumnViewCell(frame: CGRect(x: 0 , y: 0, width: scrollViewWidth, height: scrollViewHeight))
                scrollView1.addSubview(hd)
                hd.translatesAutoresizingMaskIntoConstraints = false
                hd.widthAnchor.constraint(equalToConstant: scrollViewWidth).isActive = true //180
                hd.heightAnchor.constraint(equalToConstant: scrollViewHeight).isActive = true //280
                hd.topAnchor.constraint(equalTo: scrollView1.topAnchor, constant: 0).isActive = true
                if(aHLightViewArray.isEmpty) {
                    hd.leadingAnchor.constraint(equalTo: scrollView1.leadingAnchor, constant: 0).isActive = true
                } else {
                    let lastArrayE = aHLightViewArray[aHLightViewArray.count - 1]
                    hd.leadingAnchor.constraint(equalTo: lastArrayE.trailingAnchor, constant: 0).isActive = true
                }
                aHLightViewArray.append(hd)
                hd.redrawUI()
                hd.configure(data: "")
                hd.aDelegate = self
            }
            
            let dataCount = vDataList.count
            
            let totalWidth = CGFloat(dataCount) * scrollViewWidth
            scrollView1.contentSize = CGSize(width: totalWidth, height: scrollViewHeight) //800, 280
        }
    }

    @objc func onErrorRefreshClicked(gesture: UITapGestureRecognizer) {
        self.errorText.isHidden = true
        self.errorRefreshBtn.isHidden = true
        
        bSpinner.startAnimating()
        asyncConfigure(data: "")
    }
}

extension DiscoverPlaceSizeMHighlightCell: DiscoverColumnViewCellDelegate {
    func discoverColumnDidClickSound() {
        
    }
    func discoverColumnDidClickUser(){
        
    }
    func discoverColumnDidClickPlace(){
        self.delegate?.didHighlightClickPlace(id: "")
    }
}

class LatestMultiLoopsSizeMHighlightCell: HighlightCell {
    
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
        aHLightRectBG.backgroundColor = .ddmDarkOverlayBlack //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.2 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "Latest Loops"
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
        aScroll1.heightAnchor.constraint(equalToConstant: 70).isActive = true //80
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
        errorText.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true //test
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
        let scrollViewWidth = 50.0 //60
        let scrollViewHeight = 70.0 //80
        
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
    
    @objc func onErrorRefreshClicked(gesture: UITapGestureRecognizer) {
        self.errorText.isHidden = true
        self.errorRefreshBtn.isHidden = true
        
        bSpinner.startAnimating()
        asyncConfigure(data: "")
    }
}

//test > design for latest loop
class LatestLoopSizeMHighlightCell: HighlightCell {
    
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
        aHLightRectBG.backgroundColor = .ddmDarkOverlayBlack //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.2 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "Latest Loop"
//        aHLightTitle.isHidden = true
        
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
        
//        let scrollViewWidth = viewWidth - 20.0*2
        let aScroll1 = UIView()
        aHLightRect1.addSubview(aScroll1)
        aScroll1.translatesAutoresizingMaskIntoConstraints = false
//        aScroll1.widthAnchor.constraint(equalToConstant: scrollViewWidth).isActive = true //ori: 80
        aScroll1.heightAnchor.constraint(equalToConstant: 70).isActive = true //60
        aScroll1.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aScroll1.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        aScroll1.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true //20
        aScroll1.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        
        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
//        let imageUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
//        let imageUrl2 = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        
        let aGrid = UIView()
        aGrid.backgroundColor = .ddmDarkColor
        aHLightRect1.addSubview(aGrid)
        aGrid.translatesAutoresizingMaskIntoConstraints = false
        aGrid.leadingAnchor.constraint(equalTo: aScroll1.leadingAnchor, constant: 10).isActive = true
        aGrid.heightAnchor.constraint(equalToConstant: 70).isActive = true //60
        aGrid.widthAnchor.constraint(equalToConstant: 50).isActive = true //40
//        aGrid.topAnchor.constraint(equalTo: aPhoto.bottomAnchor, constant: 20).isActive = true
        aGrid.topAnchor.constraint(equalTo: aScroll1.topAnchor, constant: 0).isActive = true //30
        aGrid.layer.cornerRadius = 5 //10

        let gifImage = SDAnimatedImageView()
        gifImage.contentMode = .scaleAspectFill
        gifImage.layer.masksToBounds = true
        gifImage.layer.cornerRadius = 5 //10
        gifImage.sd_setImage(with: imageUrl) //temp disable picture
        aGrid.addSubview(gifImage)
        gifImage.translatesAutoresizingMaskIntoConstraints = false
        gifImage.topAnchor.constraint(equalTo: aGrid.topAnchor).isActive = true
        gifImage.leadingAnchor.constraint(equalTo: aGrid.leadingAnchor).isActive = true
        gifImage.bottomAnchor.constraint(equalTo: aGrid.bottomAnchor).isActive = true
        gifImage.trailingAnchor.constraint(equalTo: aGrid.trailingAnchor).isActive = true
        
        let aHItem1ATitle = UILabel()
        aHItem1ATitle.textAlignment = .left
        aHItem1ATitle.textColor = .white
        aHItem1ATitle.font = .boldSystemFont(ofSize: 13) //13
//        aHItem1ATitle.font = .systemFont(ofSize: 13) //13
        aHLightRect1.addSubview(aHItem1ATitle)
        aHItem1ATitle.translatesAutoresizingMaskIntoConstraints = false
        aHItem1ATitle.topAnchor.constraint(equalTo: aGrid.topAnchor, constant: 10).isActive = true //5
        aHItem1ATitle.leadingAnchor.constraint(equalTo: aGrid.trailingAnchor, constant: 10).isActive = true
        aHItem1ATitle.trailingAnchor.constraint(equalTo: aScroll1.trailingAnchor, constant: -40).isActive = true
        aHItem1ATitle.text = "Bitcoin ‘Halving’ Cuts Supply of New Tokens in Threat to Miners"
//        aHItem1ATitle.numberOfLines = 2
        
        let aHSubDesc1A = UILabel()
        aHSubDesc1A.textAlignment = .left
        aHSubDesc1A.textColor = .ddmDarkGrayColor
        aHSubDesc1A.font = .systemFont(ofSize: 12)
        aHLightRect1.addSubview(aHSubDesc1A)
        aHSubDesc1A.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc1A.topAnchor.constraint(equalTo: aHItem1ATitle.bottomAnchor, constant: 5).isActive = true //0
        aHSubDesc1A.leadingAnchor.constraint(equalTo: aGrid.trailingAnchor, constant: 10).isActive = true
        aHSubDesc1A.text = "105k"
//        aHSubDesc1A.layer.opacity = 0.4
        
        let rArrowBtn = UIImageView(image: UIImage(named:"icon_love")?.withRenderingMode(.alwaysTemplate))
        rArrowBtn.tintColor = .ddmDarkGrayColor
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.leadingAnchor.constraint(equalTo: aHSubDesc1A.trailingAnchor, constant: 5).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHSubDesc1A.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 14).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 14).isActive = true
//        rArrowBtn.layer.opacity = 0.4
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
}

class LatestMultiPhotosSizeMHighlightCell: HighlightCell {
    
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
        aHLightRectBG.backgroundColor = .ddmDarkOverlayBlack //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.2 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "Latest Shots"
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
        aHLightRect1.addSubview(aScroll1)
        aScroll1.translatesAutoresizingMaskIntoConstraints = false
//        aScroll1.widthAnchor.constraint(equalToConstant: scrollViewWidth).isActive = true //ori: 80
        aScroll1.heightAnchor.constraint(equalToConstant: 60).isActive = true //80
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
        errorText.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true //test
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
        let scrollViewWidth = 60.0 //70
        let scrollViewHeight = 60.0
        
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
    
    @objc func onErrorRefreshClicked(gesture: UITapGestureRecognizer) {
        self.errorText.isHidden = true
        self.errorRefreshBtn.isHidden = true
        
        bSpinner.startAnimating()
        asyncConfigure(data: "")
    }
}

class BaseLocationHighlightBox: HighlightCell {
    
    let aHLightRect1 = UIView()
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    let rGridBG = SDAnimatedImageView()
    let aHSubDesc = UILabel()
    let aHSubDesc2 = UILabel()
    let rArrowBtn = UIImageView()
    
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
//        aHLightRectBG.backgroundColor = .ddmDarkColor //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.2 //0.2, 0.1
//        aHLightRectBG.layer.opacity = 0.0 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        aHLightRectBG.isUserInteractionEnabled = true
        aHLightRectBG.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPlaceClicked)))
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
//        aHLightTitle.text = "Base"
        aHLightTitle.text = "Location"
        
        bSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        self.addSubview(bSpinner)
        bSpinner.translatesAutoresizingMaskIntoConstraints = false
        bSpinner.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
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
        rGridBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -20).isActive = true //-10
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
//        rGridBG.backgroundColor = .ddmDarkColor

//        let rText = UILabel()
//        rText.textAlignment = .left
//        rText.textColor = .white
//        rText.font = .boldSystemFont(ofSize: 13) //13
////        aHLightSection.addSubview(rText)
//        aHLightRect1.addSubview(rText)
//        rText.translatesAutoresizingMaskIntoConstraints = false
//        rText.leadingAnchor.constraint(equalTo: rGridBG.trailingAnchor, constant: 10).isActive = true
////        rText.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor, constant: 0).isActive = true
////                rText.centerYAnchor.constraint(equalTo: rGridBG.centerYAnchor, constant: 0).isActive = true
//        rText.topAnchor.constraint(equalTo: rGridBG.topAnchor, constant: 5).isActive = true //20
//        rText.text = "Top US 100 Hits Weekly "

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
//                aHSubDesc.layer.opacity = 0.7

//        let aHSubDescSymbol = UIImageView(image: UIImage(named:"icon_round_arrow_up")?.withRenderingMode(.alwaysTemplate))
//        aHSubDescSymbol.tintColor = .green
////        aHLightSection.addSubview(aHSubDescSymbol)
//        aHLightRect1.addSubview(aHSubDescSymbol)
//        aHSubDescSymbol.translatesAutoresizingMaskIntoConstraints = false
//        aHSubDescSymbol.leadingAnchor.constraint(equalTo: aHSubDesc.trailingAnchor, constant: 0).isActive = true
//        aHSubDescSymbol.centerYAnchor.constraint(equalTo: aHSubDesc.centerYAnchor).isActive = true
//        aHSubDescSymbol.heightAnchor.constraint(equalToConstant: 28).isActive = true
//        aHSubDescSymbol.widthAnchor.constraint(equalToConstant: 28).isActive = true
////                aHSubDescSymbol.layer.opacity = 0.5

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

        rArrowBtn.image = UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate)
        rArrowBtn.tintColor = .ddmDarkGrayColor
//        aHLightSection.addSubview(rArrowBtn)
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.leadingAnchor.constraint(equalTo: aHSubDesc.trailingAnchor, constant: 10).isActive = true
//        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
//                rArrowBtn.centerYAnchor.constraint(equalTo: rGridBG.centerYAnchor).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHSubDesc.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        rArrowBtn.layer.opacity = 0.5
        rArrowBtn.isHidden = true
        
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
        let id = "p_"
        DataFetchManager.shared.fetchPlaceData(id: id) { [weak self]result in
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
                    self.aHSubDesc2.text = "Base"
                    
                    let imageUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
                    self.rGridBG.sd_setImage(with: imageUrl)
                    self.rArrowBtn.isHidden = false
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    
                    guard let self = self else {
                        return
                    }
                    
                    self.bSpinner.stopAnimating()
                    
                    self.aHSubDesc.text = ""
                    self.aHSubDesc2.text = ""
                    
                    let imageUrl = URL(string: "")
                    self.rGridBG.sd_setImage(with: imageUrl)
                    self.rArrowBtn.isHidden = true
                    
                    //error handling e.g. refetch button
                    self.errorText.text = "Unable to load. Retry."
                    self.errorText.isHidden = false
                    self.errorRefreshBtn.isHidden = false
                }
                break
            }
        }
    }
    
    @objc func onPlaceClicked(gesture: UITapGestureRecognizer) {
        self.delegate?.didHighlightClickPlace(id: "")
    }
    
    @objc func onErrorRefreshClicked(gesture: UITapGestureRecognizer) {
        self.errorText.isHidden = true
        self.errorRefreshBtn.isHidden = true
        
        bSpinner.startAnimating()
        asyncConfigure(data: "")
    }
}

//test > design for bio or "about"
class AboutUserHighlightBox: HighlightCell {
    
    let aHLightRect1 = UIView()
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    let aHSubDesc = UILabel()
    let aHSubDesc2 = UILabel()
    let rArrowBtn = UIImageView()
    
    let bSpinner = SpinLoader()
    let linkBtn = UIImageView()
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
//        aHLightRectBG.backgroundColor = .ddmDarkColor //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.2 //0.2, 0.1
//        aHLightRectBG.layer.opacity = 0.0 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "About"

        bSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        self.addSubview(bSpinner)
        bSpinner.translatesAutoresizingMaskIntoConstraints = false
        bSpinner.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        bSpinner.topAnchor.constraint(equalTo: footer.topAnchor, constant: 20).isActive = true
        bSpinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        bSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        bSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
//        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .left
        aHSubDesc.textColor = .white //white
        aHSubDesc.font = .systemFont(ofSize: 13)
//        aHLightSection.addSubview(aHSubDesc)
        aHLightRect1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHSubDesc.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true //20
//        aHSubDesc.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        aHSubDesc.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -40).isActive = true
        aHSubDesc.text = " " //maintain height of text
//                aHSubDesc.layer.opacity = 0.7
        
//        let linkBtn = UIImageView()
//        linkBtn.image = UIImage(named:"icon_round_link")?.withRenderingMode(.alwaysTemplate)
        linkBtn.tintColor = .ddmDarkGrayColor
        aHLightRect1.addSubview(linkBtn)
        linkBtn.translatesAutoresizingMaskIntoConstraints = false
        linkBtn.topAnchor.constraint(equalTo: aHSubDesc.bottomAnchor, constant: 5).isActive = true //10
        linkBtn.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        linkBtn.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        linkBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        linkBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        linkBtn.layer.opacity = 0.4

//        let aHSubDesc2 = UILabel()
        aHSubDesc2.textAlignment = .left
        aHSubDesc2.textColor = .ddmDarkGrayColor
        aHSubDesc2.font = .boldSystemFont(ofSize: 13)
//        aHLightSection.addSubview(aHSubDesc2)
        aHLightRect1.addSubview(aHSubDesc2)
        aHSubDesc2.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc2.centerYAnchor.constraint(equalTo: linkBtn.centerYAnchor).isActive = true
        aHSubDesc2.leadingAnchor.constraint(equalTo: linkBtn.trailingAnchor, constant: 10).isActive = true
//        aHSubDesc2.topAnchor.constraint(equalTo: aHSubDesc.bottomAnchor, constant: 10).isActive = true //10
//        aHSubDesc2.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
//        aHSubDesc2.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        aHSubDesc2.text = " "
//        aHSubDesc2.layer.opacity = 0.4

        rArrowBtn.image = UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate)
        rArrowBtn.tintColor = .ddmDarkGrayColor
//        aHLightSection.addSubview(rArrowBtn)
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
//        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
//                rArrowBtn.centerYAnchor.constraint(equalTo: rGridBG.centerYAnchor).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHSubDesc.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        rArrowBtn.layer.opacity = 0.5
        rArrowBtn.isHidden = true
        
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
                    
                    self.aHSubDesc.text = "The latest financial news and market analysis, direct from Bloomberg TV."
                    self.aHSubDesc2.text = "youtube.com/@courtneyryan"
                    self.linkBtn.image = UIImage(named:"icon_round_link")?.withRenderingMode(.alwaysTemplate)
                    
                    self.rArrowBtn.isHidden = false
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    
                    guard let self = self else {
                        return
                    }
                    
                    self.bSpinner.stopAnimating()
                    
                    self.aHSubDesc.text = " "
                    self.aHSubDesc2.text = ""
                    self.linkBtn.image = nil
                    
                    self.rArrowBtn.isHidden = true
                    
                    //error handling e.g. refetch button
                    self.errorText.text = "Unable to load. Retry."
                    self.errorText.isHidden = false
                    self.errorRefreshBtn.isHidden = false
                }
                break
            }
        }
    }
    
    @objc func onErrorRefreshClicked(gesture: UITapGestureRecognizer) {
        self.errorText.isHidden = true
        self.errorRefreshBtn.isHidden = true
        
        bSpinner.startAnimating()
        asyncConfigure(data: "")
    }
}

//test > design for music
class AboutSoundHighlightBox: HighlightCell {
    
    let aHLightRect1 = UIView()
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    let aHLightTitle = UILabel()
    let aHSubDesc = UILabel()
    let aHSubDesc2 = UILabel()
    let rArrowBtn = UIImageView()
    
    let bSpinner = SpinLoader()
    
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
        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.2 //0.2, 0.1
//        aHLightRectBG.layer.opacity = 0.0 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        
        bSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        self.addSubview(bSpinner)
        bSpinner.translatesAutoresizingMaskIntoConstraints = false
        bSpinner.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        bSpinner.topAnchor.constraint(equalTo: footer.topAnchor, constant: 20).isActive = true
        bSpinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        bSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        bSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let playBtn = UIImageView(image: UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate))
        playBtn.tintColor = .white
        aHLightRect1.addSubview(playBtn)
        playBtn.translatesAutoresizingMaskIntoConstraints = false
        playBtn.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        playBtn.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        playBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        playBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
//        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 12)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.centerYAnchor.constraint(equalTo: playBtn.centerYAnchor, constant: 0).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: playBtn.trailingAnchor, constant: 10).isActive = true
        aHLightTitle.text = ""
        
//        let aHLightTitle = UILabel()
//        aHLightTitle.textAlignment = .left
//        aHLightTitle.textColor = .white
//        aHLightTitle.font = .boldSystemFont(ofSize: 14)
//        aHLightRect1.addSubview(aHLightTitle)
//        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
//        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
//        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
//        aHLightTitle.text = "About"

//        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .left
        aHSubDesc.textColor = .white //white
        aHSubDesc.font = .systemFont(ofSize: 13)
//        aHLightSection.addSubview(aHSubDesc)
        aHLightRect1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHSubDesc.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true //20
//        aHSubDesc.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        aHSubDesc.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -40).isActive = true
//        aHSubDesc.text = "The latest financial news and market analysis, direct from Bloomberg TV."
        aHSubDesc.text = " "
//                aHSubDesc.layer.opacity = 0.7
        
        let linkBtn = UIImageView()
        linkBtn.image = UIImage(named:"icon_round_link")?.withRenderingMode(.alwaysTemplate)
        linkBtn.tintColor = .ddmDarkGrayColor
        aHLightRect1.addSubview(linkBtn)
        linkBtn.translatesAutoresizingMaskIntoConstraints = false
        linkBtn.topAnchor.constraint(equalTo: aHSubDesc.bottomAnchor, constant: 5).isActive = true //10
        linkBtn.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        linkBtn.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        linkBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        linkBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        linkBtn.layer.opacity = 0.4

//        let aHSubDesc2 = UILabel()
        aHSubDesc2.textAlignment = .left
        aHSubDesc2.textColor = .ddmDarkGrayColor
        aHSubDesc2.font = .boldSystemFont(ofSize: 13)
//        aHLightSection.addSubview(aHSubDesc2)
        aHLightRect1.addSubview(aHSubDesc2)
        aHSubDesc2.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc2.centerYAnchor.constraint(equalTo: linkBtn.centerYAnchor).isActive = true
        aHSubDesc2.leadingAnchor.constraint(equalTo: linkBtn.trailingAnchor, constant: 10).isActive = true
//        aHSubDesc2.topAnchor.constraint(equalTo: aHSubDesc.bottomAnchor, constant: 10).isActive = true //10
//        aHSubDesc2.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
//        aHSubDesc2.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        aHSubDesc2.text = " "
//        aHSubDesc2.layer.opacity = 0.4

        rArrowBtn.image = UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate)
        rArrowBtn.tintColor = .ddmDarkGrayColor
//        aHLightSection.addSubview(rArrowBtn)
        aHLightRect1.addSubview(rArrowBtn)
        rArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        rArrowBtn.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
//        rArrowBtn.centerYAnchor.constraint(equalTo: aHLightRect1.centerYAnchor).isActive = true
//                rArrowBtn.centerYAnchor.constraint(equalTo: rGridBG.centerYAnchor).isActive = true
        rArrowBtn.centerYAnchor.constraint(equalTo: aHSubDesc.centerYAnchor).isActive = true
        rArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        rArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        rArrowBtn.layer.opacity = 0.5
        rArrowBtn.isHidden = true
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
                    
                    self.aHLightTitle.text = "00:29"
                    self.aHSubDesc.text = "Listen full version"
                    self.aHSubDesc2.text = "youtube.com/@courtneyryan"
                    
                    self.rArrowBtn.isHidden = false
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    
                    guard let self = self else {
                        return
                    }
                    
                    self.bSpinner.stopAnimating()
                    
                    self.aHLightTitle.text = "00:00"
                    self.aHSubDesc.text = "-"
                    self.aHSubDesc2.text = "-"
                    
                    self.rArrowBtn.isHidden = true
                }
                break
            }
        }
    }
}

//test > design for no posts
class UserEmptyPostHighlightBox: HighlightCell {
    
    let aHLightRect1 = UIView()
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    let aHLightTitle = UILabel()
    let aHSubDesc = UILabel()
    
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
//        aHLightRectBG.backgroundColor = .ddmDarkColor //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.2 //0.2, 0.1
//        aHLightRectBG.layer.opacity = 0.0 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        
//        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true //10
//        aHLightTitle.centerXAnchor.constraint(equalTo: aHLightRect1.centerXAnchor, constant: 0).isActive = true //10
//        aHLightTitle.text = "Post Status"
        aHLightTitle.text = "Updates"
        
        bSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        self.addSubview(bSpinner)
        bSpinner.translatesAutoresizingMaskIntoConstraints = false
//        bSpinner.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        bSpinner.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true
        bSpinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        bSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        bSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true

//        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .left
        aHSubDesc.textColor = .white //white
        aHSubDesc.font = .systemFont(ofSize: 13)
//        aHLightSection.addSubview(aHSubDesc)
        aHLightRect1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true //10
//        aHSubDesc.centerXAnchor.constraint(equalTo: aHLightRect1.centerXAnchor, constant: 0).isActive = true
        aHSubDesc.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true
        aHSubDesc.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -20).isActive = true //-20
        aHSubDesc.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
        aHSubDesc.text = " "
//                aHSubDesc.layer.opacity = 0.7
        
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
                    
                    self.aHLightTitle.text = "No Post Yet"
                    self.aHSubDesc.text = "This account has not posted any."
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    
                    guard let self = self else {
                        return
                    }
                    
                    self.bSpinner.stopAnimating()
                    
//                    self.aHLightTitle.text = " "
                    self.aHSubDesc.text = " "
                    
                    //error handling e.g. refetch button
                    self.errorText.text = "Unable to load. Retry."
                    self.errorText.isHidden = false
                    self.errorRefreshBtn.isHidden = false
                }
                break
            }
        }
    }
    
    @objc func onErrorRefreshClicked(gesture: UITapGestureRecognizer) {
        self.errorText.isHidden = true
        self.errorRefreshBtn.isHidden = true
        
        bSpinner.startAnimating()
        asyncConfigure(data: "")
    }
}

class SoundEmptyPostHighlightBox: HighlightCell {
    
    let aHLightRect1 = UIView()
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    let aHLightTitle = UILabel()
    let aHSubDesc = UILabel()
    
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
//        aHLightRectBG.backgroundColor = .ddmDarkColor //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.2 //0.2, 0.1
//        aHLightRectBG.layer.opacity = 0.0 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        
//        let playBtn = UIImageView(image: UIImage(named:"icon_round_play")?.withRenderingMode(.alwaysTemplate))
//        playBtn.tintColor = .white
//        aHLightRect1.addSubview(playBtn)
//        playBtn.translatesAutoresizingMaskIntoConstraints = false
//        playBtn.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
//        playBtn.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
//        playBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        playBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
//
//        let aHLightTitle = UILabel()
//        aHLightTitle.textAlignment = .left
//        aHLightTitle.textColor = .white
//        aHLightTitle.font = .boldSystemFont(ofSize: 12)
//        aHLightRect1.addSubview(aHLightTitle)
//        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
//        aHLightTitle.centerYAnchor.constraint(equalTo: playBtn.centerYAnchor, constant: 0).isActive = true
//        aHLightTitle.leadingAnchor.constraint(equalTo: playBtn.trailingAnchor, constant: 10).isActive = true
//        aHLightTitle.text = "00:29"
        
//        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.text = "Updates"
        
        bSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        self.addSubview(bSpinner)
        bSpinner.translatesAutoresizingMaskIntoConstraints = false
//        bSpinner.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        bSpinner.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true
        bSpinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        bSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        bSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
//        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .left
        aHSubDesc.textColor = .white //white
        aHSubDesc.font = .systemFont(ofSize: 13)
//        aHSubDesc.font = .boldSystemFont(ofSize: 13)
//        aHLightSection.addSubview(aHSubDesc)
        aHLightRect1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHSubDesc.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true //20
        aHSubDesc.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -20).isActive = true
        aHSubDesc.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -40).isActive = true
//        aHSubDesc.text = "The latest financial news and market analysis, direct from Bloomberg TV."
        aHSubDesc.text = " "
//                aHSubDesc.layer.opacity = 0.7
        
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
                    
                    self.aHLightTitle.text = "No Post Yet"
                    self.aHSubDesc.text = "Create with this Sound"
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    
                    guard let self = self else {
                        return
                    }
                    
                    self.bSpinner.stopAnimating()
                    
//                    self.aHLightTitle.text = "-"
                    self.aHSubDesc.text = " "
                    
                    //error handling e.g. refetch button
                    self.errorText.text = "Unable to load. Retry."
                    self.errorText.isHidden = false
                    self.errorRefreshBtn.isHidden = false
                }
                break
            }
        }
    }
    
    @objc func onErrorRefreshClicked(gesture: UITapGestureRecognizer) {
        self.errorText.isHidden = true
        self.errorRefreshBtn.isHidden = true
        
        bSpinner.startAnimating()
        asyncConfigure(data: "")
    }
}

//test > design for private account
class UserPrivateAccountHighlightBox: HighlightCell {
    
    let aHLightRect1 = UIView()
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    let aHLightTitle = UILabel()
    let aHSubDesc = UILabel()
    
    let bSpinner = SpinLoader()
    
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
        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.2 //0.2, 0.1
//        aHLightRectBG.layer.opacity = 0.0 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        
        bSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        self.addSubview(bSpinner)
        bSpinner.translatesAutoresizingMaskIntoConstraints = false
        bSpinner.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        bSpinner.topAnchor.constraint(equalTo: footer.topAnchor, constant: 20).isActive = true
        bSpinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        bSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        bSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let lockBtn = UIImageView()
        lockBtn.image = UIImage(named:"icon_round_lock")?.withRenderingMode(.alwaysTemplate)
        lockBtn.tintColor = .white
        aHLightRect1.addSubview(lockBtn)
        lockBtn.translatesAutoresizingMaskIntoConstraints = false
        lockBtn.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
        lockBtn.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        lockBtn.heightAnchor.constraint(equalToConstant: 16).isActive = true //18
        lockBtn.widthAnchor.constraint(equalToConstant: 16).isActive = true
//        lockBtn.layer.opacity = 0.4
        
//        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .left
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
//        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 10).isActive = true
//        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
        aHLightTitle.leadingAnchor.constraint(equalTo: lockBtn.trailingAnchor, constant: 10).isActive = true
//        aHLightTitle.centerYAnchor.constraint(equalTo: lockBtn.centerYAnchor, constant: 0).isActive = true
        aHLightTitle.bottomAnchor.constraint(equalTo: lockBtn.bottomAnchor, constant: 0).isActive = true
//        aHLightTitle.text = "This account is private"
        aHLightTitle.text = "Private Account"

//        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .left
        aHSubDesc.textColor = .white //white
        aHSubDesc.font = .systemFont(ofSize: 13)
//        aHLightSection.addSubview(aHSubDesc)
        aHLightRect1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true
//        aHSubDesc.leadingAnchor.constraint(equalTo: aHLightTitle.leadingAnchor, constant: 0).isActive = true
        aHSubDesc.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true //20
        aHSubDesc.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -20).isActive = true //-10
        aHSubDesc.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -40).isActive = true
        aHSubDesc.text = "Follow to see @michelle posts"
//                aHSubDesc.layer.opacity = 0.7
    }
    
    //test > initialization state
    var isInitialized = false
    func initialize() {
        if(!isInitialized) {
            redrawUI()
            
            bSpinner.startAnimating()
//            asyncConfigure(data: "")
        }

        isInitialized = true
    }
}

//test > design for user profile fetch error
class FetchErrorHighlightBox: HighlightCell {
//class UserFetchErrorHighlightBox: UIView {
    
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
//        aHLightRectBG.backgroundColor = .ddmDarkColor //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.2 //0.2, 0.1
//        aHLightRectBG.layer.opacity = 0.0 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .center
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 40).isActive = true //10
//        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true //10
        aHLightTitle.centerXAnchor.constraint(equalTo: aHLightRect1.centerXAnchor, constant: 0).isActive = true //10
//        aHLightTitle.text = "Post Status"
        aHLightTitle.text = "Error Loading Data"

        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .center
        aHSubDesc.textColor = .white //white
        aHSubDesc.font = .systemFont(ofSize: 13)
//        aHLightSection.addSubview(aHSubDesc)
        aHLightRect1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true //10
//        aHSubDesc.centerXAnchor.constraint(equalTo: aHLightRect1.centerXAnchor, constant: 0).isActive = true
        aHSubDesc.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true //10
//        aHSubDesc.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -20).isActive = true //-10
        aHSubDesc.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
        aHSubDesc.text = "Something went wrong. Try again."
//                aHSubDesc.layer.opacity = 0.7
        
        let aBtn = UIView()
//        aBtn.backgroundColor = .yellow //test to remove color
        aBtn.backgroundColor = .ddmDarkColor //test to remove color
        aHLightRect1.addSubview(aBtn)
        aBtn.translatesAutoresizingMaskIntoConstraints = false
        aBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
        aBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        aBtn.centerXAnchor.constraint(equalTo: aHLightRect1.centerXAnchor, constant: 0).isActive = true
        aBtn.topAnchor.constraint(equalTo: aHSubDesc.bottomAnchor, constant: 10).isActive = true
        aBtn.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -40).isActive = true //-20
        aBtn.layer.cornerRadius = 20
//        aBtn.layer.opacity = 0.3
        aBtn.isUserInteractionEnabled = true
        aBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onRefreshClicked)))

        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_refresh")?.withRenderingMode(.alwaysTemplate))
//        bMiniBtn.tintColor = .black
        bMiniBtn.tintColor = .white
        aBtn.addSubview(bMiniBtn)
        bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        bMiniBtn.centerXAnchor.constraint(equalTo: aBtn.centerXAnchor).isActive = true
        bMiniBtn.centerYAnchor.constraint(equalTo: aBtn.centerYAnchor).isActive = true
        bMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        bMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
    }
    
    var isInitialized = false
    func initialize() {
        if(!isInitialized) {
            redrawUI()
        }

        isInitialized = true
    }
    
    @objc func onRefreshClicked(gesture: UITapGestureRecognizer) {
        self.delegate?.didHighlightClickRefresh()
    }
}
//test > design for user profile suspended
class UserSuspendedHighlightBox: HighlightCell {
    
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
//        aHLightRectBG.backgroundColor = .ddmDarkColor //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.2 //0.2, 0.1
//        aHLightRectBG.layer.opacity = 0.0 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .center
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 40).isActive = true //10
//        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true //10
        aHLightTitle.centerXAnchor.constraint(equalTo: aHLightRect1.centerXAnchor, constant: 0).isActive = true //10
//        aHLightTitle.text = "Post Status"
        aHLightTitle.text = "User Account Suspended"

        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .center
        aHSubDesc.textColor = .white //white
        aHSubDesc.font = .systemFont(ofSize: 13)
//        aHLightSection.addSubview(aHSubDesc)
        aHLightRect1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true //10
//        aHSubDesc.centerXAnchor.constraint(equalTo: aHLightRect1.centerXAnchor, constant: 0).isActive = true
        aHSubDesc.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true
        aHSubDesc.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -40).isActive = true //-20
        aHSubDesc.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
        aHSubDesc.text = "Account violated community rules."
//                aHSubDesc.layer.opacity = 0.7
    }
    
    var isInitialized = false
    func initialize() {
        if(!isInitialized) {
            redrawUI()
        }

        isInitialized = true
    }
}

//test > design for no user data found
class UserNotFoundHighlightBox: HighlightCell {
    
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
//        aHLightRectBG.backgroundColor = .ddmDarkColor //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.2 //0.2, 0.1
//        aHLightRectBG.layer.opacity = 0.0 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .center
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 40).isActive = true //10
//        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true //10
        aHLightTitle.centerXAnchor.constraint(equalTo: aHLightRect1.centerXAnchor, constant: 0).isActive = true //10
//        aHLightTitle.text = "Post Status"
        aHLightTitle.text = "User Not Found"

        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .center
        aHSubDesc.textColor = .white //white
        aHSubDesc.font = .systemFont(ofSize: 13)
//        aHLightSection.addSubview(aHSubDesc)
        aHLightRect1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true //10
//        aHSubDesc.centerXAnchor.constraint(equalTo: aHLightRect1.centerXAnchor, constant: 0).isActive = true
        aHSubDesc.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true
        aHSubDesc.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -40).isActive = true //-20
        aHSubDesc.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
        aHSubDesc.text = "This account does not exist."
//                aHSubDesc.layer.opacity = 0.7
    }
    
    var isInitialized = false
    func initialize() {
        if(!isInitialized) {
            redrawUI()
        }

        isInitialized = true
    }
}

//test > design for no place data found
class PlaceNotFoundHighlightBox: HighlightCell {
    
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
//        aHLightRectBG.backgroundColor = .ddmDarkColor //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.2 //0.2, 0.1
//        aHLightRectBG.layer.opacity = 0.0 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .center
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 40).isActive = true //10
//        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true //10
        aHLightTitle.centerXAnchor.constraint(equalTo: aHLightRect1.centerXAnchor, constant: 0).isActive = true //10
//        aHLightTitle.text = "Post Status"
        aHLightTitle.text = "Location Not Found"

        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .center
        aHSubDesc.textColor = .white //white
        aHSubDesc.font = .systemFont(ofSize: 13)
//        aHLightSection.addSubview(aHSubDesc)
        aHLightRect1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true //10
//        aHSubDesc.centerXAnchor.constraint(equalTo: aHLightRect1.centerXAnchor, constant: 0).isActive = true
        aHSubDesc.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true
        aHSubDesc.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -40).isActive = true //-20
        aHSubDesc.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
        aHSubDesc.text = "This location does not exist."
//                aHSubDesc.layer.opacity = 0.7
    }
    
    var isInitialized = false
    func initialize() {
        if(!isInitialized) {
            redrawUI()
        }

        isInitialized = true
    }
}

//test > design for place suspended
class PlaceSuspendedHighlightBox: HighlightCell {
    
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
//        aHLightRectBG.backgroundColor = .ddmDarkColor //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.2 //0.2, 0.1
//        aHLightRectBG.layer.opacity = 0.0 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .center
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 40).isActive = true //10
//        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true //10
        aHLightTitle.centerXAnchor.constraint(equalTo: aHLightRect1.centerXAnchor, constant: 0).isActive = true //10
//        aHLightTitle.text = "Post Status"
        aHLightTitle.text = "Location Suspended"

        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .center
        aHSubDesc.textColor = .white //white
        aHSubDesc.font = .systemFont(ofSize: 13)
//        aHLightSection.addSubview(aHSubDesc)
        aHLightRect1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true //10
//        aHSubDesc.centerXAnchor.constraint(equalTo: aHLightRect1.centerXAnchor, constant: 0).isActive = true
        aHSubDesc.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true
        aHSubDesc.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -40).isActive = true //-20
        aHSubDesc.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
        aHSubDesc.text = "It violated community rules."
//                aHSubDesc.layer.opacity = 0.7
    }
    
    var isInitialized = false
    func initialize() {
        if(!isInitialized) {
            redrawUI()
        }

        isInitialized = true
    }
}

//test > design for no place data found
class SoundNotFoundHighlightBox: HighlightCell {
    
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
//        aHLightRectBG.backgroundColor = .ddmDarkColor //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.2 //0.2, 0.1
//        aHLightRectBG.layer.opacity = 0.0 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .center
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 40).isActive = true //10
//        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true //10
        aHLightTitle.centerXAnchor.constraint(equalTo: aHLightRect1.centerXAnchor, constant: 0).isActive = true //10
//        aHLightTitle.text = "Post Status"
        aHLightTitle.text = "Sound Not Found"

        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .center
        aHSubDesc.textColor = .white //white
        aHSubDesc.font = .systemFont(ofSize: 13)
//        aHLightSection.addSubview(aHSubDesc)
        aHLightRect1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true //10
//        aHSubDesc.centerXAnchor.constraint(equalTo: aHLightRect1.centerXAnchor, constant: 0).isActive = true
        aHSubDesc.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true
        aHSubDesc.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -40).isActive = true //-20
        aHSubDesc.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
        aHSubDesc.text = "This sound does not exist."
//                aHSubDesc.layer.opacity = 0.7
    }
    
    var isInitialized = false
    func initialize() {
        if(!isInitialized) {
            redrawUI()
        }

        isInitialized = true
    }
}

//test > design for sound suspended
class SoundSuspendedHighlightBox: HighlightCell {
    
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
//        aHLightRectBG.backgroundColor = .ddmDarkColor //.ddmDarkColor
        aHLightRect1.addSubview(aHLightRectBG)
        aHLightRectBG.layer.cornerRadius = 10 //10
//        aHLightRectBG.layer.opacity = 0.2 //0.2, 0.1
//        aHLightRectBG.layer.opacity = 0.0 //0.2, 0.1
        aHLightRectBG.translatesAutoresizingMaskIntoConstraints = false
        aHLightRectBG.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 0).isActive = true
        aHLightRectBG.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 0).isActive = true //5
        aHLightRectBG.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: 0).isActive = true
        aHLightRectBG.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: 0).isActive = true
        
        let aHLightTitle = UILabel()
        aHLightTitle.textAlignment = .center
        aHLightTitle.textColor = .white
        aHLightTitle.font = .boldSystemFont(ofSize: 14)
        aHLightRect1.addSubview(aHLightTitle)
        aHLightTitle.translatesAutoresizingMaskIntoConstraints = false
        aHLightTitle.topAnchor.constraint(equalTo: aHLightRect1.topAnchor, constant: 40).isActive = true //10
//        aHLightTitle.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true //10
        aHLightTitle.centerXAnchor.constraint(equalTo: aHLightRect1.centerXAnchor, constant: 0).isActive = true //10
//        aHLightTitle.text = "Post Status"
        aHLightTitle.text = "Sound Suspended"

        let aHSubDesc = UILabel()
        aHSubDesc.textAlignment = .center
        aHSubDesc.textColor = .white //white
        aHSubDesc.font = .systemFont(ofSize: 13)
//        aHLightSection.addSubview(aHSubDesc)
        aHLightRect1.addSubview(aHSubDesc)
        aHSubDesc.translatesAutoresizingMaskIntoConstraints = false
        aHSubDesc.leadingAnchor.constraint(equalTo: aHLightRect1.leadingAnchor, constant: 10).isActive = true //10
//        aHSubDesc.centerXAnchor.constraint(equalTo: aHLightRect1.centerXAnchor, constant: 0).isActive = true
        aHSubDesc.topAnchor.constraint(equalTo: aHLightTitle.bottomAnchor, constant: 10).isActive = true
        aHSubDesc.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -40).isActive = true //-20
        aHSubDesc.trailingAnchor.constraint(equalTo: aHLightRect1.trailingAnchor, constant: -10).isActive = true
        aHSubDesc.text = "It violated community rules."
//                aHSubDesc.layer.opacity = 0.7
    }
    
    var isInitialized = false
    func initialize() {
        if(!isInitialized) {
            redrawUI()
        }

        isInitialized = true
    }
}
