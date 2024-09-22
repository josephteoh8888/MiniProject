//
//  PlaceSelectPanelView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit

protocol PlaceSelectPanelDelegate : AnyObject {
    func didInitializePlaceSelect()
    func didClickUserCurrentLocation(panel: PlaceSelectPanelView)
    func didClickPlaceLocation(panel: PlaceSelectPanelView)
    func didClickFinishPlaceSelect()
}
class PlaceSelectPanelView: PanelView, UIGestureRecognizerDelegate{
    var panel = UIView()
    
    var panelTopCons: NSLayoutConstraint?
    var currentPanelTopCons : CGFloat = 0.0
    
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    let aTextBox = UIView()
    let bTextField = UITextField()
    let bTextBox = UIView()
    
    var vDataList = [String]()
    var isScrollViewAtTop = true
    var currentPanelMode = ""
    let PANEL_MODE_HALF: String = "half"
    let PANEL_MODE_EMPTY: String = "empty"
    let PANEL_MODE_FULL: String = "full"
    
    var aTextBoxTopCons: NSLayoutConstraint?
    
    weak var delegate : PlaceSelectPanelDelegate?
    
    var vCV : UICollectionView?
    let aSpinner = SpinLoader()
    let bSpinner = SpinLoader()
    let footerView = UIView()
    let aaText = UILabel()
    var dataFetchState = ""
    var dataPaginateStatus = "" //test
    var pageNumber = 0
    
    let bbText = UILabel()
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
        let aBoxUnder = UIView()
        self.addSubview(aBoxUnder)
//        aBoxUnder.backgroundColor = .ddmBlackOverlayColor
        aBoxUnder.backgroundColor = .clear
        aBoxUnder.translatesAutoresizingMaskIntoConstraints = false
        aBoxUnder.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        aBoxUnder.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
//        aBoxUnder.layer.opacity = 0.1
//        aBoxUnder.isHidden = true
        aBoxUnder.isUserInteractionEnabled = true
        aBoxUnder.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackPanelClicked)))
        
        panel.backgroundColor = .ddmBlackOverlayColor
        self.addSubview(panel)
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        panel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        panel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //default 0
        panel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        panel.layer.masksToBounds = true
        panel.layer.cornerRadius = 10 //10
        //test
//        panel.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        panel.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
//        soundPanelLeadingCons = soundPanel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
        let gap = viewHeight - 150
        panelTopCons = panel.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -gap)
        panelTopCons?.isActive = true
        
//        let tText = UILabel()
//        tText.textAlignment = .left
//        tText.textColor = .white
//        tText.font = .boldSystemFont(ofSize: 14)
//        panel.addSubview(tText)
//        tText.translatesAutoresizingMaskIntoConstraints = false
//        tText.topAnchor.constraint(equalTo: panel.topAnchor, constant: 20).isActive = true
//        tText.centerXAnchor.constraint(equalTo: panel.centerXAnchor, constant: 0).isActive = true
//        tText.text = "Select Place"
//        tText.layer.opacity = 0
        
        panel.addSubview(aTextBox)
        aTextBox.translatesAutoresizingMaskIntoConstraints = false
        aTextBoxTopCons = aTextBox.topAnchor.constraint(equalTo: panel.topAnchor, constant: 20)
        aTextBoxTopCons?.isActive = true
//        aTextBox.topAnchor.constraint(equalTo: tText.bottomAnchor, constant: 20).isActive = true
        aTextBox.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 15).isActive = true
        aTextBox.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -15).isActive = true
        aTextBox.heightAnchor.constraint(equalToConstant: 40).isActive = true
        aTextBox.backgroundColor = .ddmDarkColor
        aTextBox.layer.cornerRadius = 10
        aTextBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onOpenTextBoxClicked)))
        
        let aTextSearch = UIImageView()
        aTextSearch.image = UIImage(named:"icon_round_search")?.withRenderingMode(.alwaysTemplate)
        aTextSearch.tintColor = .ddmDarkGrayColor
        aTextBox.addSubview(aTextSearch)
        aTextSearch.translatesAutoresizingMaskIntoConstraints = false
        aTextSearch.leadingAnchor.constraint(equalTo: aTextBox.leadingAnchor, constant: 10).isActive = true
        aTextSearch.centerYAnchor.constraint(equalTo: aTextBox.centerYAnchor).isActive = true
        aTextSearch.heightAnchor.constraint(equalToConstant: 26).isActive = true //ori 30
        aTextSearch.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        aTextSearch.layer.opacity = 0.5
        
        let aSearchPlaceholderText = UILabel()
        aSearchPlaceholderText.textAlignment = .left
        aSearchPlaceholderText.textColor = .ddmDarkGrayColor
//        aSearchPlaceholderText.font = .boldSystemFont(ofSize: 13)
        aSearchPlaceholderText.font = .systemFont(ofSize: 13)
        aTextBox.addSubview(aSearchPlaceholderText)
        aSearchPlaceholderText.translatesAutoresizingMaskIntoConstraints = false
        aSearchPlaceholderText.leadingAnchor.constraint(equalTo: aTextSearch.trailingAnchor, constant: 10).isActive = true
        aSearchPlaceholderText.trailingAnchor.constraint(equalTo: aTextBox.trailingAnchor, constant: -20).isActive = true
        aSearchPlaceholderText.centerYAnchor.constraint(equalTo: aTextBox.centerYAnchor, constant: 0).isActive = true
        aSearchPlaceholderText.text = "Search Place..."
