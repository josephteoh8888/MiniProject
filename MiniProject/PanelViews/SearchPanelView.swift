//
//  SearchPanelView.swift
//  MiniProject
//
//  Created by Joseph Teoh on 30/06/2024.
//

import Foundation
import UIKit
import SDWebImage

//test > new multi feed cells
protocol SearchPanelDelegate : AnyObject {

    //test > connect to other panel
    func didSearchClickUser()
    func didSearchClickPlace()
    func didSearchClickSound()
}
class SearchPanelView: PanelView{

    var searchPanel = UIView()
    let bTextField = UITextField()
    let aTextBox = UIView()
    let bTextBox = UIView()

//    var vDataList = [String]()

    weak var delegate : SearchPanelDelegate?

//    var vCV : UICollectionView?
    var isScrollViewAtTop = true
    var scrollViewInitialY : CGFloat = 0.0
    let aSpinner = SpinLoader()
    let bSpinner = SpinLoader()
    let footerView = UIView()
    let aaText = UILabel()
    var dataFetchState = ""

    let aStickyHeader = UIView()
    let bbText = UILabel()

    //test > tab
    var tabDataList = [String]()
//    var tabList = [UIView]()
    var tabList = [TabStack]()
    let tabSelect = UIView()
    var tabSelectLeadingCons: NSLayoutConstraint?
    var tabSelectWidthCons: NSLayoutConstraint?
    var stackviewUsableLength = 0.0
    let tabScrollView = UIScrollView()
    let stackView = UIView()
    var currentIndexPath = IndexPath(item: 0, section: 0)

    var currentTabSelectLeadingCons = 0.0
    var tempCurrentIndex = 0

    let feedScrollView = UIScrollView()
    var feedList = [ScrollFeedHResultListCell]()
//    var feedList = [ScrollFeedCell]()
    var currentIndex = 0
    
    var viewHeight: CGFloat = 0
    var viewWidth: CGFloat = 0

    //test > user login/out status
    var isUserLoggedIn = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()

    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupViews()
    }

    func setupViews() {

        searchPanel.backgroundColor = .ddmBlackOverlayColor
        self.addSubview(searchPanel)
        searchPanel.translatesAutoresizingMaskIntoConstraints = false
        searchPanel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        searchPanel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true //default 0
        searchPanel.layer.masksToBounds = true
        searchPanel.layer.cornerRadius = 10 //10
        searchPanel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        searchPanel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true

//        let aTextBox = UIView()
        searchPanel.addSubview(aTextBox)
        aTextBox.translatesAutoresizingMaskIntoConstraints = false
        aTextBox.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        aTextBox.leadingAnchor.constraint(equalTo: searchPanel.leadingAnchor, constant: 15).isActive = true //15
        aTextBox.trailingAnchor.constraint(equalTo: searchPanel.trailingAnchor, constant: -15).isActive = true
        aTextBox.heightAnchor.constraint(equalToConstant: 40).isActive = true
        aTextBox.backgroundColor = .ddmDarkColor
        aTextBox.layer.cornerRadius = 10
        aTextBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onOpenTextBoxClicked)))

        let aTextSearch = UIImageView()
        aTextSearch.image = UIImage(named:"icon_round_search")?.withRenderingMode(.alwaysTemplate)
        aTextSearch.tintColor = .white
        aTextBox.addSubview(aTextSearch)
        aTextSearch.translatesAutoresizingMaskIntoConstraints = false
        aTextSearch.leadingAnchor.constraint(equalTo: aTextBox.leadingAnchor, constant: 10).isActive = true
        aTextSearch.centerYAnchor.constraint(equalTo: aTextBox.centerYAnchor).isActive = true
        aTextSearch.heightAnchor.constraint(equalToConstant: 26).isActive = true //ori 30
        aTextSearch.widthAnchor.constraint(equalToConstant: 26).isActive = true
        aTextSearch.layer.opacity = 0.5

        let aSearchPlaceholderText = UILabel()
        aSearchPlaceholderText.textAlignment = .left
        aSearchPlaceholderText.textColor = .white
        aSearchPlaceholderText.font = .systemFont(ofSize: 13)
        aTextBox.addSubview(aSearchPlaceholderText)
        aSearchPlaceholderText.translatesAutoresizingMaskIntoConstraints = false
        aSearchPlaceholderText.leadingAnchor.constraint(equalTo: aTextSearch.trailingAnchor, constant: 10).isActive = true
        aSearchPlaceholderText.trailingAnchor.constraint(equalTo: aTextBox.trailingAnchor, constant: -20).isActive = true
        aSearchPlaceholderText.centerYAnchor.constraint(equalTo: aTextBox.centerYAnchor, constant: 0).isActive = true
        aSearchPlaceholderText.text = "Search..."
        aSearchPlaceholderText.layer.opacity = 0.5

        //real text field
