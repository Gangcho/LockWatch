//
//  LWWatchFace.m
//  LockWatch
//
//  Created by Janik Schmidt on 13.02.17.
//  Copyright © 2017 Janik Schmidt. All rights reserved.
//

#import "LWWatchFace.h"
#import "NCMaterialView.h"
#import "_UIBackdropView.h"
#import "CAKeyframeAnimation+AHEasing.h"
#import "LWCore.h"
#import "LWPreferences.h"

#import <objc/runtime.h>
#import <LockWatchBase/LWWatchFaceDetailSelector.h>
#import <LockWatchBase/LWWatchFaceSecondColorSelector.h>

#define scaleUpFactor (312.0/188.0)
#define deg2rad(angle) ((angle) / 180.0 * M_PI)

@implementation LWWatchFace

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		if (kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_9_x_Max) {
			// iOS 10
			self->backgroundView = [objc_getClass("NCMaterialView") materialViewWithStyleOptions:2];
			[self->backgroundView setFrame:CGRectMake(-18, -18, 348, 426)];
			[self->backgroundView setClipsToBounds:NO];
			[[[self->backgroundView subviews] objectAtIndex:0] setClipsToBounds:YES];
			[[[self->backgroundView subviews] objectAtIndex:0].layer setCornerRadius:15.0];
			[self addSubview:self->backgroundView];
		} else if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_9_0 && kCFCoreFoundationVersionNumber <= kCFCoreFoundationVersionNumber_iOS_9_x_Max) {
			// iOS 9
			self->backgroundView = [[UIView alloc] initWithFrame:CGRectMake(-18, -18, 348, 426)];
			[self->backgroundView setClipsToBounds:NO];
			[self addSubview:self->backgroundView];
			
			_UIBackdropView *blurView = [[_UIBackdropView alloc] initWithStyle:0];
			[blurView setBlurRadiusSetOnce:NO];
			[blurView setBlurRadius:4.0];
			[blurView setBackgroundColor:[UIColor colorWithWhite:0.85 alpha:0.65]];
			[blurView setClipsToBounds:YES];
			[blurView .layer setCornerRadius:15.0];
			[self->backgroundView insertSubview:blurView atIndex:0];
		}
		
		self->contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 390/2 - 312/2, 312, 312)];
		[self addSubview:self->contentView];
		
		self->titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -70, 348, 50)];
		[self->titleLabel setTextColor:[UIColor whiteColor]];
		[self->titleLabel setTextAlignment:NSTextAlignmentCenter];
		[self->titleLabel setFont:[UIFont systemFontOfSize:24.0]];
		[self->titleLabel setTransform:CGAffineTransformMakeScale(scaleUpFactor, scaleUpFactor)];
		[self->backgroundView addSubview:self->titleLabel];
		
		//[self->contentView.layer setShouldRasterize:YES];
		//[self->contentView.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
		[self setClipsToBounds:NO];
	}
	
	return self;
}

- (void)setTitleLabelText:(NSString*)newTitleLabel {
	self->_titleLabelText = newTitleLabel;
	[self->titleLabel setText:newTitleLabel];
}

- (UIView*)backgroundView {
	return self->backgroundView;
}

- (void)fadeInWithContent:(BOOL)contentFade {
	[self setAlpha:1.0];
	[self.layer removeAllAnimations];
	
	[self.backgroundView setAlpha:1.0];
	[self->backgroundView.layer removeAllAnimations];
	
	CAAnimation* opacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"
															function:QuinticEaseOut
														   fromValue:0.0
															 toValue:(contentFade?0.5:1.0)];
	opacity.duration = 0.25;
	opacity.removedOnCompletion = NO;
	opacity.fillMode = kCAFillModeForwards;
	opacity.beginTime = CACurrentMediaTime();
	
	if (contentFade) {
		[self.layer addAnimation:opacity forKey:@"opacity"];
	} else {
		[self->backgroundView.layer addAnimation:opacity forKey:@"opacity"];
	}
}

- (void)fadeOutWithContent:(BOOL)contentFade {
	[self setAlpha:1.0];
	[self.layer removeAllAnimations];
	
	[self.backgroundView setAlpha:1.0];
	[self->backgroundView.layer removeAllAnimations];
	
	CAAnimation* opacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"
															function:QuinticEaseOut
														   fromValue:(contentFade?0.5:1.0)
															 toValue:0.0];
	opacity.duration = 0.25;
	opacity.removedOnCompletion = NO;
	opacity.fillMode = kCAFillModeForwards;
	opacity.beginTime = CACurrentMediaTime();
	
	if (contentFade) {
		[self.layer addAnimation:opacity forKey:@"opacity"];
	} else {
		[self->backgroundView.layer addAnimation:opacity forKey:@"opacity"];
	}
}

