//
//  ViewController.swift
//  YogaLayouts
//
//  Created by Mwai Banda on 9/1/22.
//

import UIKit
import YogaKit
import RxSwift
import RxCocoa
import ReSwift

enum TopMenuOption: String {
    case topNews = "Top News"
    case us = "US"
    case world = "World"
    case insideIsrael = "Inside Israel"
    case nationalSecurity = "National Security"
    case politics = "Politics"
    case entertainment = "Entertainment"
    case health = "Health"
}

class GodViewController: UIViewController {
    var isExpandedTabBar = BehaviorRelay<Bool>(value: false)
    var isExpandedTopBar = BehaviorRelay<Bool>(value: false)
    let bag = DisposeBag()
    var bottomContentColumn: UIView!
    var topMenu: UIView!
    var topTabBarArrow: UIImageView!
    var bottomTabBarArrow: UIImageView!
    var topCenterRow: UIView!
    var headerButton: UIButton!
    var topMenuOptions: [TopMenuOption] = [
        .topNews,
        .us,
        .world,
        .insideIsrael,
        .nationalSecurity,
        .politics,
        .entertainment,
        .health
    ]
    var tableViewContent = BehaviorRelay<[String]>(
        value: []
    )
    var header = BehaviorRelay<String>(
        value: TopMenuOption.topNews.rawValue.uppercased()
    )
    var tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let rootView = view else { return }
        setupUI(rootView: rootView)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.dataStore.subscribe(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.dataStore.dispatch(getData)

    }
    
    func setupUI(rootView: UIView) {
        rootView.backgroundColor = .white
        rootView.configureLayout { layout in
            layout.isEnabled = true
            layout.position = .absolute
            layout.top = 0
            layout.width = 100%
        }
        setupMainContent(rootView: rootView)
        setupTopTabBar(rootView: rootView)
        setupBottomTabBar(rootView: rootView)
    }
    
