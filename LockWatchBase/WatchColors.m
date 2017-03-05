#import "WatchColors.h"

@implementation UIColor (WatchColors)

+ (UIColor*)watchWhiteColor {
	return [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
}
+ (UIColor*)watchGrayColor {
	return [UIColor colorWithRed:0.55 green:0.55 blue:0.57 alpha:1.0];
}
+ (UIColor*)watchRedColor {
	return [UIColor colorWithRed:0.86 green:0.07 blue:0.17 alpha:1.0];
}
+ (UIColor*)watchOrangeColor {
	return [UIColor colorWithRed:0.98 green:0.32 blue:0.22 alpha:1.0];
}
+ (UIColor*)watchApricotColor {
	return [UIColor colorWithRed:0.98 green:0.45 blue:0.33 alpha:1.0];
}
+ (UIColor*)watchLightOrangeColor {
	return [UIColor colorWithRed:0.99 green:0.58 blue:0.14 alpha:1.0];
}
+ (UIColor*)watchYellowColor {
	return [UIColor colorWithRed:0.9 green:0.79 blue:0.18 alpha:1.0];
}
+ (UIColor*)watchGreenColor {
	return [UIColor colorWithRed:0.56 green:0.88 blue:0.23 alpha:1.0];
}
+ (UIColor*)watchMintColor {
	return [UIColor colorWithRed:0.69 green:0.92 blue:0.62 alpha:1.0];
}
+ (UIColor*)watchTurquoiseColor {
	return [UIColor colorWithRed:0.62 green:0.83 blue:0.8 alpha:1.0];
}
+ (UIColor*)watchLightBlueColor {
	return [UIColor colorWithRed:0.43 green:0.77 blue:0.86 alpha:1.0];
}
+ (UIColor*)watchBlueColor {
	return [UIColor colorWithRed:0.16 green:0.71 blue:0.97 alpha:1.0];
}
+ (UIColor*)watchRoyalBlueColor {
	return [UIColor colorWithRed:0.4 green:0.68 blue:0.92 alpha:1.0];
}
+ (UIColor*)watchLilacColor {
	return [UIColor colorWithRed:0.76 green:0.85 blue:0.98 alpha:1.0];
}
+ (UIColor*)watchMidnightBlueColor {
	return [UIColor colorWithRed:0.38 green:0.52 blue:0.74 alpha:1.0];
}
+ (UIColor*)watchOceanBlueColor {
	return [UIColor colorWithRed:0.45 green:0.53 blue:0.77 alpha:1.0];
}
+ (UIColor*)watchPurpleColor {
	return [UIColor colorWithRed:0.6 green:0.5 blue:0.95 alpha:1.0];
}
+ (UIColor*)watchLavenderColor {
	return [UIColor colorWithRed:0.69 green:0.6 blue:0.65 alpha:1.0];
}
+ (UIColor*)watchPinkSandColor {
	return [UIColor colorWithRed:0.95 green:0.76 blue:0.74 alpha:1.0];
}
+ (UIColor*)watchLightPinkColor {
	return [UIColor colorWithRed:0.95 green:0.69 blue:0.67 alpha:1.0];
}
+ (UIColor*)watchPinkColor {
	return [UIColor colorWithRed:0.98 green:0.35 blue:0.4 alpha:1.0];
}
+ (UIColor*)watchVintageRoseColor {
	return [UIColor colorWithRed:0.94 green:0.67 blue:0.65 alpha:1.0];
}
+ (UIColor*)watchWalnutColor {
	return [UIColor colorWithRed:0.68 green:0.52 blue:0.4 alpha:1.0];
}
+ (UIColor*)watchStoneColor {
	return [UIColor colorWithRed:0.68 green:0.6 blue:0.5 alpha:1.0];
}
+ (UIColor*)watchAntiqueWhiteColor {
	return [UIColor colorWithRed:0.82 green:0.71 blue:0.58 alpha:1.0];
}
+ (UIColor*)watchCocoaColor {
	return [UIColor colorWithRed:0.6 green:0.55 blue:0.54 alpha:1.0];
}

+ (NSDictionary*)watchColors {
	NSDictionary* colors = [NSDictionary dictionaryWithObjectsAndKeys:
							[UIColor watchWhiteColor],@"ice-white",
							[UIColor watchGrayColor],@"gray",
							[UIColor watchRedColor],@"red",
							[UIColor watchOrangeColor],@"orange",
							[UIColor watchApricotColor],@"apricot",
							[UIColor watchLightOrangeColor],@"light-orange",
							[UIColor watchYellowColor],@"yellow",
							[UIColor watchGreenColor],@"green",
							[UIColor watchMintColor],@"mint",
							[UIColor watchTurquoiseColor],@"turquoise",
							[UIColor watchLightBlueColor],@"light-blue",
							[UIColor watchBlueColor],@"blue",
							[UIColor watchRoyalBlueColor],@"royal-blue",
							[UIColor watchLilacColor],@"lilac",
							[UIColor watchMidnightBlueColor],@"midnight-blue",
							[UIColor watchOceanBlueColor],@"ocean-blue",
							[UIColor watchPurpleColor],@"purple",
							[UIColor watchLavenderColor],@"lavender",
							[UIColor watchPinkSandColor],@"pink-sand",
							[UIColor watchLightPinkColor],@"light-pink",
							[UIColor watchPinkColor],@"pink",
							[UIColor watchVintageRoseColor],@"vintage-rose",
							[UIColor watchWalnutColor],@"walnut",
							[UIColor watchStoneColor],@"stone",
							[UIColor watchAntiqueWhiteColor],@"antique-white",
							[UIColor watchCocoaColor],@"cocoa",nil];
	return colors;
}

@end