//        aSearchPlaceholderText.layer.opacity = 0.5
        
        //real text field
//        let bTextBox = UIView()
        panel.addSubview(bTextBox)
        bTextBox.translatesAutoresizingMaskIntoConstraints = false
//        bTextBox.topAnchor.constraint(equalTo: tText.bottomAnchor, constant: 20).isActive = true
        bTextBox.topAnchor.constraint(equalTo: aTextBox.topAnchor, constant: 0).isActive = true
        bTextBox.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 15).isActive = true
        bTextBox.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -15).isActive = true
        bTextBox.heightAnchor.constraint(equalToConstant: 40).isActive = true
        bTextBox.backgroundColor = .ddmDarkColor
        bTextBox.layer.cornerRadius = 10
        bTextBox.isHidden = true
        
        let bTextSearch = UIImageView()
        bTextSearch.image = UIImage(named:"icon_round_search")?.withRenderingMode(.alwaysTemplate)
        bTextSearch.tintColor = .ddmDarkGrayColor
        bTextBox.addSubview(bTextSearch)
        bTextSearch.translatesAutoresizingMaskIntoConstraints = false
        bTextSearch.leadingAnchor.constraint(equalTo: bTextBox.leadingAnchor, constant: 10).isActive = true
        bTextSearch.centerYAnchor.constraint(equalTo: bTextBox.centerYAnchor).isActive = true
        bTextSearch.heightAnchor.constraint(equalToConstant: 26).isActive = true //ori 30
        bTextSearch.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        bTextSearch.layer.opacity = 0.5
        
//        let bTextField = UITextField()
        bTextField.textAlignment = .left
        bTextField.textColor = .white
//        bTextField.backgroundColor = .ddmDarkColor
//        bTextField.layer.cornerRadius = 10
        bTextField.font = .systemFont(ofSize: 13)
        bTextBox.addSubview(bTextField)
        bTextField.translatesAutoresizingMaskIntoConstraints = false
        bTextField.leadingAnchor.constraint(equalTo: bTextSearch.trailingAnchor, constant: 10).isActive = true
        bTextField.trailingAnchor.constraint(equalTo: bTextBox.trailingAnchor, constant: -50).isActive = true
        bTextField.centerYAnchor.constraint(equalTo: bTextBox.centerYAnchor, constant: 0).isActive = true
        bTextField.text = ""
        bTextField.tintColor = .yellow
        bTextField.returnKeyType = UIReturnKeyType.search
        bTextField.delegate = self
        bTextField.placeholder = "Search Place..."
        
////        let bbText = UILabel()
//        bbText.textAlignment = .left
//        bbText.textColor = .white
//        bbText.font = .boldSystemFont(ofSize: 13)
//        bTextBox.addSubview(bbText)
//        bbText.clipsToBounds = true
//        bbText.translatesAutoresizingMaskIntoConstraints = false
//        bbText.leadingAnchor.constraint(equalTo: bTextField.leadingAnchor, constant: 10).isActive = true
////        bbText.trailingAnchor.constraint(equalTo: xGrid.leadingAnchor, constant: -10).isActive = true
//        bbText.topAnchor.constraint(equalTo: bTextField.topAnchor, constant: 0).isActive = true
//        bbText.text = "Singapore..."
//        bbText.layer.opacity = 0.5
        
        let bBox = UIView()
        bBox.backgroundColor = .white
        bTextBox.addSubview(bBox)
        bBox.clipsToBounds = true
        bBox.translatesAutoresizingMaskIntoConstraints = false
        bBox.widthAnchor.constraint(equalToConstant: 20).isActive = true //ori: 40
        bBox.heightAnchor.constraint(equalToConstant: 20).isActive = true
        bBox.centerYAnchor.constraint(equalTo: bTextBox.centerYAnchor).isActive = true
        bBox.trailingAnchor.constraint(equalTo: bTextBox.trailingAnchor, constant: -10).isActive = true
        bBox.layer.cornerRadius = 10
        bBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCloseTextBoxClicked)))
        
        let aBtn = UIImageView(image: UIImage(named:"icon_round_close")?.withRenderingMode(.alwaysTemplate))
        aBtn.tintColor = .ddmDarkColor
        bBox.addSubview(aBtn)
        aBtn.translatesAutoresizingMaskIntoConstraints = false
        aBtn.centerXAnchor.constraint(equalTo: bBox.centerXAnchor).isActive = true
        aBtn.centerYAnchor.constraint(equalTo: bBox.centerYAnchor).isActive = true
        aBtn.heightAnchor.constraint(equalToConstant: 16).isActive = true
        aBtn.widthAnchor.constraint(equalToConstant: 16).isActive = true
        
