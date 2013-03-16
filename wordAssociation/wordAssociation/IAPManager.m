//
//  IAPManager.m
//  wordAssociation
//
//  Created by 南部 祐耶 on 2013/03/16.
//  Copyright (c) 2013年 Yuya Nambu. All rights reserved.
//

#import "IAPManager.h"

static IAPManager *singleton;

@implementation IAPManager


+ (IAPManager *)sharedInstance
{
	if (singleton == nil)
    {
		singleton = [[IAPManager alloc] init];
	}
	return singleton;
}


- (id)init
{
	self = [super init];
	if (self != nil)
    {
        verificationController = [VerificationController sharedInstance];
	}
	return self;
}


- (BOOL)checkCanMakePayment{
    BOOL canMakePayments;
    if (![SKPaymentQueue canMakePayments]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                        message:@"アプリ内課金が制限されています。"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        canMakePayments = NO;
    }
    else{
        canMakePayments = YES;
    }
    return canMakePayments;
}


- (void)startProductRequestWithItemType:(int)type{
    NSSet *set;
    switch (type) {
        case 0:
            set = [NSSet setWithObjects:@"wa.350coins", nil];
            break;
        case 1:
            set = [NSSet setWithObjects:@"wa.750coins", nil];
            break;
        case 2:
            set = [NSSet setWithObjects:@"wa.2000coins", nil];
            break;
        case 3:
            set = [NSSet setWithObjects:@"wa.4500coins", nil];
            break;
        case 4:
            set = [NSSet setWithObjects:@"wa.10000coins", nil];
            break;
        default:
            break;
    }
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    productsRequest.delegate = self;
    [productsRequest start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    // 無効なアイテムがないかチェック
    if ([response.invalidProductIdentifiers count] > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                        message:@"アイテムIDが不正です。"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    // 購入処理開始
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    for (SKProduct *product in response.products) {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}





- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        if (transaction.transactionState == SKPaymentTransactionStatePurchasing) {
            // 購入処理中
            /*
             * 基本何もしなくてよい。処理中であることがわかるようにインジケータをだすなど。
             */
        } else if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
            
            // 購入処理成功
            if([verificationController verifyPurchase:transaction]){
                [self completeTransaction:transaction];
                [queue finishTransaction:transaction];
            }
        } else if (transaction.transactionState == SKPaymentTransactionStateFailed) {
            // 購入処理エラー。ユーザが購入処理をキャンセルした場合もここにくる
            [queue finishTransaction:transaction];
            // エラーが発生したことをユーザに知らせる
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                            message:[transaction.error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
        } else {
            // リストア処理完了
            /*
             * アイテムの再付与を行う
             */
//            [queue finishTransaction:transaction];
        }
    }		
}

- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}


- (void)completeTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"completeTransaction %@",transaction.payment);
    
}
@end