- (void)prepareForInit {
	self->preferences =	[[objc_getClass("LWPreferences") preferences] objectForKey:[self->_watchFaceBundle bundleIdentifier]];
	if (!self->preferences) {
		self->preferences = [[NSMutableDictionary alloc] init];
	}
	
	[self updateTimeWithHour:10.0 minute:9.0 second:30.0 msecond:0.0 animated:NO];
	[self addCustomizingMode];
}

- (void)updateTimeWithHour:(CGFloat)Hour minute:(CGFloat)Minute second:(CGFloat)Second msecond:(CGFloat)Msecond animated:(BOOL)animated {
	float secondValue = ((Second/60.0) + ((Msecond/1000) / 60));
	float minuteValue = ((Minute/60) + secondValue/60);
	float hourValue = ((Hour/12) + minuteValue/12);
	
	if (self->secondHand) {
		[self->secondHand.layer removeAnimationForKey:@"secRot"];
		[self->secondHand setTransform:CGAffineTransformMakeRotation(deg2rad(secondValue*360))];
		
		if (animated) {
			CABasicAnimation* secondAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
			secondAnim.byValue = [NSNumber numberWithFloat: M_PI * 2.0];
			secondAnim.duration = 60;
			secondAnim.cumulative = YES;
			secondAnim.repeatCount = 1;
			[self->secondHand.layer addAnimation:secondAnim forKey:@"secRot"];
		}
	}
	
	if (self->minuteHand) {
		[self->minuteHand.layer removeAnimationForKey:@"minRot"];
		[self->minuteHand setTransform:CGAffineTransformMakeRotation(deg2rad(minuteValue*360))];
		
		if (animated) {
			CABasicAnimation* minuteAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
			minuteAnim.byValue = [NSNumber numberWithFloat: M_PI * 2.0];
			minuteAnim.duration = 60 * 60;
			minuteAnim.cumulative = YES;
			minuteAnim.repeatCount = 1;
			[self->minuteHand.layer addAnimation:minuteAnim forKey:@"minRot"];
		}
	}
	
	if (self->hourHand) {
		[self->hourHand.layer removeAnimationForKey:@"horRot"];
		[self->hourHand setTransform:CGAffineTransformMakeRotation(deg2rad(hourValue*360))];
		
		if (animated) {
			CABasicAnimation* hourAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
			hourAnim.byValue = [NSNumber numberWithFloat: M_PI * 2.0];
			hourAnim.duration = 60 * 60 * 12;
			hourAnim.cumulative = YES;
			hourAnim.repeatCount = 1;
			[self->hourHand.layer addAnimation:hourAnim forKey:@"hourRot"];
		}
	}
}

- (void)didStopUpdatingTime {
	if (self->secondHand) {
		[self->secondHand.layer removeAllAnimations];
	}
	if (self->minuteHand) {
		[self->minuteHand.layer removeAllAnimations];
	}
	if (self->hourHand) {
		[self->hourHand.layer removeAllAnimations];
	}

	float Hour = 10.0;
	float Minute = 9.0;
	float Second = 30.0;
	float Msecond = 0.0;
	
	float secondValue = ((Second/60.0) + ((Msecond/1000) / 60));
	float minuteValue = ((Minute/60) + secondValue/60);
	float hourValue = ((Hour/12) + minuteValue/12);
	
	[UIView animateWithDuration: 0.25 delay: 0 options: UIViewAnimationOptionCurveLinear animations:^{
		if (self->secondHand) {
			[self->secondHand setTransform:CGAffineTransformMakeRotation(deg2rad(secondValue*360))];
		}
		if (self->minuteHand) {
			[self->minuteHand setTransform:CGAffineTransformMakeRotation(deg2rad(minuteValue*360))];
		}
		if (self->hourHand) {
			[self->hourHand setTransform:CGAffineTransformMakeRotation(deg2rad(hourValue*360))];
		}
	} completion:nil];
}

