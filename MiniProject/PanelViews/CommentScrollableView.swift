//
//  CommentScrollableView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

protocol CommentScrollableDelegate : AnyObject {
    func didCClickUser(id: String)
    func didCClickPlace(id: String)
    func didCClickSound(id: String, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String)
    func didCClickClosePanel()
    func didCFinishClosePanel()
    func didCClickComment(id: String, dataType: String, pointX: CGFloat, pointY: CGFloat)
    func didCClickPost(id: String, dataType: String, pointX: CGFloat, pointY: CGFloat)
    func didCClickShare(id: String, dataType: String)
    func didCClickClickPhoto(id: String, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String)
    func didCClickClickVideo(id: String, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String)
}
class CommentScrollableView: PanelView, UIGestureRecognizerDelegate{
    
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    var panelTopCons: NSLayoutConstraint?
    var currentPanelTopCons : CGFloat = 0.0
    weak var delegate : CommentScrollableDelegate?
    var scrollablePanelHeight : CGFloat = 600.0 //500
    
    var aView = UIView()
    var vDataList = [CommentData]()
    var vCV : UICollectionView?
    
    var isScrollViewAtTop = true
    
    let aSpinner = SpinLoader()
    let bSpinner = SpinLoader()
    let footerView = UIView()
    let aaText = UILabel()
    var dataFetchState = ""
    var dataPaginateStatus = "" //test
    var pageNumber = 0
    let errorText = UILabel()
    let errorRefreshBtn = UIView()
    
    //test
    var hideCellIndex = -1
    
    //test
    let panelView = UIView()
    
    //test > comment textview
    var bView = UIView()
    var textPanelBottomCons: NSLayoutConstraint?
    var aTextBoxHeightCons: NSLayoutConstraint?
//    var aTextTrailingCons: NSLayoutConstraint?
//    var aTextBottomCons: NSLayoutConstraint?
    let aTextBox = UITextView()
    var aaViewTrailingCons: NSLayoutConstraint?
    let sendAaView = UIView()
    var sendAaViewTrailingCons: NSLayoutConstraint?
    let textPanel = UIView()
    var currentFirstResponder : UITextView?
    var isKeyboardUp = false
    let bottomBox = UIView()
    let sendBox = UIView()
    let aaView = UIView()
    let xGrid = UIView()
    let bbText = UILabel()
    let addCommentContainer = UIView()
    let sendCommentContainer = UIView()
    let sendASpinner = SpinLoader()
    let sendBText = UILabel()
    let sendBBox = UIView()
    
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
        self.addSubview(aView)
        aView.translatesAutoresizingMaskIntoConstraints = false
        aView.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        aView.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        aView.isUserInteractionEnabled = true
//        aView.layer.opacity = 0.4 //default : 0
        aView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCloseCommentClicked)))
//        aView.backgroundColor = .black //ddmBlackOverlayColor
        aView.backgroundColor = .clear
        
//        let panelView = UIView()
        panelView.backgroundColor = .ddmBlackOverlayColor
        self.addSubview(panelView)
        panelView.translatesAutoresizingMaskIntoConstraints = false
        panelView.layer.masksToBounds = true
        panelView.layer.cornerRadius = 10 //10
        panelView.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
//        panelView.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        panelView.heightAnchor.constraint(equalToConstant: scrollablePanelHeight).isActive = true
        panelTopCons = panelView.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -scrollablePanelHeight) //default: 0
        panelTopCons?.isActive = true
      
        let commentTitleText = UILabel()
        commentTitleText.textAlignment = .center
        commentTitleText.textColor = .white
//        commentTitleText.font = .systemFont(ofSize: 14) //default 14
        commentTitleText.font = .boldSystemFont(ofSize: 13) //default 14
        commentTitleText.text = "Comments" //2037 Comments
        panelView.addSubview(commentTitleText)
        commentTitleText.translatesAutoresizingMaskIntoConstraints = false
//        commentTitleText.leadingAnchor.constraint(equalTo: panelView.leadingAnchor, constant: 20).isActive = true
//        commentTitleText.trailingAnchor.constraint(equalTo: panelView.trailingAnchor, constant: 0).isActive = true
        commentTitleText.centerXAnchor.constraint(equalTo: panelView.centerXAnchor, constant: 0).isActive = true
        commentTitleText.topAnchor.constraint(equalTo: panelView.topAnchor, constant: 20).isActive = true //20
        commentTitleText.isUserInteractionEnabled = true
        commentTitleText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCommentTitleClicked)))
        
        let commentTitleBtn = UIImageView(image: UIImage(named:"icon_round_arrow_down")?.withRenderingMode(.alwaysTemplate))
//            aArrowBtn.image = UIImage(named:"icon_round_arrow_down")?.withRenderingMode(.alwaysTemplate)
        commentTitleBtn.tintColor = .white
        panelView.addSubview(commentTitleBtn)
        commentTitleBtn.translatesAutoresizingMaskIntoConstraints = false
        commentTitleBtn.leadingAnchor.constraint(equalTo: commentTitleText.trailingAnchor).isActive = true
        commentTitleBtn.centerYAnchor.constraint(equalTo: commentTitleText.centerYAnchor).isActive = true
        commentTitleBtn.heightAnchor.constraint(equalToConstant: 26).isActive = true //ori 26
        commentTitleBtn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        commentTitleBtn.isHidden = true
        
        let vLayout = UICollectionViewFlowLayout()
        vLayout.scrollDirection = .vertical
        vLayout.minimumLineSpacing = 10 //10 => spacing between rows
        vLayout.minimumInteritemSpacing = 0 //default: 4 => spacing between columns
        vCV = UICollectionView(frame: .zero, collectionViewLayout: vLayout)
        guard let vCV = vCV else {
            return
        }
        vCV.register(HCommentListViewCell.self, forCellWithReuseIdentifier: HCommentListViewCell.identifier)
        vCV.dataSource = self
        vCV.delegate = self
//        vCV.showsVerticalScrollIndicator = false
//        vCV.backgroundColor = .blue
        vCV.backgroundColor = .clear
        panelView.addSubview(vCV)
        vCV.translatesAutoresizingMaskIntoConstraints = false
//        vCV.topAnchor.constraint(equalTo: eGrid.bottomAnchor, constant: 20).isActive = true
        vCV.topAnchor.constraint(equalTo: commentTitleText.bottomAnchor, constant: 20).isActive = true //20
//        vCV.topAnchor.constraint(equalTo: l1Tab.bottomAnchor, constant: 20).isActive = true
        vCV.leadingAnchor.constraint(equalTo: panelView.leadingAnchor).isActive = true
        vCV.bottomAnchor.constraint(equalTo: panelView.bottomAnchor, constant: 0).isActive = true
        vCV.trailingAnchor.constraint(equalTo: panelView.trailingAnchor).isActive = true
        vCV.contentInsetAdjustmentBehavior = .never
        
        //test > top spinner
        vCV.addSubview(aSpinner)
        aSpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        aSpinner.translatesAutoresizingMaskIntoConstraints = false
        aSpinner.topAnchor.constraint(equalTo: vCV.topAnchor, constant: CGFloat(-35)).isActive = true
        aSpinner.centerXAnchor.constraint(equalTo: vCV.centerXAnchor).isActive = true
        aSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        aSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        //test bottom comment box => fake edittext
        let coverBottomCon = UIView()
        coverBottomCon.backgroundColor = .ddmBlackOverlayColor
        self.addSubview(coverBottomCon)
        coverBottomCon.translatesAutoresizingMaskIntoConstraints = false
        coverBottomCon.leadingAnchor.constraint(equalTo: panelView.leadingAnchor, constant: 0).isActive = true
        coverBottomCon.trailingAnchor.constraint(equalTo: panelView.trailingAnchor, constant: 0).isActive = true
        coverBottomCon.bottomAnchor.constraint(equalTo: panelView.bottomAnchor, constant: 0).isActive = true
        coverBottomCon.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
//        bottomBox.backgroundColor = .black
        bottomBox.backgroundColor = .ddmBlackOverlayColor
        self.addSubview(bottomBox)
        bottomBox.clipsToBounds = true
        bottomBox.translatesAutoresizingMaskIntoConstraints = false
        bottomBox.leadingAnchor.constraint(equalTo: panelView.leadingAnchor, constant: 0).isActive = true
        bottomBox.trailingAnchor.constraint(equalTo: panelView.trailingAnchor, constant: 0).isActive = true
//        bottomBox.heightAnchor.constraint(equalToConstant: 94).isActive = true //default: 50
//        bottomBox.bottomAnchor.constraint(equalTo: panelView.bottomAnchor, constant: 0).isActive = true
        bottomBox.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        bottomBox.heightAnchor.constraint(equalToConstant: 60).isActive = true //default: 50
        bottomBox.isUserInteractionEnabled = true
        let dPanelPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onTextViewPanGesture))
        bottomBox.addGestureRecognizer(dPanelPanGesture)
//        bottomBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onOpenTextBoxClicked)))
        
//        let addCommentContainer = UIView()
        bottomBox.addSubview(addCommentContainer)
        addCommentContainer.translatesAutoresizingMaskIntoConstraints = false
        addCommentContainer.isHidden = false
        addCommentContainer.backgroundColor = .ddmBlackDark
        addCommentContainer.layer.cornerRadius = 10 //10
        addCommentContainer.leadingAnchor.constraint(equalTo: bottomBox.leadingAnchor, constant: 20).isActive = true //0
