//
//  LoongPiece.h
//  IOSGame
//
//  Created by 薛龙 on 2018/3/6.
//  Copyright © 2018年 xuelong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoongPieceImage.h"
#import "LoongPoint.h"

@interface LoongPiece : NSObject
@property (nonatomic,strong) LoongPieceImage* image;
@property (nonatomic,assign) NSInteger beginX;
@property (nonatomic,assign) NSInteger beginY;

@property (nonatomic,assign) NSInteger indexX;
@property (nonatomic,assign) NSInteger indexY;

-(id)initWithIndexX:(NSInteger) indexX indexY:(NSInteger)indexY;
-(LoongPoint*)getCenter;
-(BOOL) isEqual:(LoongPiece*)object;
@end