//        let bTextBox = UIView()
        searchPanel.addSubview(bTextBox)
        bTextBox.translatesAutoresizingMaskIntoConstraints = false
        bTextBox.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        bTextBox.leadingAnchor.constraint(equalTo: searchPanel.leadingAnchor, constant: 15).isActive = true
        bTextBox.trailingAnchor.constraint(equalTo: searchPanel.trailingAnchor, constant: -15).isActive = true
        bTextBox.heightAnchor.constraint(equalToConstant: 40).isActive = true
        bTextBox.backgroundColor = .ddmDarkColor
        bTextBox.layer.cornerRadius = 10
        bTextBox.isHidden = true

        let bTextSearch = UIImageView()
        bTextSearch.image = UIImage(named:"icon_round_search")?.withRenderingMode(.alwaysTemplate)
        bTextSearch.tintColor = .white
        bTextBox.addSubview(bTextSearch)
        bTextSearch.translatesAutoresizingMaskIntoConstraints = false
        bTextSearch.leadingAnchor.constraint(equalTo: bTextBox.leadingAnchor, constant: 10).isActive = true
        bTextSearch.centerYAnchor.constraint(equalTo: bTextBox.centerYAnchor).isActive = true
        bTextSearch.heightAnchor.constraint(equalToConstant: 26).isActive = true //ori 30
        bTextSearch.widthAnchor.constraint(equalToConstant: 26).isActive = true
        bTextSearch.layer.opacity = 0.5

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
        bTextField.placeholder = "Search..."

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
//        bbText.text = "Search Elon Musk..."
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

        //test > try uicollectionview
//        tabDataList.append("a")
        tabDataList.append("u")
        tabDataList.append("v")
        tabDataList.append("i")
        tabDataList.append("p")
        tabDataList.append("l")
        tabDataList.append("s")
        tabDataList.append("h")

        //test > add sections tab
//        stackviewUsableLength = viewWidth - 20*2 //2 sides of 20.0 margin
//        stackviewUsableLength = viewWidth - 70*2 //2 sides of 20.0 margin
//        let hWidth = (stackviewUsableLength)/(CGFloat(vcDataList.count))
        let hWidth = 80.0

        //test ** > uiscrollview
//        let tabScrollView = UIScrollView()
//        postPanel.addSubview(tabScrollView)
        searchPanel.addSubview(tabScrollView)
        tabScrollView.backgroundColor = .clear //clear
        tabScrollView.translatesAutoresizingMaskIntoConstraints = false
        tabScrollView.heightAnchor.constraint(equalToConstant: 40).isActive = true //ori 60
//        tabScrollView.topAnchor.constraint(equalTo: aStickyHeader.bottomAnchor, constant: 0).isActive = true
        tabScrollView.topAnchor.constraint(equalTo: aTextBox.bottomAnchor, constant: 0).isActive = true
