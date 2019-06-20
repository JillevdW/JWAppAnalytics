This package is part of a group that, when installed together, will allow for easy self-hosted mobile app analytics. Without a [backend counterpart](https://github.com/JillevdW/app-analytics), this package doesn't do anything.



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



## Properties

Sometimes you want to send some other data to your backend, like whether the user has a subscription or not. This library allows for that through adding so called _properties_ to your session or your events.



##### Event properties

To add properties to your events you simply add the properties parameter when you trigger them:

```swift
AnalyticsService.shared.trigger(event: "logged_in", properties: [
  	"subscribed": false,
  	"username": username
])
```

Whenever you choose to send additional properties with an event, the library will automatically add some other information, like the locale, the device model and the iOS version.



##### Session properties

Adding properties to your session can be achieved by calling the `addSessionProperties` function. If you want to add some properties every session, make sure to call it in `applicationWillEnterForeground`, **AFTER** calling the `willEnterForeground` function:

```swift
func applicationWillEnterForeground(_ application: UIApplication) {
    AnalyticsService.shared.willEnterForeground()
  	AnalyticsService.shared.addSessionProperties(properties: [
    		"app_version": appVersion,
      	"username": username
  	])
}
```

You can add session properties at any moment in your app lifecycle by calling the `addSessionProperties` function, but remember that they will be reset when the app relaunches/reopens.