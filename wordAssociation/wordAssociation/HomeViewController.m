//
//  HomeViewController.m
//  wordAssociation
//
//  Created by 南部 祐耶 on 2013/03/12.
//  Copyright (c) 2013年 Yuya Nambu. All rights reserved.
//

#import "HomeViewController.h"
#import "GameViewController.h"

#import "FacebookManager.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)init
{
    self = [super init];
    if (self) {
//        self.title = @"連想ゲーム";
//        self.view.backgroundColor = [UIColor whiteColor];
        
        UIImageView *BG = [[UIImageView alloc] initWithFrame:self.view.bounds];
        if ([Utilities isDevice5thGen]) {
            BG.image = [UIImage imageNamed:@"Title_bg-568h"];
        }
        else{
            BG.image = [UIImage imageNamed:@"Title_bg"];
        }
        [self.view addSubview:BG];
        
        UIButton *startPlay = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([Utilities isDevice5thGen]) {
            startPlay.frame = CGRectMake(95, 420, 174 /4*3, 52 /4*3);
        }
        else{
            startPlay.frame = CGRectMake(95, 390, 174 /4*3, 52 /4*3);
        }
//        [startPlay setTitle:@"Play" forState:UIControlStateNormal];
        [startPlay setImage:[UIImage imageNamed:@"Start_Btn"] forState:UIControlStateNormal];
        [startPlay addTarget:self action:NSSelectorFromString(@"play:") forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:startPlay];
        
        
//        //リセット用
//        UIButton *reset = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        reset.frame = CGRectMake(110, 470, 100, 40);
//        //        [startPlay setTitle:@"Play" forState:UIControlStateNormal];
//        [reset setImage:[UIImage imageNamed:@"play_Btn"] forState:UIControlStateNormal];
//        [reset addTarget:self action:NSSelectorFromString(@"reset:") forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:reset];
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
//    [self.navigationController.navigationBar setHidden:NO];
}

- (void)reset:(UIButton *)b{
    [USER_DEFAULT setInteger:1 forKey:@"nowStage"];
    [USER_DEFAULT synchronize];
    
//    FacebookManager *fbManager = [FacebookManager sharedInstance];
//    [fbManager publish];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
