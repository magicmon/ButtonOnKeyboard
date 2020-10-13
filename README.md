# ButtonOnKeyboard

[![CI Status](https://img.shields.io/travis/magicmon/ButtonOnKeyboard.svg?style=flat)](https://travis-ci.org/magicmon/ButtonOnKeyboard)
[![Version](https://img.shields.io/cocoapods/v/ButtonOnKeyboard.svg?style=flat)](https://cocoapods.org/pods/ButtonOnKeyboard)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](http://mit-license.org)
[![Platform](http://img.shields.io/badge/platform-iOS.svg?style=flat)](https://developer.apple.com/resources/)
[![Language](https://img.shields.io/badge/swift-5.0-orange.svg)](https://developer.apple.com/swift)


"ButtonOnKeyboard" is used when the button position must change depending on the keyboard.
Available in both basic and notch designs. It is also available for UIButton, as well as UIView.

## Getting Started

In viewDidLoad(), stores the default size of the button.
```swift
button.bk_defaultButtonHeight = 50  // example size.
```

Whenever the keyboard state changes, it calls button.bk_onKeyboard().
```swift
button.bk_onKeyboard(keyboardHeight: height)
```

If UITextField is not visible by UIButton, add the scrollView parameter to "bk_onKeyboard()".
```swift
button.bk_onKeyboard(scrollView: scrollView, keyboardHeight: height)
```
![Demo](https://raw.githubusercontent.com/magicmon/ButtonOnKeyboard/main/Screenshots/iphone_demo.gif)
![Demo2](https://raw.githubusercontent.com/magicmon/ButtonOnKeyboard/master/Screenshots/iphone_x_demo.gif)

### Example
```swift
override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    
    button.bk_defaultButtonHeight = buttonHeightConstraint.constant  // Stores the default size of the button.
}

@objc func keyboardWillShow(_ notification: Notification) {
    var visibleHeight: CGFloat = 0
     
    if let userInfo = notification.userInfo {
        if let windowFrame = UIApplication.shared.keyWindow?.frame,
            let keyboardRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            visibleHeight = windowFrame.intersection(keyboardRect).height
        }
    }
    
    updateButtonLayout(height: visibleHeight)
}
 
@objc func keyboardWillHide(_ notification: Notification) {
    updateButtonLayout(height: 0)
}

func updateButtonLayout(height: CGFloat) {
    button.bk_onKeyboard(scrollView: scrollView, keyboardHeight: height)
}
```

## Requirements

* Swift 5.0
* iOS 11.0+


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

ButtonOnKeyboard is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ButtonOnKeyboard'
```

## Author

magicmon, sagun25si@gmail.com

## License

ButtonOnKeyboard is available under the MIT license. See the LICENSE file for more info.