//        addCommentContainer.leadingAnchor.constraint(equalTo: zGrid.trailingAnchor, constant: 10).isActive = true //0
        addCommentContainer.trailingAnchor.constraint(equalTo: bottomBox.trailingAnchor, constant: -20).isActive = true //-15
        addCommentContainer.topAnchor.constraint(equalTo: bottomBox.topAnchor, constant: 10).isActive = true //0
        addCommentContainer.bottomAnchor.constraint(equalTo: bottomBox.bottomAnchor, constant: -10).isActive = true //0
        addCommentContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onOpenTextBoxClicked)))
        
        let bText = UILabel()
        bText.textAlignment = .left
//        bText.textColor = .white
        bText.textColor = .ddmDarkGrayColor
        bText.font = .boldSystemFont(ofSize: 13)
        addCommentContainer.addSubview(bText)
//        bottomBox.addSubview(bText)
        bText.clipsToBounds = true
        bText.translatesAutoresizingMaskIntoConstraints = false
        bText.leadingAnchor.constraint(equalTo: addCommentContainer.leadingAnchor, constant: 15).isActive = true
        bText.trailingAnchor.constraint(equalTo: addCommentContainer.trailingAnchor, constant: -60).isActive = true
//        bText.topAnchor.constraint(equalTo: addCommentContainer.topAnchor, constant: 15).isActive = true
        bText.centerYAnchor.constraint(equalTo: addCommentContainer.centerYAnchor, constant: 0).isActive = true
//        bText.leadingAnchor.constraint(equalTo: bottomBox.leadingAnchor, constant: 15).isActive = true
//        bText.trailingAnchor.constraint(equalTo: bottomBox.trailingAnchor, constant: -60).isActive = true
//        bText.topAnchor.constraint(equalTo: bottomBox.topAnchor, constant: 15).isActive = true
        bText.text = "Add comment..."
//        bText.layer.opacity = 0.5
        
        bottomBox.addSubview(sendCommentContainer)
        sendCommentContainer.translatesAutoresizingMaskIntoConstraints = false
        sendCommentContainer.leadingAnchor.constraint(equalTo: bottomBox.leadingAnchor, constant: 0).isActive = true
        sendCommentContainer.trailingAnchor.constraint(equalTo: bottomBox.trailingAnchor, constant: 0).isActive = true
        sendCommentContainer.topAnchor.constraint(equalTo: bottomBox.topAnchor, constant: 0).isActive = true //default: 50
        sendCommentContainer.bottomAnchor.constraint(equalTo: bottomBox.bottomAnchor, constant: 0).isActive = true
        sendCommentContainer.isHidden = true
        
//        let sendAaView = UIView()
        sendAaView.backgroundColor = .ddmBlackDark
        sendCommentContainer.addSubview(sendAaView)
        sendAaView.translatesAutoresizingMaskIntoConstraints = false
        sendAaView.topAnchor.constraint(equalTo: sendCommentContainer.topAnchor, constant: 10).isActive = true
        sendAaView.leadingAnchor.constraint(equalTo: sendCommentContainer.leadingAnchor, constant: 20).isActive = true //-10
//        sendAaView.trailingAnchor.constraint(equalTo: sendCommentContainer.trailingAnchor, constant: -50).isActive = true
        sendAaViewTrailingCons = sendAaView.trailingAnchor.constraint(equalTo: sendCommentContainer.trailingAnchor, constant: -20)
        sendAaViewTrailingCons?.isActive = true
        sendAaView.heightAnchor.constraint(equalToConstant: 40).isActive = true //36
        sendAaView.layer.cornerRadius = 10
        sendAaView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onOpenTextBoxClicked)))
        
        sendASpinner.setConfiguration(size: 20, lineWidth: 2, gap: 6, color: .white)
        sendCommentContainer.addSubview(sendASpinner)
        sendASpinner.translatesAutoresizingMaskIntoConstraints = false
        sendASpinner.trailingAnchor.constraint(equalTo: sendCommentContainer.trailingAnchor, constant: -20).isActive = true
        sendASpinner.centerYAnchor.constraint(equalTo: sendAaView.centerYAnchor).isActive = true
        sendASpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        sendASpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
//        let sendBText = UILabel()
        sendBText.textAlignment = .left
        sendBText.textColor = .white
//        bText.textColor = .ddmDarkGrayColor
        sendBText.font = .systemFont(ofSize: 13)
        sendAaView.addSubview(sendBText)
//        bottomBox.addSubview(bText)
        sendBText.clipsToBounds = true
        sendBText.translatesAutoresizingMaskIntoConstraints = false
        sendBText.leadingAnchor.constraint(equalTo: sendAaView.leadingAnchor, constant: 15).isActive = true
        sendBText.trailingAnchor.constraint(equalTo: sendAaView.trailingAnchor, constant: -60).isActive = true
//        sendBText.topAnchor.constraint(equalTo: sendAaView.topAnchor, constant: 15).isActive = true
        sendBText.centerYAnchor.constraint(equalTo: sendAaView.centerYAnchor, constant: 0).isActive = true
        sendBText.text = ""

        //test > real textview edittext for comment
        self.addSubview(bView)
        bView.translatesAutoresizingMaskIntoConstraints = false
        bView.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        bView.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        bView.isUserInteractionEnabled = true
        bView.isHidden = true
//        aView.backgroundColor = .clear
//        aView.backgroundColor = .ddmBlackOverlayColor
        bView.backgroundColor = .black
        bView.layer.opacity = 0.3 //0.2
        let cPanelPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onTextViewPanGesture))
        bView.addGestureRecognizer(cPanelPanGesture)
        bView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCloseTextBoxClicked)))

//        textPanel.backgroundColor = .black
        textPanel.backgroundColor = .ddmBlackOverlayColor
        self.addSubview(textPanel)
        textPanel.translatesAutoresizingMaskIntoConstraints = false
        textPanel.leadingAnchor.constraint(equalTo: panelView.leadingAnchor).isActive = true
        textPanel.trailingAnchor.constraint(equalTo: panelView.trailingAnchor).isActive = true
        textPanelBottomCons = textPanel.bottomAnchor.constraint(equalTo: panelView.bottomAnchor, constant: 0)
        textPanelBottomCons?.isActive = true
//        textPanelHeightCons = textPanel.heightAnchor.constraint(equalToConstant: 60)
//        textPanelHeightCons?.isActive = true
        textPanel.isHidden = true
        textPanel.isUserInteractionEnabled = true

//        let sendBox = UIView()
//        sendBox.backgroundColor = .clear //yellow
        sendBox.backgroundColor = .yellow //yellow
        textPanel.addSubview(sendBox)
        sendBox.translatesAutoresizingMaskIntoConstraints = false
        sendBox.widthAnchor.constraint(equalToConstant: 30).isActive = true
        sendBox.heightAnchor.constraint(equalToConstant: 30).isActive = true //30
        sendBox.trailingAnchor.constraint(equalTo: textPanel.trailingAnchor, constant: -20).isActive = true //-15
//        sendBox.topAnchor.constraint(equalTo: textPanel.topAnchor, constant: 10).isActive = true
        sendBox.bottomAnchor.constraint(equalTo: textPanel.bottomAnchor, constant: -15).isActive = true //-10
        sendBox.layer.cornerRadius = 15
        sendBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSendBtnClicked)))

        let aNextMiniBtn = UIImageView(image: UIImage(named:"icon_round_arrow_right_next")?.withRenderingMode(.alwaysTemplate))
        aNextMiniBtn.tintColor = .black
        sendBox.addSubview(aNextMiniBtn)
        aNextMiniBtn.translatesAutoresizingMaskIntoConstraints = false
        aNextMiniBtn.centerXAnchor.constraint(equalTo: sendBox.centerXAnchor).isActive = true
        aNextMiniBtn.centerYAnchor.constraint(equalTo: sendBox.centerYAnchor).isActive = true
        aNextMiniBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        aNextMiniBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true

        let zZGrid = UIView()
        textPanel.addSubview(zZGrid)
        zZGrid.backgroundColor = .ddmBlackDark
        zZGrid.translatesAutoresizingMaskIntoConstraints = false
        zZGrid.heightAnchor.constraint(equalToConstant: 30).isActive = true //30
        zZGrid.widthAnchor.constraint(equalToConstant: 30).isActive = true
        zZGrid.leadingAnchor.constraint(equalTo: textPanel.leadingAnchor, constant: 20).isActive = true
        zZGrid.bottomAnchor.constraint(equalTo: textPanel.bottomAnchor, constant: -15).isActive = true //-15
        zZGrid.layer.cornerRadius = 15 //15

        let zZGridIcon = UIImageView(image: UIImage(named:"icon_round_add")?.withRenderingMode(.alwaysTemplate))
//        zGridIcon.tintColor = .white
        zZGridIcon.tintColor = .ddmDarkGrayColor
        zZGrid.addSubview(zZGridIcon)
        zZGridIcon.translatesAutoresizingMaskIntoConstraints = false
//        zGridIcon.centerXAnchor.constraint(equalTo: pMini.centerXAnchor, constant: 0).isActive = true
//        zGridIcon.bottomAnchor.constraint(equalTo: divider.topAnchor, constant: 0).isActive = true
        zZGridIcon.centerXAnchor.constraint(equalTo: zZGrid.centerXAnchor, constant: 0).isActive = true
        zZGridIcon.centerYAnchor.constraint(equalTo: zZGrid.centerYAnchor, constant: 0).isActive = true
        zZGridIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true //20
        zZGridIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        //**test > try a container for textview
//        aaView.backgroundColor = .ddmDarkColor
        aaView.backgroundColor = .ddmBlackDark
        textPanel.addSubview(aaView)
        aaView.translatesAutoresizingMaskIntoConstraints = false
        aaView.topAnchor.constraint(equalTo: textPanel.topAnchor, constant: 10).isActive = true
        aaView.bottomAnchor.constraint(equalTo: textPanel.bottomAnchor, constant: -10).isActive = true //-10
