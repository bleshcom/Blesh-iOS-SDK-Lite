# Blesh iOS SDK-Lite 5 Developer Guide

**Version:** *5.0.0*

This document describes integration of the Blesh iOS SDK-Lite with your iOS application.

## Introduction

Blesh iOS SDK-Lite collects location information from a device on which the iOS application is installed. Blesh Ads Platform uses this data for creating and enhancing audiences, serving targeted ads, and insights generation.

> **Note:** Lite edition of the Blesh iOS SDK does not display ads. Its primary use-cases are enhancing audiences and aiding insights generation.

## Changelog

  * **5.0.0** *(Released 11/26/2019)*
    * Added initialization support
    * Added callback handler for handling changes in the location permission
    * Supported server-side HTTP compression
    * Compiled as a Mac-O Universal binary

## Requirements

In order to integrate the Blesh iOS SDK-Lite make sure you are:

  * Targeting iOS version 9 or higher
  * Targeting the Swift 4.2.1 compiler
  * Using an iOS device compatible with Bluetooth 4.0 *(Optional. Required for supporting Blesh Beacon Detection)*
  * Registered on the *Blesh Publisher Portal*
    * You may need to create a *Blesh Ads Platform Access Key* for the iOS platform

> **Note:** Make sure that you declare that "your app uses IDFA" on App Store Connect. Otherwise, your app may be rejected on review. Blesh iOS SDK-Lite collects IDFA from the device, in full compliance with the Apple [requirements](https://support.apple.com/en-us/HT205223).

## Integration

### 1. Adding the Blesh iOS SDK-Lite

The Blesh iOS SDK-Lite can be added either by using CocoaPods or manually.

#### 1.1. Adding the Blesh iOS SDK-Lite with CocoaPods

Referencing the `BleshSDKLite` pod with version `5.0.0` in the `Podfile` will be sufficient to add the Blesh iOS SDK to your project.

**Steps to add:**

1. If your project doesn't have a `Podfile` then you can create one by running the following command on the terminal:

```bash
pod init
```

2. Reference `BleshSDKLite` in the `Podfile`:

```podspec
target 'YOUR_APPLICATION_NAME' do

  # ... beginning of your Podfile ...

  pod 'BleshSDKLite', :git => 'https://github.com/bleshcom/Blesh-iOS-SDK-Lite.git', :tag => '5.0.0' # this will reference the Blesh iOS SDK-Lite 5

  # ... remaining of your Podfile ...

end
```

> **Note:** Replace `YOUR_APPLICATION_NAME` with the name of your application in the `target` section

3. Install pods by running the following command on the terminal:

```bash
pod install
```

#### 1.2. Adding the Blesh iOS SDK-Lite Manually

1. Download the SDK

You can download the SDK from the following repository:

```
https://github.com/bleshcom/Blesh-iOS-SDK-Lite.git
```

To integrate a specific version of the SDK, a git revision with the tag for the desired version should be checked out.

2. Add `BleshSDKLite.framework` to your Xcode project

<div style="page-break-after: always;"></div>

### 2. Adding Frameworks

Blesh iOS SDK-Lite utilizes following frameworks. Please make sure that your project references all of them:

 * Foundation.framework
 * UIKit.framework
 * AdSupport.framework
 * CoreBluetooth.framework
 * CoreLocation.framework
 * CoreTelephony.framework
 * SystemConfiguration.framework

### 3. Reviewing Permissions

In order to provide proper notifications and proper beacon tracking, you need to get some permission from the application user, after your application is installed. Per iOS User guides, applications can ask for required permissions with their own sentences. The permissions can be configured in `Info.plist` file.

Blesh iOS SDK uses iBeacon protocol which requires location permission by default. Blesh iOS SDK needs to detect beacons and geofences even when the app is at background or killed. Therefore you have to ask for *"Always usage of location"* to your users.

Until iOS 11, when the users give permission for location usage, it was considered as *"Always"* and applications could use the location when they are killed or at background.

After iOS 11, the rules have changed and users were able to give location usage permission only when the application is in use. As a result, for iOS v11 and later, applications have to ask for two different types of location permissions: `WhenInUse` or `AlwaysAndWhenInUse`.

For backward compatibility, your application should include all three descriptors given below for location permission:

 * NSLocationAlwaysAndWhenInUseUsageDescription
 * NSLocationWhenInUseUsageDescription
 * NSLocationAlwaysUsageDescription

In the description field of location permission entries, we recommend you to encourage your users to allow *"Always use my location"*, in order to have a better performance of the system. In the below subsections, we provide some sample description text. Please check and consider them.

Please note that, with iOS version 11, applications must include all of the below 3 descriptors in their `Info.plist` file for backward compatibility with older OS versions.

1. **Always And When In Use**

This descriptor is used for iOS 11 and later. Provides permission for both when in use and when killed.

Sample Text: *"This application uses your location in order to inform you about interesting offers nearby. We advice you to choose Always option to get the offers even when you are not using the application!"*

<div style="page-break-after: always;"></div>

You can insert it into your `Info.plist` file in the following syntax.

```xml
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string><# insert always and when in use usage description text #></string>
```

2. **Always**

This descriptor is used for iOS 10 and before versions. Provides permission for both when in use and when killed.

Sample Text: *"This application uses your location in order to inform you about interesting offers nearby. We advice you to choose Always option to get the offers even when you are not using the application!"*

You can insert it into your `Info.plist` file in the following syntax.

```xml
<key>NSLocationAlwaysUsageDescription</key>
<string><# insert always usage description text #></string>
```

3. **When In Use**

This descriptor is used in all iOS versions. Provides permission for only when the application is in use. We advice you to warn your users about very low performance on receiving nearby offers.

Sample Text: *“This application uses your location in order to inform you about interesting offers nearby. Allowing location when in use only may result in poor performance in finding nearby offers!”*

You can insert it into your `Info.plist` file in the following syntax.

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string><# insert when in use usage description text #></string>
```

## Usage

In order to utilize capabilities of the Blesh iOS SDK-Lite, it needs to be started at some point of your application's lifecycle.

You can either create & manage a new instance of `BleshSDK` or you can access the `BleshSDK` singleton instance through `BleshSDK.SharedInstance`.

### 1. Starting the Blesh iOS SDK-Lite

In order to continue to receive notifications even when the app is **killed/not running in the background**, invoking `start` method should not require the application to be in the foreground. Please note that best practice is starting Blesh under **applicationDidFinishLaunchingWithOptions** in the app delegate.

<div style="page-break-after: always;"></div>

#### Swift

`BleshSDK` contains following overrides of the `start` method:

```swift
Void start(withSecretKey: string)

Void start(withSecretKey: string, completion: ((Bool) -> Void))

Void start(withSecretKey: string, withConfiguration: BleshSdkConfiguration)

Void start(withSecretKey: string, withConfiguration: BleshSdkConfiguration, completion: ((Bool) -> Void))

Void start(withSecretKey: string, withApplicationUser: BleshSdkApplicationUser)

Void start(withSecretKey: string, withApplicationUser: BleshSdkApplicationUser, completion: ((Bool) -> Void))

Void start(withSecretKey: string, withApplicationUser: BleshSdkApplicationUser, withConfiguration: BleshSdkConfiguration)

Void start(withSecretKey: string, withApplicationUser: BleshSdkApplicationUser, withConfiguration: BleshSdkConfiguration, completion: ((Bool) -> Void))
```

* The first parameter for the `start` method is always the **Blesh Ads Platform Access Key**. You may need to create one for the iOS platform at the *Blesh Publisher Portal*. If you do not have an account at the *Blesh Publisher Portal* please contact us at technology@blesh.com.

* `completion` parameter allows you to execute your business logic after the Blesh iOS SDK-Lite initialization is succeeded or failed.

* `withConfiguration` parameter allows you to configure the behaviour of the Blesh iOS SDK-Lite. The `BleshSdkConfiguration` class contains the following:

| Property   | Type | Description                                                                       | Example |
|------------|------|-----------------------------------------------------------------------------------|---------|
| TestMode   | Bool | Use the SDK in the test mode (true) or use the SDK in the production mode (false) | false   |

> **Note:** `TestMode` is off by default. You can enable this mode during your integration tests. Production environment will not be effected when this flag is set to `true`.

<div style="page-break-after: always;"></div>

* `withApplicationUser` parameter allows you to enchance the audience data by providing information about the primary user (subscriber) of your application. You can give any information which makes the subscriber unique in your application's understanding. The `BleshSdkApplicationUser` class contains the following:

| Property    | Type                     | Description                                  | Example              |
|-------------|--------------------------|----------------------------------------------|----------------------|
| UserId      | String?                  | Optional unique identifier of the user       | 42                   |
| Gender      | NSNumber?                  | Optional gender of the user (0 for female or 1 for male) | 0               |
| YearOfBirth | Int?                     | Optional year of birth of the user           | 1999                 |
| Email       | String?                  | Optional email address of the user           | jane.doe@example.com |
| PhoneNumber | String?                  | Optional mobile phone number of the user     | +905550000000        |
| Other       | Dictionary<String, String>? | Optional extra information for the user      | nil                  |

> **Note:** `Email` and `PhoneNumber` details are never sent in plain-text to the *Blesh Ads Platform*. These values are always irreversibly hashed so that no personally identifiable information is stored.

##### Example: Simple Initialization (Singleton)

You can start the Blesh iOS SDK-Lite by simply providing the *Blesh Ads Platform Access Key*:

```swift
BleshSDK.SharedInstance.start(withSecretKey: "YOUR-SECRET-KEY-HERE")
```

##### Example: Simple Initialization

You can start the Blesh iOS SDK-Lite by simply providing the *Blesh Ads Platform Access Key*:

```swift
let bleshSdk = BleshSDK()

bleshSdk.start(withSecretKey: "YOUR-SECRET-KEY-HERE")
```

<div style="page-break-after: always;"></div>

##### Example: Complete Initialization

```swift
let bleshSdkConfiguration = BleshSdkConfiguration(
	TestMode: false
)

let bleshSdkApplicationUser = BleshSdkApplicationUser(
	UserId: "42",
	Gender: 0,
	YearOfBirth: 1999,
	Email: "jane.doe@example.com",
	PhoneNumber: "+905550000000",
	Other: nil
)

BleshSDK.SharedInstance.start(
	withSecretKey: "YOUR-SECRET-KEY-HERE",
	withApplicationUser: bleshSdkApplicationUser,
	withConfiguration: bleshSdkConfiguration) {
		(isSuccessful: Bool) -> () in
		// ... INSERT BUSINESS LOGIC HERE ...
		NSLog(String(isSuccessful))
	}
```

<div style="page-break-after: always;"></div>

### 2. Notifying the Blesh iOS SDK-Lite About Changes in Permissions

Starting from Blesh iOS SDK 4.0.7, the SDK does not ask the user for permissions. Your application needs to ask location permissions. See "[Reviewing Permissions](#3-reviewing-permissions)" section for more information.

#### Swift

When the location permission changes, your application should call the `didChangeLocationAuthorization` method of `BleshSDK` with the new status.

**Example:**

```swift
import UIKit
import WebKit
import BleshSDKLite
import CoreLocation

class WebViewController: UIViewController, CLLocationManagerDelegate {
    var locationManager : CLLocationManager

    required init?(coder aDecoder: NSCoder) {
        self.locationManager = CLLocationManager()
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 10
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestLocation()

        // ... rest of the method ...
    }

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Notify the Blesh iOS SDK about the change here
        BleshSDK.SharedInstance.didChangeLocationAuthorization(status)
    }

    // ... rest of the controller ...
}
```