//        tabScrollView.centerYAnchor.constraint(equalTo: aBtn.centerYAnchor, constant: 0).isActive = true
        tabScrollView.leadingAnchor.constraint(equalTo: searchPanel.leadingAnchor, constant: 0).isActive = true //20
        tabScrollView.trailingAnchor.constraint(equalTo: searchPanel.trailingAnchor, constant: 0).isActive = true
        tabScrollView.showsHorizontalScrollIndicator = false
        tabScrollView.alwaysBounceHorizontal = true //test
        //**

        stackView.backgroundColor = .clear //clear
        tabScrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.heightAnchor.constraint(equalToConstant: 40).isActive = true //ori 30
        stackView.topAnchor.constraint(equalTo: tabScrollView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: tabScrollView.leadingAnchor, constant: 0).isActive = true //10
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
        aHighlightInner.widthAnchor.constraint(equalToConstant: 20).isActive = true //30
        aHighlightInner.centerYAnchor.constraint(equalTo: tabSelect.centerYAnchor).isActive = true
        aHighlightInner.centerXAnchor.constraint(equalTo: tabSelect.centerXAnchor).isActive = true

        searchPanel.addSubview(feedScrollView)
        feedScrollView.backgroundColor = .clear //clear
        feedScrollView.translatesAutoresizingMaskIntoConstraints = false
        feedScrollView.topAnchor.constraint(equalTo: tabScrollView.bottomAnchor, constant: 10).isActive = true
        feedScrollView.bottomAnchor.constraint(equalTo: searchPanel.bottomAnchor, constant: 0).isActive = true
        feedScrollView.leadingAnchor.constraint(equalTo: searchPanel.leadingAnchor, constant: 0).isActive = true
        feedScrollView.trailingAnchor.constraint(equalTo: searchPanel.trailingAnchor, constant: 0).isActive = true
        feedScrollView.showsHorizontalScrollIndicator = false
        feedScrollView.alwaysBounceHorizontal = true //test
        feedScrollView.isPagingEnabled = true
        feedScrollView.delegate = self
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
                let tabWidth = (viewWidth)/CGFloat(tabCount)
                stack.widthAnchor.constraint(equalToConstant: tabWidth).isActive = true
                isTabWidthFixed = true
            }
            stack.setTabTextMargin(isTabWidthFixed: isTabWidthFixed, margin: 20.0) //default: 26
            stack.setTabTypeSmall(isSmall: true)
            stack.setUIChange(isChange: false)
            stack.setArrowAdded(isArrowAdd: false)
            stack.delegate = self

            if(d == "a") {
                stack.setText(code: d, d: "All")
            } else if(d == "v") {
                stack.setText(code: d, d: "Videos")
            } else if(d == "p") {
                stack.setText(code: d, d: "Posts")
            } else if(d == "i") {
                stack.setText(code: d, d: "Shots")
            } else if(d == "u") {
                stack.setText(code: d, d: "Users")
            } else if(d == "l") {
                stack.setText(code: d, d: "Locations")
            } else if(d == "s") {
                stack.setText(code: d, d: "Sounds")
            } else if(d == "h") {
                stack.setText(code: d, d: "Hashtags")
            }
        }
    }

    func redrawUI() {
        let viewWidth = self.frame.width
        let feedHeight = feedScrollView.frame.height
        for d in tabDataList {

            var stackFeed: ScrollFeedHResultListCell?
            
            if(d == "u") {
                stackFeed = ScrollFeedHResultUserListCell()
            } else if(d == "v") {
                stackFeed = ScrollFeedHResultVideoListCell()
            } else if(d == "i") {
                stackFeed = ScrollFeedHResultPhotoListCell()
            } else if(d == "p") {
                stackFeed = ScrollFeedHResultPostListCell()
            }  else if(d == "l") {
                stackFeed = ScrollFeedHResultLocationListCell()
            } else if(d == "s") {
                stackFeed = ScrollFeedHResultSoundListCell()
            } else if(d == "h") {
                stackFeed = ScrollFeedHResultHashtagListCell()
            } else {
                stackFeed = ScrollFeedHResultMainListCell()
            }
            guard let stackFeed = stackFeed else {
                return
            }
            feedScrollView.addSubview(stackFeed)
            stackFeed.translatesAutoresizingMaskIntoConstraints = false
            if(feedList.isEmpty) {
                stackFeed.leadingAnchor.constraint(equalTo: feedScrollView.leadingAnchor, constant: 0).isActive = true //20
            } else {
                let lastArrayE = feedList[feedList.count - 1]
                stackFeed.leadingAnchor.constraint(equalTo: lastArrayE.trailingAnchor, constant: 0).isActive = true
            }
            stackFeed.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
            stackFeed.heightAnchor.constraint(equalToConstant: feedHeight).isActive = true
            feedList.append(stackFeed)

            stackFeed.initialize()
            stackFeed.aDelegate = self
            
            //test > set code
            stackFeed.setCode(code: d)
        }

        let tabCount = tabDataList.count
        feedScrollView.contentSize = CGSize(width: viewWidth * CGFloat(tabCount), height: feedHeight)
        print("searchpanel contentsize \(viewWidth * CGFloat(tabCount)), \(feedHeight)")
    }

    @objc func onOpenTextBoxClicked(gesture: UITapGestureRecognizer) {
        setFirstResponder(textField: bTextField)
    }

    @objc func onCloseTextBoxClicked(gesture: UITapGestureRecognizer) {
        resignResponder()
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

    @objc func onAPhotoClicked(gesture: UITapGestureRecognizer) {
        delegate?.didSearchClickPlace()
    }
    @objc func onBPhotoClicked(gesture: UITapGestureRecognizer) {
        delegate?.didSearchClickUser()
    }
    @objc func onCPhotoClicked(gesture: UITapGestureRecognizer) {
        delegate?.didSearchClickSound()
    }
    
    //test
    override func resumeActiveState() {
        print("searchpanelview resume active")
        
        //test > check for signin status when in active state
        asyncFetchSigninStatus()
    }

    //test > initialization state
    var isInitialized = false
    func initialize() {

        if(!isInitialized) {

            //redraw UI
            layoutTabUI()

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
    
    //test > set up search UI
    func asyncInit(id: String) {
        DataFetchManager.shared.fetchData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("searchpanel api success \(id), \(l)")

                    guard let self = self else {
                        return
                    }

                    //test > tab select
                    if(!self.tabList.isEmpty) {
                        for l in self.tabList {
                            self.stackviewUsableLength += l.frame.width
                        }
//                        self.stackviewUsableLength += 10.0 //leading constraint on tabscrollview
                        self.tabScrollView.contentSize = CGSize(width: self.stackviewUsableLength, height: 40)

                        let tab = self.tabList[0]
                        self.tabSelectWidthCons?.constant = tab.frame.width
                        self.tabSelect.isHidden = false
                    }
                    
                    self.measureTabScroll()
                    
                    //test > for feed scroll
                    self.redrawUI()

                    //test > async fetch feed
                    let feed = self.feedList[self.currentIndex]
//                    if(self.isUserLoggedIn) {
                        self.asyncFetchFeed(cell: feed, id: "search_feed")
//                    }
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
        let feed = feedList[currentIndex]
        feed.dataPaginateStatus = ""
        asyncFetchFeed(cell: feed, id: "search_feed")
    }

//    func asyncFetchFeed(cell: ScrollFeedCell?, id: String) {
    func asyncFetchFeed(cell: ScrollFeedHResultListCell?, id: String) {

        cell?.vDataList.removeAll()
        cell?.vCV?.reloadData()

        cell?.aSpinner.startAnimating()
        cell?.bSpinner.stopAnimating()

        cell?.dataPaginateStatus = "fetch"

        DataFetchManager.shared.fetchData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("searchpanel api success \(id), \(l)")

                    guard let self = self else {
                        return
                    }

                    guard let feed = cell else {
                        return
                    }

                    //test 1
                    feed.vDataList.append(contentsOf: l)
                    feed.vCV?.reloadData()

                    //test
                    feed.aSpinner.stopAnimating()
                }

                case .failure(_):
                    print("api fail")
                    break
            }
        }
    }

