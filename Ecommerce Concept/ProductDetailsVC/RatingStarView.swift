//
//  RatingStarView.swift
//  EcommerceConcept
//
//  Created by Артём on 05.12.2022.
//

import UIKit

class RatingStarView: UIView {
    
    static let fullStarWidth: CGFloat = 18
    
    let starWidthRatio: Float
    
    let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "star")
        return imageView
    }()
    

    init(rating: Float) {
        starWidthRatio = rating
        super.init(frame: .zero)
        
        clipsToBounds = true
        
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: Self.fullStarWidth * CGFloat(starWidthRatio)),
        ])
        
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(starImageView)
        NSLayoutConstraint.activate([
            starImageView.heightAnchor.constraint(equalToConstant: Self.fullStarWidth),
            starImageView.widthAnchor.constraint(equalToConstant: Self.fullStarWidth),
            starImageView.topAnchor.constraint(equalTo: topAnchor),
            starImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            starImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
           
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

