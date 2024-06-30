//
//  GetLocationMsg.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

protocol GetLocationMsgDelegate : AnyObject {
    func didGLClickProceed()
    func didGLClickDeny()
}
class GetLocationMsgView: UIView{

    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    let getLocationPromptMsg = UIView()
    weak var delegate : GetLocationMsgDelegate?

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
        self.addSubview(getLocationPromptMsg)
        getLocationPromptMsg.translatesAutoresizingMaskIntoConstraints = false
        getLocationPromptMsg.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        getLocationPromptMsg.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        getLocationPromptMsg.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        getLocationPromptMsg.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        getLocationPromptMsg.isHidden = true

        let getLocationPromptMsgBG = UIView()
        getLocationPromptMsg.addSubview(getLocationPromptMsgBG)
        getLocationPromptMsgBG.backgroundColor = .ddmBlackOverlayColor
        getLocationPromptMsgBG.layer.opacity = 0.3
        getLocationPromptMsgBG.translatesAutoresizingMaskIntoConstraints = false
        getLocationPromptMsgBG.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        getLocationPromptMsgBG.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        getLocationPromptMsgBG.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        getLocationPromptMsgBG.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

        let gBox = UIView()
        getLocationPromptMsg.addSubview(gBox)
        gBox.translatesAutoresizingMaskIntoConstraints = false
        gBox.centerXAnchor.constraint(equalTo: getLocationPromptMsg.centerXAnchor).isActive = true
        gBox.centerYAnchor.constraint(equalTo: getLocationPromptMsg.centerYAnchor, constant: -60).isActive = true
        gBox.leadingAnchor.constraint(equalTo: getLocationPromptMsg.leadingAnchor, constant: 50).isActive = true
        gBox.trailingAnchor.constraint(equalTo: getLocationPromptMsg.trailingAnchor, constant: -50).isActive = true
//        gBox.backgroundColor = .ddmBlackOverlayColor
        gBox.backgroundColor = .white
        gBox.layer.cornerRadius = 15

        let gTitleText = UILabel()
        gTitleText.textAlignment = .center
//        gTitleText.textColor = .white
        gTitleText.textColor = .ddmBlackOverlayColor
        gTitleText.font = .boldSystemFont(ofSize: 16)
        gBox.addSubview(gTitleText)
        gTitleText.translatesAutoresizingMaskIntoConstraints = false
//        gTitleText.centerYAnchor.constraint(equalTo: gBox.centerYAnchor).isActive = true
        gTitleText.topAnchor.constraint(equalTo: gBox.topAnchor, constant: 30).isActive = true
//        gTitleText.bottomAnchor.constraint(equalTo: gBox.bottomAnchor, constant: -10).isActive = true
        gTitleText.leadingAnchor.constraint(equalTo: gBox.leadingAnchor, constant: 20).isActive = true
        gTitleText.trailingAnchor.constraint(equalTo: gBox.trailingAnchor, constant: -20).isActive = true
        gTitleText.numberOfLines = 0
        gTitleText.text = "MiniApp wants to use your location" //Cybermap

        let gDetailText = UILabel()
        gDetailText.textAlignment = .center
//        gDetailText.textColor = .white
        gDetailText.textColor = .ddmBlackOverlayColor
        gDetailText.font = .systemFont(ofSize: 13)
        gBox.addSubview(gDetailText)
        gDetailText.translatesAutoresizingMaskIntoConstraints = false
//        gTitleText.centerYAnchor.constraint(equalTo: gBox.centerYAnchor).isActive = true
        gDetailText.topAnchor.constraint(equalTo: gTitleText.bottomAnchor, constant: 10).isActive = true
//        gDetailText.bottomAnchor.constraint(equalTo: gBox.bottomAnchor, constant: -30).isActive = true
        gDetailText.leadingAnchor.constraint(equalTo: gBox.leadingAnchor, constant: 60).isActive = true
        gDetailText.trailingAnchor.constraint(equalTo: gBox.trailingAnchor, constant: -60).isActive = true
        gDetailText.numberOfLines = 0
        gDetailText.text = "MiniApp uses your location for showing relevant content near you" //Cybermap

