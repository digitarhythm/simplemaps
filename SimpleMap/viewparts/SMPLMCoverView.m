//
//  SMPLMCoverView.m
//  SimpleMap
//
//  Created by Kow Sakazaki on 2012/10/14.
//  Copyright (c) 2012年 PROJECT PROMINENCE. All rights reserved.
//

#import "UserHeader.h"
#import "SMPLMCoverView.h"

@implementation SMPLMCoverView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
NSfunc();
	self = [super initWithFrame:frame];
	if (self) {
	}
	return self;
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	// 現在イベントが発生しているViewを取得
	UIView *nowHitView = [super hitTest:point withEvent:event];

	// 自分自身(UIView）だったら透過して(nilを返すとイベントを取得しなくなる)
	if ( self == nowHitView ) {
		[delegate closePanel:nil];
		return nil;
	}

	// それ意外だったらイベント発生させる
	return nowHitView;
}

/*
- (void)drawRect:(CGRect)rect
{
}
*/
@end
