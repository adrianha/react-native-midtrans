import React, { Component } from 'react';
import { Platform, StyleSheet, Text, View, Button } from 'react-native';
import Midtrans from '@adrianha/react-native-midtrans';

const midtrans = new Midtrans({
  clientKey: 'CLIENT_KEY',
  baseUrl: 'BASE_URL',
  environment: Midtrans.ENVIRONMENT_SANDBOX,
  colorTheme: {
    primaryColor: '#000000',
  },
});

const instructions = Platform.select({
  ios: 'Press Cmd+R to reload,\n' + 'Cmd+D or shake for dev menu',
  android: 'Double tap R on your keyboard to reload,\n' + 'Shake or press menu button for dev menu',
});

export default class App extends Component {
  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>Welcome to React Native!</Text>
        <Text style={styles.instructions}>To get started, edit App.js</Text>
        <Text style={styles.instructions}>{instructions}</Text>
        <Button
          title="Start Payment"
          onPress={async () => {
            try {
              const result = await midtrans.startPaymentWithSnapToken('SNAP_TOKEN');
              console.log({ result });
            } catch (e) {
              console.log(e);
            }
          }}
        />
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});
