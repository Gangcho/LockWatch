#import "LockWatch.h"
#import "LWPreferences.h"
#import "LWInterfaceView.h"

LWPreferences* preferences;
LWCore* lockWatchCore;
BOOL hasNotifications;
BOOL mediaControlsVisible;

/*
 * THIS SECTION IS ONLY FOR IOS 10 (AND PROBABLY ABOVE)
 */

%group os10

SBDashBoardMainPageViewController* mainPage;

static void setLockWatchVisibility() {
	[[mainPage isolatingViewController].view setHidden:(!hasNotifications && !mediaControlsVisible)];
	
	[lockWatchCore.interfaceView setHidden:mediaControlsVisible];
	[lockWatchCore setIsInMinimizedView:(hasNotifications && !mediaControlsVisible)];
}

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)arg1 {
	%orig(arg1);
	
	lockWatchCore = [[LWCore alloc] init];
	
	SBLockScreenManager* lsManager = [%c(SBLockScreenManager) sharedInstance];
	SBDashBoardViewController* dashBoard = [lsManager lockScreenViewController];
	mainPage = [dashBoard mainPageViewController];
	
	[[mainPage view] insertSubview:lockWatchCore.interfaceView atIndex:0];
	setLockWatchVisibility();
}

%end

%hook SBLockScreenManager

- (void)_finishUIUnlockFromSource:(int)arg1 withOptions:(id)arg2{
	%orig;
	
	if ([lockWatchCore isInSelection]) {
		[lockWatchCore setIsInSelection:NO];
	}
}
%end

%hook SBFLockScreenDateView

- (void)layoutSubviews {
	[MSHookIvar<UILabel *>(self,"_timeLabel") removeFromSuperview];
	[MSHookIvar<UILabel *>(self,"_dateSubtitleView") removeFromSuperview];
	
	[lockWatchCore setFrameForMinimizedView:self.frame];
	[lockWatchCore layoutViews];
	setLockWatchVisibility();
	
	%orig;
}

%end

%hook SBDashBoardViewController

-(void)startLockScreenFadeInAnimationForSource:(int)arg1 {
	setLockWatchVisibility();
	
	if (![lockWatchCore isInSelection]) {
		[lockWatchCore updateTimeForCurrentWatchFace];
	} else {
		[lockWatchCore setIsInSelection:NO];
	}
	
	%orig(arg1);
}

%new
- (SBDashBoardScrollGestureController*)scrollGestureController {
	return MSHookIvar<SBDashBoardScrollGestureController*>(self,"_scrollGestureController");
}

%end

%hook SBDashBoardScrollGestureController

%new
- (SBPagedScrollView*)scrollView {
	return MSHookIvar<SBPagedScrollView*>(self,"_scrollView");
}

%end

%hook SBBacklightController

- (double)defaultLockScreenDimInterval {
	lockWatchCore.defaultDimInterval = %orig;
	return %orig;
}

- (void)_lockScreenDimTimerFired {
	%log;
	if ([lockWatchCore isInSelection]) {
		return;
	}
	%orig;
};

-(void)_startFadeOutAnimationFromLockSource:(int)arg1 {
	if (arg1 == 11 && [lockWatchCore isInSelection]) {
		[self resetIdleTimer];
		return;
	}
	
	%orig;
}

%end

%hook SBDashBoardNotificationListViewController

-(void)_setListHasContent:(BOOL)arg1 {
	%orig(arg1);
	
	hasNotifications = arg1;
	setLockWatchVisibility();
}

%end

%hook SBDashBoardMediaArtworkViewController

-(void)willTransitionToPresented:(BOOL)arg1 {
	%orig(arg1);
	
	mediaControlsVisible = arg1;
	setLockWatchVisibility();
}

%end

%end // iOS 10

/*
 * THIS SECTION IS ONLY FOR IOS 9
 */

%group os9

SBLockScreenNotificationListController* notificationListController;

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)arg1 {
	%orig(arg1);
	
	lockWatchCore = [[LWCore alloc] init];
	
	SBLockScreenViewController *lockViewController = MSHookIvar<SBLockScreenViewController *>([%c(SBLockScreenManager) sharedInstance], "_lockScreenViewController");
	SBLockScreenScrollView* scrollView = MSHookIvar<SBLockScreenScrollView *>([lockViewController view] , "_foregroundScrollView");
	[scrollView addSubview:lockWatchCore.interfaceView];
}

%end

%hook SBFLockScreenDateView

- (void)layoutSubviews {
	[MSHookIvar<UILabel *>(self,"_legibilityTimeLabel") removeFromSuperview];
	[MSHookIvar<UILabel *>(self,"_legibilityDateLabel") removeFromSuperview];
	
	%orig;
}

%end

%hook SBLockScreenView

- (void)layoutSubviews {
	%orig;
	
	SBLockScreenScrollView* scrollView = MSHookIvar<SBLockScreenScrollView *>(self , "_foregroundScrollView");
	lockWatchCore.legacyScrollView = scrollView;
	[scrollView addSubview:lockWatchCore.interfaceView];
}

%end

%hook SBLockScreenViewController

- (void)viewDidLayoutSubviews {
	%log;
	%orig;
	
	notificationListController = MSHookIvar<SBLockScreenNotificationListController *>(self , "_notificationController");
}

%end

%hook SBLockScreenNotificationListController

- (void)_updateModelAndViewForAdditionOfItem:(id)item {
	%orig;
	
	hasNotifications = YES;
	setLockWatchVisibility();
}

- (void)_updateModelForRemovalOfItem:(id)item updateView:(BOOL)update {
	%orig;
	
	int notificationCount = (int)[[notificationListController valueForKey:@"listItems"] count];
	if (notificationCount > 0) {
		hasNotifications = YES;
	} else {
		hasNotifications = NO;
	}
	
	setLockWatchVisibility();
}

%end

%hook MPUNowPlayingController

-(void)_updatePlaybackState {
	%orig;
	
	mediaControlsVisible = ([self currentNowPlayingArtwork] != NULL);
	setLockWatchVisibility();
}

%end

%end // iOS 9

%ctor {
	preferences = [[LWPreferences alloc] init];
	
	if ([[[LWPreferences preferences] objectForKey:@"enabled"] boolValue]) {
		if (kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_9_x_Max) {
			%init(os10);
			
		} else if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_9_0 && kCFCoreFoundationVersionNumber <= kCFCoreFoundationVersionNumber_iOS_9_x_Max) {
			%init(os9);
		}
	}
}
