//
//  MiniApp.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

protocol MiniAppDelegate : AnyObject {
    func didClickMiniApp(code: String)
    func didLongPressMiniApp(code: String)
    func didExitMiniApp()
}

class MiniApp: QueueableView {
//class MiniAppIcon: UIView {
    
    let aMini = UIView()
    let aMiniText = UILabel()
    weak var delegate : MiniAppDelegate?
    let aMiniImage = UIImageView()
    let aMiniImageCover = UIView()
    let aMiniImageCircleBg = UIView()
    let aMiniGifImage = SDAnimatedImageView()
    var appText = ""
    var appCode = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()

    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    func setupViews() {
        
        let aMiniContainer = UIView()
        self.addSubview(aMiniContainer)
        aMiniContainer.backgroundColor = .clear
        aMiniContainer.translatesAutoresizingMaskIntoConstraints = false
        aMiniContainer.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        aMiniContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true //20
        aMiniContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        aMiniContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
//        let aMini = UIView()
        aMini.backgroundColor = .ddmBlackOverlayColor
        self.addSubview(aMini)
        aMini.translatesAutoresizingMaskIntoConstraints = false
        aMini.topAnchor.constraint(equalTo: self.topAnchor, constant: 3).isActive = true //0
//        aMini.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true //20
//        aMini.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        aMini.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        aMini.heightAnchor.constraint(equalToConstant: 60).isActive = true
        aMini.widthAnchor.constraint(equalToConstant: 60).isActive = true
        aMini.layer.cornerRadius = 30
        aMini.isUserInteractionEnabled = true
        aMini.layer.shadowColor = UIColor.ddmDarkColor.cgColor
        aMini.layer.shadowRadius = 3.0  //ori 3
        aMini.layer.shadowOpacity = 1.0 //ori 1
        aMini.layer.shadowOffset = CGSize(width: 0, height: 0) //ori 4, 4
        aMini.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMiniClicked)))
        aMini.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(onMiniLongPress)))
        
        let aMiniRing = UIView()
        aMiniRing.backgroundColor = .ddmDarkColor
        aMini.addSubview(aMiniRing)
        aMiniRing.translatesAutoresizingMaskIntoConstraints = false
        aMiniRing.centerXAnchor.constraint(equalTo: aMini.centerXAnchor).isActive = true
        aMiniRing.centerYAnchor.constraint(equalTo: aMini.centerYAnchor).isActive = true
        aMiniRing.heightAnchor.constraint(equalToConstant: 44).isActive = true //40
        aMiniRing.widthAnchor.constraint(equalToConstant: 44).isActive = true
        aMiniRing.layer.cornerRadius = 22
        
        aMini.addSubview(aMiniImageCover)
        aMiniImageCover.translatesAutoresizingMaskIntoConstraints = false
        aMiniImageCover.centerXAnchor.constraint(equalTo: aMini.centerXAnchor).isActive = true
        aMiniImageCover.centerYAnchor.constraint(equalTo: aMini.centerYAnchor).isActive = true
        aMiniImageCover.heightAnchor.constraint(equalToConstant: 40).isActive = true //36
        aMiniImageCover.widthAnchor.constraint(equalToConstant: 40).isActive = true
        aMiniImageCover.layer.cornerRadius = 20
        
        let aMiniImageBG = UIView()
//        aMiniImageBG.backgroundColor = .systemOrange
        aMiniImageBG.backgroundColor = .white
        aMiniImageCover.addSubview(aMiniImageBG)
        aMiniImageBG.translatesAutoresizingMaskIntoConstraints = false
        aMiniImageBG.centerXAnchor.constraint(equalTo: aMiniRing.centerXAnchor).isActive = true
        aMiniImageBG.centerYAnchor.constraint(equalTo: aMiniRing.centerYAnchor).isActive = true
        aMiniImageBG.heightAnchor.constraint(equalToConstant: 40).isActive = true //36
        aMiniImageBG.widthAnchor.constraint(equalToConstant: 40).isActive = true
        aMiniImageBG.layer.cornerRadius = 20
        aMiniImageBG.layer.opacity = 0.8
        
