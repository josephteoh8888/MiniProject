//
//  LocationSelectScrollablePanelView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage
import GoogleMaps

protocol LocationSelectScrollablePanelDelegate : AnyObject {
    func didClickCloseLocationSelectScrollablePanel()
    func didChangeMapPaddingLocationSelectScrollable(y: CGFloat)
    //test
//    func transmitLocationSelected(location: String)
    func didFinishInitLocationSelectScrollable(pv: LocationSelectScrollablePanelView)
    
    func didSelectedALocationSelectScrollable(pv: LocationSelectScrollablePanelView)
    func didClickProceedLocationSelectScrollable(location: String)
    func didClickDenyLocationSelectScrollable(pv: LocationSelectScrollablePanelView)
    
    func didStartMapChangeLocationSelectScrollable(pv: LocationSelectScrollablePanelView)
    func didFinishMapChangeLocationSelectScrollable(pv: LocationSelectScrollablePanelView)
}
protocol SuggestedLocationResultDelegate : AnyObject {
    func didSuggestedLocationResultClick()
}
protocol SuggestedLocationTabDelegate : AnyObject {
    func didSuggestedLocationTabClick(s: SuggestedLocationTab)
}

class SuggestedLocationResult: UIView {
    
    let aHLightRect1 = UIView()
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    let aaText = UILabel()
    
    weak var aDelegate : SuggestedLocationResultDelegate?
    
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
        //move to redrawUI()
//        redrawUI()
    }
    
    func redrawUI() {
        let l1Box = UIView()
//        aBox.backgroundColor = .ddmBlackOverlayColor
//        l1Box.backgroundColor = .ddmDarkBlack //ori
        l1Box.backgroundColor = .ddmBlackDark
        self.addSubview(l1Box)
        l1Box.clipsToBounds = true
        l1Box.translatesAutoresizingMaskIntoConstraints = false
        l1Box.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        l1Box.heightAnchor.constraint(equalToConstant: 40).isActive = true //default: 50
        l1Box.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        l1Box.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        l1Box.layer.cornerRadius = 5
//        l1Box.layer.opacity = 0.2 //0.3
        l1Box.isUserInteractionEnabled = true
        l1Box.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onL1Clicked)))
        
        let l1BoxBox = UIView()
        l1BoxBox.backgroundColor = .clear //yellow
        l1Box.addSubview(l1BoxBox)
        l1BoxBox.clipsToBounds = true
        l1BoxBox.translatesAutoresizingMaskIntoConstraints = false
        l1BoxBox.widthAnchor.constraint(equalToConstant: 20).isActive = true //ori: 40
        l1BoxBox.heightAnchor.constraint(equalToConstant: 20).isActive = true
        l1BoxBox.centerYAnchor.constraint(equalTo: l1Box.centerYAnchor).isActive = true
        l1BoxBox.leadingAnchor.constraint(equalTo: l1Box.leadingAnchor, constant: 5).isActive = true //10
        l1BoxBox.layer.cornerRadius = 5 //6

        let gridViewBtn = UIImageView(image: UIImage(named:"icon_location")?.withRenderingMode(.alwaysTemplate))
        gridViewBtn.tintColor = .white
        l1BoxBox.addSubview(gridViewBtn)
        gridViewBtn.translatesAutoresizingMaskIntoConstraints = false
        gridViewBtn.centerXAnchor.constraint(equalTo: l1BoxBox.centerXAnchor).isActive = true
        gridViewBtn.centerYAnchor.constraint(equalTo: l1BoxBox.centerYAnchor).isActive = true
        gridViewBtn.heightAnchor.constraint(equalToConstant: 16).isActive = true
        gridViewBtn.widthAnchor.constraint(equalToConstant: 16).isActive = true
//        gridViewBtn.layer.opacity = 0.5

//        let aaText = UILabel()
        aaText.textAlignment = .left
        aaText.textColor = .white
//        aaText.textColor = .ddmDarkColor
        aaText.font = .boldSystemFont(ofSize: 13)
//        aaText.font = .systemFont(ofSize: 12)
        l1Box.addSubview(aaText)
        aaText.clipsToBounds = true
        aaText.translatesAutoresizingMaskIntoConstraints = false
        aaText.topAnchor.constraint(equalTo: l1Box.topAnchor, constant: 5).isActive = true
        aaText.bottomAnchor.constraint(equalTo: l1Box.bottomAnchor, constant: -5).isActive = true
        aaText.leadingAnchor.constraint(equalTo: l1BoxBox.trailingAnchor, constant: 5).isActive = true //10
        aaText.trailingAnchor.constraint(equalTo: l1Box.trailingAnchor, constant: -10).isActive = true
//        aaText.text = "Petronas Twin Tower"
        aaText.text = ""
//        aaText.layer.opacity = 0.5
    }
    
    @objc func onL1Clicked(gesture: UITapGestureRecognizer) {
        aDelegate?.didSuggestedLocationResultClick()
    }
    
    func configureUI(data: String) {
        aaText.text = data
    }
}
class SuggestedLocationTab: UIView {
    
    let aHLightRect1 = UIView()
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    let l1Box = UIView()
    let aaText = UILabel()
    let l1TabArrowBtn = UIImageView()
    var aaTextTrailingCons: NSLayoutConstraint?
    var l1TabArrowBtnTrailingCons: NSLayoutConstraint?
    
    weak var aDelegate : SuggestedLocationTabDelegate?
    
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
        //move to redrawUI()
//        redrawUI()
    }
    
    func redrawUI() {
//        let l1Box = UIView()
//        aBox.backgroundColor = .ddmBlackOverlayColor
        l1Box.backgroundColor = .ddmDarkBlack //ori
//        l1Box.backgroundColor = .ddmBlackDark
        self.addSubview(l1Box)
        l1Box.clipsToBounds = true
        l1Box.translatesAutoresizingMaskIntoConstraints = false
        l1Box.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        l1Box.heightAnchor.constraint(equalToConstant: 30).isActive = true //default: 50
        l1Box.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        l1Box.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        l1Box.layer.cornerRadius = 5
//        l1Box.layer.opacity = 0.2 //0.3
        l1Box.isUserInteractionEnabled = true
        l1Box.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onS1Clicked)))

//        let aaText = UILabel()
        aaText.textAlignment = .left
        aaText.textColor = .ddmDarkGrayColor
//        aaText.textColor = .ddmDarkColor
        aaText.font = .boldSystemFont(ofSize: 13)
//        aaText.font = .systemFont(ofSize: 12)
        l1Box.addSubview(aaText)
        aaText.clipsToBounds = true
        aaText.translatesAutoresizingMaskIntoConstraints = false
        aaText.centerYAnchor.constraint(equalTo: l1Box.centerYAnchor).isActive = true
        aaText.leadingAnchor.constraint(equalTo: l1Box.leadingAnchor, constant: 7).isActive = true //10
        aaTextTrailingCons = aaText.trailingAnchor.constraint(equalTo: l1Box.trailingAnchor, constant: -7)
        aaTextTrailingCons?.isActive = true
//        aaText.trailingAnchor.constraint(equalTo: l1Box.trailingAnchor, constant: -7).isActive = true
//        aaText.text = "Petronas Twin Tower"
        aaText.text = "" //Created
//        aaText.layer.opacity = 0.5
        
//        let l1TabArrowBtn = UIImageView()
//        l1TabArrowBtn.image = UIImage(named:"icon_arrow_down")?.withRenderingMode(.alwaysTemplate)
        l1TabArrowBtn.image = UIImage(named:"icon_round_arrow_down")?.withRenderingMode(.alwaysTemplate)
        l1TabArrowBtn.tintColor = .white
