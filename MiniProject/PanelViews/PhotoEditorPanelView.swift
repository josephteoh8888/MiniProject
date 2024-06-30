//
//  PhotoEditorPanelView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage
import AVFoundation

import Photos

class PhotoEditorPanelView: PanelView{
    
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    var panel = UIView()
    var currentPanelTopCons : CGFloat = 0.0
    var panelTopCons: NSLayoutConstraint?
    
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
        panel.backgroundColor = .ddmBlackOverlayColor
        self.addSubview(panel)
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        panel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        panel.layer.masksToBounds = true
        panel.layer.cornerRadius = 10 //10
        panel.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        panel.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        panelTopCons = panel.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -viewHeight)
        panelTopCons?.isActive = true
        
        let aBtn = UIView()
//        aBtn.backgroundColor = .ddmDarkColor
        panel.addSubview(aBtn)
        aBtn.translatesAutoresizingMaskIntoConstraints = false
        aBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
        aBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        aBtn.leadingAnchor.constraint(equalTo: aStickyHeader.leadingAnchor, constant: 10).isActive = true
        aBtn.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 10).isActive = true
    //        aBtn.topAnchor.constraint(equalTo: userPanel.topAnchor, constant: 30).isActive = true
//        aBtn.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
//        let topInsetMargin = panel.safeAreaInsets.top + 10
        aBtn.topAnchor.constraint(equalTo: panel.topAnchor, constant: 50).isActive = true
        aBtn.layer.cornerRadius = 20
        aBtn.layer.opacity = 0.3
        aBtn.isUserInteractionEnabled = true
//        aBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackPhotoEditorPanelClicked)))

        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_arrow_down_a")?.withRenderingMode(.alwaysTemplate))
        bMiniBtn.tintColor = .white
//        aStickyHeader.addSubview(bMiniBtn)
        panel.addSubview(bMiniBtn)
        bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        bMiniBtn.centerXAnchor.constraint(equalTo: aBtn.centerXAnchor).isActive = true
        bMiniBtn.centerYAnchor.constraint(equalTo: aBtn.centerYAnchor).isActive = true
        bMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        bMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        
        //carousel of images
        let scrollView = UIScrollView()
        panel.addSubview(scrollView)
        scrollView.backgroundColor = .clear
        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        let topMargin = 50.0 + topInset + 20.0
//        scrollView.topAnchor.constraint(equalTo: panel.topAnchor, constant: topMargin).isActive = true
        scrollView.topAnchor.constraint(equalTo: aBtn.bottomAnchor, constant: 0).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 0).isActive = true //0
        scrollView.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: 0).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: 400.0).isActive = true  //280
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        let contentWidth = viewWidth * 2
        scrollView.contentSize = CGSize(width: contentWidth, height: 400.0) //800, 280
        scrollView.isPagingEnabled = true //false
//        scrollView.delegate = self

//                let gifUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        let gifUrl = URL(string: "https://i3.ytimg.com/vi/VjXTddVwFmw/maxresdefault.jpg")
//            https://i3.ytimg.com/vi/2mcGhpbWlyg/maxresdefault.jpg
        let imageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/dandanmap-37085.appspot.com/o/users%2FMW26M6lXx3TLD7zWc6409pfzYet1%2Fpost%2FhzBDMLjPLaaux0i6VODb%2Fvideo%2F0%2Fimg_0_OzBhXd4L5TSA0n3tQ7C8m.jpg?alt=media")
        var gifImage1 = SDAnimatedImageView()
        gifImage1.contentMode = .scaleAspectFill
        gifImage1.clipsToBounds = true
        gifImage1.sd_setImage(with: imageUrl)
//                gifImage1.layer.cornerRadius = 10 //5
        scrollView.addSubview(gifImage1)
        gifImage1.translatesAutoresizingMaskIntoConstraints = false
        gifImage1.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true //180
        gifImage1.heightAnchor.constraint(equalToConstant: 400.0).isActive = true //280
        gifImage1.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        gifImage1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
        //test > click on photo
        gifImage1.isUserInteractionEnabled = true
//        gifImage1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPhotoClicked)))//20

        var gifImage2 = SDAnimatedImageView()
        gifImage2.contentMode = .scaleAspectFill
        gifImage2.clipsToBounds = true
        gifImage2.sd_setImage(with: gifUrl)
//                gifImage2.layer.cornerRadius = 10 //5
        scrollView.addSubview(gifImage2)
        gifImage2.translatesAutoresizingMaskIntoConstraints = false
        gifImage2.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true //180
        gifImage2.heightAnchor.constraint(equalToConstant: 400.0).isActive = true //280
        gifImage2.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        gifImage2.leadingAnchor.constraint(equalTo: gifImage1.trailingAnchor, constant: 0).isActive = true //10
        
        //**test > tools panel
        let toolPanel = UIView()
        toolPanel.backgroundColor = .ddmBlackOverlayColor //black
