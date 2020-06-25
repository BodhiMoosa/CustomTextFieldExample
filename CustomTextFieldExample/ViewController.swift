//
//  ViewController.swift
//  CustomTextFieldExample
//
//  Created by Tayler Moosa on 6/25/20.
//  Copyright © 2020 Tayler Moosa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var customTextObject : CustomTextFieldContainerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureAdditionalSettings()
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        customTextObject = CustomTextFieldContainerView(title: "Placeholder Text", inputTextHeight: 30, accentColor: .red)
        view.addSubview(customTextObject)
        NSLayoutConstraint.activate([
            customTextObject.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            customTextObject.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            customTextObject.heightAnchor.constraint(equalToConstant: 75),
            customTextObject.topAnchor.constraint(equalTo: view.topAnchor, constant: 50)
        ])
        
    }
    
    private func configureAdditionalSettings() {
        customTextObject.alignment                  = .center
        customTextObject.textFieldBackgroundColor   = .systemGray3
        customTextObject.lineWidth                  = 2
        customTextObject.placeholderColor           = .blue
    }


}