//        let aMiniImageCircleBg = UIView()
        aMiniImageCircleBg.backgroundColor = .systemYellow
//        aMiniImageCircleBg.backgroundColor = .white
        aMiniImageCover.addSubview(aMiniImageCircleBg)
        aMiniImageCircleBg.translatesAutoresizingMaskIntoConstraints = false
        aMiniImageCircleBg.centerXAnchor.constraint(equalTo: aMiniRing.centerXAnchor).isActive = true
        aMiniImageCircleBg.centerYAnchor.constraint(equalTo: aMiniRing.centerYAnchor).isActive = true
//        aMiniImageCircleBg.heightAnchor.constraint(equalToConstant: 32).isActive = true //28, 32
//        aMiniImageCircleBg.widthAnchor.constraint(equalToConstant: 32).isActive = true
//        aMiniImageCircleBg.layer.cornerRadius = 16
        aMiniImageCircleBg.isHidden = true
        
//        let aMiniImage = UIImageView(image: UIImage(named:"flaticon_srip_places"))
//        aMiniImage.contentMode = .scaleAspectFill
//        aMiniImage.layer.masksToBounds = true
        aMiniImageCover.addSubview(aMiniImage)
        aMiniImage.translatesAutoresizingMaskIntoConstraints = false
        aMiniImage.centerXAnchor.constraint(equalTo: aMini.centerXAnchor).isActive = true
        aMiniImage.centerYAnchor.constraint(equalTo: aMini.centerYAnchor).isActive = true
//        aMiniImage.heightAnchor.constraint(equalToConstant: 32).isActive = true //32
//        aMiniImage.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
//        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
//        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
//        var bMiniGifImage = SDAnimatedImageView()
        aMiniGifImage.contentMode = .scaleAspectFill
        aMiniGifImage.layer.masksToBounds = true
//        aMiniGifImage.sd_setImage(with: imageUrl)
        aMiniImageCover.addSubview(aMiniGifImage)
        aMiniGifImage.translatesAutoresizingMaskIntoConstraints = false
        aMiniGifImage.centerXAnchor.constraint(equalTo: aMiniImageCover.centerXAnchor).isActive = true
        aMiniGifImage.centerYAnchor.constraint(equalTo: aMiniImageCover.centerYAnchor).isActive = true
        aMiniGifImage.heightAnchor.constraint(equalToConstant: 40).isActive = true //ori 36
        aMiniGifImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        aMiniGifImage.layer.cornerRadius = 20
        aMiniGifImage.isHidden = true
        
        //test 1 > text box for mini apps title
        let aMiniTextBox = UIView()
        aMiniTextBox.backgroundColor = .ddmBlackOverlayColor
//        self.view.addSubview(aMiniTextBox)
        aMini.addSubview(aMiniTextBox)
        aMiniTextBox.translatesAutoresizingMaskIntoConstraints = false
        aMiniTextBox.topAnchor.constraint(equalTo: aMini.bottomAnchor, constant: -10).isActive = true //default: -30
        aMiniTextBox.centerXAnchor.constraint(equalTo: aMini.centerXAnchor).isActive = true
        aMiniTextBox.heightAnchor.constraint(equalToConstant: 15).isActive = true
        aMiniTextBox.layer.cornerRadius = 5
        
//        let aMiniText = UILabel()
        aMiniText.textAlignment = .center
        aMiniText.textColor = .white
        aMiniText.font = .boldSystemFont(ofSize: 10)
        aMiniTextBox.addSubview(aMiniText)
        aMiniText.translatesAutoresizingMaskIntoConstraints = false
        aMiniText.centerYAnchor.constraint(equalTo: aMiniTextBox.centerYAnchor).isActive = true
        aMiniText.leadingAnchor.constraint(equalTo: aMiniTextBox.leadingAnchor, constant: 5).isActive = true
        aMiniText.trailingAnchor.constraint(equalTo: aMiniTextBox.trailingAnchor, constant: -5).isActive = true
