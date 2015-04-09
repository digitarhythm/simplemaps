//
//  SMPLMViewController.m
//  SimpleMap
//
//  Created by Kow Sakazaki on 2012/10/11.
//  Copyright (c) 2012年 PROJECT PROMINENCE. All rights reserved.
//

#import "UserHeader.h"
#import "SMPLMViewController.h"
#import "SMPLMWebView.h"
#import "SMPLMPanelView.h"
#import "SMPLMCoverView.h"

@interface SMPLMViewController () {
	UIButton* centerButton;
	UIButton* streetviewCloseButton;
	UIButton* streetviewStartButton;
	UISearchBar* searchStrBar;
	SMPLMWebView* webview;
	SMPLMPanelView* controller;
	SMPLMCoverView* coverView;
	CGRect VIEWSIZE;
}
- (void)keepCurrentLocation;
- (void)releaseCurrentLocation;
- (void)closePanel:(id)sender;
- (void)streetviewControl:(NSString*)flag;
- (void)startStreetView;
- (void)closeStreetView;
- (void)errorDialog:(NSUInteger)num;
- (void)jumpCurrentLocation:(id)sender;
@end

@implementation SMPLMViewController

//##################################################################################
// viewが生成された後に実行される
//##################################################################################
- (void)viewDidLoad
{
NSfunc();
    [super viewDidLoad];
NSLog(@"viewDidLoad\n");
	// 画面サイズを取得
	VIEWSIZE = [[UIScreen mainScreen] bounds];
	CGRect orgfrm = VIEWSIZE;
	
	// 地図のWebView生成
	if (webview == nil) {
		webview = [[SMPLMWebView alloc] init];
		webview.delegate = self;
		webview.dataDetectorTypes = UIDataDetectorTypeNone;
		[self.view addSubview:webview];
	}

	// 検索テキストフィールド
//	if (searchStrBar == nil) {
//		searchStrBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 18, VIEWSIZE.size.width, SEARCHBAR_HEIGHT)];
//		searchStrBar.keyboardType = UIKeyboardTypeDefault;
//		searchStrBar.tintColor = [UIColor clearColor];
//		searchStrBar.placeholder = NSLocalizedString(@"ADDRESS_SEARCH", @"Address to search");
//		searchStrBar.delegate = self;
//		[self.view addSubview:searchStrBar];
//	}
	
	// ストリートビューを始めるボタンを生成
	if (streetviewStartButton == nil) {
		streetviewStartButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[streetviewStartButton setFrame:CGRectMake(4, STATUSBAR_HEIGHT + 2, 32, 32)];
		[streetviewStartButton setImage:[UIImage imageNamed:@"streetview.png"] forState:UIControlStateNormal];
		UITapGestureRecognizer *dtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startStreetView)];
		dtap.numberOfTapsRequired = 1;
		[streetviewStartButton addGestureRecognizer:dtap];
		streetviewStartButton.backgroundColor = [UIColor clearColor];
		streetviewStartButton.alpha = 0.8f;
		streetviewStartButton.hidden = NO;
		[self.view addSubview:streetviewStartButton];
	}
	
	// ストリートビューを閉じるボタンを生成
	if (streetviewCloseButton == nil) {
		streetviewCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[streetviewCloseButton setFrame:CGRectMake(VIEWSIZE.size.width - 26, STATUSBAR_HEIGHT + 2, 24, 24)];
		[streetviewCloseButton setImage:[UIImage imageNamed:@"closebutton.png"] forState:UIControlStateNormal];
		UITapGestureRecognizer *dtap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeStreetView)];
		dtap2.numberOfTapsRequired = 1;
		[streetviewCloseButton addGestureRecognizer:dtap2];
		streetviewCloseButton.backgroundColor = [UIColor blackColor];
		streetviewCloseButton.alpha = 0.8f;
		streetviewCloseButton.hidden = YES;
		[self.view addSubview:streetviewCloseButton];
	}
	
	// 中心図形を生成
	if (centerButton == nil) {
		centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[centerButton setFrame:CGRectMake(0, 0, 16, 16)];
		CGPoint center = CGPointMake(orgfrm.size.width / 2, (orgfrm.size.height - STATUSBAR_HEIGHT) / 2);
		[centerButton setCenter:center];
		centerButton.alpha = 0.5f;
		[centerButton setImage:[UIImage imageNamed:@"centerImage_normal.png"] forState:UIControlStateNormal];
		UILongPressGestureRecognizer *long_press_ges;
		long_press_ges = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(jumpCurrentLocation:)];
		[centerButton addGestureRecognizer:long_press_ges];
		[self.view addSubview:centerButton];
	}
	
	[self createCoverView];
	[self createControlPanel];
	
}

