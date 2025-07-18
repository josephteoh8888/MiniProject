//
//  NotifyPanelView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

protocol NotifyPanelDelegate : AnyObject {
    
    //test > connect to other panel
    func didNotifyClickUser(id: String)
    func didNotifyClickPlace(id: String)
    func didNotifyClickSound(id: String)
    func didNotifyClickLogin()
}

//test > new method with uiscrollview of feedcells
class NotifyPanelView: PanelView{
    var notifyPanel = UIView()
    var tabDataList = [String]()
    
    weak var delegate : NotifyPanelDelegate?
    
    let aStickyHeader = UIView()
    
    let feedScrollView = UIScrollView()
    var feedList = [ScrollFeedHNotifyListCell]()
    
//    var tabList = [UIView]()
    var tabList = [TabStack]()
    let tabSelect = UIView()
    var tabSelectLeadingCons: NSLayoutConstraint?
    var tabSelectWidthCons: NSLayoutConstraint?
    var stackviewUsableLength = 0.0
    let tabScrollView = UIScrollView()
    let stackView = UIView()
    let tabScrollMargin = 90.0 //20, 0, 50
    
    var currentIndex = 0
    
    var currentTabSelectLeadingCons = 0.0
    var tempCurrentIndex = 0
    
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    
    //test > user login/out status
    var isUserLoggedIn = false
    let aLoggedOutBox = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()

    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    func setupViews() {
        
        notifyPanel.backgroundColor = .ddmBlackOverlayColor
        self.addSubview(notifyPanel)
        notifyPanel.translatesAutoresizingMaskIntoConstraints = false
        notifyPanel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        notifyPanel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //default 0
        notifyPanel.layer.masksToBounds = true
        notifyPanel.layer.cornerRadius = 10 //10
        notifyPanel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        notifyPanel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        
        let aStickyHeader = UIView()
//        aStickyHeader.backgroundColor = .ddmBlackOverlayColor
        notifyPanel.addSubview(aStickyHeader)
        aStickyHeader.translatesAutoresizingMaskIntoConstraints = false
        aStickyHeader.trailingAnchor.constraint(equalTo: notifyPanel.trailingAnchor).isActive = true
        aStickyHeader.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        aStickyHeader.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        aStickyHeader.leadingAnchor.constraint(equalTo: notifyPanel.leadingAnchor, constant: 0).isActive = true
        aStickyHeader.isHidden = true
        
//        let aBtn = UIView()
////        aBtn.backgroundColor = .ddmDarkColor
////        aBtn.backgroundColor = .clear
//        aStickyHeader.addSubview(aBtn)
//        aBtn.translatesAutoresizingMaskIntoConstraints = false
//        aBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true //ori: 40
//        aBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
////        aBtn.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -10).isActive = true
//        aBtn.leadingAnchor.constraint(equalTo: aStickyHeader.leadingAnchor, constant: 20).isActive = true
//    //        aBtn.topAnchor.constraint(equalTo: userPanel.topAnchor, constant: 30).isActive = true
//        aBtn.bottomAnchor.constraint(equalTo: aStickyHeader.bottomAnchor, constant: 0).isActive = true
//        aBtn.layer.cornerRadius = 20
//        aBtn.layer.opacity = 0.3
//        aBtn.isUserInteractionEnabled = true
//        aBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onABtnClicked)))
//
//        let rBoxBtn = UIImageView()
//        rBoxBtn.image = UIImage(named:"icon_round_setting")?.withRenderingMode(.alwaysTemplate)
//        rBoxBtn.tintColor = .white
//        aStickyHeader.addSubview(rBoxBtn)
//        rBoxBtn.translatesAutoresizingMaskIntoConstraints = false
//        rBoxBtn.centerXAnchor.constraint(equalTo: aBtn.centerXAnchor).isActive = true
//        rBoxBtn.centerYAnchor.constraint(equalTo: aBtn.centerYAnchor).isActive = true
//        rBoxBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true
//        rBoxBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
////        rBoxBtn.layer.opacity = 0.5
        
        tabDataList.append("dm") //chat
//        tabDataList.append("f") //follower
//        tabDataList.append("l") //like
//        tabDataList.append("c") //comment
        tabDataList.append("n") //notification
//        tabDataList.append("dm") //chat
//        tabDataList.append("o") //chat
        
        //test ** > uiscrollview
        notifyPanel.addSubview(tabScrollView)
        tabScrollView.backgroundColor = .clear //clear
        tabScrollView.translatesAutoresizingMaskIntoConstraints = false
        tabScrollView.heightAnchor.constraint(equalToConstant: 40).isActive = true //ori 60
//        tabScrollView.topAnchor.constraint(equalTo: aStickyHeader.bottomAnchor, constant: 0).isActive = true
        tabScrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true //50
        tabScrollView.leadingAnchor.constraint(equalTo: notifyPanel.leadingAnchor, constant: tabScrollMargin).isActive = true //20
        tabScrollView.trailingAnchor.constraint(equalTo: notifyPanel.trailingAnchor, constant: -tabScrollMargin).isActive = true
        tabScrollView.showsHorizontalScrollIndicator = false
        tabScrollView.alwaysBounceHorizontal = true //test
        //**

        stackView.backgroundColor = .clear //clear
        tabScrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.heightAnchor.constraint(equalToConstant: 40).isActive = true //ori 30
        stackView.topAnchor.constraint(equalTo: tabScrollView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: tabScrollView.leadingAnchor, constant: 10).isActive = true
//
//        aHighlight.backgroundColor = .yellow
        tabSelect.backgroundColor = .clear
        stackView.addSubview(tabSelect)
        tabSelect.translatesAutoresizingMaskIntoConstraints = false
        tabSelectLeadingCons = tabSelect.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0)
        tabSelectLeadingCons?.isActive = true
        tabSelect.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
        tabSelect.heightAnchor.constraint(equalToConstant: 2).isActive = true //ori 60
//        tabSelect.widthAnchor.constraint(equalToConstant: hWidth).isActive = true
        tabSelectWidthCons = tabSelect.widthAnchor.constraint(equalToConstant: 0)
        tabSelectWidthCons?.isActive = true
//        aHighlight.widthAnchor.constraint(equalToConstant: 30).isActive = true
        tabSelect.isHidden = true

