//
//  RatingStackView.swift
//  EcommerceConcept
//
//  Created by Артём on 05.12.2022.
//

import UIKit

class RatingStackView: UIStackView {
    
    init(rating: Float) {
        super.init(frame: .zero)
        self.axis = .horizontal
        self.spacing = 9
        
        var ratingCounter = rating
        for _ in 1...5 {
            if ratingCounter > 1 {
                addArrangedSubview(RatingStarView(rating: 1))
                ratingCounter -= 1
            } else {
                addArrangedSubview(RatingStarView(rating: ratingCounter))
                ratingCounter = 0
            }
        }

    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