//        self.view.addSubview(arrowBtn)
        l1Box.addSubview(l1TabArrowBtn)
        l1TabArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        l1TabArrowBtn.leadingAnchor.constraint(equalTo: aaText.trailingAnchor, constant: 0).isActive = true
        l1TabArrowBtnTrailingCons = l1TabArrowBtn.trailingAnchor.constraint(equalTo: l1Box.trailingAnchor, constant: 0)
        l1TabArrowBtnTrailingCons?.isActive = false
//        l1TabArrowBtn.trailingAnchor.constraint(equalTo: l1Box.trailingAnchor, constant: 0).isActive = true //-5
        l1TabArrowBtn.centerYAnchor.constraint(equalTo: aaText.centerYAnchor).isActive = true
        l1TabArrowBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true //ori 26
        l1TabArrowBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        l1TabArrowBtn.layer.opacity = 0.5
        l1TabArrowBtn.isHidden = true
    }
    
    @objc func onS1Clicked(gesture: UITapGestureRecognizer) {
        aDelegate?.didSuggestedLocationTabClick(s: self)
    }
    
    func configureUI(data: String) {
        aaText.text = data
    }
    
    func selectTab() {
        l1Box.backgroundColor = .ddmBlackDark
        aaText.textColor = .white
        aaTextTrailingCons?.isActive = false
        l1TabArrowBtnTrailingCons?.isActive = true
        l1TabArrowBtn.isHidden = false
    }
    
    func unselectTab() {
        l1Box.backgroundColor = .ddmDarkBlack
        aaText.textColor = .ddmDarkGrayColor
        aaTextTrailingCons?.isActive = true
        l1TabArrowBtnTrailingCons?.isActive = false
        l1TabArrowBtn.isHidden = true
    }
}
class LocationSelectScrollablePanelView: ScrollablePanelView{
    
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    var panelView = UIView()
    
    //test > new
    var panelTopCons: NSLayoutConstraint?
    var currentPanelTopCons : CGFloat = 0.0
    let PANEL_MODE_HALF: String = "half"
    let PANEL_MODE_EMPTY: String = "empty"
    let PANEL_MODE_FULL: String = "full"
    var scrollablePanelHeight : CGFloat = 0.0 //300
    var halfModeMapPadding : CGFloat = 150.0 //200
    
    var currentPanelMode = ""
    var currentMapPaddingBottom: CGFloat = 0
    
//    let aTextBox = UIView()
    var aTextBoxTopCons: NSLayoutConstraint?
    let bTextField = UITextField()
    let bTextBox = UIView()
    let aPanel = UIView()
    let bPanel = UIView()
    let cPanel = UIView()
    
    var currentLSelectMode = ""
    let LSELECT_MODE_SELECTED_PIN: String = "pin"
    let LSELECT_MODE_SELECTED_PLACE: String = "place"
    let LSELECT_MODE_EMPTY: String = "empty"
    
    weak var delegate : LocationSelectScrollablePanelDelegate?
    
    //test > for search places
    var vDataList = [String]()
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
    
    //test > location suggestions for user
    let cSpinner = SpinLoader()
    let aScroll1 = UIScrollView()
    var uDataList = [String]()
    var aHLightViewArray = [UIView]()
    
    var tabDataList = [String]()
    var aTabViewArray = [SuggestedLocationTab]()
    let pImage = SDAnimatedImageView()
    let lGrid = UIView()
    let cErrorText = UILabel()
    let cErrorRefreshBtn = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        viewWidth = frame.width
        viewHeight = frame.height
//        setupViews()

    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

//        setupViews()
    }

    func setupViews() {
        panelView.backgroundColor = .ddmBlackOverlayColor
        self.addSubview(panelView)
        panelView.translatesAutoresizingMaskIntoConstraints = false
        panelView.layer.masksToBounds = true
        panelView.layer.cornerRadius = 10 //10
        panelView.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        panelView.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
//        panelView.layer.opacity = 0.5
        
        aPanel.backgroundColor = .ddmBlackOverlayColor
        panelView.addSubview(aPanel)
        aPanel.translatesAutoresizingMaskIntoConstraints = false
        aPanel.layer.masksToBounds = true
        aPanel.layer.cornerRadius = 10 //10
        aPanel.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        aPanel.heightAnchor.constraint(equalToConstant: scrollablePanelHeight).isActive = true
        aPanel.isHidden = false
        
        let aPillBtn = UIView()
        aPillBtn.backgroundColor = .ddmDarkColor
        aPanel.addSubview(aPillBtn)
        aPillBtn.translatesAutoresizingMaskIntoConstraints = false
        aPillBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
        aPillBtn.heightAnchor.constraint(equalToConstant: 6).isActive = true
        aPillBtn.centerXAnchor.constraint(equalTo: aPanel.centerXAnchor).isActive = true
        aPillBtn.topAnchor.constraint(equalTo: aPanel.topAnchor, constant: 10).isActive = true
        aPillBtn.layer.cornerRadius = 3
        
        //pin location
        let xGrid = UIView()
        xGrid.backgroundColor = .ddmDarkBlack
//        panel.addSubview(aGrid)
        aPanel.addSubview(xGrid)
        xGrid.translatesAutoresizingMaskIntoConstraints = false
//        xGrid.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 20).isActive = true
//        xGrid.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20).isActive = true
        xGrid.leadingAnchor.constraint(equalTo: aPanel.leadingAnchor, constant: 15).isActive = true
        xGrid.trailingAnchor.constraint(equalTo: aPanel.trailingAnchor, constant: -15).isActive = true
//        xGrid.topAnchor.constraint(equalTo: aTextBox.bottomAnchor, constant: 20).isActive = true //10
        xGrid.topAnchor.constraint(equalTo: aPanel.topAnchor, constant: 30).isActive = true //10
        xGrid.heightAnchor.constraint(equalToConstant: 40).isActive = true //40
        xGrid.layer.cornerRadius = 10
//        xGrid.layer.opacity = 0.1
        xGrid.isUserInteractionEnabled = true
        xGrid.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPinClicked)))
        
        let xGridBG = UIView()
//        xGridBG.backgroundColor = .ddmDarkColor //ori
//        xGridBG.backgroundColor = .clear
//        panel.addSubview(xGridBG)
        aPanel.addSubview(xGridBG)
        xGridBG.translatesAutoresizingMaskIntoConstraints = false
        xGridBG.leadingAnchor.constraint(equalTo: xGrid.leadingAnchor, constant: 10).isActive = true
        xGridBG.heightAnchor.constraint(equalToConstant: 30).isActive = true
        xGridBG.widthAnchor.constraint(equalToConstant: 30).isActive = true
        xGridBG.centerYAnchor.constraint(equalTo: xGrid.centerYAnchor, constant: 0).isActive = true
        xGridBG.layer.cornerRadius = 5 //20
        
//        let xGridIcon = UIImageView(image: UIImage(named:"icon_location")?.withRenderingMode(.alwaysTemplate))
        let xGridIcon = UIImageView(image: UIImage(named:"icon_round_pin_location")?.withRenderingMode(.alwaysTemplate))
        xGridIcon.tintColor = .white
//        panel.addSubview(aGridIcon)
        aPanel.addSubview(xGridIcon)
        xGridIcon.translatesAutoresizingMaskIntoConstraints = false
        xGridIcon.centerXAnchor.constraint(equalTo: xGridBG.centerXAnchor).isActive = true
        xGridIcon.centerYAnchor.constraint(equalTo: xGridBG.centerYAnchor).isActive = true
//        xGridIcon.leadingAnchor.constraint(equalTo: xGrid.leadingAnchor, constant: 10).isActive = true
//        xGridIcon.centerYAnchor.constraint(equalTo: xGrid.centerYAnchor).isActive = true
        xGridIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        xGridIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        xGridIcon.layer.opacity = 0.5
        
        let xText = UILabel()
        xText.textAlignment = .left
        xText.textColor = .white
        xText.font = .boldSystemFont(ofSize: 14)
