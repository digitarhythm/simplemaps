//
//  SMPLMPanelView.m
//  SimpleMap
//
//  Created by Kow Sakazaki on 2012/10/11.
//  Copyright (c) 2012年 PROJECT PROMINENCE. All rights reserved.
//

#import <iAd/iAd.h>
#import <QuartzCore/QuartzCore.h>
#import "SMPLMAppDelegate.h"
#import "SMPLMViewController.h"
#import "SMPLMPanelView.h"
#import "UserHeader.h"

@interface SMPLMPanelView () {
	float diff_y;
	float panel_y;
	BOOL panel_flag;
	CGRect VIEWSIZE;
	CGPoint start_pt;
	UISwitch* keepLocationSwitch;
	UISearchBar* searchStrBar;
	ADBannerView *adBannerView;
}
- (void)keepCurrentLocationControl:(id)sender;
@end

@implementation SMPLMPanelView
@synthesize delegate;

//##################################################################################
// インスタンスが生成される時に実行される
//##################################################################################
- (id)initWithFrame:(CGRect)frame
{
NSfunc();
    self = [super initWithFrame:frame];
    if (self) {
		VIEWSIZE = [[UIScreen mainScreen] bounds];
		panel_flag = NO;
		
		// 検索テキストフィールド
		if (searchStrBar == nil) {
			searchStrBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, VIEWSIZE.size.width, SEARCHBAR_HEIGHT)];
			searchStrBar.keyboardType = UIKeyboardTypeDefault;
			searchStrBar.tintColor = [UIColor clearColor];
			searchStrBar.placeholder = NSLocalizedString(@"ADDRESS_SEARCH", @"Address to search");
			searchStrBar.delegate = self;
			[self addSubview:searchStrBar];
		}
	
		// 現在地を中心に固定するスイッチ
		keepLocationSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(6, PANEL_STRAP + 4 + SEARCHBAR_HEIGHT, 64, 24)];
		[self addSubview:keepLocationSwitch];
		[keepLocationSwitch addTarget:self action:@selector(keepCurrentLocationControl:) forControlEvents:UIControlEventValueChanged];
		
        // 現在地を中心に固定するテキストタイトル
		UILabel* keepLocationLabel = [[UILabel alloc] init];
		CGRect switchRect = [keepLocationSwitch frame];
		switchRect.origin.x += (switchRect.size.width + 2);
		switchRect.size.width = 128;
		[keepLocationLabel setFrame:switchRect];
		keepLocationLabel.text = NSLocalizedString(@"KEEP_LOCATION", @"Keep current location");
		keepLocationLabel.backgroundColor = [UIColor clearColor];
		keepLocationLabel.textColor = [UIColor whiteColor];
		keepLocationLabel.textAlignment = UITextAlignmentCenter;
		keepLocationLabel.adjustsFontSizeToFitWidth	= YES;
		[self addSubview:keepLocationLabel];
		
		// コピーライト表示
		UILabel* copyright = [[UILabel alloc] initWithFrame:CGRectMake((VIEWSIZE.size.width - (VIEWSIZE.size.width * 0.6)) / 2, PANEL_HEIGHT - COPYRIGHT_LABEL_HEIGHT, VIEWSIZE.size.width * 0.6, COPYRIGHT_LABEL_HEIGHT)];
		copyright.text = @"powered by PROJECT PROMINENCE";
		copyright.backgroundColor = [UIColor clearColor];
		copyright.textColor = [UIColor whiteColor];
		copyright.textAlignment = UITextAlignmentCenter;
		copyright.adjustsFontSizeToFitWidth = YES;
		[self addSubview:copyright];
		
		// Start observing
		NSNotificationCenter *center;
		center = [NSNotificationCenter defaultCenter];
		[center addObserver:self
			selector:@selector(keyboardWillShow:)
			name:UIKeyboardWillShowNotification
			object:nil];
		[center addObserver:self
			selector:@selector(keyboardWillHide:)
			name:UIKeyboardWillHideNotification
			object:nil];
    }
    return self;
}

- (void)keyboardWillShow:(NSNotification*)notification
{
	CGRect bounds = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	CGRect frm = [self frame];
	frm.origin.y = bounds.origin.y - SEARCHBAR_HEIGHT - 20;
	[UIView animateWithDuration:0.1f animations:^{
		[self setFrame:frm];
	}];
}

- (void)keyboardWillHide:(NSNotification*)notification
{
	CGRect bounds = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	CGRect frm = [self frame];
	frm.origin.y = bounds.origin.y - SEARCHBAR_HEIGHT - 20;
	[UIView animateWithDuration:0.1f animations:^{
		[self setFrame:frm];
	}];
}

//##################################################################################
// キーボードを隠す
//##################################################################################
- (void)hideKeyboard
{
	[searchStrBar resignFirstResponder];
}

