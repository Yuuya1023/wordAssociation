//
//  Utilities.m
//  wordAssociation
//
//  Created by 南部 祐耶 on 2013/03/16.
//  Copyright (c) 2013年 Yuya Nambu. All rights reserved.
//

#import "Utilities.h"

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

@end