//        aaView.leadingAnchor.constraint(equalTo: textPanel.leadingAnchor, constant: 15).isActive = true
        aaView.leadingAnchor.constraint(equalTo: zZGrid.trailingAnchor, constant: 10).isActive = true
        aaViewTrailingCons = aaView.trailingAnchor.constraint(equalTo: textPanel.trailingAnchor, constant: -20)
        aaViewTrailingCons?.isActive = true
        aaView.layer.cornerRadius = 10

        aTextBox.textAlignment = .left
        aTextBox.textColor = .white
        aTextBox.backgroundColor = .clear
        aTextBox.font = .systemFont(ofSize: 13)
        textPanel.addSubview(aTextBox)
        aTextBox.translatesAutoresizingMaskIntoConstraints = false
        aTextBox.bottomAnchor.constraint(equalTo: aaView.bottomAnchor, constant: 0).isActive = true
        aTextBox.trailingAnchor.constraint(equalTo: aaView.trailingAnchor, constant: -10).isActive = true
        aTextBox.leadingAnchor.constraint(equalTo: aaView.leadingAnchor, constant: 10).isActive = true
        aTextBox.topAnchor.constraint(equalTo: aaView.topAnchor, constant: 4).isActive = true
        aTextBoxHeightCons = aTextBox.heightAnchor.constraint(equalToConstant: 36)
        aTextBoxHeightCons?.isActive = true
        aTextBox.text = ""
        aTextBox.delegate = self
        aTextBox.tintColor = .yellow

//        let bbText = UILabel()
        bbText.textAlignment = .left
//        bbText.textColor = .white
        bbText.textColor = .ddmDarkGrayColor
        bbText.font = .boldSystemFont(ofSize: 13)
        textPanel.addSubview(bbText)
        bbText.clipsToBounds = true
        bbText.translatesAutoresizingMaskIntoConstraints = false
        bbText.leadingAnchor.constraint(equalTo: aTextBox.leadingAnchor, constant: 10).isActive = true
//        bbText.trailingAnchor.constraint(equalTo: xGrid.leadingAnchor, constant: -10).isActive = true
        bbText.topAnchor.constraint(equalTo: aTextBox.topAnchor, constant: 8).isActive = true
        bbText.text = "Say something nice..."
