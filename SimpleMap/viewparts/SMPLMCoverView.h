//
//  SMPLMCoverView.h
//  SimpleMap
//
//  Created by Kow Sakazaki on 2012/10/14.
//  Copyright (c) 2012年 PROJECT PROMINENCE. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMPLMCoverViewDelegate;

@interface SMPLMCoverView : UIView {
	__weak id<SMPLMCoverViewDelegate> delegate;
}

@property (nonatomic,weak) id<SMPLMCoverViewDelegate> delegate;
@end

@protocol SMPLMCoverViewDelegate
- (void)closePanel:(id)sender;
@end