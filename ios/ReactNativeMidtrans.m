#import "ReactNativeMidtrans.h"

@interface ReactNativeMidtrans ()
@property (nonatomic, copy) RCTPromiseResolveBlock resolver;
@property (nonatomic, copy) RCTPromiseRejectBlock rejector;
@end

static NSString *const kEnvironmentSandbox = @"ENVIRONMENT_SANDBOX";
static NSString *const EnvironmentSandbox = @"sandbox";
static NSString *const kEnvironmentProduction = @"ENVIRONMENT_PRODUCTION";
static NSString *const EnvironmentProduction = @"production";

@implementation ReactNativeMidtrans

RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup
{
    return NO;
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

- (NSDictionary *)constantsToExport
{
    return @{
             kEnvironmentSandbox: EnvironmentSandbox,
             kEnvironmentProduction: EnvironmentProduction
             };
}

RCT_EXPORT_METHOD(init:(NSDictionary *)config)
{
    NSString *clientKey = [config valueForKey:@"clientKey"];
    NSString *merchantUrl = [config valueForKey:@"baseUrl"];
    MidtransServerEnvironment environment = [[config valueForKey:@"environment"] isEqualToString:EnvironmentSandbox] ? MidtransServerEnvironmentSandbox : MidtransServerEnvironmentProduction;
    [CONFIG setClientKey:clientKey environment:environment merchantServerURL:merchantUrl];
}

RCT_REMAP_METHOD(startPaymentWithSnapToken,
                 snapToken:(NSString *)snapToken
                 startPaymentWithSnapTokenResolver: (RCTPromiseResolveBlock)resolve
                 startPaymentWithSnapTokenRejecter: (RCTPromiseRejectBlock)reject)
{
    [[MidtransMerchantClient shared] requestTransacationWithCurrentToken:snapToken completion:^(MidtransTransactionTokenResponse * _Nullable regenerateToken, NSError * _Nullable error) {
        if (error) {
            reject(@"REQUEST_TRANSACTION_FAILED", @"Something went wrong", error);
        } else {
            self.resolver = resolve;
            self.rejector = reject;

            MidtransUIPaymentViewController *paymentVC = [[MidtransUIPaymentViewController alloc] initWithToken:regenerateToken];
            paymentVC.paymentDelegate = self;
            UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
            [rootVC presentViewController:paymentVC animated:YES completion:nil];
        }
    }];
}

#pragma mark - MidtransUIPaymentViewControllerDelegate
- (void)finishPayment:(MidtransTransactionResult *)result error:(NSError *)error
{
    if (self.resolver == nil || self.rejector == nil) {
        return;
    }

    if (error) {
        self.rejector(@"PAYMENT_FAILED", @"Something went wrong", error);
    } else {
        self.resolver(@{
                        @"isTransactionCancelled": result ? @NO : @YES,
                        @"status": result ? result.transactionStatus : @""
                        });
    }

    self.resolver = nil;
    self.rejector = nil;
}

- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController paymentSuccess:(MidtransTransactionResult *)result {
    [self finishPayment:result error:nil];
}

- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController paymentFailed:(NSError *)error {
    [self finishPayment:nil error:error];
}

- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController paymentPending:(MidtransTransactionResult *)result {
    [self finishPayment:result error:nil];
}

- (void)paymentViewController_paymentCanceled:(MidtransUIPaymentViewController *)viewController {
    [self finishPayment:nil error:nil];
}

- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController saveCard:(MidtransMaskedCreditCard *)result {
    /** noop. */
}

- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController saveCardFailed:(NSError *)error {
    /** noop. */
}

@end