//        let aGrid = UIView()
//        aGrid.backgroundColor = .ddmDarkColor
//        panel.addSubview(aGrid)
//        aGrid.translatesAutoresizingMaskIntoConstraints = false
//        aGrid.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 15).isActive = true
//        aGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        aGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        aGrid.topAnchor.constraint(equalTo: aTextBox.bottomAnchor, constant: 20).isActive = true
//        aGrid.layer.cornerRadius = 10
//
//        let aGridIcon = UIImageView(image: UIImage(named:"icon_round_near_me")?.withRenderingMode(.alwaysTemplate))
//        aGridIcon.tintColor = .white
//        aGrid.addSubview(aGridIcon)
//        aGridIcon.translatesAutoresizingMaskIntoConstraints = false
//        aGridIcon.centerXAnchor.constraint(equalTo: aGrid.centerXAnchor).isActive = true
//        aGridIcon.centerYAnchor.constraint(equalTo: aGrid.centerYAnchor).isActive = true
//        aGridIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        aGridIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
//
//        let aText = UILabel()
//        aText.textAlignment = .left
//        aText.textColor = .white
//        aText.font = .systemFont(ofSize: 14)
//        panel.addSubview(aText)
//        aText.translatesAutoresizingMaskIntoConstraints = false
//        aText.centerYAnchor.constraint(equalTo: aGrid.centerYAnchor, constant: 0).isActive = true
////        aText.topAnchor.constraint(equalTo: aTextBox.bottomAnchor, constant: 30).isActive = true
//        aText.leadingAnchor.constraint(equalTo: aGrid.trailingAnchor, constant: 10).isActive = true
//        aText.text = "Around You"
//        aText.isUserInteractionEnabled = true
//        aText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onAroundYouClicked)))
//
//        let bGrid = UIView()
//        bGrid.backgroundColor = .ddmDarkColor
//        panel.addSubview(bGrid)
//        bGrid.translatesAutoresizingMaskIntoConstraints = false
//        bGrid.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 15).isActive = true
//        bGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        bGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        bGrid.topAnchor.constraint(equalTo: aGrid.bottomAnchor, constant: 10).isActive = true
//        bGrid.layer.cornerRadius = 10
//
//        let bText = UILabel()
//        bText.textAlignment = .left
//        bText.textColor = .white
//        bText.font = .systemFont(ofSize: 14)
//        panel.addSubview(bText)
//        bText.translatesAutoresizingMaskIntoConstraints = false
//        bText.centerYAnchor.constraint(equalTo: bGrid.centerYAnchor, constant: 0).isActive = true
////        bText.topAnchor.constraint(equalTo: aText.bottomAnchor, constant: 15).isActive = true
//        bText.leadingAnchor.constraint(equalTo: bGrid.trailingAnchor, constant: 10).isActive = true
//        bText.text = "Malaysia"
//
//        let cGrid = UIView()
//        cGrid.backgroundColor = .ddmDarkColor
//        panel.addSubview(cGrid)
//        cGrid.translatesAutoresizingMaskIntoConstraints = false
//        cGrid.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 15).isActive = true
//        cGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        cGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        cGrid.topAnchor.constraint(equalTo: bGrid.bottomAnchor, constant: 10).isActive = true
//        cGrid.layer.cornerRadius = 10
//
//        let cText = UILabel()
//        cText.textAlignment = .left
//        cText.textColor = .white
//        cText.font = .systemFont(ofSize: 14)
//        panel.addSubview(cText)
//        cText.translatesAutoresizingMaskIntoConstraints = false
//        cText.centerYAnchor.constraint(equalTo: cGrid.centerYAnchor, constant: 0).isActive = true
////        bText.topAnchor.constraint(equalTo: aText.bottomAnchor, constant: 15).isActive = true
//        cText.leadingAnchor.constraint(equalTo: cGrid.trailingAnchor, constant: 10).isActive = true
//        cText.text = "Kuala Lumpur"
//
//        let dGrid = UIView()
//        dGrid.backgroundColor = .ddmDarkColor
//        panel.addSubview(dGrid)
//        dGrid.translatesAutoresizingMaskIntoConstraints = false
//        dGrid.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 15).isActive = true
//        dGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        dGrid.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        dGrid.topAnchor.constraint(equalTo: cGrid.bottomAnchor, constant: 10).isActive = true
//        dGrid.layer.cornerRadius = 10
//
//        let dText = UILabel()
//        dText.textAlignment = .left
//        dText.textColor = .white
//        dText.font = .systemFont(ofSize: 14)
//        panel.addSubview(dText)
//        dText.translatesAutoresizingMaskIntoConstraints = false
//        dText.centerYAnchor.constraint(equalTo: dGrid.centerYAnchor, constant: 0).isActive = true
////        bText.topAnchor.constraint(equalTo: aText.bottomAnchor, constant: 15).isActive = true
//        dText.leadingAnchor.constraint(equalTo: dGrid.trailingAnchor, constant: 10).isActive = true
//        dText.text = "World"
        
