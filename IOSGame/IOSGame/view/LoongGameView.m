//
//  LoongGameView.m
//  IOSGame
//
//  Created by 薛龙 on 2018/3/6.
//  Copyright © 2018年 xuelong. All rights reserved.
//

#import "LoongGameView.h"
#import "LoongLinkInfo.h"

@implementation LoongGameView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
UIImage* selectedImage;

// 定义连接线的颜色
UIColor* bubbleColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        selectedImage=[UIImage imageNamed:@"selected.png"];
        NSURL* disUrl=[[NSBundle mainBundle] URLForResource:@"dis" withExtension:@"wav"];
        NSURL* guUrl=[[NSBundle mainBundle] URLForResource:@"gu" withExtension:@"mp3"];
        
        bubbleColor = [UIColor colorWithPatternImage:
                       [UIImage imageNamed:@"bubble.jpg"]];
    }
    return self;
}


-(void)drawRect:(CGRect)rect{
    if (self.gameService==nil) {
        return;
    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, [bubbleColor CGColor]);
    CGContextSetLineWidth(ctx, 10);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    NSArray* pieces = self.gameService.pieces;   // ②
    if (pieces!=nil)
    {
        
        for (int i=0; i<pieces.count; i++)
        {
            for (int j=0; j<[[pieces objectAtIndex:i] count]; j++)
            {
                
                if ([[[pieces objectAtIndex:i] objectAtIndex:j]
                     class]==LoongPiece.class)
                {
                    // 得到这个FKPiece对象
                    LoongPiece* piece =[[pieces objectAtIndex:i] objectAtIndex:j];
                    // 将该FKPiece对象中包含的图片绘制在制定位置
                    [piece.image.pieceImg drawAtPoint:CGPointMake(
                                                                piece.beginX, piece.beginY)];
                }
            }
        }
    }
    if (self.linkInfo!=nil) {
        [self drawLine:self.linkInfo context:ctx];
        self.linkInfo=nil;
        [self performSelector:@selector(setNeedsDisplay) withObject:nil afterDelay:3];
    }
    if (self.selectedPiece!=nil) {
        [selectedImage drawAtPoint:CGPointMake(self.selectedPiece.beginX, self.selectedPiece.beginY)];
    }
}

-(void)drawLine:(LoongLinkInfo*)linkInfo context:(CGContextRef)ctx{
    /*NSArray* points=linkInfo.points;
    LoongPoint* firstPoint=[points objectAtIndex:0];
    CGContextMoveToPoint(ctx, firstPoint.x, firstPoint.y);
    for (int i=1; i<points.count; i++) {
        LoongPoint* currentPoint=[points objectAtIndex:i];
        CGContextAddLineToPoint(ctx, currentPoint.x, currentPoint.y);
    }
    CGContextStrokePath(ctx);*/
    
    // 获取FKLinkInfo中封装的所有连接点
    NSArray* points = linkInfo.points;
    LoongPoint* firstPoint = [points objectAtIndex:0];
    CGContextMoveToPoint(ctx, firstPoint.x, firstPoint.y);
    // 依次遍历FKLinkInfo中的每个连接点
    for (int i = 1; i < points.count; i++)
    {
        // 获取当前连接点与下一个连接点
        LoongPoint* currentPoint = [points objectAtIndex:i];
        CGContextAddLineToPoint(ctx , currentPoint.x, currentPoint.y);
    }
    // 绘制路径
    CGContextStrokePath(ctx);
}


-(void)startGame{
    NSLog(@"Controller:开始");
    [self.gameService start];
    [self setNeedsDisplay];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch* touch=[touches anyObject];
    NSArray* pieces=self.gameService.pieces;
    
    CGPoint touchPoint=[touch locationInView:self];
    LoongPiece* currentPiece=[self.gameService findPieceAtTouchX:touchPoint.x TouchY:touchPoint.y];
    if ([currentPiece class]!=LoongPiece.class) {
        return;
    }
    if (self.selectedPiece==nil) {
        self.selectedPiece=currentPiece;
        [self setNeedsDisplay];
        return;
    }else{
        LoongLinkInfo* linkInfo=[self.gameService linkWithBeginPiece:self.selectedPiece EndPiece:currentPiece];
        if (linkInfo==nil) {
            self.selectedPiece==currentPiece;
            [self setNeedsDisplay];
        }else{
            [self handleSuccessLink:linkInfo prevPiece:self.selectedPiece currentPiece:currentPiece pieces:pieces];
        }
    }
}
-(void) handleSuccessLink:(LoongLinkInfo*)linkInfo prevPiece:(LoongPiece*)prevPiece currentPiece:(LoongPiece*)currentPiece pieces:(NSArray*) pieces{
    _linkInfo=linkInfo;
    self.selectedPiece=nil;
    [[pieces objectAtIndex:prevPiece.indexX]  setObject:[NSObject new]
                                                atIndex:prevPiece.indexY];
    [[pieces objectAtIndex:currentPiece.indexX]  setObject:[NSObject new] atIndex:currentPiece.indexY];
    [self setNeedsDisplay];
    [self.delegate checkWin:self];
}


@end
