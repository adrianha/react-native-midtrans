# @adrianha/react-native-midtrans

## Getting started

`$ npm install @adrianha/react-native-midtrans --save`

### Mostly automatic installation

`$ react-native link @adrianha/react-native-midtrans`

### Manual installation

#### iOS using Cocoapods

1. Add `pod 'ReactNativeMidtrans', :path => '../node_modules/@adrianha/react-native-midtrans'` on your `Podfile`
2. Run `pod install`
3. Run your project (`Cmd+R`)

#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `@adrianha/react-native-midtrans` and add `ReactNativeMidtrans.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libReactNativeMidtrans.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)

#### Android

1. Open up `android/build.gradle`

- Add `maven { url "http://dl.bintray.com/pt-midtrans/maven" }` on `allproject.repositories` scope
- Add `maven { url "https://jitpack.io" }` on `allproject.repositories` scope

2. Open up `android/app/src/main/java/[...]/MainApplication.java`

- Add `import com.adrianha.midtrans.ReactNativeMidtransPackage;` to the imports at the top of the file
- Add `new ReactNativeMidtransPackage()` to the list returned by the `getPackages()` method

3. Append the following lines to `android/settings.gradle`:
   ```
   include ':@adrianha/react-native-midtrans'
   project(':@adrianha/react-native-midtrans').projectDir = new File(rootProject.projectDir, 	'../node_modules/@adrianha/react-native-midtrans/android')
   ```
4. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
   ```
   implementation project(':@adrianha/react-native-midtrans')
   ```

## Usage

1. Create Midtrans instance

```javascript
import Midtrans from '@adrianha/react-native-midtrans';

const midtrans = new Midtrans({
  clientKey: 'CLIENT_KEY',
  baseUrl: 'BASE_URL',

  /** iOS only: Midtrans.ENVIRONMENT_SANDBOX | Midtrans.ENVIRONMENT_PRODUCTION */
  environment: Midtrans.ENVIRONMENT_SANDBOX,

  /** android only */
  colorTheme: {
    primaryColor: '#000000',
  },
});
```

2. Pay with SNAP token

```javascript
try {
  const result = await midtrans.startPaymentWithSnapToken('SNAP_TOKEN');
  console.log({ result });
} catch (e) {
  console.log(e);
}
```
