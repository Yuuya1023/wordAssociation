//
//  IAPManager.h
//  wordAssociation
//
//  Created by 南部 祐耶 on 2013/03/16.
//  Copyright (c) 2013年 Yuya Nambu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#import "VerificationController.h"

@interface IAPManager : NSObject <SKRequestDelegate,SKPaymentTransactionObserver,SKProductsRequestDelegate>{
    VerificationController *verificationController;
    BOOL purchasing;
}

+ (IAPManager *)sharedInstance;

- (BOOL)checkCanMakePayment;
- (void)startProductRequestWithItemType:(int)type;
- (void)completeTransactionWithData:(NSData *)data;
- (void)completeTransaction:(SKPaymentTransaction *)transaction;

@end
