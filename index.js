import { NativeModules } from 'react-native';

const { ReactNativeMidtrans } = NativeModules;

class Midtrans {
  static ENVIRONMENT_SANDBOX = ReactNativeMidtrans.ENVIRONMENT_SANDBOX;
  static ENVIRONMENT_PRODUCTION = ReactNativeMidtrans.ENVIRONMENT_PRODUCTION;

  constructor({ clientKey, baseUrl, environment = Midtrans.ENVIRONMENT_SANDBOX, colorTheme }) {
    ReactNativeMidtrans.init({
      clientKey,
      baseUrl,
      environment,
      colorTheme,
    });
  }

  startPaymentWithSnapToken = snapToken => ReactNativeMidtrans.startPaymentWithSnapToken(snapToken);
}

export default Midtrans;
