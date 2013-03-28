//
//  Utilities.m
//  wordAssociation
//
//  Created by 南部 祐耶 on 2013/03/16.
//  Copyright (c) 2013年 Yuya Nambu. All rights reserved.
//

#import "Utilities.h"
#import "SBJson.h"


@implementation Utilities

+ (BOOL)isDevice5thGen{
    BOOL isDevice5thGen = NO;
    
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    if (frame.size.height == 548.0) {
        isDevice5thGen = YES;
    }
    else{
        isDevice5thGen = NO;
    }
    return isDevice5thGen;
}

+ (NSMutableArray *)setQuestionIDs:(int)num{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < num; i++) {
        BOOL y = YES;
        while (y) {
            int rand = arc4random() % num;
            if (![array containsObject:[NSString stringWithFormat:@"%d",rand]]) {
                [array addObject:[NSString stringWithFormat:@"%d",rand]];
                NSLog(@"%d",rand);
                y = NO;
            }
        }
    }
    return array;
}

+ (NSDictionary *)jsonParserWithPath:(NSString *)filePath{
    NSString *jsonString = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:filePath] encoding:NSUTF8StringEncoding];
//        NSArray *jsonArray = [jsonString JSONValue];
    
    SBJsonParser* sbjsonparser =[[SBJsonParser alloc]init];
    NSError* error = nil;
    NSDictionary* dic = [sbjsonparser objectWithString:jsonString
                                                 error:&error];
    
    return dic;
}

+ (NSDictionary *)jsonParserWithJsonString:(NSString *)jsonString{
    SBJsonParser* sbjsonparser =[[SBJsonParser alloc]init];
    NSError* error = nil;
    NSDictionary* dic = [sbjsonparser objectWithString:jsonString
                                                 error:&error];
    
    return dic;
}

@end