        let aHighlightInner = UIView()
        aHighlightInner.backgroundColor = .yellow
        tabSelect.addSubview(aHighlightInner)
        aHighlightInner.translatesAutoresizingMaskIntoConstraints = false
        aHighlightInner.heightAnchor.constraint(equalToConstant: 2).isActive = true //ori 60
        aHighlightInner.widthAnchor.constraint(equalToConstant: 30).isActive = true
        aHighlightInner.centerYAnchor.constraint(equalTo: tabSelect.centerYAnchor).isActive = true
        aHighlightInner.centerXAnchor.constraint(equalTo: tabSelect.centerXAnchor).isActive = true
        
        notifyPanel.addSubview(feedScrollView)
        feedScrollView.backgroundColor = .clear //clear
        feedScrollView.translatesAutoresizingMaskIntoConstraints = false
        feedScrollView.topAnchor.constraint(equalTo: tabScrollView.bottomAnchor, constant: 10).isActive = true
        feedScrollView.bottomAnchor.constraint(equalTo: notifyPanel.bottomAnchor, constant: 0).isActive = true //0
        feedScrollView.leadingAnchor.constraint(equalTo: notifyPanel.leadingAnchor, constant: 0).isActive = true
        feedScrollView.trailingAnchor.constraint(equalTo: notifyPanel.trailingAnchor, constant: 0).isActive = true
        feedScrollView.showsHorizontalScrollIndicator = false
        feedScrollView.alwaysBounceHorizontal = true //test
        feedScrollView.isPagingEnabled = true
        feedScrollView.delegate = self
        
