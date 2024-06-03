# PROJECT_NAME

[![Made with Supabase](https://supabase.com/badge-made-with-supabase-dark.svg)](https://supabase.com)

This project aims to build a scalable and powerful architecture for production-ready Flutter applications. The architecture will be designed to handle various aspects of app development, including UI/UX, state managment, data fetching, and more. By folowing best practices and utilizing efficient design patterns, the goal is to create a robust foundation that can easily adapt to changing requirements and scale with the growth of the application.

## Preview

<details>
    <summary>Screenshots</summary>
    <p float="left">
      <img src="https://github.com/Nika0000/SuperFrog/assets/72192978/ee0cd791-c34a-4127-a080-539633e93de9" alt="auth_dark" width="24%" />
      <img src="https://github.com/Nika0000/SuperFrog/assets/72192978/804d3dd1-6de8-4d5e-a790-f8789ad40d00" alt="home_dark" width="24%" />
      <img src="https://github.com/Nika0000/SuperFrog/assets/72192978/b4653f70-1631-4092-842a-fdb9b455f05c" alt="auth_light" width="24%" />
      <img src="https://github.com/Nika0000/SuperFrog/assets/72192978/65a2b5c8-9298-4f99-a49b-e63cf642e14e" alt="Image4" width="24%" />
    </p>
</details>

<details>
    <summary>Screenshots (web)</summary>
    <p float="left">
      <img src="https://github.com/Nika0000/SuperFrog/assets/72192978/e949dea8-d581-48fe-a255-1a930ccf62b4" alt="Image1" width="49%" />
      <img src="https://github.com/Nika0000/SuperFrog/assets/72192978/abfb900f-3da5-415a-82a5-7eba217474fb" alt="Image2" width="49%" />
    </p>
    <p float="left">
      <img src="https://github.com/Nika0000/SuperFrog/assets/72192978/78a713ff-0a3d-4aec-a905-27420d3fd65f" alt="Image3" width="49%" />
      <img src="https://github.com/Nika0000/SuperFrog/assets/72192978/821370fe-638d-451e-bd91-781b5b0496e4" alt="Image4" width="49%" />
    </p>
</details>


## Get Started

```sh
# Clone repo
git clone https://github.com/Nika0000/SuperFrog.git
cd SuperFrog

# Install all the required dependencies
flutter pub get

# Generate model, route, localization
flutter pub run build_runner build
```
Before running the application, you need to set up the environment configuration files.

Create `env.prod.json` for production and `env.dev.json` for development in the root directory of the project and add the following configuration:

```json
{
    "SUPABASE_URL": "your-supabase-url",
    "SUPABASE_ANON_KEY": "your-annon-key",
    "SUPABASE_BUCKET_NAME": "your-bucket-name",
    "GOOGLE_WEB_CLIENT_ID": "google-oauth-web",
    "GOOGLE_IOS_CLIENT_ID": "google-oauth-ios",
    "APPLE_CLIENT_ID": "apple-client-id",
    "TURNSTILE_SITE_KEY": "cloudflare-turnstile-site-key"
}
```

## Running

### Android / IOS / Web
```sh
# Debug
flutter run --debug --dart-define-from-file env.dev.json

# Release
flutter run --release --dart-define-from-file env.prod.json
```

## Building for Production

### Android
To build a signed release APK, you need to [sign your application](https://docs.flutter.dev/deployment/android#sign-the-app). Follow thoes steps:

1. Generate a Keystore:

    If you don`t have a keystore, generate one by running the following command in your terminal:
    ```sh
    keytool -genkey -v -keystore <your-key-name>.jks -keyalg RSA \
            -keysize 2048 -validity 10000 -alias <your-key-alias>
    ```

2. Reference the Keystore:
    
    Create a file named `key.propertis` in the `android` directory and add the following:
  
    ```text
    storePassword=<your-store-password>
    keyPassword=<your-key-password>
    keyAlias=<your-key-alias>
    storeFile=<path-to-your-keystore>
    ```

3. Build the Release APK:

    ```sh
    flutter build apk --release --dart-define-from-file env.prod.json
    ```

### iOS
#### Prepare for iOS Release
To build and [distribute your iOS app](https://docs.flutter.dev/deployment/ios#review-xcode-project-settings), follow thoes steps:

1. Update Project Settings:
    
    Open the `ios` folder of your Flutter project in Xcode:
    ```sh
    open ios/Runner.xcworkspace
    ```

2. Configure App Information: 
    
    In Xcode, select the `Runner` project in the Project Navigator. Under the `General` tab, configure the following:

    * Display Name
    * Bundle Identifer
    * Team (select your Apple Developer account)
    * Version and Build number

3. Configure Signing & Capabilities:
    
    Under the `Signing & Capabilities` tab, ensure that Automatically manage signing is checked. Select your Development Team.

4. Build the iOSS App:

    Run the following command to build the iOS app:
    ```sh
    flutter build ios --release --dart-define-from-file env.prod.json
    ```

5. Archive the App:

    In Xcode, select `Product > Archive` to create an archive of your app.

6. Distribute the App:

    After the archive is created, the Xcode Organizer window will appear. Select your archive and click `Distribute App`. Follow the prompts to upload your app to the App Store or export it for Ad Hoc distribution.

### Web
To build and deploy your Flutter web app, follow thoes steps:

1. Build the Web App:

    Run the following command to create a release build for the web:
    ```sh
    flutter build web --web-renderer canvaskit --dart-define-from-file env.prod.json
    ```

2. Deploy the Web App:

    Upload the contents of the `build/web` directory to your web server or hosing provider.

## Project Structure
The project structure is organized into logical modules and directories, each serving a specific purpose in the application's architecture. Here's a brief overview of the main directories and their contents:

<sup>

```sh
    src
     ├── assets/    # Contains all the non-Dart resources used in the app, such as images and localization files.
     │    ├── images/  # Stores image assets.
     │    │     ├── logo_dark.svg  # The dark version of the app logo.
     │    │     └── logo_light.svg # The light version of the app logo.
     │    │
     │    └── locales/  # Contains localization files for different languages
     │          ├── en_US.json  # Localization file for US English.
     │          └── ka_GE.json  # Localization file for Georgian.
     └── lib  # Contains the main Dart code for the application.
          ├── app/  # Contains the main app structure.
          │    ├── pages/  # Directory for different pages/screens of the app.
          │    ├── widgets/  # Directory for reusable widgets.
          │    └── app_view.dart  # Main view of the application.
          ├── config/  # Contains configuration files for the app.
          │    ├── app_config.dart  # General configuration settings for the app.
          │    ├── theme_config.dart  # Configuration related to theming and appearance.
          │    └── preference_config.dart  # Configuration related user preferences and settings
          ├── data/  # Manages data-related components.
          │    ├── blocs/  # Contains BLoC (Business Logic Component) classes for state management.
          │    ├── model/  # Contains data models.
          │    └── services/  # Contains service classes for making API calls or handling data.
          ├── routes/  # Manages app navigation.
          │    └── app_routes.dart  # Defines the routes for navigating between different pages.
          ├── utils/  # Contains utility functions and helpers used throughout the app.
          │    └── ...
          └── main.dart  # The entry point of the application.
```

</sup>

## Theming and appearance

This project uses the [Moon.io](https://moon.io/) design system for its UI components and design patterns.

## Configure Supabase

### Email Templates

<details>
    <summary>Confirm signup</summary>
    
```html
<h2>Confirm your signup</h2>

<p>Follow this link to confirm your usesr:</p>
<p><a href="{{ .ConfirmationURL }}">Confirm your mail</a></p>
```
</details>

<details>
    <summary>Invite user</summary>
    
```html
    <h2>You have been invited</h2>

    <p>You have been invited to create a user on {{ .SiteURL }}. Follow this link to accept the invite:</p>
    <p><a href="{{ .ConfirmationURL }}">Accept the invite</a></p>
```
</details>

<details>
    <summary>Magic Link</summary>
    
```html
    <h2>Magic Link</h2>

    <p>Follow this link to login:</p>
    <p><a href="{{ .SiteURL }}auth/callback/verify?token={{ .TokenHash }}&type=magiclink">Log in</a></p>
```
</details>

<details>
    <summary>Change Email Address</summary>
    
```html
    <h2>Confirm Change of Email</h2>

    <p>Follow this link to confirm the update of your email from {{ .Email }} to {{ .NewEmail }}:</p>
    <p><a href="{{ .ConfirmationURL }}">Change Email</a></p>
```
</details>

<details>
    <summary>Reset Password</summary>
    
```html
    <h2>Reset Password</h2>

    <p>Follow this link to reset the password for your user:</p>
    <p>OTP: {{.Token }}</p>
    <p><a href="{{ .SiteURL }}auth/callback/verify?token={{ .TokenHash }}&type=recovery">Reset Password</a></p>
```
</details>


### URL Configuration

To ensure functionalities like password recovery, magic links, email change work correctly, configure the Site URL in Supabase Dashborad.

1. **Go to `Autentication` -> `URL Configuration`**
2. **Set the Site Url**
    - In the "Site URL" field, enter the URL where your Flutter app is hosted. If you`re in development, this might be something like http://localhost:8000/callback/verify
3. **Configure Redirect URLs for Deep linking**
    - In the "Redirect URLs" section, add the URLs that your auth providers are permitted to redirect to post-authentication. You can use wildcards if necessary. For example:
    
        - com.example.demoapp://auth/callback/verify
        - http://localhost:8080/auth/callback/verify



### Enable Captcha protection

To enhance the security of your authentication process, you can enable Cloudflare Turnstile CAPTCHA in your Supabase project. Follow these steps:

1. **Create a Cloudflare Turnstile Account**
    - In the [Cloudflare Turnstile](https://www.cloudflare.com/products/turnstile/) dashboard, create a new Turnstile widget (invisible)
2. **Go to `Project Settings` -> `Authentication`**
    - Enable Captcha protection
    - Choose Captcha Provider to `Turnstile by Cloudflare`
    - Enter `Secret key` in "Captcha secret" field and save.

## Additional Configuration

### Deep Linking

> \[!NOTE]
>
> Before you start **Configure Your Domain**: ensure that you have a domain to use for deep linking. For Android and iOS, you will need to host configuration file.
> Android [Hosting assetlinks.json file](https://docs.flutter.dev/cookbook/navigation/set-up-app-links#3-hosting-assetlinks-json-file)
> Ios [Host apple-app-site-association](https://docs.flutter.dev/cookbook/navigation/set-up-universal-links?tab=xcode-ide#create-and-host-apple-app-site-association-json-file) JSON file

#### Android

1. Open `AndroidManifest.xml` located at `android/app/src/main/AndroidManifest.xml`

2. Inside the `<activity>` tag for your main activity. Replace `www.yourdomain.com` with your actual domain.

    ```xml
    <activity
    android:name=".MainActivity"
    android:launchMode="singleTask"
    android:theme="@style/LaunchTheme"
    android:configChanges="keyboard|keyboardHidden|orientation|screenSize|smallestScreenSize|screenLayout|density|uiMode"
    android:hardwareAccelerated="true"
    android:windowSoftInputMode="adjustResize">
    
        <!-- Deeplink -->
        <meta-data android:name="flutter_deeplinking_enabled" android:value="true" />
        <intent-filter android:autoVerify="true">
            <action android:name="android.intent.action.VIEW" />
            <category android:name="android.intent.category.DEFAULT" />
            <category android:name="android.intent.category.BROWSABLE" />
            <data android:scheme="http" android:host="www.yourdomain.com" />
            <data android:scheme="https" />
        </intent-filter>
    
    <!-- Existing configurations -->
    </activity>
    ```

#### iOS

1. Open `Info.plist` located at `ios/Runner/Info.plist`.

2. Add a new entry for URL types. Replace `your_scheme` with your actual URL scheme and `yourdomain.com` with your actual domain. 

    ```xml
        <dict>
            <key>CFBundleURLTypes</key>
       	    <!-- Deep linking -->
            <array>
                <dict>
                    <key>CFBundleURLSchemes</key>
                    <array>
                        <string>your_scheme</string>
                    </array>
                    <key>CFBundleURLName</key>
                    <string>www.yourdomain.com</string>
                </dict>
            </array>
    	    <!--End of the Deep linking-->
        </dict>
    ```


## Contribution
Contributions are welcome! If you have any ideas, suggestions, or improvements for the architecture, feel free to open an issue or submit a pull request. Please ensure that your contributions align with the project's goals and guidelines.

## License
This project is licensed under the [MIT License](./LICENSE). Feel free to use, modify, and distribute the code for your own projects.

