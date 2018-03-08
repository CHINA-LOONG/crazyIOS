//
//  LoongGameView.h
//  IOSGame
//
//  Created by 薛龙 on 2018/3/6.
//  Copyright © 2018年 xuelong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LoongPiece.h"
#import "LoongLinkInfo.h"
#import "LoongGameService.h"

@class LoongGameView;

@protocol LoongGameViewDelegate <NSObject>
-(void)checkWin:(LoongGameView*)gameView;
@end

@interface LoongGameView : UIView
@property (nonatomic,strong) LoongGameService* gameService;
@property (nonatomic,strong) LoongLinkInfo* linkInfo;
@property (nonatomic,strong) LoongPiece* selectedPiece;
@property (nonatomic,strong) id<LoongGameViewDelegate> delegate;

-(void) startGame;

@end