//        let aResult = UIView()
//        aResult.backgroundColor = .ddmDarkColor
//        panel.addSubview(aResult)
//        aResult.translatesAutoresizingMaskIntoConstraints = false
//        aResult.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 15).isActive = true
//        aResult.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -15).isActive = true
//        aResult.heightAnchor.constraint(equalToConstant: 120).isActive = true
//        aResult.topAnchor.constraint(equalTo: cGrid.bottomAnchor, constant: 30).isActive = true
//        aResult.layer.cornerRadius = 10
//        aResult.layer.opacity = 0.3
//
//        let bResult = UIView()
//        bResult.backgroundColor = .ddmDarkColor
//        panel.addSubview(bResult)
//        bResult.translatesAutoresizingMaskIntoConstraints = false
//        bResult.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 15).isActive = true
//        bResult.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -15).isActive = true
//        bResult.heightAnchor.constraint(equalToConstant: 120).isActive = true
//        bResult.topAnchor.constraint(equalTo: aResult.bottomAnchor, constant: 15).isActive = true
//        bResult.layer.cornerRadius = 10
//        bResult.layer.opacity = 0.3
//
//        let cResult = UIView()
//        cResult.backgroundColor = .ddmDarkColor
//        panel.addSubview(cResult)
//        cResult.translatesAutoresizingMaskIntoConstraints = false
//        cResult.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 15).isActive = true
//        cResult.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -15).isActive = true
//        cResult.heightAnchor.constraint(equalToConstant: 120).isActive = true
//        cResult.topAnchor.constraint(equalTo: bResult.bottomAnchor, constant: 15).isActive = true
//        cResult.layer.cornerRadius = 10
//        cResult.layer.opacity = 0.3
        
//        vDataList.append("a")
//        vDataList.append("a")
//        vDataList.append("a")
//        vDataList.append("a")
//        vDataList.append("a")
//        vDataList.append("a")
        let gridLayout = UICollectionViewFlowLayout()
        gridLayout.scrollDirection = .vertical
        gridLayout.minimumLineSpacing = 10 //default: 20 => spacing between rows
        gridLayout.minimumInteritemSpacing = 0 //default: 4 => spacing between columns
//        let vCV = UICollectionView(frame: .zero, collectionViewLayout: gridLayout)
        vCV = UICollectionView(frame: .zero, collectionViewLayout: gridLayout)
        guard let vCV = vCV else {
            return
        }
//        vCV.register(HListViewCell.self, forCellWithReuseIdentifier: HListViewCell.identifier)
        vCV.register(HMultiLocationViewCell.self, forCellWithReuseIdentifier: HMultiLocationViewCell.identifier)
        vCV.register(HSingleLocationViewCell.self, forCellWithReuseIdentifier: HSingleLocationViewCell.identifier)
        vCV.dataSource = self
        vCV.delegate = self
        vCV.backgroundColor = .clear
        panel.addSubview(vCV)
        vCV.translatesAutoresizingMaskIntoConstraints = false
        vCV.topAnchor.constraint(equalTo: aTextBox.bottomAnchor, constant: 10).isActive = true
        vCV.leadingAnchor.constraint(equalTo: panel.leadingAnchor).isActive = true
        vCV.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: 0).isActive = true
        vCV.trailingAnchor.constraint(equalTo: panel.trailingAnchor).isActive = true
        vCV.contentInsetAdjustmentBehavior = .never
        let vcvPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onVCVPanGesture))
        vcvPanGesture.delegate = self //for simultaneous pan recognizer for uicollectionview
        vCV.addGestureRecognizer(vcvPanGesture)
        
        //test > top spinner
        vCV.addSubview(aSpinner)
        aSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        aSpinner.translatesAutoresizingMaskIntoConstraints = false
        aSpinner.topAnchor.constraint(equalTo: vCV.topAnchor, constant: CGFloat(-35)).isActive = true
        aSpinner.centerXAnchor.constraint(equalTo: vCV.centerXAnchor).isActive = true
        aSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        aSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        //test > add footer ***
        vCV.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer")
        //***
        
