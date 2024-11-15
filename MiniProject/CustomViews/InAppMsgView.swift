//
//  InAppMsgView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

protocol InAppMsgDelegate : AnyObject {
    func didInAppMsgClickClose()
}
class InAppMsgView: UIView{
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    let box = UIView()
    let gTitleText = UILabel()
    let aSpinner = SpinLoader()
    
    let miniError = UIView()
    let errorText = UILabel()
    let errorRefreshBtn = UIView()
    
    //test > new
    var panelTopCons: NSLayoutConstraint?
    var currentPanelTopCons : CGFloat = 0.0
    
    weak var delegate : InAppMsgDelegate?
    
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
        
        self.addSubview(box)
        box.translatesAutoresizingMaskIntoConstraints = false
        box.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        box.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        box.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        box.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        box.backgroundColor = .white
//        box.backgroundColor = .black
//        box.backgroundColor = .ddmBlackOverlayColor
        box.layer.cornerRadius = 10
        
//        let gTitleText = UILabel()
        gTitleText.textAlignment = .left
//        gTitleText.textColor = .white
        gTitleText.textColor = .ddmBlackOverlayColor
        gTitleText.font = .boldSystemFont(ofSize: 13)
        box.addSubview(gTitleText)
        gTitleText.translatesAutoresizingMaskIntoConstraints = false
        gTitleText.centerYAnchor.constraint(equalTo: box.centerYAnchor).isActive = true
//        gTitleText.topAnchor.constraint(equalTo: box.topAnchor, constant: 30).isActive = true
//        gTitleText.bottomAnchor.constraint(equalTo: box.bottomAnchor, constant: 30).isActive = true
        gTitleText.leadingAnchor.constraint(equalTo: box.leadingAnchor, constant: 15).isActive = true
        gTitleText.trailingAnchor.constraint(equalTo: box.trailingAnchor, constant: -40).isActive = true
//        gTitleText.numberOfLines = 0
        gTitleText.text = ""
        gTitleText.isHidden = false
        
        box.addSubview(aSpinner)
        aSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .ddmBlackOverlayColor)
//        aSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        aSpinner.translatesAutoresizingMaskIntoConstraints = false
        aSpinner.centerYAnchor.constraint(equalTo: box.centerYAnchor).isActive = true
        aSpinner.trailingAnchor.constraint(equalTo: box.trailingAnchor, constant: -15).isActive = true
        aSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        aSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        //test > error handling
//        let miniError = UIView()
        miniError.backgroundColor = .red
        box.addSubview(miniError)
        miniError.translatesAutoresizingMaskIntoConstraints = false
        miniError.leadingAnchor.constraint(equalTo: box.leadingAnchor, constant: 15).isActive = true
        miniError.centerYAnchor.constraint(equalTo: box.centerYAnchor, constant: 0).isActive = true
        miniError.heightAnchor.constraint(equalToConstant: 20).isActive = true
        miniError.widthAnchor.constraint(equalToConstant: 20).isActive = true
        miniError.layer.cornerRadius = 10
        miniError.isHidden = true

        let miniBtn = UIImageView(image: UIImage(named:"icon_round_priority")?.withRenderingMode(.alwaysTemplate))
        miniBtn.tintColor = .white
        miniError.addSubview(miniBtn)
        miniBtn.translatesAutoresizingMaskIntoConstraints = false
        miniBtn.centerXAnchor.constraint(equalTo: miniError.centerXAnchor).isActive = true
        miniBtn.centerYAnchor.constraint(equalTo: miniError.centerYAnchor).isActive = true
        miniBtn.heightAnchor.constraint(equalToConstant: 12).isActive = true
        miniBtn.widthAnchor.constraint(equalToConstant: 12).isActive = true
        
        errorText.textAlignment = .center //left
        errorText.textColor = .ddmBlackOverlayColor
        errorText.font = .boldSystemFont(ofSize: 13)
//        self.addSubview(errorText)
        box.addSubview(errorText)
        errorText.translatesAutoresizingMaskIntoConstraints = false
        errorText.clipsToBounds = true
        errorText.translatesAutoresizingMaskIntoConstraints = false
        errorText.centerYAnchor.constraint(equalTo: box.centerYAnchor).isActive = true
        errorText.leadingAnchor.constraint(equalTo: miniError.trailingAnchor, constant: 10).isActive = true
        errorText.text = ""
