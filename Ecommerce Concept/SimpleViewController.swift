//
//  SimpleViewController.swift
//  EcommerceConcept
//
//  Created by Артём on 04.12.2022.
//

import UIKit

class SimpleViewController: UIViewController {

    lazy var filterView = FilterView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        setupNavigationBar()

        // Do any additional setup after loading the view.
    }
    
    private func setupNavigationBar() {
        let button = UIBarButtonItem(image: UIImage(named: "filter"), style: .plain , target: self, action: #selector(filterTapped))
        button.tintColor = #colorLiteral(red: 0.00884380471, green: 0.02381574176, blue: 0.1850150228, alpha: 1)
        navigationItem.rightBarButtonItem = button
        filterTapped()
    }
    
    @objc func filterTapped() {
        
        filterView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterView)
        
        NSLayoutConstraint.activate([
            filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            filterView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
       
        ])
    }

}