//        bbText.layer.opacity = 0.5
        //**
        
        //test > add footer ***
        vCV.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer")
        //***
        
        //test > vcv gesture simultaneous
        let panelPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onVCVPanGesture))
        panelPanGesture.delegate = self //for simultaneous pan recognizer for uicollectionview
        vCV.addGestureRecognizer(panelPanGesture)
        
        let aPanelPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onCommentPanelPanGesture))
        panelView.addGestureRecognizer(aPanelPanGesture)
        
        //test > to make comment bg non-movable
        let bPanelPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onCommentBackgroundPanGesture))
        aView.addGestureRecognizer(bPanelPanGesture)
    }
    
    //*test > textbox activation
    override func keyboardUp(margin: CGFloat) {
        guard let firstResponder = self.currentFirstResponder else {
            return
        }
        if(firstResponder == aTextBox) {
            print("currentfirstresponder true : \(firstResponder)")

            textPanel.isHidden = false
            bView.isHidden = false

            if(!isKeyboardUp) {
                UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut],
                    animations: {
                    self.textPanel.transform = CGAffineTransform(translationX: 0, y: -margin)
                }, completion: { finished in
                })
            } else {
                self.textPanel.transform = CGAffineTransform(translationX: 0, y: -margin)
            }

            isKeyboardUp = true
        }
    }
    @objc func onOpenTextBoxClicked(gesture: UITapGestureRecognizer) {
//        setFirstResponder(textView: aTextBox)
        
        if(!isStatusUploading) {
            setFirstResponder(textView: aTextBox)
        }
    }

    @objc func onCloseTextBoxClicked(gesture: UITapGestureRecognizer) {
        //test > check if textbox is empty
        if(aTextBox.text != "") {
            sendBText.text = aTextBox.text
            addCommentContainer.isHidden = true
            sendCommentContainer.isHidden = false
            sendBBox.isHidden = false
        } else {
            sendBText.text = ""
            addCommentContainer.isHidden = false
            sendCommentContainer.isHidden = true
            sendBBox.isHidden = true
            
            clearTextbox()
        }
        
        resignResponder()

        self.textPanel.transform = CGAffineTransform(translationX: 0, y: 0)
    }
    @objc func onClearTextBoxClicked(gesture: UITapGestureRecognizer) {
        
        sendBBox.isHidden = true
        addCommentContainer.isHidden = false
        sendCommentContainer.isHidden = true
        
        clearTextbox()
    }
    
    @objc func onSendBtnClicked(gesture: UITapGestureRecognizer) {
        sendBText.text = aTextBox.text
        
        resignResponder()
        asyncSendNewData()

        self.textPanel.transform = CGAffineTransform(translationX: 0, y: 0)
    }
    
    func setFirstResponder(textView: UITextView) {
        currentFirstResponder = textView
        textView.becomeFirstResponder()
    }
    
    func resignResponder() {
        self.endEditing(true)
        currentFirstResponder = nil

        isKeyboardUp = false
        textPanel.isHidden = true
        bView.isHidden = true
    }
    
    var isStatusUploading = false
    func asyncSendNewData() {
        addCommentContainer.isHidden = true
        sendCommentContainer.isHidden = false
        
        sendASpinner.startAnimating()
        sendASpinner.startAnimating()
        sendAaViewTrailingCons?.isActive = false
        sendAaViewTrailingCons = sendAaView.trailingAnchor.constraint(equalTo: sendASpinner.leadingAnchor, constant: -10)
        sendAaViewTrailingCons?.isActive = true
        
        sendBBox.isHidden = true
        
        isStatusUploading = true
        
        let id = "c_"
        DataUploadManager.shared.sendCommentData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                DispatchQueue.main.async {
                    guard let self = self else {
                        return
                    }
                    
                    self.addCommentContainer.isHidden = false
                    self.sendCommentContainer.isHidden = true
                    
                    self.sendASpinner.stopAnimating()
                    
                    self.scrollToTop(isAnimated: false)
                    self.addData()
                    self.clearTextbox()
                    
                    self.isStatusUploading = false
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    guard let self = self else {
                        return
                    }
                    
                    self.sendASpinner.stopAnimating()
                    self.sendAaViewTrailingCons?.isActive = false
                    self.sendAaViewTrailingCons = self.sendAaView.trailingAnchor.constraint(equalTo: self.sendCommentContainer.trailingAnchor, constant: -20)
                    self.sendAaViewTrailingCons?.isActive = true
                    
                    self.sendBBox.isHidden = false
                    self.openErrorUploadMsg()
                    
                    self.isStatusUploading = false
                }
                break
            }
        }
    }
    
    func clearTextbox() {
        aTextBox.text = ""
        sendBText.text = ""
        
        aaViewTrailingCons?.isActive = false
        aaViewTrailingCons = aaView.trailingAnchor.constraint(equalTo: textPanel.trailingAnchor, constant: -20)
        aaViewTrailingCons?.isActive = true
        
        sendAaViewTrailingCons?.isActive = false
        sendAaViewTrailingCons = sendAaView.trailingAnchor.constraint(equalTo: sendCommentContainer.trailingAnchor, constant: -20)
        sendAaViewTrailingCons?.isActive = true

        let minHeight = 36.0
        aTextBoxHeightCons?.constant = minHeight
        
        bbText.isHidden = false
    }
    //test > view pan gesture to prevent video panel move by panning textview
    @objc func onTextViewPanGesture(gesture: UIPanGestureRecognizer) {
        print("onPan start A: ")
    }
    //*
    
    @objc func onCommentTitleClicked(gesture: UIPanGestureRecognizer) {
        scrollToTop(isAnimated: true)
    }
    
    func scrollToTop(isAnimated: Bool) {
        vCV?.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: isAnimated)
    }
    
    func openErrorUploadMsg() {
        let errorPanel = ErrorUploadCommentMsgView(frame: CGRect(x: 0 , y: 0, width: self.frame.width, height: self.frame.height))
        self.addSubview(errorPanel)
        errorPanel.translatesAutoresizingMaskIntoConstraints = false
        errorPanel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        errorPanel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        errorPanel.delegate = self
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer is UIPanGestureRecognizer) {
            return true
        } else {
            return false
        }
    }
    
    @objc func onVCVPanGesture(gesture: UIPanGestureRecognizer) {
        if(gesture.state == .began) {
            print("onPan began top constraint: ")
            
            self.currentPanelTopCons = self.panelTopCons!.constant
        } else if(gesture.state == .changed) {
            let translation = gesture.translation(in: self)
            let x = translation.x
            var y = translation.y

            let velocity = gesture.velocity(in: self)
            
            print("onPan changed: \(x), \(y)")
            
            //y > 0 means downwards
            if(y > 0) {
                if(isScrollViewAtTop) {
                    self.panelTopCons?.constant = self.currentPanelTopCons + y
                }
            }
            else {
                //test
                isScrollViewAtTop = false
            }

        } else if(gesture.state == .ended){
            print("onPan end: \(self.currentPanelTopCons - self.panelTopCons!.constant)")
            if(self.currentPanelTopCons - self.panelTopCons!.constant < -150) {
                UIView.animate(withDuration: 0.2, animations: {
                    self.panelTopCons?.constant = 0
                    self.layoutIfNeeded()
                    
                    self.delegate?.didCClickClosePanel()
                }, completion: { _ in
                    //test > stop video before closing panel
                    print("vcv onPan destroy cell: ")
                    self.destroyCell()
//                    self.pausePlayingMedia()
                    
                    self.removeFromSuperview()
                    
                    //test > trigger finish close panel
                    self.delegate?.didCFinishClosePanel()
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.panelTopCons?.constant = -self.scrollablePanelHeight
                    self.layoutIfNeeded()
                }, completion: { _ in
                })
            }
        }
    }
    
    @objc func onCloseCommentClicked(gesture: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.2, animations: {
            self.panelTopCons?.constant = 0
            self.layoutIfNeeded()
            
            self.delegate?.didCClickClosePanel()
        }, completion: { _ in
            //test > stop video before closing panel
            self.destroyCell()
//            self.pausePlayingMedia()
            
            self.removeFromSuperview()
            
            //test > trigger finish close panel
            self.delegate?.didCFinishClosePanel()
        })
    }

    @objc func onCommentPanelPanGesture(gesture: UIPanGestureRecognizer) {
        if(gesture.state == .began) {
            self.currentPanelTopCons = self.panelTopCons!.constant
        } else if(gesture.state == .changed) {
            let translation = gesture.translation(in: self)
            let x = translation.x
            let y = translation.y
            if(y > 0) {
                self.panelTopCons?.constant = self.currentPanelTopCons + y
            }
        } else if(gesture.state == .ended){
            print("commentpanel: \(self.currentPanelTopCons - self.panelTopCons!.constant)")
            if(self.currentPanelTopCons - self.panelTopCons!.constant < -150) {
                UIView.animate(withDuration: 0.2, animations: {
                    self.panelTopCons?.constant = 0
                    self.layoutIfNeeded()
                    
                    self.delegate?.didCClickClosePanel()
                }, completion: { _ in
                    //test > stop video before closing panel
                    self.destroyCell()
//                    self.pausePlayingMedia()
                    
                    self.removeFromSuperview()
                    
                    //test > trigger finish close panel
                    self.delegate?.didCFinishClosePanel()
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.panelTopCons?.constant = -self.scrollablePanelHeight
                    self.layoutIfNeeded()
                }, completion: { _ in
                })
            }
        }
    }
    
    //test > to make comment bg non-movable
    @objc func onCommentBackgroundPanGesture(gesture: UIPanGestureRecognizer) {
        
    }
    
    //test > customize background color and opacity
    func setBackgroundDark() {
        aView.layer.opacity = 0.4 //default : 0
        aView.backgroundColor = .black //ddmBlackOverlayColor
    }
    
    //test > initialization state
    var isInitialized = false
    func initialize() {
        
        if(!isInitialized) {
//            self.asyncFetchFeed(id: "post_feed")
            self.asyncFetchFeed(id: "comment_feed")
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
    
    //*test > remove one comment
    var selectedItemIdx = -1
    func removeData(idxToRemove: Int) {
        if(!vDataList.isEmpty) {
            if(idxToRemove > -1 && idxToRemove < vDataList.count) {
                var indexPaths = [IndexPath]()
                let idx = IndexPath(item: idxToRemove, section: 0)
                indexPaths.append(idx)
                
                vDataList.remove(at: idxToRemove)
                self.vCV?.deleteItems(at: indexPaths)
                
                unselectItemData()
                
                //test
                if(vDataList.isEmpty) {
                    self.configureFooterUI(data: "na")
                    self.aaText.text = "No comments yet."
                }
            }
        }
    }

    func unselectItemData() {
        selectedItemIdx = -1
    }
    
    func addData() {
        var indexPaths = [IndexPath]()
        
        let i = "b"
        //ori
//        let commentData = CommentData()
//        commentData.setDataType(data: i)
//        commentData.setData(data: i)
//        commentData.setTextString(data: i)
        
        //test 2 > real data structure
        let vData = CommentDataset() //temp workaround
        vData.setupData(data: i)
        let commentData = CommentData()
        commentData.setData(rData: vData)
        
        self.vDataList.insert(commentData, at: 0)
        
        let idx = IndexPath(item: 0, section: 0)
        indexPaths.append(idx)
        self.vCV?.insertItems(at: indexPaths)
    }
    //*
    
    //test > fetch data => temp fake data => try refresh data first
    func asyncFetchFeed(id: String) {
        //test 
        self.vDataList.removeAll() //test > refresh dataset
        self.vCV?.reloadData()
        
        dataFetchState = "start"
        aSpinner.startAnimating()
        
        //test > adjust contentInset to y = 50 to move cv downward to accomodate spinner
        self.adjustContentInset(topInset: CGFloat(50), bottomInset: CGFloat(100))
        
        let id_ = "comment"
        let isPaginate = false
        DataFetchManager.shared.fetchCommentFeedData(id: id_, isPaginate: isPaginate) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("api success \(id), \(l)")
                    
                    guard let self = self else {
                        return
                    }
                    
//                    self.vDataList.removeAll() //test > refresh dataset
 
                    //test
                    self.aSpinner.stopAnimating()
                    
                    //test 2 > new append method
                    for i in l {
                        let commentData = CommentData()
                        commentData.setData(rData: i)
                        self.vDataList.append(commentData)
                    }
                    self.vCV?.reloadData()
                    
                    //*test 3 > reload only appended data, not entire dataset
//                    let dataCount = self.vDataList.count
//                    var indexPaths = [IndexPath]()
//                    var j = 1
//                    for i in l {
//                        let commentData = CommentData()
//                        commentData.setDataType(data: i)
//                        commentData.setData(data: i)
//                        commentData.setTextString(data: i)
//                        self.vDataList.append(commentData)
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
                        self.aaText.text = "No comments yet."
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
        
        let id_ = "comment"
        let isPaginate = true
        DataFetchManager.shared.fetchCommentFeedData(id: id_, isPaginate: isPaginate) { [weak self]result in
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
                    
                    //test 1 > append all data fetched
//                    self.vDataList.append(contentsOf: l)
                    
                    //test 2 > new append method
//                    for i in l {
//                        let commentData = CommentData()
//                        commentData.setDataType(data: i)
//                        commentData.setData(data: i)
//                        commentData.setTextString(data: i)
//                        self.vDataList.append(commentData)
//                    }
//                    self.vCV?.reloadData()
                    
                    //*test 3 > reload only appended data, not entire dataset
                    let dataCount = self.vDataList.count
                    var indexPaths = [IndexPath]()
                    var j = 1
                    for i in l {
                        let commentData = CommentData()
                        commentData.setData(rData: i)
                        self.vDataList.append(commentData)

                        let idx = IndexPath(item: dataCount - 1 + j, section: 0)
                        indexPaths.append(idx)
                        j += 1
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
        self.asyncFetchFeed(id: "comment_feed")
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
    
    //test > dehide cell
    func dehideCell() {
        guard let a = self.vCV else {
            return
        }

        if(hideCellIndex > -1) {
            let idxPath = IndexPath(item: hideCellIndex, section: 0)
            let currentVc = a.cellForItem(at: idxPath)
            guard let b = currentVc as? HCommentListViewCell else {
                return
            }
            b.dehideCell()
            
            hideCellIndex = -1
        }
    }
    
    //test > resume current video
    func resumePlayingMedia() {
        //test 2 > new method for cell-asset idx
        resumeMediaAsset(cellAssetIdx: playingCellMediaAssetIdx)
    }

    //test > pause current video for closing
    func pausePlayingMedia() {
        //test 2 > new method for cell-asset idx
        pauseMediaAsset(cellAssetIdx: playingCellMediaAssetIdx)
        print("comment pauseplaying: \(playingCellMediaAssetIdx)")
    }
    
    //test > destroy cell
    func destroyCell() {
        guard let a = self.vCV else {
            return
        }
        print("comment destroy cell \(a.visibleCells)")
        for cell in a.visibleCells {
            if let b = cell as? HCommentListViewCell {
                b.destroyCell()
            }
        }
    }
    
    //test 2 > new method for pausing video with cell-asset idx
    func pauseMediaAsset(cellAssetIdx: [Int]) {
        guard let a = self.vCV else {
            return
        }
        if(cellAssetIdx.count == 2) {
            let cIdx = cellAssetIdx[0] //cell index
            let aIdx = cellAssetIdx[1] //asset index
            if(cIdx > -1 && aIdx > -1) {
                let cIdxPath = IndexPath(item: cIdx, section: 0)
                let cell = a.cellForItem(at: cIdxPath)
                if let c = cell as? HCommentListViewCell {
                    if(!c.aTestArray.isEmpty && aIdx < c.aTestArray.count) {
                        c.pauseMedia(aIdx: aIdx)
//                        playingCellMediaAssetIdx = [-1, -1] //disabled for pauseCurrentVideo() and resume
                    }
                }
            }
        }
    }
    
    func resumeMediaAsset(cellAssetIdx: [Int]) {
        guard let a = self.vCV else {
            return
        }
        if(cellAssetIdx.count == 2) {
            let cIdx = cellAssetIdx[0]
            let aIdx = cellAssetIdx[1]
            if(cIdx > -1 && aIdx > -1) {
                let cIdxPath = IndexPath(item: cIdx, section: 0)
                let cell = a.cellForItem(at: cIdxPath)
                if let c = cell as? HCommentListViewCell {
                    if(!c.aTestArray.isEmpty && aIdx < c.aTestArray.count) {
                        c.resumeMedia(aIdx: aIdx)
                    }
                }
            }
        }
    }
    
    //test 2 > new intersect func() for multi-video/audio assets play on/off
    //try autoplay OFF first, then only autoplay
    var playingCellMediaAssetIdx = [-1, -1] //none playing initially
//    var isMediaAutoplayEnabled = true
    var isMediaAutoplayEnabled = false
    func getIntersect2() {
        guard let v = self.vCV else {
            return
        }
        
        //fixed dummy area
        let dummyTopMargin = 70.0
        let panelRectY = panelView.frame.origin.y
        let vCvRectY = v.frame.origin.y
        let dummyOriginY = panelRectY + vCvRectY + dummyTopMargin
        let dummyView = CGRect(x: 0, y: dummyOriginY, width: self.frame.width, height: 200)
//        let dummyView = CGRect(x: 0, y: dummyOriginY, width: 20, height: 200)
        //*just in case > add view for illustration
//        let dV = UIView(frame: dummyView)
//        dV.backgroundColor = .blue
//        self.addSubview(dV)
        //*
        
        //identify intersected assets
        var cellAssetIdxArray = [[Int]]() //[cellIdx, assetIdx] => use array for simplicity
        for cell in v.visibleCells {
            guard let indexPath = v.indexPath(for: cell) else {
                return
            }
            guard let b = cell as? HCommentListViewCell else {
                return
            }
            
            let cellRect = v.convert(b.frame, to: self)
            let aTestRect = b.aTest.frame
            
            let p = b.mediaArray
            if(!p.isEmpty) {
                for m in p {
                    //test > quote
                    if let q = m as? PostQuoteContentCell {
                        //for quote content cells only => double loop for inner media
                        let pp = q.mediaArray
                        if(!pp.isEmpty) {
                            for mm in pp {
                                let mmFrame = mm.frame
                                let aaTestRect = q.aTest.frame
                                
                                let mFrame = m.frame
                                if let j = b.aTestArray.firstIndex(of: m) {
                                    let cVidCOriginY = mFrame.origin.y + aTestRect.origin.y + cellRect.origin.y + mmFrame.origin.y + aaTestRect.origin.y
                                    let cVidCRect = CGRect(x: 0, y: cVidCOriginY, width: mmFrame.size.width, height: mmFrame.size.height)
                                    
                                    let isIntersect = dummyView.intersects(cVidCRect)
                                    if(isIntersect) {
                                        let idx = [indexPath.row, j]
                                        cellAssetIdxArray.append(idx)
                                    }
                                }
                            }
                        }
                    } else {
                        let mFrame = m.frame
                        if let j = b.aTestArray.firstIndex(of: m) {
                            let cVidCOriginY = mFrame.origin.y + aTestRect.origin.y + cellRect.origin.y
                            let cVidCRect = CGRect(x: 0, y: cVidCOriginY, width: mFrame.size.width, height: mFrame.size.height)
                            
                            let isIntersect = dummyView.intersects(cVidCRect)
                            if(isIntersect) {
                                let idx = [indexPath.row, j]
                                cellAssetIdxArray.append(idx)
                            }
                        }
                    }
                }
            }
        }
 
        print("getintersect2 x: \(cellAssetIdxArray); \(playingCellMediaAssetIdx)")
        
        //test > pause media when playingMedia is no longer intersected inside dummy view
        let t = cellAssetIdxArray.contains(playingCellMediaAssetIdx)
        if(!t) {
            pauseMediaAsset(cellAssetIdx: playingCellMediaAssetIdx)
            playingCellMediaAssetIdx = [-1, -1] //reset state
        }
        
        //test > autoplay video when intersected
        if(isMediaAutoplayEnabled) {
            if(!cellAssetIdxArray.isEmpty) {
                let iCellAssetIdx = cellAssetIdxArray[0]
                print("getintersect2 x: \(iCellAssetIdx); \(playingCellMediaAssetIdx) => \(iCellAssetIdx == playingCellMediaAssetIdx)")
                if(iCellAssetIdx != playingCellMediaAssetIdx) {
                    
                    //autostop playing media to prevent multi-video playing together
                    if(playingCellMediaAssetIdx != [-1, -1]) {
                        pauseMediaAsset(cellAssetIdx: playingCellMediaAssetIdx)
                        playingCellMediaAssetIdx = [-1, -1]
                    }
                    
                    //autoplay media when intersected
                    if(iCellAssetIdx.count == 2) {
                        let cIdx = iCellAssetIdx[0]
                        let aIdx = iCellAssetIdx[1]
                        if(cIdx > -1 && aIdx > -1) {
                            playingCellMediaAssetIdx = [cIdx, aIdx]
                            resumeMediaAsset(cellAssetIdx: playingCellMediaAssetIdx)
                        }
                    }
                }
            }
        }
    }
}

extension CommentScrollableView: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView,
//                  layout collectionViewLayout: UICollectionViewLayout,
//                  insetForSectionAt section: Int) -> UIEdgeInsets {
//        print("commentpanel collection: \(section)")
//        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 100.0, right: 0.0) //default: 50
//    }
    
    private func estimateHeight(text: String, textWidth: CGFloat, fontSize: CGFloat) -> CGFloat {
        if(text == "") {
            return 0
        }
        else {
            let size = CGSize(width: textWidth, height: 1000)
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]
            let estimatedFrame = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            
            return estimatedFrame.height.rounded(.up)
        }
    }

    //test > to comment out
    func collectionView(_ collectionView: UICollectionView,
                   layout collectionViewLayout: UICollectionViewLayout,
                   sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        let text = vDataList[indexPath.row].dataTextString
//        let dataL = vDataList[indexPath.row].dataArray
        let dataCL = vDataList[indexPath.row].contentDataArray
        let d = vDataList[indexPath.row].dataCode
        
        var contentHeight = 0.0
        
        let photoSize = 28.0
        let photoLhsMargin = 20.0
        let usernameLhsMargin = 5.0
        let indentSize = photoSize + photoLhsMargin + usernameLhsMargin
        
        if(d == "a") {
            for cl in dataCL {
                let l = cl.dataCode
                let da = cl.dataArray
                
                if(l == "text") {
                    let tTopMargin = 20.0
//                    let tContentHeight = estimateHeight(text: text, textWidth: collectionView.frame.width - indentSize - 30.0, fontSize: 13)
                    let t = cl.dataTextString
                    let tContentHeight = estimateHeight(text: t, textWidth: collectionView.frame.width - indentSize - 20.0, fontSize: 14) //font 13
                    let tHeight = tTopMargin + tContentHeight
                    contentHeight += tHeight
                }
                else if(l == "photo") {
                    let cellWidth = collectionView.frame.width
                    let lhsMargin = indentSize
                    let rhsMargin = 20.0
                    let availableWidth = cellWidth - lhsMargin - rhsMargin
                    
                    let assetSize = CGSize(width: 3, height: 4) //4:3
                    var cSize = CGSize(width: 0, height: 0)
                    if(assetSize.width > assetSize.height) {
                        //1 > landscape photo 4:3 w:h
                        let aRatio = CGSize(width: 4, height: 3) //aspect ratio
                        let cHeight = availableWidth * aRatio.height / aRatio.width
//                        cSize = CGSize(width: availableWidth, height: cHeight)
                        //test > round to int to prevent incomplete photo scroll
                        cSize = CGSize(width: round(availableWidth), height: round(cHeight))
                    }
                    else if (assetSize.width < assetSize.height){
                        //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                        let aRatio = CGSize(width: 2, height: 3) //aspect ratio
                        let cWidth = availableWidth * 2 / 3
                        let cHeight = cWidth * aRatio.height / aRatio.width
//                        cSize = CGSize(width: cWidth, height: cHeight)
                        //test > round to int to prevent incomplete photo scroll
                        cSize = CGSize(width: round(cWidth), height: round(cHeight))
                    } else {
                        //square
                        let cWidth = availableWidth
//                        cSize = CGSize(width: cWidth, height: cWidth)
                        //test > round to int to prevent incomplete photo scroll
                        cSize = CGSize(width: round(cWidth), height: round(cWidth))
                    }
                    
                    let pTopMargin = 20.0
    //                let pContentHeight = 280.0
                    let pContentHeight = cSize.height
                    let pHeight = pTopMargin + pContentHeight
                    contentHeight += pHeight
                }
                else if(l == "photo_s") {
                    let cellWidth = self.frame.width
                    let lhsMargin = indentSize
                    let rhsMargin = 20.0
                    let descHeight = 40.0
                    let availableWidth = cellWidth - lhsMargin - rhsMargin
                    
                    let assetSize = CGSize(width: 4, height: 3)
                    var cSize = CGSize(width: 0, height: 0)
                    if(assetSize.width > assetSize.height) {
                        //1 > landscape photo 4:3 w:h
                        let aRatio = CGSize(width: 4, height: 3) //aspect ratio
                        let cHeight = availableWidth * aRatio.height / aRatio.width + descHeight
//                        cSize = CGSize(width: availableWidth, height: cHeight)
                        //test > round to int to prevent incomplete photo scroll
                        cSize = CGSize(width: round(availableWidth), height: round(cHeight))
                    }
                    else if (assetSize.width < assetSize.height){
                        //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                        let aRatio = CGSize(width: 2, height: 3) //aspect ratio
                        let cWidth = availableWidth * 2 / 3
                        let cHeight = cWidth * aRatio.height / aRatio.width + descHeight
//                        cSize = CGSize(width: cWidth, height: cHeight)
                        //test > round to int to prevent incomplete photo scroll
                        cSize = CGSize(width: round(cWidth), height: round(cHeight))
                    } else {
                        //square
                        let cWidth = availableWidth
//                        cSize = CGSize(width: cWidth, height: cWidth + descHeight)
                        //test > round to int to prevent incomplete photo scroll
                        cSize = CGSize(width: round(cWidth), height: round(cWidth + descHeight))
                    }
                    
                    let pTopMargin = 20.0
    //                let pContentHeight = 280.0
                    let pContentHeight = cSize.height
    //                let pHeight = pTopMargin + pContentHeight + 40.0 //40.0 for bottom container for description
                    let pHeight = pTopMargin + pContentHeight
                    contentHeight += pHeight
                }
                else if(l == "video") {
                    let cellWidth = self.frame.width
                    let lhsMargin = indentSize
                    let rhsMargin = 20.0
                    let availableWidth = cellWidth - lhsMargin - rhsMargin
                    
                    let assetSize = CGSize(width: 3, height: 4)
                    var cSize = CGSize(width: 0, height: 0)
                    if(assetSize.width > assetSize.height) {
                        //1 > landscape photo 4:3 w:h
                        let aRatio = CGSize(width: 4, height: 3) //aspect ratio
                        let cHeight = availableWidth * aRatio.height / aRatio.width
//                        cSize = CGSize(width: availableWidth, height: cHeight)
                        //test > round to int to prevent incomplete photo scroll
                        cSize = CGSize(width: round(availableWidth), height: round(cHeight))
                    }
                    else if (assetSize.width < assetSize.height){
                        //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                        let aRatio = CGSize(width: 2, height: 3) //aspect ratio
                        let cWidth = availableWidth * 2 / 3
                        let cHeight = cWidth * aRatio.height / aRatio.width
//                        cSize = CGSize(width: cWidth, height: cHeight)
                        //test > round to int to prevent incomplete photo scroll
                        cSize = CGSize(width: round(cWidth), height: round(cHeight))
                    } else {
                        //square
                        let cWidth = availableWidth
//                        cSize = CGSize(width: cWidth, height: cWidth)
                        //test > round to int to prevent incomplete photo scroll
                        cSize = CGSize(width: round(cWidth), height: round(cWidth))
                    }
                    
                    let vTopMargin = 20.0
    //                let vContentHeight = 350.0 //250
                    let vContentHeight = cSize.height
                    let vHeight = vTopMargin + vContentHeight
                    contentHeight += vHeight
                }
                else if(l == "video_l") {
                    let cellWidth = collectionView.frame.width
                    let lhsMargin = indentSize
                    let rhsMargin = 20.0
                    let descHeight = 40.0
                    let availableWidth = cellWidth - lhsMargin - rhsMargin
                    
                    let assetSize = CGSize(width: 3, height: 4)
                    var cSize = CGSize(width: 0, height: 0)
                    if(assetSize.width > assetSize.height) {
                        //1 > landscape photo 4:3 w:h
                        let aRatio = CGSize(width: 4, height: 3) //aspect ratio
                        let cHeight = availableWidth * aRatio.height / aRatio.width + descHeight
//                        cSize = CGSize(width: availableWidth, height: cHeight)
                        //test > round to int to prevent incomplete photo scroll
                        cSize = CGSize(width: round(availableWidth), height: round(cHeight))
                    }
                    else if (assetSize.width < assetSize.height){
                        //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                        let aRatio = CGSize(width: 2, height: 3) //aspect ratio
                        let cWidth = availableWidth * 2 / 3
                        let cHeight = cWidth * aRatio.height / aRatio.width + descHeight
                        cSize = CGSize(width: cWidth, height: cHeight)
                        //test > round to int to prevent incomplete photo scroll
                        cSize = CGSize(width: round(cWidth), height: round(cHeight))
                    } else {
                        //square
                        let cWidth = availableWidth
                        cSize = CGSize(width: cWidth, height: cWidth + descHeight)
                        //test > round to int to prevent incomplete photo scroll
                        cSize = CGSize(width: round(cWidth), height: round(cWidth + descHeight))
                    }
                    
                    let vTopMargin = 20.0
    //                let vContentHeight = 350.0 //250
                    let vContentHeight = cSize.height
                    let vHeight = vTopMargin + vContentHeight
    //                let vHeight = vTopMargin + vContentHeight + 40.0 //40.0 for bottom container for description
                    contentHeight += vHeight
                }
                else if(l == "quote") {
                    
                    let qLhsMargin = indentSize
                    let qRhsMargin = 20.0
                    let quoteWidth = collectionView.frame.width - qLhsMargin - qRhsMargin
                    
                    let dd = cl.contentDataCode
                    if(dd == "a" || dd == "") {
                        //**test > fake data for quote post
                        var qDataArray = [String]()
                        
                        for d in da {
                            qDataArray.append(d)
                        }
                        //**
                        
                        for i in qDataArray {
                            if(i == "text") {
                                let tTopMargin = 20.0
    //                            let tContentHeight = estimateHeight(text: text, textWidth: quoteWidth - 20.0 - 20.0, fontSize: 14)
                                let t = cl.dataTextString
                                let tContentHeight = estimateHeight(text: t, textWidth: quoteWidth - 20.0 - 20.0, fontSize: 14)
                                let tHeight = tTopMargin + tContentHeight
                                contentHeight += tHeight
                            }
                            else if(i == "photo") {
                                let lhsMargin = 20.0
                                let rhsMargin = 20.0
                                let availableWidth = quoteWidth - lhsMargin - rhsMargin
                                
                                let assetSize = CGSize(width: 4, height: 3)//landscape
        //                        let assetSize = CGSize(width: 3, height: 4)
                                var cSize = CGSize(width: 0, height: 0)
                                if(assetSize.width > assetSize.height) {
                                    //1 > landscape photo 4:3 w:h
                                    let aRatio = CGSize(width: 4, height: 3) //aspect ratio
                                    let cHeight = availableWidth * aRatio.height / aRatio.width
    //                                cSize = CGSize(width: availableWidth, height: cHeight)
                                    //test > round to int to prevent incomplete photo scroll
                                    cSize = CGSize(width: round(availableWidth), height: round(cHeight))
                                }
                                else if (assetSize.width < assetSize.height){
                                    //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                                    let aRatio = CGSize(width: 2, height: 3) //aspect ratio
                                    let cWidth = availableWidth * 2 / 3
                //                    let cWidth = availableWidth //test full width for portrait
                                    let cHeight = cWidth * aRatio.height / aRatio.width
    //                                cSize = CGSize(width: cWidth, height: cHeight)
                                    //test > round to int to prevent incomplete photo scroll
                                    cSize = CGSize(width: round(cWidth), height: round(cHeight))
                                } else {
                                    //square
                                    let cWidth = availableWidth
    //                                cSize = CGSize(width: cWidth, height: cWidth)
                                    //test > round to int to prevent incomplete photo scroll
                                    cSize = CGSize(width: round(cWidth), height: round(cWidth))
                                }

                                let pTopMargin = 20.0
                //                let pContentHeight = 280.0
                                let pContentHeight = cSize.height
                                let pHeight = pTopMargin + pContentHeight
                                contentHeight += pHeight
                            }
                            else if(i == "photo_s") {
                                let lhsMargin = 20.0
                                let rhsMargin = 20.0
                                let descHeight = 40.0
                                let availableWidth = quoteWidth - lhsMargin - rhsMargin
                                
                                let assetSize = CGSize(width: 4, height: 3)
                                var cSize = CGSize(width: 0, height: 0)
                                if(assetSize.width > assetSize.height) {
                                    //1 > landscape photo 4:3 w:h
                                    let aRatio = CGSize(width: 4, height: 3) //aspect ratio
                                    let cHeight = availableWidth * aRatio.height / aRatio.width + descHeight
    //                                cSize = CGSize(width: availableWidth, height: cHeight)
                                    //test > round to int to prevent incomplete photo scroll
                                    cSize = CGSize(width: round(availableWidth), height: round(cHeight))
                                }
                                else if (assetSize.width < assetSize.height){
                                    //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                                    let aRatio = CGSize(width: 2, height: 3) //aspect ratio
                                    let cWidth = availableWidth * 2 / 3
                                    let cHeight = cWidth * aRatio.height / aRatio.width + descHeight
    //                                cSize = CGSize(width: cWidth, height: cHeight)
                                    //test > round to int to prevent incomplete photo scroll
                                    cSize = CGSize(width: round(cWidth), height: round(cHeight))
                                } else {
                                    //square
                                    let cWidth = availableWidth
    //                                cSize = CGSize(width: cWidth, height: cWidth + descHeight)
                                    //test > round to int to prevent incomplete photo scroll
                                    cSize = CGSize(width: round(cWidth), height: round(cWidth + descHeight))
                                }
                                
                                let pTopMargin = 20.0
                //                let pContentHeight = 280.0
                                let pContentHeight = cSize.height
                                let pHeight = pTopMargin + pContentHeight
                                contentHeight += pHeight
                            }
                            else if(i == "video") {
                                let lhsMargin = 20.0
                                let rhsMargin = 20.0
                                let availableWidth = quoteWidth - lhsMargin - rhsMargin
                                
                                let assetSize = CGSize(width: 3, height: 4)
                                var cSize = CGSize(width: 0, height: 0)
                                if(assetSize.width > assetSize.height) {
                                    //1 > landscape photo 4:3 w:h
                                    let aRatio = CGSize(width: 4, height: 3) //aspect ratio
                                    let cHeight = availableWidth * aRatio.height / aRatio.width
    //                                cSize = CGSize(width: availableWidth, height: cHeight)
                                    //test > round to int to prevent incomplete photo scroll
                                    cSize = CGSize(width: round(availableWidth), height: round(cHeight))
                                }
                                else if (assetSize.width < assetSize.height){
                                    //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                                    let aRatio = CGSize(width: 2, height: 3) //aspect ratio
                                    let cWidth = availableWidth * 2 / 3
                                    let cHeight = cWidth * aRatio.height / aRatio.width
    //                                cSize = CGSize(width: cWidth, height: cHeight)
                                    //test > round to int to prevent incomplete photo scroll
                                    cSize = CGSize(width: round(cWidth), height: round(cHeight))
                                } else {
                                    //square
                                    let cWidth = availableWidth
    //                                cSize = CGSize(width: cWidth, height: cWidth)
                                    //test > round to int to prevent incomplete photo scroll
                                    cSize = CGSize(width: round(cWidth), height: round(cWidth))
                                }
                                
                                let vTopMargin = 20.0
                //                let vContentHeight = 350.0 //250
                                let vContentHeight = cSize.height
                                let vHeight = vTopMargin + vContentHeight
                                contentHeight += vHeight
                            }
                            else if(i == "video_l") {
                                let lhsMargin = 20.0
                                let rhsMargin = 20.0
                                let descHeight = 40.0
                                let availableWidth = quoteWidth - lhsMargin - rhsMargin
                                
                                let assetSize = CGSize(width: 3, height: 4)
                                var cSize = CGSize(width: 0, height: 0)
                                if(assetSize.width > assetSize.height) {
                                    //1 > landscape photo 4:3 w:h
                                    let aRatio = CGSize(width: 4, height: 3) //aspect ratio
                                    let cHeight = availableWidth * aRatio.height / aRatio.width + descHeight
    //                                cSize = CGSize(width: availableWidth, height: cHeight)
                                    //test > round to int to prevent incomplete photo scroll
                                    cSize = CGSize(width: round(availableWidth), height: round(cHeight))
                                }
                                else if (assetSize.width < assetSize.height){
                                    //2 > portrait photo 3:4, use 2:3 instead of 9:16 as latter is too tall
                                    let aRatio = CGSize(width: 2, height: 3) //aspect ratio
                                    let cWidth = availableWidth * 2 / 3
                                    let cHeight = cWidth * aRatio.height / aRatio.width + descHeight
    //                                cSize = CGSize(width: cWidth, height: cHeight)
                                    //test > round to int to prevent incomplete photo scroll
                                    cSize = CGSize(width: round(cWidth), height: round(cHeight))
                                } else {
                                    //square
                                    let cWidth = availableWidth
    //                                cSize = CGSize(width: cWidth, height: cWidth + descHeight)
                                    //test > round to int to prevent incomplete photo scroll
                                    cSize = CGSize(width: round(cWidth), height: round(cWidth + descHeight))
                                }
                                
                                let vTopMargin = 20.0
                //                let vContentHeight = 350.0 //250
                                let vContentHeight = cSize.height
                                let vHeight = vTopMargin + vContentHeight
                //                let vHeight = vTopMargin + vContentHeight + 40.0 //40.0 for bottom container for description
                                contentHeight += vHeight
                            }
                            else if(i == "quote") {
                                let tTopMargin = 20.0
                                let t = "[Quote]"
                                let tContentHeight = estimateHeight(text: t, textWidth: quoteWidth - 20.0 - 20.0, fontSize: 14)
                                let tHeight = tTopMargin + tContentHeight
                                contentHeight += tHeight
                            }
                        }
                    }
                    else if(dd == "na") {
                        let qNpTopMargin = 20.0
                        let qNpTTopMargin = 10.0 //20
                        let qNpTBottomMargin = 10.0
                        let qNpText = "Post does not exist."
                        let qNpContentHeight = estimateHeight(text: qNpText, textWidth: quoteWidth - 20.0 - 20.0, fontSize: 13)
                        let qNpHeight = qNpTTopMargin + qNpContentHeight + qNpTBottomMargin + qNpTopMargin
                        contentHeight += qNpHeight
                    }
                    else if(dd == "us") {
                        let qNpTopMargin = 20.0
                        let qNpTTopMargin = 10.0 //20
                        let qNpTBottomMargin = 10.0
                        let qNpText = "Post violated community rules."
                        let qNpContentHeight = estimateHeight(text: qNpText, textWidth: quoteWidth - 20.0 - 20.0, fontSize: 13)
                        let qNpHeight = qNpTTopMargin + qNpContentHeight + qNpTBottomMargin + qNpTopMargin
                        contentHeight += qNpHeight
                    }
                    let qTopMargin = 20.0
                    let qUserPhotoHeight = 28.0
                    let qUserPhotoTopMargin = 15.0 //20
                    let qFrameBottomMargin = 20.0 //10
                    let qHeight = qTopMargin + qUserPhotoHeight + qUserPhotoTopMargin + qFrameBottomMargin
                    contentHeight += qHeight
                }
            }
        }
        else if(d == "na") {
            let npTopMargin = 20.0
            let npTTopMargin = 10.0 //20
            let npTBottomMargin = 10.0
            let npText = "Post does not exist."
            let npContentHeight = estimateHeight(text: npText, textWidth: collectionView.frame.width - 20.0 - 20.0, fontSize: 13)
            let npHeight = npTTopMargin + npContentHeight + npTBottomMargin + npTopMargin
            contentHeight += npHeight
        }
        else if(d == "us") {
            let npTopMargin = 20.0
            let npTTopMargin = 10.0 //20
            let npTBottomMargin = 10.0
            let npText = "Post violated community rules."
            let npContentHeight = estimateHeight(text: npText, textWidth: collectionView.frame.width - 20.0 - 20.0, fontSize: 13)
            let npHeight = npTTopMargin + npContentHeight + npTBottomMargin + npTopMargin
            contentHeight += npHeight
        }
        
        let userPhotoHeight = 28.0
        let userPhotoTopMargin = 10.0 //10
        let actionBtnTopMargin = 20.0
        let actionBtnHeight = 26.0
        let frameBottomMargin = 20.0 //10
        let miscHeight = userPhotoHeight + userPhotoTopMargin + actionBtnTopMargin + actionBtnHeight + frameBottomMargin
        let totalHeight = contentHeight + miscHeight
        
//        return CGSize(width: collectionView.frame.width, height: 80)
        return CGSize(width: collectionView.frame.width, height: totalHeight)
    }
    
    //test > add footer
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        print("commentpanel footer reuse")
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
        print("commentpanel referencesize: \(section)")
        return CGSize(width: collectionView.bounds.size.width, height: 100)
    }
        
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == vDataList.count - 1 {
            print("commentpanel willdisplay: \(indexPath.row)")

            if(dataPaginateStatus != "end") {
                if(pageNumber >= 3) {
                    asyncPaginateFetchFeed(id: "comment_feed_end")
                } else {
                    asyncPaginateFetchFeed(id: "comment_feed")
                }

            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("commentpanel didEndDisplaying: \(indexPath.row)")
    }
}
//test > try scrollview listener
extension CommentScrollableView: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

        print("scrollview begin: \(scrollView.contentOffset.y)")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //test > react to intersected index
//        reactToIntersectedVideo(intersectedIdx: getIntersectedIdx())
        
        //test 2 > try new intersect
        getIntersect2()
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
//        if(!decelerate) {
//            //test
//            if(scrollView.contentOffset.y == 0) {
//                isScrollViewAtTop = true
//            } else {
//                isScrollViewAtTop = false
//            }
//            print("scrollview end drag check: \(isScrollViewAtTop)")
//        }
        
        //test
        let scrollOffsetY = scrollView.contentOffset.y
        
        //test > refresh dataset
        if(isScrollViewAtTop) {
            if(scrollOffsetY < -80) {
                //test > clear data for regenerate feed => not great
//                vcDataList.removeAll()
//                postCV?.reloadData()
                //**
                
//                self.asyncFetchFeed(id: "post_feed")
                self.asyncFetchFeed(id: "comment_feed")
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

        print("scrollview animation ended")
        
        //test > reset contentInset to origin of y = 0
//        self.adjustContentInset(topInset: CGFloat(0), bottomInset: CGFloat(50))
        self.adjustContentInset(topInset: CGFloat(0), bottomInset: CGFloat(100))
    }
}
extension CommentScrollableView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCommentListViewCell.identifier, for: indexPath) as! HCommentListViewCell
        cell.aDelegate = self
        
        //test > configure cell
        cell.configure(data: vDataList[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCommentListViewCell.identifier, for: indexPath) as! HCommentListViewCell
//        let originInRootView = collectionView.convert(cell.frame.origin, to: self)
//        print("collectionView index: \(indexPath), \(cell.frame.origin.x), \(cell.frame.origin.y), \(originInRootView)")
        
     }
}

