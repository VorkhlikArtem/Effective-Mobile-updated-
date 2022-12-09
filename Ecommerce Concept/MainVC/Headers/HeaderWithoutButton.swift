//
//  HeaderWithoutButton.swift
//  EcommerceConcept
//
//  Created by Артём on 04.12.2022.
//

import UIKit

class HeaderWithoutButton: UICollectionReusableView {
    static let reuseId = "SectionHeader"
    
    let title: UILabel = {
        let label = UILabel()
        label.font = UIFont.markProBold25()
        label.textColor = .blackTextColor
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    func configure(text: String) {
        title.text = text
     
        
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
            title.trailingAnchor.constraint(equalTo: trailingAnchor)

        ])
    }
}