// イベント受け取り用view生成
- (void)createCoverView
{
	if (coverView == nil) {
		coverView = [[SMPLMCoverView alloc] initWithFrame:VIEWSIZE];
		coverView.backgroundColor = [UIColor clearColor];
		coverView.delegate = self;
		[self.view addSubview:coverView];
	}
}

// コントロールパネルを生成
- (void)createControlPanel
{
	CGRect orgfrm = [[UIScreen mainScreen] bounds];
	CGRect viewfrm = orgfrm;
	viewfrm.size.height = PANEL_HEIGHT;
	viewfrm.origin.y = VIEWSIZE.size.height - PANEL_STRAP;
	if (controller == nil) {
		controller = [[SMPLMPanelView alloc] initWithFrame:viewfrm];
		controller.delegate = self;
		[controller setFrame:viewfrm];
		controller.alpha = 0.8;
		controller.backgroundColor = [UIColor blackColor];
		UIImageView* uparrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"uparrow.png"]];
		[uparrow setFrame:CGRectMake((orgfrm.size.width / 2) - 9, 0, 18, 18)];
		[controller addSubview:uparrow];
		[self.view addSubview:controller];
	}
}

//##################################################################################
// メモリが足りなくなったら呼ばれる
//##################################################################################
- (void)viewDidUnload
{
NSLog(@"viewDidUnload\n");
}

//##################################################################################
// GoogleMapの中心を現在地にする
//##################################################################################
- (void)jumpCurrentLocation:(id)sender
{
	NSString *command =[NSString stringWithFormat:@"dispCurrentCenterGoogleMap()"];
	[webview stringByEvaluatingJavaScriptFromString:command];
}

//##################################################################################
// ストリートビューを開始する
//##################################################################################
- (void)startStreetView
{
//NSLog(@"disp street view");
	[self streetviewControl:@"YES"];
	NSString *command =[NSString stringWithFormat:@"dispStreetView()"];
	[webview stringByEvaluatingJavaScriptFromString:command];
}

//##################################################################################
// コントロールパネルを閉じて、キーボードを非表示にする
//##################################################################################
- (void)closePanel:(id)sender
{
//NSLog(@"closePanel\n");
	// 画面サイズを取得
	[controller panelControl:NO];
	[controller hideKeyboard];
}

//- (void)searchBarSearchButtonClicked: (UISearchBar *)searchBar {
//	[searchStrBar resignFirstResponder];
//	NSString* str = searchStrBar.text;
- (void)searchInputLocation:(NSString*)str
{
	NSString *command =[NSString stringWithFormat:[NSString stringWithFormat:@"searchAddress('%@')", str]];
	[webview stringByEvaluatingJavaScriptFromString:command];
}

//##################################################################################
// ストリートビューを終了する
//##################################################################################
- (void)closeStreetView
{
	[self streetviewControl:NO];
	[self createControlPanel];
	[self createCoverView];
}

//##################################################################################
// メモリ不足警告を受けた
//##################################################################################
- (void)didReceiveMemoryWarning
{
NSfunc();
    [super didReceiveMemoryWarning];
	
NSLog(@"didReceiveMemoryWarning");
	
    // Dispose of any resources that can be recreated.

	NSURLCache* cache = [NSURLCache sharedURLCache];
	[cache removeAllCachedResponses];
}

