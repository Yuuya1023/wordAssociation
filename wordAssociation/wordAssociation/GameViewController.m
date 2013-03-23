//
//  GameViewController.m
//  wordAssociation
//
//  Created by 南部 祐耶 on 2013/03/12.
//  Copyright (c) 2013年 Yuya Nambu. All rights reserved.
//

#import "GameViewController.h"
#import "IAPManager.h"
#import "FacebookManager.h"

@interface GameViewController ()

@end

@implementation GameViewController

- (id)init
{
    self = [super init];
    if (self) {
        nowStage = [USER_DEFAULT integerForKey:@"nowStage"];
//        self.title = [NSString stringWithFormat:@"Stage %d",nowStage];
//        self.view.backgroundColor = [UIColor whiteColor];
        
        naviBarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        naviBarImageView.image = [UIImage imageNamed:@"Bar"];
        naviBarImageView.userInteractionEnabled = YES;
        [self.view addSubview:naviBarImageView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 6, 200, 30)];
        titleLabel.text = [NSString stringWithFormat:@"Stage %d",nowStage];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        
        [naviBarImageView addSubview:titleLabel];
        
        int navbarHeight = 44;
        
        //通知取得
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(hideAnimation) name:IAP_FINISHED_NOTIFICATION_NAME object:nil];
        
        UIImageView *BG = [[UIImageView alloc] initWithFrame:CGRectMake(0, navbarHeight, 320, self.view.bounds.size.height - navbarHeight)];
        BG.image = [UIImage imageNamed:@"Bg"];
        [self.view addSubview:BG];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(8, 7, 47, 28);
        [backButton setImage:[UIImage imageNamed:@"Back_Btn"] forState:UIControlStateNormal];
        [backButton addTarget:self action:NSSelectorFromString(@"back:") forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(240, 6, 70, 30);
        [button setImage:[UIImage imageNamed:@"Coin_Btn"] forState:UIControlStateNormal];
        [button addTarget:self action:NSSelectorFromString(@"showItemList:") forControlEvents:UIControlEventTouchUpInside];
        
        moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(21, -1, 45, 30)];
        moneyLabel.text = [USER_DEFAULT stringForKey:COINS_KEY];
        moneyLabel.adjustsFontSizeToFitWidth = YES;
        moneyLabel.textAlignment = NSTextAlignmentRight;
        moneyLabel.textColor = [UIColor whiteColor];
        moneyLabel.backgroundColor = [UIColor clearColor];
        [button addSubview:moneyLabel];
        
        [naviBarImageView addSubview:backButton];
        [naviBarImageView addSubview:button];

//        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//        self.navigationItem.leftBarButtonItem = leftButton;
//        self.navigationItem.rightBarButtonItem = rightButton;
        
        //写真たち
        image1 = [[UIImageView alloc] init];
        image1.userInteractionEnabled = YES;
        image1.tag = 100;
        image1.backgroundColor = [UIColor blackColor];
        
        image2 = [[UIImageView alloc] init];
        image2.userInteractionEnabled = YES;
        image2.tag = 101;
        image2.backgroundColor = [UIColor blueColor];
        
        image3 = [[UIImageView alloc] init];
        image3.userInteractionEnabled = YES;
        image3.tag = 102;
        image3.backgroundColor = [UIColor redColor];
        
        image4 = [[UIImageView alloc] init];
        image4.userInteractionEnabled = YES;
        image4.tag = 103;
        image4.backgroundColor = [UIColor yellowColor];
        
        zoomImage = [[UIImageView alloc] init];
        zoomImage.userInteractionEnabled = YES;
        zoomImage.tag = 105;
        zoomImage.alpha = 0.0;
        zoomImage.backgroundColor = [UIColor grayColor];
        
        if ([Utilities isDevice5thGen]) {
            image1.frame = CGRectMake(30, 30 + navbarHeight, 120, 120);
            image2.frame = CGRectMake(170, 30 + navbarHeight, 120, 120);
            image3.frame = CGRectMake(30, 160 + navbarHeight, 120, 120);
            image4.frame = CGRectMake(170, 160 + navbarHeight, 120, 120);
            zoomImage.frame = CGRectMake(35, 30 + navbarHeight, 250, 250);
        }
        else{
            image1.frame = CGRectMake(30, 10 + navbarHeight, 120, 120);
            image2.frame = CGRectMake(170, 10 + navbarHeight, 120, 120);
            image3.frame = CGRectMake(30, 140 + navbarHeight, 120, 120);
            image4.frame = CGRectMake(170, 140 + navbarHeight, 120, 120);
            zoomImage.frame = CGRectMake(35, 10 + navbarHeight, 250, 250);
        }

        
        [self.view addSubview:image1];
        [self.view addSubview:image2];
        [self.view addSubview:image3];
        [self.view addSubview:image4];
        [self.view addSubview:zoomImage];
        
        //答えが当てはまるパネル
        panelBg = [[UIImageView alloc] init];
        panelBg.userInteractionEnabled = YES;
        [self.view addSubview:panelBg];
        
        //答え用のボタンを用意
        UIImage *answerBtnBg = [UIImage imageNamed:@"Answer_Btn"];
        UIColor *titleColor_Ans = [UIColor whiteColor];
        UIFont *titleFont = [UIFont fontWithName:@"GillSans" size:18];
        
        int buttonSize = 35;
        
        answer1 = [UIButton buttonWithType:UIButtonTypeCustom];
        answer1.frame = CGRectMake(0, 0, buttonSize, buttonSize);
        answer1.tag = 201;
        answer1.titleLabel.font = titleFont;
        [answer1 setTitleColor:titleColor_Ans forState:UIControlStateNormal];
        [answer1 setBackgroundImage:answerBtnBg forState:UIControlStateNormal];
        [answer1 addTarget:self action:NSSelectorFromString(@"unsetWord:") forControlEvents:UIControlEventTouchUpInside];
        answer2 = [UIButton buttonWithType:UIButtonTypeCustom];
        answer2.frame = CGRectMake(39, 0, buttonSize, buttonSize);
        answer2.tag = 202;
        answer2.titleLabel.font = titleFont;
        [answer2 setTitleColor:titleColor_Ans forState:UIControlStateNormal];
        [answer2 setBackgroundImage:answerBtnBg forState:UIControlStateNormal];
        [answer2 addTarget:self action:NSSelectorFromString(@"unsetWord:") forControlEvents:UIControlEventTouchUpInside];
        answer3 = [UIButton buttonWithType:UIButtonTypeCustom];
        answer3.frame = CGRectMake(78, 0, buttonSize, buttonSize);
        answer3.tag = 203;
        answer3.titleLabel.font = titleFont;
        [answer3 setTitleColor:titleColor_Ans forState:UIControlStateNormal];
        [answer3 setBackgroundImage:answerBtnBg forState:UIControlStateNormal];
        [answer3 addTarget:self action:NSSelectorFromString(@"unsetWord:") forControlEvents:UIControlEventTouchUpInside];
        answer4 = [UIButton buttonWithType:UIButtonTypeCustom];
        answer4.frame = CGRectMake(117, 0, buttonSize, buttonSize);
        answer4.tag = 204;
        answer4.titleLabel.font = titleFont;
        [answer4 setTitleColor:titleColor_Ans forState:UIControlStateNormal];
        [answer4 setBackgroundImage:answerBtnBg forState:UIControlStateNormal];
        [answer4 addTarget:self action:NSSelectorFromString(@"unsetWord:") forControlEvents:UIControlEventTouchUpInside];
        answer5 = [UIButton buttonWithType:UIButtonTypeCustom];
        answer5.frame = CGRectMake(156, 0, buttonSize, buttonSize);
        answer5.tag = 205;
        answer5.titleLabel.font = titleFont;
        [answer5 setTitleColor:titleColor_Ans forState:UIControlStateNormal];
        [answer5 setBackgroundImage:answerBtnBg forState:UIControlStateNormal];
        [answer5 addTarget:self action:NSSelectorFromString(@"unsetWord:") forControlEvents:UIControlEventTouchUpInside];
        answer6 = [UIButton buttonWithType:UIButtonTypeCustom];
        answer6.frame = CGRectMake(195, 0, buttonSize, buttonSize);
        answer6.tag = 206;
        answer6.titleLabel.font = titleFont;
        [answer6 setTitleColor:titleColor_Ans forState:UIControlStateNormal];
        [answer6 setBackgroundImage:answerBtnBg forState:UIControlStateNormal];
        [answer6 addTarget:self action:NSSelectorFromString(@"unsetWord:") forControlEvents:UIControlEventTouchUpInside];
        answer7 = [UIButton buttonWithType:UIButtonTypeCustom];
        answer7.frame = CGRectMake(234, 0, buttonSize, buttonSize);
        answer7.tag = 207;
        answer7.titleLabel.font = titleFont;
        [answer7 setTitleColor:titleColor_Ans forState:UIControlStateNormal];
        [answer7 setBackgroundImage:answerBtnBg forState:UIControlStateNormal];
        [answer7 addTarget:self action:NSSelectorFromString(@"unsetWord:") forControlEvents:UIControlEventTouchUpInside];
        
        facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [facebookButton setBackgroundImage:[UIImage imageNamed:@"Facebook_Btn"] forState:UIControlStateNormal];
        [facebookButton addTarget:self action:NSSelectorFromString(@"facebookShare:") forControlEvents:UIControlEventTouchUpInside];
        [panelBg addSubview:facebookButton];
        
        //文字たち
        UIImage *btnBg = [UIImage imageNamed:@"Word_btn"];
        UIColor *titleColor = [UIColor blackColor];
