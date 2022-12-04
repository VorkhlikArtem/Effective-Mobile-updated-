//
//  FilterTextFieldFormStackView.swift
//  EcommerceConcept
//
//  Created by Артём on 04.12.2022.
//

import UIKit

class FilterTextFieldFormStackView : UIStackView {
    
    var tableHeightConstraint: NSLayoutConstraint?
    
    lazy var filteringTable: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain )
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .gray
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    let filterOptionTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "MarkPro-Medium", size: 18)
        label.textColor = .blackTextColor
        label.textAlignment = .left
        return label
    }()
    
    let filterTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: "MarkPro-Regular", size: 18)
        textField.textColor = .blackTextColor
        textField.borderStyle = .none
        textField.layer.borderColor = #colorLiteral(red: 0.8352296948, green: 0.8353304267, blue: 0.8351953626, alpha: 1)
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 1
        textField.leftViewMode = .always
        textField.leftView = .init(frame: CGRect(x: 0, y: 0, width: 14, height: 0))
        
        let revealTableButton: UIButton = {
            let button = UIButton(type: .system)
            button.setImage(UIImage(named: "downArrow"), for: .normal)
            button.addTarget(self, action: #selector(revealFilteringTable), for: .touchUpInside)
            return button
        }()
        textField.rightViewMode = .always
        textField.rightView = revealTableButton
        return textField
    }()
    
    @objc func revealFilteringTable() {
        
        filteringTable.translatesAutoresizingMaskIntoConstraints = false
        guard let superView = self.superview?.superview else {return}
        print(superView)
        superView.addSubview(filteringTable)
        NSLayoutConstraint.activate([
            filteringTable.topAnchor.constraint(equalTo: filterTextField.bottomAnchor, constant: 0),
            filteringTable.leadingAnchor.constraint(equalTo: filterTextField.leadingAnchor, constant: 0),
            filteringTable.trailingAnchor.constraint(equalTo: filterTextField.trailingAnchor, constant: 0),
            
        ])
        
        tableHeightConstraint = filteringTable.heightAnchor.constraint(equalToConstant: 0)
        tableHeightConstraint?.isActive = true
        
        
        tableHeightConstraint?.constant = 150
        UIView.animate(withDuration: 3, delay: 0, options: .curveEaseOut, animations: {
            
            superView.layoutIfNeeded()
        }, completion: nil)
        
        filteringTable.reloadData()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
      
        self.axis = .vertical
        self.distribution = .fill
        self.spacing = 5
        self.addArrangedSubview(filterOptionTitle)
        self.addArrangedSubview(filterTextField)
        
        filterTextField.translatesAutoresizingMaskIntoConstraints = false
        filterTextField.heightAnchor.constraint(equalToConstant: 37).isActive = true
        filterTextField.delegate = self
        
    }
    
    var filterOptions = [String]()
    
    convenience init(title: String, filterOptions: [String]) {
        self.init(frame: .zero)
        filterOptionTitle.text = title
        filterTextField.text = "none"
        
        self.filterOptions = ["filterOptions", "ddd", "www", "ttt"]

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        filteringTable.layer.cornerRadius = 5
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FilterTextFieldFormStackView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = filteringTable.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = filterOptions[indexPath.row]
        content.textProperties.color = .red
        content.textProperties.font = UIFont(name: "MarkPro-Regular", size: 16)!
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        filterTextField.text = filterOptions[indexPath.row]
        filteringTable.removeFromSuperview()
    }
}

extension FilterTextFieldFormStackView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        revealFilteringTable()
        return false
    }
}
