//
//  ViewController.h
//  IOSGame
//
//  Created by 薛龙 on 2018/3/6.
//  Copyright © 2018年 xuelong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoongGameView.h"

@interface ViewController : UIViewController<UIAlertViewDelegate,LoongGameViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *startBtn;
@property (strong, nonatomic) IBOutlet UILabel *timeText;

@end

