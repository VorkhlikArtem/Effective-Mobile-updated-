//
//  ProductDetailsBottomView.swift
//  EcommerceConcept
//
//  Created by Артём on 05.12.2022.
//

import UIKit

class ProductDetailsBottomView: UIView {
    
    // MARK: - View Properties
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
       // button.tintColor = .blackTextColor
       // button.backgroundColor = .white
        button.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        return button
    }()
    
    let colorCapacityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Select color and capacity"
        label.font = UIFont(name: "MarkPro-Medium", size: 16)
        label.textColor = .blackTextColor
        return label
    }()
    
    var ratingStackView: RatingStackView!
    let mainSegmentedControl = ProductDetailMainSegmentedControl()
    var featuresStackView: FeaturesStackView!
    var colorSegmentedControl: ProductColorSegmentedControl!
    var capacitySegmentedControl: CapacitySegmentedControl!
    
    
    let addToCartButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .filled()
        let fontAttribute = [NSAttributedString.Key.font: UIFont(name: "MarkPro-Bold", size: 20) as Any]
        let nsString = NSAttributedString(string: "Add to cart", attributes: fontAttribute)
        button.configuration?.attributedTitle = AttributedString.init(nsString)
        button.configuration?.titleAlignment = .leading
        button.configuration?.baseBackgroundColor = .orangeColor
        button.configuration?.contentInsets = .init(top: 14, leading: 45, bottom: 15, trailing: 0)
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "MarkPro-Bold", size: 20)
        label.textColor = .white
        return label
    }()
    
    // MARK: - Data Properties
    var isFavorite = false {
        didSet {
            if isFavorite {
               selectedLikeButton()
            } else {
               unselectedLikeButton()
            }
        }
    }
    
    // MARK: - Init
    init(productDetailBottomViewModel: ProductDetailBottomViewModelProtocol) {
        super.init(frame: .zero)
       
        titleLabel.text = productDetailBottomViewModel.title
        ratingStackView = RatingStackView(rating: productDetailBottomViewModel.rating)
        
        let productFeaturesViewModel = ProductFeaturesViewModel(productDetailBottomViewModel: productDetailBottomViewModel)
        featuresStackView = FeaturesStackView(featuresViewModel: productFeaturesViewModel)
        
        let productColorViewModel = ProductColorViewModel(hexStrings: productDetailBottomViewModel.color)
        colorSegmentedControl = ProductColorSegmentedControl(productColorViewModel: productColorViewModel)
        
        let productCapacityViewModel = ProductCapacityViewModel(capacities: productDetailBottomViewModel.capacity)
        capacitySegmentedControl = CapacitySegmentedControl(productCapacityViewModel: productCapacityViewModel)
        
        priceLabel.text = productDetailBottomViewModel.formatedPrice
        isFavorite = productDetailBottomViewModel.isFavorites
        if productDetailBottomViewModel.isFavorites {
            selectedLikeButton()
        } else {
            unselectedLikeButton()
        }
        
        setupConstraints()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 30
        layer.shadowOpacity = 0.2
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 10
        
        likeButton.layer.cornerRadius = 5
        likeButton.layer.shadowOpacity = 0.1
        likeButton.layer.shadowColor = UIColor.black.cgColor
        likeButton.layer.shadowOffset = .zero
  
    }
    
    // MARK: - Like button
    @objc private func likeTapped(button: UIButton) {
        isFavorite.toggle()
    }
    
    private func unselectedLikeButton() {
        likeButton.backgroundColor = .white
        likeButton.tintColor = .blackTextColor
    }
    
    private func selectedLikeButton() {
        likeButton.backgroundColor = .blackTextColor
        likeButton.tintColor = .white
    }
    
    
    // MARK: - setup Constraints
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
        
        self.addSubview(colorCapacityLabel)
        NSLayoutConstraint.activate([
            colorCapacityLabel.topAnchor.constraint(equalTo: featuresStackView.bottomAnchor, constant: 30),
            colorCapacityLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
        ])
        
        colorSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(colorSegmentedControl)
        NSLayoutConstraint.activate([
            colorSegmentedControl.topAnchor.constraint(equalTo: colorCapacityLabel.bottomAnchor, constant: 14),
            colorSegmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 35),
            colorSegmentedControl.heightAnchor.constraint(equalToConstant: 40)
      
        ])
        
        capacitySegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(capacitySegmentedControl)
        NSLayoutConstraint.activate([
            capacitySegmentedControl.centerYAnchor.constraint(equalTo: colorSegmentedControl.centerYAnchor),
            capacitySegmentedControl.leadingAnchor.constraint(equalTo: colorSegmentedControl.trailingAnchor, constant: 58),
            capacitySegmentedControl.heightAnchor.constraint(equalToConstant: 30)
      
        ])
        
        self.addSubview(addToCartButton)
        NSLayoutConstraint.activate([
         
            addToCartButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            addToCartButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            addToCartButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            addToCartButton.topAnchor.constraint(equalTo: colorSegmentedControl.bottomAnchor, constant: 27)
      
        ])
        
        self.addSubview(priceLabel)
        NSLayoutConstraint.activate([
            priceLabel.trailingAnchor.constraint(equalTo: addToCartButton.trailingAnchor, constant: -38),
            priceLabel.bottomAnchor.constraint(equalTo: addToCartButton.bottomAnchor, constant: -15),
        
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
        ContainerView().ignoresSafeArea(.all)
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
