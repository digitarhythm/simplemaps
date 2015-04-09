//
//  SMPLMPanelView.h
//  SimpleMap
//
//  Created by Kow Sakazaki on 2012/10/11.
//  Copyright (c) 2012年 PROJECT PROMINENCE. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMPLMPanelDelegate;

@interface SMPLMPanelView : UIView {
	__weak id<SMPLMPanelDelegate> delegate;
}

- (void)hideKeyboard;
- (void)panelControl:(BOOL)flag;
- (void)keepCurrentLocationSwitch:(BOOL)flag;

@property (nonatomic,weak) id<SMPLMPanelDelegate> delegate;

@end

@protocol SMPLMPanelDelegate
- (void)keepCurrentLocation;
- (void)releaseCurrentLocation;
- (void)searchInputLocation:(NSString*)str;
- (void)closePanel:(id)sender;
@end