//test > textview delegate for comment
extension CommentScrollableView: UITextViewDelegate {
//    func textView(_ textView: UITextView, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let maxLength = 20
//        let currentString: NSString = (textView.text ?? "") as NSString
//        let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
//
//        return newString.length <= maxLength
//    }

    func textViewDidChange(_ textView: UITextView) {
        
        let minHeight = 36.0
        let maxHeight = 72.0
        
//        let size = CGSize(width: self.frame.width, height: .infinity)
        let emojiBtnWidth = 40.0
        let textboxMargin = 10.0
        var maxUsableTextWidth = aaView.frame.size.width - textboxMargin * 2
        var minUsableTextWidth = aaView.frame.size.width - emojiBtnWidth * 3 - textboxMargin * 2
        let size = CGSize(width: minUsableTextWidth, height: 1000)
        let estimatedSize = textView.sizeThatFits(size)
        
        let intrinsicSize = CGSize(width: maxUsableTextWidth, height: 1000)
        let estimatedIntrinsicSize = textView.sizeThatFits(intrinsicSize)
        
        //tets 2 > check length of textview text
        let currentString: NSString = (textView.text ?? "") as NSString
        print("textviewdelegate: \(currentString.length), \(estimatedSize), \(aaView.frame.size.width)")

        if(currentString.length > 0) {
            aaViewTrailingCons?.isActive = false
            aaViewTrailingCons = aaView.trailingAnchor.constraint(equalTo: sendBox.leadingAnchor, constant: -10)
            aaViewTrailingCons?.isActive = true

            bbText.isHidden = true
            
            //test 2 > check width and height
            let estimatedWidth = estimatedIntrinsicSize.width
            if(estimatedWidth < minUsableTextWidth) {
                let estimatedHeight = estimatedSize.height
                if(estimatedHeight < minHeight) {
                    aTextBoxHeightCons?.constant = minHeight
                } else {
                    if(estimatedHeight >= maxHeight) {
                        aTextBoxHeightCons?.constant = maxHeight
                    } else {
                        aTextBoxHeightCons?.constant = estimatedHeight
                    }
                }
            }
            else {
                let estimatedHeight = estimatedIntrinsicSize.height
                if(estimatedHeight >= maxHeight) {
                    aTextBoxHeightCons?.constant = maxHeight
                } else if(estimatedHeight < minHeight) {
                    aTextBoxHeightCons?.constant = minHeight
                } else {
                    aTextBoxHeightCons?.constant = estimatedHeight
                }
            }
        } else {
            aaViewTrailingCons?.isActive = false
            aaViewTrailingCons = aaView.trailingAnchor.constraint(equalTo: textPanel.trailingAnchor, constant: -20)
            aaViewTrailingCons?.isActive = true

            aTextBoxHeightCons?.constant = minHeight
            
            bbText.isHidden = false
        }
    }
}
extension CommentScrollableView: ErrorUploadCommentMsgDelegate {
    func didEUCommentClickProceed() {
        asyncSendNewData()
    }
    func didEUCommentClickDeny(){
        //test
//        setFirstResponder(textView: aTextBox)
    }
}
extension CommentScrollableView: HListCellDelegate {
    func hListDidClickVcvComment(vc: UICollectionViewCell, id: String, dataType: String, pointX: CGFloat, pointY: CGFloat){
        
        pausePlayingMedia()

//        delegate?.didCClickComment(id: id, dataType: dataType)
        
        //test 2 > new method
        if let a = vCV {
            for cell in a.visibleCells {
                
                if(cell == vc) {
                    //commentview bounds is fullscreen, so no more conversion is needed
                    let originInRootView = a.convert(cell.frame.origin, to: self)
                    let visibleIndexPath = a.indexPath(for: cell)
                    let pointX1 = originInRootView.x + pointX
                    let pointY1 = originInRootView.y + pointY
                    print("comment idx frame origin p: \(pointX1), \(pointY1)")
                    delegate?.didCClickComment(id: id, dataType: dataType, pointX: pointX1, pointY: pointY1)
                    
                    if let c = visibleIndexPath {
                        hideCellIndex = c.row
                    }
                    
                    break
                }
            }
        }
    }
    func hListDidClickVcvLove(){
        
    }
    func hListDidClickVcvShare(vc: UICollectionViewCell, id: String, dataType: String){
        
        pausePlayingMedia()
        
        if let a = vCV {
            for cell in a.visibleCells {
                
                if(cell == vc) {
                    let selectedIndexPath = a.indexPath(for: cell)
                    delegate?.didCClickShare(id: id, dataType: dataType)
                    
                    if let c = selectedIndexPath {
                        selectedItemIdx = c.row
                    }
                    
                    break
                }
            }
        }
    }
    func hListDidClickVcvClickUser(id: String){
        pausePlayingMedia()
        delegate?.didCClickUser(id: id)
    }
    func hListDidClickVcvClickPlace(id: String){
        pausePlayingMedia()
        delegate?.didCClickPlace(id: id)
    }
    func hListDidClickVcvClickSound(id: String, vc: UICollectionViewCell, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
        pausePlayingMedia()
//        delegate?.didCClickSound(id: id)
        
        if let a = vCV {
            for cell in a.visibleCells {
                
                if(cell == vc) {
                    //commentview bounds is fullscreen, so no more conversion is needed
                    let originInRootView = a.convert(cell.frame.origin, to: self)
                    let visibleIndexPath = a.indexPath(for: cell)
                    let pointX1 = originInRootView.x + pointX
                    let pointY1 = originInRootView.y + pointY
                    print("comment idx frame origin p: \(pointX1), \(pointY1)")
                    delegate?.didCClickSound(id: id, pointX: pointX1, pointY: pointY1, view: view, mode: mode)
                    
                    if let c = visibleIndexPath {
                        hideCellIndex = c.row
                    }
                    
                    break
                }
            }
        }
    }
    func hListDidClickVcvClickPost(id: String, dataType: String, vc: UICollectionViewCell, pointX: CGFloat, pointY: CGFloat){
        pausePlayingMedia()
//        delegate?.didCClickPost(id: id, dataType: dataType)
        
        //test 2 > new method
        if let a = vCV {
            for cell in a.visibleCells {
                
                if(cell == vc) {
                    //commentview bounds is fullscreen, so no more conversion is needed
                    let originInRootView = a.convert(cell.frame.origin, to: self)
                    let visibleIndexPath = a.indexPath(for: cell)
                    let pointX1 = originInRootView.x + pointX
                    let pointY1 = originInRootView.y + pointY
                    print("comment idx frame origin p: \(pointX1), \(pointY1)")
                    delegate?.didCClickPost(id: id, dataType: dataType, pointX: pointX1, pointY: pointY1)
                    
                    if let c = visibleIndexPath {
                        hideCellIndex = c.row
                    }
                    
                    break
                }
            }
        }
    }
    func hListDidClickVcvClickPhoto(id: String, vc: UICollectionViewCell, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
        
        pausePlayingMedia()
        
        if let a = vCV {
            for cell in a.visibleCells {
                
                if(cell == vc) {
                    //commentview bounds is fullscreen, so no more conversion is needed
                    let originInRootView = a.convert(cell.frame.origin, to: self)
                    let visibleIndexPath = a.indexPath(for: cell)
                    let pointX1 = originInRootView.x + pointX
                    let pointY1 = originInRootView.y + pointY
                    print("comment idx frame origin p: \(pointX1), \(pointY1)")
                    delegate?.didCClickClickPhoto(id: id, pointX: pointX1, pointY: pointY1, view: view, mode: mode)
                    
                    if let c = visibleIndexPath {
                        hideCellIndex = c.row
                    }
                    
                    break
                }
            }
        }
    }
    func hListDidClickVcvClickVideo(id: String, vc: UICollectionViewCell, pointX: CGFloat, pointY: CGFloat, view: UIView, mode: String){
        
        pausePlayingMedia()
        
        if let a = vCV {
            for cell in a.visibleCells {
                
                if(cell == vc) {
                    //commentview bounds is fullscreen, so no more conversion is needed
                    let originInRootView = a.convert(cell.frame.origin, to: self)
                    let visibleIndexPath = a.indexPath(for: cell)
                    let pointX1 = originInRootView.x + pointX
                    let pointY1 = originInRootView.y + pointY
                    print("comment idx frame origin p: \(pointX1), \(pointY1)")
                    delegate?.didCClickClickVideo(id: id, pointX: pointX1, pointY: pointY1, view: view, mode: mode)
                    
                    if let c = visibleIndexPath {
                        hideCellIndex = c.row
                    }
                    
                    break
                }
            }
        }
    }
    func hListDidClickVcvSortComment(){}
    func hListIsScrollCarousel(isScroll: Bool){}
    