        //test > logged out UI
//        let aLoggedOutBox = UIView()
        notifyPanel.addSubview(aLoggedOutBox)
        aLoggedOutBox.translatesAutoresizingMaskIntoConstraints = false
//        aLoggedOutBox.topAnchor.constraint(equalTo: aSemiTransparentTextBox.topAnchor, constant: 0).isActive = true
        aLoggedOutBox.centerYAnchor.constraint(equalTo: notifyPanel.centerYAnchor, constant: -60).isActive = true //-90
        aLoggedOutBox.leadingAnchor.constraint(equalTo: notifyPanel.leadingAnchor).isActive = true
        aLoggedOutBox.trailingAnchor.constraint(equalTo: notifyPanel.trailingAnchor).isActive = true
        aLoggedOutBox.isHidden = false
//        aLoggedOutBox.isHidden = true
        
//        let loggedOutImage = UIImageView(image: UIImage(named:"icon_outline_account")?.withRenderingMode(.alwaysTemplate))
        let loggedOutImage = UIImageView(image: UIImage(named:"icon_round_account_b")?.withRenderingMode(.alwaysTemplate))
        loggedOutImage.tintColor = .white
        aLoggedOutBox.addSubview(loggedOutImage)
        loggedOutImage.translatesAutoresizingMaskIntoConstraints = false
        loggedOutImage.topAnchor.constraint(equalTo: aLoggedOutBox.topAnchor).isActive = true
        loggedOutImage.centerXAnchor.constraint(equalTo: aLoggedOutBox.centerXAnchor, constant: 0).isActive = true
        loggedOutImage.heightAnchor.constraint(equalToConstant: 60).isActive = true //ori 26
        loggedOutImage.widthAnchor.constraint(equalToConstant: 60).isActive = true
//        loggedOutImage.layer.opacity = 0.8
        
        let aLoginText = UILabel()
        aLoginText.textAlignment = .center
        aLoginText.textColor = .white
        aLoginText.font = .boldSystemFont(ofSize: 13)
//        aLoginText.font = .systemFont(ofSize: 14)
        aLoggedOutBox.addSubview(aLoginText)
        aLoginText.translatesAutoresizingMaskIntoConstraints = false
        aLoginText.topAnchor.constraint(equalTo: loggedOutImage.bottomAnchor, constant: 10).isActive = true
        aLoginText.centerXAnchor.constraint(equalTo: loggedOutImage.centerXAnchor, constant: 0).isActive = true
        aLoginText.text = "Log into existing account" //default: Around You
        
        let aFollow = UIView()
        aFollow.backgroundColor = .yellow
        aLoggedOutBox.addSubview(aFollow)
        aFollow.translatesAutoresizingMaskIntoConstraints = false
//        aFollow.leadingAnchor.constraint(equalTo: aLoggedOutBox.leadingAnchor, constant: 100).isActive = true
//        aFollow.trailingAnchor.constraint(equalTo: aLoggedOutBox.trailingAnchor, constant: -100).isActive = true
        aFollow.centerXAnchor.constraint(equalTo: aLoggedOutBox.centerXAnchor).isActive = true
        aFollow.heightAnchor.constraint(equalToConstant: 40).isActive = true //30
        aFollow.topAnchor.constraint(equalTo: aLoginText.bottomAnchor, constant: 20).isActive = true
        aFollow.bottomAnchor.constraint(equalTo: aLoggedOutBox.bottomAnchor, constant: 0).isActive = true
        aFollow.layer.cornerRadius = 10
        aFollow.isUserInteractionEnabled = true
        aFollow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onFollowClicked)))

        let aFollowText = UILabel()
        aFollowText.textAlignment = .center
        aFollowText.textColor = .black
        aFollowText.font = .boldSystemFont(ofSize: 13) //default 14
        aFollow.addSubview(aFollowText)
        aFollowText.translatesAutoresizingMaskIntoConstraints = false
