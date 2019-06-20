package com.adrianha.midtrans;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.midtrans.sdk.corekit.callback.TransactionFinishedCallback;
import com.midtrans.sdk.corekit.core.MidtransSDK;
import com.midtrans.sdk.corekit.core.UIKitCustomSetting;
import com.midtrans.sdk.corekit.core.themes.CustomColorTheme;
import com.midtrans.sdk.corekit.models.snap.TransactionResult;
import com.midtrans.sdk.uikit.SdkUIFlowBuilder;

public class ReactNativeMidtransModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;

    public ReactNativeMidtransModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "ReactNativeMidtrans";
    }

    @ReactMethod
    public void init(ReadableMap config) {
        String clientKey = config.getString("clientKey");
        String baseUrl = config.getString("baseUrl");

        // set up custom theme
        String defaultPrimaryColor = "#999999";
        String defaultPrimaryDarkColor = "#737373";
        String defaultSecondaryColor = "#adadad";
        CustomColorTheme colorTheme = new CustomColorTheme(defaultPrimaryColor, defaultPrimaryDarkColor, defaultSecondaryColor);
        if (config.getMap("colorTheme") != null) {
            ReadableMap colorThemeMap = config.getMap("colorTheme");
            String primaryColor = colorThemeMap.hasKey("primaryColor") ? colorThemeMap.getString("primaryColor") : defaultPrimaryColor;
            String primaryDarkColor = colorThemeMap.hasKey("primaryDarkColor") ? colorThemeMap.getString("primaryDarkColor") : defaultPrimaryDarkColor;
            String secondaryColor = colorThemeMap.hasKey("secondaryColor") ? colorThemeMap.getString("secondaryColor") : defaultSecondaryColor;
            colorTheme = new CustomColorTheme(primaryColor, primaryDarkColor, secondaryColor);
        }

        UIKitCustomSetting uiKitCustomSetting = new UIKitCustomSetting();
        uiKitCustomSetting.setSkipCustomerDetailsPages(true);
        uiKitCustomSetting.setShowPaymentStatus(false);

        SdkUIFlowBuilder.init()
                .setContext(reactContext.getApplicationContext())
                .setClientKey(clientKey)
                .setMerchantBaseUrl(baseUrl)
                .enableLog(BuildConfig.DEBUG)
                .setColorTheme(colorTheme)
                .setUIkitCustomSetting(uiKitCustomSetting)
                .buildSDK();
    }

    @ReactMethod
    public void startPaymentWithSnapToken(String snapToken, final Promise promise) {
        MidtransSDK.getInstance()
            .setTransactionFinishedCallback(new TransactionFinishedCallback() {
                @Override
                public void onTransactionFinished(TransactionResult transactionResult) {
                    try {
                        WritableMap result = Arguments.createMap();
                        result.putString("status", transactionResult.getStatus());
                        result.putBoolean("isTransactionCancelled", transactionResult.isTransactionCanceled());
                        promise.resolve(result);
                    } catch (Exception e) {
                        promise.reject(e);
                    }
                }
            });
        MidtransSDK.getInstance()
            .startPaymentUiFlow(reactContext.getCurrentActivity(), snapToken);
    }
}