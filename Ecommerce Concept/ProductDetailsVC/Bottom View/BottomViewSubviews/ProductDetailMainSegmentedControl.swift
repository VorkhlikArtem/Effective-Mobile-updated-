//
//  ProductDetailSegmentedController.swift
//  EcommerceConcept
//
//  Created by Артём on 06.12.2022.
//

import UIKit

class ProductDetailMainSegmentedControl: UIStackView {
    
    var initialSelectedButtonIndex = 0
    
    let menuButtonTitles = Constants.detailProductMenuButtonsNames
    
    private var buttons: [UIButton] {
        return self.arrangedSubviews as! [UIButton]
    }
    
    private var leadingLineConstraint: NSLayoutConstraint?
    private var trailingLineConstraint: NSLayoutConstraint?
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .orangeColor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.axis = .horizontal
        distribution = .fillEqually
        spacing = 30
        setupStackView()
        setupLineViewConstraints()
    }
    
    private func setupStackView() {
        menuButtonTitles.enumerated().forEach { (index, buttonTitle) in
            let menuButton: UIButton = {
                let button = UIButton(type: .system)
                button.setTitle(buttonTitle, for: .normal)
                button.tintColor = index == initialSelectedButtonIndex ? .blackTextColor : .darkgrayTextColor
                button.titleLabel?.font = index == initialSelectedButtonIndex ? .markProBold20() : .markProRegular20()
                button.addTarget(self, action: #selector(selectButton), for: .touchUpInside)
                return button
            }()
            self.addArrangedSubview(menuButton)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lineView.layer.cornerRadius = lineView.frame.height / 2
    }
    
    @objc private func selectButton(selectedButton: UIButton) {
        for button in buttons {
            button.setTitleColor(.darkgrayTextColor, for: .normal)
            button.titleLabel?.font = .markProRegular20()
        }
        selectedButton.setTitleColor(.blackTextColor, for: .normal)
        selectedButton.titleLabel?.font = .markProBold20()
        
        startLineAnimation(with: selectedButton)
     
    }
    
    private func startLineAnimation(with selectedButton: UIButton) {
        leadingLineConstraint?.isActive = false
        trailingLineConstraint?.isActive = false
        
        leadingLineConstraint = lineView.leadingAnchor.constraint(equalTo: selectedButton.leadingAnchor)
        leadingLineConstraint?.isActive = true
        
        trailingLineConstraint =  lineView.trailingAnchor.constraint(equalTo: selectedButton.trailingAnchor)
        trailingLineConstraint?.isActive = true
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func  setupLineViewConstraints() {
        let selectedButton = buttons[initialSelectedButtonIndex]
        lineView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lineView)
        NSLayoutConstraint.activate([
            
            lineView.bottomAnchor.constraint(equalTo: selectedButton.bottomAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 4)
           
        ])
        
        leadingLineConstraint = lineView.leadingAnchor.constraint(equalTo: selectedButton.leadingAnchor)
        leadingLineConstraint?.isActive = true
        
        trailingLineConstraint =  lineView.trailingAnchor.constraint(equalTo: selectedButton.trailingAnchor)
        trailingLineConstraint?.isActive = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