//        aFollowText.centerXAnchor.constraint(equalTo: aFollow.centerXAnchor).isActive = true
        aFollowText.leadingAnchor.constraint(equalTo: aFollow.leadingAnchor, constant: 60).isActive = true
        aFollowText.trailingAnchor.constraint(equalTo: aFollow.trailingAnchor, constant: -60).isActive = true
        aFollowText.centerYAnchor.constraint(equalTo: aFollow.centerYAnchor).isActive = true
        aFollowText.text = "Login"
    }
    
    @objc func onABtnClicked(gesture: UITapGestureRecognizer) {

    }
    
    @objc func onFollowClicked(gesture: UITapGestureRecognizer) {
        
        aLoggedOutBox.isHidden = true
        
        delegate?.didNotifyClickLogin()
    }
    
    //test
    override func resumeActiveState() {
        print("notifypanelview resume active")
        
        //test > check for signin status when in active state
        asyncFetchSigninStatus()
    }
    
    //test > initialization state
    var isInitialized = false
    func initialize() {
        
        if(!isInitialized) {
            
            //redraw UI
            layoutTabUI()
            
            if(isUserLoggedIn) {
                aLoggedOutBox.isHidden = true
            } else {
                aLoggedOutBox.isHidden = false
            }
            
            //start fetch data
            self.asyncInit(id: "search_term")
        }
        //test > check signin status
//        else {
//            asyncFetchSigninStatus()
//        }
            
        isInitialized = true
    }
    func initialize(width: CGFloat, height: CGFloat) {
        viewWidth = width
        viewHeight = height
        
//        initialize()
        
        //test
        asyncFetchSigninStatus()
    }
    
    func layoutTabUI() {
        
        for d in tabDataList {
            let stack = TabStack()
            stackView.addSubview(stack)
            stack.translatesAutoresizingMaskIntoConstraints = false
            if(tabList.isEmpty) {
                stack.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0).isActive = true //20
            } else {
                let lastArrayE = tabList[tabList.count - 1]
                stack.leadingAnchor.constraint(equalTo: lastArrayE.trailingAnchor, constant: 0).isActive = true //20
            }
            stack.centerYAnchor.constraint(equalTo: stackView.centerYAnchor, constant: 0).isActive = true
            stack.heightAnchor.constraint(equalToConstant: 40).isActive = true
            tabList.append(stack)
            if(!tabList.isEmpty && tabList.count == tabDataList.count) {
                stack.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0).isActive = true
            }
            //test > if less than 3 tabs, can split width of tab to two equal parts
            let tabCount = tabDataList.count
            var isTabWidthFixed = false
            if(tabCount < 3) {
//            if(tabCount == 2 || tabCount == 3) {
                let tabWidth = (viewWidth - tabScrollMargin*2)/CGFloat(tabCount)
                stack.widthAnchor.constraint(equalToConstant: tabWidth).isActive = true
                isTabWidthFixed = true
            }
            stack.setTabTextMargin(isTabWidthFixed: isTabWidthFixed)
            stack.setTabTypeSmall(isSmall: true)
            stack.setUIChange(isChange: false)
            stack.setArrowAdded(isArrowAdd: false)
            stack.delegate = self

            if(d == "dm") {
                stack.setText(code: d, d: "Chat") //Messages
            } else if(d == "f") {
                stack.setText(code: d, d: "Followers")
            }  else if(d == "c") {
                stack.setText(code: d, d: "Comments")
            } else if(d == "l") {
                stack.setText(code: d, d: "Likes")
            } else if(d == "n") {
//                stack.setText(code: d, d: "Notifications")
                stack.setText(code: d, d: "Inbox")
            } else if(d == "o") {
                stack.setText(code: d, d: "Order")
            }

        }
    }
    
    func redrawUI() {
        let viewWidth = self.frame.width
        let feedHeight = feedScrollView.frame.height
        for d in tabDataList {
//            let stack = UIView()
            
            var stack: ScrollFeedHNotifyListCell?
            
            if(d == "dm") {
                stack = ScrollFeedHNotifyChatListCell()
            } else if(d == "n") {
                stack = ScrollFeedHNotifyInboxListCell()
            } else {
                stack = ScrollFeedHNotifyInboxListCell()
            }
            guard let stack = stack else {
                return
            }
            feedScrollView.addSubview(stack)
            stack.translatesAutoresizingMaskIntoConstraints = false
            if(feedList.isEmpty) {
                stack.leadingAnchor.constraint(equalTo: feedScrollView.leadingAnchor, constant: 0).isActive = true
            } else {
                let lastArrayE = feedList[feedList.count - 1]
                stack.leadingAnchor.constraint(equalTo: lastArrayE.trailingAnchor, constant: 0).isActive = true //20
            }
            stack.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
            stack.heightAnchor.constraint(equalToConstant: feedHeight).isActive = true
            feedList.append(stack)
            
            stack.initialize()
            stack.aDelegate = self
            
            //test > set code
            stack.setCode(code: d)
        }
        
        let tabCount = tabDataList.count
        feedScrollView.contentSize = CGSize(width: viewWidth * CGFloat(tabCount), height: feedHeight)
        print("notifypanel contentsize \(viewWidth * CGFloat(tabCount)), \(feedHeight)")
    }
    
    var tabScrollGap = 0.0
    var totalTabScrollXLead = 0.0
    func measureTabScroll() {
        tabScrollGap = stackviewUsableLength - tabScrollView.frame.width
        if(tabScrollGap < 0) {
            tabScrollGap = 0.0
        }
        if(!self.tabList.isEmpty) {
            totalTabScrollXLead = stackviewUsableLength - tabList[tabList.count - 1].frame.width
        }
    }
    
    func activateTabUI() {
        if(!self.tabList.isEmpty) {
            for l in self.tabList {
                self.stackviewUsableLength += l.frame.width
            }
//                        self.stackviewUsableLength += 10.0 //leading constraint on tabscrollview
            print("notifypanel tabstack usablewidth \(self.stackviewUsableLength)")
            self.tabScrollView.contentSize = CGSize(width: self.stackviewUsableLength, height: 40)

            let tab = self.tabList[0]
            self.tabSelectWidthCons?.constant = tab.frame.width
            self.tabSelect.isHidden = false
        }
        self.measureTabScroll()
        
        self.reactToTabSectionChange(index: self.currentIndex) //test
    }
    
    func asyncInit(id: String) {
        DataFetchManager.shared.fetchData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("notifypanel init api success \(id), \(l)")

                    guard let self = self else {
                        return
                    }
                    
//                    if(!self.tabList.isEmpty) {
//                        for l in self.tabList {
//                            self.stackviewUsableLength += l.frame.width
//                        }
////                        self.stackviewUsableLength += 10.0 //leading constraint on tabscrollview
//                        print("notifypanel tabstack usablewidth \(self.stackviewUsableLength)")
//                        self.tabScrollView.contentSize = CGSize(width: self.stackviewUsableLength, height: 40)
//
//                        let tab = self.tabList[0]
//                        self.tabSelectWidthCons?.constant = tab.frame.width
//                        self.tabSelect.isHidden = false
//                    }
//                    self.measureTabScroll()
//                    
//                    self.reactToTabSectionChange(index: self.currentIndex) //test
                    
                    //test > init tabscroll UI e.g. measure width
                    self.activateTabUI()
                    self.redrawUI()
                    
                    //test > async fetch feed
                    if(!self.feedList.isEmpty) {
                        let feed = self.feedList[self.currentIndex]
                        if(self.isUserLoggedIn) {
                            self.asyncFetchFeed(cell: feed, id: "notify_feed")
                        }
                    }
                }

                case .failure(_):
                    print("api fail")
                    break
            }
        }
    }
    
    //test > remove all UI when user sign out
    func deconfigurePanel() {
        
        if(!feedList.isEmpty) {
            for feed in feedList {
                feed.dataPaginateStatus = ""
                feed.vDataList.removeAll()
                feed.vCV?.reloadData()
                
                feed.removeFromSuperview()
            }
            feedList.removeAll()
        }
        
        if(!tabList.isEmpty) {
            for e in tabList {
                e.removeFromSuperview()
            }
            tabList.removeAll()
        }
        
        //reset to 0
        stackviewUsableLength = 0.0
    }
    
    //test > fetch data => temp fake data => try refresh data first
    func refreshFetchData() {
        if(!feedList.isEmpty) {
            let feed = feedList[currentIndex]
            feed.configureFooterUI(data: "")
            
            feed.dataPaginateStatus = ""
            asyncFetchFeed(cell: feed, id: "notify_feed")
        }
    }
    
    //test > tab section UI Change (hardcoded - to be fixed in future)
    func reactToTabSectionChange(index: Int) {
        
        if(!self.tabList.isEmpty) {
            var i = 0
            for l in self.tabList {
                if(i == currentIndex) {
                    l.selectStack()
                } else {
                    l.unselectStack()
                }
                i += 1
            }
        }
    }
    
    func asyncFetchFeed(cell: ScrollFeedHNotifyListCell?, id: String) {

        cell?.vDataList.removeAll()
        cell?.vCV?.reloadData()

        cell?.aSpinner.startAnimating()
        cell?.bSpinner.stopAnimating()
        
        cell?.dataPaginateStatus = "fetch"

        let id_ = "post"
        let isPaginate = false
//        DataFetchManager.shared.fetchFeedData(id: id_, isPaginate: isPaginate) { [weak self]result in
        DataFetchManager.shared.fetchNotifyFeedData(id: id_, isPaginate: isPaginate) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("notifypanel api success \(id), \(l)")

                    guard let feed = cell else {
                        return
                    }
                    
                    //test
                    feed.aSpinner.stopAnimating()
                    
//                    feed.dataPaginateStatus = "fetch"
                    
                    //test 1
//                    feed.vDataList.append(contentsOf: l)
                    for i in l {
                        let notifyData = NotifyData()
                        notifyData.setData(rData: i)
                        feed.vDataList.append(notifyData)
                    }
                    
                    feed.vCV?.reloadData()

                    //*test 3 > reload only appended data, not entire dataset
//                    let dataCount = feed.vDataList.count
//                    var indexPaths = [IndexPath]()
//                    var j = 1
//                    for i in l {
//                        feed.vDataList.append(i)
//
//                        let idx = IndexPath(item: dataCount - 1 + j, section: 0)
//                        indexPaths.append(idx)
//                        j += 1
//
//                        print("ppv asyncfetch reload \(idx)")
//                    }
//                    feed.vCV?.insertItems(at: indexPaths)
                    //*
                    
                    //test
                    if(l.isEmpty) {
                        print("postpanelscroll footer reuse configure")
                        feed.setFooterAaText(text: "Nothing has been posted yet.")
                        feed.configureFooterUI(data: "na")
                    }
                }

                case .failure(let error):
                print("api fail")
                DispatchQueue.main.async {
                    cell?.aSpinner.stopAnimating()
                    
                    cell?.configureFooterUI(data: "e")
                }
                break
            }
        }
    }

    func asyncPaginateFetchFeed(cell: ScrollFeedHNotifyListCell?, id: String) {

        cell?.bSpinner.startAnimating()

        let id_ = "post"
        let isPaginate = true
//        DataFetchManager.shared.fetchFeedData(id: id_, isPaginate: isPaginate) { [weak self]result in
        DataFetchManager.shared.fetchNotifyFeedData(id: id_, isPaginate: isPaginate) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("notifypanel api paginate success \(id), \(l), \(l.isEmpty)")

                    guard let feed = cell else {
                        return
                    }
                    if(l.isEmpty) {
                        feed.dataPaginateStatus = "end"
                    }
                    //test
                    feed.bSpinner.stopAnimating()

                    //test 1
//                    feed.vDataList.append(contentsOf: l)
//                    feed.vCV?.reloadData()
                    
                    //*test 3 > reload only appended data, not entire dataset
                    let dataCount = feed.vDataList.count
                    var indexPaths = [IndexPath]()
                    var j = 1
                    for i in l {
//                        feed.vDataList.append(i)
                        
                        let notifyData = NotifyData()
                        notifyData.setData(rData: i)
                        feed.vDataList.append(notifyData)

                        let idx = IndexPath(item: dataCount - 1 + j, section: 0)
                        indexPaths.append(idx)
                        j += 1
                    }
                    feed.vCV?.insertItems(at: indexPaths)
                    //*

                    //test
                    if(l.isEmpty) {
                        feed.configureFooterUI(data: "end")
                    }
                }

                case .failure(let error):
                DispatchQueue.main.async {
                    print("api fail")
                    cell?.bSpinner.stopAnimating()
                    
                    cell?.configureFooterUI(data: "e")
                }
                break
            }
        }
    }
    
    func asyncFetchSigninStatus() {
        //test > simple get method
        let isSignedIn = SignInManager.shared.getStatus()
        if(self.isInitialized) {
            if(self.isUserLoggedIn != isSignedIn) {
                self.isUserLoggedIn = isSignedIn
                
                self.deconfigurePanel()
        
                self.isInitialized = false
                self.initialize()
            }
            //test > recheck UI for aLoggedOut
            else {
                if(self.isUserLoggedIn) {
                    self.aLoggedOutBox.isHidden = true
                } else {
                    self.aLoggedOutBox.isHidden = false
                }
            }
        } else {
            self.isUserLoggedIn = isSignedIn
            self.initialize()
        }
        
        //old method by fetching
//        SignInManager.shared.fetchStatus(id: "fetch_status") { [weak self]result in
//            switch result {
//                case .success(let l):
//
//                //update UI on main thread
//                DispatchQueue.main.async {
//                    print("notifypanelview api success: \(l)")
//                    guard let self = self else {
//                        return
//                    }
//                    
//                    let isSignedIn = l
//                    
//                    if(self.isInitialized) {
//                        if(self.isUserLoggedIn != isSignedIn) {
//                            self.isUserLoggedIn = isSignedIn
//                            
//                            self.deconfigurePanel()
//                    
//                            self.isInitialized = false
//                            self.initialize()
//                        }
//                        //test > recheck UI for aLoggedOut
//                        else {
//                            if(self.isUserLoggedIn) {
//                                self.aLoggedOutBox.isHidden = true
//                            } else {
//                                self.aLoggedOutBox.isHidden = false
//                            }
//                        }
//                    } else {
//                        self.isUserLoggedIn = isSignedIn
//                        self.initialize()
//                    }
//                }
//
//                case .failure(_):
//                    print("api fail")
//                    break
//            }
//        }
    }
}

