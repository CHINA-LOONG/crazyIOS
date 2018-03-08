//
//  LoongGameService.m
//  IOSGame
//
//  Created by 薛龙 on 2018/3/6.
//  Copyright © 2018年 xuelong. All rights reserved.
//
#import "LoongGameService.h"

#import "LoongGameService.h"
#import "LoongBaseBoard.h"
#import "LoongVerticalBoard.h"
#import "Constants.h"

@implementation LoongGameService

-(void)start{
    NSLog(@"service： 开始");
    LoongBaseBoard* board=nil;
    int index=arc4random()%1;
    switch (index) {
        case 0:
            board=[[LoongVerticalBoard alloc] init];
            break;
            
        default:
            board=[[LoongVerticalBoard alloc] init];
            break;
    }
    self.pieces=[board create];
}
-(BOOL)hasPieces{
    for (int i=0; self.pieces.count; i++) {
        for (int j=0; j<[[self.pieces objectAtIndex:i] count]; j++) {
            if ([[[self.pieces objectAtIndex:i] objectAtIndex:j] class]==LoongPiece.class) {
                return YES;
            }
        }
    }
    return NO;
}
-(LoongPiece*)findPieceAtTouchX:(CGFloat) touchX TouchY:(CGFloat) touchY{
    
    CGFloat relativeX=touchX-beginImageX;
    CGFloat relativeY=touchY-beginImageY;
    
    if (relativeX<0||relativeY<0) {
        return nil;
    }
    int indexX=[self getIndexWithRelateive:relativeX size:PIECE_WIDTH];
    int indexY=[self getIndexWithRelateive:relativeY size:PIECE_HEIGHT];
    
    if (indexX<0||indexY<0) {
        return nil;
    }
    else if (indexX>=xSize||indexY>=ySize){
        return nil;
    }else{
        return [[self.pieces objectAtIndex:indexX] objectAtIndex:indexY];
    }
}

-(int) getIndexWithRelateive:(NSInteger)relative size:(NSInteger) size{
    int index=-1;
    if (relative%size==0) {
        index=relative/size-1;
    }else{
        index=relative/size;
    }
    return index;
}
-(LoongLinkInfo*)linkWithBeginPiece:(LoongPiece*) p1 EndPiece:(LoongPiece*)p2{
    if (p1==p2) {
        return nil;
    }
    if (![p1 isEqual:p2]) {
        return nil;
    }
    if (p2.indexX<p1.indexX) {
        return [self linkWithBeginPiece:p2 EndPiece:p1];
    }
    LoongPoint* p1Point=[p1 getCenter];
    LoongPoint* p2Point=[p2 getCenter];
    
    if (p1.indexY==p2.indexY) {
        if (![self isXBlockFromP1:p1Point toP2:p2Point pieceWidth:PIECE_WIDTH]) {
            return [[LoongLinkInfo alloc] initWithP1:p1Point P2:p2Point];
        }
    }
    if (p1.indexX==p2.indexX) {
        if (![self isYBlockFromP1:p1Point toP2:p2Point pieceHeight:PIECE_HEIGHT]) {
            return [[LoongLinkInfo alloc] initWithP1:p1Point P2:p2Point];
        }
    }
    
    LoongPoint* cornerPoint=[self getCornerPointFromStartPoint:p1Point toPoint:p2Point width:PIECE_WIDTH height:PIECE_HEIGHT];
    if (cornerPoint!=nil) {
        return [[LoongLinkInfo alloc] initWithP1:p1Point P2:cornerPoint P3:p2Point];
    }
    NSDictionary* turns=[self getLinkPointsFromPoint:p1Point toPoint:p2Point width:PIECE_WIDTH height:PIECE_HEIGHT];
    if (turns.count!=0) {

        return [self getShortcutFromPoint:p1Point toPoint:p2Point
                                    turns:turns distance:
                [self getDistanceFromPoint:p1Point toPoint:p2Point]];
    }
    
    
    return nil;
}

/**
 检测水平的两点间是否有障碍

 @param p1 <#p1 description#>
 @param p2 <#p2 description#>
 @param pieceWidth <#pieceWidth description#>
 @return <#return value description#>
 */
