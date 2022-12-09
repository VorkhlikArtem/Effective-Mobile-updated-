//
//  SelectCategoryCell.swift
//  Ecommerce Concept
//
//  Created by Артём on 03.12.2022.
//

import UIKit

class SelectCategoryCell: UICollectionViewCell {
    
    static var reuseId: String = "SelectCategoryCell"
    
    let categoryImageView = UIImageView()
    let categoryTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "MarkPro-Regular", size: 12)
        label.textColor = .blackTextColor
        
        return label
    }()
    let circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        
        clipsToBounds = true
        categoryImageView.contentMode = .scaleAspectFit
       
        self.backgroundColor = .clear
        setupConstraints()
    }
    
    override func prepareForReuse() {
        deselect()
    }
    

    
    func configure(with categoryModel: CategoryItem) {
        categoryImageView.image = UIImage(named: categoryModel.imageName)?.withTintColor(.gray)
        categoryTitle.text = categoryModel.title
        
    }
    
    func select() {
        circleView.backgroundColor = .orange
        categoryImageView.image = categoryImageView.image?.withTintColor(.white)
        categoryTitle.textColor = .orange
    }
    
    func deselect() {
        circleView.backgroundColor = .white
        categoryImageView.image = categoryImageView.image?.withTintColor(.gray)
        categoryTitle.textColor = .blackTextColor
    }
    
    func setupConstraints() {
        circleView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(circleView)
        NSLayoutConstraint.activate([
            circleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            circleView.centerYAnchor.constraint(equalTo: centerYAnchor),
            circleView.heightAnchor.constraint(equalToConstant: Constants.selectCategoryCellWidth),
            circleView.widthAnchor.constraint(equalToConstant: Constants.selectCategoryCellWidth),

        ])
        
        categoryImageView.translatesAutoresizingMaskIntoConstraints = false
        circleView.addSubview(categoryImageView)
        NSLayoutConstraint.activate([
            categoryImageView.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            categoryImageView.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            categoryImageView.heightAnchor.constraint(equalToConstant: 35),
            categoryImageView.widthAnchor.constraint(equalToConstant: 35),

        ])
        
        categoryTitle.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(categoryTitle)
        NSLayoutConstraint.activate([
            categoryTitle.centerXAnchor.constraint(equalTo: centerXAnchor),
           // categoryTitle.bottomAnchor.constraint(equalTo: bottomAnchor),
            categoryTitle.topAnchor.constraint(equalTo: circleView.bottomAnchor, constant: 7)

        ])
        
//        NSLayoutConstraint.activate([
//            categoryImageView.topAnchor.constraint(equalTo: topAnchor),
//            categoryImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            categoryImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
//            categoryImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
//
//        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleView.layer.cornerRadius = Constants.selectCategoryCellWidth / 2
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
