//
//  CapacitySegmentedControl.swift
//  EcommerceConcept
//
//  Created by Артём on 07.12.2022.
//

import UIKit

class CapacitySegmentedControl: UIStackView {
    
    var initialSelectedButtonIndex: Int = 0
    
    private var buttons: [UIButton] {
        return self.arrangedSubviews as! [UIButton]
    }
    
    private var leadingSegmentConstraint: NSLayoutConstraint?
    private var trailingSegmentConstraint: NSLayoutConstraint?
    
    private let segmentView: UIView = {
        let view = UIView()
        view.backgroundColor = .orangeColor
        return view
    }()
    
    init(productCapacityViewModel: ProductCapacityViewModelProtocol) {
        super.init(frame: .zero)
        
        self.axis = .horizontal
        spacing = 5
        setupStackView(with: productCapacityViewModel.formatedCapacities)
        setupSegmentConstraints()
    }
    
    private func setupStackView(with formatedCapacities: [String]) {

        formatedCapacities.enumerated().forEach { (index, capacity) in
            let colorButton: UIButton = {
                let button = UIButton(type: .system)
                button.setTitle(capacity, for: .normal)
                button.tintColor = .white
                button.tintColor = index == initialSelectedButtonIndex ? .white : .darkgrayTextColor
                button.titleLabel?.font = UIFont(name: "MarkPro-Bold", size: 13)
                button.addTarget(self, action: #selector(selectButton), for: .touchUpInside)
                return button
            }()
            self.addArrangedSubview(colorButton)
        }
    }
    
    @objc private func selectButton(selectedButton: UIButton) {
        for button in buttons {
            button.setTitleColor(.darkgrayTextColor, for: .normal)
        }
        selectedButton.setTitleColor(.white, for: .normal)

        startLineAnimation(with: selectedButton)
     
    }
    
    private func startLineAnimation(with selectedButton: UIButton) {
        leadingSegmentConstraint?.isActive = false
        trailingSegmentConstraint?.isActive = false
        
        leadingSegmentConstraint = segmentView.leadingAnchor.constraint(equalTo: selectedButton.leadingAnchor)
        leadingSegmentConstraint?.isActive = true
        
        trailingSegmentConstraint =  segmentView.trailingAnchor.constraint(equalTo: selectedButton.trailingAnchor)
        trailingSegmentConstraint?.isActive = true
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func setupSegmentConstraints() {
        let selectedButton = buttons[initialSelectedButtonIndex]
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(segmentView, belowSubview: selectedButton)
        NSLayoutConstraint.activate([
            segmentView.bottomAnchor.constraint(equalTo: selectedButton.bottomAnchor),
            segmentView.heightAnchor.constraint(equalTo: selectedButton.heightAnchor),
        ])
        
        leadingSegmentConstraint = segmentView.leadingAnchor.constraint(equalTo: selectedButton.leadingAnchor)
        leadingSegmentConstraint?.isActive = true
        
        trailingSegmentConstraint =  segmentView.trailingAnchor.constraint(equalTo: selectedButton.trailingAnchor)
        trailingSegmentConstraint?.isActive = true
        
        buttons.forEach { button in
            button.widthAnchor.constraint(equalToConstant: button.intrinsicContentSize.width + 30).isActive = true
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        segmentView.layer.cornerRadius = 10
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
