//
//  ProductDetailCVCell.swift
//  EcommerceConcept
//
//  Created by Артём on 07.12.2022.
//

import UIKit

class ProductDetailCVCell: UICollectionViewCell {
    
    static var reuseId: String = "ProductDetailCVCell"
    
    let productImageView = WebImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 15
        productImageView.contentMode = .scaleAspectFill
        setupConstraints()
        
    
    }
    
    override func prepareForReuse() {
        productImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //clipsToBounds = false
        layer.masksToBounds = false
        self.layer.shadowOpacity = 0.5
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 30
        
        productImageView.layer.cornerRadius = 15
    }
    
    
    func configure(with urlString: String) {
        productImageView.set(imageURL: urlString)
    }
    
    func setupConstraints() {
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(productImageView)
        productImageView.clipsToBounds = true
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: topAnchor),
            productImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            productImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            productImageView.trailingAnchor.constraint(equalTo: trailingAnchor)

        ])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
