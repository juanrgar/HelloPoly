//
//  HelloPolyNGAppDelegate.h
//  HelloPolyNG
//
//  Created by Juan Rafael Garcia Blanco on 8/11/10.
//  Copyright 2010 UPM. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MainWindowController.h"
#import "PreferencesController.h"

@interface HelloPolyAppDelegate : NSObject <NSApplicationDelegate> {
	@private
	MainWindowController *mainCont;
	PreferencesController *prefsCont;
	BOOL showingSlider;
}

@property (retain, nonatomic) MainWindowController *mainCont;
@property (retain, nonatomic) PreferencesController *prefsCont;
@property (assign, nonatomic) BOOL showingSlider;

- (IBAction)toggleShowHideSlider:(id)sender;
- (IBAction)showPreferences:(id)sender;

@end
