//
//  CustomStepper.swift
//  EcommerceConcept
//
//  Created by Артём on 08.12.2022.
//

import UIKit

protocol CustomStepperDelegate: AnyObject {
    func valueChanged(_ stepper: CustomStepper, value: Int)
}

class CustomStepper: UIStackView {
    
    var count: Int = 1
    
    weak var delegate: CustomStepperDelegate?
    
    private let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus"), for: .normal)
        button.tintColor = .white
        button.tag = 1
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "MarkPro-Medium", size: 20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let minusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "minus"), for: .normal)
        button.tintColor = .white
        button.tag = 2
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
        backgroundColor = #colorLiteral(red: 0.1563866436, green: 0.1562446654, blue: 0.2642547786, alpha: 1)
        distribution = .fillEqually
        countLabel.text = String(count)
        setOpacity()
        
        addArrangedSubview(minusButton)
        addArrangedSubview(countLabel)
        addArrangedSubview(plusButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        layer.cornerRadius = self.frame.width / 2
    }
    
    func configure(with count: Int) {
        self.count = count
        countLabel.text = String(count)
    }
    
    @objc private func buttonTapped(button : UIButton) {
        if button.tag == 1 {
            count += 1
        } else if count != 1 {
            count -= 1
        }
        countLabel.text = String(count)
        setOpacity()
        delegate?.valueChanged(self, value: count)
    }
    
    private func setOpacity() {
        minusButton.alpha = count == 1 ? 0.5 : 1
        minusButton.isEnabled = count == 1 ? false : true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
}