//        let aBtn = UIView()
//    //        aBtn.backgroundColor = .ddmBlackOverlayColor
//        aBtn.backgroundColor = .ddmDarkColor
//        panel.addSubview(aBtn)
//        aBtn.translatesAutoresizingMaskIntoConstraints = false
//        aBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
//        aBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        aBtn.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 10).isActive = true
//    //        aBtn.topAnchor.constraint(equalTo: userPanel.topAnchor, constant: 30).isActive = true
//        aBtn.topAnchor.constraint(equalTo: panel.topAnchor, constant: 10).isActive = true
//        aBtn.layer.cornerRadius = 20
//        aBtn.layer.opacity = 0.3
//        aBtn.isUserInteractionEnabled = true
//        aBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackPanelClicked)))
//
//        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_arrow_left")?.withRenderingMode(.alwaysTemplate))
//        bMiniBtn.tintColor = .white
//        panel.addSubview(bMiniBtn)
//        bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
//        bMiniBtn.centerXAnchor.constraint(equalTo: aBtn.centerXAnchor).isActive = true
//        bMiniBtn.centerYAnchor.constraint(equalTo: aBtn.centerYAnchor).isActive = true
//        bMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
//        bMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        
        
        //test > gesture recognizer for dragging user panel
        let panelPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onPanelPanGesture))
        panel.addGestureRecognizer(panelPanGesture)

    }
    
    @objc func onVCVPanGesture(gesture: UIPanGestureRecognizer) {
        if(gesture.state == .began) {
            print("onPan began top constraint: ")
            
            if(self.currentPanelMode == self.PANEL_MODE_HALF) {
                currentPanelTopCons = panelTopCons!.constant
            }

        } else if(gesture.state == .changed) {
            let translation = gesture.translation(in: self)
            let x = translation.x
            var y = translation.y

            let velocity = gesture.velocity(in: self)
            
            print("onPan changed: \(x), \(y)")
            
            //y > 0 means downwards
            if(self.currentPanelMode == self.PANEL_MODE_HALF) {
                if(y > 0) {
                    if(isScrollViewAtTop) {
                        panelTopCons?.constant = currentPanelTopCons + y
                    }
                } else {
                    //test
                    isScrollViewAtTop = false
                }
            }

        } else if(gesture.state == .ended){
            print("onPan end:")
            
            if(self.currentPanelMode == self.PANEL_MODE_HALF) {
                if(self.panelTopCons!.constant - self.currentPanelTopCons < 150) {
                    print("placeselectpanel <150 \(self.currentPanelTopCons), \(self.panelTopCons!.constant)")
                    UIView.animate(withDuration: 0.2, animations: {
                        let gap = self.viewHeight - 150
                        self.panelTopCons?.constant = -gap
                        self.layoutIfNeeded()
                    }, completion: { _ in
                    })
                } else {
                    print("placeselectpanel >150 \(self.currentPanelTopCons), \(self.panelTopCons!.constant)")
                    closePanel(isAnimated: true)
                }
            }

        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer is UIPanGestureRecognizer) {
            return true
        } else {
            return false
        }
    }
    
    @objc func onAroundYouClicked(gesture: UITapGestureRecognizer) {
        delegate?.didClickUserCurrentLocation(panel: self)
    }
    
    @objc func onBackPanelClicked(gesture: UITapGestureRecognizer) {
        closePanel(isAnimated: true)
    }
    
    @objc func onOpenTextBoxClicked(gesture: UITapGestureRecognizer) {
        setFirstResponder(textField: bTextField)
        
//        aTextBox.isHidden = true
//        bTextBox.isHidden = false
        
        let topInset = self.safeAreaInsets.top
        print("placeselect: \(topInset)")
        aTextBoxTopCons?.constant = topInset + 10
        
        let gap = self.viewHeight
        self.panelTopCons?.constant = -gap
        
        currentPanelMode = PANEL_MODE_FULL
        
        //test
        self.adjustContentInset(topInset: CGFloat(0), bottomInset: CGFloat(50)) //50
    }
    
    @objc func onCloseTextBoxClicked(gesture: UITapGestureRecognizer) {
        resignResponder()
        
//        aTextBox.isHidden = false
//        bTextBox.isHidden = true
        
        aTextBoxTopCons?.constant = 20
        
        UIView.animate(withDuration: 0.2, animations: {
            let gap = self.viewHeight - 150
            self.panelTopCons?.constant = -gap
            self.layoutIfNeeded()
        }, completion: { _ in
        })
        
        currentPanelMode = PANEL_MODE_HALF
        
        //test
        self.adjustContentInset(topInset: CGFloat(0), bottomInset: CGFloat(200)) //50
    }
    
    func activate() {
        setFirstResponder(textField: bTextField)
    }
    
    func setFirstResponder(textField: UITextField) {
        textField.becomeFirstResponder()
        aTextBox.isHidden = true
        bTextBox.isHidden = false
        
        bbText.isHidden = false
    }
    
    func resignResponder() {
        self.endEditing(true)
        aTextBox.isHidden = false
        bTextBox.isHidden = true
        
        bbText.isHidden = true
    }
    
    @objc func onPanelPanGesture(gesture: UIPanGestureRecognizer) {
        if(gesture.state == .began) {
            if(self.currentPanelMode == self.PANEL_MODE_HALF) {
                self.currentPanelTopCons = self.panelTopCons!.constant
            }

        } else if(gesture.state == .changed) {
            let translation = gesture.translation(in: self)
            let x = translation.x
            let y = translation.y
            
            if(self.currentPanelMode == self.PANEL_MODE_HALF) {
                if(y > 0) {
                    self.panelTopCons?.constant = self.currentPanelTopCons + y
                }
            }

        } else if(gesture.state == .ended){
            if(self.currentPanelMode == self.PANEL_MODE_HALF) {
                if(self.panelTopCons!.constant - self.currentPanelTopCons < 150) {
                    print("placeselectpanel <150 \(self.currentPanelTopCons), \(self.panelTopCons!.constant)")
                    UIView.animate(withDuration: 0.2, animations: {
                        let gap = self.viewHeight - 150
                        self.panelTopCons?.constant = -gap
                        self.layoutIfNeeded()
                    }, completion: { _ in
                    })
                } else {
                    print("placeselectpanel >150 \(self.currentPanelTopCons), \(self.panelTopCons!.constant)")
                    closePanel(isAnimated: true)
                }
            }

        }
    }
    
    func closePanel(isAnimated: Bool) {
        currentPanelMode = PANEL_MODE_EMPTY
        
        if(isAnimated) {
            UIView.animate(withDuration: 0.2, animations: {
                self.panelTopCons?.constant = 0
                self.layoutIfNeeded()
//                self.superview?.layoutIfNeeded()
            }, completion: { _ in
                self.removeFromSuperview()
            })
        } else {
            self.removeFromSuperview()
        }
        
        delegate?.didClickFinishPlaceSelect()
    }
    
    var isInitialized = false
    func initialize() {
        currentPanelMode = PANEL_MODE_HALF
        
        let gap = viewHeight - 150
        panelTopCons?.constant = -gap
        
        delegate?.didInitializePlaceSelect()
        
        //test > async fetch data
        if(!isInitialized) {
            self.asyncFetchFeed(id: "post_feed")
        }
        
        isInitialized = true
    }
    
    //helper function: top and bottom margin to accomodate spinners while fetching data
    func adjustContentInset(topInset: CGFloat, bottomInset: CGFloat) {
        self.vCV?.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
    }
    func adjustContentOffset(x: CGFloat, y: CGFloat, animated: Bool) {
        self.vCV?.setContentOffset(CGPoint(x: x, y: y), animated: true)
    }
    
    //test > fetch data => temp fake data => try refresh data first
    func asyncFetchFeed(id: String) {
        
        //test
        self.vDataList.removeAll() //test > refresh dataset
        self.vCV?.reloadData()
        
        dataFetchState = "start"
        aSpinner.startAnimating()
        
        //test > adjust contentInset to y = 50 to move cv downward to accomodate spinner
        if(self.currentPanelMode == self.PANEL_MODE_HALF) {
            self.adjustContentInset(topInset: CGFloat(50), bottomInset: CGFloat(200))
        }
        else if(self.currentPanelMode == self.PANEL_MODE_FULL) {
            self.adjustContentInset(topInset: CGFloat(50), bottomInset: CGFloat(50))
        }
        
        let id_ = "post"
        let isPaginate = false
        DataFetchManager.shared.fetchFeedData(id: id_, isPaginate: isPaginate) { [weak self]result in
//        DataFetchManager.shared.fetchData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("api success \(id), \(l)")
                    
                    guard let self = self else {
                        return
                    }
                    
                    //test
                    self.aSpinner.stopAnimating()
                    
                    //test 2 > reload entire dataset
                    for i in l {
                        self.vDataList.append(i)
                    }
                    self.vCV?.reloadData()
                    
                    //*test 3 > reload only appended data, not entire dataset
//                    let dataCount = self.vDataList.count
//                    var indexPaths = [IndexPath]()
//                    var j = 1
//                    for i in l {
//                        self.vDataList.append(i)
//
//                        let idx = IndexPath(item: dataCount - 1 + j, section: 0)
//                        indexPaths.append(idx)
//                        j += 1
//
//                        print("ppv asyncfetch reload \(idx)")
//                    }
//                    self.vCV?.insertItems(at: indexPaths)
                    //*

                    //test > animate cv back to y = 0 by contentOffset then only adjust contentInset after animate
                    self.adjustContentOffset(x: 0, y: 0, animated: true)
                    
                    self.dataFetchState = "end"
                    
                    //test
                    if(l.isEmpty) {
                        self.configureFooterUI(data: "na")
                        self.aaText.text = "No results."
                    }
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    print("api fail")
                    self?.aSpinner.stopAnimating()
                    
                    self?.configureFooterUI(data: "e")
                }
                break
            }
        }
    }
    
    func asyncPaginateFetchFeed(id: String) {
        bSpinner.startAnimating()
        
        pageNumber += 1
        
        let id_ = "post"
        let isPaginate = true
        DataFetchManager.shared.fetchFeedData(id: id_, isPaginate: isPaginate) { [weak self]result in
//        DataFetchManager.shared.fetchData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("api success \(id), \(l), \(l.isEmpty)")
                    
                    guard let self = self else {
                        return
                    }
                    
                    if(l.isEmpty) {
                        self.dataPaginateStatus = "end"
                    }
                    
                    //test
                    self.bSpinner.stopAnimating()
                    
//                    self.vDataList.append(contentsOf: l)
//                    self.vCV?.reloadData()
                    
                    //*test 3 > reload only appended data, not entire dataset
                    let dataCount = self.vDataList.count
                    var indexPaths = [IndexPath]()
                    var j = 1
                    for i in l {
                        self.vDataList.append(i)

                        let idx = IndexPath(item: dataCount - 1 + j, section: 0)
                        indexPaths.append(idx)
                        j += 1

                        print("ppv asyncfetch reload \(idx)")
                    }
                    self.vCV?.insertItems(at: indexPaths)
                    //*
                    
                    //test
                    if(l.isEmpty) {
                        self.configureFooterUI(data: "end")
                    }
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    print("api fail")
                    self?.bSpinner.stopAnimating()
                    
                    self?.configureFooterUI(data: "e")
                }
                break
            }
        }
    }
    
    //test > fetch data => temp fake data => try refresh data first
    func refreshFetchData() {
        configureFooterUI(data: "")
        
        dataPaginateStatus = ""
        self.asyncFetchFeed(id: "post_feed")
    }
    
    //test > footer error handling for refresh feed
    @objc func onErrorRefreshClicked(gesture: UITapGestureRecognizer) {
        print("error refresh clicked")
        refreshFetchData()
    }
    
    var footerState = ""
    var footerAaText = ""
    func setFooterAaText(text: String) {
        footerAaText = text
    }
    func configureFooterUI(data: String) {
        aaText.text = ""
        errorText.text = ""
        errorRefreshBtn.isHidden = true
        
        if(data == "end") {
            aaText.text = "End"
        }
        else if(data == "e") {
            errorText.text = "Something went wrong. Try again"
            errorRefreshBtn.isHidden = false
        }
        else if(data == "na") {
            aaText.text = footerAaText
            //removed, text to be customized at panelview level
        }
        
        footerState = data
    }
}

