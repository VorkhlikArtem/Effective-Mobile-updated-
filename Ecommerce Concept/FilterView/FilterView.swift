//
//  FilterView.swift
//  EcommerceConcept
//
//  Created by Артём on 04.12.2022.
//

import UIKit

class FilterView: UIView {
    
    let textFieldForm = FilterTextFieldFormStackView(title: "Model", filterOptions: ["ddd", "dddf"])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        setupConstraints()
        
    }
    
    func setupConstraints() {
        textFieldForm.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldForm)
        NSLayoutConstraint.activate([
           
            textFieldForm.centerYAnchor.constraint(equalTo: centerYAnchor),
           
            textFieldForm.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 46),
            textFieldForm.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -31)

        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - SwiftUI
import SwiftUI
struct FilterViewProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().ignoresSafeArea(.all).previewInterfaceOrientation(.portrait)
    }
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = UINavigationController(rootViewController: SimpleViewController())
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }

        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
    }
}
