//
//  HotSalesCell.swift
//  Ecommerce Concept
//
//  Created by Артём on 03.12.2022.
//

import UIKit

class HotSalesCell: UICollectionViewCell {
    
    static var reuseId: String = "HotSalesCell"
    
    let hotSalesImageView = WebImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .green
        layer.cornerRadius = 10
        clipsToBounds = true
        hotSalesImageView.contentMode = .scaleAspectFill
        setupConstraints()
    }
    
    override func prepareForReuse() {
        hotSalesImageView.image = nil
    }
    
    
    func configure(with urlString: String) {
        hotSalesImageView.set(imageURL: urlString)
    }
    
    func setupConstraints() {
        hotSalesImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hotSalesImageView)
        NSLayoutConstraint.activate([
            hotSalesImageView.topAnchor.constraint(equalTo: topAnchor),
            hotSalesImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            hotSalesImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            hotSalesImageView.trailingAnchor.constraint(equalTo: trailingAnchor)

        ])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