extension PlaceSelectPanelView: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView,
//                  layout collectionViewLayout: UICollectionViewLayout,
//                  insetForSectionAt section: Int) -> UIEdgeInsets {
//        print("placepanel collection: \(section)")
////        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 100.0, right: 0.0)
//        return UIEdgeInsets(top: 15.0, left: 0.0, bottom: 200.0, right: 0.0)
//    }

    func collectionView(_ collectionView: UICollectionView,
                   layout collectionViewLayout: UICollectionViewLayout,
                   sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("placepanel collection 2: \(indexPath)")
//        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 3 - lay.minimumInteritemSpacing
//        let widthPerItem = collectionView.frame.width / 3 - 40
//        return CGSize(width: widthPerItem - 8, height: 250)
//        return CGSize(width: widthPerItem, height: 160)
//        return CGSize(width: collectionView.frame.width, height: 150)
//        return CGSize(width: collectionView.frame.width - 30, height: 120)
        
        if(indexPath.item == 0) {
            return CGSize(width: collectionView.frame.width, height: 210) //200
        } else {
//            return CGSize(width: collectionView.frame.width - 30, height: 120)
            return CGSize(width: collectionView.frame.width, height: 60)
        }
    }
    
    //test > add footer
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        print("postpanel footer reuse")
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
//            header.addSubview(headerView)
            return header
        case UICollectionView.elementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)