extension NotifyPanelView: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //test 3 > new scrollview method
        if(scrollView == feedScrollView) {
            let xOffset = scrollView.contentOffset.x
            let viewWidth = self.frame.width
            let currentIndex = round(xOffset/viewWidth)
            
            //*tab select UI
            tempCurrentIndex = Int(currentIndex) //use tempcurrentindex as user will scroll fast cause problem
            let currentItemIndex = tempCurrentIndex
            var xWidth = 0.0
            var i = 0
            if(!self.tabList.isEmpty) {
                for l in self.tabList {
                    if(i == currentItemIndex) {
                        break
                    }
                    xWidth += l.frame.width
                    i += 1
                }
            }
            currentTabSelectLeadingCons = xWidth
        }
        //*
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView == feedScrollView) {
            let xOffset = scrollView.contentOffset.x
            let viewWidth = self.frame.width
            let currentIndex = round(xOffset/viewWidth)

            if(!self.tabList.isEmpty) {
                let currentItemIndex = tempCurrentIndex
                let currentX = notifyPanel.frame.width * CGFloat(currentItemIndex)
                let currentTabWidth = tabList[currentItemIndex].frame.width
                var hOffsetX = 0.0
                if(xOffset >= currentX) {
                    var nextTabWidth = tabList[currentItemIndex].frame.width
                    if(currentItemIndex < tabList.count - 1) {
                        nextTabWidth = tabList[currentItemIndex + 1].frame.width
                    }
                    hOffsetX = (xOffset - currentX)/(notifyPanel.frame.width) * currentTabWidth + currentTabSelectLeadingCons
                    tabSelectLeadingCons?.constant = hOffsetX

                    let hWidth = (xOffset - currentX)/(notifyPanel.frame.width) * (nextTabWidth - currentTabWidth) + currentTabWidth
                    tabSelectWidthCons?.constant = hWidth
                }
                else if (xOffset < currentX) {
                    var prevTabWidth = tabList[currentItemIndex].frame.width
                    if(currentItemIndex > 0) {
                        prevTabWidth = tabList[currentItemIndex - 1].frame.width
                    }

                    hOffsetX = (xOffset - currentX)/(notifyPanel.frame.width) * prevTabWidth + currentTabSelectLeadingCons
                    tabSelectLeadingCons?.constant = hOffsetX

                    let hWidth = (xOffset - currentX)/(notifyPanel.frame.width) * (currentTabWidth - prevTabWidth) + currentTabWidth
                    tabSelectWidthCons?.constant = hWidth
                }
                
                //test > tabscroll move along when feedscroll scroll to next tab
                if(self.tabList.count > 1) { //otherwise tabscroll cannot contentoffset
                    var oX = hOffsetX
                    if(hOffsetX > totalTabScrollXLead) {
                        oX = totalTabScrollXLead
                    }
                    if(totalTabScrollXLead > 0) {
                        let tabXContentOffset = oX/totalTabScrollXLead * tabScrollGap
                        tabScrollView.setContentOffset(CGPoint(x: tabXContentOffset, y: 0), animated: false)
                    }
                }
            }
            
            //test > async fetch feed
            let rIndex = Int(round(currentIndex))
            if(!self.feedList.isEmpty) {
                let feed = self.feedList[rIndex]
                if(feed.dataPaginateStatus == "") {
                    if(isUserLoggedIn) {
                        self.asyncFetchFeed(cell: feed, id: "notify_feed")
                    }
                }
            }
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if(scrollView == feedScrollView) {
            let xOffset = scrollView.contentOffset.x
            let viewWidth = self.frame.width
            print("notifypanel scroll decelerate \(xOffset), \(viewWidth)")
            
            currentIndex = Int(xOffset/viewWidth)

            reactToTabSectionChange(index: currentIndex)
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if(scrollView == feedScrollView) {
            let xOffset = scrollView.contentOffset.x
            let viewWidth = self.frame.width
            
            currentIndex = Int(xOffset/viewWidth)
            
            //test > change tab title font opacity when scrolled
            reactToTabSectionChange(index: currentIndex)
            
            //test > finalize current index tabselect margin and width
            var xWidth = 0.0
            var i = 0
            if(!self.tabList.isEmpty) {
                for l in self.tabList {
                    if(i == currentIndex) {
                        break
                    }
                    xWidth += l.frame.width
                    i += 1
                }
            }
            tabSelectLeadingCons?.constant = xWidth
            tabSelectWidthCons?.constant = tabList[currentIndex].frame.width
        }
    }
}

