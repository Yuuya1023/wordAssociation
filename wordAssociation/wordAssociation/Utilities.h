//
//  Utilities.h
//  wordAssociation
//
//  Created by 南部 祐耶 on 2013/03/16.
//  Copyright (c) 2013年 Yuya Nambu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject


+ (BOOL)isDevice5thGen;
+ (NSMutableArray *)setQuestionIDs:(int)num;
+ (NSDictionary *)jsonParserWithPath:(NSString *)filePath;
+ (NSDictionary *)jsonParserWithJsonString:(NSString *)jsonString;




@end