//            footer.addSubview(footerView)
            
            footerView.frame = CGRect(x: 0, y: 0, width: collectionView.frame.width, height: 100)
//            footerView.backgroundColor = .ddmDarkColor
//            footerView.backgroundColor = .blue
            footer.addSubview(footerView)
//            footerView.isHidden = true

            aaText.textAlignment = .left
            aaText.textColor = .white
            aaText.font = .systemFont(ofSize: 12)
            footerView.addSubview(aaText)
            aaText.clipsToBounds = true
            aaText.translatesAutoresizingMaskIntoConstraints = false
//            aaText.centerYAnchor.constraint(equalTo: footerView.centerYAnchor, constant: 0).isActive = true
            aaText.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 20).isActive = true
            aaText.centerXAnchor.constraint(equalTo: footerView.centerXAnchor, constant: 0).isActive = true
            aaText.layer.opacity = 0.5
//            if(dataPaginateStatus == "end") {
//                aaText.text = "End"
//            } else {
//                aaText.text = ""
//            }
            
            bSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
            footer.addSubview(bSpinner)
            bSpinner.translatesAutoresizingMaskIntoConstraints = false
//            bSpinner.centerYAnchor.constraint(equalTo: footer.centerYAnchor).isActive = true
            bSpinner.topAnchor.constraint(equalTo: footer.topAnchor, constant: 20).isActive = true
            bSpinner.centerXAnchor.constraint(equalTo: footer.centerXAnchor).isActive = true
            bSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
            bSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
//            bSpinner.isHidden = true
            
            //test > error handling
            errorText.textAlignment = .center //left
            errorText.textColor = .white
            errorText.font = .systemFont(ofSize: 13)
            footerView.addSubview(errorText)
            errorText.clipsToBounds = true
            errorText.translatesAutoresizingMaskIntoConstraints = false
//            errorText.centerYAnchor.constraint(equalTo: footerView.centerYAnchor, constant: 0).isActive = true
            errorText.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 20).isActive = true
            errorText.centerXAnchor.constraint(equalTo: footerView.centerXAnchor, constant: 0).isActive = true
            errorText.text = ""
            
            errorRefreshBtn.backgroundColor = .ddmDarkColor //test to remove color
            footerView.addSubview(errorRefreshBtn)
            errorRefreshBtn.translatesAutoresizingMaskIntoConstraints = false
            errorRefreshBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
            errorRefreshBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
            errorRefreshBtn.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
            errorRefreshBtn.topAnchor.constraint(equalTo: errorText.bottomAnchor, constant: 10).isActive = true
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
            bMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
            bMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
            
            configureFooterUI(data: footerState)
            
            return footer
        default:
            fatalError("Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        print("postpanel referencesize: \(section)")
        return CGSize(width: collectionView.bounds.size.width, height: 100)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == vDataList.count - 1 {
            print("postpanel willdisplay: \(indexPath.row)")

            if(dataPaginateStatus != "end") {
                if(pageNumber >= 3) {
                    asyncPaginateFetchFeed(id: "post_feed_end")
                } else {
                    asyncPaginateFetchFeed(id: "post_feed")
                }

            }
        }
    }
}

extension PlaceSelectPanelView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HListViewCell.identifier, for: indexPath) as! HListViewCell
////        cell.aDelegate = self
//        return cell
        
        if(indexPath.item == 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HMultiLocationViewCell.identifier, for: indexPath) as! HMultiLocationViewCell
            cell.aDelegate = self
            return cell
        } else {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HListViewCell.identifier, for: indexPath) as! HListViewCell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HSingleLocationViewCell.identifier, for: indexPath) as! HSingleLocationViewCell
            cell.aDelegate = self
            cell.configure(data: vDataList[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

     }
}

