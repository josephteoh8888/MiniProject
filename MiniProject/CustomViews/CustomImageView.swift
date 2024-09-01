//
//  CustomImageView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 27/08/2024.
//

import Foundation
import UIKit
import SDWebImage

protocol CustomImageViewDelegate : AnyObject {
    func customImageViewClickPhoto()
    func customImageViewDoubleClickPhoto(pointX: CGFloat, pointY: CGFloat)
}

//test > custom image view to show rendering spin loader, error fetching etc
class CustomImageView: UIView {
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    let imageView = SDAnimatedImageView()
    let bSpinner = SpinLoader()
    let errorText = UILabel()
    let errorRefreshBtn = UIView()
    
    weak var aDelegate : CustomImageViewDelegate?
    
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
//        self.backgroundColor = .black
        self.backgroundColor = .ddmDarkColor
        
        bSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        self.addSubview(bSpinner)
        bSpinner.translatesAutoresizingMaskIntoConstraints = false
            bSpinner.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        bSpinner.topAnchor.constraint(equalTo: footer.topAnchor, constant: 20).isActive = true
        bSpinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        bSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        bSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
//        let gifUrl = URL(string: "https://i3.ytimg.com/vi/2mcGhpbWlyg/maxresdefault.jpg")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
//        imageView.sd_setImage(with: gifUrl)
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true //180
//        imageView.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true //280
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPhotoClicked)))
        imageView.isHidden = true
        
        //test > error handling
        errorText.textAlignment = .center //left
        errorText.textColor = .white
        errorText.font = .systemFont(ofSize: 13)
        self.addSubview(errorText)
        errorText.clipsToBounds = true
        errorText.translatesAutoresizingMaskIntoConstraints = false
        errorText.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -20).isActive = true
//        errorText.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
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
    
    @objc func onErrorRefreshClicked(gesture: UITapGestureRecognizer) {
        print("customimageview refetch clicked")
        
        refetchAsset(url: "_")
        
    }
    @objc func onPhotoClicked(gesture: UITapGestureRecognizer) {
        print("customimageview clicked")
        aDelegate?.customImageViewClickPhoto()
    }
    
    var assetUrl = ""
    func setImage(url : String) {
//        let gifUrl = URL(string: url)
//        imageView.sd_setImage(with: gifUrl)
        assetUrl = url
        bSpinner.startAnimating()
        
        asyncConfigure(url: url)
    }
    
    func refetchAsset(url : String) {
        
        let gifUrl = URL(string: "")
        self.imageView.sd_setImage(with: gifUrl)
        self.imageView.isHidden = true
        
        self.errorText.isHidden = true
        self.errorRefreshBtn.isHidden = true
        
        bSpinner.startAnimating()
        asyncConfigure(url: assetUrl)
    }
    
    //*test > async load photo
    func asyncConfigure(url: String) {
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
                    
                    self.errorText.isHidden = true
                    self.errorRefreshBtn.isHidden = true
                    
                    let gifUrl = URL(string: url)
                    self.imageView.sd_setImage(with: gifUrl)
                    self.imageView.isHidden = false
                    
                    //add blurring for sensitive content
                    
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    
                    guard let self = self else {
                        return
                    }
                    self.bSpinner.stopAnimating()
                    
                    self.imageView.isHidden = true
                    
                    //error handling e.g. refetch button
                    self.errorText.text = "Unable to load. Retry."
                    self.errorText.isHidden = false
                    self.errorRefreshBtn.isHidden = false
                }
                break
            }
        }
    }
    //*
}

//test > custom image view for double tap capability
class CustomDoubleTapImageView: UIView {
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    let imageView = SDAnimatedImageView()
    let bSpinner = SpinLoader()
    let errorText = UILabel()
    let errorRefreshBtn = UIView()
    
    weak var aDelegate : CustomImageViewDelegate?
    
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
//        self.backgroundColor = .ddmBlackOverlayColor
        self.backgroundColor = .ddmDarkColor
        
        bSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        self.addSubview(bSpinner)
        bSpinner.translatesAutoresizingMaskIntoConstraints = false
            bSpinner.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        bSpinner.topAnchor.constraint(equalTo: footer.topAnchor, constant: 20).isActive = true
        bSpinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        bSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        bSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
//        let gifUrl = URL(string: "https://i3.ytimg.com/vi/2mcGhpbWlyg/maxresdefault.jpg")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
//        imageView.sd_setImage(with: gifUrl)
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true //180
//        imageView.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true //280
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        imageView.isUserInteractionEnabled = true
//        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPhotoClicked)))
        imageView.isHidden = true
        
        let atapGR = UITapGestureRecognizer(target: self, action: #selector(onPhotoClicked))
        atapGR.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(atapGR)
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(onDoubleClicked))
        tapGR.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(tapGR)
        atapGR.require(toFail: tapGR) //enable double tap
        
        //test > error handling
        errorText.textAlignment = .center //left
        errorText.textColor = .white
        errorText.font = .systemFont(ofSize: 13)
        self.addSubview(errorText)
        errorText.clipsToBounds = true
        errorText.translatesAutoresizingMaskIntoConstraints = false
        errorText.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -20).isActive = true
//        errorText.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        errorText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        errorText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        errorText.text = ""
        errorText.numberOfLines = 0
        errorText.isHidden = true
        
        errorRefreshBtn.backgroundColor = .ddmDarkColor //test to remove color
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
    
    @objc func onErrorRefreshClicked(gesture: UITapGestureRecognizer) {
        print("customimageview refetch clicked")
        
        refetchAsset(url: "_")
        
    }
    @objc func onPhotoClicked(gesture: UITapGestureRecognizer) {
        print("customimageview clicked")
        aDelegate?.customImageViewClickPhoto()
    }
    @objc func onDoubleClicked(gesture: UITapGestureRecognizer) {
        print("customimageview double clicked")
//        aDelegate?.customImageViewClickPhoto()
        
        let translation = gesture.location(in: self)
        let x = translation.x
        let y = translation.y
        aDelegate?.customImageViewDoubleClickPhoto(pointX: x, pointY: y)
    }
    
    var assetUrl = ""
    func setImage(url : String) {
//        let gifUrl = URL(string: url)
//        imageView.sd_setImage(with: gifUrl)
        assetUrl = url
        bSpinner.startAnimating()
        
        asyncConfigure(url: url)
    }
    
    func refetchAsset(url : String) {
        
        let gifUrl = URL(string: "")
        self.imageView.sd_setImage(with: gifUrl)
        self.imageView.isHidden = true
        
        self.errorText.isHidden = true
        self.errorRefreshBtn.isHidden = true
        
        bSpinner.startAnimating()
        asyncConfigure(url: assetUrl)
    }
    
    //*test > async load photo
    func asyncConfigure(url: String) {
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
                    
                    self.errorText.isHidden = true
                    self.errorRefreshBtn.isHidden = true
                    
                    let gifUrl = URL(string: url)
                    self.imageView.sd_setImage(with: gifUrl)
                    self.imageView.isHidden = false
                    
                    //add blurring for sensitive content
                    
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    
                    guard let self = self else {
                        return
                    }
                    self.bSpinner.stopAnimating()
                    
                    self.imageView.isHidden = true
                    
                    //error handling e.g. refetch button
                    self.errorText.text = "Unable to load. Retry."
                    self.errorText.isHidden = false
                    self.errorRefreshBtn.isHidden = false
                }
                break
            }
        }
    }
    //*
}
