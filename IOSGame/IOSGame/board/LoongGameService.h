//
//  LoongGameService.h
//  IOSGame
//
//  Created by 薛龙 on 2018/3/6.
//  Copyright © 2018年 xuelong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoongPiece.h"
#import "LoongLinkInfo.h"

@interface LoongGameService : NSObject

@property (nonatomic,strong) NSArray* pieces;

-(void)start;
-(BOOL)hasPieces;
-(LoongPiece*)findPieceAtTouchX:(CGFloat) touchX TouchY:(CGFloat) touchY;
-(LoongLinkInfo*)linkWithBeginPiece:(LoongPiece*) p1 EndPiece:(LoongPiece*)p2;

@end
