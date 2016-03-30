//
//  XdEditableView.m
//  MyTestForCAShapeLayer
//
//  Created by 酷酷的1xd on 16/2/29.
//  Copyright © 2016年 酷酷的1xd. All rights reserved.
//

#import "XdEditableView.h"

@implementation XdEditableView{
    UIBezierPath *path;
    UIView *editView;
    CGPoint pointTopLeft;
    CGPoint pointTopRight;
    CGPoint pointBottomLeft;
    CGPoint pointBottomRight;
    UIView *viewTopLeft;
    UIView *viewTopRight;
    UIView *viewBottomLeft;
    UIView *viewBottomRight;
    CAShapeLayer *caLayer;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    if (!path) {
        path = [UIBezierPath bezierPath];
    }
//    UIColor *strokeColor = [UIColor greenColor];
//    [strokeColor setStroke];
//    [path setLineWidth:3.0];
//    [path moveToPoint:pointTopLeft];
//    [path addLineToPoint:pointTopRight];
//    [path addLineToPoint:pointBottomRight];
//    [path addLineToPoint:pointBottomLeft];
//    [path addLineToPoint:pointTopLeft];
//    [path stroke];
}

- (instancetype )initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initFourPoints];
        [self initEditView];
        [self addFourPointViews];
        return self;
    }
    return nil;
}

- (void)initEditView{
    editView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/10, CGRectGetWidth(self.frame)/10, CGRectGetWidth(self.frame)*8/10, CGRectGetHeight(self.frame)*8/10)];
    //editView.backgroundColor = [UIColor redColor];
    //editView.layer.masksToBounds = YES;
    [self addSubview:editView];
    caLayer = [[CAShapeLayer alloc]init];
    UIBezierPath *localPath = [UIBezierPath bezierPath];
    [localPath moveToPoint:CGPointMake(pointTopLeft.x-CGRectGetWidth(self.frame)/10, pointTopLeft.y-CGRectGetWidth(self.frame)/10)];
    [localPath addLineToPoint:CGPointMake(pointTopRight.x-CGRectGetWidth(self.frame)/10, pointTopRight.y-CGRectGetWidth(self.frame)/10)];
    [localPath addLineToPoint:CGPointMake(pointBottomRight.x-CGRectGetWidth(self.frame)/10, pointBottomRight.y-CGRectGetWidth(self.frame)/10)];
    [localPath addLineToPoint:CGPointMake(pointBottomLeft.x-CGRectGetWidth(self.frame)/10, pointBottomLeft.y-CGRectGetWidth(self.frame)/10)];
    [localPath addLineToPoint:CGPointMake(pointTopLeft.x-CGRectGetWidth(self.frame)/10, pointTopLeft.y-CGRectGetWidth(self.frame)/10)];
    caLayer.path = localPath.CGPath;
    caLayer.strokeColor = [UIColor yellowColor].CGColor;
    caLayer.fillColor = [UIColor colorWithPatternImage:[self scaleImgToFitEdittingView:[UIImage imageNamed:@"a.jpg"]]].CGColor;
    caLayer.lineJoin = kCALineJoinBevel;
    caLayer.lineWidth = 1;
    [editView.layer addSublayer:caLayer];
}

- (void)initFourPoints{
    pointTopLeft = CGPointMake(CGRectGetWidth(self.frame)/10, CGRectGetWidth(self.frame)/10);
    pointTopRight = CGPointMake(CGRectGetWidth(self.frame)*9/10, CGRectGetWidth(self.frame)/10);
    pointBottomLeft = CGPointMake(CGRectGetWidth(self.frame)/10, CGRectGetWidth(self.frame)*9/10);
    pointBottomRight = CGPointMake(CGRectGetWidth(self.frame)*9/10, CGRectGetWidth(self.frame)*9/10);
}

