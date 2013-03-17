//
//  GameViewController.m
//  wordAssociation
//
//  Created by 南部 祐耶 on 2013/03/12.
//  Copyright (c) 2013年 Yuya Nambu. All rights reserved.
//

#import "GameViewController.h"
#import "IAPManager.h"

@interface GameViewController ()

@end

@implementation GameViewController

- (id)init
{
    self = [super init];
    if (self) {
        nowStage = [USER_DEFAULT integerForKey:@"nowStage"];
        self.title = [NSString stringWithFormat:@"Stage %d",nowStage];
//        self.view.backgroundColor = [UIColor whiteColor];
        
        //通知取得
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(hideAnimation) name:IAP_FINISHED_NOTIFICATION_NAME object:nil];
        
        UIImageView *BG = [[UIImageView alloc] initWithFrame:self.view.bounds];
        BG.image = [UIImage imageNamed:@"bg.jpg"];
        [self.view addSubview:BG];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 0, 70, 30);
        [backButton setImage:[UIImage imageNamed:@"Back_btn"] forState:UIControlStateNormal];
        [backButton addTarget:self action:NSSelectorFromString(@"back:") forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 90, 30);
        [button setImage:[UIImage imageNamed:@"money_Btn"] forState:UIControlStateNormal];
        [button addTarget:self action:NSSelectorFromString(@"showItemList:") forControlEvents:UIControlEventTouchUpInside];

        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = leftButton;
        self.navigationItem.rightBarButtonItem = rightButton;
        
        //写真たち
        image1 = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 120, 120)];
        image1.userInteractionEnabled = YES;
        image1.tag = 100;
        image1.backgroundColor = [UIColor blackColor];
        
        image2 = [[UIImageView alloc] initWithFrame:CGRectMake(170, 10, 120, 120)];
        image2.userInteractionEnabled = YES;
        image2.tag = 101;
        image2.backgroundColor = [UIColor blueColor];
        
        image3 = [[UIImageView alloc] initWithFrame:CGRectMake(30, 140, 120, 120)];
        image3.userInteractionEnabled = YES;
        image3.tag = 102;
        image3.backgroundColor = [UIColor redColor];
        
        image4 = [[UIImageView alloc] initWithFrame:CGRectMake(170, 140, 120, 120)];
        image4.userInteractionEnabled = YES;
        image4.tag = 103;
        image4.backgroundColor = [UIColor yellowColor];
        
        zoomImage = [[UIImageView alloc] initWithFrame:CGRectMake(35, 10, 250, 250)];
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
        panelBg = [[UIImageView alloc] init];
        panelBg.userInteractionEnabled = YES;
        [self.view addSubview:panelBg];
        
        //答え用のボタンを用意
        UIImage *answerBtnBg = [UIImage imageNamed:@"num_Bg02"];
        UIColor *titleColor = [UIColor blackColor];
        UIFont *titleFont = [UIFont fontWithName:@"GillSans" size:18];
        
        answer1 = [UIButton buttonWithType:UIButtonTypeCustom];
        answer1.frame = CGRectMake(0, 0, 40, 40);
        answer1.tag = 201;
        answer1.titleLabel.font = titleFont;
        [answer1 setTitleColor:titleColor forState:UIControlStateNormal];
        [answer1 setBackgroundImage:answerBtnBg forState:UIControlStateNormal];
        [answer1 addTarget:self action:NSSelectorFromString(@"unsetWord:") forControlEvents:UIControlEventTouchUpInside];
        answer2 = [UIButton buttonWithType:UIButtonTypeCustom];
        answer2.frame = CGRectMake(40, 0, 40, 40);
        answer2.tag = 202;
        answer2.titleLabel.font = titleFont;
        [answer2 setTitleColor:titleColor forState:UIControlStateNormal];
        [answer2 setBackgroundImage:answerBtnBg forState:UIControlStateNormal];
        [answer2 addTarget:self action:NSSelectorFromString(@"unsetWord:") forControlEvents:UIControlEventTouchUpInside];
        answer3 = [UIButton buttonWithType:UIButtonTypeCustom];
        answer3.frame = CGRectMake(80, 0, 40, 40);
        answer3.tag = 203;
        answer3.titleLabel.font = titleFont;
        [answer3 setTitleColor:titleColor forState:UIControlStateNormal];
        [answer3 setBackgroundImage:answerBtnBg forState:UIControlStateNormal];
        [answer3 addTarget:self action:NSSelectorFromString(@"unsetWord:") forControlEvents:UIControlEventTouchUpInside];
        answer4 = [UIButton buttonWithType:UIButtonTypeCustom];
        answer4.frame = CGRectMake(120, 0, 40, 40);
        answer4.tag = 204;
        answer4.titleLabel.font = titleFont;
        [answer4 setTitleColor:titleColor forState:UIControlStateNormal];
        [answer4 setBackgroundImage:answerBtnBg forState:UIControlStateNormal];
        [answer4 addTarget:self action:NSSelectorFromString(@"unsetWord:") forControlEvents:UIControlEventTouchUpInside];
        answer5 = [UIButton buttonWithType:UIButtonTypeCustom];
        answer5.frame = CGRectMake(160, 0, 40, 40);
        answer5.tag = 205;
        answer5.titleLabel.font = titleFont;
        [answer5 setTitleColor:titleColor forState:UIControlStateNormal];
        [answer5 setBackgroundImage:answerBtnBg forState:UIControlStateNormal];
        [answer5 addTarget:self action:NSSelectorFromString(@"unsetWord:") forControlEvents:UIControlEventTouchUpInside];
        answer6 = [UIButton buttonWithType:UIButtonTypeCustom];
        answer6.frame = CGRectMake(200, 0, 40, 40);
        answer6.tag = 206;
        answer6.titleLabel.font = titleFont;
        [answer6 setTitleColor:titleColor forState:UIControlStateNormal];
        [answer6 setBackgroundImage:answerBtnBg forState:UIControlStateNormal];
        [answer6 addTarget:self action:NSSelectorFromString(@"unsetWord:") forControlEvents:UIControlEventTouchUpInside];
        answer7 = [UIButton buttonWithType:UIButtonTypeCustom];
        answer7.frame = CGRectMake(240, 0, 40, 40);
        answer7.tag = 207;
        answer7.titleLabel.font = titleFont;
        [answer7 setTitleColor:titleColor forState:UIControlStateNormal];
        [answer7 setBackgroundImage:answerBtnBg forState:UIControlStateNormal];
        [answer7 addTarget:self action:NSSelectorFromString(@"unsetWord:") forControlEvents:UIControlEventTouchUpInside];
        
        
        
        //文字たち
        UIImage *btnBg = [UIImage imageNamed:@"num_Bg01"];
