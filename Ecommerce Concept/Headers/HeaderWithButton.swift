//
//  HeaderWithButton.swift
//  EcommerceConcept
//
//  Created by Артём on 04.12.2022.
//

import UIKit

class HeaderWithButton: UICollectionReusableView {
    static let reuseId = "HeaderWithButton"
    
    let title: UILabel = {
        let label = UILabel()
        label.font = UIFont.markProBold25()
        label.textColor = .blackTextColor
        return label
    }()
    
    let seeMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.orange, for: .normal)
        button.titleLabel?.font = .markProRegular15()
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
      //  seeMoreButton.setTitle("see more", for: .normal)
        setupConstraints()
    }
    
    func configure(title: String, buttonText: String) {
        self.title.text = title
        seeMoreButton.setTitle(buttonText, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        title.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(title)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor),
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.bottomAnchor.constraint(equalTo: bottomAnchor),
            

        ])
        
        seeMoreButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(seeMoreButton)
        
        NSLayoutConstraint.activate([
            seeMoreButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            seeMoreButton.trailingAnchor.constraint(equalTo: trailingAnchor),
           // seeMoreButton.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 20)
        ])
    }
}

