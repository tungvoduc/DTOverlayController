# DTOverlayController

[![CI Status](https://img.shields.io/travis/tungvoduc/DTOverlayController.svg?style=flat)](https://travis-ci.org/tungvoduc/DTOverlayController)
[![Version](https://img.shields.io/cocoapods/v/DTOverlayController.svg?style=flat)](https://cocoapods.org/pods/DTOverlayController)
[![License](https://img.shields.io/cocoapods/l/DTOverlayController.svg?style=flat)](https://cocoapods.org/pods/DTOverlayController)
[![Platform](https://img.shields.io/cocoapods/p/DTOverlayController.svg?style=flat)](https://cocoapods.org/pods/DTOverlayController)

## Screenshots
|<img src="Screenshots/screenshot.gif" width="300">|<img src="Screenshots/screenshot.png" width="300">|

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage
To present a view controller inside an over lay controller, simply do in your view controller:

```swift
let overlayController = DTOverlayController(viewController: viewController)
present(overlayController, animated: true, completion: nil)

```

There are other properties that you can use to customize your over lay controller. These are some of them:

```swift
let overlayController = DTOverlayController(viewController: viewController)

// View controller is automatically dismissed when you release your finger
overlayController.dismissableProgress = 0.4

// Enable/disable pan gesture
overlayController.isPanGestureEnabled = false

// Update top-left and top-right corner radius
overlayController.overlayViewCornerRadius = 10

// Control the height of the view controller
overlayController.overlayHeight = .dynamic(0.8) // 80% height of parent controller
overlayController.overlayHeight = .static(300) // fixed 300-point height
overlayController.overlayHeight = .inset(50) // fixed 50-point inset from top

```

You can check more of these configurations in the library. `DTOverlayController`
will be further developed and new features will be coming in next releases. Feel free to contribute or suggest improvements by creating issues.

## Requirements
- iOS 9.0+

## Installation

DTOverlayController is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'DTOverlayController'
```

## Author

tungvoduc, tung98.dn@gmail.com

## License

DTOverlayController is available under the MIT license. See the LICENSE file for more info.
