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
    
    let newLabel = UILabel(text: "New", font: .markProBold10(), textColor: .white, labelColor: .orangeColor)
    let titleLabel = UILabel(font: .markProBold25(), textColor: .white)
    let subtitleLabel = UILabel(font: .markProRegular11() , textColor: .white)
   // let buyButton = UIButton(text: "Buy now!", font: .markProBold11(), textColor: .blackTextColor, buttonColor: .white)
    
    let buyButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.configuration = .filled()
        let fontAttribute = [NSAttributedString.Key.font: UIFont.markProBold11() as Any, NSAttributedString.Key.foregroundColor: UIColor.blackTextColor as Any]
        let nsString = NSAttributedString(string: "Buy now!", attributes: fontAttribute)
        button.configuration?.attributedTitle = AttributedString.init(nsString)
        button.configuration?.baseBackgroundColor = .white
        button.configuration?.contentInsets = .init(top: 5, leading: 27, bottom: 5, trailing: 27)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .green
        layer.cornerRadius = 10
        clipsToBounds = true
        hotSalesImageView.contentMode = .scaleAspectFill
        newLabel.textAlignment = .center
  
        setupConstraints()
    }
    
    override func prepareForReuse() {
        hotSalesImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        buyButton.clipsToBounds = true
        buyButton.layer.cornerRadius = 5
        newLabel.clipsToBounds = true
        newLabel.layer.cornerRadius = newLabel.frame.height / 2
    }
    
    
    func configure(with hotSalesViewModel: HotSalesItem) {
        hotSalesImageView.set(imageURL: hotSalesViewModel.picture)
        titleLabel.text = hotSalesViewModel.title
        subtitleLabel.text = hotSalesViewModel.subtitle
        newLabel.isHidden = hotSalesViewModel.isNew ?? false
        buyButton.isHidden = !hotSalesViewModel.isBuy
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
        
        newLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(newLabel)
        NSLayoutConstraint.activate([
            newLabel.topAnchor.constraint(equalTo: topAnchor, constant: 23),
            newLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            newLabel.heightAnchor.constraint(equalToConstant: 27),
            newLabel.widthAnchor.constraint(equalTo: newLabel.heightAnchor)
        ])
        
        let vStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        vStack.axis = .vertical
        vStack.distribution = .equalSpacing
        vStack.spacing = 5
        vStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            vStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
        ])
        
        buyButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(buyButton)
        NSLayoutConstraint.activate([
            buyButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            buyButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            
        ])
        
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