//        xText.font = .systemFont(ofSize: 14)
//        panel.addSubview(xText)
        aPanel.addSubview(xText)
        xText.translatesAutoresizingMaskIntoConstraints = false
        xText.centerYAnchor.constraint(equalTo: xGrid.centerYAnchor, constant: 0).isActive = true
        xText.leadingAnchor.constraint(equalTo: xGridBG.trailingAnchor, constant: 10).isActive = true //ori: 20
//        xText.text = "Everyone Can See"
        xText.text = "Pin Map Location"
//        xText.layer.opacity = 0.5
        
//        let aArrowBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right")?.withRenderingMode(.alwaysTemplate))
//        aArrowBtn.tintColor = .white
////        panel.addSubview(aArrowBtn)
//        panelView.addSubview(aArrowBtn)
//        aArrowBtn.translatesAutoresizingMaskIntoConstraints = false
//        aArrowBtn.trailingAnchor.constraint(equalTo: aGrid.trailingAnchor).isActive = true
//        aArrowBtn.centerYAnchor.constraint(equalTo: aGrid.centerYAnchor).isActive = true
//        aArrowBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
//        aArrowBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
//        aArrowBtn.layer.opacity = 0.5
        
        //fake search
        let aTextBox = UIView()
        aPanel.addSubview(aTextBox)
        aTextBox.translatesAutoresizingMaskIntoConstraints = false
//        aTextBoxTopCons = aTextBox.topAnchor.constraint(equalTo: panelView.topAnchor, constant: 20)
        aTextBoxTopCons = aTextBox.topAnchor.constraint(equalTo: xGrid.bottomAnchor, constant: 10)
        aTextBoxTopCons?.isActive = true
//        aTextBox.topAnchor.constraint(equalTo: tText.bottomAnchor, constant: 20).isActive = true
        aTextBox.leadingAnchor.constraint(equalTo: aPanel.leadingAnchor, constant: 15).isActive = true
        aTextBox.trailingAnchor.constraint(equalTo: aPanel.trailingAnchor, constant: -15).isActive = true
        aTextBox.heightAnchor.constraint(equalToConstant: 40).isActive = true //40
        aTextBox.backgroundColor = .clear
        aTextBox.layer.cornerRadius = 10
        aTextBox.isUserInteractionEnabled = true
        aTextBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onOpenTextBoxClicked)))
        
        let aTextBg = UIView()
        aTextBg.backgroundColor = .ddmDarkBlack
//        panel.addSubview(aGrid)
        aTextBox.addSubview(aTextBg)
        aTextBg.translatesAutoresizingMaskIntoConstraints = false
        aTextBg.leadingAnchor.constraint(equalTo: aTextBox.leadingAnchor, constant: 0).isActive = true
        aTextBg.trailingAnchor.constraint(equalTo: aTextBox.trailingAnchor, constant: 0).isActive = true
        aTextBg.bottomAnchor.constraint(equalTo: aTextBox.bottomAnchor, constant: 0).isActive = true //10
        aTextBg.topAnchor.constraint(equalTo: aTextBox.topAnchor, constant: 0).isActive = true //10
        aTextBg.layer.cornerRadius = 10
//        aTextBg.layer.opacity = 0.1
        
        let aGridBG = UIView()
//        aGridBG.backgroundColor = .ddmDarkColor //ori
//        aGridBG.backgroundColor = .clear
//        panel.addSubview(aGridBG)
        aPanel.addSubview(aGridBG)
        aGridBG.translatesAutoresizingMaskIntoConstraints = false
        aGridBG.leadingAnchor.constraint(equalTo: aTextBox.leadingAnchor, constant: 10).isActive = true
        aGridBG.heightAnchor.constraint(equalToConstant: 30).isActive = true
        aGridBG.widthAnchor.constraint(equalToConstant: 30).isActive = true
        aGridBG.centerYAnchor.constraint(equalTo: aTextBox.centerYAnchor, constant: 0).isActive = true
        aGridBG.layer.cornerRadius = 5 //20
        
        let aTextSearch = UIImageView()
        aTextSearch.image = UIImage(named:"icon_round_search")?.withRenderingMode(.alwaysTemplate)
        aTextSearch.tintColor = .white
//        aTextBox.addSubview(aTextSearch)
        aPanel.addSubview(aTextSearch)
        aTextSearch.translatesAutoresizingMaskIntoConstraints = false
//        aTextSearch.leadingAnchor.constraint(equalTo: aTextBox.leadingAnchor, constant: 10).isActive = true
//        aTextSearch.centerYAnchor.constraint(equalTo: aTextBox.centerYAnchor).isActive = true
        aTextSearch.centerXAnchor.constraint(equalTo: aGridBG.centerXAnchor).isActive = true
        aTextSearch.centerYAnchor.constraint(equalTo: aGridBG.centerYAnchor).isActive = true
        aTextSearch.heightAnchor.constraint(equalToConstant: 20).isActive = true //ori 26
        aTextSearch.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        aTextSearch.layer.opacity = 0.5
        
        let aText = UILabel()
        aText.textAlignment = .left
        aText.textColor = .white
        aText.font = .boldSystemFont(ofSize: 14)
//        aText.font = .systemFont(ofSize: 14)
//        panel.addSubview(aText)
        aPanel.addSubview(aText)
        aText.translatesAutoresizingMaskIntoConstraints = false
        aText.centerYAnchor.constraint(equalTo: aTextBox.centerYAnchor, constant: 0).isActive = true
        aText.leadingAnchor.constraint(equalTo: aGridBG.trailingAnchor, constant: 10).isActive = true //ori: 20
//        aText.text = "Everyone Can See"
        aText.text = "Search Place"
        
//        let lGrid = UIView()
//        lGrid.backgroundColor = .ddmDarkColor
        lGrid.backgroundColor = .clear
//        panel.addSubview(aGrid)
        aPanel.addSubview(lGrid)
        lGrid.translatesAutoresizingMaskIntoConstraints = false
        lGrid.leadingAnchor.constraint(equalTo: aPanel.leadingAnchor, constant: 15).isActive = true
        lGrid.trailingAnchor.constraint(equalTo: aPanel.trailingAnchor, constant: -15).isActive = true
        lGrid.topAnchor.constraint(equalTo: aTextBox.bottomAnchor, constant: 30).isActive = true //20
        lGrid.heightAnchor.constraint(equalToConstant: 30).isActive = true //40
        lGrid.layer.cornerRadius = 10
//        lGrid.layer.opacity = 0.1
        
        let pImageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/trail-test-45362.appspot.com/o/temp_gif_4.gif?alt=media")
//        let pImage = SDAnimatedImageView()
        pImage.contentMode = .scaleAspectFill
        pImage.layer.masksToBounds = true
        pImage.sd_setImage(with: pImageUrl)
        aPanel.addSubview(pImage)
        pImage.translatesAutoresizingMaskIntoConstraints = false
        pImage.leadingAnchor.constraint(equalTo: lGrid.leadingAnchor, constant: 10).isActive = true
        pImage.centerYAnchor.constraint(equalTo: lGrid.centerYAnchor, constant: 0).isActive = true
        pImage.heightAnchor.constraint(equalToConstant: 28).isActive = true
        pImage.widthAnchor.constraint(equalToConstant: 28).isActive = true //30
        pImage.layer.cornerRadius = 14
        pImage.backgroundColor = .ddmDarkColor
        
        //*selection tab for suggested locations
        tabDataList.append("c") //created
        tabDataList.append("b") //bookmark
        tabDataList.append("n") //near me
        //*
        
        aPanel.addSubview(aScroll1)
        aScroll1.translatesAutoresizingMaskIntoConstraints = false
