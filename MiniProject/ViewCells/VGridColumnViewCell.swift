//
//  VGridColumnViewCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

class VGridColumnViewCell: UICollectionViewCell {
    static let identifier = "VGridColumnViewCell"
    
    let aMiniText = UILabel()
    let bMiniBtn = UIImageView()
//    var code = ""
    
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

//        contentView.backgroundColor = .red //test
        
        let aMiniRing = UIView()
        aMiniRing.backgroundColor = .ddmDarkColor
        contentView.addSubview(aMiniRing)
        aMiniRing.translatesAutoresizingMaskIntoConstraints = false
        aMiniRing.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        aMiniRing.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        aMiniRing.heightAnchor.constraint(equalToConstant: 44).isActive = true //48
        aMiniRing.widthAnchor.constraint(equalToConstant: 44).isActive = true
        aMiniRing.layer.cornerRadius = 22
        aMiniRing.layer.opacity = 0.4 //0.2
        
        bMiniBtn.tintColor = .white
//        contentView.addSubview(bMiniBtn)
        contentView.addSubview(bMiniBtn)
        bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        bMiniBtn.centerXAnchor.constraint(equalTo: aMiniRing.centerXAnchor).isActive = true
        bMiniBtn.centerYAnchor.constraint(equalTo: aMiniRing.centerYAnchor, constant: 0).isActive = true
        bMiniBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true
        bMiniBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
//        bMiniBtn.isUserInteractionEnabled = true
//        bMiniBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBtnClicked)))
        
        let aMiniTextBox = UIView()
//        aMiniTextBox.backgroundColor = .ddmBlackOverlayColor
        aMiniTextBox.backgroundColor = .clear
        contentView.addSubview(aMiniTextBox)
        aMiniTextBox.translatesAutoresizingMaskIntoConstraints = false
        aMiniTextBox.topAnchor.constraint(equalTo: aMiniRing.bottomAnchor, constant: 2).isActive = true //default: -30
        aMiniTextBox.centerXAnchor.constraint(equalTo: aMiniRing.centerXAnchor).isActive = true
        aMiniTextBox.heightAnchor.constraint(equalToConstant: 30).isActive = true
        aMiniTextBox.widthAnchor.constraint(equalToConstant: 70).isActive = true
//        aMiniTextBox.layer.cornerRadius = 5
        
        aMiniText.textAlignment = .center
        aMiniText.textColor = .white
//        aMiniText.font = .boldSystemFont(ofSize: 10)
        aMiniText.font = .systemFont(ofSize: 10)
        aMiniTextBox.addSubview(aMiniText)
        aMiniText.translatesAutoresizingMaskIntoConstraints = false
        aMiniText.centerXAnchor.constraint(equalTo: aMiniTextBox.centerXAnchor).isActive = true
        aMiniText.topAnchor.constraint(equalTo: aMiniTextBox.topAnchor).isActive = true
//        aMiniText.leadingAnchor.constraint(equalTo: aMiniTextBox.leadingAnchor, constant: 5).isActive = true
//        aMiniText.trailingAnchor.constraint(equalTo: aMiniTextBox.trailingAnchor, constant: -5).isActive = true
        aMiniText.text = ""
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        bMiniBtn.image = UIImage(named:"")?.withRenderingMode(.alwaysTemplate)
        aMiniText.text = ""
        
//        code = ""
    }
    func configure(data: String) {
        
//        code = data
        
        if(data == "r") {
            bMiniBtn.image = UIImage(named:"icon_round_repeat")?.withRenderingMode(.alwaysTemplate)
            aMiniText.text = "Repost"
        } else if(data == "s") {
            bMiniBtn.image = UIImage(named:"icon_round_share_to")?.withRenderingMode(.alwaysTemplate)
            aMiniText.text = "Share To"
        } else if(data == "c") {
            bMiniBtn.image = UIImage(named:"icon_round_link")?.withRenderingMode(.alwaysTemplate)
            aMiniText.text = "Copy Link"
        } else if(data == "rp") {
            bMiniBtn.image = UIImage(named:"icon_round_report")?.withRenderingMode(.alwaysTemplate)
            aMiniText.text = "Report"
        } else if(data == "wa") {
//            bMiniBtn.image = UIImage(named:"icon_round_repeat")?.withRenderingMode(.alwaysTemplate)
            aMiniText.text = "WhatsApp"
        } else if(data == "x") {
//            bMiniBtn.image = UIImage(named:"icon_round_repeat")?.withRenderingMode(.alwaysTemplate)
            aMiniText.text = "X"
        } else if(data == "f") {
            bMiniBtn.image = UIImage(named:"icon_round_add_person")?.withRenderingMode(.alwaysTemplate)
            aMiniText.text = "Follow"
        } else if(data == "d") {
            bMiniBtn.image = UIImage(named:"icon_round_heartbreak")?.withRenderingMode(.alwaysTemplate)
            aMiniText.text = "Dislike"
        } else if(data == "sg") {
            bMiniBtn.image = UIImage(named:"icon_round_cash")?.withRenderingMode(.alwaysTemplate)
            aMiniText.text = "Send Gift"
        } else if(data == "de") {
            bMiniBtn.image = UIImage(named:"icon_round_delete")?.withRenderingMode(.alwaysTemplate)
            aMiniText.text = "Delete"
        }
    }

}