-(BOOL) isXBlockFromP1:(LoongPoint*)p1 toP2:(LoongPoint*)p2 pieceWidth:(CGFloat) pieceWidth
{
    if (p2.x<p1.x) {
        return [self isXBlockFromP1:p2 toP2:p1 pieceWidth:pieceWidth];
    }
    for (int i=p1.x+pieceWidth; i<p2.x; i=i+pieceWidth) {
        if ([self hasPieceAtX:i y:p1.y]) {
            return YES;
        }
    }
    return NO;
}
-(BOOL) isYBlockFromP1:(LoongPoint*) p1 toP2:(LoongPoint*) p2 pieceHeight:(CGFloat) pieceHeight
{
    if (p2.y<p1.y) {
        return [self isYBlockFromP1:p2 toP2:p1 pieceHeight:pieceHeight];
    }
    for (int i=p1.y+pieceHeight; i<p2.y; i=i+pieceHeight) {
        if ([self hasPieceAtX:p1.x y:i]) {
            return YES;
        }
    }
    return NO;
}

-(BOOL) hasPieceAtX:(NSInteger) x y:(NSInteger)y
{
    return [[self findPieceAtTouchX:x TouchY:y] class]==LoongPiece.class;
}


-(NSDictionary*) getLinkPointsFromPoint:(LoongPoint*) point1 toPoint:(LoongPoint*) point2 width:(NSInteger) pieceWidth height:(NSInteger) pieceHeight{
    
    NSMutableDictionary* result=[[NSMutableDictionary alloc] init];
    //因为1在2的左侧，只需要获取1的上右下，
    NSArray* p1UpChanel=[self getUpChanelFromPoint:point1 min:point2.y height:pieceHeight];
    NSArray* p1RightChanel=[self getRightChanelFromPoint:point1 max:point2.x width:pieceWidth];
    NSArray* p1DownChanel=[self getDownChanelFromPoint:point1 max:point2.y height:pieceHeight];
    //因为2在1的右侧，只需要获取2的上左下，
    NSArray* p2DownChanel=[self getDownChanelFromPoint:point2 max:point1.y height:pieceHeight];
    NSArray* p2LeftChanel=[self getLeftChanelFromPoint:point2 min:point1.x width:pieceWidth];
    NSArray* p2UpChanel=[self getUpChanelFromPoint:point2 min:point1.y height:pieceHeight];
    
    NSInteger heightMax=(ySize+1)*pieceHeight+beginImageY;
    NSInteger widthMax=(xSize+1)*pieceWidth+beginImageX;
    
    if ([self isLeftUpP1:point1 P2:point2]||[self isLeftDownP1:point1 P2:point2]) {
        return [self getLinkPointsFromPoint:point2 toPoint:point1 width:pieceWidth height:pieceHeight];
    }
    if (point1.y == point2.y)
    {
        // 在同一行,向上遍历
        // 以point1的中心点向上遍历获取点集合
        p1UpChanel = [self getUpChanelFromPoint:point1
                                            min:0 height:pieceHeight];
        // 以point2的中心点向上遍历获取点集合
        p2UpChanel = [self getUpChanelFromPoint:point2
                                            min:0 height:pieceHeight];
        NSDictionary* upLinkPoints = [self getXLinkPoints:p1UpChanel
                                                 p2Chanel:p2UpChanel pieceWidth:pieceHeight];
        // 向下遍历,不超过Board(有方块的地方)的边框
        // 以p1中心点向下遍历获取点集合
        p1DownChanel = [self getDownChanelFromPoint:point1
                                                max:heightMax height:pieceHeight];
        // 以p2中心点向下遍历获取点集合
        p2DownChanel = [self getDownChanelFromPoint:point2
                                                max:heightMax height:pieceHeight];
        NSDictionary* downLinkPoints = [self getXLinkPoints:p1DownChanel
                                                   p2Chanel:p2DownChanel pieceWidth:pieceHeight];
        [result addEntriesFromDictionary:upLinkPoints];
        [result addEntriesFromDictionary:downLinkPoints];
    }
    // p1、p2位于同一列不能直接相连
    if (point1.x == point2.x)
    {
        // 在同一列, 向左遍历
        // 以p1的中心点向左遍历获取点集合
        NSArray* p1LeftChanel = [self getLeftChanelFromPoint:point1
                                                         min:0 width:pieceWidth];
        // 以p2的中心点向左遍历获取点集合
        p2LeftChanel = [self getLeftChanelFromPoint:point2
                                                min:0 width:pieceWidth];
        NSDictionary* leftLinkPoints = [self getYLinkPoints:p1LeftChanel
                                                   p2Chanel:p2LeftChanel pieceHeight:pieceWidth];
        // 向右遍历, 不得超过Board的边框（有方块的地方）
        // 以p1的中心点向右遍历获取点集合
        p1RightChanel = [self getRightChanelFromPoint:point1
                                                  max:widthMax width:pieceWidth];
        // 以p2的中心点向右遍历获取点集合
        NSArray* p2RightChanel = [self getRightChanelFromPoint:point2
                                                           max:widthMax width:pieceWidth];
        NSDictionary* rightLinkPoints = [self getYLinkPoints:p1RightChanel
                                                    p2Chanel:p2RightChanel pieceHeight:pieceWidth];
        [result addEntriesFromDictionary:leftLinkPoints];
        [result addEntriesFromDictionary:rightLinkPoints];
    }
    // point2位于point1的右上角
    if ([self isRightUpP1:point1 P2:point2])
    {
        // 获取point1向上遍历, point2向下遍历时横向可以连接的点
        NSDictionary* upDownLinkPoints = [self getXLinkPoints:p1UpChanel
                                                     p2Chanel:p2DownChanel pieceWidth:pieceWidth];
        // 获取point1向右遍历, point2向左遍历时纵向可以连接的点
        NSDictionary* rightLeftLinkPoints = [self getYLinkPoints:p1RightChanel
                                                        p2Chanel:p2LeftChanel pieceHeight:pieceHeight];
        // 获取以p1为中心的向上通道
        p1UpChanel = [self getUpChanelFromPoint:point1
                                            min:0 height:pieceHeight];
        // 获取以p2为中心的向上通道
        p2UpChanel = [self getUpChanelFromPoint:point2
                                            min:0 height:pieceHeight];
        // 获取point1向上遍历, point2向上遍历时横向可以连接的点
        NSDictionary* upUpLinkPoints = [self getXLinkPoints:p1UpChanel
                                                   p2Chanel:p2UpChanel pieceWidth:pieceWidth];
        // 获取以p1为中心的向下通道
        p1DownChanel = [self getDownChanelFromPoint:point1
                                                max:heightMax height:pieceHeight];
        // 获取以p2为中心的向下通道
        p2DownChanel = [self getDownChanelFromPoint:point2
                                                max:heightMax height:pieceHeight];
        // 获取point1向下遍历, point2向下遍历时横向可以连接的点
        NSDictionary* downDownLinkPoints = [self getXLinkPoints:p1DownChanel
                                                       p2Chanel:p2DownChanel pieceWidth:pieceWidth];
        // 获取以p1为中心的向右通道
        p1RightChanel = [self getRightChanelFromPoint:point1
                                                  max:widthMax width:pieceWidth];
        // 获取以p2为中心的向右通道
        NSArray* p2RightChanel = [self getRightChanelFromPoint:point2
                                                           max:widthMax width:pieceWidth];
        // 获取point1向右遍历, point2向右遍历时纵向可以连接的点
        NSDictionary* rightRightLinkPoints = [self getYLinkPoints:p1RightChanel
                                                         p2Chanel:p2RightChanel pieceHeight:pieceHeight];
        // 获取以p1为中心的向左通道
        NSArray* p1LeftChanel = [self getLeftChanelFromPoint:point1
                                                         min:0 width:pieceWidth];
        // 获取以p2为中心的向左通道
        p2LeftChanel = [self getLeftChanelFromPoint:point2
                                                min:0 width:pieceWidth];
        // 获取point1向左遍历, point2向右遍历时纵向可以连接的点
        NSDictionary* leftLeftLinkPoints = [self getYLinkPoints:p1LeftChanel
                                                       p2Chanel:p2LeftChanel pieceHeight:pieceHeight];
        [result addEntriesFromDictionary:upDownLinkPoints];
        [result addEntriesFromDictionary:rightLeftLinkPoints];
        [result addEntriesFromDictionary:upUpLinkPoints];
        [result addEntriesFromDictionary:downDownLinkPoints];
        [result addEntriesFromDictionary:rightRightLinkPoints];
        [result addEntriesFromDictionary:leftLeftLinkPoints];
    }
    // point2位于point1的右下角
    if ([self isRightDownP1:point1 P2:point2])
    {
        // 获取point1向下遍历, point2向上遍历时横向可连接的点
        NSDictionary* downUpLinkPoints = [self getXLinkPoints:p1DownChanel
                                                     p2Chanel:p2UpChanel pieceWidth:pieceWidth];
        // 获取point1向右遍历, point2向左遍历时纵向可连接的点
        NSDictionary* rightLeftLinkPoints = [self getYLinkPoints:p1RightChanel
                                                        p2Chanel:p2LeftChanel pieceHeight:pieceHeight];
        // 获取以p1为中心的向上通道
        p1UpChanel = [self getUpChanelFromPoint:point1
                                            min:0 height:pieceHeight];
        // 获取以p2为中心的向上通道
        p2UpChanel = [self getUpChanelFromPoint:point2
                                            min:0 height:pieceHeight];
        // 获取point1向上遍历, point2向上遍历时横向可连接的点
        NSDictionary* upUpLinkPoints = [self getXLinkPoints:p1UpChanel
                                                   p2Chanel:p2UpChanel pieceWidth:pieceWidth];
        // 获取以p1为中心的向下通道
        p1DownChanel = [self getDownChanelFromPoint:point1
                                                max:heightMax height:pieceHeight];
        // 获取以p2为中心的向下通道
        p2DownChanel = [self getDownChanelFromPoint:point2
                                                max:heightMax height:pieceHeight];
        // 获取point1向下遍历, point2向下遍历时横向可连接的点
        NSDictionary* downDownLinkPoints = [self getXLinkPoints:p1DownChanel
                                                       p2Chanel:p2DownChanel pieceWidth:pieceWidth];
        // 获取以p1为中心的向左通道
        NSArray* p1LeftChanel = [self getLeftChanelFromPoint:point1
                                                         min:0 width:pieceWidth];
        // 获取以p2为中心的向左通道
        p2LeftChanel = [self getLeftChanelFromPoint:point2
                                                min:0 width:pieceWidth];
        // 获取point1向左遍历, point2向左遍历时纵向可连接的点
        NSDictionary* leftLeftLinkPoints = [self getYLinkPoints:p1LeftChanel
                                                       p2Chanel:p2LeftChanel pieceHeight:pieceHeight];
        // 获取以p1为中心的向右通道
        p1RightChanel = [self getRightChanelFromPoint:point1
                                                  max:widthMax width:pieceWidth];
        // 获取以p2为中心的向右通道
        NSArray* p2RightChanel = [self getRightChanelFromPoint:point2
                                                           max:widthMax width:pieceWidth];
        // 获取point1向右遍历, point2向右遍历时纵向可以连接的点
        NSDictionary* rightRightLinkPoints = [self getYLinkPoints:p1RightChanel
                                                         p2Chanel:p2RightChanel pieceHeight:pieceHeight];
        [result addEntriesFromDictionary:downUpLinkPoints];
        [result addEntriesFromDictionary:rightLeftLinkPoints];
        [result addEntriesFromDictionary:upUpLinkPoints];
        [result addEntriesFromDictionary:downDownLinkPoints];
        [result addEntriesFromDictionary:leftLeftLinkPoints];
        [result addEntriesFromDictionary:rightRightLinkPoints];
    }
    
    return result;
}
-(LoongPoint*) getCornerPointFromStartPoint:(LoongPoint*) point1 toPoint:(LoongPoint*) point2 width:(NSInteger) pieceWidth height:(NSInteger) pieceHeight
{
    if ([self isLeftUpP1:point1 P2:point2]||[self isLeftDownP1:point1 P2:point2]) {
        return [self getCornerPointFromStartPoint:point2 toPoint:point1 width:pieceWidth height:pieceHeight];
    }
    //第一个点的向上、向右、向下三个通道
    NSArray* point1RightChanel=[self getRightChanelFromPoint:point1 max:point2.x width:pieceWidth];
    NSArray* point1UpChanel=[self getUpChanelFromPoint:point1 min:point2.y height:pieceHeight];
    NSArray* point1DownChanel=[self getDownChanelFromPoint:point1 max:point2.y height:pieceHeight];
    //第二个点的向下、向左、向上三个通道
    NSArray* point2DownChanel=[self getDownChanelFromPoint:point2 max:point1.y height:pieceHeight];
    NSArray* point2LeftChanel=[self getLeftChanelFromPoint:point2 min:point1.x width:pieceWidth];
    NSArray* point2UpChanel=[self getUpChanelFromPoint:point2 min:point1.y height:pieceHeight];
    //转换成右上或右下的两种方式----
    if ([self isRightUpP1:point1 P2:point2]) {
        LoongPoint* linkPoint1=[self getWrapPointChanel1:point1RightChanel chanel2:point2DownChanel];
        LoongPoint* linkPoint2=[self getWrapPointChanel1:point1UpChanel chanel2:point2LeftChanel];
        return (linkPoint1==nil)?linkPoint2:linkPoint1;
    }
    if ([self isRightDownP1:point1 P2:point2]) {
        LoongPoint* linkPoint1=[self getWrapPointChanel1:point1DownChanel chanel2:point2LeftChanel];
        LoongPoint* linkPoint2=[self getWrapPointChanel1:point1RightChanel chanel2:point2UpChanel];
        return (linkPoint1==nil)?linkPoint2:linkPoint1;
    }
    
    return nil;
}
-(BOOL) isLeftUpP1:(LoongPoint*) point1 P2:(LoongPoint*) point2
{
    return (point2.x<point1.x&&point2.y<point1.y);
}
-(BOOL) isLeftDownP1:(LoongPoint*) point1 P2:(LoongPoint*) point2
{
    return (point2.x<point1.x&&point2.y>point1.y);
}
-(BOOL) isRightUpP1:(LoongPoint*) point1 P2:(LoongPoint*) point2
{
    return (point2.x>point1.x&&point2.y<point1.y);
}
-(BOOL) isRightDownP1:(LoongPoint*) point1 P2:(LoongPoint*) point2
{
    return (point2.x>point1.x&&point2.y>point1.y);
}

