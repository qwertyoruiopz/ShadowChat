//
//  SCChanPart.h
//  ShadowChat
//
//  Created by qwerty or on 05/09/11.
//  Copyright 2011 uiop. All rights reserved.
//
@interface UIView (Private)
- (void)_layoutSubviews;
@end
@interface UICalloutView : UIView
{
    UIImageView* _leftCap;
    UIImageView* _rightCap;
    UIImageView* _topAnchor;
    UIImageView* _bottomAnchor;
    UIImageView* _leftBackground;
    UIImageView* _rightBackground;
    UILabel* _title;
    UILabel* _subtitle;
    UILabel* _temporary;
    UIView* _leftView;
    UIView* _rightView;
    struct {
        CGPoint origin;
        CGPoint offset;
        int position;
        CGPoint desiredPoint;
        CGRect desiredBounds;
    } _anchor;
    CGRect _frame;
    id _delegate;
    struct {
        unsigned shouldSendTouchPauseUp : 1;
        unsigned delegateViewHandleTapWithCountEvent : 1;
        unsigned delegateViewHandleTapWithCountEventFingerCount : 1;
        unsigned delegateViewHandleTouchPauseIsDown : 1;
        unsigned reserved : 28;
    } _flags;
    NSMutableArray* _fadeInViews;
    NSMutableArray* _fadeOutViews;
    NSTimer* _layoutAnimationTimer;
}
-(void)setTitle:(id)title;
-(void)setSubtitle:(id)subtitle;
-(void)fadeOutWithDuration:(CGFloat)duration;
-(void)setAnchorPoint:(CGPoint)point boundaryRect:(CGRect)rect animate:(BOOL)animate;
-(void)_layoutSubviews:(BOOL)animated;
@property(retain, nonatomic) UIView* leftView;
@property(retain, nonatomic) UIView* rightView;
@end
@interface SCChanPart : UICalloutView
{
    UILabel* accessoryText;
    UIImageView* ppl;
    BOOL mode;
    UIView* roundView;
    id chan;
    CGRect savedRect;
    CGRect savedRectTwo;
}
- (void)die;
- (id)initWithFrame:(CGRect)frame;
-(NSString*)accessoryText;
-(void)setMode:(BOOL)mode_ rotateBtn:(UIButton*)btn;
-(void)rotateButton:(UIButton*)sender;
-(void)setOpacity:(CGFloat)opacity;
-(void)setAccessoryText:(NSString*)text;
-(void)setChan:(id)chan_;
-(void)setTitle:(id)title;
-(void)setSubtitle:(id)subtitle;
@end