//        aScroll1.widthAnchor.constraint(equalToConstant: scrollViewWidth).isActive = true //ori: 80
        aScroll1.heightAnchor.constraint(equalToConstant: 40).isActive = true //60
        aScroll1.leadingAnchor.constraint(equalTo: aPanel.leadingAnchor, constant: 0).isActive = true
        aScroll1.trailingAnchor.constraint(equalTo: aPanel.trailingAnchor, constant: 0).isActive = true
        aScroll1.topAnchor.constraint(equalTo: lGrid.bottomAnchor, constant: 10).isActive = true
//        aScroll1.bottomAnchor.constraint(equalTo: aHLightRect1.bottomAnchor, constant: -10).isActive = true
        aScroll1.showsHorizontalScrollIndicator = false
        aScroll1.showsVerticalScrollIndicator = false
//        aScroll1.backgroundColor = .red
        
        aPanel.addSubview(cSpinner)
        cSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        cSpinner.translatesAutoresizingMaskIntoConstraints = false
        cSpinner.centerYAnchor.constraint(equalTo: aScroll1.centerYAnchor, constant: CGFloat(0)).isActive = true
//        cSpinner.centerXAnchor.constraint(equalTo: aPanel.centerXAnchor).isActive = true
        cSpinner.leadingAnchor.constraint(equalTo: lGrid.leadingAnchor, constant: 20).isActive = true
        cSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        cSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        cSpinner.startAnimating()
        
        //test > error handling
        cErrorText.textAlignment = .center //left
        cErrorText.textColor = .white
        cErrorText.font = .systemFont(ofSize: 13)
        aPanel.addSubview(cErrorText)
        cErrorText.clipsToBounds = true
        cErrorText.translatesAutoresizingMaskIntoConstraints = false
        cErrorText.centerYAnchor.constraint(equalTo: aScroll1.centerYAnchor, constant: 0).isActive = true
        cErrorText.leadingAnchor.constraint(equalTo: lGrid.leadingAnchor, constant: 20).isActive = true
//        cErrorText.centerXAnchor.constraint(equalTo: aPanel.centerXAnchor, constant: -20).isActive = true
        cErrorText.text = ""
        cErrorText.numberOfLines = 0
        cErrorText.isHidden = true
        
//        errorRefreshBtn.backgroundColor = .ddmDarkColor //test to remove color
        aPanel.addSubview(cErrorRefreshBtn)
        cErrorRefreshBtn.translatesAutoresizingMaskIntoConstraints = false
        cErrorRefreshBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
        cErrorRefreshBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        errorRefreshBtn.centerXAnchor.constraint(equalTo: aHLightRect1.centerXAnchor).isActive = true
//        errorRefreshBtn.topAnchor.constraint(equalTo: errorText.bottomAnchor, constant: 0).isActive = true
        cErrorRefreshBtn.centerYAnchor.constraint(equalTo: cErrorText.centerYAnchor, constant: 0).isActive = true //test
        cErrorRefreshBtn.leadingAnchor.constraint(equalTo: cErrorText.trailingAnchor).isActive = true
        cErrorRefreshBtn.layer.cornerRadius = 20
        cErrorRefreshBtn.isUserInteractionEnabled = true
        cErrorRefreshBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCErrorRefreshClicked)))
        cErrorRefreshBtn.isHidden = true
        
        let cbMiniBtn = UIImageView(image: UIImage(named:"icon_round_refresh")?.withRenderingMode(.alwaysTemplate))
//        bMiniBtn.tintColor = .black
        cbMiniBtn.tintColor = .white
        cErrorRefreshBtn.addSubview(cbMiniBtn)
        cbMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        cbMiniBtn.centerXAnchor.constraint(equalTo: cErrorRefreshBtn.centerXAnchor).isActive = true
        cbMiniBtn.centerYAnchor.constraint(equalTo: cErrorRefreshBtn.centerYAnchor).isActive = true
        cbMiniBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true //26
        cbMiniBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        //real text field
//        let bPanel = UIView()
        bPanel.backgroundColor = .ddmBlackOverlayColor
        panelView.addSubview(bPanel)
        bPanel.translatesAutoresizingMaskIntoConstraints = false
        bPanel.layer.masksToBounds = true
        bPanel.layer.cornerRadius = 10 //10
        bPanel.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        bPanel.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        bPanel.isHidden = true
        
        let acBtn = UIView()
//        aBtn.backgroundColor = .ddmDarkColor
        bPanel.addSubview(acBtn)
        acBtn.translatesAutoresizingMaskIntoConstraints = false
        acBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
        acBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        aBtn.leadingAnchor.constraint(equalTo: aStickyHeader.leadingAnchor, constant: 10).isActive = true
        acBtn.leadingAnchor.constraint(equalTo: bPanel.leadingAnchor, constant: 10).isActive = true
    //        aBtn.topAnchor.constraint(equalTo: userPanel.topAnchor, constant: 30).isActive = true
        acBtn.topAnchor.constraint(equalTo: bPanel.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
//        let topInsetMargin = panel.safeAreaInsets.top + 10
//        aBtn.topAnchor.constraint(equalTo: panel.topAnchor, constant: 50).isActive = true
        acBtn.layer.cornerRadius = 20
//        aBtn.layer.opacity = 0.3
        acBtn.isUserInteractionEnabled = true
        acBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCloseTextBoxClicked)))

//        let bcMiniBtn = UIImageView(image: UIImage(named:"icon_round_arrow_left")?.withRenderingMode(.alwaysTemplate))
        let bcMiniBtn = UIImageView(image: UIImage(named:"icon_round_arrow_down_a")?.withRenderingMode(.alwaysTemplate))
//        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_close")?.withRenderingMode(.alwaysTemplate))
        bcMiniBtn.tintColor = .white
//        aStickyHeader.addSubview(bMiniBtn)
        acBtn.addSubview(bcMiniBtn)
        bcMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        bcMiniBtn.centerXAnchor.constraint(equalTo: acBtn.centerXAnchor).isActive = true
        bcMiniBtn.centerYAnchor.constraint(equalTo: acBtn.centerYAnchor).isActive = true
        bcMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        bcMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        
//        let bTextBox = UIView()
        bPanel.addSubview(bTextBox)
        bTextBox.translatesAutoresizingMaskIntoConstraints = false
