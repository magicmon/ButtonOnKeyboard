//
//  ButtonOnKeyboard.swift
//  ButtonOnKeyboard
//
//  Created by magicmon on 2020/10/07.
//

import UIKit
extension UIApplication {
    var keyWindowInConnectedScenes: UIWindow? {
        return windows.first(where: { $0.isKeyWindow })
    }
}

@available(iOS 11.0, *)
extension UIButton {
    public func buttonOnKeyboard(scrollView: UIScrollView? = nil,
                                 defaultButtonHeight: CGFloat = 0,
                                 keyboardHeight: CGFloat = 0) {
        guard let bottomConstraint = self.findConstraint(layoutAttribute: .bottom),
            let heightConstraint = findHeightConstraint() else { return }
        
        var safeAreaBottom: CGFloat {
            if let window = UIApplication.shared.keyWindow {
                return window.safeAreaInsets.bottom
            }
            
            return 0.0
        }
        let isOnTheSuperView = self.superview?.isEqual(bottomConstraint.firstItem) == true
        
        let currentButtonHeight = defaultButtonHeight > 0 ? defaultButtonHeight : self.frame.height
        
        UIView.animate(withDuration: 0.23, animations: { [weak self] in
            guard let `self` = self else { return }
            if keyboardHeight > 0 {
                bottomConstraint.constant = keyboardHeight - (isOnTheSuperView ? 0 : safeAreaBottom)
                heightConstraint.constant = currentButtonHeight

                scrollView?.contentInset.bottom = keyboardHeight - safeAreaBottom
                scrollView?.scrollIndicatorInsets.bottom = keyboardHeight - safeAreaBottom
            } else {
                bottomConstraint.constant = 0
                heightConstraint.constant = currentButtonHeight + (isOnTheSuperView ? safeAreaBottom : 0)
                
                scrollView?.contentInset.bottom = 0
                scrollView?.scrollIndicatorInsets.bottom = 0
            }
            self.superview?.layoutIfNeeded()
        }, completion: nil)
    }
}

// MARK: - Extension for Constraint
extension UIView {
    func findConstraint(layoutAttribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        for constraint in (superview?.constraints ?? []) where itemMatch(constraint: constraint, layoutAttribute: layoutAttribute) {
            return constraint
        }
        
        return nil
    }
    
    func itemMatch(constraint: NSLayoutConstraint, layoutAttribute: NSLayoutConstraint.Attribute) -> Bool {
        let firstItemMatch = constraint.firstItem as? UIView == self && constraint.firstAttribute == layoutAttribute
        let secondItemMatch = constraint.secondItem as? UIView == self && constraint.secondAttribute == layoutAttribute
        return firstItemMatch || secondItemMatch
    }
    
    func findHeightConstraint() -> NSLayoutConstraint? {
        return constraints.last(where: {
            $0.firstItem as? UIView == self && $0.firstAttribute == .height && $0.relation == .equal
        })
    }
}