//        toolPanel.backgroundColor = .black //black
        panel.addSubview(toolPanel)
        toolPanel.translatesAutoresizingMaskIntoConstraints = false
        toolPanel.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: 0).isActive = true
//        toolPanel.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -bottomInset).isActive = true
        toolPanel.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 0).isActive = true
        toolPanel.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: 0).isActive = true
        toolPanel.layer.cornerRadius = 0
        toolPanel.heightAnchor.constraint(equalToConstant: 120).isActive = true //60
        
        let mainEditPanel = UIView()
        toolPanel.addSubview(mainEditPanel)
        mainEditPanel.translatesAutoresizingMaskIntoConstraints = false
        mainEditPanel.bottomAnchor.constraint(equalTo: toolPanel.bottomAnchor, constant: 0).isActive = true
        mainEditPanel.topAnchor.constraint(equalTo: toolPanel.topAnchor, constant: 0).isActive = true
        mainEditPanel.leadingAnchor.constraint(equalTo: toolPanel.leadingAnchor, constant: 0).isActive = true
        mainEditPanel.trailingAnchor.constraint(equalTo: toolPanel.trailingAnchor, constant: 0).isActive = true
        
        let mainXGrid = UIView()
        mainEditPanel.addSubview(mainXGrid)
        mainXGrid.backgroundColor = .ddmDarkColor
        mainXGrid.translatesAutoresizingMaskIntoConstraints = false
        mainXGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        mainXGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
        mainXGrid.leadingAnchor.constraint(equalTo: mainEditPanel.leadingAnchor, constant: 20).isActive = true
        mainXGrid.topAnchor.constraint(equalTo: mainEditPanel.topAnchor, constant: 10).isActive = true
//        mainXGrid.centerYAnchor.constraint(equalTo: mainEditPanel.centerYAnchor, constant: 0).isActive = true
        mainXGrid.layer.cornerRadius = 20 //10
//        mainXGrid.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onAddSoundClicked)))

//        let mainXGridIcon = UIImageView(image: UIImage(named:"icon_round_textfield")?.withRenderingMode(.alwaysTemplate))
//        let mainXGridIcon = UIImageView(image: UIImage(named:"icon_round_add_v")?.withRenderingMode(.alwaysTemplate))
        let mainXGridIcon = UIImageView(image: UIImage(named:"icon_round_music")?.withRenderingMode(.alwaysTemplate))
        mainXGridIcon.tintColor = .white
//        uView.addSubview(xGridIcon)
        mainEditPanel.addSubview(mainXGridIcon)
        mainXGridIcon.translatesAutoresizingMaskIntoConstraints = false
        mainXGridIcon.centerXAnchor.constraint(equalTo: mainXGrid.centerXAnchor, constant: 0).isActive = true
        mainXGridIcon.centerYAnchor.constraint(equalTo: mainXGrid.centerYAnchor, constant: 0).isActive = true
        mainXGridIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true //26
        mainXGridIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let mainXGridText = UILabel()
        mainXGridText.textAlignment = .center
        mainXGridText.textColor = .white
        mainXGridText.font = .boldSystemFont(ofSize: 10)
        mainEditPanel.addSubview(mainXGridText)
        mainXGridText.translatesAutoresizingMaskIntoConstraints = false
        mainXGridText.topAnchor.constraint(equalTo: mainXGrid.bottomAnchor, constant: 2).isActive = true
        mainXGridText.centerXAnchor.constraint(equalTo: mainXGrid.centerXAnchor).isActive = true
        mainXGridText.text = "Add Sound"
        
        let aNext = UIView()
        aNext.backgroundColor = .yellow
    //        aFollow.backgroundColor = .ddmGoldenYellowColor
        panel.addSubview(aNext)
        aNext.translatesAutoresizingMaskIntoConstraints = false
        aNext.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20).isActive = true
        aNext.heightAnchor.constraint(equalToConstant: 30).isActive = true
        aNext.widthAnchor.constraint(equalToConstant: 30).isActive = true
        aNext.centerYAnchor.constraint(equalTo: mainXGrid.centerYAnchor, constant: 0).isActive = true
        aNext.layer.cornerRadius = 15
        aNext.isUserInteractionEnabled = true
//        aNext.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onVideoEditorNextClicked)))
//        aNext.isHidden = true
        
        let aNextMiniBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right_next")?.withRenderingMode(.alwaysTemplate))
        aNextMiniBtn.tintColor = .black
        panel.addSubview(aNextMiniBtn)
        aNextMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        aNextMiniBtn.centerXAnchor.constraint(equalTo: aNext.centerXAnchor).isActive = true
        aNextMiniBtn.centerYAnchor.constraint(equalTo: aNext.centerYAnchor).isActive = true
        aNextMiniBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        aNextMiniBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
    }
}