//    func asyncPaginateFetchFeed(cell: ScrollFeedCell?, id: String) {
    func asyncPaginateFetchFeed(cell: ScrollFeedHResultListCell?, id: String) {

        cell?.bSpinner.startAnimating()

        DataFetchManager.shared.fetchData(id: id) { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("searchpanel api paginate success \(id), \(l), \(l.isEmpty)")

                    guard let self = self else {
                        return
                    }

                    guard let feed = cell else {
                        return
                    }
                    if(l.isEmpty) {
                        feed.dataPaginateStatus = "end"
                    }

                    //test 1
//                    feed.vDataList.append(contentsOf: l)
//                    feed.vCV?.reloadData()
                    
                    //*test 3 > reload only appended data, not entire dataset
                    let dataCount = feed.vDataList.count
                    var indexPaths = [IndexPath]()
                    var j = 1
                    for i in l {
                        feed.vDataList.append(i)

                        let idx = IndexPath(item: dataCount - 1 + j, section: 0)
                        indexPaths.append(idx)
                        j += 1
                    }
                    feed.vCV?.insertItems(at: indexPaths)
                    //*

                    //test
                    feed.bSpinner.stopAnimating()
                }

                case .failure(_):
                    print("api fail")
                    break
            }
        }
    }
    
    func asyncFetchSigninStatus() {
        SignInManager.shared.fetchStatus(id: "fetch_status") { [weak self]result in
            switch result {
                case .success(let l):

                //update UI on main thread
                DispatchQueue.main.async {
                    print("notifypanelview api success: \(l)")
                    guard let self = self else {
                        return
                    }
                    
                    let isSignedIn = l
                    
                    if(self.isInitialized) {
                        if(self.isUserLoggedIn != isSignedIn) {
                            self.isUserLoggedIn = isSignedIn
                            
                            self.deconfigurePanel()
                    
                            self.isInitialized = false
                            self.initialize()
                        }
                    } else {
                        self.isUserLoggedIn = isSignedIn
                        self.initialize()
                    }
                }

                case .failure(_):
                    print("api fail")
                    break
            }
        }
    }
}

