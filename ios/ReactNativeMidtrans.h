#if __has_include(<React/RCTBridgeModule.h>)
#import <React/RCTBridgeModule.h>
#else
#import "RCTBridgeModule.h"
#endif
#import <MidtransKit/MidtransKit.h>

@interface ReactNativeMidtrans : NSObject <RCTBridgeModule, MidtransUIPaymentViewControllerDelegate>

@end
