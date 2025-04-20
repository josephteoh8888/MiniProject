//
//  HPlacesListViewCell.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

protocol HPlacesListDelegate : AnyObject {
    func didHPlacesClickPlace(id: String)
    func didHPlacesClickVideo()
}
class HPlacesListViewCell: UICollectionViewCell {
    static let identifier = "HPlacesListViewCell"
    
    weak var aDelegate : HPlacesListDelegate?
    let aNameText = UILabel()
    
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

        //test > result vertical panel layout
        let aResult = UIView()
//        aResult.backgroundColor = .ddmDarkColor
        aResult.backgroundColor = .ddmDarkBlack
        contentView.addSubview(aResult)
        aResult.translatesAutoresizingMaskIntoConstraints = false
        aResult.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        aResult.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        aResult.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        aResult.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
//        aResult.layer.cornerRadius = 10
//        aResult.layer.opacity = 0.1 //0.3
        aResult.isUserInteractionEnabled = true
        aResult.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPlaceClicked)))

//        let aNameText = UILabel()
        aNameText.textAlignment = .left
        aNameText.textColor = .white
        aNameText.font = .boldSystemFont(ofSize: 13)
        contentView.addSubview(aNameText)
        aNameText.translatesAutoresizingMaskIntoConstraints = false
        aNameText.topAnchor.constraint(equalTo: aResult.topAnchor, constant: 10).isActive = true
        aNameText.leadingAnchor.constraint(equalTo: aResult.leadingAnchor, constant: 20).isActive = true
        aNameText.text = "-"
        
        let aGrid = UIView()
        aGrid.backgroundColor = .ddmDarkColor
        contentView.addSubview(aGrid)
        aGrid.translatesAutoresizingMaskIntoConstraints = false
        aGrid.leadingAnchor.constraint(equalTo: aResult.leadingAnchor, constant: 20).isActive = true
        aGrid.heightAnchor.constraint(equalToConstant: 70).isActive = true
        aGrid.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        aGrid.topAnchor.constraint(equalTo: aPhoto.bottomAnchor, constant: 20).isActive = true
        aGrid.topAnchor.constraint(equalTo: aNameText.bottomAnchor, constant: 20).isActive = true
        aGrid.layer.cornerRadius = 10

//        let aImageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
        let gifImage = SDAnimatedImageView()
        gifImage.contentMode = .scaleAspectFill
        gifImage.layer.masksToBounds = true
        gifImage.layer.cornerRadius = 10
//        gifImage.sd_setImage(with: aImageUrl)
        aGrid.addSubview(gifImage)
        gifImage.translatesAutoresizingMaskIntoConstraints = false
        gifImage.topAnchor.constraint(equalTo: aGrid.topAnchor).isActive = true
        gifImage.leadingAnchor.constraint(equalTo: aGrid.leadingAnchor).isActive = true
        gifImage.bottomAnchor.constraint(equalTo: aGrid.bottomAnchor).isActive = true
        gifImage.trailingAnchor.constraint(equalTo: aGrid.trailingAnchor).isActive = true

        let bGrid = UIView()
        bGrid.backgroundColor = .ddmDarkColor
        contentView.addSubview(bGrid)
        bGrid.translatesAutoresizingMaskIntoConstraints = false
        bGrid.leadingAnchor.constraint(equalTo: aGrid.trailingAnchor, constant: 10).isActive = true
        bGrid.heightAnchor.constraint(equalToConstant: 70).isActive = true
        bGrid.widthAnchor.constraint(equalToConstant: 50).isActive = true
        bGrid.topAnchor.constraint(equalTo: aGrid.topAnchor).isActive = true
        bGrid.layer.cornerRadius = 10

        let cGrid = UIView()
        cGrid.backgroundColor = .ddmDarkColor
        contentView.addSubview(cGrid)
        cGrid.translatesAutoresizingMaskIntoConstraints = false
        cGrid.leadingAnchor.constraint(equalTo: bGrid.trailingAnchor, constant: 10).isActive = true
        cGrid.heightAnchor.constraint(equalToConstant: 70).isActive = true
        cGrid.widthAnchor.constraint(equalToConstant: 50).isActive = true
        cGrid.topAnchor.constraint(equalTo: aGrid.topAnchor).isActive = true
//        cGrid.bottomAnchor.constraint(equalTo: aPanelView.bottomAnchor).isActive = true //
        cGrid.layer.cornerRadius = 10
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("HResultUserListViewCell prepare for reuse")
        
        aNameText.text = "-"
    }
    
//    func configure(data: String) {
    func configure(data: BaseData) {

        guard let a = data as? PlaceData else {
            return
        }
        let l = a.dataCode
        
        if(l == "a") {
            asyncConfigure(data: "")
            
            self.aNameText.text = a.dataTextString //"Petronas Twin Towers"
        }
        else if(l == "na") {
            
        }
        else if(l == "us") {
            
        }
    }
    func asyncConfigure(data: String) {
        let id = "a"
        DataFetchManager.shared.fetchDummyDataTimeDelay(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("pdp api success \(id), \(l)")
                    
                    guard let self = self else {
                        return
                    }
                    
//                    self.aNameText.text = "Petronas Twin Towers"
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    
                    guard let self = self else {
                        return
                    }
                    
//                    self.aNameText.text = "-"
                }
                break
            }
        }
    }
    
    @objc func onPlaceClicked(gesture: UITapGestureRecognizer) {
        aDelegate?.didHPlacesClickPlace(id: "")
    }
}

extension PlacesMiniScrollablePanelView: HPlacesListDelegate{
    func didHPlacesClickPlace(id: String){
        delegate?.didPlacesMiniClickPlace(id: id)
    }
    func didHPlacesClickVideo(){

    }
}