    //test > carousel photo scroll page
    func hListCarouselIdx(vc: UICollectionViewCell, aIdx: Int, idx: Int){
        if let a = vCV {
            for cell in a.visibleCells {
                guard let indexPath = a.indexPath(for: cell) else {
                    continue
                }
                
                if(cell == vc) {
//                    vDataList[indexPath.row].t_s = ts
                    
                    //test > new method
                    let data = vDataList[indexPath.row]
                    let dataCL = data.contentDataArray
                    if(aIdx > -1 && aIdx < dataCL.count) {
                        dataCL[aIdx].p_s = idx
                    }

                    break
                }
            }
        }
    }
    
    func hListVideoStopTime(vc: UICollectionViewCell, aIdx: Int, ts: Double){
        if let a = vCV {
            for cell in a.visibleCells {
                guard let indexPath = a.indexPath(for: cell) else {
                    continue
                }
                
                if(cell == vc) {
//                    vDataList[indexPath.row].t_s = ts
                    
                    //test > new method
                    let data = vDataList[indexPath.row]
                    let dataCL = data.contentDataArray
                    if(aIdx > -1 && aIdx < dataCL.count) {
                        dataCL[aIdx].t_s = ts
                    }

                    break
                }
            }
        }
    }
    
    //test > click play sound
    func hListDidClickVcvPlayAudio(vc: UICollectionViewCell){
        
    }
    