    private func setupTopTabBar(rootView: UIView) {
        let top = UIView()
        top.backgroundColor = .clear
        top.configureLayout { (layout) in
            layout.isEnabled = true
            layout.position = .absolute
            layout.top = 0
            layout.width = 100%
        }
        rootView.addSubview(top)
        
        
        topCenterRow = UIView()
        topCenterRow.backgroundColor = .darkGray
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didExpandTopBar))
        topCenterRow.addGestureRecognizer(tapGesture)
        topCenterRow.isUserInteractionEnabled = true
        topCenterRow.configureLayout { layout in
            layout.isEnabled = true
            layout.width = 100%
            layout.height = 80
            layout.paddingTop = 30
            layout.flexDirection = .row
            layout.justifyContent = .center
            layout.alignContent = .center
            
        }
        
        top.addSubview(topCenterRow)
        topMenu = UIView()
        topMenu.backgroundColor = .darkGray.withAlphaComponent(0.85)
        topMenu.configureLayout { layout in
            layout.isEnabled = true
            layout.width = 100%
            layout.flexDirection = .column
            layout.alignSelf = .center
            layout.justifyContent = .center
            
        }
        top.addSubview(topMenu)
        topMenu.yoga.isIncludedInLayout = isExpandedTopBar.value
        
        
        headerButton = UIButton()
        headerButton.titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        headerButton.addTarget(self, action: #selector(didExpandTopBar), for: .touchUpInside)
        headerButton.configureLayout { layout in
            layout.isEnabled = true
            layout.height = 50
        }
        
        
        topTabBarArrow = UIImageView()
        topTabBarArrow.image = UIImage(named: "chevron.down")
        
        
        topTabBarArrow.configureLayout { layout in
            layout.isEnabled = true
            layout.height = 5
            layout.width = 10
            layout.marginLeft = 10
            layout.top = 23
        }
        
        topCenterRow.addSubview(headerButton)
        topCenterRow.addSubview(topTabBarArrow)
        
        
        for i in 0..<topMenuOptions.count {
            let menuButton = UIButton()
            menuButton.addTarget(self, action: #selector(didTapOption(sender:)), for: .touchUpInside)
            menuButton.menuOptions = [topMenuOptions[i]]
            menuButton.tag = i
            menuButton.setAttributedTitle(NSAttributedString(string: topMenuOptions[i].rawValue, attributes: [.font: UIFont.systemFont(ofSize: 17, weight: .semibold)]), for: .normal)
            menuButton.configureLayout { layout in
                layout.isEnabled = true
                layout.paddingLeft = 20
                layout.height = 40
            }
            topMenu.addSubview(menuButton)
        }
        
        
        header.bind(to: headerButton.rx.title())
            .disposed(by: bag)
        isExpandedTopBar.map({ $0 ? 1 : 0 })
            .bind(to: topMenu.rx.alpha)
            .disposed(by: bag)
        
        addSpacers(for: topMenu)
        
        guard let firstOption = topMenu.subviews.first as? UIButton else { return }
        setSelectedMenuOptionColor(for: firstOption)
    }
    
    private func setupMainContent(rootView: UIView) {
        let contentbg = UIView()
        contentbg.backgroundColor = .gray.withAlphaComponent(0.25)
        contentbg.configureLayout { (layout) in
            layout.isEnabled = true
            layout.position = .absolute
            layout.width = 100%
            layout.height = 100%
            layout.marginVertical = 80
        }
        rootView.addSubview(contentbg)
        
        let content = UIView()
        content.backgroundColor = .clear
        content.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 100%
            layout.paddingHorizontal = 5
            layout.marginBottom = 90
            layout.flexGrow = 1
        }
        
        contentbg.addSubview(content)
        
        let banner = UIView()
        banner.backgroundColor = .clear
        banner.alpha = 0
        banner.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 100%
            layout.height = 0
            layout.alignItems = .center
            layout.justifyContent = .center
        }
        
        content.addSubview(banner)

        let bannerLabel = UILabel()
        bannerLabel.text = "banner"
        bannerLabel.configureLayout { layout in
            layout.isEnabled = true
            layout.height = 50
        }

        banner.addSubview(bannerLabel)
        tableview = {
            let tableView = UITableView()
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            tableView.backgroundColor = .clear
            tableView.showsVerticalScrollIndicator = false
            tableView.translatesAutoresizingMaskIntoConstraints = false
            return tableView
        }()
        tableview.configureLayout { layout in
            layout.isEnabled = true
            layout.width = 100%
            layout.flexGrow = 1
        }
        
        content.addSubview(tableview)
        
        tableViewContent.bind(
            to: tableview.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)
        ){ row, content, cell in
            cell.backgroundColor = .clear
            cell.textLabel?.textColor = .darkGray
            cell.textLabel?.text = content
            
        }.disposed(by: bag)
        
    }
    
    private func setupBottomTabBar(rootView: UIView) {
        let bottomTabBar = UIView()
        bottomTabBar.configureLayout { (layout) in
            layout.isEnabled = true
            layout.position = .absolute
            layout.bottom = 0
            layout.width = 100%
        }
        rootView.addSubview(bottomTabBar)
        
        let bottomContentCotainer = UIView()
        bottomContentCotainer.backgroundColor = .brown
        bottomContentCotainer.configureLayout { layout in
            layout.isEnabled = true
            layout.width = 100%
            layout.flexDirection = .column
            layout.alignContent = .center
            
        }
        
        bottomTabBar.addSubview(bottomContentCotainer)
        
        let bottomContentRow = UIView()
        bottomContentRow.backgroundColor = .lightBlue
        bottomContentRow.configureLayout { layout in
            layout.isEnabled = true
            layout.width = 100%
            layout.flexDirection = .row
            layout.alignContent = .center
            layout.justifyContent = .spaceBetween
            
            layout.height = 60
            
        }
        bottomContentCotainer.addSubview(bottomContentRow)
        
        let newsFeedButton = UIButton()
        newsFeedButton.setTitle("News Feed".uppercased(), for: .normal)
        newsFeedButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        newsFeedButton.configureLayout { layout in
            layout.isEnabled = true
            layout.width = 33%
            layout.height = 55
            layout.alignSelf = .center
        }
        
        bottomContentRow.addSubview(newsFeedButton)
        
        let centerRow = UIView()
        centerRow.layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
        centerRow.layer.shadowOpacity = 0.85
        centerRow.layer.shadowRadius = 10.0
        centerRow.backgroundColor = .lightBlue
        centerRow.layer.cornerRadius = 2
        let centerRowTapGesture = UITapGestureRecognizer(target: self, action: #selector(didExpandTabBar))
        centerRow.addGestureRecognizer(centerRowTapGesture)
        centerRow.isUserInteractionEnabled = true
        centerRow.configureLayout { layout in
            layout.isEnabled = true
            layout.width = 28%
            layout.height = 50
            layout.top = -10
            layout.flexDirection = .column
            layout.alignContent = .center
            layout.justifyContent = .center
        }
        
        bottomContentRow.addSubview(centerRow)
        
        let optionsButton = UILabel()
        optionsButton.text = "Options".uppercased()
        optionsButton.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        optionsButton.configureLayout { layout in
            layout.isEnabled = true
            layout.paddingTop = 10
            layout.alignSelf = .center
        }
        
        bottomTabBarArrow = UIImageView()
        bottomTabBarArrow.image = UIImage(named: "chevron.up")
        
        
        bottomTabBarArrow.configureLayout { layout in
            layout.isEnabled = true
            layout.marginLeft = 10
            layout.height = 10
            layout.width = 15
            layout.alignSelf = .center
            
        }
        centerRow.addSubview(bottomTabBarArrow)
        centerRow.addSubview(optionsButton)
        
        
        
        let watchButton = UIButton()
        watchButton.setTitle("Watch".uppercased(), for: .normal)
        watchButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        watchButton.configureLayout { layout in
            layout.isEnabled = true
            layout.width = 33%
            layout.height = 55
            layout.alignSelf = .center
        }
        
        bottomContentRow.addSubview(watchButton)
        
        bottomContentColumn = UIView()
        bottomContentColumn.backgroundColor = .lightBlue
        bottomContentColumn.tag = 100
        bottomContentColumn.configureLayout { layout in
            layout.isEnabled = true
            layout.width = 100%
            layout.flexDirection = .column
            layout.paddingVertical = 20
            
        }
        bottomContentColumn.yoga.isIncludedInLayout = isExpandedTabBar.value
        bottomContentCotainer.addSubview(bottomContentColumn)
        
        let loginButton = UIButton()
        loginButton.setTitle("Login", for: .normal)
        loginButton.configureLayout { layout in
            layout.isEnabled = true
            layout.left = 0
            layout.height = 35
            layout.paddingLeft = 20
            layout.alignSelf = .flexStart
        }
        
        bottomContentColumn.addSubview(loginButton)
        
        let contactButton = UIButton()
        contactButton.setTitle("Contact", for: .normal)
        contactButton.configureLayout { layout in
            layout.isEnabled = true
            layout.left = 0
            layout.height = 35
            layout.paddingLeft = 20
            layout.alignSelf = .flexStart
        }
        bottomContentColumn.addSubview(contactButton)
        
        let supportButton = UIButton()
        supportButton.setTitle("Support", for: .normal)
        supportButton.configureLayout { layout in
            layout.isEnabled = true
            layout.left = 0
            layout.height = 35
            layout.paddingLeft = 20
            layout.alignSelf = .flexStart
        }
        
        bottomContentColumn.addSubview(supportButton)
        
        let settingsButton = UIButton()
        settingsButton.setTitle("Settings", for: .normal)
        settingsButton.configureLayout { layout in
            layout.isEnabled = true
            layout.left = 0
            layout.height = 35
            layout.paddingLeft = 20
            layout.alignSelf = .flexStart
        }
        
        bottomContentColumn.addSubview(settingsButton)
        
        let showBannerButton = UIButton()
        showBannerButton.setTitle("Show Banner", for: .normal)
        showBannerButton.configureLayout { layout in
            layout.isEnabled = true
            layout.left = 0
            layout.height = 35
            layout.paddingLeft = 20
            layout.alignSelf = .flexStart
        }
        
        bottomContentColumn.addSubview(showBannerButton)
        
        addSpacers(for: bottomContentColumn)
        
        isExpandedTabBar.map({ $0 ? 1 : 0 }).bind(to: bottomContentColumn.rx.alpha).disposed(by: bag)
        rootView.yoga.applyLayout(preservingOrigin: true)
    }
    
    
    private func addSpacers(for view: UIView) {
        view.subviews.forEach { subView in
            let spacer = UIView()
            spacer.backgroundColor = UIColor.white.withAlphaComponent(0.25)
            spacer.configureLayout(block: { (layout) in
                layout.isEnabled = true
                layout.height = 1
            })
            if subView != view.subviews.last {
                view.insertSubview(spacer, aboveSubview: subView)
            }
        }
    }
    
    @objc private func didTapOption(sender: Any) {
        guard let option = sender as? UIButton else { return }
        topMenu.yoga.isIncludedInLayout = false

        switch option.menuOptions[option.tag] {
        case .topNews:
            header.accept(TopMenuOption.topNews.rawValue.uppercased())
        case .us:
            header.accept(TopMenuOption.us.rawValue.uppercased())
        case .world:
            header.accept(TopMenuOption.world.rawValue.uppercased())
        case .insideIsrael:
            header.accept(TopMenuOption.insideIsrael.rawValue.uppercased())
        case .nationalSecurity:
            header.accept(TopMenuOption.nationalSecurity.rawValue.uppercased())
        case .politics:
            header.accept(TopMenuOption.politics.rawValue.uppercased())
        case .entertainment:
            header.accept(TopMenuOption.entertainment.rawValue.uppercased())
        case .health:
            header.accept(TopMenuOption.health.rawValue.uppercased())
        }
        topTabBarArrow.image = UIImage(named: "chevron.down")
        
        didExpandTopBar()
        setSelectedMenuOptionColor(for: option)

        headerButton.yoga.markDirty()
        self.view.yoga.applyLayout(preservingOrigin: true)
    }
    
    
    private func setSelectedMenuOptionColor(for option: UIButton) {
        topMenu.subviews.forEach { view in
            guard let button = view as? UIButton else { return }
            if option.attributedTitle(for: .normal) == button.attributedTitle(for: .normal) {
                button.setTitleColor(.systemBlue, for: .normal)
            } else {
                button.setTitleColor(.white, for: .normal)
            }
        }
    }
    
    @objc private func didExpandTabBar() {
        isExpandedTabBar.accept(!isExpandedTabBar.value)
        
        if isExpandedTabBar.value {
            bottomContentColumn.yoga.isIncludedInLayout = true
            bottomTabBarArrow.image = UIImage(named: "chevron.down")
            
        } else {
            bottomContentColumn.yoga.isIncludedInLayout = false
            bottomTabBarArrow.image = UIImage(named: "chevron.up")
        }
        self.view.yoga.applyLayout(preservingOrigin: true)
        
        print(isExpandedTabBar.value)
    }
    
    @objc private func didExpandTopBar() {
        isExpandedTopBar.accept(!isExpandedTopBar.value)
        
        if isExpandedTopBar.value {
            topMenu.yoga.isIncludedInLayout = true
            topTabBarArrow.image = UIImage(named: "chevron.up")
            
        } else {
            topMenu.yoga.isIncludedInLayout = false
            topTabBarArrow.image = UIImage(named: "chevron.down")
        }
        self.view.yoga.applyLayout(preservingOrigin: true)
        
        print(isExpandedTopBar.value)
    }
}


extension GodViewController: StoreSubscriber {
    typealias StoreSubscriberStateType = AppState
    
    func newState(state: AppState) {
        print(state.tableContent)
        tableViewContent.accept(state.tableContent)
    }
    
    
}
