//
//  HMultiLocationViewCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

protocol HMultiLocationDelegate : AnyObject {
    func didClickUserCurrentLocation()
}
class HMultiLocationViewCell: UICollectionViewCell {
    static let identifier = "HMultiViewCell"
    var gifImage = SDAnimatedImageView()
    
    weak var aDelegate : HMultiLocationDelegate?
    
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
//        let aResult = UIView()
//        aResult.backgroundColor = .ddmDarkColor
//        contentView.addSubview(aResult)
//        aResult.translatesAutoresizingMaskIntoConstraints = false
////        aResult.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
////        aResult.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
////        aResult.heightAnchor.constraint(equalToConstant: 120).isActive = true
////        aResult.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
//        aResult.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
//        aResult.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
//        aResult.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
//        aResult.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
//        aResult.layer.cornerRadius = 10
//        aResult.layer.opacity = 0.3
        
        let aGrid = UIView()
        aGrid.backgroundColor = .ddmDarkColor
        contentView.addSubview(aGrid)
        aGrid.translatesAutoresizingMaskIntoConstraints = false
        aGrid.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        aGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        aGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
        aGrid.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        aGrid.layer.cornerRadius = 10
        
        let aGridIcon = UIImageView(image: UIImage(named:"icon_round_near_me")?.withRenderingMode(.alwaysTemplate))
        aGridIcon.tintColor = .white
        aGrid.addSubview(aGridIcon)
        aGridIcon.translatesAutoresizingMaskIntoConstraints = false
        aGridIcon.centerXAnchor.constraint(equalTo: aGrid.centerXAnchor).isActive = true
        aGridIcon.centerYAnchor.constraint(equalTo: aGrid.centerYAnchor).isActive = true
        aGridIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        aGridIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let aText = UILabel()
        aText.textAlignment = .left
        aText.textColor = .white
        aText.font = .systemFont(ofSize: 14)
        contentView.addSubview(aText)
        aText.translatesAutoresizingMaskIntoConstraints = false
        aText.centerYAnchor.constraint(equalTo: aGrid.centerYAnchor, constant: 0).isActive = true
//        aText.topAnchor.constraint(equalTo: aTextBox.bottomAnchor, constant: 30).isActive = true
        aText.leadingAnchor.constraint(equalTo: aGrid.trailingAnchor, constant: 10).isActive = true
        aText.text = "Around You"
        aText.isUserInteractionEnabled = true
        aText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onAroundYouClicked)))
    
        let bGrid = UIView()
        bGrid.backgroundColor = .ddmDarkColor
        contentView.addSubview(bGrid)
        bGrid.translatesAutoresizingMaskIntoConstraints = false
        bGrid.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        bGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        bGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
        bGrid.topAnchor.constraint(equalTo: aGrid.bottomAnchor, constant: 10).isActive = true
        bGrid.layer.cornerRadius = 10
        
        let bText = UILabel()
        bText.textAlignment = .left
        bText.textColor = .white
        bText.font = .systemFont(ofSize: 14)
        contentView.addSubview(bText)
        bText.translatesAutoresizingMaskIntoConstraints = false
        bText.centerYAnchor.constraint(equalTo: bGrid.centerYAnchor, constant: 0).isActive = true
//        bText.topAnchor.constraint(equalTo: aText.bottomAnchor, constant: 15).isActive = true
        bText.leadingAnchor.constraint(equalTo: bGrid.trailingAnchor, constant: 10).isActive = true
        bText.text = "Malaysia"
        
        let cGrid = UIView()
        cGrid.backgroundColor = .ddmDarkColor
        contentView.addSubview(cGrid)
        cGrid.translatesAutoresizingMaskIntoConstraints = false
        cGrid.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        cGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
        cGrid.topAnchor.constraint(equalTo: bGrid.bottomAnchor, constant: 10).isActive = true
        cGrid.layer.cornerRadius = 10
        
        let cText = UILabel()
        cText.textAlignment = .left
        cText.textColor = .white
        cText.font = .systemFont(ofSize: 14)
        contentView.addSubview(cText)
        cText.translatesAutoresizingMaskIntoConstraints = false
        cText.centerYAnchor.constraint(equalTo: cGrid.centerYAnchor, constant: 0).isActive = true
//        bText.topAnchor.constraint(equalTo: aText.bottomAnchor, constant: 15).isActive = true
        cText.leadingAnchor.constraint(equalTo: cGrid.trailingAnchor, constant: 10).isActive = true
        cText.text = "Kuala Lumpur"
        
        let dGrid = UIView()
        dGrid.backgroundColor = .ddmDarkColor
        contentView.addSubview(dGrid)
        dGrid.translatesAutoresizingMaskIntoConstraints = false
        dGrid.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        dGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        dGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
        dGrid.topAnchor.constraint(equalTo: cGrid.bottomAnchor, constant: 10).isActive = true
        dGrid.layer.cornerRadius = 10
        
        let dText = UILabel()
        dText.textAlignment = .left
        dText.textColor = .white
        dText.font = .systemFont(ofSize: 14)
        contentView.addSubview(dText)
        dText.translatesAutoresizingMaskIntoConstraints = false
        dText.centerYAnchor.constraint(equalTo: dGrid.centerYAnchor, constant: 0).isActive = true
//        bText.topAnchor.constraint(equalTo: aText.bottomAnchor, constant: 15).isActive = true
        dText.leadingAnchor.constraint(equalTo: dGrid.trailingAnchor, constant: 10).isActive = true
        dText.text = "Global"
    }
    
    @objc func onAroundYouClicked(gesture: UITapGestureRecognizer) {
        aDelegate?.didClickUserCurrentLocation()
    }
}
