//
//  PreferencesController.m
//  HelloPolyNG
//
//  Created by Juan Rafael Garcia Blanco on 8/17/10.
//  Copyright 2010 UPM. All rights reserved.
//

#import "PreferencesController.h"


@implementation PreferencesController

@synthesize mainCont;
@synthesize toolBar;
@synthesize generalView;
@synthesize appearanceView;
@synthesize minNumberOfSides;
@synthesize maxNumberOfSides;
@synthesize blankView;

- (void)resizeWindowToSize:(NSSize)newSize animated:(BOOL)animateFlag {
	NSWindow *win = self.window;
	NSRect contentFrame = [win contentRectForFrameRect:[win frame]];
	
	contentFrame.origin.y += (contentFrame.size.height - newSize.height);
	contentFrame.size.width = newSize.width;
	contentFrame.size.height = newSize.height;
	
	NSRect newFrame = [win frameRectForContentRect:contentFrame];
	[win setFrame:newFrame display:YES animate:animateFlag];
}

- (id)initWithWindowNibName:(NSString *)windowNibName {
	NSLog(@"PreferencesController initWithWindowNibName:");
	if (self = [super initWithWindowNibName:windowNibName]) {
		blankView = [[NSView alloc] init];
	}
	return self;
}

- (void)awakeFromNib {
	NSLog(@"PreferencesController awakeFromNib");
	NSWindow *window = [self window];
    [window setHidesOnDeactivate:NO];
    [window setExcludedFromWindowsMenu:YES];
	
	[minNumberOfSides setIntegerValue:mainCont.polygon.minimumNumberOfSides];
	[maxNumberOfSides setIntegerValue:mainCont.polygon.maximumNumberOfSides];
	
	id preferencesId = [[NSUserDefaults standardUserDefaults] objectForKey:@"preferencesId"];
	NSArray *items = [toolBar items];
	if (preferencesId == nil) {
		NSLog(@"defaulting");
		preferencesId = [[items objectAtIndex:0] itemIdentifier];
	}
	for (NSUInteger i = 0; i < [items count]; i++) {
		if ([[[items objectAtIndex:i] itemIdentifier] isEqual:preferencesId]) {
			switch (i) {
				case 0:
					[self resizeWindowToSize:[generalView frame].size animated:NO];
					[self.window setContentView:generalView];
					break;
				case 1:
					[self resizeWindowToSize:[appearanceView frame].size animated:NO];
					[self.window setContentView:appearanceView];
					break;
				default:
					break;
			}
			break;
		}
	}
	[toolBar setSelectedItemIdentifier:preferencesId];
}

- (void)windowWillLoad {
	NSLog(@"PreferencesController windowWillLoad");
}

- (void)windowDidLoad {
	NSLog(@"PreferencesController windowDidLoad");
}

- (IBAction)showGeneral:(id)sender {
	NSLog(@"PreferencesController showGeneral");
	[self.window setTitle:@"General"];
	[self.window setContentView:blankView];
	[self resizeWindowToSize:[generalView frame].size animated:YES];
	[self.window setContentView:generalView];
}

- (IBAction)showAppearance:(id)sender {
	NSLog(@"PreferencesController showAppearance");
	[self.window setTitle:@"Appearance"];
	[self.window setContentView:blankView];
	[self resizeWindowToSize:[appearanceView frame].size animated:YES];
	[self.window setContentView:appearanceView];
}

- (void)saveState:(NSUserDefaults *)defaults {
	NSLog(@"PreferencesController saveState:");
	[defaults setObject:[toolBar selectedItemIdentifier] forKey:@"preferencesId"];
}

- (BOOL)windowShouldClose:(id)sender {
	NSLog(@"PreferencesController windowShouldClose");
	NSInteger numOfSides = mainCont.polygon.numberOfSides;
	NSInteger minNumOfSides = [minNumberOfSides integerValue];
	
	if (minNumOfSides < 3) {
		return NO;
	}
	if (numOfSides < minNumOfSides || numOfSides > [maxNumberOfSides integerValue]) {
		return NO;
	}
	return YES;
}

- (void)windowWillClose:(NSNotification *)notification {
	NSLog(@"PreferencesController windowWillClose");
	NSInteger newMin, newMax;
	
	newMin = [minNumberOfSides integerValue];
	newMax = [maxNumberOfSides integerValue];
	
	[mainCont.numberOfSidesSlider setMinValue:newMin];
	[mainCont.numberOfSidesSlider setMaxValue:newMax];
	[mainCont.numberOfSidesSlider setNumberOfTickMarks:newMax - newMin + 1];
	
	mainCont.polygon.minimumNumberOfSides = newMin;
	mainCont.polygon.maximumNumberOfSides = newMax;
	
	[mainCont updateInterface];
}

@end