//        bTextBox.topAnchor.constraint(equalTo: aTextBox.topAnchor, constant: 0).isActive = true
        bTextBox.topAnchor.constraint(equalTo: bPanel.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
//        bTextBox.topAnchor.constraint(equalTo: bPanel.topAnchor, constant: 60).isActive = true //ori
//        bTextBox.leadingAnchor.constraint(equalTo: bPanel.leadingAnchor, constant: 15).isActive = true
        bTextBox.leadingAnchor.constraint(equalTo: acBtn.trailingAnchor, constant: 0).isActive = true
        bTextBox.trailingAnchor.constraint(equalTo: bPanel.trailingAnchor, constant: -15).isActive = true
        bTextBox.heightAnchor.constraint(equalToConstant: 40).isActive = true
        bTextBox.backgroundColor = .ddmDarkColor
        bTextBox.layer.cornerRadius = 10
        
        let bTextSearch = UIImageView()
        bTextSearch.image = UIImage(named:"icon_round_search")?.withRenderingMode(.alwaysTemplate)
        bTextSearch.tintColor = .ddmDarkGrayColor
        bTextBox.addSubview(bTextSearch)
//        panelView.addSubview(bTextSearch)
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
//        panelView.addSubview(bTextField)
        bTextField.translatesAutoresizingMaskIntoConstraints = false
        bTextField.leadingAnchor.constraint(equalTo: bTextSearch.trailingAnchor, constant: 10).isActive = true
        bTextField.trailingAnchor.constraint(equalTo: bTextBox.trailingAnchor, constant: -50).isActive = true
        bTextField.centerYAnchor.constraint(equalTo: bTextBox.centerYAnchor, constant: 0).isActive = true
        bTextField.text = ""
        bTextField.tintColor = .yellow
        bTextField.returnKeyType = UIReturnKeyType.search
//        bTextField.delegate = self
        bTextField.placeholder = "Search Place..."
        
        let bBox = UIView()
        bBox.backgroundColor = .white
        bTextBox.addSubview(bBox)
//        panelView.addSubview(bBox)
        bBox.clipsToBounds = true
        bBox.translatesAutoresizingMaskIntoConstraints = false
        bBox.widthAnchor.constraint(equalToConstant: 20).isActive = true //ori: 40
        bBox.heightAnchor.constraint(equalToConstant: 20).isActive = true
        bBox.centerYAnchor.constraint(equalTo: bTextBox.centerYAnchor).isActive = true
        bBox.trailingAnchor.constraint(equalTo: bTextBox.trailingAnchor, constant: -10).isActive = true
        bBox.layer.cornerRadius = 10
//        bBox.isHidden = true
        bBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onEraseSearchTextClicked)))
        
        let aBtn = UIImageView(image: UIImage(named:"icon_round_close")?.withRenderingMode(.alwaysTemplate))
        aBtn.tintColor = .ddmDarkColor
        bBox.addSubview(aBtn)
        aBtn.translatesAutoresizingMaskIntoConstraints = false
        aBtn.centerXAnchor.constraint(equalTo: bBox.centerXAnchor).isActive = true
        aBtn.centerYAnchor.constraint(equalTo: bBox.centerYAnchor).isActive = true
        aBtn.heightAnchor.constraint(equalToConstant: 16).isActive = true
        aBtn.widthAnchor.constraint(equalToConstant: 16).isActive = true
        
        let gridLayout = UICollectionViewFlowLayout()
        gridLayout.scrollDirection = .vertical
        gridLayout.minimumLineSpacing = 10 //default: 20 => spacing between rows
        gridLayout.minimumInteritemSpacing = 0 //default: 4 => spacing between columns
//        let vCV = UICollectionView(frame: .zero, collectionViewLayout: gridLayout)
        vCV = UICollectionView(frame: .zero, collectionViewLayout: gridLayout)
        guard let vCV = vCV else {
            return
        }
        vCV.register(HSingleLocationViewCell.self, forCellWithReuseIdentifier: HSingleLocationViewCell.identifier)
        vCV.dataSource = self
        vCV.delegate = self
        vCV.backgroundColor = .clear
        bPanel.addSubview(vCV)
        vCV.translatesAutoresizingMaskIntoConstraints = false
        vCV.topAnchor.constraint(equalTo: bTextBox.bottomAnchor, constant: 10).isActive = true
        vCV.leadingAnchor.constraint(equalTo: bPanel.leadingAnchor).isActive = true
        vCV.bottomAnchor.constraint(equalTo: bPanel.bottomAnchor, constant: 0).isActive = true
        vCV.trailingAnchor.constraint(equalTo: bPanel.trailingAnchor).isActive = true
        vCV.contentInsetAdjustmentBehavior = .never
//        let vcvPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onVCVPanGesture))
//        vcvPanGesture.delegate = self //for simultaneous pan recognizer for uicollectionview
//        vCV.addGestureRecognizer(vcvPanGesture)
        vCV.alwaysBounceVertical = true
        
        //test > top spinner
        vCV.addSubview(aSpinner)
        aSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        aSpinner.translatesAutoresizingMaskIntoConstraints = false
        aSpinner.topAnchor.constraint(equalTo: vCV.topAnchor, constant: CGFloat(35)).isActive = true
        aSpinner.centerXAnchor.constraint(equalTo: vCV.centerXAnchor).isActive = true
        aSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        aSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        //test > add footer ***
        vCV.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer")
        //***
        
        cPanel.backgroundColor = .ddmBlackOverlayColor
        panelView.addSubview(cPanel)
        cPanel.translatesAutoresizingMaskIntoConstraints = false
        cPanel.layer.masksToBounds = true
        cPanel.layer.cornerRadius = 10 //10
        cPanel.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        cPanel.heightAnchor.constraint(equalToConstant: scrollablePanelHeight).isActive = true
        cPanel.isHidden = true
        
        let cPillBtn = UIView()
        cPillBtn.backgroundColor = .ddmDarkColor
        cPanel.addSubview(cPillBtn)
        cPillBtn.translatesAutoresizingMaskIntoConstraints = false
        cPillBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
        cPillBtn.heightAnchor.constraint(equalToConstant: 6).isActive = true
        cPillBtn.centerXAnchor.constraint(equalTo: cPanel.centerXAnchor).isActive = true
        cPillBtn.topAnchor.constraint(equalTo: cPanel.topAnchor, constant: 10).isActive = true
        cPillBtn.layer.cornerRadius = 3
        
        let aaBtn = UIView()
//        aBtn.backgroundColor = .ddmDarkColor
        cPanel.addSubview(aaBtn)
        aaBtn.translatesAutoresizingMaskIntoConstraints = false
        aaBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
        aaBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        aaBtn.leadingAnchor.constraint(equalTo: cPanel.leadingAnchor, constant: 20).isActive = true
        aaBtn.layer.cornerRadius = 20
//        aaBtn.layer.opacity = 0.3
        aaBtn.isUserInteractionEnabled = true
        aaBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onExitViewClicked)))
        aaBtn.topAnchor.constraint(equalTo: cPanel.topAnchor, constant: 20).isActive = true
        
        let bMiniBtn = UIImageView(image: UIImage(named:"icon_round_arrow_left")?.withRenderingMode(.alwaysTemplate))
        bMiniBtn.tintColor = .white
        aaBtn.addSubview(bMiniBtn)
        bMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        bMiniBtn.centerXAnchor.constraint(equalTo: aaBtn.centerXAnchor).isActive = true
        bMiniBtn.centerYAnchor.constraint(equalTo: aaBtn.centerYAnchor).isActive = true
        bMiniBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        bMiniBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        
        let cTitleText = UILabel()
        cTitleText.textAlignment = .center
        cTitleText.textColor = .white
//        cTitleText.textColor = .ddmBlackOverlayColor
        cTitleText.font = .boldSystemFont(ofSize: 14) //16
        cPanel.addSubview(cTitleText)
        cTitleText.translatesAutoresizingMaskIntoConstraints = false
//        cTitleText.topAnchor.constraint(equalTo: cPanel.topAnchor, constant: 50).isActive = true
        cTitleText.topAnchor.constraint(equalTo: aaBtn.bottomAnchor, constant: 0).isActive = true
        cTitleText.leadingAnchor.constraint(equalTo: cPanel.leadingAnchor, constant: 20).isActive = true
        cTitleText.trailingAnchor.constraint(equalTo: cPanel.trailingAnchor, constant: -20).isActive = true
        cTitleText.numberOfLines = 0
        cTitleText.text = "Confirm to use this Location?"
        
//        let cLBox = UIView()
////        cLBox.backgroundColor = .ddmBlackOverlayColor
//        cLBox.backgroundColor = .ddmDarkColor
//        cPanel.addSubview(cLBox)
//        cLBox.clipsToBounds = true
//        cLBox.translatesAutoresizingMaskIntoConstraints = false
//        cLBox.leadingAnchor.constraint(equalTo: cPanel.leadingAnchor, constant: 40).isActive = true
//        cLBox.trailingAnchor.constraint(equalTo: cPanel.trailingAnchor, constant: -40).isActive = true
//        cLBox.heightAnchor.constraint(equalToConstant: 80).isActive = true //default: 50
////        cLBox.topAnchor.constraint(equalTo: aText.bottomAnchor, constant: 20).isActive = true
////        cLBox.topAnchor.constraint(equalTo: lGrid.bottomAnchor, constant: 0).isActive = true
//        cLBox.topAnchor.constraint(equalTo: cTitleText.bottomAnchor, constant: 20).isActive = true
//        cLBox.layer.cornerRadius = 5
//        cLBox.layer.opacity = 0.2 //0.3
        
        let proceedView = UIView()