-(NSArray*) getLeftChanelFromPoint:(LoongPoint*)p min:(NSInteger)min width:(NSInteger)pieceWidth
{
    NSMutableArray* result=[[NSMutableArray alloc] init];
    for (int i=p.x-pieceWidth; i>=min; i=i-pieceWidth) {
        if ([self hasPieceAtX:i y:p.y]) {
            return result;
        }
        [result addObject:[[LoongPoint alloc] initWithX:i y:p.y]];
    }
    return result;
}

- (NSArray*) getRightChanelFromPoint:(LoongPoint*)p max:(NSInteger)max
                               width:(NSInteger)pieceWidth
{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    // 获取向右通道, 由一个点向右遍历, 步长为FKPiece图片的宽
    for (int i = p.x + pieceWidth; i <= max
         ; i = i + pieceWidth)
    {
        // 遇到障碍, 表示通道已经到尽头, 直接返回
        if ([self hasPieceAtX:i y:p.y])
        {
            return result;
        }
        [result addObject:[[LoongPoint alloc] initWithX:i y:p.y]];
    }
    return result;
}

- (NSArray*) getUpChanelFromPoint:(LoongPoint*)p min:(NSInteger)min
                           height:(NSInteger)pieceHeight
{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    // 获取向上通道, 由一个点向上遍历, 步长为FKPiece图片的高
    for (int i = p.y - pieceHeight; i >= min
         ; i = i - pieceHeight)
    {
        // 遇到障碍, 表示通道已经到尽头, 直接返回
        if ([self hasPieceAtX:p.x y:i])
        {
            // 如果遇到障碍, 直接返回
            return result;
        }
        [result addObject:[[LoongPoint alloc] initWithX:p.x y:i]];
    }
    return result;
}
- (NSArray*) getDownChanelFromPoint:(LoongPoint*)p max:(NSInteger)max
                             height:(NSInteger)pieceHeight
{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    // 获取向下通道, 由一个点向下遍历, 步长为FKPiece图片的高
    for (int i = p.y + pieceHeight; i <= max
         ; i = i + pieceHeight)
    {
        // 遇到障碍, 表示通道已经到尽头, 直接返回
        if ([self hasPieceAtX:p.x y:i])
        {
            // 如果遇到障碍, 直接返回
            return result;
        }
        [result addObject:[[LoongPoint alloc] initWithX:p.x y:i]];
    }
    return result;
}
-(LoongPoint*) getWrapPointChanel1:(NSArray*)p1Chanel chanel2:(NSArray*)p2Chanel
{
    for (int i=0; i<p1Chanel.count; i++) {
        LoongPoint* temp1=[p1Chanel objectAtIndex:i];
        for (int j=0; j<p2Chanel.count; j++) {
            LoongPoint* temp2=[p2Chanel objectAtIndex:j];
            if ([temp1 isEqual:temp2]) {
                return temp1;
            }
        }
    }
    return nil;
}
- (NSDictionary*) getYLinkPoints:(NSArray*) p1Chanel
                        p2Chanel:(NSArray*) p2Chanel pieceHeight:(NSInteger) pieceHeight
{
    NSMutableDictionary* result = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < p1Chanel.count; i++)
    {
        LoongPoint* temp1 = [p1Chanel objectAtIndex:i];
        for (int j = 0; j < p2Chanel.count; j++)
        {
            LoongPoint* temp2 = [p2Chanel objectAtIndex:j];
            // 如果x坐标相同(在同一列)
            if (temp1.x == temp2.x)
            {
                // 没有障碍则加到结果的NSMutableDictionary中
                if (![self isYBlockFromP1:temp1 toP2:temp2 pieceHeight:pieceHeight])
                {
                    [result setObject:temp2 forKey:temp1];
                }
            }
        }
    }
    return [result copy];
}

