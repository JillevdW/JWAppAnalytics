This package is part of a group that, when installed together, will allow for easy self-hosted mobile app analytics. Without a backend counterpart, this package doesn't do anything.



## Basic installation

Add the following line to your `Podfile`:

```ruby
pod 'JWAppAnalytics', :git => 'https://github.com/JillevdW/JWAppAnalytics.git', :tag=> '0.2.2'
```

The pod should now be installed the next time you run `pod install` in the root directory of your project.

Once you've successfully installed the package, import `JWAppAnalytics` in your `AppDelegate` class.

Then, add the following lines to the `application(_:didFinishLaunchingWithOptions:)` function:

```swift
AnalyticsService.shared.setup(withUrl: "http://127.0.0.1:8000")

// This triggers an event you should have registered in your backend. It's always nice to register an 'open_app' event.
AnalyticsService.shared.trigger(event: "open_app")
```



To enable the tracking of user sessions in your app you'll need to pass `true` to the `userJourneyEnabled` parameter of the `setup` function:

```swift
AnalyticsService.shared.setup(withUrl: "http://127.0.0.1:8000", userJourneyEnabled: true)
```

You'll also need to add the following code inside your `AppDelegate` class:

```swift
func applicationDidEnterBackground(_ application: UIApplication) {
    AnalyticsService.shared.didEnterBackground()
    // other code
}

func applicationWillEnterForeground(_ application: UIApplication) {
    AnalyticsService.shared.willEnterForeground()
    // other code
}
```