extension NotifyPanelView: ScrollFeedCellDelegate {
    func sfcWillBeginDragging(offsetY: CGFloat) {

    }
    func sfcScrollViewDidScroll(offsetY: CGFloat) {

    }
    func sfcSrollViewDidEndDecelerating(offsetY: CGFloat) {

    }
    func sfcScrollViewDidEndDragging(offsetY: CGFloat, decelerate: Bool) {

        if(offsetY < -80) {
            if(isUserLoggedIn) {
                self.refreshFetchData()
            }
        }
    }

    func sfcVCVPanBegan(offsetY: CGFloat, isScrollActive: Bool){

    }

    func sfcVCVPanChanged(offsetY: CGFloat, isScrollActive: Bool) {

    }

    func sfcVCVPanEnded(offsetY: CGFloat, isScrollActive: Bool) {

    }

    func sfcDidClickVcvRefresh(){
        refreshFetchData()
    }
    func sfcDidClickVcvComment() {
        print("fcDidClickVcvComment ")
    }
    func sfcDidClickVcvLove() {
        print("fcDidClickVcvLike ")
    }
    func sfcDidClickVcvShare(id: String, dataType: String) {
        print("fcDidClickVcvShare ")
    }

    func sfcDidClickVcvClickUser(id: String) {
        //test
        delegate?.didNotifyClickUser(id: id)
    }
    func sfcDidClickVcvClickPlace(id: String) {
        delegate?.didNotifyClickPlace(id: id)
    }
    func sfcDidClickVcvClickSound(id: String, pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String) {
//        delegate?.didNotifyClickSound(id: id)
    }
    func sfcDidClickVcvClickPost(id: String, dataType: String, pointX: CGFloat, pointY: CGFloat) {
//        openPostDetail()
    }
    func sfcDidClickVcvClickPhoto(id: String, pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String) {

    }
    func sfcDidClickVcvClickVideo(id: String, pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String) {

    }

