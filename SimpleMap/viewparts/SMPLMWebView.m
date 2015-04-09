//
//  SMPLMWebView.m
//  SimpleMap
//
//  Created by Kow Sakazaki on 2012/09/30.
//  Copyright (c) 2012年 PROJECT PROMINENCE. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UserHeader.h"
#import "SMPLMAppDelegate.h"
#import "SMPLMWebView.h"
#import "SMPLMCoverView.h"

@interface SMPLMWebView () {
}
@end

@implementation SMPLMWebView

- (id)initWithFrame:(CGRect)frame
{
NSfunc();
    self = [super initWithFrame:frame];
    if (self) {
		// Google Mapを表示
		CGRect VIEWSIZE = [[UIScreen mainScreen] bounds];
		CGRect frm = VIEWSIZE;
		frm.size.height -= STATUSBAR_HEIGHT;
		frm.origin.y += STATUSBAR_HEIGHT;
		[self setFrame:frm];
		
		[[NSURLCache sharedURLCache] setMemoryCapacity:0];
		
		NSString *path = [[NSBundle mainBundle] pathForResource:@"maps" ofType:@"html"];
		
		NSURL* url = [NSURL fileURLWithPath:path];
		NSURLRequest* urlrequest = [NSURLRequest requestWithURL:url
													cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
												timeoutInterval:30];

		[self loadRequest:urlrequest];
			
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
@end
