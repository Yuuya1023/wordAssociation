//
//  WAMasterViewController.h
//  wordAssociation
//
//  Created by 南部 祐耶 on 2013/03/12.
//  Copyright (c) 2013年 Yuya Nambu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WADetailViewController;

@interface WAMasterViewController : UITableViewController

@property (strong, nonatomic) WADetailViewController *detailViewController;

@end