- (void)dealloc
{
	NSfunc();
}

//##################################################################################
//##################################################################################
//##################################################################################
// JSから呼ばれるデリゲート群
//##################################################################################
//##################################################################################
//##################################################################################

//##################################################################################
// 現在地を画面中央に固定する
//##################################################################################
- (void)keepCurrentLocation
{
	[centerButton setImage:[UIImage imageNamed:@"centerImage_keep.png"] forState:UIControlStateNormal];
	[controller keepCurrentLocationSwitch:YES];
	NSString *command =[NSString stringWithFormat:@"setKeepCurrentLocationFlag(1)"];
	[webview stringByEvaluatingJavaScriptFromString:command];
}

//##################################################################################
// 現在地の画面中央固定を解除する
//##################################################################################
- (void)releaseCurrentLocation
{
	[centerButton setImage:[UIImage imageNamed:@"centerImage_normal.png"] forState:UIControlStateNormal];
	[controller keepCurrentLocationSwitch:NO];
	NSString *command =[NSString stringWithFormat:@"setKeepCurrentLocationFlag(0)"];
	[webview stringByEvaluatingJavaScriptFromString:command];
}


//##################################################################################
// ストリートビューコントローラー
//##################################################################################
- (void)streetviewControl:(NSString*)flag
{
	switch (flag.boolValue) {
		case YES:
			centerButton.hidden = YES;
			streetviewCloseButton.hidden = NO;
			streetviewStartButton.hidden = YES;
			break;
			
		case NO: {
			NSString *command =[NSString stringWithFormat:@"hideStreetView()"];
			[webview stringByEvaluatingJavaScriptFromString:command];
			centerButton.hidden = NO;
			streetviewCloseButton.hidden = YES;
			streetviewStartButton.hidden = NO;
		}
		break;
			
		default:
			break;
	}
}

//##################################################################################
// エラーダイアログを表示する
//##################################################################################
- (void)errorDialog:(NSUInteger)num
{
	NSString* str;
	switch (num) {
		case 0:
			str = @"場所を特定出来ませんでした。";
			break;
			
		default:
			break;
	}
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
													message:str
													delegate:self
													cancelButtonTitle:@"OK"
													otherButtonTitles:nil];
    [alert show];
}

//##################################################################################
// JSからデリゲートを呼び出すためのデリゲート
//##################################################################################
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	if (request.cachePolicy != NSURLRequestReloadIgnoringLocalCacheData) {
        
		NSMutableURLRequest *req = (NSMutableURLRequest *)request;
		req.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
	}

	NSString *requestString = [[request URL] absoluteString];
	if ([requestString rangeOfString:@"tv.prominence.simplemap://"].location == NSNotFound){
		return YES;
	}

	NSError *error = nil;
	NSString *pattern = [NSString stringWithFormat:@"tv\.prominence\.simplemap://(.+)\\((.+)\\)"];
	NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:pattern
																		 options:0
																		   error:&error];
	if(error != nil){
		NSLog(@"%@", [error description]);
		return NO;
	}

	NSTextCheckingResult *match = [reg firstMatchInString:requestString
												  options:0
													range:NSMakeRange(0, requestString.length)];
	if(match.numberOfRanges == 0){
		NSLog(@"not match");
		return NO;
	}

	NSString *method = [requestString substringWithRange:[match rangeAtIndex:1]];
	NSString *params = [requestString substringWithRange:[match rangeAtIndex:2]];
//	NSLog(@"%@, %@", method, params);

	// 呼ばれたメソッドを実行
	if([method isEqualToString:@"streetviewControl"]){
		[self streetviewControl:params];
	} else
	if([method isEqualToString:@"releaseCurrentLocation"]){
		[self releaseCurrentLocation];
	} else
	if([method isEqualToString:@"alertDialog"]){
		[self errorDialog:params.intValue];
	}

	return NO;
}

@end
