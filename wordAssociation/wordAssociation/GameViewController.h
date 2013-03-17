//
//  GameViewController.h
//  wordAssociation
//
//  Created by 南部 祐耶 on 2013/03/12.
//  Copyright (c) 2013年 Yuya Nambu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController{
    UIImageView *image1;
    UIImageView *image2;
    UIImageView *image3;
    UIImageView *image4;
    
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
    
    UIView *completeView;
    UIButton *next;
    
    int tapCount;
    int nowStage;
    
    NSMutableArray *answerArray;
    NSMutableArray *answerTagArray;
    NSMutableArray *wordHintArray;
    
    NSTimer *timer;
    int timerCount;
    int timerStatus;
    
    UIView *grayView;
    UIActivityIndicatorView *indicator;
    
    UIImageView *itemListView;
    UIButton *item1;
    UIButton *item2;
    UIButton *item3;
    UIButton *item4;
    UIButton *item5;
    
    int didSetWords;
    int answerLength;
}

@end