//        UIFont *titleFont = [UIFont fontWithName:@"GillSans" size:18];

        button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame = CGRectMake(5, [UIScreen mainScreen].bounds.size.height - 160 + navbarHeight, 40, 40);
        [button1 setTitleColor:titleColor forState:UIControlStateNormal];
        button1.tag = 301;
        button1.titleLabel.font = titleFont;
        [button1 setBackgroundImage:btnBg forState:UIControlStateNormal];
        [button1 addTarget:self action:NSSelectorFromString(@"tapWord:") forControlEvents:UIControlEventTouchUpInside];
        
        button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        button2.frame = CGRectMake(50, [UIScreen mainScreen].bounds.size.height - 160 + navbarHeight, 40, 40);
        [button2 setTitleColor:titleColor forState:UIControlStateNormal];
        button2.tag = 302;
        button2.titleLabel.font = titleFont;
        [button2 setBackgroundImage:btnBg forState:UIControlStateNormal];
        [button2 addTarget:self action:NSSelectorFromString(@"tapWord:") forControlEvents:UIControlEventTouchUpInside];

        button3 = [UIButton buttonWithType:UIButtonTypeCustom];
        button3.frame = CGRectMake(95, [UIScreen mainScreen].bounds.size.height - 160 + navbarHeight, 40, 40);
        [button3 setTitleColor:titleColor forState:UIControlStateNormal];
        button3.tag = 303;
        button3.titleLabel.font = titleFont;
        [button3 setBackgroundImage:btnBg forState:UIControlStateNormal];
        [button3 addTarget:self action:NSSelectorFromString(@"tapWord:") forControlEvents:UIControlEventTouchUpInside];
        
        button4 = [UIButton buttonWithType:UIButtonTypeCustom];
        button4.frame = CGRectMake(140, [UIScreen mainScreen].bounds.size.height - 160 + navbarHeight, 40, 40);
        [button4 setTitleColor:titleColor forState:UIControlStateNormal];
        button4.tag = 304;
        button4.titleLabel.font = titleFont;
        [button4 setBackgroundImage:btnBg forState:UIControlStateNormal];
        [button4 addTarget:self action:NSSelectorFromString(@"tapWord:") forControlEvents:UIControlEventTouchUpInside];
        
        button5 = [UIButton buttonWithType:UIButtonTypeCustom];
        button5.frame = CGRectMake(185, [UIScreen mainScreen].bounds.size.height - 160 + navbarHeight, 40, 40);
        [button5 setTitleColor:titleColor forState:UIControlStateNormal];
        button5.tag = 305;
        button5.titleLabel.font = titleFont;
        [button5 setBackgroundImage:btnBg forState:UIControlStateNormal];
        [button5 addTarget:self action:NSSelectorFromString(@"tapWord:") forControlEvents:UIControlEventTouchUpInside];
        
        button6 = [UIButton buttonWithType:UIButtonTypeCustom];
        button6.frame = CGRectMake(230, [UIScreen mainScreen].bounds.size.height - 160 + navbarHeight, 40, 40);
        [button6 setTitleColor:titleColor forState:UIControlStateNormal];
        button6.tag = 306;
        button6.titleLabel.font = titleFont;
        [button6 setBackgroundImage:btnBg forState:UIControlStateNormal];
        [button6 addTarget:self action:NSSelectorFromString(@"tapWord:") forControlEvents:UIControlEventTouchUpInside];
        

        
        button7 = [UIButton buttonWithType:UIButtonTypeCustom];
        button7.frame = CGRectMake(5, [UIScreen mainScreen].bounds.size.height - 115 + navbarHeight, 40, 40);
        [button7 setTitleColor:titleColor forState:UIControlStateNormal];
        button7.tag = 307;
        button7.titleLabel.font = titleFont;
        [button7 setBackgroundImage:btnBg forState:UIControlStateNormal];
        [button7 addTarget:self action:NSSelectorFromString(@"tapWord:") forControlEvents:UIControlEventTouchUpInside];
        
        button8 = [UIButton buttonWithType:UIButtonTypeCustom];
        button8.frame = CGRectMake(50, [UIScreen mainScreen].bounds.size.height - 115 + navbarHeight, 40, 40);
        [button8 setTitleColor:titleColor forState:UIControlStateNormal];
        button8.tag = 308;
        button8.titleLabel.font = titleFont;
        [button8 setBackgroundImage:btnBg forState:UIControlStateNormal];
        [button8 addTarget:self action:NSSelectorFromString(@"tapWord:") forControlEvents:UIControlEventTouchUpInside];
        
        button9 = [UIButton buttonWithType:UIButtonTypeCustom];
        button9.frame = CGRectMake(95, [UIScreen mainScreen].bounds.size.height - 115 + navbarHeight, 40, 40);
        [button9 setTitleColor:titleColor forState:UIControlStateNormal];
        button9.tag = 309;
        button9.titleLabel.font = titleFont;
        [button9 setBackgroundImage:btnBg forState:UIControlStateNormal];
        [button9 addTarget:self action:NSSelectorFromString(@"tapWord:") forControlEvents:UIControlEventTouchUpInside];
        
        button10 = [UIButton buttonWithType:UIButtonTypeCustom];
        button10.frame = CGRectMake(140, [UIScreen mainScreen].bounds.size.height - 115 + navbarHeight, 40, 40);
        [button10 setTitleColor:titleColor forState:UIControlStateNormal];
        button10.tag = 310;
        button10.titleLabel.font = titleFont;
        [button10 setBackgroundImage:btnBg forState:UIControlStateNormal];
        [button10 addTarget:self action:NSSelectorFromString(@"tapWord:") forControlEvents:UIControlEventTouchUpInside];
        
        button11 = [UIButton buttonWithType:UIButtonTypeCustom];
        button11.frame = CGRectMake(185, [UIScreen mainScreen].bounds.size.height - 115 + navbarHeight, 40, 40);
        [button11 setTitleColor:titleColor forState:UIControlStateNormal];
        button11.tag = 311;
        button11.titleLabel.font = titleFont;
        [button11 setBackgroundImage:btnBg forState:UIControlStateNormal];
        [button11 addTarget:self action:NSSelectorFromString(@"tapWord:") forControlEvents:UIControlEventTouchUpInside];

        button12 = [UIButton buttonWithType:UIButtonTypeCustom];
        button12.frame = CGRectMake(230, [UIScreen mainScreen].bounds.size.height - 115 + navbarHeight, 40, 40);
        [button12 setTitleColor:titleColor forState:UIControlStateNormal];
        button12.tag = 312;
        button12.titleLabel.font = titleFont;
        [button12 setBackgroundImage:btnBg forState:UIControlStateNormal];
        [button12 addTarget:self action:NSSelectorFromString(@"tapWord:") forControlEvents:UIControlEventTouchUpInside];
        

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
        hint = [UIButton buttonWithType:UIButtonTypeCustom];
        hint.frame = CGRectMake(275, [UIScreen mainScreen].bounds.size.height - 160 + navbarHeight, 40, 40);
        [hint setImage:[UIImage imageNamed:@"Hitomoji_Btn_on"] forState:UIControlStateNormal];
