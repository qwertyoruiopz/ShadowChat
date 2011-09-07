//
//  SCChanPart.m
//  ShadowChat
//
//  Created by qwerty or on 05/09/11.
//  Copyright 2011 uiop. All rights reserved.
//
#import <QuartzCore/QuartzCore.h> 
#import "SCChanPart.h"
#import "SHIRCChannel.h"
#define UIColorFromRGB(rgbValue, alpha_) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alpha_]
#define kIRCNETTag -9837254
@implementation SCChanPart
- (void)die {
    [super fadeOutWithDuration:1];
    [[chan socket] sendCommand:@"QUIT" withArguments:@"The game"];
}
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame]))
    {
        UIButton* removeButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [removeButton setImage:[UIImage imageNamed:@"minus.png"] forState:UIControlStateNormal];
        [removeButton sizeToFit];
        [removeButton addTarget:self action:@selector(rotateButton:) forControlEvents:UIControlEventTouchUpInside];
        [self setLeftView:removeButton];
        roundView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
        roundView.backgroundColor=UIColorFromRGB(0xeae6d1, 0.1);
        roundView.layer.cornerRadius = 5;
        [self setRightView:roundView];
        accessoryText=[[UILabel alloc] initWithFrame:CGRectMake(5, 0, 0, 0)];
        [accessoryText setFont:[UIFont boldSystemFontOfSize:24]];
        [accessoryText setBackgroundColor:[UIColor clearColor]];
        [accessoryText setTextColor:[UIColor whiteColor]];
        accessoryText.shadowColor=[UIColor blackColor];
        accessoryText.textAlignment=UITextAlignmentCenter;
        accessoryText.shadowOffset=CGSizeMake(0, -1);
        [roundView addSubview:accessoryText];
		ppl = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ppl.png"]];
		[roundView addSubview:ppl];
		[self setAccessoryText:@"12"];
		[accessoryText release];
		[ppl release];
		[roundView release];
	}
	return self;
}
-(NSString*)accessoryText
{
    return [accessoryText text];
}
-(void)setMode:(BOOL)mode_ rotateBtn:(UIButton*)btn
{
    if(mode_)
    {
        savedRect=_title.frame;
        [roundView retain];
        [self setRightView:nil];
        [self _layoutSubviews:NO];
        [UIView beginAnimations:@"btnRoto" context:nil];
        [UIView setAnimationDuration:0.3f];
        btn.transform = CGAffineTransformMakeRotation(M_PI/2);
        [UIView commitAnimations];
        [self setTitle:[@"Part from " stringByAppendingString:[chan name]]];
        [self setSubtitle:@""];
        CGPoint pt=_title.center;
        pt.y=36;
        _title.center=pt;
    }
    else
    {
        roundView.frame=CGRectMake(0, 0, 80, 30);
        [self setRightView:roundView];
        [roundView sizeToFit];
        [self setAccessoryText:[self accessoryText]];
        [roundView release];
        [UIView beginAnimations:@"btnRoto" context:nil];
        [UIView setAnimationDuration:0.3f];
        btn.transform = CGAffineTransformMakeRotation(0);
        [UIView commitAnimations];
        [self setSubtitle:[chan net]];
        [self setTitle:[chan name]];
        _title.frame=savedRect;
        [self sizeToFit];
        [self _layoutSubviews:YES];
    }
    mode=mode_;
}
-(void)rotateButton:(UIButton*)sender
{
    [self setMode:!mode rotateBtn:sender];
}
-(void)setOpacity:(CGFloat)opacity
{
	_leftCap.alpha=opacity;
    _rightCap.alpha=opacity;
	_topAnchor.alpha=opacity;
	_bottomAnchor.alpha=opacity;
	_leftBackground.alpha=opacity;
	_rightBackground.alpha=opacity;
}
-(void)setAccessoryText:(NSString*)text;
{
    [accessoryText setText:text];
    [accessoryText sizeToFit];
    ppl.layer.shadowOffset=CGSizeMake(0, -1);
    ppl.layer.shadowColor=[[UIColor blackColor] CGColor];
    ppl.layer.masksToBounds=NO;
    ppl.layer.shadowOpacity = 0.7f;
    ppl.layer.shouldRasterize = YES; 
    ppl.layer.shadowRadius = 0.1f;
    [ppl sizeToFit];
    CGRect framez=ppl.frame;
    framez.origin.x=accessoryText.frame.size.width;
    framez.origin.x+=7;
    framez.origin.y=9;
    ppl.frame=framez;
    [_rightView sizeToFit];
    CGFloat newSize=framez.origin.x;
    newSize+=framez.size.width;
    framez=_rightView.frame;
    framez.size.width=newSize+5;
    _rightView.frame=framez;
    [self sizeToFit];
}
-(void)setChan:(id)chan_
{
    [self setTitle:[chan_ name]];
    [self setSubtitle:[chan_ net]];
    [chan release];
    chan=chan_;
    [chan_ retain];
}
-(void)setTitle:(id)title
{
    [super setTitle:title];
    [_title setTextAlignment:UITextAlignmentCenter];
}
-(void)setSubtitle:(id)subtitle
{
    [[self viewWithTag:kIRCNETTag] removeFromSuperview];
    if([subtitle isEqualToString:@""]||!subtitle)
    {
        return [super setSubtitle:@""];
    }
    NSMutableString* onStr=[NSMutableString stringWithString:@"on "];
    int len=[subtitle length];
    while (len--)
        [onStr appendString:@"  "];
    [super setSubtitle:(NSString*)onStr];
    UILabel* ircnet=[[UILabel alloc] initWithFrame:((UIView*)_subtitle).frame];
    [ircnet setTag:kIRCNETTag];
    CGRect frame=[ircnet frame];
    frame.origin.x+=16;
    [ircnet setFrame:frame];
    [ircnet setFont:[UIFont boldSystemFontOfSize:[[_subtitle font] pointSize]]];
    [ircnet setBackgroundColor:[UIColor clearColor]];
    [ircnet setTextColor:[UIColor whiteColor]];
    [ircnet setText:subtitle];
    ircnet.shadowColor=_subtitle.shadowColor;
    ircnet.shadowOffset=_subtitle.shadowOffset;
    [ircnet sizeToFit];
    [self addSubview:ircnet];
    [ircnet release];
}
@end
