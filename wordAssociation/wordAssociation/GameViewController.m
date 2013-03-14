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
        image1.userInteractionEnabled = YES;
        image1.tag = 100;
        image1.backgroundColor = [UIColor blackColor];
        
        image2 = [[UIImageView alloc] initWithFrame:CGRectMake(170, 10, 120, 120)];
        image2.image = [UIImage imageNamed:@""];
        image2.userInteractionEnabled = YES;
        image2.tag = 101;
        image2.backgroundColor = [UIColor blueColor];
        
        image3 = [[UIImageView alloc] initWithFrame:CGRectMake(40, 140, 120, 120)];
        image3.image = [UIImage imageNamed:@""];
        image3.userInteractionEnabled = YES;
        image3.tag = 102;
        image3.backgroundColor = [UIColor redColor];
        
        image4 = [[UIImageView alloc] initWithFrame:CGRectMake(170, 140, 120, 120)];
        image4.image = [UIImage imageNamed:@""];
        image4.userInteractionEnabled = YES;
        image4.tag = 103;
        image4.backgroundColor = [UIColor yellowColor];
        
        zoomImage = [[UIImageView alloc] initWithFrame:CGRectMake(40, 10, 250, 250)];
        zoomImage.userInteractionEnabled = YES;
        zoomImage.tag = 105;
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
        UIImage *btnBg = [UIImage imageNamed:@"num_Bg01"];
        UIColor *titleColor = [UIColor blackColor];
        UIFont *titleFont = [UIFont fontWithName:@"GillSans" size:18];

        button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame = CGRectMake(5, [UIScreen mainScreen].bounds.size.height - 160, 40, 40);
        [button1 setTitle:@"1" forState:UIControlStateNormal];
        [button1 setTitleColor:titleColor forState:UIControlStateNormal];
        button1.titleLabel.font = titleFont;
        [button1 setBackgroundImage:btnBg forState:UIControlStateNormal];
        [button1 addTarget:self action:NSSelectorFromString(@"setWord:") forControlEvents:UIControlEventTouchUpInside];
        
        button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        button2.frame = CGRectMake(50, [UIScreen mainScreen].bounds.size.height - 160, 40, 40);
        [button2 setTitle:@"2" forState:UIControlStateNormal];
        [button2 setTitleColor:titleColor forState:UIControlStateNormal];
        button2.titleLabel.font = titleFont;
        [button2 setBackgroundImage:btnBg forState:UIControlStateNormal];
        [button2 addTarget:self action:NSSelectorFromString(@"setWord:") forControlEvents:UIControlEventTouchUpInside];

        button3 = [UIButton buttonWithType:UIButtonTypeCustom];
        button3.frame = CGRectMake(95, [UIScreen mainScreen].bounds.size.height - 160, 40, 40);
        [button3 setTitle:@"3" forState:UIControlStateNormal];
        [button3 setTitleColor:titleColor forState:UIControlStateNormal];
        button3.titleLabel.font = titleFont;
        [button3 setBackgroundImage:btnBg forState:UIControlStateNormal];
        [button3 addTarget:self action:NSSelectorFromString(@"setWord:") forControlEvents:UIControlEventTouchUpInside];
        
        button4 = [UIButton buttonWithType:UIButtonTypeCustom];
        button4.frame = CGRectMake(140, [UIScreen mainScreen].bounds.size.height - 160, 40, 40);
        [button4 setTitle:@"4" forState:UIControlStateNormal];
        [button4 setTitleColor:titleColor forState:UIControlStateNormal];
        button4.titleLabel.font = titleFont;
        [button4 setBackgroundImage:btnBg forState:UIControlStateNormal];
        [button4 addTarget:self action:NSSelectorFromString(@"setWord:") forControlEvents:UIControlEventTouchUpInside];
        
        button5 = [UIButton buttonWithType:UIButtonTypeCustom];
        button5.frame = CGRectMake(185, [UIScreen mainScreen].bounds.size.height - 160, 40, 40);
        [button5 setTitle:@"5" forState:UIControlStateNormal];
        [button5 setTitleColor:titleColor forState:UIControlStateNormal];
        button5.titleLabel.font = titleFont;
        [button5 setBackgroundImage:btnBg forState:UIControlStateNormal];
        [button5 addTarget:self action:NSSelectorFromString(@"setWord:") forControlEvents:UIControlEventTouchUpInside];
        
        button6 = [UIButton buttonWithType:UIButtonTypeCustom];
        button6.frame = CGRectMake(230, [UIScreen mainScreen].bounds.size.height - 160, 40, 40);
        [button6 setTitle:@"6" forState:UIControlStateNormal];
        [button6 setTitleColor:titleColor forState:UIControlStateNormal];
        button6.titleLabel.font = titleFont;
        [button6 setBackgroundImage:btnBg forState:UIControlStateNormal];
        [button6 addTarget:self action:NSSelectorFromString(@"setWord:") forControlEvents:UIControlEventTouchUpInside];
        

        
        button7 = [UIButton buttonWithType:UIButtonTypeCustom];
        button7.frame = CGRectMake(5, [UIScreen mainScreen].bounds.size.height - 115, 40, 40);
        [button7 setTitle:@"7" forState:UIControlStateNormal];
        [button7 setTitleColor:titleColor forState:UIControlStateNormal];
        button7.titleLabel.font = titleFont;
        [button7 setBackgroundImage:btnBg forState:UIControlStateNormal];
        [button7 addTarget:self action:NSSelectorFromString(@"setWord:") forControlEvents:UIControlEventTouchUpInside];
        
        button8 = [UIButton buttonWithType:UIButtonTypeCustom];
        button8.frame = CGRectMake(50, [UIScreen mainScreen].bounds.size.height - 115, 40, 40);
        [button8 setTitle:@"8" forState:UIControlStateNormal];
        [button8 setTitleColor:titleColor forState:UIControlStateNormal];
        button8.titleLabel.font = titleFont;
        [button8 setBackgroundImage:btnBg forState:UIControlStateNormal];
        [button8 addTarget:self action:NSSelectorFromString(@"setWord:") forControlEvents:UIControlEventTouchUpInside];
        
        button9 = [UIButton buttonWithType:UIButtonTypeCustom];
        button9.frame = CGRectMake(95, [UIScreen mainScreen].bounds.size.height - 115, 40, 40);
        [button9 setTitle:@"9" forState:UIControlStateNormal];
        [button9 setTitleColor:titleColor forState:UIControlStateNormal];
        button9.titleLabel.font = titleFont;
        [button9 setBackgroundImage:btnBg forState:UIControlStateNormal];
        [button9 addTarget:self action:NSSelectorFromString(@"setWord:") forControlEvents:UIControlEventTouchUpInside];
        
        button10 = [UIButton buttonWithType:UIButtonTypeCustom];
        button10.frame = CGRectMake(140, [UIScreen mainScreen].bounds.size.height - 115, 40, 40);
        [button10 setTitle:@"A" forState:UIControlStateNormal];
        [button10 setTitleColor:titleColor forState:UIControlStateNormal];
        button10.titleLabel.font = titleFont;
        [button10 setBackgroundImage:btnBg forState:UIControlStateNormal];
        [button10 addTarget:self action:NSSelectorFromString(@"setWord:") forControlEvents:UIControlEventTouchUpInside];
        
        button11 = [UIButton buttonWithType:UIButtonTypeCustom];
        button11.frame = CGRectMake(185, [UIScreen mainScreen].bounds.size.height - 115, 40, 40);
        [button11 setTitle:@"B" forState:UIControlStateNormal];
        [button11 setTitleColor:titleColor forState:UIControlStateNormal];
        button11.titleLabel.font = titleFont;
        [button11 setBackgroundImage:btnBg forState:UIControlStateNormal];
        [button11 addTarget:self action:NSSelectorFromString(@"setWord:") forControlEvents:UIControlEventTouchUpInside];

        button12 = [UIButton buttonWithType:UIButtonTypeCustom];
        button12.frame = CGRectMake(230, [UIScreen mainScreen].bounds.size.height - 115, 40, 40);
        [button12 setTitle:@"C" forState:UIControlStateNormal];
        [button12 setTitleColor:titleColor forState:UIControlStateNormal];
        button12.titleLabel.font = titleFont;
        [button12 setBackgroundImage:btnBg forState:UIControlStateNormal];
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
        
        
        //ヒント用のボタン
        hint = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        hint.frame = CGRectMake(275, [UIScreen mainScreen].bounds.size.height - 160, 40, 40);
        [hint setBackgroundImage:[UIImage imageNamed:@"hint_Btn"] forState:UIControlStateNormal];
        [hint addTarget:self action:NSSelectorFromString(@"hint:") forControlEvents:UIControlEventTouchUpInside];
        
        hint2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        hint2.frame = CGRectMake(275, [UIScreen mainScreen].bounds.size.height - 115, 40, 40);
        [hint2 setBackgroundImage:[UIImage imageNamed:@"kesigomu_Btn"] forState:UIControlStateNormal];
        [hint2 addTarget:self action:NSSelectorFromString(@"hint2:") forControlEvents:UIControlEventTouchUpInside];

        
        [self.view addSubview:hint];
        [self.view addSubview:hint2];
        
        
        //クリアした時のビュー
        completeView = [[UIView alloc] initWithFrame:self.view.bounds];
        completeView.backgroundColor = [UIColor blackColor];
        completeView.alpha = 0.0;