        let gBtn = UIView()
        gBox.addSubview(gBtn)
        gBtn.backgroundColor = .yellow
        gBtn.translatesAutoresizingMaskIntoConstraints = false
        gBtn.leadingAnchor.constraint(equalTo: gBox.leadingAnchor, constant: 50).isActive = true
        gBtn.trailingAnchor.constraint(equalTo: gBox.trailingAnchor, constant: -50).isActive = true
        gBtn.topAnchor.constraint(equalTo: gDetailText.bottomAnchor, constant: 30).isActive = true
//        gBtn.bottomAnchor.constraint(equalTo: gBox.bottomAnchor, constant: -30).isActive = true
        gBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        gBtn.layer.cornerRadius = 10
        gBtn.isUserInteractionEnabled = true
        gBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onGetLocationProceedClicked)))

        let gBtnText = UILabel()
        gBtnText.textAlignment = .center
        gBtnText.textColor = .black
        gBtnText.font = .boldSystemFont(ofSize: 13)
        gBox.addSubview(gBtnText)
        gBtnText.translatesAutoresizingMaskIntoConstraints = false
//        gBtnText.topAnchor.constraint(equalTo: gBtn.topAnchor, constant: 10).isActive = true
//        gBtnText.bottomAnchor.constraint(equalTo: gBtn.bottomAnchor, constant: -10).isActive = true
        gBtnText.centerYAnchor.constraint(equalTo: gBtn.centerYAnchor).isActive = true
        gBtnText.leadingAnchor.constraint(equalTo: gBtn.leadingAnchor, constant: 20).isActive = true
        gBtnText.trailingAnchor.constraint(equalTo: gBtn.trailingAnchor, constant: -20).isActive = true
        gBtnText.text = "Allow"

        let gDenyText = UILabel()
        gDenyText.textAlignment = .center
//        gDenyText.textColor = .white
        gDenyText.textColor = .ddmBlackOverlayColor
        gDenyText.font = .systemFont(ofSize: 13)
        gBox.addSubview(gDenyText)
        gDenyText.translatesAutoresizingMaskIntoConstraints = false
        gDenyText.topAnchor.constraint(equalTo: gBtn.bottomAnchor, constant: 15).isActive = true
        gDenyText.bottomAnchor.constraint(equalTo: gBox.bottomAnchor, constant: -30).isActive = true
        gDenyText.centerXAnchor.constraint(equalTo: gBox.centerXAnchor, constant: 0).isActive = true
        gDenyText.text = "Don't Allow"
        gDenyText.isUserInteractionEnabled = true
        gDenyText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onGetLocationDenyClicked)))
    }

    @objc func onGetLocationProceedClicked(gesture: UITapGestureRecognizer) {
        self.removeFromSuperview()
        self.delegate?.didGLClickProceed()
    }
    @objc func onGetLocationDenyClicked(gesture: UITapGestureRecognizer) {
        self.removeFromSuperview()
        self.delegate?.didGLClickDeny()
    }
}

//test
extension ViewController: GetLocationMsgDelegate{

    func didGLClickProceed() {
        switch locationManager.authorizationStatus {
        case .authorizedAlways:
            print("location prompt 1")
            locationManager.requestLocation() //request location once
        case .authorizedWhenInUse:
            print("location prompt 2")
            locationManager.requestLocation() //request location once
        case .denied:
            print("location prompt 3")
            //go to app setting
            openAppIOSPublicSetting()
        case .notDetermined:
            print("location prompt 4")
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("location prompt 5")
            //go to app setting
            openAppIOSPublicSetting()
        @unknown default:
            print("location prompt unknown")
            //go to app setting
            openAppIOSPublicSetting()
        }
    }
    func didGLClickDeny() {

    }
}