- (NSDictionary*) getXLinkPoints:(NSArray*) p1Chanel
                        p2Chanel:(NSArray*) p2Chanel pieceWidth:(NSInteger) pieceWidth
{
    NSMutableDictionary* result = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < p1Chanel.count; i++)
    {
        // 从第一通道中取一个点
        LoongPoint* temp1 = [p1Chanel objectAtIndex:i];
        // 再遍历第二个通道, 看下第二通道中是否有点可以与temp1横向相连
        for (int j = 0; j < p2Chanel.count; j++)
        {
            LoongPoint* temp2 = [p2Chanel objectAtIndex:j];
            // 如果y坐标相同(在同一行), 再判断它们之间是否有直接障碍
            if (temp1.y == temp2.y)
            {
                if (![self isXBlockFromP1:temp1 toP2:temp2 pieceWidth:pieceWidth])
                {
                    // 没有障碍则加到结果的NSMutableDictionary中
                    [result setObject:temp2 forKey:temp1];
                }
            }
        }
    }
    return [result copy];
}

- (CGFloat) getDistanceFromPoint:(LoongPoint*) p1 toPoint:(LoongPoint*) p2
{
    int xDistance = abs(p1.x - p2.x);
    int yDistance = abs(p1.y - p2.y);
    return xDistance + yDistance;
}

