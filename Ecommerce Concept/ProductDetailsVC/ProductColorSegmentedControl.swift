//
//  ProductColorSegmentedControl.swift
//  EcommerceConcept
//
//  Created by Артём on 07.12.2022.
//

import UIKit

class ProductColorSegmentedControl: UIStackView {
    
    var initialSelectedButtonIndex: Int? = 0
    
    private var buttons: [UIButton] {
        return self.arrangedSubviews as! [UIButton]
    }

    
    init(productColorViewModel: ProductColorViewModelProtocol) {
        super.init(frame: .zero)
        
        self.axis = .horizontal
        distribution = .fillEqually
        spacing = 18
        setupStackView(with: productColorViewModel.hexStrings)
        setupConstraints()
    }
    
    private func setupStackView(with hexColors: [String]) {
        let uiColors = hexColors.map { UIColor(hex: $0)}
        
        uiColors.enumerated().forEach { (index, color) in
            let colorButton: UIButton = {
                let button = UIButton(type: .system)
                button.backgroundColor = color
                button.tintColor = .white
                if index == initialSelectedButtonIndex {
                    button.setImage(UIImage(named: "checkmark"), for: .normal)
                }
                button.addTarget(self, action: #selector(selectButton), for: .touchUpInside)
                return button
            }()
            self.addArrangedSubview(colorButton)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        buttons.forEach({ $0.layer.cornerRadius = $0.frame.height / 2})
    }
    
    @objc private func selectButton(selectedButton: UIButton) {
        for button in buttons {
            button.setImage(nil, for: .normal)
        }
        selectedButton.setImage(UIImage(named: "checkmark"), for: .normal)
    }
    
    private func  setupConstraints() {
        buttons.forEach { button in
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

