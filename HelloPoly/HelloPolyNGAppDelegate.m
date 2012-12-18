//
//  HelloPolyNGAppDelegate.m
//  HelloPolyNG
//
//  Created by Juan Rafael Garcia Blanco on 8/11/10.
//  Copyright 2010 UPM. All rights reserved.
//

#import "HelloPolyNGAppDelegate.h"

@implementation HelloPolyNGAppDelegate

@synthesize mainCont;
@synthesize prefsCont;
@synthesize showingSlider;

- (void)dealloc {
	NSLog(@"HelloPolyNGAppDelegate dealloc");
	[super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	NSLog(@"HelloPolyNGAppDelegate applicationDidFinishLaunching:");
	
	mainCont = [[MainWindowController alloc] initWithWindowNibName:@"MainWindow"];
	[mainCont showWindow:self];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
	NSLog(@"HelloPolyNGAppDelegate applicationWillTerminate:");
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[mainCont saveState:defaults];
	[mainCont release];
	if (prefsCont) {
		[prefsCont saveState:defaults];
		[prefsCont release];
	}
	[defaults synchronize];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
	NSLog(@"HelloPolyNGAppDelegate applicationShouldTerminateAfterLastWindowClosed:");
	return YES;
}

- (IBAction)toggleShowHideSlider:(id)sender {
	NSLog(@"HelloPolyNGAppDelegate toggleShowHideSlider:");
	
	NSMenuItem *mItem = (NSMenuItem *)sender;
	
	if (!showingSlider) {
		[mItem setTitle:@"Hide Slider"];
	}
	else {
		[mItem setTitle:@"Show Slider"];
	}
	[mainCont toggleShowHideSlider:showingSlider];
	showingSlider = !showingSlider;
}

- (IBAction)showPreferences:(id)sender {
	NSLog(@"MainWindowController showPreferences:");
	if (!prefsCont) {
		prefsCont = [[PreferencesController alloc] initWithWindowNibName:@"PreferencesWindow"];
		prefsCont.mainCont = mainCont;
	}
	[prefsCont showWindow:self];
}

@end
