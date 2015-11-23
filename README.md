# Turms

Turms is a limited port of TSMessages to Swift

At present, it supports only the "over navigation bar" style.

## Requirements

- iOS 9.0+
- Xcode 7.1+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate Turms into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'Turms', '~> 1.0'
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate Turms into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "unsignedapps/Turms" ~> 1.0
```

Run `carthage` to build the framework and drag the built `Turms.framework` into your Xcode project, then follow the [other instructions](https://github.com/Carthage/Carthage) to setup the remaining build steps.

## Usage

Some simple examples of Turms in use:

```swift
import Turms

MessageController.show(type: .Error, message: "This is a test error message.")

MessageController.show(type: .Success, title: "Title", subtitle: "Message Body", duration: .Automatic, dismissible: true)
```

## License

Turms is released under a MIT license. See the `LICENSE` file for more.