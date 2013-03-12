//
//  GameViewController.m
//  wordAssociation
//
//  Created by 南部 祐耶 on 2013/03/12.
//  Copyright (c) 2013年 Yuya Nambu. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()

@end

@implementation GameViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"Stage Hoge";
        self.view.backgroundColor = [UIColor whiteColor];
        
        //写真たち
        image1 = [[UIImageView alloc] initWithFrame:CGRectMake(40, 10, 120, 120)];
        image1.image = [UIImage imageNamed:@""];
        image1.backgroundColor = [UIColor blackColor];
        
        image2 = [[UIImageView alloc] initWithFrame:CGRectMake(170, 10, 120, 120)];
        image2.image = [UIImage imageNamed:@""];
        image2.backgroundColor = [UIColor blueColor];
        
        image3 = [[UIImageView alloc] initWithFrame:CGRectMake(40, 140, 120, 120)];
        image3.image = [UIImage imageNamed:@""];
        image3.backgroundColor = [UIColor redColor];
        
        image4 = [[UIImageView alloc] initWithFrame:CGRectMake(170, 140, 120, 120)];
        image4.image = [UIImage imageNamed:@""];
        image4.backgroundColor = [UIColor yellowColor];
        
        zoomImage = [[UIImageView alloc] initWithFrame:CGRectMake(40, 10, 250, 250)];
        zoomImage.alpha = 0.0;
        zoomImage.backgroundColor = [UIColor grayColor];
        
        [self.view addSubview:image1];
        [self.view addSubview:image2];
        [self.view addSubview:image3];
        [self.view addSubview:image4];
        [self.view addSubview:zoomImage];
        
        //答えが当てはまるパネル
        panelBg = [[UIImageView alloc] initWithFrame:CGRectMake(90, 270, 150, 40)];
        panelBg.backgroundColor = [UIColor grayColor];
        
        [self.view addSubview:panelBg];
        
        //文字たち
        button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button1.frame = CGRectMake(5, [UIScreen mainScreen].bounds.size.height - 160, 40, 40);
        [button1 setTitle:@"1" forState:UIControlStateNormal];
        [button1 addTarget:self action:NSSelectorFromString(@"setWord:") forControlEvents:UIControlEventTouchUpInside];
        
        button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button2.frame = CGRectMake(50, [UIScreen mainScreen].bounds.size.height - 160, 40, 40);
        [button2 setTitle:@"2" forState:UIControlStateNormal];
        [button2 addTarget:self action:NSSelectorFromString(@"setWord:") forControlEvents:UIControlEventTouchUpInside];

        button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button3.frame = CGRectMake(95, [UIScreen mainScreen].bounds.size.height - 160, 40, 40);
        [button3 setTitle:@"3" forState:UIControlStateNormal];
        [button3 addTarget:self action:NSSelectorFromString(@"setWord:") forControlEvents:UIControlEventTouchUpInside];
        
        button4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button4.frame = CGRectMake(140, [UIScreen mainScreen].bounds.size.height - 160, 40, 40);
        [button4 setTitle:@"4" forState:UIControlStateNormal];
        [button4 addTarget:self action:NSSelectorFromString(@"setWord:") forControlEvents:UIControlEventTouchUpInside];
        
        button5 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button5.frame = CGRectMake(185, [UIScreen mainScreen].bounds.size.height - 160, 40, 40);
        [button5 setTitle:@"5" forState:UIControlStateNormal];
        [button5 addTarget:self action:NSSelectorFromString(@"setWord:") forControlEvents:UIControlEventTouchUpInside];
        
        button6 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button6.frame = CGRectMake(230, [UIScreen mainScreen].bounds.size.height - 160, 40, 40);
        [button6 setTitle:@"6" forState:UIControlStateNormal];
        [button6 addTarget:self action:NSSelectorFromString(@"setWord:") forControlEvents:UIControlEventTouchUpInside];
        

        
        button7 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button7.frame = CGRectMake(5, [UIScreen mainScreen].bounds.size.height - 115, 40, 40);
        [button7 setTitle:@"7" forState:UIControlStateNormal];
        [button7 addTarget:self action:NSSelectorFromString(@"setWord:") forControlEvents:UIControlEventTouchUpInside];
        
        button8 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button8.frame = CGRectMake(50, [UIScreen mainScreen].bounds.size.height - 115, 40, 40);
        [button8 setTitle:@"8" forState:UIControlStateNormal];
        [button8 addTarget:self action:NSSelectorFromString(@"setWord:") forControlEvents:UIControlEventTouchUpInside];
        
        button9 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button9.frame = CGRectMake(95, [UIScreen mainScreen].bounds.size.height - 115, 40, 40);
        [button9 setTitle:@"9" forState:UIControlStateNormal];
        [button9 addTarget:self action:NSSelectorFromString(@"setWord:") forControlEvents:UIControlEventTouchUpInside];
        
        button10 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button10.frame = CGRectMake(140, [UIScreen mainScreen].bounds.size.height - 115, 40, 40);
        [button10 setTitle:@"A" forState:UIControlStateNormal];
        [button10 addTarget:self action:NSSelectorFromString(@"setWord:") forControlEvents:UIControlEventTouchUpInside];
        
        button11 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button11.frame = CGRectMake(185, [UIScreen mainScreen].bounds.size.height - 115, 40, 40);
        [button11 setTitle:@"B" forState:UIControlStateNormal];
        [button11 addTarget:self action:NSSelectorFromString(@"setWord:") forControlEvents:UIControlEventTouchUpInside];

        button12 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button12.frame = CGRectMake(230, [UIScreen mainScreen].bounds.size.height - 115, 40, 40);
        [button12 setTitle:@"C" forState:UIControlStateNormal];
        [button12 addTarget:self action:NSSelectorFromString(@"setWord:") forControlEvents:UIControlEventTouchUpInside];
        

        [self.view addSubview:button1];
        [self.view addSubview:button2];
        [self.view addSubview:button3];
        [self.view addSubview:button4];
        [self.view addSubview:button5];
        [self.view addSubview:button6];
        [self.view addSubview:button7];
        [self.view addSubview:button8];
        [self.view addSubview:button9];
        [self.view addSubview:button10];
        [self.view addSubview:button11];
        [self.view addSubview:button12];
        
        hint = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        hint.frame = CGRectMake(275, [UIScreen mainScreen].bounds.size.height - 160, 40, 40);
        [hint setTitle:@"h" forState:UIControlStateNormal];
        [hint addTarget:self action:NSSelectorFromString(@"hint:") forControlEvents:UIControlEventTouchUpInside];
        
        hint2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        hint2.frame = CGRectMake(275, [UIScreen mainScreen].bounds.size.height - 115, 40, 40);
        [hint2 setTitle:@"H" forState:UIControlStateNormal];
        [hint2 addTarget:self action:NSSelectorFromString(@"hint2:") forControlEvents:UIControlEventTouchUpInside];

        
        [self.view addSubview:hint];
        [self.view addSubview:hint2];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)setWord:(UIButton *)b{
    
}

- (void)hint:(UIButton *)b{
    
}

- (void)hint2:(UIButton *)b{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