//        UIColor *titleColor = [UIColor blackColor];
//        UIFont *titleFont = [UIFont fontWithName:@"GillSans" size:18];

        button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame = CGRectMake(5, [UIScreen mainScreen].bounds.size.height - 160, 40, 40);
        [button1 setTitleColor:titleColor forState:UIControlStateNormal];
        button1.tag = 301;
        button1.titleLabel.font = titleFont;
        [button1 setBackgroundImage:btnBg forState:UIControlStateNormal];
        [button1 addTarget:self action:NSSelectorFromString(@"tapWord:") forControlEvents:UIControlEventTouchUpInside];
        
        button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        button2.frame = CGRectMake(50, [UIScreen mainScreen].bounds.size.height - 160, 40, 40);
        [button2 setTitleColor:titleColor forState:UIControlStateNormal];
        button2.tag = 302;
        button2.titleLabel.font = titleFont;
        [button2 setBackgroundImage:btnBg forState:UIControlStateNormal];
        [button2 addTarget:self action:NSSelectorFromString(@"tapWord:") forControlEvents:UIControlEventTouchUpInside];

        button3 = [UIButton buttonWithType:UIButtonTypeCustom];
        button3.frame = CGRectMake(95, [UIScreen mainScreen].bounds.size.height - 160, 40, 40);
        [button3 setTitleColor:titleColor forState:UIControlStateNormal];
        button3.tag = 303;
        button3.titleLabel.font = titleFont;
        [button3 setBackgroundImage:btnBg forState:UIControlStateNormal];
        [button3 addTarget:self action:NSSelectorFromString(@"tapWord:") forControlEvents:UIControlEventTouchUpInside];
        
        button4 = [UIButton buttonWithType:UIButtonTypeCustom];
        button4.frame = CGRectMake(140, [UIScreen mainScreen].bounds.size.height - 160, 40, 40);
        [button4 setTitleColor:titleColor forState:UIControlStateNormal];
        button4.tag = 304;
        button4.titleLabel.font = titleFont;
        [button4 setBackgroundImage:btnBg forState:UIControlStateNormal];
        [button4 addTarget:self action:NSSelectorFromString(@"tapWord:") forControlEvents:UIControlEventTouchUpInside];
        
        button5 = [UIButton buttonWithType:UIButtonTypeCustom];
        button5.frame = CGRectMake(185, [UIScreen mainScreen].bounds.size.height - 160, 40, 40);
        [button5 setTitleColor:titleColor forState:UIControlStateNormal];
        button5.tag = 305;
        button5.titleLabel.font = titleFont;
        [button5 setBackgroundImage:btnBg forState:UIControlStateNormal];
        [button5 addTarget:self action:NSSelectorFromString(@"tapWord:") forControlEvents:UIControlEventTouchUpInside];
        
        button6 = [UIButton buttonWithType:UIButtonTypeCustom];
        button6.frame = CGRectMake(230, [UIScreen mainScreen].bounds.size.height - 160, 40, 40);
        [button6 setTitleColor:titleColor forState:UIControlStateNormal];
        button6.tag = 306;
        button6.titleLabel.font = titleFont;
        [button6 setBackgroundImage:btnBg forState:UIControlStateNormal];
        [button6 addTarget:self action:NSSelectorFromString(@"tapWord:") forControlEvents:UIControlEventTouchUpInside];
        

        
        button7 = [UIButton buttonWithType:UIButtonTypeCustom];
        button7.frame = CGRectMake(5, [UIScreen mainScreen].bounds.size.height - 115, 40, 40);
        [button7 setTitleColor:titleColor forState:UIControlStateNormal];
        button7.tag = 307;
        button7.titleLabel.font = titleFont;
        [button7 setBackgroundImage:btnBg forState:UIControlStateNormal];
        [button7 addTarget:self action:NSSelectorFromString(@"tapWord:") forControlEvents:UIControlEventTouchUpInside];
        
        button8 = [UIButton buttonWithType:UIButtonTypeCustom];
        button8.frame = CGRectMake(50, [UIScreen mainScreen].bounds.size.height - 115, 40, 40);
        [button8 setTitleColor:titleColor forState:UIControlStateNormal];
        button8.tag = 308;
        button8.titleLabel.font = titleFont;
        [button8 setBackgroundImage:btnBg forState:UIControlStateNormal];
        [button8 addTarget:self action:NSSelectorFromString(@"tapWord:") forControlEvents:UIControlEventTouchUpInside];
        
        button9 = [UIButton buttonWithType:UIButtonTypeCustom];
        button9.frame = CGRectMake(95, [UIScreen mainScreen].bounds.size.height - 115, 40, 40);
        [button9 setTitleColor:titleColor forState:UIControlStateNormal];
        button9.tag = 309;
        button9.titleLabel.font = titleFont;
        [button9 setBackgroundImage:btnBg forState:UIControlStateNormal];
        [button9 addTarget:self action:NSSelectorFromString(@"tapWord:") forControlEvents:UIControlEventTouchUpInside];
        
        button10 = [UIButton buttonWithType:UIButtonTypeCustom];
        button10.frame = CGRectMake(140, [UIScreen mainScreen].bounds.size.height - 115, 40, 40);
        [button10 setTitleColor:titleColor forState:UIControlStateNormal];
        button10.tag = 310;
        button10.titleLabel.font = titleFont;
        [button10 setBackgroundImage:btnBg forState:UIControlStateNormal];
        [button10 addTarget:self action:NSSelectorFromString(@"tapWord:") forControlEvents:UIControlEventTouchUpInside];
        
        button11 = [UIButton buttonWithType:UIButtonTypeCustom];
        button11.frame = CGRectMake(185, [UIScreen mainScreen].bounds.size.height - 115, 40, 40);
        [button11 setTitleColor:titleColor forState:UIControlStateNormal];
        button11.tag = 311;
        button11.titleLabel.font = titleFont;
        [button11 setBackgroundImage:btnBg forState:UIControlStateNormal];
        [button11 addTarget:self action:NSSelectorFromString(@"tapWord:") forControlEvents:UIControlEventTouchUpInside];

        button12 = [UIButton buttonWithType:UIButtonTypeCustom];
        button12.frame = CGRectMake(230, [UIScreen mainScreen].bounds.size.height - 115, 40, 40);
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

        
        //文字列セット
        answerArray = [[NSMutableArray alloc] init];
        wordHintArray = [[NSMutableArray alloc] init];
        answerTagArray =[[NSMutableArray alloc] init];
        [self setQuestion:nowStage];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
                
                NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     b.titleLabel.text,@"string",
                                     [NSString stringWithFormat:@"%d",b.tag],@"tag",
                                     [[answerArray objectAtIndex:i] objectForKey:@"usedHint"],@"usedHint",
                                     nil];
                [answerArray replaceObjectAtIndex:i withObject:dic];
                [b setEnabled:NO];
                
                //文字列セット
                [self setWordWithTag:i title:b.titleLabel.text];
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
    didSetWords++;
    if(didSetWords == answerLength){
        [self answerCheck];
    }
}






