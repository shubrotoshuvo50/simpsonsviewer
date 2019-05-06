//
//  LoaderView.swift
//  simpsonsviewer
//
//  Created by IMCS2 on 5/5/19.
//  Copyright © 2019 Shubroto. All rights reserved.
//

import UIKit

class LoaderView: UIView {
    
    var textLabel: UILabel = {
        let label = UILabel()
        label.text = "Default Text"
        label.textAlignment = .center
        return label
    }()
    
    var enableSpinner: Bool = false {
        didSet {
            spinnerAction()
        }
    }
    
    private var stackView: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    private var spinnerView: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .gray)
        return activity
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(stackView)
        // Add Constraint to Stack View
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0)
            ])
        stackView.addArrangedSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Attach this view to the parent view with all necessary constraints
    func setUpView(parentView: UIView, message: String){
        parentView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: parentView.topAnchor, constant: 0),
            self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: 0),
            self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 0),
            self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: 0)
            ])
        textLabel.text = message
    }
    
    // Add or remove spinner view
    private func spinnerAction() {
        if enableSpinner { // Enable Spinner is true
            spinnerView.startAnimating()
            stackView.insertArrangedSubview(spinnerView, at: 0)
        } else {
            spinnerView.removeFromSuperview()
        }
    }
    
}