//        [hint setBackgroundImage:[UIImage imageNamed:@"Hitomoji_on_Btn"] forState:UIControlStateNormal];
        [hint addTarget:self action:NSSelectorFromString(@"hint:") forControlEvents:UIControlEventTouchUpInside];
        
        hint2 = [UIButton buttonWithType:UIButtonTypeCustom];
        hint2.frame = CGRectMake(275, [UIScreen mainScreen].bounds.size.height - 115 + navbarHeight, 40, 40);
        [hint2 setImage:[UIImage imageNamed:@"Mojikeshi_Btn_on"] forState:UIControlStateNormal];
//        [hint2 setBackgroundImage:[UIImage imageNamed:@"Mojikeshi_on_Btn"] forState:UIControlStateNormal];
        [hint2 addTarget:self action:NSSelectorFromString(@"hint2:") forControlEvents:UIControlEventTouchUpInside];

        
        [self.view addSubview:hint];
        [self.view addSubview:hint2];

        
        //文字列セット
        answerArray = [[NSMutableArray alloc] init];
        answerTagArray = [[NSMutableArray alloc] init];
        didDeleteWordsTagArray = [[NSMutableArray alloc] init];
        [self setQuestion:nowStage];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Bar"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Title_Bar"] forBarMetrics:UIBarMetricsDefault];
}





//////写真のタップ判定

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    if (touch.view.tag >= 100 && touch.view.tag <= 103) {
        [self zoomInImage:touch.view.tag];
    }
    else if(touch.view.tag == 105){
        [self zoomOutImage];
    }
}






//////写真をタップした時にズームを行う

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
        image1.alpha = 0.0;
        image2.alpha = 0.0;
        image3.alpha = 0.0;
        image4.alpha = 0.0;
    }];
}







//////ズーム中の画像をズームアウトする

- (void)zoomOutImage{
    [UIView animateWithDuration:0.5f animations:^(void) {
        zoomImage.alpha = 0.0;
        image1.alpha = 1.0;
        image2.alpha = 1.0;
        image3.alpha = 1.0;
        image4.alpha = 1.0;
    }];
}







//////12文字の文字列群から文字を選択したとき

- (void)tapWord:(UIButton *)b{
    int insertStatus = 0;
    for (int i = 0; i < [answerArray count]; i++) {
        if ([[[answerArray objectAtIndex:i] objectForKey:@"string"] isEqualToString:@"-1"]) {
            if (insertStatus == 0) {
                insertStatus = 1;
                
                //文字列セット
                [self setWordWithTag:i title:b.titleLabel.text];
                
                NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     b.titleLabel.text,@"string",
                                     [NSString stringWithFormat:@"%d",b.tag],@"tag",
                                     [[answerArray objectAtIndex:i] objectForKey:@"usedHint"],@"usedHint",
                                     nil];
                [answerArray replaceObjectAtIndex:i withObject:dic];
                [b setEnabled:NO];
                
                //答え合わせ
                if(didSetWords == answerLength){
                    [self answerCheck];
                }
            }
            else{
                //まだ空きがある
                insertStatus = 2;
            }
        }
    }
//    if (insertStatus == 1) {
//        NSLog(@"答え合わせ");
//        [self answerCheck];
//    }
}






/////文字列セット

