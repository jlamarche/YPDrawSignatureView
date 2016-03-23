# Multicolor YPDrawSignatureView Fork

I could not find a good signature capturer iOS made in Swift, so I gave it a try. I leaned heavily on the blog entry [Capture a Signature on iOS](https://www.altamiracorp.com/blog/employee-posts/capture-a-signature-on-ios) by Jason Harwig, and [Macheads101](https://www.youtube.com/user/macheads101), he has a great [tutorial](https://www.youtube.com/watch?v=8KV1o9hPF5E&list=UU7fIuG6L5EPc9Ijq2_BCmIg) on YouTube.

## Fork
This fork adds support for multiple line colors and widths within one signature. While most applications will want signatures to be black, I needed a bit more flexibility for one app I'm working on and thought I'd make the changes available for anyone else who wants to use them.

The example app has been updated from the original to support very rudimentary color and line width changing. Very little has changed in terms of how the original view is used. The only real difference is that stroke color and line width now only apply to what you draw in the future, changing them doesn't change the color or size of what's already been drawn.

I've also removed the use of the `++` operator for forward compatibility, since it's being removed in Swift 3.0

## Swift 2.2

The class supports Swift 2.2

## Usage

Add a new `UIView` where you want the signature capture field. Set its class to `YPDrawSignatureView`, and connect it to an `@IBOutlet` property in your `UIViewController`. For saving and clearing the signature, add two buttons to your view controller. Hook each button up to an `@IBAction` function.

## Example Project

Check out the example project for more information on how to save signatures and how to clear the signature view.

## Installation

Add YPDrawSignature.swift to your project

## Support and Issues

GitHub Issues are for filing bug reports and feature requests only. Use [StackOverflow](http://stackoverflow.com/search?q=YPDrawSignatureView) for support related questions and help.

## Original Author

Geert-Jan Nilsen ( gert@yuppielabel.com )
[Yuppielabel](http://yuppielabel.com)

## Contributors

[TyrantFox](https://github.com/TyrantFox).

[Jeff LaMarche](https://github.com/jlamarche).

## License

YPDrawSignatureView is available under the MIT license. See the LICENSE file for more info. Feel free to fork and modify.