extension SearchPanelView: UIScrollViewDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //test 3 > new scrollview method
        if(scrollView == feedScrollView) {
            let xOffset = scrollView.contentOffset.x
            let viewWidth = self.frame.width
            let currentIndex = round(xOffset/viewWidth)
            print("searchpanel scroll begin \(xOffset), \(viewWidth), \(currentIndex)")
            
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
        //test 3 > new scrollview method
        if(scrollView == feedScrollView) {
            let xOffset = scrollView.contentOffset.x
            let viewWidth = self.frame.width
            let currentIndex = round(xOffset/viewWidth)

            if(!self.tabList.isEmpty) {
                let currentItemIndex = tempCurrentIndex
                let currentX = searchPanel.frame.width * CGFloat(currentItemIndex)
                let currentTabWidth = tabList[currentItemIndex].frame.width
                var hOffsetX = 0.0
                if(xOffset >= currentX) {
                    var nextTabWidth = tabList[currentItemIndex].frame.width
                    if(currentItemIndex < tabList.count - 1) {
                        nextTabWidth = tabList[currentItemIndex + 1].frame.width
                    }
                    hOffsetX = (xOffset - currentX)/(searchPanel.frame.width) * currentTabWidth + currentTabSelectLeadingCons
                    tabSelectLeadingCons?.constant = hOffsetX

                    let hWidth = (xOffset - currentX)/(searchPanel.frame.width) * (nextTabWidth - currentTabWidth) + currentTabWidth
                    tabSelectWidthCons?.constant = hWidth
                }
                else if (xOffset < currentX) {
                    var prevTabWidth = tabList[currentItemIndex].frame.width
                    if(currentItemIndex > 0) {
                        prevTabWidth = tabList[currentItemIndex - 1].frame.width
                    }

                    hOffsetX = (xOffset - currentX)/(searchPanel.frame.width) * prevTabWidth + currentTabSelectLeadingCons
                    tabSelectLeadingCons?.constant = hOffsetX

                    let hWidth = (xOffset - currentX)/(searchPanel.frame.width) * (currentTabWidth - prevTabWidth) + currentTabWidth
                    tabSelectWidthCons?.constant = hWidth
                }
                
                //test > tabscroll move along when feedscroll scroll to next tab
                if(self.tabList.count > 1) { //otherwise tabscroll cannot contentoffset
                    var oX = hOffsetX
                    if(hOffsetX > totalTabScrollXLead) {
                        oX = totalTabScrollXLead
                    }
                    let tabXContentOffset = oX/totalTabScrollXLead * tabScrollGap
                    tabScrollView.setContentOffset(CGPoint(x: tabXContentOffset, y: 0), animated: false)
                }
            }
            
            //test > async fetch feed
            let rIndex = Int(currentIndex)
            let feed = self.feedList[rIndex]
            if(feed.dataPaginateStatus == "") {
                self.asyncFetchFeed(cell: feed, id: "search_feed")
            }
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if(scrollView == feedScrollView) {
            let xOffset = scrollView.contentOffset.x
            let viewWidth = self.frame.width
            print("searchpanel scroll decelerate \(xOffset), \(viewWidth)")
            
            currentIndex = Int(xOffset/viewWidth)
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
//            reactToTabSectionChange(index: currentIndex)
            
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

extension SearchPanelView: ScrollFeedCellDelegate {
    func sfcWillBeginDragging(offsetY: CGFloat) {

    }
    func sfcScrollViewDidScroll(offsetY: CGFloat) {

    }
    func sfcSrollViewDidEndDecelerating(offsetY: CGFloat) {

    }
    func sfcScrollViewDidEndDragging(offsetY: CGFloat, decelerate: Bool) {

        if(offsetY < -80) {
            self.refreshFetchData()
        }
    }

    func sfcVCVPanBegan(offsetY: CGFloat, isScrollActive: Bool){

    }

    func sfcVCVPanChanged(offsetY: CGFloat, isScrollActive: Bool) {

    }

    func sfcVCVPanEnded(offsetY: CGFloat, isScrollActive: Bool) {

    }

    func sfcDidClickVcvItem(pointX: CGFloat, pointY: CGFloat, view:UIView, itemIndex:IndexPath){

    }
    func sfcDidClickVcvComment() {
        print("fcDidClickVcvComment ")
    }
    func sfcDidClickVcvLove() {
        print("fcDidClickVcvLike ")
    }
    func sfcDidClickVcvShare() {
        print("fcDidClickVcvShare ")
    }

    func sfcDidClickVcvClickUser() {
        //test
        delegate?.didSearchClickUser()
    }
    func sfcDidClickVcvClickPlace() {
//        delegate?.didClickPostPanelVcvClickPlace()
    }
    func sfcDidClickVcvClickSound() {

    }
    func sfcDidClickVcvClickPost() {
//        openPostDetail()
    }
    func sfcDidClickVcvClickPhoto(pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String) {

    }
    func sfcDidClickVcvClickVideo(pointX: CGFloat, pointY: CGFloat, view:UIView, mode: String) {

    }

    //test
    func sfcAsyncFetchFeed() {

    }
    func sfcAsyncPaginateFeed(cell: ScrollFeedCell?) {
        //test
        print("feedhresultlistcell real paginate async")

        if let d = cell as? ScrollFeedHResultListCell {
            self.asyncPaginateFetchFeed(cell: d, id: "search_feed_end")
        }
        
//        if let d = cell {
//            self.asyncPaginateFetchFeed(cell: d, id: "search_feed_end")
//        }
    }

    func sfcIsScrollCarousel(isScroll: Bool) {
//        isCarouselScrolled = isScroll
    }
    
    func sfcAutoplayVideo(cell: ScrollFeedCell?, vCCell: UICollectionViewCell?) {
//    func sfcAutoplayVideo(cell: ScrollFeedCell?, vCCell: HPostListAViewCell?) {
        
    }
}

//test
extension ViewController: SearchPanelDelegate{

    func didSearchClickUser() {
        //test
        openUserPanel()
        
//        openPostDetailPanel()
    }
    func didSearchClickPlace() {
        openPlacePanel()
    }
    func didSearchClickSound() {
        //test
        openSoundPanel()
    }
}

extension SearchPanelView: TabStackDelegate {
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

extension SearchPanelView: UITextFieldDelegate {
//    func textView(_ textView: UITextView, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let maxLength = 20
//        let currentString: NSString = (textView.text ?? "") as NSString
//        let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
//
//        return newString.length <= maxLength
//    }

    //test > for "Return" key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if(textField == bTextField) {
            print("textfielddelegate return: ")
            resignResponder()
        }

        return true
    }

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