- (void)setWordWithTag:(int)tag title:(NSString *)title{
    switch (tag) {
        case 0:
            [answer1 setTitle:title forState:UIControlStateNormal];
            break;
        case 1:
            [answer2 setTitle:title forState:UIControlStateNormal];
            break;
        case 2:
            [answer3 setTitle:title forState:UIControlStateNormal];
            break;
        case 3:
            [answer4 setTitle:title forState:UIControlStateNormal];
            break;
        case 4:
            [answer5 setTitle:title forState:UIControlStateNormal];
            break;
        case 5:
            [answer6 setTitle:title forState:UIControlStateNormal];
            break;
        case 6:
            [answer7 setTitle:title forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    if ([[[answerArray objectAtIndex:tag] objectForKey:@"tag"] intValue] == -1) {
        didSetWords++;
    }
    else{
        [self buttonSetEnabled:[[[answerArray objectAtIndex:tag] objectForKey:@"tag"] intValue] enable:YES];
    }
    NSLog(@"didSetWords %d",didSetWords);
}






//////答えとして選択した文字列を解除する

- (void)unsetWord:(UIButton *)b{
    NSLog(@"unsetWord");
    [b setTitle:@"" forState:UIControlStateNormal];
    [self setColor:1];
    
    int tag = 0;
    int index = 0;
    //答えのパネルから文字を解除する
    switch (b.tag) {
        case 201:
            index = 0;
            break;
        case 202:
            index = 1;
            break;
        case 203:
            index = 2;
            break;
        case 204:
            index = 3;
            break;
        case 205:
            index = 4;
            break;
        case 206:
            index = 5;
            break;
        case 207:
            index = 6;
            break;
            
        default:
            break;
    }
    if ([[[answerArray objectAtIndex:index] objectForKey:@"tag"] intValue] != -1) {
        didSetWords--;
        
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"-1",@"string",
                             @"-1",@"tag",
                             [[answerArray objectAtIndex:index] objectForKey:@"usedHint"],@"usedHint",
                             nil];
        tag = [[[answerArray objectAtIndex:index] objectForKey:@"tag"] intValue];
        [answerArray replaceObjectAtIndex:index withObject:dic];
    }

    
    //12文字の選択されていた文字を復活させる
    [self buttonSetEnabled:tag enable:YES];
}






/////答えのボタンを有効or無効にする

- (void)buttonSetEnabled:(int)tag enable:(BOOL)enable{
    switch (tag) {
        case 301:
            [button1 setEnabled:enable];
            break;
        case 302:
            [button2 setEnabled:enable];
            break;
        case 303:
            [button3 setEnabled:enable];
            break;
        case 304:
            [button4 setEnabled:enable];
            break;
        case 305:
            [button5 setEnabled:enable];
            break;
        case 306:
            [button6 setEnabled:enable];
            break;
        case 307:
            [button7 setEnabled:enable];
            break;
        case 308:
            [button8 setEnabled:enable];
            break;
        case 309:
            [button9 setEnabled:enable];
            break;
        case 310:
            [button10 setEnabled:enable];
            break;
        case 311:
            [button11 setEnabled:enable];
            break;
        case 312:
            [button12 setEnabled:enable];
            break;
        default:
            break;
    }
}







/////ボタンにアルファ値をセットする

- (void)buttonSetAlpha:(int)tag alpha:(float)alpha{
    switch (tag) {
        case 0:
            button1.alpha = alpha;
            break;
        case 1:
            button2.alpha = alpha;
            break;
        case 2:
            button3.alpha = alpha;
            break;
        case 3:
            button4.alpha = alpha;
            break;
        case 4:
            button5.alpha = alpha;
            break;
        case 5:
            button6.alpha = alpha;
            break;
        case 6:
            button7.alpha = alpha;
            break;
        case 7:
            button8.alpha = alpha;
            break;
        case 8:
            button9.alpha = alpha;
            break;
        case 9:
            button10.alpha = alpha;
            break;
        case 10:
            button11.alpha = alpha;
            break;
        case 11:
            button12.alpha = alpha;
            break;
        default:
            break;
    }
}







//////解答をチェックする

- (void)answerCheck{
    NSMutableString *answer = [[NSMutableString alloc] initWithString:@""];
    for (int i = 0; i < [answerArray count]; i++) {
        [answer appendFormat:@"%@",[[answerArray objectAtIndex:i] objectForKey:@"string"]];
    }
    NSLog(@"どやっ %@",answer);
    
    NSDictionary *dic= [[USER_DEFAULT objectForKey:@"json"] objectAtIndex:nowStage - 1];
    if ([[dic objectForKey:@"answer"] isEqualToString:answer]) {
        NSLog(@"正解！");
        [self showCompleteView];
    }
    else{
        NSLog(@"残念！");
        timerStatus = 0;
        timerCount = 0;
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                          target:self
                                                        selector:@selector(timerAnimation:)
                                                        userInfo:nil
                                                         repeats:YES
                          ];
        [timer fire];
    }
}







//////タイマーで文字色を点滅させる

- (void)timerAnimation:(NSTimer *)t{
    if (timerStatus == 0) {
        [self setColor:0];
        timerStatus = 1;
    }
    else{
        [self setColor:1];
        timerStatus = 0;
    }
    timerCount++;
    if (timerCount >= 7) {
        [timer invalidate];
    }
}






//////問題が外れた時に文字色を変化させる

