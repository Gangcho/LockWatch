/*!
	@file		LWScrollView.h
	@abstract	The main scroll view containing watch faces, buttons and labels
	@copyright	(c) 2015-2017 FESTIVAL Development
 */

#import <UIKit/UIKit.h>

@class LWScrollViewContainer, LWWatchButton;

@interface LWScrollView : UIView <UIScrollViewDelegate> {
	BOOL isScaledDown;
	BOOL isCustomizing;
	NSInteger selectedWatchFaceIndex;
	
	LWScrollViewContainer* _wrapperView;
	UIScrollView* _contentView;
	LWWatchButton* customizeButton;
	
	NSMutableArray* watchFaceViews;
	
	UILongPressGestureRecognizer* pressed;
	UITapGestureRecognizer* tapped;
	
	CGFloat currentScale;
	CGFloat scrollDelta;
}

@property (nonatomic, retain) UIScrollView* contentView;
@property (nonatomic, retain) LWScrollViewContainer* wrapperView;

+ (id)sharedInstance;

- (void)tapped:(id)sender;
- (void)pressed:(id)sender;

- (void)setSelecting:(BOOL)selecting customizing:(BOOL)customizing;
- (void)scaleUp;
- (void)scaleDown;

- (BOOL)isCustomizing;

- (void)animateScaleToFactor:(float)endValue fromFactor:(float)beginningValue duration:(double)duration;

@end

// Get force touch capability status from device
@interface UIDevice (Private)

@property (nonatomic, readonly) BOOL _supportsForceTouch;

@end
