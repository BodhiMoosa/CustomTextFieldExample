//
//  CustomTextFieldContainerView.swift
//  CustomTextFieldExample
//
//  Created by Tayler Moosa on 6/25/20.
//  Copyright © 2020 Tayler Moosa. All rights reserved.
//

import UIKit
enum UnderlineType {
    case line
}
enum TextFieldAlignment {
    case center
    case left
    case right
}
class CustomTextFieldContainerView: UIView {
    
    private var lineHeightAnchor                : NSLayoutConstraint!
    private var placeHolderLeadingAnchor        : NSLayoutConstraint!
    private var placeHolderTrailingAnchor       : NSLayoutConstraint!
    
    private let bottomLine                      = UIView()
    private let textField                       = UITextField()
    private let label                           = UILabel()
    var title : String                  = "" {
        didSet {
            label.text                  = title
        }
    }
    private var originalPosition                : CGRect!
    private var isEmpty                         = true
    var accentColor : UIColor           = UIColor.label {
        didSet {
            label.textColor             = accentColor
            bottomLine.backgroundColor  = accentColor
        }
    }
    private var inputFieldHeight                : CGFloat  = 30
    var placeholderColor                : UIColor = .systemGray2 {
        didSet {
            label.textColor = placeholderColor
        }
    }
    var lineWidth             : CGFloat = 1 {
        didSet {
            lineHeightAnchor.isActive   = false
            lineHeightAnchor            = nil
            lineHeightAnchor            = bottomLine.heightAnchor.constraint(equalToConstant: lineWidth)
            lineHeightAnchor.isActive   = true
            updateConstraintsIfNeeded()
        }
    }
    
    var underlineStyle                  : UnderlineType? {
        didSet {
            switch underlineStyle {
            case .line:
                bottomLine.alpha = 1
            case .none:
                bottomLine.alpha = 0                
            }
        }
    }
    
    var textFieldBackgroundColor        : UIColor? {
        didSet {
            textField.backgroundColor = textFieldBackgroundColor
        }
    }
    
    private var labelXPosition                  : CGFloat = -10
    private var labelTrailingConstant           : CGFloat = 0
    private var labelLeadingConstant            : CGFloat = 10
    
    var alignment  : TextFieldAlignment = .left {
        didSet {
            placeHolderTrailingAnchor.isActive  = false
            placeHolderLeadingAnchor.isActive   = false
            placeHolderTrailingAnchor           = nil
            placeHolderLeadingAnchor            = nil
            switch alignment {
            case .left:
                labelLeadingConstant            = 5
                labelTrailingConstant           = 0
                labelXPosition                  = -10
                label.textAlignment             = .left
                textField.textAlignment         = .left
            case .center:
                labelXPosition                  = 0
                labelTrailingConstant           = 0
                labelLeadingConstant            = 0
                label.textAlignment             = .center
                textField.textAlignment         = .center
            case .right:
                labelTrailingConstant           = -5
                labelLeadingConstant            = 0
                labelXPosition                  = 10
                label.textAlignment             = .right
                textField.textAlignment         = .right
            }
            placeHolderLeadingAnchor            = label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: labelLeadingConstant)
            placeHolderTrailingAnchor           = label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: labelTrailingConstant)
            placeHolderTrailingAnchor.isActive  = true
            placeHolderLeadingAnchor.isActive   = true
            updateConstraintsIfNeeded()
        }
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureTextField()
        configureTitleLabel()
        underline()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String, inputTextHeight: CGFloat, accentColor: UIColor) {
        super.init(frame: .zero)
        label.text          = title
        inputFieldHeight    = inputTextHeight
        self.accentColor    = accentColor
        configure()
        configureTextField()
        configureTitleLabel()
        underline()
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints   = false
        textField.font                              = textField.font?.withSize(inputFieldHeight * 0.6)
        label.font                                  = textField.font
    }
    
    
    private func configureTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate                                  = self
        addSubview(textField)
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            textField.heightAnchor.constraint(equalToConstant: inputFieldHeight),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func configureTitleLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment                             = .left
        label.textColor                                 = placeholderColor
        label.alpha                                     = 0.7
        addSubview(label)
        
        placeHolderLeadingAnchor    = label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: labelLeadingConstant)
        placeHolderTrailingAnchor   = label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: labelTrailingConstant)
        
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: inputFieldHeight),
            label.bottomAnchor.constraint(equalTo: textField.bottomAnchor)
        ])
        
        placeHolderTrailingAnchor.isActive  = true
        placeHolderLeadingAnchor.isActive   = true
    }
    
    func animate(isEmpty: Bool) {
        if self.isEmpty == isEmpty {
            return
        } else {
            self.isEmpty = isEmpty
        }
        
        if originalPosition == nil {
            originalPosition = self.label.frame
        }
        if !isEmpty {
            UIView.animate(withDuration: 0.1) {
                self.label.frame        = self.originalPosition.offsetBy(dx: self.labelXPosition, dy: -self.inputFieldHeight)
                self.label.textColor    = self.accentColor
                self.label.font         = self.label.font.withSize(self.label.font.pointSize * 0.7)
                self.label.alpha        = 1

            }
        } else {
            UIView.animate(withDuration: 0.1) {
                self.label.frame        = self.originalPosition
                self.label.textColor    = self.placeholderColor
                self.label.font         = self.textField.font
                self.label.alpha        = 0.7

            }
        }
    }
    
   private func underline() {
        bottomLine.translatesAutoresizingMaskIntoConstraints    = false
        bottomLine.backgroundColor                              = accentColor
        addSubview(bottomLine)
        lineHeightAnchor = bottomLine.heightAnchor.constraint(equalToConstant: lineWidth)

        NSLayoutConstraint.activate([
            bottomLine.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            bottomLine.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 1)
        ])
    lineHeightAnchor.isActive = true
    }
}

extension CustomTextFieldContainerView : UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
            if textField.text!.isEmpty {
                self.animate(isEmpty: true)
            } else {
                self.animate(isEmpty: false)
            }
        }
}