- (void)setColor:(int)type{
    if (type == 0) {
        [answer1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [answer2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [answer3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [answer4 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [answer5 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [answer6 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [answer7 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    else if (type == 1) {
        [answer1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [answer2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [answer3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [answer4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [answer5 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [answer6 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [answer7 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}





/////ランダムで文字をひとつ解放

- (void)hint:(UIButton *)b{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"いちもんじはかせ"
                                                    message:@"ふぉっふぉっふぉ、「60コイン」をくれればわしの発明で答えを一つおしえてやろう"
                                                   delegate:self
                                          cancelButtonTitle:@"キャンセル"
                                          otherButtonTitles:@"OK", nil];
    alert.tag = 400;
    [alert show];
}







/////ランダムで候補から三文字削除

- (void)hint2:(UIButton *)b{
    if (canDeleteWords == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"もじけしすないぱー"
                                                        message:@"もう消せる文字がないぜ！"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else{
        int deleteWords = 3;
        if (canDeleteWords < 3) {
            deleteWords = canDeleteWords;
        }

        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"もじけしすないぱー"
                                                        message:[NSString stringWithFormat:@"「%dコイン」でやとってくれれば「%d文字」消してやるぜ！",deleteWords * 30,deleteWords]
                                                       delegate:self
                                              cancelButtonTitle:@"キャンセル"
                                              otherButtonTitles:@"OK", nil];
        alert.tag = 401;
        [alert show];
    }
}







/////UIAlertView Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSDictionary *dic= [[USER_DEFAULT objectForKey:@"json"] objectAtIndex:nowStage - 1];
    int coins = [USER_DEFAULT integerForKey:COINS_KEY];
    if (alertView.tag == 400 && buttonIndex == 1) {
        if (coins < 60) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"コインがたりないようじゃのぉ"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        NSString *ans = [dic objectForKey:@"answer"];
        NSString *str = [dic objectForKey:@"string"];
        
        BOOL isOK = YES;
        while (isOK) {
            int rand = arc4random() % [ans length];
            NSMutableDictionary *inDic = [[NSMutableDictionary alloc] initWithDictionary:[answerArray objectAtIndex:rand]];
            if ([[inDic objectForKey:@"usedHint"] intValue] == -1) {
                int setTag = [[answerTagArray objectAtIndex:rand] intValue];
                
                //ボタンに文字をセット
//                [self buttonSetEnabled:setTag + 301 enable:NO];
                [self buttonSetAlpha:setTag alpha:0.0];
                [self setWordWithTag:rand title:[str substringWithRange:NSMakeRange(setTag,1)]];
                
                //配列に記憶
                [inDic setObject:@"1" forKey:@"usedHint"];
                [inDic setObject:[str substringWithRange:NSMakeRange(setTag,1)] forKey:@"string"];
                [inDic setObject:[NSString stringWithFormat:@"%d",setTag] forKey:@"tag"];
                [answerArray replaceObjectAtIndex:rand withObject:inDic];
                
                [USER_DEFAULT setObject:answerArray forKey:ANSWER_RESTORE_KEY];
                [USER_DEFAULT synchronize];
                
                //答えのボタンをロックする
                [self answerButtonLockWithTag:rand];
                
                //答え合わせ
                if(didSetWords == answerLength){
                    [self answerCheck];
                }
                
                [self setCoins:-60];
                isOK = NO;
            }
        }
    }
    else if (alertView.tag == 401 && buttonIndex == 1){
        NSLog(@"%d",canDeleteWords);
        int deleteWords = 3;
        if (canDeleteWords < 3) {
            deleteWords = canDeleteWords;
        }
        if (coins < (deleteWords * 30)) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"コインが足りないぜ！出直してきな！"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        canDeleteWords-=deleteWords;
        NSLog(@"%d",canDeleteWords);
        //消せる文字分繰り返す
        for (int i = 0; i < deleteWords; i ++) {
            BOOL isOK = YES;
            while (isOK) {
                int rand = arc4random() % 12;
                NSString *randIntStr = [NSString stringWithFormat:@"%d",rand];
                if(![answerTagArray containsObject:randIntStr] && ![didDeleteWordsTagArray containsObject:randIntStr]){
                    [self buttonSetAlpha:rand alpha:0.0];
                    [didDeleteWordsTagArray addObject:[NSString stringWithFormat:@"%d",rand]];
                    
                    [USER_DEFAULT setObject:didDeleteWordsTagArray forKey:WORDS_RESTORE_KEY];
                    [USER_DEFAULT synchronize];
                    
                    isOK = NO;
                }
            }
        }
        [self setCoins:-30 * deleteWords];
    }
}






/////答えのボタンをロック

- (void)answerButtonLockWithTag:(int)tag{
    switch (tag) {
        case 0:
            [answer1 setTitleColor:[UIColor greenColor] forState:UIControlStateDisabled];
            [answer1 setEnabled:NO];
            break;
        case 1:
            [answer2 setTitleColor:[UIColor greenColor] forState:UIControlStateDisabled];
            [answer2 setEnabled:NO];
            break;
        case 2:
            [answer3 setTitleColor:[UIColor greenColor] forState:UIControlStateDisabled];
            [answer3 setEnabled:NO];
            break;
        case 3:
            [answer4 setTitleColor:[UIColor greenColor] forState:UIControlStateDisabled];
            [answer4 setEnabled:NO];
            break;
        case 4:
            [answer5 setTitleColor:[UIColor greenColor] forState:UIControlStateDisabled];
            [answer5 setEnabled:NO];
            break;
        case 5:
            [answer6 setTitleColor:[UIColor greenColor] forState:UIControlStateDisabled];
            [answer6 setEnabled:NO];
            break;
        case 6:
            [answer7 setTitleColor:[UIColor greenColor] forState:UIControlStateDisabled];
            [answer7 setEnabled:NO];
            break;
        default:
            break;
    }
}







/////消した文字、答えを復元する

- (void)restoreAnswers{
    NSLog(@"%@",[USER_DEFAULT objectForKey:ANSWER_RESTORE_KEY]);
    
    [answerArray setArray:[USER_DEFAULT objectForKey:ANSWER_RESTORE_KEY]];
    for (int i = 0; i < [answerArray count]; i++) {
        NSMutableDictionary *inDic = [[NSMutableDictionary alloc] initWithDictionary:[answerArray objectAtIndex:i]];
        if ([[inDic objectForKey:@"usedHint"] intValue] == 1) {
            didSetWords++;
            [self buttonSetAlpha:[[inDic objectForKey:@"tag"] intValue] alpha:0.0];
            [self setWordWithTag:i title:[inDic objectForKey:@"string"]];
            
            //答えのボタンをロック
            [self answerButtonLockWithTag:i];
        }
        else{
            [inDic setObject:@"-1" forKey:@"usedHint"];
            [inDic setObject:@"-1" forKey:@"string"];
            [inDic setObject:@"-1" forKey:@"tag"];
            [answerArray replaceObjectAtIndex:i withObject:inDic];
        }
    }
}
- (void)restoreWords{
    NSLog(@"%@",[USER_DEFAULT objectForKey:WORDS_RESTORE_KEY]);
    
//    didDeleteWordsTagArray = [USER_DEFAULT objectForKey:WORDS_RESTORE_KEY];
    [didDeleteWordsTagArray setArray:[USER_DEFAULT objectForKey:WORDS_RESTORE_KEY]];
    for (int i = 0; i < [didDeleteWordsTagArray count]; i++) {
        [self buttonSetAlpha:[[didDeleteWordsTagArray objectAtIndex:i] intValue] alpha:0.0];
    }
}







/////差分のコインをセットする

- (void)setCoins:(int)margin{
    int coins = [USER_DEFAULT integerForKey:COINS_KEY];
    NSLog(@"before coins %d",coins);
    coins+=margin;
    NSLog(@"after coins %d",coins);
    [USER_DEFAULT setInteger:coins forKey:COINS_KEY];
    [USER_DEFAULT synchronize];
    
    moneyLabel.text = [USER_DEFAULT stringForKey:COINS_KEY];
}








//////問題をセット

- (void)setQuestion:(int)stage{
    NSDictionary *dic= [[USER_DEFAULT objectForKey:@"json"] objectAtIndex:stage - 1];
    
    //写真
    image1.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d_1",stage]];
    image2.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d_2",stage]];
    image3.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d_3",stage]];
    image4.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d_4",stage]];
    
    //12文字
    NSString *str = [dic objectForKey:@"string"];
    [button1 setTitle:[str substringWithRange:NSMakeRange(0,1)] forState:UIControlStateNormal];
    [button2 setTitle:[str substringWithRange:NSMakeRange(1,1)] forState:UIControlStateNormal];
    [button3 setTitle:[str substringWithRange:NSMakeRange(2,1)] forState:UIControlStateNormal];
    [button4 setTitle:[str substringWithRange:NSMakeRange(3,1)] forState:UIControlStateNormal];
    [button5 setTitle:[str substringWithRange:NSMakeRange(4,1)] forState:UIControlStateNormal];
    [button6 setTitle:[str substringWithRange:NSMakeRange(5,1)] forState:UIControlStateNormal];
    [button7 setTitle:[str substringWithRange:NSMakeRange(6,1)] forState:UIControlStateNormal];
    [button8 setTitle:[str substringWithRange:NSMakeRange(7,1)] forState:UIControlStateNormal];
    [button9 setTitle:[str substringWithRange:NSMakeRange(8,1)] forState:UIControlStateNormal];
    [button10 setTitle:[str substringWithRange:NSMakeRange(9,1)] forState:UIControlStateNormal];
    [button11 setTitle:[str substringWithRange:NSMakeRange(10,1)] forState:UIControlStateNormal];
    [button12 setTitle:[str substringWithRange:NSMakeRange(11,1)] forState:UIControlStateNormal];
    
    
    //答えを埋め込むパネル
    [answer1 removeFromSuperview];
    [answer2 removeFromSuperview];
    [answer3 removeFromSuperview];
    [answer4 removeFromSuperview];
    [answer5 removeFromSuperview];
    [answer6 removeFromSuperview];
    [answer7 removeFromSuperview];
    
    //画面サイズ判定
    int rectY;
    if ([Utilities isDevice5thGen]) {
        rectY = 390;
    }
    else{
        rectY = 314;
    }
    
    NSString *ans = [dic objectForKey:@"answer"];
    answerLength = [ans length];
    canDeleteWords = 12 - answerLength;
    NSLog(@"length %d",answerLength);
    int buttonSize = 35;
    switch ([ans length]) {
        case 2:
            panelBg.frame = CGRectMake(105, rectY, 120, 40);
            [panelBg addSubview:answer1];
            [panelBg addSubview:answer2];
            facebookButton.frame = CGRectMake(87, 2, buttonSize, buttonSize);
            break;
        case 3:
            panelBg.frame = CGRectMake(85, rectY, 160, 40);
            [panelBg addSubview:answer1];
            [panelBg addSubview:answer2];
            [panelBg addSubview:answer3];
            facebookButton.frame = CGRectMake(127, 2, buttonSize, buttonSize);
            break;
        case 4:
            panelBg.frame = CGRectMake(65, rectY, 200, 40);
            [panelBg addSubview:answer1];
            [panelBg addSubview:answer2];
            [panelBg addSubview:answer3];
            [panelBg addSubview:answer4];
            facebookButton.frame = CGRectMake(167, 2, buttonSize, buttonSize);
            break;
        case 5:
            panelBg.frame = CGRectMake(45, rectY, 240, 40);
            [panelBg addSubview:answer1];
            [panelBg addSubview:answer2];
            [panelBg addSubview:answer3];
            [panelBg addSubview:answer4];
            [panelBg addSubview:answer5];
            facebookButton.frame = CGRectMake(207, 2, buttonSize, buttonSize);
            break;
        case 6:
            panelBg.frame = CGRectMake(25, rectY, 280, 40);
            [panelBg addSubview:answer1];
            [panelBg addSubview:answer2];
            [panelBg addSubview:answer3];
            [panelBg addSubview:answer4];
            [panelBg addSubview:answer5];
            [panelBg addSubview:answer6];
            facebookButton.frame = CGRectMake(247, 2, buttonSize, buttonSize);
            break;
        case 7:
            panelBg.frame = CGRectMake(5, rectY, 320, 40);
            [panelBg addSubview:answer1];
            [panelBg addSubview:answer2];
            [panelBg addSubview:answer3];
            [panelBg addSubview:answer4];
            [panelBg addSubview:answer5];
            [panelBg addSubview:answer6];
            [panelBg addSubview:answer7];
            facebookButton.frame = CGRectMake(277, 2, buttonSize, buttonSize);
            break;
        default:
            break;
    }
//    [panelBg addSubview:facebookButton];
    [self initiarizeArray:[ans length]];
    
    //答えのタグを配列に記憶
    for (int i = 0; i < [ans length]; i++) {
        for (int j = 0; j < 12; j++) {
            
            NSString *tmpStr = [str substringWithRange:NSMakeRange(j,1)];
            NSString *tmpAns = [ans substringWithRange:NSMakeRange(i,1)];
            if ([tmpStr isEqualToString:tmpAns]) {
                [answerTagArray replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d",j]];
            }
        }
    }
    NSLog(@"answerTagArray %@",answerTagArray);
}






//////配列を初期化する

- (void)initiarizeArray:(int)num{
    if ([USER_DEFAULT objectForKey:ANSWER_RESTORE_KEY] == nil) {
        [answerArray removeAllObjects];
        for (int i = 0; i< num; i++) {
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"-1",@"string",
                                 @"-1",@"tag",
                                 @"-1",@"usedHint",
                                 nil];
            [answerArray addObject:dic];
        }
    }
    else{
        [self restoreAnswers];
    }
    
    //答えのタグのみを格納する配列
    [answerTagArray removeAllObjects];
    for (int i = 0; i< num; i++) {
        [answerTagArray addObject:@"-1"];
    }
    
    if ([USER_DEFAULT objectForKey:WORDS_RESTORE_KEY] == nil) {
        [didDeleteWordsTagArray removeAllObjects];
    }
    else{
        [self restoreWords];
    }
    
}




//////ナビゲーションバーのもどるボタンを押した時

- (void)back:(UIBarButtonItem *)b{
    [self.navigationController popViewControllerAnimated:YES];
}





//////課金アイテムの一覧を表示

- (void)showItemList:(UIButton *)b{
    //購入履歴のチェックを行うためインスタンスを取得
    [IAPManager sharedInstance];
    
    grayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    grayView.backgroundColor = [UIColor blackColor];
    grayView.alpha = 0.6;
    
    itemListView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Item_Board"]];
    itemListView.frame = CGRectMake(12, 30, 296, 412);
//    itemListView.backgroundColor = [UIColor blueColor];
    itemListView.userInteractionEnabled = YES;
    
    [self.view addSubview:grayView];
    [self.view addSubview:itemListView];
    
    //値段表記
//    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
//    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
//    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
//    [numberFormatter setLocale:product.priceLocale];
//    NSString *formattedString = [numberFormatter stringFromNumber:product.price];
    
    //ボタン
    UIImage *item1_image = [UIImage imageNamed:@"item1_Btn"];
    UIImage *item2_image = [UIImage imageNamed:@"item2_Btn"];
    UIImage *item3_image = [UIImage imageNamed:@"item3_Btn"];
    UIImage *item4_image = [UIImage imageNamed:@"item4_Btn"];
    UIImage *item5_image = [UIImage imageNamed:@"item5_Btn"];
    
    item1 = [UIButton buttonWithType:UIButtonTypeCustom];
    item1.frame = CGRectMake(22, 79, 250, 50);
    item1.tag = 0;
    [item1 setBackgroundImage:item1_image forState:UIControlStateNormal];
    [item1 addTarget:self action:NSSelectorFromString(@"inAppPurchase:") forControlEvents:UIControlEventTouchUpInside];
    
    item2 = [UIButton buttonWithType:UIButtonTypeCustom];
    item2.frame = CGRectMake(22, 130, 250, 50);
    item2.tag = 1;
    [item2 setBackgroundImage:item2_image forState:UIControlStateNormal];
    [item2 addTarget:self action:NSSelectorFromString(@"inAppPurchase:") forControlEvents:UIControlEventTouchUpInside];
    
    item3 = [UIButton buttonWithType:UIButtonTypeCustom];
    item3.frame = CGRectMake(22, 180, 250, 50);
    item3.tag = 2;
    [item3 setBackgroundImage:item3_image forState:UIControlStateNormal];
    [item3 addTarget:self action:NSSelectorFromString(@"inAppPurchase:") forControlEvents:UIControlEventTouchUpInside];
    
    item4 = [UIButton buttonWithType:UIButtonTypeCustom];
    item4.frame = CGRectMake(22, 230, 250, 50);
    item4.tag = 3;
    [item4 setBackgroundImage:item4_image forState:UIControlStateNormal];
    [item4 addTarget:self action:NSSelectorFromString(@"inAppPurchase:") forControlEvents:UIControlEventTouchUpInside];
    
    item5 = [UIButton buttonWithType:UIButtonTypeCustom];
    item5.frame = CGRectMake(22, 280, 250, 50);
    item5.tag = 4;
    [item5 setBackgroundImage:item5_image forState:UIControlStateNormal];
    [item5 addTarget:self action:NSSelectorFromString(@"inAppPurchase:") forControlEvents:UIControlEventTouchUpInside];
    
    [itemListView addSubview:item1];
    [itemListView addSubview:item2];
    [itemListView addSubview:item3];
    [itemListView addSubview:item4];
    [itemListView addSubview:item5];
    
    item1_price = [[UILabel alloc] initWithFrame:CGRectMake(160, 9, 60, 30)];
    item1_price.text = NSLocalizedString(@"price1Price", @"値段1");
    item1_price.textAlignment = NSTextAlignmentRight;
    item1_price.backgroundColor = [UIColor clearColor];
    item1_price.textColor = [UIColor darkGrayColor];
    
    item2_price = [[UILabel alloc] initWithFrame:CGRectMake(160, 9, 60, 30)];
    item2_price.text = NSLocalizedString(@"price2Price", @"値段2");
    item2_price.textAlignment = NSTextAlignmentRight;
    item2_price.backgroundColor = [UIColor clearColor];
    item2_price.textColor = [UIColor darkGrayColor];
    
    item3_price = [[UILabel alloc] initWithFrame:CGRectMake(160, 9, 60, 30)];
    item3_price.text = NSLocalizedString(@"price3Price", @"値段3");
    item3_price.textAlignment = NSTextAlignmentRight;
    item3_price.backgroundColor = [UIColor clearColor];
    item3_price.textColor = [UIColor darkGrayColor];
    
    item4_price = [[UILabel alloc] initWithFrame:CGRectMake(160, 9, 60, 30)];
    item4_price.text = NSLocalizedString(@"price4Price", @"値段4");
    item4_price.textAlignment = NSTextAlignmentRight;
    item4_price.backgroundColor = [UIColor clearColor];
    item4_price.textColor = [UIColor darkGrayColor];
    
    item5_price = [[UILabel alloc] initWithFrame:CGRectMake(160, 9, 60, 30)];
    item5_price.text = NSLocalizedString(@"price5Price", @"値段5");
    item5_price.textAlignment = NSTextAlignmentRight;
    item5_price.backgroundColor = [UIColor clearColor];
    item5_price.textColor = [UIColor darkGrayColor];
    
    
    [item1 addSubview:item1_price];
    [item2 addSubview:item2_price];
    [item3 addSubview:item3_price];
    [item4 addSubview:item4_price];
    [item5 addSubview:item5_price];
    
    cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(95, 335, 100 * 1.1, 30 * 1.1);
    [cancel setBackgroundImage:[UIImage imageNamed:@"Cancel_Btn"] forState:UIControlStateNormal];
    [cancel addTarget:self action:NSSelectorFromString(@"cancel:") forControlEvents:UIControlEventTouchUpInside];
    
    [itemListView addSubview:cancel];
    
}





//////課金アイテムを選択した時

- (void)inAppPurchase:(UIButton *)b{
    [item1 removeFromSuperview];
    [item2 removeFromSuperview];
    [item3 removeFromSuperview];
    [item4 removeFromSuperview];
    [item5 removeFromSuperview];
    [cancel removeFromSuperview];
    [itemListView removeFromSuperview];
    
    IAPManager *iapManager = [IAPManager sharedInstance];
    if ([iapManager checkCanMakePayment]) {
        //ぐるぐるを出す
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        indicator.center = self.view.center;
        [indicator startAnimating];
        [grayView addSubview:indicator];
        
        [iapManager startProductRequestWithItemType:b.tag];
    }
}






//////アイテム選択画面を消す

- (void)cancel:(UIButton *)b{
    [item1 removeFromSuperview];
    [item2 removeFromSuperview];
    [item3 removeFromSuperview];
    [item4 removeFromSuperview];
    [item5 removeFromSuperview];
    [cancel removeFromSuperview];
    [grayView removeFromSuperview];
    [itemListView removeFromSuperview];
}



//////課金終了後にアニメーションを見えなくする

- (void)hideAnimation{
    [UIView animateWithDuration:0.3f animations:^(void) {
        grayView.alpha = 0.0;
        moneyLabel.text = [USER_DEFAULT stringForKey:COINS_KEY];
        
    }completion:^(BOOL finished){
        [indicator removeFromSuperview];
        [grayView removeFromSuperview];
    }];
}




//////クリア画面表示

- (void)showCompleteView{
    
    //クリアした時のビュー
    completeView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    completeView.backgroundColor = [UIColor blackColor];
    completeView.alpha = 0.0;
    
    textImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"text_clear"]];
    textImageView.backgroundColor = [UIColor clearColor];
    textImageView.alpha = 0.0;
    textImageView.frame = CGRectMake(60, 100, 200, 50);
    
    next = [UIButton buttonWithType:UIButtonTypeCustom];
    next.frame = CGRectMake(95, 330, 174 /4*3, 52 /4*3);
    next.alpha = 0.0;
    [next setImage:[UIImage imageNamed:@"Next_Btn"] forState:UIControlStateNormal];
    [next addTarget:self action:NSSelectorFromString(@"goToNextStage:") forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationController.view addSubview:completeView];
    [self.navigationController.view addSubview:textImageView];
    [self.navigationController.view addSubview:next];
    
    
    compPanel = [[UIImageView alloc] init];
    compPanel.alpha = 0.0;
    [self.navigationController.view addSubview:compPanel];
    
    //ボタンたち
    UIImage *buttonImage = [UIImage imageNamed:@"Answer_Btn"];
    int size = 40;
    
    compButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    compButton1.frame = CGRectMake(0, 0, size, size);
    [compButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    compButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    compButton2.frame = CGRectMake(size, 0, size, size);
    [compButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    compButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    compButton3.frame = CGRectMake(size * 2, 0, size, size);
    [compButton3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    compButton4 = [UIButton buttonWithType:UIButtonTypeCustom];
    compButton4.frame = CGRectMake(size * 3, 0, size, size);
    [compButton4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    compButton5 = [UIButton buttonWithType:UIButtonTypeCustom];
    compButton5.frame = CGRectMake(size * 4, 0, size, size);
    [compButton5 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    compButton6 = [UIButton buttonWithType:UIButtonTypeCustom];
    compButton6.frame = CGRectMake(size * 5, 0, size, size);
    [compButton6 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    compButton7 = [UIButton buttonWithType:UIButtonTypeCustom];
    compButton7.frame = CGRectMake(size * 6, 0, size, size);
    [compButton7 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    NSDictionary *dic= [[USER_DEFAULT objectForKey:@"json"] objectAtIndex:nowStage - 1];
    NSString *answer = [dic objectForKey:@"answer"];
    
    int rectY = 200;
    switch ([answer length]) {
        case 2:
            compPanel.frame = CGRectMake(120, rectY, 120, 40);
            [compPanel addSubview:compButton1];
            [compPanel addSubview:compButton2];
            //            facebookButton.frame = CGRectMake(87, 2, size, size);
            
            [compButton1 setTitle:[answer substringWithRange:NSMakeRange(0,1)] forState:UIControlStateNormal];
            [compButton2 setTitle:[answer substringWithRange:NSMakeRange(1,1)] forState:UIControlStateNormal];
            break;
        case 3:
            compPanel.frame = CGRectMake(100, rectY, 160, 40);
            [compPanel addSubview:compButton1];
            [compPanel addSubview:compButton2];
            [compPanel addSubview:compButton3];
            //            facebookButton.frame = CGRectMake(127, 2, size, size);
            
            [compButton1 setTitle:[answer substringWithRange:NSMakeRange(0,1)] forState:UIControlStateNormal];
            [compButton2 setTitle:[answer substringWithRange:NSMakeRange(1,1)] forState:UIControlStateNormal];
            [compButton3 setTitle:[answer substringWithRange:NSMakeRange(2,1)] forState:UIControlStateNormal];
            break;
        case 4:
            compPanel.frame = CGRectMake(80, rectY, 200, 40);
            [compPanel addSubview:compButton1];
            [compPanel addSubview:compButton2];
            [compPanel addSubview:compButton3];
            [compPanel addSubview:compButton4];
            //            facebookButton.frame = CGRectMake(167, 2, size, size);
            
            [compButton1 setTitle:[answer substringWithRange:NSMakeRange(0,1)] forState:UIControlStateNormal];
            [compButton2 setTitle:[answer substringWithRange:NSMakeRange(1,1)] forState:UIControlStateNormal];
            [compButton3 setTitle:[answer substringWithRange:NSMakeRange(2,1)] forState:UIControlStateNormal];
            [compButton4 setTitle:[answer substringWithRange:NSMakeRange(3,1)] forState:UIControlStateNormal];
            break;
        case 5:
            compPanel.frame = CGRectMake(60, rectY, 240, 40);
            [compPanel addSubview:compButton1];
            [compPanel addSubview:compButton2];
            [compPanel addSubview:compButton3];
            [compPanel addSubview:compButton4];
            [compPanel addSubview:compButton5];
            //            facebookButton.frame = CGRectMake(207, 2, size, size);
            
            [compButton1 setTitle:[answer substringWithRange:NSMakeRange(0,1)] forState:UIControlStateNormal];
            [compButton2 setTitle:[answer substringWithRange:NSMakeRange(1,1)] forState:UIControlStateNormal];
            [compButton3 setTitle:[answer substringWithRange:NSMakeRange(2,1)] forState:UIControlStateNormal];
            [compButton4 setTitle:[answer substringWithRange:NSMakeRange(3,1)] forState:UIControlStateNormal];
            [compButton5 setTitle:[answer substringWithRange:NSMakeRange(4,1)] forState:UIControlStateNormal];
            break;
        case 6:
            compPanel.frame = CGRectMake(40, rectY, 280, 40);
            [compPanel addSubview:compButton1];
            [compPanel addSubview:compButton2];
            [compPanel addSubview:compButton3];
            [compPanel addSubview:compButton4];
            [compPanel addSubview:compButton5];
            [compPanel addSubview:compButton6];
            //            facebookButton.frame = CGRectMake(247, 2, size, size);
            
            [compButton1 setTitle:[answer substringWithRange:NSMakeRange(0,1)] forState:UIControlStateNormal];
            [compButton2 setTitle:[answer substringWithRange:NSMakeRange(1,1)] forState:UIControlStateNormal];
            [compButton3 setTitle:[answer substringWithRange:NSMakeRange(2,1)] forState:UIControlStateNormal];
            [compButton4 setTitle:[answer substringWithRange:NSMakeRange(3,1)] forState:UIControlStateNormal];
            [compButton5 setTitle:[answer substringWithRange:NSMakeRange(4,1)] forState:UIControlStateNormal];
            [compButton6 setTitle:[answer substringWithRange:NSMakeRange(5,1)] forState:UIControlStateNormal];
            break;
        case 7:
            compPanel.frame = CGRectMake(20, rectY, 320, 40);
            [compPanel addSubview:compButton1];
            [compPanel addSubview:compButton2];
            [compPanel addSubview:compButton3];
            [compPanel addSubview:compButton4];
            [compPanel addSubview:compButton5];
            [compPanel addSubview:compButton6];
            [compPanel addSubview:compButton7];
            //            facebookButton.frame = CGRectMake(277, 2, size, size);
            
            [compButton1 setTitle:[answer substringWithRange:NSMakeRange(0,1)] forState:UIControlStateNormal];
            [compButton2 setTitle:[answer substringWithRange:NSMakeRange(1,1)] forState:UIControlStateNormal];
            [compButton3 setTitle:[answer substringWithRange:NSMakeRange(2,1)] forState:UIControlStateNormal];
            [compButton4 setTitle:[answer substringWithRange:NSMakeRange(3,1)] forState:UIControlStateNormal];
            [compButton5 setTitle:[answer substringWithRange:NSMakeRange(4,1)] forState:UIControlStateNormal];
            [compButton6 setTitle:[answer substringWithRange:NSMakeRange(5,1)] forState:UIControlStateNormal];
            [compButton7 setTitle:[answer substringWithRange:NSMakeRange(6,1)] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    [compButton1 setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [compButton2 setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [compButton3 setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [compButton4 setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [compButton5 setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [compButton6 setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [compButton7 setBackgroundImage:buttonImage forState:UIControlStateNormal];
    
    //次ステージの準備
    nowStage++;
    [USER_DEFAULT setInteger:nowStage forKey:@"nowStage"];
    [USER_DEFAULT setObject:nil forKey:ANSWER_RESTORE_KEY];
    [USER_DEFAULT setObject:nil forKey:WORDS_RESTORE_KEY];
    [USER_DEFAULT synchronize];
    
    [UIView animateWithDuration:0.5f animations:^(void) {
        completeView.alpha = 0.7;
        textImageView.alpha = 1.0;
        compPanel.alpha = 1.0;
        next.alpha = 1.0;
    }];
}





//////次ページへ遷移

- (void)goToNextStage:(UIButton *)b{
    [self setQuestion:nowStage];
    [self deselestAll];
    [UIView animateWithDuration:0.5f animations:^(void) {
        titleLabel.text = [NSString stringWithFormat:@"Stage %d",nowStage];
        completeView.alpha = 0.0;
        textImageView.alpha = 0.0;
        compPanel.alpha = 0.0;
        next.alpha = 0.0;
        
        [next removeFromSuperview];
        [compButton1 removeFromSuperview];
        [compButton2 removeFromSuperview];
        [compButton3 removeFromSuperview];
        [compButton4 removeFromSuperview];
        [compButton5 removeFromSuperview];
        [compButton6 removeFromSuperview];
        [compButton7 removeFromSuperview];
        [compPanel removeFromSuperview];
        [textImageView removeFromSuperview];
        [completeView removeFromSuperview];
    }];
    
}



//////選択中の文字を全て解除

- (void)deselestAll{
    didSetWords = 0;
    [button1 setEnabled:YES];
    [button2 setEnabled:YES];
    [button3 setEnabled:YES];
    [button4 setEnabled:YES];
    [button5 setEnabled:YES];
    [button6 setEnabled:YES];
    [button7 setEnabled:YES];
    [button8 setEnabled:YES];
    [button9 setEnabled:YES];
    [button10 setEnabled:YES];
    [button11 setEnabled:YES];
    [button12 setEnabled:YES];
    
    button1.alpha = 1.0;
    button2.alpha = 1.0;
    button3.alpha = 1.0;
    button4.alpha = 1.0;
    button5.alpha = 1.0;
    button6.alpha = 1.0;
    button7.alpha = 1.0;
    button8.alpha = 1.0;
    button9.alpha = 1.0;
    button10.alpha = 1.0;
    button11.alpha = 1.0;
    button12.alpha = 1.0;
    
    [answer1 setEnabled:YES];
    [answer2 setEnabled:YES];
    [answer3 setEnabled:YES];
    [answer4 setEnabled:YES];
    [answer5 setEnabled:YES];
    [answer6 setEnabled:YES];
    [answer7 setEnabled:YES];
    
    [answer1 setTitle:@"" forState:UIControlStateNormal];
    [answer2 setTitle:@"" forState:UIControlStateNormal];
    [answer3 setTitle:@"" forState:UIControlStateNormal];
    [answer4 setTitle:@"" forState:UIControlStateNormal];
    [answer5 setTitle:@"" forState:UIControlStateNormal];
    [answer6 setTitle:@"" forState:UIControlStateNormal];
    [answer7 setTitle:@"" forState:UIControlStateNormal];
    
    [answer1 setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
    [answer2 setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
    [answer3 setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
    [answer4 setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
    [answer5 setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
    [answer6 setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
    [answer7 setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
}


- (void)facebookShare:(UIButton *)b{
    FacebookManager *fbManager = [FacebookManager sharedInstance];
//    [fbManager publish];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Mojikeshi_Btn_on" ofType:@"png"];
//    NSLog(@"%@",path);
    [fbManager publishWithDescription:@"testtest" filePath:@"http://blog-imgs-54.fc2.com/d/0/9/d09325/img_387733_4701749_0.jpg"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
