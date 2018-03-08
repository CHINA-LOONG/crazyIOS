//
//  LoongVerticalBoard.m
//  IOSGame
//
//  Created by 薛龙 on 2018/3/7.
//  Copyright © 2018年 xuelong. All rights reserved.
//

#import "LoongVerticalBoard.h"
#import "LoongPiece.h"

@implementation LoongVerticalBoard

-(NSArray*) createPieces:(NSArray *)pieces{
    NSMutableArray* notNullPieces=[[NSMutableArray alloc] init];
    for (int i = 0; i < pieces.count; i++)
    {
        for (int j = 0; j < [[pieces objectAtIndex:i] count]; j++)
        {
            if (i % 2 == 0)
            {
                LoongPiece* piece = [[LoongPiece alloc] initWithIndexX:i indexY:j];
                [notNullPieces addObject:piece];
            }
        }
    }
    return notNullPieces;
}

@end
