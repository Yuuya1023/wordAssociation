//
//  FacebookManager.m
//  wordAssociation
//
//  Created by 南部 祐耶 on 2013/03/20.
//  Copyright (c) 2013年 Yuya Nambu. All rights reserved.
//

#import "FacebookManager.h"

static FacebookManager *singleton;
static NSString* APPLICATION_ID = @"141530622690643";

@implementation FacebookManager

+ (FacebookManager *)sharedInstance
{
	if (singleton == nil)
    {
		singleton = [[FacebookManager alloc] init];
	}
	return singleton;
}

- (id)init
{
	self = [super init];
	if (self != nil){
        facebook = [[Facebook alloc] initWithAppId:APPLICATION_ID andDelegate:self];
        [facebook setSessionDelegate:self];
	}
	return self;
}

-(void)login{
    if (YES) {
//        NSArray *permissions =  [NSArray arrayWithObjects:
//                                 @"read_stream",@"publish_stream",nil];
////        [facebook authorize:permissions delegate:self];
//        [facebook authorize:permissions];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       APPLICATION_ID,@"client_id",
                                       @"touch", @"display",
                                       @"publish_stream,read_stream,offline_access", @"scope",
                                       nil];
        [facebook dialog:@"oauth"
               andParams:params
             andDelegate:self];
    } else {
        [facebook logout:self];
    }
}

- (void)publish{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"testMessage",  @"message",
                                   nil];
    
    [facebook dialog:@"stream.publish"
           andParams:params
         andDelegate:self];
}


- (void)fbDidLogin {
    NSLog(@"HelloFbViewController.fbDidLogin");
//    [loginButton setLoginStatus:YES];
//    [loggedInView setHidden:NO];
}

- (void)fbDidNotLogin:(BOOL)cancelled {
    NSLog(@"fbDidNotLogin");
//    [loginButton setLoginStatus:NO];
//    [loggedInView setHidden:YES];
}

- (void)fbDidLogout {
    NSLog(@"HelloFbViewController.fbDidLogout");
//    [loginButton setLoginStatus:NO];
//    [loggedInView setHidden:YES];
}

- (void)fbDialogNotLogin:(BOOL)cancelled{
    NSLog(@"fbDialogNotLogin");
}

- (void)fbDialogLogin:(NSString *)token expirationDate:(NSDate *)expirationDate{
    NSLog(@"fbDialogLogin %@, %@",token,expirationDate);
}



- (void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt{
    
}

- (void)fbSessionInvalidated{
    
}

//キーボードを隠す
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    [messageField resignFirstResponder];
    return YES;
}

-(void)postMessage {
    
    NSDictionary *privacy = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"CUSTOM",@"value",
                              @"SELF",@"friends",
                              nil];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"testMessage",  @"message",
                                   [privacy JSONRepresentation], @"privacy",
                                   nil];
    [facebook requestWithGraphPath:@"/me/feed"
                         andParams:params
                     andHttpMethod:@"POST"
                       andDelegate:self];
}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"HelloFbViewController.didReceiveResponse");
};

- (void)request:(FBRequest *)request didLoad:(id)result {
    NSLog(@"HelloFbViewController.didLoad");
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Success"
                          message:[NSString stringWithFormat:@"id=%@",
                                   [result objectForKey:@"id"]]
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles: nil];
    [alert show];
//    [messageField setText:@""];
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"HelloFbViewController.didFailWithError %@", error);
};

//- (void)dealloc {
//    [messageField release];
//    [loginButton release];
//    [super dealloc];
//}

@end
