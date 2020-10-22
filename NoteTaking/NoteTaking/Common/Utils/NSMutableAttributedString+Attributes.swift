//
//  NSMutableAttributedString+Attributes.swift
//  NoteTaking
//
//  Created by Kaden Kim on 2020-10-21.
//

import UIKit

extension NSMutableAttributedString {
    
    func alignTextAttachment(of width: CGFloat, range: NSRange) {
        beginEditing()
        enumerateAttribute(.attachment, in: range,
                           options: NSAttributedString.EnumerationOptions()) { (value, range, stop) in
            if let attachment = value as? NSTextAttachment,
               let image = attachment.image(forBounds: attachment.bounds, textContainer: NSTextContainer(), characterIndex: range.location) {
                let imageSize = image.size, ratio = width / imageSize.width
                attachment.bounds = .init(origin: .zero, size: .init(width: imageSize.width * ratio, height: imageSize.height * ratio))
            }
        }
        endEditing()
    }
    
    func setFont(_ font: UIFont, range: NSRange) {
        beginEditing()
        removeAttribute(.font, range: range)
        addAttribute(.font, value: font, range: range)
        endEditing()
    }
    
    func setFontWithoutTraits(_ font: UIFont, range: NSRange) {
        beginEditing()
        enumerateAttribute(.font, in: range) { (value, range, stop) in
            if let oldFont = value as? UIFont {
                removeAttribute(.font, range: range)
                addAttribute(.font, value: oldFont.copyTraits(to: font), range: range)
            }
        }
        endEditing()
    }
    
    func setFontColor(_ color: UIColor = UIColor.label, backgroundColor: UIColor? = UIColor.clear, range: NSRange) {
        beginEditing()
        removeAttribute(.foregroundColor, range: range)
        addAttribute(.foregroundColor, value: color, range: range)
        if let backgroundColor = backgroundColor {
            removeAttribute(.backgroundColor, range: range)
            addAttribute(.backgroundColor, value: backgroundColor, range: range)
        }
        endEditing()
    }
    
}
