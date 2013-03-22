//
//  IAPManager.m
//  wordAssociation
//
//  Created by 南部 祐耶 on 2013/03/16.
//  Copyright (c) 2013年 Yuya Nambu. All rights reserved.
//

#import "IAPManager.h"
#import "SBJson.h"
#import "NSString+MD5.h"

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
        purchasing = NO;
        verificationController = [VerificationController sharedInstance];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        NSLog(@"defaultQueue %@",[SKPaymentQueue defaultQueue].transactions);
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
    
    //アプリ内課金中かどうかのフラグを保存
    purchasing = YES;
    
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
        [self finishTransaction];
        return;
    }
    // 購入処理開始
    for (SKProduct *product in response.products) {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}





- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                
                // 購入処理中
                /*
                 * 基本何もしなくてよい。処理中であることがわかるようにインジケータをだすなど。
                 */
                
                break;
            case SKPaymentTransactionStatePurchased:
                
                // 購入処理成功
                if([verificationController verifyPurchase:transaction]){
                    [queue finishTransaction:transaction];
                }
                
                break;
            case SKPaymentTransactionStateFailed:{
                
                // 購入処理エラー。ユーザが購入処理をキャンセルした場合もここにくる
                [queue finishTransaction:transaction];
                [self finishTransaction];
                // エラーが発生したことをユーザに知らせる
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                                message:[transaction.error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
                [alert show];
            }
                
                break;
            case SKPaymentTransactionStateRestored:
                
                // リストア処理完了
                /*
                 * アイテムの再付与を行う
                 */
                [queue finishTransaction:transaction];
                [self finishTransaction];
                
                break;
                
            default:
                break;
        }
    }		
}

- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
//    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)completeTransactionWithData:(NSData *)data{
    NSString *resString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"completeTransaction %@",resString);
    
    SBJsonParser* sbjsonparser =[[SBJsonParser alloc]init];
    NSError* error;
    error = nil;
    NSDictionary* dic = [sbjsonparser objectWithString:resString
                                                 error:&error];
    NSLog(@"%@",dic);
    int point = 0;
    if ([[dic objectForKey:@"status"] intValue] == 0) {
        NSString *pid = [[dic objectForKey:@"receipt"] objectForKey:@"product_id"];
        if ([pid isEqualToString:@"wa.350coins"]) {
            point = 350;
        }
        else if ([pid isEqualToString:@"wa.750coins"]){
            point = 750;
        }
        else if ([pid isEqualToString:@"wa.2000coins"]){
            point = 2000;
        }
        else if ([pid isEqualToString:@"wa.4500coins"]){
            point = 4500;
        }
        else if ([pid isEqualToString:@"wa.10000coins"]){
            point = 10000;
        }
        NSLog(@"%d coins",point);
    }
//    NSString *pointStr = [NSString stringWithFormat:@"%d",point];
//    NSString *MD5 = [pointStr md5String];
//    NSLog(@"%@",MD5);
    
    int beforeCoins = [USER_DEFAULT integerForKey:COINS_KEY];
    int afterCoins = beforeCoins + point;
    NSLog(@"before %d",beforeCoins);
    NSLog(@"after %d",afterCoins);
    [USER_DEFAULT setInteger:afterCoins forKey:COINS_KEY];
    [USER_DEFAULT synchronize];
    
    [self finishTransactionWithCoins:point];
}

//- (void)completeTransaction:(SKPaymentTransaction *)transaction{
//    NSLog(@"completeTransaction %@",transaction.payment);
//    [self finishTransaction];
//}

- (void)finishTransaction{
    purchasing = NO;
    NSNotification *n = [NSNotification notificationWithName:IAP_FINISHED_NOTIFICATION_NAME object:self];
    [[NSNotificationCenter defaultCenter] postNotification:n];
}

- (void)finishTransactionWithCoins:(NSInteger)coins{
    
    NSString *message = @"";
    if (purchasing) {
        message = [NSString stringWithFormat:@"%dコインゲットしました！",coins];
    }
    else{
        message = [NSString stringWithFormat:@"%dコインゲットしました！\n※この購入は前回完了できなかった決済を復元した可能性があります",coins];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功！"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    purchasing = NO;
    NSNotification *n = [NSNotification notificationWithName:IAP_FINISHED_NOTIFICATION_NAME object:self];
    [[NSNotificationCenter defaultCenter] postNotification:n];
}
@end
