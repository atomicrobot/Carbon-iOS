# AR Demo
"AR Demo" is a sample project used to demonstrate a clean architecture pattern that we, as a company, should strive to build. This project is meant to be continually evolving, but the goals should not change: create highly scalable code that is clean, easy to read and understand, easily maintainable, implemented using iOS best practices, and demonstrates our expertise in the industry building iOS applications.

## What does the app do?
At a very high level, this sample app utilizes the [GitHub API](https://docs.github.com/en/rest) to fetch a list of repositories for the [Atomic Robot](https://github.com/atomicrobot/) organization. The list is displayed and a user can tap a repo to view a list of commits. From there they can dig down into the commit details.

## How do I use it?
Fire up Xcode and run the project! That it. There are [currently] no 3rd party dependencies.

## How does it do it?

### SwiftUI
[SwiftUI](https://developer.apple.com/xcode/swiftui/) has been in production versions of iOS for many years, and it is our belief that moving forward all projects should take advantage of this framework (where it makes sense to do so). This sample app was originally built using 100% pure SwiftUI for the view layer.

### Combine
Similarly to SwiftUI, [Combine](https://developer.apple.com/documentation/combine) has been in production iOS versions for the same amount of time and we believe it is mature enough to use in our apps where it makes sense. This sample app uses Combine to feed data from the view model back to the views using the Publisher/Subscriber model and SwiftUI features available right out of the box. The idea is to establish good patterns for using Combine.

### MVVM
This app utilizes a Model / View / ViewModel architecture, a common pattern seen in mature iOS apps. Keeping the Models and ViewModels separate from our View layer is important because it allows them to be tested independently.

### Unit Tests
We believe that unit tests are very important. When building new features, keep testing at the forefront of your mind as you write new code. Keep functions small and ensure they are only performing one operation. Unit test as much logic as possible. When writing new classes and functions, consider injecting dependencies rather than relying on member variables or global singletons. This can help very much with testing.

### Dependency Injection
You already know what this is. Or you should. If you don't, take a quick break and check [Wikipedia](https://en.wikipedia.org/wiki/Dependency_injection). Injecting dependencies into objects and/or functions will help with testability, and creates clean, well-structured code. In this sample app we use simple constructor-based injection. For example:
```
class ViewModel {
    private let manager: SomeManagerProtocol

    init(manager: SomeManager = SomeManager.sharedInstance) {
        self.manager = manager
    }

    func myAwesomeFunction() -> String { ... }
}
```
Here we allow default values for `SomeManager`, but while writing unit tests you may want to stub out the manager object so you can focus on testing your view model. In this case you could potentially create a new manager type that conforms to SomeManagerProtocol and inject that instead of using the default value.
```
class ViewModelTests: XCTestCase {
    func testMyAwesomeFunction() {
        // Inject the mock'ed manager into our view model
        let viewModel = MyViewModel(manager: MockManager())

        XCTAssertEqual("Some expected value", viewModel.myAwesomeFunction())
    }
}

// Create a stub to use for testing
class MockManager: SomeManagerProtocol {}
```

### Localization
Always localize any user-facing strings! It's far easier to build an app with localization from the beginning rather than having to retrofit everything when the stakeholders decide you are, in fact, building a global application.

### Swift Package Manager
We currently do not rely on any 3rd party packages in this sample app, but if you need to include something in your project we should use the SPM version.

### Custom Build Configurations
Xcode allows you to have multiple build configurations in your project, which is extremely helpful when you are testing and distributing your app. A common example is that you might want the following versions of your app:
- Debug (active development)
- Beta (ready for QA testing)
- Release (ready for App Store)

By creating `.xcconfig` files for each of these cases, you can easily change things like app name, bundle ID, and app icons. You can also have a base configuration file which will set some project defaults, but can be overridden for specific configs. For example, maybe your base bundle ID is `com.mycompany.testapp`, but you want to append `.dev` or `.beta` for the respective configs. Simply `#include` the base config file, then use `$(inherited)` to obtain the base value. Example:
```
#include "Base.xcconfig"

// com.mycompany.testapp.beta
PRODUCT_BUNDLE_IDENTIFIER = $(inherited).beta
```

If you don't need to override a value, just leave it in the base config file (no need to add it to the release/debug/beta versions). I found a really nice [tutorial](https://www.raywenderlich.com/21441177-building-your-app-using-build-configurations-and-xcconfig) that talks about these things that you may find useful.

A couple important takeaways on things that sucked up a bunch of my time:

1. Many of these build configuration values are hard coded in the Build Settings tab for your project. If you want to change them to use your `.xcconfig` files, you will need to change the defaults. Pressing `Delete` on the config option will give you the values inherited from your config files, which you should see reflected immediately.
1. If you change the `PRODUCT_MODULE_NAME` (which I changed from `AR Demo` to `ARDemo` because I didn't want any spaces in my `#include`), keep in mind that your module name MUST be different between targets. This means that your App target cannot have the same module name as your Tests target.
1. Values in your `.xcconfig` files only work if they are included in your `Info.plist` (newer Xcode versions don't actually have an `Info.plist` file in the project, so you will use the Info tab instead).

## Using .xcassets Asset Catalog
We should favor using Xcode's asset catalog for assets like colors and images until we find a strong argument against it. The asset catalog is a great tool provided for us right out of the box when using Xcode. It integrates nicely with SwiftUI and previews, there is built-in support for light/dark mode when adding color assets, and (best of all?) you can create colors using hex values! The asset catalog is also easily organized to keep your colors and images separate.

# Enhancements
Since this is a living, breathing project, there are always opportunities for enhancements. The original scope was intentionally kept tight, but below are some areas where things can be added and/or enhanced.
- More robust error handling and/or retry logic
- Pagination (as a complex use case of infinite scrolling)
- Search/filtering the lists (locally or query params)
- Launch screen
- UIKit bridging
- UI tests
- Deep linking
- Notifications (local and/or remote)
- Modules (SPM)