//        proceedView.backgroundColor = .black
        proceedView.backgroundColor = .yellow
        cPanel.addSubview(proceedView)
        proceedView.translatesAutoresizingMaskIntoConstraints = false
        proceedView.topAnchor.constraint(equalTo: cTitleText.bottomAnchor, constant: 30).isActive = true
//        proceedView.bottomAnchor.constraint(equalTo: exitView.topAnchor, constant: -10).isActive = true
        proceedView.heightAnchor.constraint(equalToConstant: 40).isActive = true //ori 45
        proceedView.leadingAnchor.constraint(equalTo: cPanel.leadingAnchor, constant: 40).isActive = true
        proceedView.trailingAnchor.constraint(equalTo: cPanel.trailingAnchor, constant: -40).isActive = true
//        proceedView.layer.opacity = 0.2 //0.3
        proceedView.layer.cornerRadius = 10
        proceedView.isUserInteractionEnabled = true
        proceedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onProceedViewClicked)))
        
        let proceedViewText = UILabel()
        proceedViewText.textAlignment = .center
        proceedViewText.textColor = .black
        proceedViewText.font = .boldSystemFont(ofSize: 14)
//        panel.addSubview(aSaveDraftText)
        cPanel.addSubview(proceedViewText)
        proceedViewText.translatesAutoresizingMaskIntoConstraints = false
        proceedViewText.centerXAnchor.constraint(equalTo: proceedView.centerXAnchor).isActive = true
        proceedViewText.centerYAnchor.constraint(equalTo: proceedView.centerYAnchor).isActive = true
        proceedViewText.text = "Confirm"
//        proceedViewText.layer.opacity = 0.5
        
        let exitView = UIView()
//        exitView.backgroundColor = .black
        exitView.backgroundColor = .ddmDarkOverlayBlack
        cPanel.addSubview(exitView)
        exitView.translatesAutoresizingMaskIntoConstraints = false
        exitView.topAnchor.constraint(equalTo: proceedView.bottomAnchor, constant: 10).isActive = true
//        exitView.bottomAnchor.constraint(equalTo: cPanel.bottomAnchor, constant: -50).isActive = true
        exitView.heightAnchor.constraint(equalToConstant: 40).isActive = true //ori 45
        exitView.leadingAnchor.constraint(equalTo: cPanel.leadingAnchor, constant: 40).isActive = true //15
        exitView.trailingAnchor.constraint(equalTo: cPanel.trailingAnchor, constant: -40).isActive = true
//        exitView.layer.opacity = 0.2 //0.3
        exitView.layer.cornerRadius = 10
        exitView.isUserInteractionEnabled = true
        exitView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onExitViewClicked)))
        
        let exitViewText = UILabel()
        exitViewText.textAlignment = .center
        exitViewText.textColor = .white
        exitViewText.font = .boldSystemFont(ofSize: 14)
//        panel.addSubview(aSaveDraftText)
        cPanel.addSubview(exitViewText)
        exitViewText.translatesAutoresizingMaskIntoConstraints = false
        exitViewText.centerXAnchor.constraint(equalTo: exitView.centerXAnchor).isActive = true
        exitViewText.centerYAnchor.constraint(equalTo: exitView.centerYAnchor).isActive = true
        exitViewText.text = "Cancel"
//        exitViewText.layer.opacity = 0.5
        
        //test > gesture recognizer for dragging user panel
        let panelPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onPanelPanGesture))
        panelView.addGestureRecognizer(panelPanGesture)
    }
    
    @objc func onPinClicked(gesture: UITapGestureRecognizer) {

        currentLSelectMode = LSELECT_MODE_SELECTED_PIN
        refreshModeUI()
        
        delegate?.didSelectedALocationSelectScrollable(pv: self)
    }
    
    @objc func onL1Clicked(gesture: UITapGestureRecognizer) {

        currentLSelectMode = LSELECT_MODE_SELECTED_PLACE
        refreshModeUI()
        
        delegate?.didSelectedALocationSelectScrollable(pv: self)
    }
    
    @objc func onExitViewClicked(gesture: UITapGestureRecognizer) {
        
        currentLSelectMode = LSELECT_MODE_EMPTY
        refreshModeUI()
        
        delegate?.didClickDenyLocationSelectScrollable(pv: self)
    }
    
    let aPanelTopMargin = 30.0
    let xGridHeight = 40.0
    let aTextBoxTopMargin = 10.0
    let aTextBoxHeight = 40.0
    let lGridTopMargin = 30.0
    let lGridHeight = 30.0
    let lBoxTopMargin = 10.0
    let lBoxHeight = 40.0
    let aPanelBottomMargin = 20.0
    let cPanelTopMargin = 20.0
    let cBackBtnHeight = 40.0
    let cTextTopMargin = 0.0
    let cTextHeight = 18.0
    let cProceedTopMargin = 30.0
    let cProceedHeight = 40.0
    let cExitTopMargin = 10.0
    let cExitHeight = 40.0
    let cPanelBottomMargin = 20.0
    func computeHeight() {
        if(currentLSelectMode == LSELECT_MODE_EMPTY) {
            let totalHeight = aPanelTopMargin + xGridHeight + aTextBoxTopMargin + aTextBoxHeight + lGridTopMargin + lGridHeight + lBoxTopMargin + lBoxHeight + aPanelBottomMargin + safeAreaInsets.bottom
            scrollablePanelHeight = totalHeight
        } else if(currentLSelectMode == LSELECT_MODE_SELECTED_PIN){
            let totalHeight = cPanelTopMargin + cBackBtnHeight + cTextTopMargin + cTextHeight + cProceedTopMargin + cProceedHeight + cExitTopMargin + cExitHeight + cPanelBottomMargin + safeAreaInsets.bottom
            scrollablePanelHeight = totalHeight
        } else if(currentLSelectMode == LSELECT_MODE_SELECTED_PLACE){
            let totalHeight = cPanelTopMargin + cBackBtnHeight + cTextTopMargin + cTextHeight + cProceedTopMargin + cProceedHeight + cExitTopMargin + cExitHeight + cPanelBottomMargin + safeAreaInsets.bottom
            scrollablePanelHeight = totalHeight
        }
    }
    
    func refreshModeUI() {
        resignResponder()
        
        if(currentLSelectMode == LSELECT_MODE_EMPTY) {
            aPanel.isHidden = false
            cPanel.isHidden = true
        } else if(currentLSelectMode == LSELECT_MODE_SELECTED_PLACE) {
            aPanel.isHidden = true
            cPanel.isHidden = false
        } else if(currentLSelectMode == LSELECT_MODE_SELECTED_PIN) {
            aPanel.isHidden = true
            cPanel.isHidden = false
        }
        
        computeHeight()
        panelTopCons?.constant = -scrollablePanelHeight
    }
    
    @objc func onProceedViewClicked(gesture: UITapGestureRecognizer) {
        
        delegate?.didClickProceedLocationSelectScrollable(location: "cc")
        
        close(isAnimated: false)
    }
    
    @objc func onOpenTextBoxClicked(gesture: UITapGestureRecognizer) {
        
        setFirstResponder(textField: bTextField)
        
        self.panelTopCons?.constant = -self.frame.height
        self.changePanelMode(panelMode: self.PANEL_MODE_FULL)
        
        let topInset = self.safeAreaInsets.top
        print("locationselect: \(topInset)")
//        aTextBoxTopCons?.constant = topInset + 10
//        aTextBoxTopCons?.constant = 60
        
//        aTextBox.isHidden = true
        aPanel.isHidden = true
        
        //test > place search
        refreshFetchData()
    }
    
    @objc func onCloseTextBoxClicked(gesture: UITapGestureRecognizer) {
        resignResponder()
        
//        aTextBoxTopCons?.constant = 20
        
//        aTextBox.isHidden = false
        aPanel.isHidden = false
        
        UIView.animate(withDuration: 0.2, animations: {
            self.panelTopCons?.constant = -self.scrollablePanelHeight
            self.layoutIfNeeded()
        }, completion: { _ in
        })
        
        self.changePanelMode(panelMode: self.PANEL_MODE_HALF) //test
        
        //test > erase all place search results
    }
    
    @objc func onEraseSearchTextClicked(gesture: UITapGestureRecognizer) {
        bTextField.text = ""
    }
    
    func setFirstResponder(textField: UITextField) {
        textField.becomeFirstResponder()
//        aTextBox.isHidden = true
        aPanel.isHidden = true
//        bTextBox.isHidden = false
        bPanel.isHidden = false
        
//        bbText.isHidden = false
    }
    
    func resignResponder() {
        self.endEditing(true)
//        aTextBox.isHidden = false
        aPanel.isHidden = false
//        bTextBox.isHidden = true
        bPanel.isHidden = true
//        bbText.isHidden = true
    }
    
    //test > for suggesting locations