//        [self.view bringSubviewToFront:completeView];
        
        next = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        next.frame = CGRectMake(90, 250, 150, 40);
        next.alpha = 0.0;
        [next setTitle:@"next" forState:UIControlStateNormal];
        [next addTarget:self action:NSSelectorFromString(@"goToNextStage:") forControlEvents:UIControlEventTouchUpInside];
        

        [self.view addSubview:completeView];
        [self.view addSubview:next];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    if (touch.view.tag >= 100 && touch.view.tag <= 103) {
        [self zoomInImage:touch.view.tag];
    }
    else if(touch.view.tag == 105){
        [self zoomOutImage];
    }
}

- (void)zoomInImage:(int)tag{
    NSLog(@"%d",tag);
    switch (tag) {
        case 100:
            zoomImage.image = image1.image;
            break;
        case 101:
            zoomImage.image = image2.image;
            break;
        case 102:
            zoomImage.image = image3.image;
            break;
        case 103:
            zoomImage.image = image4.image;
            break;
        default:
            break;
    }
    [UIView animateWithDuration:0.5f animations:^(void) {
        zoomImage.alpha = 1.0;
    }];
}

- (void)zoomOutImage{
    [UIView animateWithDuration:0.5f animations:^(void) {
        zoomImage.alpha = 0.0;
    }];
}


- (void)setWord:(UIButton *)b{
    tapCount++;
    if (tapCount > 4) {
        [self showCompleteView];
    }
}

- (void)hint:(UIButton *)b{
    
}

- (void)hint2:(UIButton *)b{
    
}


- (void)showCompleteView{
    [UIView animateWithDuration:0.5f animations:^(void) {
        completeView.alpha = 0.7;
        next.alpha = 1.0;
    }];
}


- (void)goToNextStage:(UIButton *)b{
    [UIView animateWithDuration:0.5f animations:^(void) {
        completeView.alpha = 0.0;
        next.alpha = 0.0;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
