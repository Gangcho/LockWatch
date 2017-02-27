//
//  LWWatchButton.m
//  LockWatch
//
//  Created by Janik Schmidt on 13.02.17.
//  Copyright © 2017 Janik Schmidt. All rights reserved.
//

#import "LWWatchButton.h"
#import <objc/runtime.h>
#import "NCMaterialView.h"
#import "_UIBackdropView.h"

@implementation LWWatchButton

- (id)initWithFrame:(CGRect)frame withTitle:(NSString*)title {
	self = [super initWithFrame:frame];
	
	if (self) {
		/*self->backgroundView = [objc_getClass("NCMaterialView") materialViewWithStyleOptions:2];
		[self->backgroundView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		[self->backgroundView.layer setCornerRadius:8.0];
		[self->backgroundView setClipsToBounds:YES];
		[self addSubview:self->backgroundView];*/
		
		if (kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_9_x_Max) {
			// iOS 10
			self->backgroundView = [objc_getClass("NCMaterialView") materialViewWithStyleOptions:2];
			[self->backgroundView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
			[self->backgroundView.layer setCornerRadius:8.0];
			[self->backgroundView setClipsToBounds:YES];
			[self addSubview:self->backgroundView];
		} else if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_9_0 && kCFCoreFoundationVersionNumber <= kCFCoreFoundationVersionNumber_iOS_9_x_Max) {
			// iOS 9
			self->backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
			[self->backgroundView.layer setCornerRadius:8.0];
			[self->backgroundView setClipsToBounds:YES];
			[self addSubview:self->backgroundView];
			
			_UIBackdropView *blurView = [[_UIBackdropView alloc] initWithStyle:0];
			[blurView setBlurRadiusSetOnce:NO];
			[blurView setBlurRadius:4.0];
			[blurView setBackgroundColor:[UIColor colorWithWhite:0.85 alpha:0.65]];
			[self->backgroundView insertSubview:blurView atIndex:0];
		}
		
		[self setTitle:title forState:UIControlStateNormal];
		[self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[self.titleLabel setFont:[UIFont systemFontOfSize:30]];
	}
	
	return self;
}

@end
