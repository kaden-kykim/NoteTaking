//
//  StackView.swift
//
//  Created by Derrick Park on 2019-05-30.
//  Modified by Kaden Kim on 2020-10-21.
//

import UIKit

class StackView: UIStackView {
    
    convenience init(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill) {
        self.init(arrangedSubviews: arrangedSubviews, axis: axis, spacing: spacing, alignment: alignment, distribution: .fill)
    }
    
    convenience init(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat = 0, distribution: UIStackView.Distribution = .fill) {
        self.init(arrangedSubviews: arrangedSubviews, axis: axis, spacing: spacing, alignment: .fill, distribution: distribution)
    }
    
    convenience init(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat = 0) {
        self.init(arrangedSubviews: arrangedSubviews, axis: axis, spacing: spacing, alignment: .fill, distribution: .fill)
    }
    
    init(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        arrangedSubviews.forEach { addArrangedSubview($0) }
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = distribution
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
