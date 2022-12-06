//
//  ProductDetailsBottomView.swift
//  EcommerceConcept
//
//  Created by Артём on 05.12.2022.
//

import UIKit

class ProductDetailsBottomView: UIView {
    
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "MarkPro-Medium", size: 24)
        label.textColor = .blackTextColor
        return label
    }()
    
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "unselected"), for: .normal)
        button.tintColor = .blackTextColor
        button.backgroundColor = .white
        return button
    }()
    
    var ratingStackView: RatingStackView!
    let mainSegmentedControl = ProductDetailMainSegmentedControl()
    var featuresStackView: FeaturesStackView!
    
    init(productDetailBottomViewModel: ProductDetailBottomViewModelProtocol) {
        super.init(frame: .zero)
       
        titleLabel.text = productDetailBottomViewModel.title
        ratingStackView = RatingStackView(rating: productDetailBottomViewModel.rating)
        
        let productFeaturesViewModel = ProductFeaturesViewModel(productDetailBottomViewModel: productDetailBottomViewModel)
        featuresStackView = FeaturesStackView(featuresViewModel: productFeaturesViewModel)
        
        setupConstraints()
        

    
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 30
        layer.shadowOpacity = 0.2
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 10
        
        likeButton.layer.cornerRadius = 10
        likeButton.layer.shadowOpacity = 0.2
        likeButton.layer.shadowColor = UIColor.black.cgColor
        likeButton.layer.shadowOffset = .zero
        likeButton.layer.shadowRadius = 10
    }
    
    private func  setupConstraints() {
        self.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 28),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 38)
        ])
        
        self.addSubview(likeButton)
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: topAnchor, constant: 28),
            likeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -37),
            likeButton.heightAnchor.constraint(equalToConstant: 33),
            likeButton.widthAnchor.constraint(equalToConstant: 37)
        ])
        
        ratingStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(ratingStackView)
        NSLayoutConstraint.activate([
            ratingStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            ratingStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 38)
      
        ])
        
        mainSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(mainSegmentedControl)
        NSLayoutConstraint.activate([
            mainSegmentedControl.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 32),
            mainSegmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 27),
            mainSegmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -27),
      
        ])
        
        featuresStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(featuresStackView)
        NSLayoutConstraint.activate([
            featuresStackView.topAnchor.constraint(equalTo: mainSegmentedControl.bottomAnchor, constant: 30),
            featuresStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 27),
            featuresStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -27),
      
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - SwiftUI
import SwiftUI
struct ProductDetailsBottomViewProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().ignoresSafeArea(.all).previewInterfaceOrientation(.landscapeLeft)
    }
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = UINavigationController(rootViewController: ProductDetailsViewController())
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }

        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
    }
}
