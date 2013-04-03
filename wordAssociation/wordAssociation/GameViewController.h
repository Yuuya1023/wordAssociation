//
//  GameViewController.h
//  wordAssociation
//
//  Created by 南部 祐耶 on 2013/03/12.
//  Copyright (c) 2013年 Yuya Nambu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface GameViewController : UIViewController{
    
//    UINavigationBar *navBar;
    UIImageView *naviBarImageView;
    UILabel *titleLabel;
    UILabel *subTitleLabel;
    
    UIImageView *image1;
    UIImageView *image2;
    UIImageView *image3;
    UIImageView *image4;
    
    UIImageView *imageFlame1;
    UIImageView *imageFlame2;
    UIImageView *imageFlame3;
    UIImageView *imageFlame4;
    UIImageView *imageFlame5;

    UIImageView *zoomImage;
    
    UIImageView *panelBg;
    
    UIButton *button1;
    UIButton *button2;
    UIButton *button3;
    UIButton *button4;
    UIButton *button5;
    UIButton *button6;
    UIButton *button7;
    UIButton *button8;
    UIButton *button9;
    UIButton *button10;
    UIButton *button11;
    UIButton *button12;
    
    UIButton *hint;
    UIButton *hint2;
    
    UIButton *answer1;
    UIButton *answer2;
    UIButton *answer3;
    UIButton *answer4;
    UIButton *answer5;
    UIButton *answer6;
    UIButton *answer7;
    
    UIButton *facebookButton;
    
    UILabel *moneyLabel;
    
    UIView *completeView;
    UIButton *next;
    UIImageView *textImageView;
    UIImageView *coingetImageView;
    UILabel *stageCountLabel;
    UILabel *stageLabel;
    
    UIImageView *compPanel;
    UIButton *compButton1;
    UIButton *compButton2;
    UIButton *compButton3;
    UIButton *compButton4;
    UIButton *compButton5;
    UIButton *compButton6;
    UIButton *compButton7;
    
    int tapCount;
    int nowStage;
    int nowMainStage;
    int nowSubStage;
    NSString *nowStageKey;
    
    NSMutableArray *answerArray;
    NSMutableArray *answerTagArray;
    
    NSTimer *timer;
    int timerCount;
    int timerStatus;
    
    UIView *grayView;
    UIActivityIndicatorView *indicator;
    
    UIImageView *itemListView;
    UIImageView *itemListTitleView;
    UIButton *item1;
    UIButton *item2;
    UIButton *item3;
    UIButton *item4;
    UIButton *item5;
    
    UILabel *item1_price;
    UILabel *item2_price;
    UILabel *item3_price;
    UILabel *item4_price;
    UILabel *item5_price;
    
    UIButton *cancel;
    
    int didSetWords;
    int answerLength;
    int canDeleteWords;
    NSMutableArray *didDeleteWordsTagArray;
}

@end