//        errorText.numberOfLines = 0
        errorText.isHidden = true
        
        self.addSubview(errorRefreshBtn)
        errorRefreshBtn.translatesAutoresizingMaskIntoConstraints = false
        errorRefreshBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true //ori: 40
        errorRefreshBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        errorRefreshBtn.centerYAnchor.constraint(equalTo: box.centerYAnchor).isActive = true
//        errorRefreshBtn.leadingAnchor.constraint(equalTo: gTitleText.trailingAnchor, constant: 10).isActive = true //0
        errorRefreshBtn.trailingAnchor.constraint(equalTo: box.trailingAnchor, constant: -15).isActive = true //0
//        errorRefreshBtn.layer.cornerRadius = 15
        errorRefreshBtn.isUserInteractionEnabled = true
        errorRefreshBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onErrorRefreshClicked)))
        errorRefreshBtn.isHidden = true
        
        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_refresh")?.withRenderingMode(.alwaysTemplate))
        bMiniBtn.tintColor = .ddmBlackOverlayColor
//        bMiniBtn.tintColor = .white
        errorRefreshBtn.addSubview(bMiniBtn)
        bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        bMiniBtn.centerXAnchor.constraint(equalTo: errorRefreshBtn.centerXAnchor).isActive = true
        bMiniBtn.centerYAnchor.constraint(equalTo: errorRefreshBtn.centerYAnchor).isActive = true
        bMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true //26
        bMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        
        let bPanelPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onPanelPanGesture))
        self.addGestureRecognizer(bPanelPanGesture)
//        aPanelView.addGestureRecognizer(bPanelPanGesture)
    }
    
    var isInitialized = false
    func initialize() {
        if(!isInitialized) {
//            aSpinner.startAnimating()
        }
        isInitialized = true
    }
    
    //test 1 > dismiss msg with timer
    var searchTimer: Timer?
    func dismiss() {
        //Invalidate and Reinitialise
        self.searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { [weak self] (timer) in
            print("dismiss in-app timer \(self)")
            
            self?.close(isAnimated: true)
        })
    }
    
    //test 2 > dismiss msg with dispatchQ
