//
//  SMPLMAppDelegate.h
//  SimpleMap
//
//  Created by Kow Sakazaki on 2012/09/30.
//  Copyright (c) 2012年 PROJECT PROMINENCE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMPLMAppDelegate : UIResponder <UIApplicationDelegate> {
}

- (void)setEnvironment:(NSString*)key value:(NSString*)val;
- (NSString*)getEnvironment:(NSString*)key;

@property (strong, nonatomic) UIWindow *window;

@end
