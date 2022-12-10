//
//  CartTVCell.swift
//  EcommerceConcept
//
//  Created by Артём on 08.12.2022.
//

import UIKit

protocol CartTVCellDelegate: AnyObject {
    func countChanged(_ cell: UITableViewCell, count: Int)
    func deleteCell(_ cell: UITableViewCell)
}


class CartTVCell: UITableViewCell {
    
    static var reuseId: String = "CartTVCell"
    
    weak var delegate: CartTVCellDelegate?

    let productImageView = WebImageView()
    
    let modelName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "MarkPro-Medium", size: 20)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "MarkPro-Medium", size: 20)
        label.textColor = .orangeColor
        return label
    }()
    
    let stepper = CustomStepper()
    
    let deleteButton = UIButton(image: "delete", imageColor: #colorLiteral(red: 0.2123073339, green: 0.2123567462, blue: 0.3040331602, alpha: 1))
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .blackTextColor
        clipsToBounds = false
        productImageView.contentMode = .scaleAspectFill
        
        stepper.delegate = self
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    override func prepareForReuse() {
        productImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        productImageView.clipsToBounds = true
        productImageView.layer.cornerRadius = 10

    }
    

    func configure(with cartCellItem: CartCellViewModel) {
        productImageView.set(imageURL: cartCellItem.images)
        priceLabel.text = "$\(cartCellItem.price.formattedWithSeparator)"
        modelName.text = cartCellItem.title
    }
    
    @objc private func deleteTapped() {
        delegate?.deleteCell(self)
    }
    
    func setupConstraints() {
        
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(productImageView)
        NSLayoutConstraint.activate([
          
            productImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 23),
            productImageView.topAnchor.constraint(equalTo: topAnchor),
            productImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.67),
            productImageView.widthAnchor.constraint(equalTo: productImageView.heightAnchor),

        ])
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(deleteButton)
        NSLayoutConstraint.activate([
          
            deleteButton.centerYAnchor.constraint(equalTo: productImageView.centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),

        ])
        
        stepper.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(stepper)
        NSLayoutConstraint.activate([
            stepper.centerYAnchor.constraint(equalTo: productImageView.centerYAnchor),
            stepper.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -17),
            stepper.heightAnchor.constraint(equalToConstant: 68),
            stepper.widthAnchor.constraint(equalToConstant: 26),
        ])

        let vStack = UIStackView(arrangedSubviews: [modelName, priceLabel])
        vStack.axis = .vertical
        vStack.distribution = .fill
        vStack.spacing = 6

        vStack.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 15),
            vStack.bottomAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: -6),
            vStack.trailingAnchor.constraint(lessThanOrEqualTo: stepper.leadingAnchor, constant: -33),
            vStack.topAnchor.constraint(equalTo: topAnchor, constant: 4)
        ])

    }

}

extension CartTVCell: CustomStepperDelegate {
    func valueChanged(_ stepper: CustomStepper, value: Int) {
        delegate?.countChanged(self, count: value)
    }
    
    
}
