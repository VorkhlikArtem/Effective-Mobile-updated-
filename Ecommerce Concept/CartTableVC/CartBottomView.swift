//
//  CartBottomView.swift
//  EcommerceConcept
//
//  Created by Артём on 08.12.2022.
//

import UIKit

class CartBottomView: UIView {
    
    private let totalLabel = UILabel(text: "Total", font: .markProRegular15(), textColor: .white)
    private let deliveryLabel = UILabel(text: "Delivery", font: .markProRegular15(), textColor: .white)
    
    private let totalPriceLabel = UILabel(font: .markProBold15(), textColor: .white)
    private let deliveryInfoLabel = UILabel(font: .markProBold15(), textColor: .white)
    
    private let checkoutButton = UIButton(text: "Checkout", font: .markProBold20(), textColor: .white, buttonColor: .orangeColor)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blackTextColor
        checkoutButton.clipsToBounds = true
        checkoutButton.layer.cornerRadius = 10
        setupStacks()
    }
    
    func configure(with bottomCartViewModel: CartBottomViewModelProtocol) {
        totalPriceLabel.text = bottomCartViewModel.formattedPriceString
        deliveryInfoLabel.text = bottomCartViewModel.deliveryInfo
    }
    
    func configureTotalPrice(with text: String) {
        totalPriceLabel.text = text
    }
    
    private func  setupStacks() {
        let totalStack = UIStackView(arrangedSubviews: [totalLabel, totalPriceLabel])
        totalStack.axis = .horizontal
        totalStack.distribution = .equalSpacing

        let deliveryStack = UIStackView(arrangedSubviews: [deliveryLabel, deliveryInfoLabel])
        deliveryStack.axis = .horizontal
        deliveryStack.distribution = .equalSpacing
        
        let mainStack = UIStackView(arrangedSubviews: [totalStack, deliveryStack])
        mainStack.axis = .vertical
        mainStack.spacing = 12
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 55),
           // mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -26),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -35),
            deliveryInfoLabel.leadingAnchor.constraint(equalTo: totalPriceLabel.leadingAnchor)
        ])
        
        checkoutButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(checkoutButton)
        NSLayoutConstraint.activate([
            checkoutButton.topAnchor.constraint(equalTo: mainStack.bottomAnchor, constant: 27),
            checkoutButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 44),
            checkoutButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            checkoutButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -44),

        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
}

