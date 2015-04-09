//
//  SMPLMViewController.h
//  SimpleMap
//
//  Created by Kow Sakazaki on 2012/10/11.
//  Copyright (c) 2012年 PROJECT PROMINENCE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMPLMViewController : UIViewController <UIWebViewDelegate>

- (void)createCoverView;
- (void)createControlPanel;
- (void)jumpCurrentLocation:(id)sender;
- (void)startStreetView;
- (void)closePanel:(id)sender;
- (void)closeStreetView;
- (void)keepCurrentLocation;
- (void)releaseCurrentLocation;
- (void)streetviewControl:(NSString*)flag;
- (void)errorDialog:(NSUInteger)num;
- (void)searchInputLocation:(NSString*)str;

@end
