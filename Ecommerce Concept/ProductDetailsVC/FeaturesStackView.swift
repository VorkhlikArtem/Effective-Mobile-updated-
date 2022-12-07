//
//  FeaturesStackView.swift
//  EcommerceConcept
//
//  Created by Артём on 06.12.2022.
//

import UIKit

class FeaturesStackView: UIStackView {
    
    let detailProductFeaturesImageNames = Constants.detailProductFeaturesImageNames
    
    init(featuresViewModel: ProductFeaturesViewModelProtocol) {
        super.init(frame: .zero)
        axis = .horizontal
        distribution = .fillEqually
        
        setupStackView(featuresViewModel: featuresViewModel)
    }
    
    private func setupStackView(featuresViewModel: ProductFeaturesViewModelProtocol) {
        for feature in featuresViewModel.productFeatures {
            let vStack: UIStackView = {
                let stack = UIStackView()
                stack.axis = .vertical
                stack.spacing = 5
                return stack
            }()
            
            let featureImageView = UIImageView(image: UIImage(named: feature.imageName))
            featureImageView.contentMode = .scaleAspectFit
            
            let featureLabel: UILabel = {
                let label = UILabel()
                label.textColor = UIColor(red: 0.717, green: 0.717, blue: 0.717, alpha: 1)
                label.font = UIFont(name: "MarkPro-Regular", size: 11)
                label.text = feature.name
                label.textAlignment = .center
                return label
            }()
            
            vStack.addArrangedSubview(featureImageView)
            vStack.addArrangedSubview(featureLabel)
            
            self.addArrangedSubview(vStack)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
}

