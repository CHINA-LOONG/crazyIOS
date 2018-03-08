//
//  ViewController.m
//  IOSGame
//
//  Created by 薛龙 on 2018/3/6.
//  Copyright © 2018年 xuelong. All rights reserved.
//

#import "ViewController.h"
#import "LoongGameView.h"
#import "Constants.h"
#import "LoongPiece.h"

@interface ViewController ()

@end

@implementation ViewController

LoongGameView* gameView;
NSInteger leftTime;

NSTimer* timer;

BOOL isPlaying;

UIAlertView* lostAlert;
UIAlertView* successAlert;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIApplication sharedApplication].statusBarHidden=YES;
    self.timeText.textColor=[UIColor colorWithRed:1 green:1 blue:9/15 alpha:1];
    
    UIColor* bgColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"room.jpg"]];
    self.view.backgroundColor=bgColor;
    
    [self.startBtn setBackgroundImage:[UIImage imageNamed:@"start.png"]
                            forState:UIControlStateNormal];
    [self.startBtn setBackgroundImage:[UIImage imageNamed:@"start_down.png"]
                            forState:UIControlStateHighlighted];
    [self.startBtn addTarget:self action:@selector(startGame) forControlEvents:UIControlEventTouchUpInside];
    
    gameView=[[LoongGameView alloc] initWithFrame:CGRectMake(0, 20, 320, 420)];
    gameView.gameService=[[LoongGameService alloc]init];
    gameView.delegate=self;
    gameView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:gameView];
    
    lostAlert=[[UIAlertView alloc]initWithTitle:@"失败" message:@"游戏失败！重新开始？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    successAlert=[[UIAlertView alloc]initWithTitle:@"胜利" message:@"游戏胜利！重新开始？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
}

-(void)startGame{
    if (timer!=nil) {
        [timer invalidate];
    }
    leftTime=DEFAULT_TIME;
    [gameView startGame];
    isPlaying=YES;
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshView) userInfo:nil repeats:YES];
    gameView.selectedPiece=nil;
}
-(void)refreshView{
    self.timeText.text=[NSString stringWithFormat:@"剩余时间：%d",leftTime];
    leftTime--;
    if (leftTime<0) {
        [timer invalidate];
        isPlaying=NO;
        [lostAlert show];
        return;
    }
}
- (void) alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 如果用户选中的“确定”按钮
    if(buttonIndex == 1)
    {
        [self startGame];
    }
}
- (void)checkWin:(LoongGameView *)gameView
{
    // 判断是否还有剩下的方块, 如果没有, 游戏胜利
    if (![gameView.gameService hasPieces])
    {
        // 游戏胜利
        [successAlert show];
        // 停止定时器
        [timer invalidate];
        // 更改游戏状态
        isPlaying = NO;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