- (void)didStartUpdatingTime {
	if (self->secondHand) {
		[self->secondHand.layer removeAllAnimations];
	}
	if (self->minuteHand) {
		[self->minuteHand.layer removeAllAnimations];
	}
	if (self->hourHand) {
		[self->hourHand.layer removeAllAnimations];
	}
	
	NSDate* date = [NSDate date];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	NSDateComponents *hourComp = [gregorian components:NSCalendarUnitHour fromDate:date];
	NSDateComponents *minuteComp = [gregorian components:NSCalendarUnitMinute fromDate:date];
	NSDateComponents *secondComp = [gregorian components:NSCalendarUnitSecond fromDate:date];
	NSDateComponents *MsecondComp = [gregorian components:NSCalendarUnitNanosecond fromDate:date];
	
	float Hour = ([hourComp hour] >= 12) ? [hourComp hour] - 12 : [hourComp hour];
	float Minute = [minuteComp minute];
	float Second = [secondComp second];
	float Msecond = roundf([MsecondComp nanosecond]/1000000);
	
	float secondValue = ((Second/60.0) + ((Msecond/1000) / 60));
	float minuteValue = ((Minute/60) + secondValue/60);
	float hourValue = ((Hour/12) + minuteValue/12);
	
	[UIView animateWithDuration: 0.25 delay: 0 options: UIViewAnimationOptionCurveLinear animations:^{
		if (self->secondHand) {
			[self->secondHand setTransform:CGAffineTransformMakeRotation(deg2rad(secondValue*360))];
		}
		if (self->minuteHand) {
			[self->minuteHand setTransform:CGAffineTransformMakeRotation(deg2rad(minuteValue*360))];
		}
		if (self->hourHand) {
			[self->hourHand setTransform:CGAffineTransformMakeRotation(deg2rad(hourValue*360))];
		}
	} completion:^(BOOL finished) {
		//[[LWCore sharedInstance] updateTimeForCurrentWatchFace];
	}];
}


// CUSTOMIZATION MODE

- (void)addCustomizingMode {
	NSArray* customizingOptions = [NSArray arrayWithContentsOfFile:[self.watchFaceBundle pathForResource:@"Customization" ofType:@"plist"]];
	if (customizingOptions) {
		self->_customizable = YES;
		
		self->customizingScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 312, 390)];
		[self->customizingScrollView setContentSize:CGSizeMake([customizingOptions count]*312, 390)];
		//[self->customizingScrollView setBackgroundColor:[UIColor colorWithRed:0 green:1 blue:0 alpha:0.5]];
		[self->customizingScrollView setUserInteractionEnabled:NO];
		[self->customizingScrollView setPagingEnabled:YES];
		[self->customizingScrollView setShowsHorizontalScrollIndicator:NO];
		[self->customizingScrollView setShowsVerticalScrollIndicator:NO];
		[self->customizingScrollView setHidden:YES];
		[self->customizingScrollView setDelegate:self];
		[self addSubview:self->customizingScrollView];
		
		for (int i=0; i<[customizingOptions count]; i++) {
			NSDictionary* customizingMode = [customizingOptions objectAtIndex:i];
			
			if ([[customizingMode objectForKey:@"type"] isEqualToString:@"face"]) {
				LWWatchFaceDetailSelector* detailSelector = [[LWWatchFaceDetailSelector alloc] initWithFrame:CGRectMake(i*312, 0, 312, 390) options:[customizingMode objectForKey:@"options"] forWatchFace:self];
				[self->customizingScrollView addSubview:detailSelector];
			}
			
			if ([[customizingMode objectForKey:@"type"] isEqualToString:@"color-second"]) {
				LWWatchFaceSecondColorSelector* secondColorSelector = [[LWWatchFaceSecondColorSelector alloc] initWithFrame:CGRectMake(i*312, 0, 312, 390) options:[customizingMode objectForKey:@"options"]];
				[self->customizingScrollView addSubview:secondColorSelector];
			}
		}
	}
}

- (void)setIsCustomizing:(BOOL)isCustomizing {
	self->_isCustomizing = isCustomizing;
	[self->customizingScrollView setUserInteractionEnabled:isCustomizing];
	[self->customizingScrollView setHidden:!isCustomizing];
	
	[self->indicatorView setHidden:isCustomizing];
}

- (void)setLevelOfDetail:(int)levelOfDetail {
	self->_levelOfDetail = levelOfDetail;
	
	[self->indicatorView setHidden:self.isCustomizing];
	
	[self->preferences setObject:[NSNumber numberWithInt:levelOfDetail] forKey:@"levelOfDetail"];
	[[objc_getClass("LWPreferences") preferences] setObject:self->preferences forKey:[self->_watchFaceBundle bundleIdentifier]];
	[objc_getClass("LWPreferences") savePreferences];
}

@end
