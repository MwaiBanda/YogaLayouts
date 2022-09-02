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

class ViewController: UIViewController {
    var isExpanded = BehaviorRelay<Bool>(value: false)
    let bag = DisposeBag()
    var bottomContentColumn: UIView!
    var bottomContentRow2: UIView!
    var bottomContentRow1: UIView!
    var arrow: UIImageView!

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
        let background = UIView()
        background.backgroundColor = .gray.withAlphaComponent(0.2)
        background.configureLayout { (layout) in
            layout.isEnabled = true
            layout.position = .absolute
            layout.width = 100%
            layout.height = 100%
        }
        rootView.addSubview(background)
        
        let top = UIView()
        top.backgroundColor = .orange
        top.configureLayout { (layout) in
            layout.isEnabled = true
            layout.position = .absolute
            layout.top = 0
            layout.width = 100%
            layout.height = 60
        }
        rootView.addSubview(top)
        
        let bottom = UIView()
        bottom.backgroundColor = .orange
        bottom.configureLayout { (layout) in
            layout.isEnabled = true
            layout.position = .absolute
            layout.bottom = 0
            layout.width = 100%
        }
        rootView.addSubview(bottom)
        
        bottomContentColumn = UIView()
        bottomContentColumn.backgroundColor = .brown
        bottomContentColumn.configureLayout { layout in
            layout.isEnabled = true
            layout.width = 100%
            layout.flexDirection = .column
            layout.alignContent = .center
            
        }
        
        bottom.addSubview(bottomContentColumn)
        
        bottomContentRow1 = UIView()
        bottomContentRow1.backgroundColor = .blue
        bottomContentRow1.configureLayout { layout in
            layout.isEnabled = true
            layout.markDirty()
            layout.width = 100%
            layout.flexDirection = .row
            layout.alignContent = .center
            layout.justifyContent = .center
            
            layout.height = 60
            
        }
        let button2 = UIButton()
        button2.setTitle("First", for: .normal)
        button2.addTarget(self, action: #selector(didExpand), for: .touchUpInside)
        button2.configureLayout { layout in
            layout.isEnabled = true
            layout.width = 33%
            layout.height = 55
            layout.alignSelf = .center
        }
        
        bottomContentRow1.addSubview(button2)
        
        let centerRow = UIView()
        centerRow.layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
        centerRow.layer.shadowOpacity = 0.85
        centerRow.layer.shadowRadius = 10.0
        centerRow.backgroundColor = .blue
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didExpand))
        centerRow.addGestureRecognizer(tapGesture)
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
        
        bottomContentRow1.addSubview(centerRow)

        let button = UIButton()
        button.setTitle("Expand", for: .normal)
        button.addTarget(self, action: #selector(didExpand), for: .touchUpInside)
      
        button.configureLayout { layout in
            layout.isEnabled = true
            layout.height = 50
        }
        
        arrow = UIImageView()
        arrow.image = UIImage(named: "chevron.down")
       
        
        arrow.configureLayout { layout in
            layout.isEnabled = true
            layout.marginLeft = 10
            layout.height = 10
            layout.width = 15
            layout.alignSelf = .center

        }
        
        centerRow.addSubview(button)
        centerRow.addSubview(arrow)

       
        
        let button3 = UIButton()
        button3.setTitle("Last", for: .normal)
        button3.addTarget(self, action: #selector(didExpand), for: .touchUpInside)
        button3.configureLayout { layout in
            layout.isEnabled = true
            layout.width = 33%
            layout.height = 55
            layout.alignSelf = .center
        }
        
        bottomContentRow1.addSubview(button3)
        
        bottomContentRow2 = UIView()
        bottomContentRow2.backgroundColor = .orange
        bottomContentRow2.tag = 100
        bottomContentRow2.configureLayout { layout in
            layout.isEnabled = true
            layout.width = 100%
            layout.flexDirection = .row
            layout.alignContent = .center
            layout.height = 150
            
        }
        bottomContentRow2.yoga.isIncludedInLayout = false
        bottomContentColumn.addSubview(bottomContentRow1)
        
        bottomContentColumn.addSubview(bottomContentRow2)

        isExpanded.map({ $0 ? 1 : 0 }).bind(to: bottomContentRow2.rx.alpha).disposed(by: bag)
        
        rootView.yoga.applyLayout(preservingOrigin: true)
    }
    
    @objc func didExpand() {
        isExpanded.accept(!isExpanded.value)
        
        if isExpanded.value {
            bottomContentRow2.yoga.isIncludedInLayout = true
            arrow.image = UIImage(named: "chevron.up")

        } else {
            bottomContentRow2.yoga.isIncludedInLayout = false
            arrow.image = UIImage(named: "chevron.down")
        }
        self.view.yoga.applyLayout(preservingOrigin: true)
        
        print(isExpanded.value)
    }
}