- (void)addFourPointViews{
    viewTopLeft = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        view.center = pointTopLeft;
        view.tag = 1;
        [view addGestureRecognizer:[self getPanGestureRecognizer]];
        view.backgroundColor = [UIColor clearColor];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = CGRectGetWidth(view.frame)/2;
        view;
    });
    viewTopRight = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        view.center = pointTopRight;
        view.tag = 2;
        [view addGestureRecognizer:[self getPanGestureRecognizer]];
        view.backgroundColor = [UIColor clearColor];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = CGRectGetWidth(view.frame)/2;
        view;
    });
    viewBottomLeft = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        view.center = pointBottomLeft;
        view.tag = 4;
        [view addGestureRecognizer:[self getPanGestureRecognizer]];
        view.backgroundColor = [UIColor clearColor];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = CGRectGetWidth(view.frame)/2;
        view;
    });
    viewBottomRight = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        view.center = pointBottomRight;
        view.tag = 3;
        [view addGestureRecognizer:[self getPanGestureRecognizer]];
        view.backgroundColor = [UIColor clearColor];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = CGRectGetWidth(view.frame)/2;
        view;
    });
    if (self) {
        [self addSubview:viewTopLeft];
        [self addSubview:viewTopRight];
        [self addSubview:viewBottomLeft];
        [self addSubview:viewBottomRight];
    }
}

- (void)drawEditableRect{
//    [caLayer removeFromSuperlayer];
//    caLayer = [[CAShapeLayer alloc]init];
    UIBezierPath *localPath = [UIBezierPath bezierPath];
    [localPath moveToPoint:CGPointMake(pointTopLeft.x-CGRectGetWidth(self.frame)/10, pointTopLeft.y-CGRectGetWidth(self.frame)/10)];
    [localPath addLineToPoint:CGPointMake(pointTopRight.x-CGRectGetWidth(self.frame)/10, pointTopRight.y-CGRectGetWidth(self.frame)/10)];
    [localPath addLineToPoint:CGPointMake(pointBottomRight.x-CGRectGetWidth(self.frame)/10, pointBottomRight.y-CGRectGetWidth(self.frame)/10)];
    [localPath addLineToPoint:CGPointMake(pointBottomLeft.x-CGRectGetWidth(self.frame)/10, pointBottomLeft.y-CGRectGetWidth(self.frame)/10)];
    [localPath addLineToPoint:CGPointMake(pointTopLeft.x-CGRectGetWidth(self.frame)/10, pointTopLeft.y-CGRectGetWidth(self.frame)/10)];
    caLayer.path = localPath.CGPath;
//    caLayer.strokeColor = [UIColor yellowColor].CGColor;
//    caLayer.fillColor = [UIColor colorWithPatternImage:[self scaleImgToFitEdittingView:[UIImage imageNamed:@"a.jpg"]]].CGColor;
//    caLayer.lineWidth = 5;
//    [editView.layer addSublayer:caLayer];
    //[self setNeedsDisplay];
}

- (UIPanGestureRecognizer *)getPanGestureRecognizer{
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesFunc:)];
    return panGes;
}

- (void)panGesFunc:(UIPanGestureRecognizer *)panGes{
    long tag = [panGes.view tag];
    UIView *tempView = panGes.view;
    CGPoint point = [panGes translationInView:self];
    tempView.center = CGPointMake(tempView.center.x+point.x, tempView.center.y+point.y);
    switch (tag) {
        case 1:
        {
            pointTopLeft = tempView.center;
        }
            break;
        case 2:
        {
            pointTopRight = tempView.center;
        }
            break;
        case 3:
        {
            pointBottomRight = tempView.center;
        }
            break;
        case 4:
        {
            pointBottomLeft = tempView.center;
        }
            break;
            
        default:
            break;
    }
    [panGes setTranslation:CGPointMake(0, 0) inView:self];
    [self drawEditableRect];
}

- (UIImage *)scaleImgToFitEdittingView:(UIImage *)img{
    UIGraphicsBeginImageContext(CGSizeMake(CGRectGetWidth(self.frame), CGRectGetWidth(self.frame)));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, 0, CGRectGetWidth(self.frame));
    CGContextScaleCTM(ctx, 1, -1);
    [img drawInRect:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame))];
    
    UIImage *temp = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return temp;
}
@end
