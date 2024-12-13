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
//        aMiniRing.backgroundColor = .ddmDarkColor
        aMiniRing.backgroundColor = .ddmBlackDark
        contentView.addSubview(aMiniRing)
        aMiniRing.translatesAutoresizingMaskIntoConstraints = false
        aMiniRing.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        aMiniRing.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        aMiniRing.heightAnchor.constraint(equalToConstant: 44).isActive = true //48
        aMiniRing.widthAnchor.constraint(equalToConstant: 44).isActive = true
        aMiniRing.layer.cornerRadius = 22
//        aMiniRing.layer.opacity = 0.4 //0.2
        
//        bMiniBtn.tintColor = .white
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
//        aMiniTextBox.heightAnchor.constraint(equalToConstant: 30).isActive = true
        aMiniTextBox.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        aMiniText.textAlignment = .center
        aMiniText.textColor = .white
//        aMiniText.font = .boldSystemFont(ofSize: 10)
        aMiniText.font = .systemFont(ofSize: 10)
        aMiniTextBox.addSubview(aMiniText)
        aMiniText.translatesAutoresizingMaskIntoConstraints = false
//        aMiniText.centerXAnchor.constraint(equalTo: aMiniTextBox.centerXAnchor).isActive = true
        aMiniText.topAnchor.constraint(equalTo: aMiniTextBox.topAnchor).isActive = true
        aMiniText.leadingAnchor.constraint(equalTo: aMiniTextBox.leadingAnchor, constant: 5).isActive = true
        aMiniText.trailingAnchor.constraint(equalTo: aMiniTextBox.trailingAnchor, constant: -5).isActive = true
        aMiniText.text = ""
        aMiniText.numberOfLines = 2
        aMiniText.bottomAnchor.constraint(equalTo: aMiniTextBox.bottomAnchor).isActive = true
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
            bMiniBtn.tintColor = .white
            aMiniText.text = "React" //Repost
        } else if(data == "s") {
            bMiniBtn.image = UIImage(named:"icon_round_share_to")?.withRenderingMode(.alwaysTemplate)
            bMiniBtn.tintColor = .white
            aMiniText.text = "Share To"
        } else if(data == "c") {
            bMiniBtn.image = UIImage(named:"icon_round_link")?.withRenderingMode(.alwaysTemplate)
            bMiniBtn.tintColor = .white
            aMiniText.text = "Copy Link"
        } else if(data == "cr") {
            bMiniBtn.image = UIImage(named:"icon_round_add")?.withRenderingMode(.alwaysTemplate)
            bMiniBtn.tintColor = .white
            aMiniText.text = "Use Location"
        } else if(data == "cr_p") {
            bMiniBtn.image = UIImage(named:"icon_round_add")?.withRenderingMode(.alwaysTemplate)
            bMiniBtn.tintColor = .white
//            bMiniBtn.image = UIImage(named:"flaticon_srip_places")
            aMiniText.text = "Create New Location"
        } else if(data == "cr_post") {
            bMiniBtn.image = UIImage(named:"icon_round_add")?.withRenderingMode(.alwaysTemplate)
            bMiniBtn.tintColor = .white
//            bMiniBtn.image = UIImage(named:"flaticon_freepik_article")
            aMiniText.text = "Create Post"
        } else if(data == "cr_photo") {
            bMiniBtn.image = UIImage(named:"icon_round_add")?.withRenderingMode(.alwaysTemplate)
            bMiniBtn.tintColor = .white
//            bMiniBtn.image = UIImage(named:"flaticon_icon_home_photo")
            aMiniText.text = "Create Shot" //Tag in New Shot
        } else if(data == "cr_video") {
            bMiniBtn.image = UIImage(named:"icon_round_add")?.withRenderingMode(.alwaysTemplate)
            bMiniBtn.tintColor = .white
//            bMiniBtn.image = UIImage(named:"flaticon_freepik_video_b")
            aMiniText.text = "Create Loop"
        } else if(data == "rp") {
            bMiniBtn.image = UIImage(named:"icon_round_report")?.withRenderingMode(.alwaysTemplate)
            bMiniBtn.tintColor = .white
            aMiniText.text = "Report"
        } else if(data == "wa") {
//            bMiniBtn.image = UIImage(named:"icon_round_repeat")?.withRenderingMode(.alwaysTemplate)
            aMiniText.text = "WhatsApp"
        } else if(data == "x") {
//            bMiniBtn.image = UIImage(named:"icon_round_repeat")?.withRenderingMode(.alwaysTemplate)
            aMiniText.text = "X"
        } else if(data == "f") {
            bMiniBtn.image = UIImage(named:"icon_round_add_person")?.withRenderingMode(.alwaysTemplate)
            bMiniBtn.tintColor = .white
            aMiniText.text = "Follow"
        } else if(data == "d") {
            bMiniBtn.image = UIImage(named:"icon_round_heartbreak")?.withRenderingMode(.alwaysTemplate)
            bMiniBtn.tintColor = .white
            aMiniText.text = "Dislike"
        } else if(data == "sg") {
            bMiniBtn.image = UIImage(named:"icon_round_cash")?.withRenderingMode(.alwaysTemplate)
            bMiniBtn.tintColor = .white
            aMiniText.text = "Send Gift"
        } else if(data == "de") {
            bMiniBtn.image = UIImage(named:"icon_round_delete")?.withRenderingMode(.alwaysTemplate)
            bMiniBtn.tintColor = .white
            aMiniText.text = "Delete"
        } else if(data == "sa") {
            bMiniBtn.image = UIImage(named:"icon_round_bookmark_b")?.withRenderingMode(.alwaysTemplate)
            bMiniBtn.tintColor = .white
            aMiniText.text = "Save"
        }
    }

}

