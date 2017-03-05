#import <UIKit/UIKit.h>

@class LWWatchFace;

@interface LWWatchFaceDetailSelector : UIView <UIScrollViewDelegate> {
	LWWatchFace* customizingWatchFace;
	
	UIScrollView* _contentView;
	NSArray* _options;
	
	NSMutableArray* imageContainers;
	
	CGFloat scrollDelta;
}

@property (nonatomic, strong) UIScrollView* contentView;
@property (nonatomic, strong) NSArray* options;

- (id)initWithFrame:(CGRect)frame options:(NSArray*)options forWatchFace:(LWWatchFace*)watchFace;

@end
