//
//  ProductDetailCVCell.swift
//  EcommerceConcept
//
//  Created by Артём on 07.12.2022.
//

import UIKit

class ProductDetailCVCell: UICollectionViewCell {
    
    static var reuseId: String = "ProductDetailCVCell"
    
    let hotSalesImageView = WebImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .green
        layer.cornerRadius = 15
        hotSalesImageView.contentMode = .scaleAspectFill
        setupConstraints()
        
    
    }
    
    override func prepareForReuse() {
        hotSalesImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //clipsToBounds = false
        layer.masksToBounds = false
        self.layer.shadowOpacity = 0.5
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 30
        
        hotSalesImageView.layer.cornerRadius = 15
    }
    
    
    func configure(with urlString: String) {
        hotSalesImageView.set(imageURL: urlString)
    }
    
    func setupConstraints() {
        hotSalesImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hotSalesImageView)
        hotSalesImageView.clipsToBounds = true
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