//        aMiniText.text = "Malaysia"
//        aMiniText.text = "Places"
        aMiniText.text = "-"
//        aMiniText.text = "马来西亚"
    }
    
    @objc func onMiniClicked(gesture: UITapGestureRecognizer) {
        delegate?.didClickMiniApp(code: appCode)
    }
    @objc func onMiniLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            delegate?.didLongPressMiniApp(code: appCode)
        }
    }
    
    func setText(d: String) {
        appCode = d
    }
    func setText(code: String, d: String) {
        aMiniText.text = d
        appCode = code
        
        if(appCode == "location") {
            aMiniImage.image = UIImage(named:"flaticon_srip_places")
            aMiniImageCircleBg.isHidden = true
            
            aMiniGifImage.isHidden = true
            
            aMiniImage.heightAnchor.constraint(equalToConstant: 32).isActive = true //32
            aMiniImage.widthAnchor.constraint(equalToConstant: 32).isActive = true
            aMiniImageCircleBg.heightAnchor.constraint(equalToConstant: 32).isActive = true //28, 32
            aMiniImageCircleBg.widthAnchor.constraint(equalToConstant: 32).isActive = true
            aMiniImageCircleBg.layer.cornerRadius = 16
        }
        else if(appCode == "loop") {
            aMiniImage.image = UIImage(named:"flaticon_freepik_video_b")
            aMiniImageCircleBg.isHidden = false
            
            let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
            aMiniGifImage.sd_setImage(with: imageUrl)
//            aMiniGifImage.isHidden = false
            aMiniGifImage.isHidden = true
            
            aMiniImage.heightAnchor.constraint(equalToConstant: 32).isActive = true //32
            aMiniImage.widthAnchor.constraint(equalToConstant: 32).isActive = true
            aMiniImageCircleBg.heightAnchor.constraint(equalToConstant: 32).isActive = true //28, 32
            aMiniImageCircleBg.widthAnchor.constraint(equalToConstant: 32).isActive = true
            aMiniImageCircleBg.layer.cornerRadius = 16
        }
        else if(appCode == "post") {
            aMiniImage.image = UIImage(named:"flaticon_freepik_article")
            aMiniImageCircleBg.isHidden = true
            
            aMiniGifImage.isHidden = true
            
            aMiniImage.heightAnchor.constraint(equalToConstant: 28).isActive = true //32
            aMiniImage.widthAnchor.constraint(equalToConstant: 28).isActive = true
            aMiniImageCircleBg.heightAnchor.constraint(equalToConstant: 28).isActive = true //28, 32
            aMiniImageCircleBg.widthAnchor.constraint(equalToConstant: 28).isActive = true
            aMiniImageCircleBg.layer.cornerRadius = 14
        }
        else if(appCode == "photo") {
            aMiniImage.image = UIImage(named:"flaticon_icon_home_photo")
            aMiniImageCircleBg.isHidden = true
            
            aMiniGifImage.isHidden = true
            
            aMiniImage.heightAnchor.constraint(equalToConstant: 32).isActive = true //32
            aMiniImage.widthAnchor.constraint(equalToConstant: 32).isActive = true
            aMiniImageCircleBg.heightAnchor.constraint(equalToConstant: 32).isActive = true //28, 32
            aMiniImageCircleBg.widthAnchor.constraint(equalToConstant: 32).isActive = true
            aMiniImageCircleBg.layer.cornerRadius = 16
        }
        //test > other mini apps
        else if(appCode == "creator") {
//            aMiniImage.image = UIImage(named:"flaticon_freepik_star")
//            aMiniImage.image = UIImage(named:"flaticon_freepik_famous_b")
//            aMiniImage.image = UIImage(named:"flaticon_freepik_famous")
            aMiniImage.image = UIImage(named:"flaticon_sbts2018_celebrity")
            aMiniImageCircleBg.isHidden = true
            
            aMiniGifImage.isHidden = true
            
            aMiniImage.heightAnchor.constraint(equalToConstant: 32).isActive = true //32
            aMiniImage.widthAnchor.constraint(equalToConstant: 32).isActive = true
            aMiniImageCircleBg.heightAnchor.constraint(equalToConstant: 32).isActive = true //28, 32
            aMiniImageCircleBg.widthAnchor.constraint(equalToConstant: 32).isActive = true
            aMiniImageCircleBg.layer.cornerRadius = 16
        }
        else if(appCode == "ride") {
            aMiniImage.image = UIImage(named:"flaticon_icon_home_photo")
            aMiniImageCircleBg.isHidden = true
            
            aMiniGifImage.isHidden = true
            
            aMiniImage.heightAnchor.constraint(equalToConstant: 32).isActive = true //32
            aMiniImage.widthAnchor.constraint(equalToConstant: 32).isActive = true
            aMiniImageCircleBg.heightAnchor.constraint(equalToConstant: 32).isActive = true //28, 32
            aMiniImageCircleBg.widthAnchor.constraint(equalToConstant: 32).isActive = true
            aMiniImageCircleBg.layer.cornerRadius = 16
        }
        else if(appCode == "hotel") {
            aMiniImage.image = UIImage(named:"flaticon_icon_home_photo")
            aMiniImageCircleBg.isHidden = true
            
            aMiniGifImage.isHidden = true
            
            aMiniImage.heightAnchor.constraint(equalToConstant: 32).isActive = true //32
            aMiniImage.widthAnchor.constraint(equalToConstant: 32).isActive = true
            aMiniImageCircleBg.heightAnchor.constraint(equalToConstant: 32).isActive = true //28, 32
            aMiniImageCircleBg.widthAnchor.constraint(equalToConstant: 32).isActive = true
            aMiniImageCircleBg.layer.cornerRadius = 16
        }
        else if(appCode == "voice") {
            aMiniImage.image = UIImage(named:"flaticon_icon_home_photo")
            aMiniImageCircleBg.isHidden = true
            
            aMiniGifImage.isHidden = true
            
            aMiniImage.heightAnchor.constraint(equalToConstant: 32).isActive = true //32
            aMiniImage.widthAnchor.constraint(equalToConstant: 32).isActive = true
            aMiniImageCircleBg.heightAnchor.constraint(equalToConstant: 32).isActive = true //28, 32
            aMiniImageCircleBg.widthAnchor.constraint(equalToConstant: 32).isActive = true
            aMiniImageCircleBg.layer.cornerRadius = 16
        }
    }
    
    func shutterMiniGifImage() {
        UIView.animate(withDuration: 0.1,
            animations: {
                self.aMiniImageCover.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                self.aMiniImageCover.layer.opacity = 0.0
            },
            completion: { _ in
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [], //test 0.3 delay
                    animations: {
                        self.aMiniImageCover.transform = CGAffineTransform.identity
                        self.aMiniImageCover.layer.opacity = 1.0
                    },
                    completion: { _ in
                    self.delegate?.didExitMiniApp()
                    })
            })
    }
    //test > hide bmini app when video panel opens
    func hideMiniGifImage(){
        self.aMiniImageCover.layer.opacity = 0.0
    }
    func dehideMiniGifImage(){
        self.aMiniImageCover.layer.opacity = 1.0
    }
}