- (LoongLinkInfo*) getShortcutFromPoint:(LoongPoint*) p1 toPoint:(LoongPoint*) p2
                               turns:(NSDictionary*) turns distance:(NSInteger)shortDistance
{
    NSMutableArray* infos = [[NSMutableArray alloc] init];
    // 遍历结果NSDictionary
    for (LoongPoint* point1 in turns)
    {
        LoongPoint* point2 = turns[point1];
        // 将转折点与选择点封装成FKLinkInfo对象, 放到NSArray集合中
        [infos addObject:[[LoongLinkInfo alloc]
                          initWithP1:p1 P2:point1 P3:point2 P4:p2]];
    }
    return [self getShortcut:infos shortDistance:shortDistance];
}
- (LoongLinkInfo*) getShortcut:(NSArray*) infos shortDistance:(int) shortDistance
{
    int temp1 = 0;
    LoongLinkInfo* result = nil;
    for (int i = 0; i < infos.count; i++)
    {
        LoongLinkInfo* info = [infos objectAtIndex:i];
        // 计算出几个点的总距离
        NSInteger distance = [self countAll:info.points];
        // 将循环第一个的差距用temp1保存
        if (i == 0)
        {
            temp1 = distance - shortDistance;
            result = info;
        }
        // 如果下一次循环的值比temp1的还小, 则用当前的值作为temp1
        if (distance - shortDistance < temp1)
        {
            temp1 = distance - shortDistance;
            result = info;
        }
    }
    return result;
}

- (NSInteger) countAll:(NSArray*) points
{
    NSInteger result = 0;
    for (int i = 0; i < points.count - 1; i++)
    {
        // 获取第i个点
        LoongPoint* point1 = [points objectAtIndex:i];
        // 获取第i + 1个点
        LoongPoint* point2 = [points objectAtIndex:i + 1];
        // 计算第i个点与第i + 1个点的距离，并添加到总距离中
        result += [self getDistanceFromPoint:point1 toPoint:point2];
    }
    return result;
}
@end