//    func dismissQ() {
//        DispatchQueue.global().asyncAfter(deadline: .now()+2.0, execute: { //0.6s
//            print("dismissQ \(self)")
//            self.close(isAnimated: true)
//        })
//    }
    
    @objc func onErrorRefreshClicked(gesture: UITapGestureRecognizer) {
        print("reupload data btn:")
        //
        DataUploadManager.shared.sendData(id: "a_") { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    guard let self = self else {
                        return
                    }
                    
                    self.updateConfigUI(data: self.dataType, taskId: "a_")
                }

                case .failure(_):
                //update UI on main thread
                DispatchQueue.main.async {
                    guard let self = self else {
                        return
                    }
                    print("api fail")
                    
                    self.updateConfigUI(data: self.dataType, taskId: "a_")
                }

                break
            }
        }
        
        self.updateConfigUI(data: dataType, taskId: "a_")
    }
    
    var dataType = ""
    func updateConfigUI(data: String, taskId: String) {
        gTitleText.isHidden = true
        miniError.isHidden = true
        aSpinner.stopAnimating()
        errorRefreshBtn.isHidden = true
        errorText.isHidden = true
        
//        let status = DataUploadManager.shared.getStatus(id: "a")
        let status = DataUploadManager.shared.getStatus(id: taskId)
        if let a = status {
            //set text according to type
            dataType = data
            if(data == "up_post") {
                if(a == "progress") {
                    gTitleText.text = "Uploading Post..."
                    gTitleText.isHidden = false
                    aSpinner.startAnimating()
                } else if(a == "success") {
                    gTitleText.text = "Post created successfully"
                    gTitleText.isHidden = false
                    dismiss()
                } else if(a == "fail") {
                    miniError.isHidden = false
                    errorText.isHidden = false
                    errorText.text = "Error occurs. Retry."
                    errorRefreshBtn.isHidden = false
                }
            }
            else if(data == "up_photo") {
                if(a == "progress") {
                    gTitleText.text = "Uploading Shot..."
                    gTitleText.isHidden = false
                    aSpinner.startAnimating()
                } else if(a == "success") {
                    gTitleText.text = "Shot created successfully."
                    gTitleText.isHidden = false
                    dismiss()
                } else if(a == "fail") {
                    miniError.isHidden = false
                    errorText.isHidden = false
                    errorText.text = "Error occurs. Retry."
                    errorRefreshBtn.isHidden = false
                }
            }
            else if(data == "up_video") {
                if(a == "progress") {
                    gTitleText.text = "Uploading Loop..."
                    gTitleText.isHidden = false
                    aSpinner.startAnimating()
                } else if(a == "success") {
                    gTitleText.text = "Loop created successfully."
                    gTitleText.isHidden = false
                    dismiss()
                } else if(a == "fail") {
                    miniError.isHidden = false
                    errorText.isHidden = false
                    errorText.text = "Error occurs. Retry."
                    errorRefreshBtn.isHidden = false
                }
            }
            else if(data == "up_place") {
                if(a == "progress") {
                    gTitleText.text = "Creating Location..."
                    gTitleText.isHidden = false
                    aSpinner.startAnimating()
                } else if(a == "success") {
                    gTitleText.text = "Location created successfully."
                    gTitleText.isHidden = false
                    dismiss()
                } else if(a == "fail") {
                    miniError.isHidden = false
                    errorText.isHidden = false
                    errorText.text = "Error occurs. Retry."
                    errorRefreshBtn.isHidden = false
                }
            } else if(data == "up_user") {
                if(a == "progress") {
                    gTitleText.text = "Creating User Profile..."
                    gTitleText.isHidden = false
                    aSpinner.startAnimating()
                } else if(a == "success") {
                    gTitleText.text = "User created successfully."
                    gTitleText.isHidden = false
                    dismiss()
                } else if(a == "fail") {
                    miniError.isHidden = false
                    errorText.isHidden = false
                    errorText.text = "Error occurs. Retry."
                    errorRefreshBtn.isHidden = false
                }
            } else if(data == "ed_user") {
                if(a == "progress") {
                    gTitleText.text = "Editing User Profile..."
                    gTitleText.isHidden = false
                    aSpinner.startAnimating()
                } else if(a == "success") {
                    gTitleText.text = "User edited successfully."
                    gTitleText.isHidden = false
                    dismiss()
                } else if(a == "fail") {
                    miniError.isHidden = false
                    errorText.isHidden = false
                    errorText.text = "Error occurs. Retry."
                    errorRefreshBtn.isHidden = false
                }
            }
        } else {
            close(isAnimated: false)
        }
    }
    
    @objc func onPanelPanGesture(gesture: UIPanGestureRecognizer) {

        if(gesture.state == .began) {
            print("xtest panel onPan start:")
            currentPanelTopCons = panelTopCons!.constant

        } else if(gesture.state == .changed) {
            let translation = gesture.translation(in: self)
            let x = translation.x
            let y = translation.y

            let velocity = gesture.velocity(in: self)
            print("xtest panel onPan change: ")

            //test > put a limit to how high panel can be scrolled
            if(y < 0) {
                //y go up
                panelTopCons?.constant = currentPanelTopCons + y
            } else {
                //y go down
                self.panelTopCons?.constant = 10.0
            }

        } else if(gesture.state == .ended){
            print("xtest panel onPan end: ")
            let translation = gesture.translation(in: self)
            let x = translation.x
            let y = translation.y

            //test xxx
//            if (self.currentPanelTopCons - self.panelTopCons!.constant > 0) {
//                close(isAnimated: true)
//            }
            
            close(isAnimated: true)
        }
    }
    
    func close(isAnimated: Bool) {
        if(isAnimated) {
            UIView.animate(withDuration: 0.2, animations: {
                self.panelTopCons?.constant = -100
                self.superview?.layoutIfNeeded()
            }, completion: { _ in
                self.removeFromSuperview()
                self.delegate?.didInAppMsgClickClose()
            })
        } else {
            self.removeFromSuperview()
            self.delegate?.didInAppMsgClickClose()
        }
    }
}

extension ViewController: InAppMsgDelegate{
    func didInAppMsgClickClose(){
        print("inapp close \(inAppMsgList)")
        if(!inAppMsgList.isEmpty) {
            inAppMsgList.remove(at: inAppMsgList.count - 1)
            print("inapp close after \(inAppMsgList)")
        }
    }

}
