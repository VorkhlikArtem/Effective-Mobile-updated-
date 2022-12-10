//
//  FilterView.swift
//  EcommerceConcept
//
//  Created by Артём on 04.12.2022.
//

import UIKit

protocol FilterViewDelegate: AnyObject {
    func removeViewFromSuperview(_ filterView: UIView)
}

class FilterView: UIView {
    
    let filterOptions = FilterOption.allCases
    
    let filterOptionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = 20
        return stackView
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "cross"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .blackTextColor
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "MarkPro-Medium", size: 18)
        label.text = "Filter options"
        label.textColor = .blackTextColor
        return label
    }()
    
    let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = UIFont(name: "MarkPro-Medium", size: 18)
        button.backgroundColor = .orangeColor
        return button
    }()
    
    weak var delegate: FilterViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        fillupStackView()
        setupConstraints()
        addGesture()
        dismissButton.addTarget(self, action: #selector(dismissFilterView), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(dismissFilterView), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.clipsToBounds = true
        self.layer.cornerRadius = 30
        dismissButton.clipsToBounds = true
        dismissButton.layer.cornerRadius = 10
        doneButton.clipsToBounds = true
        doneButton.layer.cornerRadius = 10
    }
    
    @objc func dismissFilterView() {
        postNotification()
        delegate?.removeViewFromSuperview(self)
    }
    
    func fillupStackView() {
        filterOptions.forEach { filterOption in
            let textFieldForm = FilterTextFieldFormStackView(title: filterOption.title , filterOptionItems: filterOption.descriptions )
            filterOptionsStackView.addArrangedSubview(textFieldForm)
        }
    }
    
    // MARK: - Setup Constraints
    
    func setupConstraints() {
        self.addSubview(dismissButton)
        NSLayoutConstraint.activate([
            dismissButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 44),
            dismissButton.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            dismissButton.heightAnchor.constraint(equalToConstant: 37),
            dismissButton.widthAnchor.constraint(equalToConstant: 37)
        ])
        
        self.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor) ,
            titleLabel.centerYAnchor.constraint(equalTo: dismissButton.centerYAnchor)
        ])
        
        self.addSubview(doneButton)
        NSLayoutConstraint.activate([
            doneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            doneButton.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            doneButton.heightAnchor.constraint(equalToConstant: 37),
            doneButton.widthAnchor.constraint(equalToConstant: 86)

        ])
        
        self.addSubview(filterOptionsStackView)
        NSLayoutConstraint.activate([
            filterOptionsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 46),
            filterOptionsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -31),
            filterOptionsStackView.topAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: 30),
            filterOptionsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
  
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Adding Gestures
    func addGesture() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(postNotification)))
    }
    
    @objc func postNotification() {
        NotificationCenter.default.post(name: .hideFilterTables, object: nil)
    }
    
}

