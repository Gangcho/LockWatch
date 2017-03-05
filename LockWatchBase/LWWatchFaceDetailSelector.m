#import "LWWatchFaceDetailSelector.h"
#import "LWWatchFace.h"

#if TARGET_OS_SIMULATOR
#define RESOURCE_LOCATION @"/opt/simject/FESTIVAL/LockWatch/Resources"
#else
#define RESOURCE_LOCATION @"/var/mobile/Library/FESTIVAL/LockWatch/Resources"
#endif


@implementation LWWatchFaceDetailSelector

- (id)initWithFrame:(CGRect)frame options:(NSArray*)options forWatchFace:(LWWatchFace*)watchFace {
	self = [super initWithFrame:frame];
	
	if (self) {
		self->customizingWatchFace = watchFace;
		[self setOptions:options];
		
		self.contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 312, 390)];
		[self.contentView setPagingEnabled:YES];
		[self.contentView setDelegate:self];
		[self addSubview:self.contentView];
		
		UIImageView* faceSelectorBorder = [[UIImageView alloc] initWithImage:[[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/edit", RESOURCE_LOCATION]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
		[faceSelectorBorder setTintColor:[UIColor colorWithRed:0.106 green:1.0 blue:0.549 alpha:1.0]];
		[faceSelectorBorder setFrame:CGRectMake(0, 0, 312, 390)];
		[self addSubview:faceSelectorBorder];
		
		self->imageContainers = [[NSMutableArray alloc] init];
		for (int i=0; i<self.options.count; i++) {
			NSMutableArray* images = [[NSMutableArray alloc] init];
			
			for (int j=0; j<[[self.options objectAtIndex:i] count]; j++) {
				UIImageView* detailImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", RESOURCE_LOCATION, [[self.options objectAtIndex:i] objectAtIndex:j]]]];
				[detailImage setFrame:CGRectMake(0, 390/2 - 312/2, 312, 312)];
				
				if (i != [self->customizingWatchFace levelOfDetail]) {
					[detailImage setAlpha:0];
				}
				
				[self addSubview:detailImage];
				[images addObject:detailImage];
			}
			
			[self->imageContainers addObject:images];
		}
		[self.contentView setContentSize:CGSizeMake(0, [self.options count]*390)];
		[self.contentView setContentOffset:CGPointMake(0, [self->customizingWatchFace levelOfDetail]*390)];
	}
	
	return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	CGFloat height = 390;
	CGFloat offset = scrollView.contentOffset.y;
	CGFloat page = ceilf(scrollView.contentOffset.y / height);
	CGFloat pageProgress = (((page) * height) - offset)/height;
	pageProgress = (round(pageProgress*100))/100.0;
	
	int prevIndex = (page > 0) ? floor(page) : 0;
	int nextIndex = (page < [self.options count]-1) ? ceil(page) : (int)[self.options count]-1;
	
	if (self->scrollDelta != scrollView.contentOffset.y && scrollView.contentOffset.y > 0 && scrollView.contentOffset.y+height < scrollView.contentSize.height) {
		for (int i=0; i<[self.options count]; i++) {
			for (UIImageView* image in [self->imageContainers objectAtIndex:i]) {
				[image setAlpha: 0];
			}
		}
		
		if (self->scrollDelta < scrollView.contentOffset.y) {
			NSArray* next = [self->imageContainers objectAtIndex:nextIndex];
			
			if (scrollView.contentOffset.y+height <= scrollView.contentSize.height && scrollView.contentOffset.y > 0) {
				NSArray* current = [self->imageContainers objectAtIndex:MAX(nextIndex-1, 0)];
				
				for (UIImageView* image in current) {
					[image setAlpha:MAX(0, pageProgress)];
				}
				for (UIImageView* image in next) {
					[image setAlpha:MAX(0, 1-pageProgress)];
				}
			}
		}
		if (self->scrollDelta > scrollView.contentOffset.y) {
			NSArray* prev = [self->imageContainers objectAtIndex:prevIndex];
			
			if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y+height <= scrollView.contentSize.height) {
				NSArray* current = [self->imageContainers objectAtIndex:MIN(prevIndex-1, [self.options count]-1)];
				
				for (UIImageView* image in current) {
					[image setAlpha:MAX(0, pageProgress)];
				}
				for (UIImageView* image in prev) {
					[image setAlpha:MAX(0, 1-pageProgress)];
				}
			}
		}
	}
	
	self->scrollDelta = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	CGFloat height = 390;
	CGFloat page = MAX(MIN(ceilf(scrollView.contentOffset.y / height), [self.options count]-1), 0);
	
	[self->customizingWatchFace setLevelOfDetail:(int)page];
}

@end
