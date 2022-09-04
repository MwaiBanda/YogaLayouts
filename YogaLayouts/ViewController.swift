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

class ViewController: UIViewController {
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
    var header = BehaviorRelay<String>(value: TopMenuOption.topNews.rawValue.uppercased())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let rootView = view else {
            return
        }
        setupUI(rootView: rootView)
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
    
    func setupTopTabBar(rootView: UIView) {
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
            menuButton.setTitle(topMenuOptions[i].rawValue, for: .normal)
            menuButton.addTarget(self, action: #selector(didTapOption(sender:)), for: .touchUpInside)
            menuButton.menuOptions = [topMenuOptions[i]]
            menuButton.tag = i
            menuButton.configureLayout { layout in
                layout.isEnabled = true
                layout.paddingLeft = 20
                layout.height = 40
            }
            topMenu.addSubview(menuButton)
        }
        
        
        header.bind(to: headerButton.rx.title()).disposed(by: bag)
        addSpacers(for: topMenu)
        isExpandedTopBar.map({ $0 ? 1 : 0 }).bind(to: topMenu.rx.alpha).disposed(by: bag)

        
    }
    func setupMainContent(rootView: UIView) {
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
            layout.flexGrow = 1
        }
        
        contentbg.addSubview(content)
        
        let Header = UILabel()
        Header.text = "Content"
        Header.backgroundColor = .orange
        Header.configureLayout { layout in
            layout.isEnabled = true
            layout.height = 50
            layout.width = 100
        }
        content.addSubview(Header)
    }
    
    func setupBottomTabBar(rootView: UIView) {
        let bottom = UIView()
        bottom.backgroundColor = .orange
        bottom.configureLayout { (layout) in
            layout.isEnabled = true
            layout.position = .absolute
            layout.bottom = 0
            layout.width = 100%
        }
        rootView.addSubview(bottom)
        
        let bottomContentCotainer = UIView()
        bottomContentCotainer.backgroundColor = .brown
        bottomContentCotainer.configureLayout { layout in
            layout.isEnabled = true
            layout.width = 100%
            layout.flexDirection = .column
            layout.alignContent = .center
            
        }
        
        bottom.addSubview(bottomContentCotainer)
        
        let bottomContentRow = UIView()
        bottomContentRow.backgroundColor = .blue
        bottomContentRow.configureLayout { layout in
            layout.isEnabled = true
            layout.width = 100%
            layout.flexDirection = .row
            layout.alignContent = .center
            layout.justifyContent = .center
            
            layout.height = 60
            
        }
        bottomContentCotainer.addSubview(bottomContentRow)
        
        let button2 = UIButton()
        button2.setTitle("First", for: .normal)
        button2.addTarget(self, action: #selector(didExpandTabBar), for: .touchUpInside)
        button2.configureLayout { layout in
            layout.isEnabled = true
            layout.width = 33%
            layout.height = 55
            layout.alignSelf = .center
        }
        
        bottomContentRow.addSubview(button2)
        
        let centerRow = UIView()
        centerRow.layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
        centerRow.layer.shadowOpacity = 0.85
        centerRow.layer.shadowRadius = 10.0
        centerRow.backgroundColor = .blue
        let centerRowTapGesture = UITapGestureRecognizer(target: self, action: #selector(didExpandTabBar))
        centerRow.addGestureRecognizer(centerRowTapGesture)
        centerRow.isUserInteractionEnabled = true
        centerRow.configureLayout { layout in
            layout.isEnabled = true
            layout.width = 33%
            layout.height = 50
            layout.top = -10
            layout.flexDirection = .row
            layout.alignContent = .center
            layout.justifyContent = .center
        }
        
        bottomContentRow.addSubview(centerRow)
        
        let button = UILabel()
        button.text = "Expand"
        
        button.configureLayout { layout in
            layout.isEnabled = true
            layout.height = 50
        }
        
        bottomTabBarArrow = UIImageView()
        bottomTabBarArrow.image = UIImage(named: "chevron.down")
        
        
        bottomTabBarArrow.configureLayout { layout in
            layout.isEnabled = true
            layout.marginLeft = 10
            layout.height = 10
            layout.width = 15
            layout.alignSelf = .center
            
        }
        
        centerRow.addSubview(button)
        centerRow.addSubview(bottomTabBarArrow)
        
        
        
        let button3 = UIButton()
        button3.setTitle("Last", for: .normal)
        button3.addTarget(self, action: #selector(didExpandTabBar), for: .touchUpInside)
        button3.configureLayout { layout in
            layout.isEnabled = true
            layout.width = 33%
            layout.height = 55
            layout.alignSelf = .center
        }
        
        bottomContentRow.addSubview(button3)
        
        bottomContentColumn = UIView()
        bottomContentColumn.backgroundColor = .orange
        bottomContentColumn.tag = 100
        bottomContentColumn.configureLayout { layout in
            layout.isEnabled = true
            layout.width = 100%
            layout.flexDirection = .column
            layout.paddingVertical = 20
            
        }
        bottomContentColumn.yoga.isIncludedInLayout = isExpandedTabBar.value
        bottomContentCotainer.addSubview(bottomContentColumn)
        
        let button4 = UIButton()
        button4.setTitle("Login", for: .normal)
        button4.addTarget(self, action: #selector(didExpandTabBar), for: .touchUpInside)
        button4.configureLayout { layout in
            layout.isEnabled = true
            layout.left = 0
            layout.height = 40
            layout.paddingLeft = 20
            layout.alignSelf = .flexStart
        }
        
        bottomContentColumn.addSubview(button4)
        
        let button5 = UIButton()
        button5.setTitle("Contact", for: .normal)
        button5.addTarget(self, action: #selector(didExpandTabBar), for: .touchUpInside)
        button5.configureLayout { layout in
            layout.isEnabled = true
            layout.left = 0
            layout.height = 40
            layout.paddingLeft = 20
            layout.alignSelf = .flexStart
        }
        bottomContentColumn.addSubview(button5)
        
        let button6 = UIButton()
        button6.setTitle("Support", for: .normal)
        button6.addTarget(self, action: #selector(didExpandTabBar), for: .touchUpInside)
        button6.configureLayout { layout in
            layout.isEnabled = true
            layout.left = 0
            layout.height = 40
            layout.paddingLeft = 20
            layout.alignSelf = .flexStart
        }
        
        bottomContentColumn.addSubview(button6)
        
        let button7 = UIButton()
        button7.setTitle("Settings", for: .normal)
        button7.addTarget(self, action: #selector(didExpandTabBar), for: .touchUpInside)
        button7.configureLayout { layout in
            layout.isEnabled = true
            layout.left = 0
            layout.height = 40
            layout.paddingLeft = 20
            layout.alignSelf = .flexStart
        }
        
        bottomContentColumn.addSubview(button7)
        
        addSpacers(for: bottomContentColumn)
        
        isExpandedTabBar.map({ $0 ? 1 : 0 }).bind(to: bottomContentColumn.rx.alpha).disposed(by: bag)
        rootView.yoga.applyLayout(preservingOrigin: true)
    }
    
    
    func addSpacers(for view: UIView) {
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
    @objc func didTapOption(sender: Any) {
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
            fallthrough
        case .nationalSecurity:
            fallthrough
        case .politics:
            fallthrough
        case .entertainment:
            fallthrough
        case .health:
            break
        }
        topTabBarArrow.image = UIImage(named: "chevron.down")
        didExpandTopBar()
        headerButton.yoga.markDirty()
        self.view.yoga.applyLayout(preservingOrigin: true)
    }
    @objc func didExpandTabBar() {
        isExpandedTabBar.accept(!isExpandedTabBar.value)
        
        if isExpandedTabBar.value {
            bottomContentColumn.yoga.isIncludedInLayout = true
            bottomTabBarArrow.image = UIImage(named: "chevron.up")
            
        } else {
            bottomContentColumn.yoga.isIncludedInLayout = false
            bottomTabBarArrow.image = UIImage(named: "chevron.down")
        }
        self.view.yoga.applyLayout(preservingOrigin: true)
        
        print(isExpandedTabBar.value)
    }
    
    @objc func didExpandTopBar() {
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

extension UIButton {
    struct OptionHolder {
        static var stored = [TopMenuOption]()
    }
    var menuOptions: [TopMenuOption] {
        get {
            return OptionHolder.stored
        }
        set(newValue) {
            OptionHolder.stored.append(contentsOf: newValue)
        }
    }
}
