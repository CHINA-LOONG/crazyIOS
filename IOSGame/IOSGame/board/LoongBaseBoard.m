//
//  LoongBaseBoard.m
//  IOSGame
//
//  Created by 薛龙 on 2018/3/6.
//  Copyright © 2018年 xuelong. All rights reserved.
//

#import "LoongBaseBoard.h"
#import "Constants.h"
#import "FKImageUtil.h"
#import "LoongPiece.h"

@implementation LoongBaseBoard

-(NSArray*) createPieces:(NSArray*)pieces{
    return nil;
}
-(NSArray*) create{
    NSLog(@"开始游戏");
    NSMutableArray* pieces=[[NSMutableArray alloc] init];

    for(int i = 0 ; i < xSize ; i++)
    {
        NSMutableArray* arr = [[NSMutableArray alloc] init];
        for (int j = 0 ; j < ySize ; j++)
        {
            [arr addObject:[NSObject new]];
        }
        [pieces addObject:arr];
    }
    NSArray* notNullPiece=[self createPieces:pieces];
    NSArray* playImage=getPlayImages((int)notNullPiece.count);
    int imageWidth=[[playImage objectAtIndex:0] pieceImg].size.width;
    int imageHeight=[[playImage objectAtIndex:0] pieceImg].size.height;
    
    for (int i=0; i<notNullPiece.count; i++) {
        LoongPiece* piece=[notNullPiece objectAtIndex:i];
        piece.image=[playImage objectAtIndex:i];
        
        piece.beginX=piece.indexX*imageWidth+beginImageX;
        piece.beginY=piece.indexY*imageHeight+beginImageY;
        
        [[pieces objectAtIndex:piece.indexX]setObject:piece atIndex:piece.indexY];
    }
    
    return pieces;
}
@end
