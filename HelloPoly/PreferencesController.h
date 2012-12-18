//
//  PreferencesController.h
//  HelloPolyNG
//
//  Created by Juan Rafael Garcia Blanco on 8/17/10.
//  Copyright 2010 UPM. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MainWindowController.h"


@interface PreferencesController : NSWindowController <NSWindowDelegate, NSToolbarDelegate> {
	@private
	MainWindowController *mainCont;
	IBOutlet NSToolbar *toolBar;
	IBOutlet NSView *generalView;
	IBOutlet NSView *appearanceView;
	IBOutlet NSTextField *minNumberOfSides;
	IBOutlet NSTextField *maxNumberOfSides;
	
	NSView *blankView;
}

@property (assign, nonatomic) MainWindowController *mainCont;
@property (retain, nonatomic) IBOutlet NSToolbar *toolBar;
@property (retain, nonatomic) IBOutlet NSView *generalView;
@property (retain, nonatomic) IBOutlet NSView *appearanceView;
@property (retain, nonatomic) IBOutlet NSTextField *minNumberOfSides;
@property (retain, nonatomic) IBOutlet NSTextField *maxNumberOfSides;
@property (retain, nonatomic) NSView *blankView;

- (IBAction)showGeneral:(id)sender;
- (IBAction)showAppearance:(id)sender;

- (void)saveState:(NSUserDefaults *)defaults;

@end
