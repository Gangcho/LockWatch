#import "LWWatchFaceSecondColorSelector.h"
#import "WatchColors.h"

@implementation LWWatchFaceSecondColorSelector

- (id)initWithFrame:(CGRect)frame options:(NSArray*)options {
	self = [super initWithFrame:frame];
	
	if (self) {
		[self setDelegate:self];
		
		UIView* secondCustomizePill = [[UIView alloc] initWithFrame:CGRectMake(127, 149, 58, 222)];
		[secondCustomizePill.layer setBorderWidth:3.0];
		[secondCustomizePill.layer setBorderColor:[UIColor colorWithRed:0.106 green:1.0 blue:0.549 alpha:1.0].CGColor];
		[secondCustomizePill.layer setCornerRadius:29.0];
		[self addSubview:secondCustomizePill];
	}
	
	return self;
}

@end