//##################################################################################
// 検索実行
//##################################################################################
- (void)searchBarSearchButtonClicked: (UISearchBar *)searchBar {
	[searchStrBar resignFirstResponder];
	NSString* str = searchStrBar.text;
	[delegate searchInputLocation:str];
	[delegate closePanel:nil];
}

//##################################################################################
// 画面をタッチされたら呼ばれる
//##################################################################################
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	SMPLMAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
	UITouch *touch = [touches anyObject];
	start_pt = [touch locationInView:appDelegate.window];
	CGRect frm = [self frame];
	panel_y = frm.origin.y;
	diff_y = frm.origin.y - start_pt.y;
}

//##################################################################################
// タッチしている指を動かしたら呼ばれる
//##################################################################################
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	SMPLMAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
	UITouch *touch = [touches anyObject];
	CGPoint touch_pt = [touch locationInView:appDelegate.window];
	panel_y = touch_pt.y + diff_y;
	if (panel_y < VIEWSIZE.size.height - PANEL_HEIGHT) {
		panel_y = VIEWSIZE.size.height - PANEL_HEIGHT;
	}
	if (panel_y > VIEWSIZE.size.height - PANEL_STRAP) {
		panel_y = VIEWSIZE.size.height - PANEL_STRAP;
	}
	CGRect frm = [self frame];
	frm.origin.y = panel_y;
	[self setFrame:frm];
}

//##################################################################################
// タッチしていた指を離したら呼ばれる
//##################################################################################
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (panel_flag == NO && panel_y < (VIEWSIZE.size.height - PANEL_STRAP - PANEL_DRAG_AREA)) {
		[self panelControl:YES];
//		panel_flag = YES;
//		[UIView animateWithDuration:0.1f animations:^{
//			panel_y = VIEWSIZE.size.height - PANEL_HEIGHT;
//			CGRect frm = [self frame];
//			frm.origin.y = panel_y;
//			[self setFrame:frm];
//		}];
	} else if (panel_flag == YES && panel_y > VIEWSIZE.size.height - PANEL_HEIGHT + PANEL_DRAG_AREA) {
		[self panelControl:NO];
		//		panel_flag = NO;
//		[UIView animateWithDuration:0.1f animations:^{
//			panel_y = VIEWSIZE.size.height - PANEL_STRAP;
//			CGRect frm = [self frame];
//			frm.origin.y = panel_y;
//			[self setFrame:frm];
//		}];
	} else if (panel_flag == NO) {
		[self panelControl:NO];
		//		panel_flag = YES;
//		[UIView animateWithDuration:0.1f animations:^{
//			panel_y = VIEWSIZE.size.height - PANEL_STRAP;
//			CGRect frm = [self frame];
//			frm.origin.y = panel_y;
//			[self setFrame:frm];
//		}];
	} else if (panel_flag == YES) {
		[self panelControl:YES];
		//		panel_flag = NO;
//		[UIView animateWithDuration:0.1f animations:^{
//			panel_y = VIEWSIZE.size.height - PANEL_HEIGHT;
//			CGRect frm = [self frame];
//			frm.origin.y = panel_y;
//			[self setFrame:frm];
//		}];
	}
}

- (void)panelControl:(BOOL)flag
{
	switch (flag) {
		case YES: {
			[searchStrBar resignFirstResponder];
			// iAd
			adBannerView = [[ADBannerView alloc] initWithFrame:CGRectZero];
			adBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifier320x50;
			adBannerView.delegate = self;
			CGRect frm = CGRectMake(0, PANEL_HEIGHT - 70, 320, 50);
			[adBannerView setFrame:frm];
			[self addSubview: adBannerView];
		
			[UIView animateWithDuration:0.1f animations:^{
				panel_y = VIEWSIZE.size.height - PANEL_HEIGHT;
				CGRect frm = [self frame];
				frm.origin.y = panel_y;
				[self setFrame:frm];
			}completion:^(BOOL finished) {
				panel_flag = YES;
			}];
		}
		break;
			
		case NO: {
			[UIView animateWithDuration:0.1f animations:^{
				panel_y = VIEWSIZE.size.height - PANEL_STRAP;
				CGRect frm = [self frame];
				frm.origin.y = panel_y;
				[self setFrame:frm];
			} completion:^(BOOL finished) {
				panel_flag = NO;
				[adBannerView removeFromSuperview];
			}];
		}
		break;
			
		default:
			break;
	}
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
}

// iAdがエラー
- (void)bannerView:(ADBannerView *)bannerView didFailToReceiveAdWithError:(NSError *)error{
    bannerView.frame = CGRectOffset(bannerView.frame, 0, 100);
}

- (void)keepCurrentLocationControl:(id)sender
{
	if ([sender isOn] == YES) {
		[delegate keepCurrentLocation];
	} else {
		[delegate releaseCurrentLocation];
	}
}

- (void)keepCurrentLocationSwitch:(BOOL)flag
{
	if (flag == YES) {
		[keepLocationSwitch setOn:YES animated:YES];
	} else {
		[keepLocationSwitch setOn:NO animated:YES];
	}
}

@end
