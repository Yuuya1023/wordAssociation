//
//  HomeViewController.m
//  wordAssociation
//
//  Created by 南部 祐耶 on 2013/03/12.
//  Copyright (c) 2013年 Yuya Nambu. All rights reserved.
//

#import "HomeViewController.h"
#import "GameViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"連想ゲーム";
        self.view.backgroundColor = [UIColor whiteColor];
        
        UIButton *startPlay = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        startPlay.frame = CGRectMake(110, 200, 100, 40);
//        [startPlay setTitle:@"Play" forState:UIControlStateNormal];
        [startPlay setImage:[UIImage imageNamed:@"play_Btn"] forState:UIControlStateNormal];
        [startPlay addTarget:self action:NSSelectorFromString(@"play:") forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:startPlay];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (void)play:(UIButton *)b{
    GameViewController *gameView = [[GameViewController alloc] init];
    [self.navigationController pushViewController:gameView animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