//////答えとして選択した文字列を解除する

- (void)unsetWord:(UIButton *)b{
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
        [answer1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [answer2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [answer3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [answer4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [answer5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [answer6 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [answer7 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}





/////ランダムで文字をひとつ解放

- (void)hint:(UIButton *)b{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ヒント"
                                                    message:@"正解を１文字だけひらくことができます。"
                                                   delegate:self
                                          cancelButtonTitle:@"キャンセル"
                                          otherButtonTitles:@"OK", nil];
    alert.tag = 400;
    [alert show];
}







/////ランダムで候補から三文字削除

- (void)hint2:(UIButton *)b{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ヒント"
                                                    message:@"候補から三文字消すことができます。"
                                                   delegate:self
                                          cancelButtonTitle:@"キャンセル"
                                          otherButtonTitles:@"OK", nil];
    alert.tag = 401;
    [alert show];
}







/////UIAlertView Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSDictionary *dic= [[USER_DEFAULT objectForKey:@"json"] objectAtIndex:nowStage - 1];
    if (alertView.tag == 400) {
        NSString *ans = [dic objectForKey:@"answer"];
        NSString *str = [dic objectForKey:@"string"];
        
        BOOL isOK = YES;
        while (isOK) {
            int rand = arc4random() % [ans length];
            NSMutableDictionary *inDic = [[NSMutableDictionary alloc] initWithDictionary:[answerArray objectAtIndex:rand]];
            if ([[inDic objectForKey:@"usedHint"] intValue] == -1) {
                int setTag = [[answerTagArray objectAtIndex:rand] intValue];
                
                [inDic setObject:@"1" forKey:@"usedHint"];
                [inDic setObject:[str substringWithRange:NSMakeRange(setTag,1)] forKey:@"string"];
                [inDic setObject:[NSString stringWithFormat:@"%d",setTag] forKey:@"tag"];
                [answerArray replaceObjectAtIndex:rand withObject:inDic];
                
                //答えのボタンをロックする
                switch (rand) {
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
                [self buttonSetEnabled:setTag + 301 enable:NO];
                [self setWordWithTag:rand title:[str substringWithRange:NSMakeRange(setTag,1)]];
                isOK = NO;
            }
        }
    }
    else if (alertView.tag == 401){
        
    }
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
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    int rectY;
    if (frame.size.height == 548.0) {
        rectY = 310;
    }
    else{
        rectY = 270;
    }
    
    NSString *ans = [dic objectForKey:@"answer"];
    answerLength = [ans length];
    switch ([ans length]) {
        case 3:
            panelBg.frame = CGRectMake(100, rectY, 120, 40);
            [panelBg addSubview:answer1];
            [panelBg addSubview:answer2];
            [panelBg addSubview:answer3];
            break;
        case 4:
            panelBg.frame = CGRectMake(80, rectY, 160, 40);
            [panelBg addSubview:answer1];
            [panelBg addSubview:answer2];
            [panelBg addSubview:answer3];
            [panelBg addSubview:answer4];
            break;
        case 5:
            panelBg.frame = CGRectMake(60, rectY, 200, 40);
            [panelBg addSubview:answer1];
            [panelBg addSubview:answer2];
            [panelBg addSubview:answer3];
            [panelBg addSubview:answer4];
            [panelBg addSubview:answer5];
            break;
        case 6:
            panelBg.frame = CGRectMake(40, rectY, 240, 40);
            [panelBg addSubview:answer1];
            [panelBg addSubview:answer2];
            [panelBg addSubview:answer3];
            [panelBg addSubview:answer4];
            [panelBg addSubview:answer5];
            [panelBg addSubview:answer6];
            break;
        case 7:
            panelBg.frame = CGRectMake(20, rectY, 280, 40);
            [panelBg addSubview:answer1];
            [panelBg addSubview:answer2];
            [panelBg addSubview:answer3];
            [panelBg addSubview:answer4];
            [panelBg addSubview:answer5];
            [panelBg addSubview:answer6];
            [panelBg addSubview:answer7];
            break;
        default:
            break;
    }
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
    [answerArray removeAllObjects];
    for (int i = 0; i< num; i++) {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"-1",@"string",
                             @"-1",@"tag",
                             @"-1",@"usedHint",
                             nil];
        [answerArray addObject:dic];
    }
    
    //答えのタグのみを格納する配列
    [answerTagArray removeAllObjects];
    for (int i = 0; i< num; i++) {
        [answerTagArray addObject:@"-1"];
    }
    
    [wordHintArray removeAllObjects];
    for (int i = 0; i< 12; i++) {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"-1",@"string",
                             @"-1",@"tag",
                             @"-1",@"usedHint",
                             nil];
        [wordHintArray addObject:dic];
    }
    
    
    
}




//////ナビゲーションバーのもどるボタンを押した時

- (void)back:(UIBarButtonItem *)b{
    [self.navigationController popViewControllerAnimated:YES];
}





//////課金アイテムの一覧を表示

- (void)showItemList:(UIButton *)b{
    grayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    grayView.backgroundColor = [UIColor blackColor];
    grayView.alpha = 0.6;
    
    itemListView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    itemListView.frame = CGRectMake(30, 60, 260, 380);
    itemListView.backgroundColor = [UIColor blueColor];
    itemListView.userInteractionEnabled = YES;
    
    [self.navigationController.view addSubview:grayView];
    [self.navigationController.view addSubview:itemListView];
    
    //ボタン
    UIImage *answerBtnBg = [UIImage imageNamed:@"num_Bg02"];
    
    item1 = [UIButton buttonWithType:UIButtonTypeCustom];
    item1.frame = CGRectMake(0, 0, 40, 40);
    item1.tag = 0;
    [item1 setBackgroundImage:answerBtnBg forState:UIControlStateNormal];
    [item1 addTarget:self action:NSSelectorFromString(@"inAppPurchase:") forControlEvents:UIControlEventTouchUpInside];
    
    item2 = [UIButton buttonWithType:UIButtonTypeCustom];
    item2.frame = CGRectMake(0, 50, 40, 40);
    item2.tag = 1;
    [item2 setBackgroundImage:answerBtnBg forState:UIControlStateNormal];
    [item2 addTarget:self action:NSSelectorFromString(@"inAppPurchase:") forControlEvents:UIControlEventTouchUpInside];
    
    item3 = [UIButton buttonWithType:UIButtonTypeCustom];
    item3.frame = CGRectMake(0, 100, 40, 40);
    item3.tag = 2;
    [item3 setBackgroundImage:answerBtnBg forState:UIControlStateNormal];
    [item3 addTarget:self action:NSSelectorFromString(@"inAppPurchase:") forControlEvents:UIControlEventTouchUpInside];
    
    item4 = [UIButton buttonWithType:UIButtonTypeCustom];
    item4.frame = CGRectMake(0, 150, 40, 40);
    item4.tag = 3;
    [item4 setBackgroundImage:answerBtnBg forState:UIControlStateNormal];
    [item4 addTarget:self action:NSSelectorFromString(@"inAppPurchase:") forControlEvents:UIControlEventTouchUpInside];
    
    item5 = [UIButton buttonWithType:UIButtonTypeCustom];
    item5.frame = CGRectMake(0, 200, 40, 40);
    item5.tag = 4;
    [item5 setBackgroundImage:answerBtnBg forState:UIControlStateNormal];
    [item5 addTarget:self action:NSSelectorFromString(@"inAppPurchase:") forControlEvents:UIControlEventTouchUpInside];
    
    [itemListView addSubview:item1];
    [itemListView addSubview:item2];
    [itemListView addSubview:item3];
    [itemListView addSubview:item4];
    [itemListView addSubview:item5];
}





//////課金アイテムを選択した時

- (void)inAppPurchase:(UIButton *)b{
    [self cancel:nil];
    IAPManager *iapManager = [IAPManager sharedInstance];
    if ([iapManager checkCanMakePayment]) {
        //ぐるぐるを出す
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        indicator.center = self.navigationController.view.center;
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
    [itemListView removeFromSuperview];
}



//////課金終了後にアニメーションを見えなくする

- (void)hideAnimation{
    [UIView animateWithDuration:0.3f animations:^(void) {
        grayView.alpha = 0.0;
        
    }completion:^(BOOL finished){
        [indicator removeFromSuperview];
        [grayView removeFromSuperview];
    }];
}




//////クリア画面表示

- (void)showCompleteView{
    nowStage++;
    [USER_DEFAULT setInteger:nowStage forKey:@"nowStage"];
    [USER_DEFAULT synchronize];
    
    //クリアした時のビュー
    completeView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    completeView.backgroundColor = [UIColor blackColor];
    completeView.alpha = 0.0;
    
    next = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    next.frame = CGRectMake(90, 250, 150, 40);
    next.alpha = 0.0;
    [next setTitle:@"next" forState:UIControlStateNormal];
    [next addTarget:self action:NSSelectorFromString(@"goToNextStage:") forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationController.view addSubview:completeView];
    [self.navigationController.view addSubview:next];
    
    [UIView animateWithDuration:0.5f animations:^(void) {
        completeView.alpha = 0.7;
        next.alpha = 1.0;
    }];
}





//////次ページへ遷移

- (void)goToNextStage:(UIButton *)b{
    [self setQuestion:nowStage];
    [self deselestAll];
    [UIView animateWithDuration:0.5f animations:^(void) {
        self.title = [NSString stringWithFormat:@"Stage %d",nowStage];
        completeView.alpha = 0.0;
        next.alpha = 0.0;
        
        [next removeFromSuperview];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
