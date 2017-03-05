//
//  LWWatchFaceUtility.m
//  WatchFaces
//
//  Created by Janik Schmidt on 19.02.17.
//
//

#import "LWWatchFaceUtility.h"

@implementation LWWatchFaceUtility


- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		self->_levelOfDetail = 3;
		
		self->indicatorBase = [Indicators indicatorBase];
		[self->contentView addSubview:self->indicatorBase];
		
		self->indicatorView = [Indicators indicatorsForUtilityWithDetail:self.levelOfDetail];
		[self->contentView addSubview:self->indicatorView];
		
		self->hourHand = [Hands hourHandWithAccentColor:[UIColor whiteColor] andChronographStyle:NO];
		[self->hourHand.layer setPosition:CGPointMake(312/2, 312/2)];
		[self->contentView addSubview:self->hourHand];
		
		self->minuteHand = [Hands minuteHandWithAccentColor:[UIColor whiteColor] andChronographStyle:NO];
		[self->minuteHand.layer setPosition:CGPointMake(312/2, 312/2)];
		[self->contentView addSubview:self->minuteHand];
		
		self->secondHand = [Hands secondHandWithAccentColor:kWatchColorLightOrange];
		[self->secondHand.layer setPosition:CGPointMake(312/2, 312/2)];
		[self->contentView addSubview:self->secondHand];
		
		NSLog(@"[LockWatch] %@", self->_watchFaceBundle);
	}
	
	return self;
}

- (void)prepareForInit {
	[super prepareForInit];
	
	if ([self->preferences objectForKey:@"levelOfDetail"]) {
		[self setLevelOfDetail:[[self->preferences objectForKey:@"levelOfDetail"] intValue]];
	} else {
		[self setLevelOfDetail:3];
	}
}

- (void)setLevelOfDetail:(int)levelOfDetail {
	[self->indicatorView removeFromSuperview];
	self->indicatorView = [Indicators indicatorsForUtilityWithDetail:levelOfDetail];
	[self->contentView insertSubview:self->indicatorView atIndex:1];
	
	[super setLevelOfDetail:levelOfDetail];
	//[self->contentView addSubview:self->indicatorView];
}

@end
