//
//  CartTVCell.swift
//  EcommerceConcept
//
//  Created by Артём on 08.12.2022.
//

import UIKit
import Combine

enum CartCellEvent {
    case quantityChanged(value: Int)
    case deleteItem
}

class CartTVCell: UITableViewCell {
    
    static var reuseId: String = "CartTVCell"
    
    private let eventSubject = PassthroughSubject<CartCellEvent, Never>()
    var eventPublisher: AnyPublisher<CartCellEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    
    var cancellables: Set<AnyCancellable> = []

    private let productImageView = WebImageView()
    
    private let modelName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "MarkPro-Medium", size: 20)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "MarkPro-Medium", size: 20)
        label.textColor = .orangeColor
        return label
    }()
    
    private let stepper = CombineStepper()
    private let deleteButton = UIButton(image: "delete", imageColor: #colorLiteral(red: 0.3431054292, green: 0.3447591231, blue: 0.4955973926, alpha: 1))
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .blackTextColor
        clipsToBounds = false
        productImageView.contentMode = .scaleAspectFill
       // stepper.delegate = self
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        setupConstraints()
        
        stepper.countChangedPublisher.sink { [weak self] count in
            self?.eventSubject.send(.quantityChanged(value: count))
        }
        .store(in: &stepper.cancellables)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        cancellables = Set<AnyCancellable>()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        productImageView.clipsToBounds = true
        productImageView.layer.cornerRadius = 10

    }
    

    func configure(with cartCellItem: CartCellViewModel) {
        productImageView.set(imageURL: cartCellItem.images)
        priceLabel.text = cartCellItem.formattedPrice
        modelName.text = cartCellItem.title
        stepper.configure(with: cartCellItem.count)
    }
    
    @objc private func deleteTapped() {
        eventSubject.send(.deleteItem)
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
