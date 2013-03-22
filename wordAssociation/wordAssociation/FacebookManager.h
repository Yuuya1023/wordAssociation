//
//  FacebookManager.h
//  wordAssociation
//
//  Created by 南部 祐耶 on 2013/03/20.
//  Copyright (c) 2013年 Yuya Nambu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Facebook.h"
#import "FBLoginDialog.h"
//#import "JSON.h"
#import "SBJson.h"

@interface FacebookManager : NSObject<FBSessionDelegate, FBRequestDelegate,FBDialogDelegate,FBLoginDialogDelegate,
UITextFieldDelegate>{
    
    Facebook *facebook;
}

+ (FacebookManager *)sharedInstance;

- (void)login;
- (void)publish;
- (void)publishWithDescription:(NSString *)description filePath:(NSString *)filePath;


@end