extension ViewController: MiniAppDelegate{
    func didClickMiniApp(code: String) {
        if let index = miniAppDataList.firstIndex(of: code) {
            print("miniapp index clicked: \(index), \(code)")
            
            selectedMiniAppIndex = index
            
            let xOffset = miniAppScrollView.contentOffset.x
            let miniAppOriginX = miniAppViewList[index].frame.origin.x
            let miniAppWidth = miniAppViewList[index].frame.size.width
            let x1 = miniAppOriginX - xOffset + miniAppWidth/2
//            let y1 = miniAppScrollView.frame.origin.y + miniAppViewList[index].frame.size.height/2
            let y1 = miniAppContainer.frame.origin.y + miniAppViewList[index].frame.size.height/2
            let offsetX1 = x1 - self.view.frame.width/2
            let offsetY1 = y1 - self.view.frame.height/2
            
            if(code == "location") {
                openPlacesMiniPanel()
            } else if(code == "creator") {
                openUsersMiniPanel()
            } else if(code == "loop"){
                dequeueObject()
                let qId = addQueueObject()
                if(qId != -1) {
                    miniAppViewList[index].setId(id: qId)
                }

                //result from queue
                if(!queueObjectList.isEmpty) {
                    let d = queueObjectList[queueObjectList.count - 1].getIsToOpenPanel()
                    let id = queueObjectList[queueObjectList.count - 1].getId()
                    if(id == miniAppViewList[index].getId()) {
                        if(d) {
                            print("async pulsewave start open video: ")
                            self.openVideoPanel(offX: offsetX1, offY: offsetY1, originatorView: miniAppViewList[index], originatorViewType: OriginatorTypes.MAP_VIDEO_MINIAPP_UIVIEW, id: id)
                        }
                    }
                }
            } else if(code == "post"){
//                openPostPanel(offX: offsetX1, offY: offsetY1)
                
                //test 2 > new method
                dequeueObject()
                let qId = addQueueObject()
                if(qId != -1) {
                    miniAppViewList[index].setId(id: qId)
                }

                //result from queue
                if(!queueObjectList.isEmpty) {
                    let d = queueObjectList[queueObjectList.count - 1].getIsToOpenPanel()
                    let id = queueObjectList[queueObjectList.count - 1].getId()
                    if(id == miniAppViewList[index].getId()) {
                        if(d) {
                            self.openPostPanel(offX: offsetX1, offY: offsetY1, originatorView: miniAppViewList[index], originatorViewType: OriginatorTypes.MAP_VIDEO_MINIAPP_UIVIEW, id: id)
                        }
                    }
                }
            } else if(code == "photo"){
                //test 1 > direct method
//                openPhotoPanel(offX: offsetX1, offY: offsetY1)
                
                //test 2 > new method
                dequeueObject()
                let qId = addQueueObject()
                if(qId != -1) {
                    miniAppViewList[index].setId(id: qId)
                }

                //result from queue
                if(!queueObjectList.isEmpty) {
                    let d = queueObjectList[queueObjectList.count - 1].getIsToOpenPanel()
                    let id = queueObjectList[queueObjectList.count - 1].getId()
                    if(id == miniAppViewList[index].getId()) {
                        if(d) {
                            self.openPhotoPanel(offX: offsetX1, offY: offsetY1, originatorView: miniAppViewList[index], originatorViewType: OriginatorTypes.MAP_VIDEO_MINIAPP_UIVIEW, id: id)
                        }
                    }
                }
            } else if(code == "voice"){
                dequeueObject()
                let qId = addQueueObject()
                if(qId != -1) {
                    miniAppViewList[index].setId(id: qId)
                }

                //result from queue
                if(!queueObjectList.isEmpty) {
                    let d = queueObjectList[queueObjectList.count - 1].getIsToOpenPanel()
                    let id = queueObjectList[queueObjectList.count - 1].getId()
                    if(id == miniAppViewList[index].getId()) {
                        if(d) {
                            print("async pulsewave start open video: ")
                            self.openSoundPanel(offX: offsetX1, offY: offsetY1, originatorView: miniAppViewList[index], originatorViewType: OriginatorTypes.MAP_VIDEO_MINIAPP_UIVIEW, id: id)
                        }
                    }
                }
            }
        } else {
            print("Element not found in the array")
        }
    }
    
    func didLongPressMiniApp(code: String){
        
        //test 5 > taptic feedback
        //good for games
//        let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
//        feedbackGenerator.prepare()
//        feedbackGenerator.impactOccurred()
        
        //**selected this
        let feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator.prepare()
        feedbackGenerator.notificationOccurred(.error)
        
        //feel soft
//        let feedbackGenerator = UISelectionFeedbackGenerator()
//        feedbackGenerator.prepare()
//        feedbackGenerator.selectionChanged()
    }
    
    func didExitMiniApp(){
        selectedMiniAppIndex = -1
    }
}