extension PlaceSelectPanelView: UITextFieldDelegate {
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        let currentString: NSString = (textField.text ?? "") as NSString
//        print("textfieldchange: \(currentString.length)")
//        if(currentString.length > 0) {
//
//            bbText.isHidden = true
//        } else {
//
//            bbText.isHidden = false
//        }
//
//        return true // Return true to allow the text change to occur
//    }
}

//test > try scrollview listener
extension PlaceSelectPanelView: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollview end: \(scrollView.contentOffset.y)")
        
        //test
        if(scrollView.contentOffset.y == 0) {
            isScrollViewAtTop = true
        } else {
            isScrollViewAtTop = false
        }
        print("scrollview end: \(scrollView.contentOffset.y), \(isScrollViewAtTop)")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollview end drag: \(scrollView.contentOffset.y), \(decelerate)")
        if(!decelerate) {
            
            //test
            if(scrollView.contentOffset.y == 0) {
                isScrollViewAtTop = true
            } else {
                isScrollViewAtTop = false
            }
            print("scrollview end drag check: \(isScrollViewAtTop)")
        }
    }
    
    //test > footer
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

        print("p scrollview animation ended")
        
        //test > reset contentInset to origin of y = 0
        if(self.currentPanelMode == self.PANEL_MODE_HALF) {
            self.adjustContentInset(topInset: CGFloat(0), bottomInset: CGFloat(200))
        }
        else if(self.currentPanelMode == self.PANEL_MODE_FULL) {
            self.adjustContentInset(topInset: CGFloat(0), bottomInset: CGFloat(50))
        }
    }
}

extension PlaceSelectPanelView: HMultiLocationDelegate{
    func didClickUserCurrentLocation(){
        delegate?.didClickUserCurrentLocation(panel: self)
    }
    
    func didClickPlaceLocation() {
        delegate?.didClickPlaceLocation(panel: self)
    }
}

extension PlaceSelectPanelView: HSingleLocationDelegate{
    func didClickSinglePlaceLocation() {
        delegate?.didClickPlaceLocation(panel: self)
    }
}

extension ViewController: PlaceSelectPanelDelegate{
    func didClickUserCurrentLocation(panel : PlaceSelectPanelView) {
        //test > indicate whether user specifically clicked get location button
        isUserGetLocationClicked = true
        
        switch locationManager.authorizationStatus {
        case .authorizedAlways:
            print("location prompt 1")
//            locationManager.requestLocation() //request location once
            
            //test > use latest user location for fast retrieval
//            if(latestUserLocation.latitude != 0.0 && latestUserLocation.longitude != 0.0) {
//                animateMapToUserLocation()
//
//                //test > make panel disappear when animate map
//                panel.closePanel(isAnimated: true)
//            } else {
//                locationManager.requestLocation() //request location once
//            }
            
            //test 2 > use optional latestuserlocation
            guard let latestUserLocation = self.latestUserLocation else {
                locationManager.requestLocation() //request location once
                return
            }
            animateMapToUserLocation()
            //test > make panel disappear when animate map
            panel.closePanel(isAnimated: true)

        case .authorizedWhenInUse:
            print("location prompt 2")
//            locationManager.requestLocation() //request location once
            
            //test > use latest user location for fast retrieval
//            if(latestUserLocation.latitude != 0.0 && latestUserLocation.longitude != 0.0) {
//                animateMapToUserLocation()
//
//                //test > make panel disappear when animate map
//                panel.closePanel(isAnimated: true)
//            } else {
//                locationManager.requestLocation() //request location once
//            }
            
            //test 2 > use optional latestuserlocation
            guard let latestUserLocation = self.latestUserLocation else {
                locationManager.requestLocation() //request location once
                return
            }
            animateMapToUserLocation()
            //test > make panel disappear when animate map
            panel.closePanel(isAnimated: true)
        case .denied:
            print("location prompt 3")
            //test > location error msg
            openLocationErrorPromptMsg()
        case .notDetermined:
            print("location prompt 4")
            //test > location error msg
            openLocationErrorPromptMsg()
        case .restricted:
            print("location prompt 5")
            //test > location error msg
            openLocationErrorPromptMsg()
        @unknown default:
            print("location prompt unknown")
            //test > location error msg
            openLocationErrorPromptMsg()
        }
    }
    func didClickPlaceLocation(panel : PlaceSelectPanelView) {
        panel.closePanel(isAnimated: true)
    }
    func didInitializePlaceSelect() {
        //test > UI change when clicked on place select
        aSemiTransparentText.layer.opacity = 0.3
        arrowBtn.layer.opacity = 0.3
        arrowBtn.image =  UIImage(named:"icon_round_arrow_up")?.withRenderingMode(.alwaysTemplate)
        
        semiGifImageOuter.layer.opacity = 0
        semiGifImage.layer.opacity = 0
        
        semiTransparentSpinner.startAnimating()
        semiTransparentSpinner.isHidden = false
    }
    
    func didClickFinishPlaceSelect() {
        //test > UI change when clicked on place select
        aSemiTransparentText.layer.opacity = 1
        arrowBtn.layer.opacity = 1
        arrowBtn.image =  UIImage(named:"icon_round_arrow_down")?.withRenderingMode(.alwaysTemplate)
        
        semiGifImageOuter.layer.opacity = 1
        semiGifImage.layer.opacity = 1
        
        semiTransparentSpinner.stopAnimating()
        semiTransparentSpinner.isHidden = true
    }
}