//    var uDataList = [String]()
//    var aHLightViewArray = [UIView]()
    func configure(data: String) {
//        let scrollViewWidth = 200.0
        let scrollViewHeight = 40.0
        
        let scrollLeadingMargin = 15.0
        let scrollTrailingMargin = 15.0
        let resultGap = 10.0
        var totalSumSize = 0.0
        
        if(data == "a") {
            uDataList.append("Petronas Twin Tower") //"p"
            uDataList.append("London")
            uDataList.append("Tesla Gigafactory")

            for a in uDataList {
            
                let hd = SuggestedLocationResult()
                aScroll1.addSubview(hd)
                hd.translatesAutoresizingMaskIntoConstraints = false
//                hd.widthAnchor.constraint(equalToConstant: scrollViewWidth).isActive = true //180
                hd.heightAnchor.constraint(equalToConstant: scrollViewHeight).isActive = true //280
                hd.topAnchor.constraint(equalTo: aScroll1.topAnchor, constant: 0).isActive = true
                if(aHLightViewArray.isEmpty) {
                    let firstGap = scrollLeadingMargin + resultGap
                    totalSumSize += firstGap
                    totalSumSize += scrollTrailingMargin
                    
                    hd.leadingAnchor.constraint(equalTo: aScroll1.leadingAnchor, constant: firstGap).isActive = true
                } else {
                    totalSumSize += resultGap
                    
                    let lastArrayE = aHLightViewArray[aHLightViewArray.count - 1]
                    hd.leadingAnchor.constraint(equalTo: lastArrayE.trailingAnchor, constant: resultGap).isActive = true
                }
                aHLightViewArray.append(hd)
                hd.redrawUI()
                hd.configureUI(data: a) //"a"
                hd.aDelegate = self
                
                //test > compute width
                let tContentWidth = estimateWidth(text: a, textHeight: 40, fontSize: 14)
                let tContentTrailingMargin = 10.0
                let tContentLeadingMargin = 5.0
                let tIconSize = 20.0
                let tIconLeadingMargin = 5.0
                let tSum = tContentWidth + tContentTrailingMargin + tContentLeadingMargin + tIconSize + tIconLeadingMargin
                totalSumSize += tSum
                print("estimateWidth: \(tContentWidth)")
            }

            aScroll1.contentSize = CGSize(width: totalSumSize, height: scrollViewHeight) //800, 280
        }
    }
    
    private func estimateWidth(text: String, textHeight: CGFloat, fontSize: CGFloat) -> CGFloat {
        if(text == ""){
            return 0
        } else {
            let size = CGSize(width: 1000, height: textHeight) //1000 height is dummy
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]
            let estimatedFrame = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            
            return estimatedFrame.width
        }
    }
    
    func asyncConfigure(data: String) {
        let id = "u"
        DataFetchManager.shared.fetchUserData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("pdp api success \(id), \(l)")
                    
                    guard let self = self else {
                        return
                    }

                    self.cSpinner.stopAnimating()
                    self.configure(data: "a")
                    
                    if(l.isEmpty) {
                        self.configureCErrorUI(data: "na")
                    }
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    
                    guard let self = self else {
                        return
                    }
                    self.cSpinner.stopAnimating()
                    
                    //error handling e.g. refetch button
                    self.configureCErrorUI(data: "e")
                }
                break
            }
        }
    }
    
    func deconfigureCell() {
        aScroll1.setContentOffset(CGPoint.zero, animated: false)
        
        if(!aHLightViewArray.isEmpty) {
            for e in aHLightViewArray {
                e.removeFromSuperview()
            }
            aHLightViewArray.removeAll()
            uDataList.removeAll()
        }
    }
    
    func configureCErrorUI(data: String) {
        self.cErrorText.text = ""
        self.cErrorText.isHidden = true
        self.cErrorRefreshBtn.isHidden = true
        
        if(data == "e") {
            self.cErrorText.text = "Something went wrong. Retry."
            self.cErrorText.isHidden = false
            self.cErrorRefreshBtn.isHidden = false
        }
        else if(data == "na") {
            self.cErrorText.text = "Empty result."
            self.cErrorText.isHidden = false
        }
    }
    
    func clearCErrorUI() {
        self.cErrorText.text = ""
        self.cErrorText.isHidden = true
        self.cErrorRefreshBtn.isHidden = true
    }
    
    //test > error handling for refresh suggested locations
    @objc func onCErrorRefreshClicked(gesture: UITapGestureRecognizer) {
        deconfigureCell()
        clearCErrorUI()
        
        cSpinner.startAnimating()
        asyncConfigure(data: "")
    }
    
    func configureTab() {
        for a in tabDataList {
            let s1Tab = SuggestedLocationTab()
            aPanel.addSubview(s1Tab)
            s1Tab.translatesAutoresizingMaskIntoConstraints = false
            s1Tab.heightAnchor.constraint(equalToConstant: 30).isActive = true //280
            s1Tab.centerYAnchor.constraint(equalTo: lGrid.centerYAnchor, constant: 0).isActive = true
            if(aTabViewArray.isEmpty) {
                s1Tab.leadingAnchor.constraint(equalTo: pImage.trailingAnchor, constant: 10).isActive = true
            } else {
                let lastArrayE = aTabViewArray[aTabViewArray.count - 1]
                s1Tab.leadingAnchor.constraint(equalTo: lastArrayE.trailingAnchor, constant: 10).isActive = true
            }
//            s1Tab.leadingAnchor.constraint(equalTo: pImage.trailingAnchor, constant: 10).isActive = true
            s1Tab.redrawUI()
            if(a == "n") {
                s1Tab.configureUI(data: "Near Me") //"a"
            }
            else if (a == "c") {
                s1Tab.configureUI(data: "Created") //"a"
            }
            else if (a == "b") {
                s1Tab.configureUI(data: "Saves") //"a"
            }
            s1Tab.aDelegate = self
            aTabViewArray.append(s1Tab)
        }
        
        //init => select tab at 0 first
        if(!aTabViewArray.isEmpty) {
            aTabViewArray[0].selectTab()
        }
    }
    
    //test > initialization state
    var isInitialized = false
    func initialize() {

        //test > compute UI height beforehand
        currentLSelectMode = LSELECT_MODE_EMPTY
        computeHeight()
        
        UIView.animate(withDuration: 0.2, animations: {
            self.panelTopCons?.constant = -self.scrollablePanelHeight

            self.changePanelMode(panelMode: self.PANEL_MODE_HALF) //test

        }, completion: { _ in
            print("place panel init complete")

            self.delegate?.didFinishInitLocationSelectScrollable(pv: self)
        })
        
        if(!isInitialized) {
            setupViews()
            
            configureTab()
            
            //test > fetch suggested locations for prompt
            cSpinner.startAnimating()
            asyncConfigure(data: "")
        }
        
        isInitialized = true
    }
    
    func changePanelMode(panelMode : String) {
        print("change correctMapPadding: \(panelMode)")
        if(panelMode == PANEL_MODE_EMPTY) {
            currentMapPaddingBottom = 0
            delegate?.didChangeMapPaddingLocationSelectScrollable(y: 0)
        } else {
            currentMapPaddingBottom = halfModeMapPadding
            delegate?.didChangeMapPaddingLocationSelectScrollable(y: halfModeMapPadding)
        }
        currentPanelMode = panelMode
    }
    
    override func close(isAnimated: Bool) {
        print("close correctMapPadding: ")
        self.changePanelMode(panelMode: self.PANEL_MODE_EMPTY) //test

        if(isAnimated) {
            UIView.animate(withDuration: 0.2, animations: {
                self.panelTopCons?.constant = 0

//                self.change(scrollLevel: self.getScrollLevel())
                self.superview?.layoutIfNeeded()
            }, completion: { _ in
                self.delegate?.didClickCloseLocationSelectScrollablePanel()
                self.removeFromSuperview()
            })
        } else {
            self.delegate?.didClickCloseLocationSelectScrollablePanel()
            self.removeFromSuperview()
        }
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
                    
                    delegate?.didChangeMapPaddingLocationSelectScrollable(y: currentMapPaddingBottom - y)
                    
                    //test marker disappear trigger
                    delegate?.didStartMapChangeLocationSelectScrollable(pv: self)
                }
            }

        } else if(gesture.state == .ended){
            if(self.currentPanelMode == self.PANEL_MODE_HALF) {
                if(self.panelTopCons!.constant - self.currentPanelTopCons < 150) {
                    print("createselect <150 \(self.currentPanelTopCons), \(self.panelTopCons!.constant)")
                    UIView.animate(withDuration: 0.2, animations: {
//                        let gap = 300.0
                        let gap = self.scrollablePanelHeight
                        self.panelTopCons?.constant = -gap
                        
                        self.changePanelMode(panelMode: self.PANEL_MODE_HALF) //test
                        self.layoutIfNeeded()
                    }, completion: { _ in
                        self.delegate?.didFinishMapChangeLocationSelectScrollable(pv: self)
                    })

                } else {
                    print("createselect >150 \(self.currentPanelTopCons), \(self.panelTopCons!.constant)")
                    close(isAnimated: true)
                }
            }

        }
    }
    
    //test > fetch data => temp fake data => try refresh data first
    func asyncFetchFeed(id: String) {
        
        //test
        self.vDataList.removeAll() //test > refresh dataset
        self.vCV?.reloadData()
        
        dataFetchState = "start"
        aSpinner.startAnimating()
        
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
                    print("rr api success \(id), \(l), \(l.isEmpty)")
                    
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

extension LocationSelectScrollablePanelView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                   layout collectionViewLayout: UICollectionViewLayout,
                   sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("placepanel collection 2: \(indexPath)")
//        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 3 - lay.minimumInteritemSpacing
        
        return CGSize(width: collectionView.frame.width, height: 60)
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

extension LocationSelectScrollablePanelView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HSingleLocationViewCell.identifier, for: indexPath) as! HSingleLocationViewCell
        cell.aDelegate = self
        cell.configure(data: vDataList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

     }
}

