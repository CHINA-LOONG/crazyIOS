//
//  LoongPiece.m
//  IOSGame
//
//  Created by 薛龙 on 2018/3/6.
//  Copyright © 2018年 xuelong. All rights reserved.
//

#import "LoongPiece.h"

@implementation LoongPiece

-(id)initWithIndexX:(NSInteger) indexX indexY:(NSInteger)indexY{
    self=[super init];
    if (self) {
        _indexX=indexX;
        _indexY=indexY;
    }
    return self;
}
-(LoongPoint*)getCenter{
    return [[LoongPoint alloc] initWithX:self.image.pieceImg.size.width/2+_beginX y:self.image.pieceImg.size.height/2+_beginY];
}
-(BOOL) isEqual:(LoongPiece*)object{
    if (self.image==nil) {
        if (object.image!=nil) {
            return NO;
        }
    }
    return self.image.pieceImgID==object.image.pieceImgID;
}
@end