    func hListDidClickVcvClickPlay(vc: UICollectionViewCell, isPlay: Bool){
        //test > try new method for manual play/stop video
        if let a = vCV {
            for cell in a.visibleCells {
                guard let indexPath = a.indexPath(for: cell) else {
                    continue
                }
                
                if(cell == vc) {
                    if let s = cell as? HCommentListViewCell {
                        let mIdx = s.playingMediaAssetIdx
                        if(isPlay) {
                            pauseMediaAsset(cellAssetIdx: playingCellMediaAssetIdx) //test
                            
                            playingCellMediaAssetIdx = [indexPath.row, mIdx]
                        } else {
                            playingCellMediaAssetIdx = [-1, -1]
                        }
                    }
                    
                    break
                }
            }
        }
        
        print("comment playingCellMediaAssetIdx: \(playingCellMediaAssetIdx)")
    }
    
    func hListResize(vc: UICollectionViewCell){
        if let a = vCV {
            for cell in a.visibleCells {
                guard let indexPath = a.indexPath(for: cell) else {
                    continue
                }
                
                if(cell == vc) {
                    if let s = cell as? HCommentListViewCell {
                        var idxArray: [IndexPath] = []
                        idxArray.append(indexPath)
                        a.reloadItems(at: idxArray)
                    }
                    
                    break
                }
            }
        }
    }
}

