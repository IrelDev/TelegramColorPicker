# TelegramColorPicker
Simple telegram style color picker build in swift

<p align="center">  
  <img src = "Assets/Demo.gif" /> <br>
  <img src = "https://img.shields.io/badge/platform-iOS%2010%2B%20%7C%20macOS%2010.15%2B-lightgrey" />
  <img src = "https://img.shields.io/badge/swift-5.0-orange.svg" />
  <img src = "https://img.shields.io/badge/license-MIT-blue.svg" />
  <img src = "https://img.shields.io/badge/cocoapods-✔-green.svg" />
  <img src = "https://img.shields.io/badge/pod-v1.0.1-green" \>
</p>

## Installation

### CocoaPods
[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. To integrate TelegramColorPicker into your project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'TelegramColorPicker', '~> 1.0.1'
```
After that use `pod install` command in your terminal.

### Manually
If you prefer not to use any dependency managers, you can integrate TelegramColorPicker into your project manually by copying `Sources` directory into your project.

## Usage

### Programmatically
Create TelegramColorPicker instance then add it as a subview.
```swift
let frame = CGRect(x: .zero, y: .zero, width: 400, height: 250)
let colorPicker = TelegramColorPicker(frame: frame)
addSubview(colorPicker)
```
### Storyboard
Drag `View` object from the object library and set `TelegramColorPicker` as a custom class in identity inspector.
Create and connect @IBOutlet with `TelegramColorPicker` type.

### Get color update
Use `getColorUpdate` function with your custom closure and don't forget to use `[weak self]` to avoid strong reference cycle.
```swift
getColorUpdate { [weak self] (_, color) in
           guard let newColor = color.newValue, let hexadecimalColor = newColor.toHex() else { return }
           self?.textLabel.text = hexadecimalColor
       }
```
## Example
This repository contains example where you can [see how](Example/QRCodeViewController.swift) TelegramColorPicker can be used for QRCode foreground color changing.

## License
TelegramColorPicker is available under the MIT license, see the [LICENSE](LICENSE) file for more information.
