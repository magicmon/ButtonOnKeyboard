//
//  ButtonOnKeyboard.swift
//  ButtonOnKeyboard
//
//  Created by magicmon on 2020/10/07.
//

import UIKit

@available(iOS 11.0, *)
extension UIView {
    static var buttonOnKeyboardDefaultHeight: CGFloat = 0.0
    public var bk_defaultButtonHeight: CGFloat {
        get { return UIButton.buttonOnKeyboardDefaultHeight }
        set {
            UIButton.buttonOnKeyboardDefaultHeight = newValue
            bk_onKeyboard()
        }
    }
    
    private var safeAreaBottom: CGFloat {
        if let window = UIApplication.shared.windows.first {
            return window.frame.height - window.safeAreaLayoutGuide.layoutFrame.height - window.safeAreaLayoutGuide.layoutFrame.minY
        }
        
        return 0.0
    }
    
    
    public func bk_onKeyboard(scrollView: UIScrollView? = nil, keyboardHeight: CGFloat = 0) {
        guard let bottomConstraint = self.findConstraint(layoutAttribute: .bottom),
            let heightConstraint = findHeightConstraint() else { return }
        
        
        var isOnTheSuperView: Bool = self.superview?.isEqual(bottomConstraint.firstItem) == true
        var currentButtonHeight: CGFloat = self.frame.height
        if UIButton.buttonOnKeyboardDefaultHeight > 0 {
            currentButtonHeight = UIButton.buttonOnKeyboardDefaultHeight
        } else {
            currentButtonHeight = self.frame.height
            isOnTheSuperView = false
        }
        
        UIView.animate(withDuration: 0.23, animations: { [weak self] in
            guard let `self` = self else { return }
            if keyboardHeight > 0 {
                bottomConstraint.constant = keyboardHeight - (isOnTheSuperView ? 0 : self.safeAreaBottom)
                heightConstraint.constant = currentButtonHeight

                scrollView?.contentInset.bottom = keyboardHeight + UIButton.buttonOnKeyboardDefaultHeight
                scrollView?.scrollIndicatorInsets.bottom = keyboardHeight  + UIButton.buttonOnKeyboardDefaultHeight
            } else {
                bottomConstraint.constant = 0
                heightConstraint.constant = currentButtonHeight + (isOnTheSuperView ? self.safeAreaBottom : 0)
                
                scrollView?.contentInset.bottom = 0
                scrollView?.scrollIndicatorInsets.bottom = 0
            }
            self.superview?.layoutIfNeeded()
        }, completion: nil)
    }
}

// MARK: - Extension for Constraint
extension UIView {
    private func findConstraint(layoutAttribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        for constraint in (superview?.constraints ?? []) where itemMatch(constraint: constraint, layoutAttribute: layoutAttribute) {
            return constraint
        }
        
        return nil
    }
    
    private func itemMatch(constraint: NSLayoutConstraint, layoutAttribute: NSLayoutConstraint.Attribute) -> Bool {
        let firstItemMatch = constraint.firstItem as? UIView == self && constraint.firstAttribute == layoutAttribute
        let secondItemMatch = constraint.secondItem as? UIView == self && constraint.secondAttribute == layoutAttribute
        return firstItemMatch || secondItemMatch
    }
    
    private func findHeightConstraint() -> NSLayoutConstraint? {
        return constraints.last(where: {
            $0.firstItem as? UIView == self && $0.firstAttribute == .height && $0.relation == .equal
        })
    }
}