    //test
    func sfcAsyncFetchFeed() {

    }
    func sfcAsyncPaginateFeed(cell: ScrollFeedCell?) {
        //test
        print("feedhresultlistcell real paginate async")
        if let d = cell as? ScrollFeedHNotifyListCell {
            if(isUserLoggedIn) {
                self.asyncPaginateFetchFeed(cell: d, id: "notify_feed_end")
            }
        }
    }
    
    func sfcIsScrollCarousel(isScroll: Bool) {
//        isCarouselScrolled = isScroll
    }
    
    func sfcAutoplayVideo(cell: ScrollFeedCell?, vCCell: UICollectionViewCell?) {
//    func sfcAutoplayVideo(cell: ScrollFeedCell?, vCCell: HPostListAViewCell?) {
        
    }
}

extension NotifyPanelView: TabStackDelegate {
    func didClickTabStack(tabCode: String, isSelected: Bool) {
        if let index = tabDataList.firstIndex(of: tabCode) {
            print("tabstack index clicked: \(index), \(tabCode)")
            if(currentIndex != index) {
                let xOffset = CGFloat(index) * viewWidth
                feedScrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
            }
            else {
                
            }
        } else {
            print("Element not found in the array")
        }
    }
}

//test
extension ViewController: NotifyPanelDelegate{

    func didNotifyClickUser(id: String) {
        //test
//        openUserPanel()
        //test > real id for fetching data
        openUserPanel(id: id)
    }
    func didNotifyClickPlace(id: String) {
//        openPlacePanel()
        //test > real id for fetching data
        openPlacePanel(id: id)
    }
    func didNotifyClickSound(id: String) {
//        openSoundPanel()
        //test > real id for fetching data
//        openSoundPanel(id: id)
    }
    func didNotifyClickLogin() {
        //test
        openLoginPanel()
    }
}