extension ViewController: LocationSelectScrollablePanelDelegate{
    func didClickCloseLocationSelectScrollablePanel(){
        //test > reappear video when back from place panel
        backPage(isCurrentPageScrollable: true)
    }
    
    func didChangeMapPaddingLocationSelectScrollable(y: CGFloat) {
        changeMapPadding(padding: y)
        
        //test > try move redView of collision check according to map padding
        //-ve as y direction is inverse
        redViewTopCons?.constant = -y
    }
    
    //test
    func didFinishInitLocationSelectScrollable(pv: LocationSelectScrollablePanelView) {
        
        //test 2 > scan for relevant nearby places to be shown on map for selection
        //test marker with yellow arrow as selected
        
        //test 3 > show pin location yellow marker
//        locationPinner.isHidden = false
        
        //test 4 > pinner custom view
//        lPinner?.isHidden = false
//        lPinner?.hoverPin()
        
        //test 5 > use map target as point for pinner
        showPinLocation(pv: pv)
        
        //test 6 > show live location of user
        showLiveLLocationSelect(pv: pv)
    }
    
    func didSelectedALocationSelectScrollable(pv: LocationSelectScrollablePanelView) {
        
        lPinner?.isHidden = true
        
        if(pv.currentLSelectMode == pv.LSELECT_MODE_SELECTED_PLACE) {
            //test > get locationpinner points on screen
            showPlaceLSelectedPoint(pv: pv)
        } else if(pv.currentLSelectMode == pv.LSELECT_MODE_SELECTED_PIN) {
            //test > get locationpinner points on screen
            showPinLSelectedPoint(pv: pv)
            
            //test > disable map from moving
//            mapView?.settings.scrollGestures = false
        }

    }
    func didClickProceedLocationSelectScrollable(location: String) {
        
        guard let target = mapView?.camera.target else {
            return
        }
        
        if(!pageList.isEmpty) {
            
            if(pageList.count >= 2) {
                let a = pageList[pageList.count - 2] as? CreatorPanelView
                a?.setPinString(i: location)
                a?.setPinCoordinates(target: target)

                a?.showLocationSelected()
            }

        }
    }
    func didClickDenyLocationSelectScrollable(pv: LocationSelectScrollablePanelView) {
        
        //test
//        mapRemoveMarkers()
        mapRemoveLSelectedPoints()
        
        //re-enable pinner
        if(pv.currentLSelectMode == pv.LSELECT_MODE_EMPTY) {
            lPinner?.isHidden = false
            lPinner?.hoverPin()
            
            //test > re-enable map from moving
//            mapView?.settings.scrollGestures = true
        }
    }
    
    func didStartMapChangeLocationSelectScrollable(pv: LocationSelectScrollablePanelView) {
        
        if(pv.currentLSelectMode == pv.LSELECT_MODE_EMPTY) {
            lPinner?.isHidden = true
        }
        
        mapDisappearMarkers()
    }
    func didFinishMapChangeLocationSelectScrollable(pv: LocationSelectScrollablePanelView) {
        
        if(pv.currentLSelectMode == pv.LSELECT_MODE_EMPTY) {
            lPinner?.isHidden = false
        }
        
        mapReappearMarkers()
    }
}

extension LocationSelectScrollablePanelView: HSingleLocationDelegate{
    func didClickSinglePlaceLocation() {
        //test
        currentLSelectMode = LSELECT_MODE_SELECTED_PLACE
        refreshModeUI()
        
        delegate?.didSelectedALocationSelectScrollable(pv: self)
    }
}

extension LocationSelectScrollablePanelView: SuggestedLocationResultDelegate{
    func didSuggestedLocationResultClick() {
        currentLSelectMode = LSELECT_MODE_SELECTED_PLACE
        refreshModeUI()
        
        delegate?.didSelectedALocationSelectScrollable(pv: self)
    }
}
extension LocationSelectScrollablePanelView: SuggestedLocationTabDelegate{
    func didSuggestedLocationTabClick(s: SuggestedLocationTab) {
//        reactToTabChange(tab: "1")
        for t in aTabViewArray {
            t.unselectTab()
        }
        s.selectTab()
        
        deconfigureCell()
        clearCErrorUI()
        
        cSpinner.startAnimating()
        asyncConfigure(data: "")
    }
}
