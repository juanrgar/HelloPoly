//
//  MainWindowController.h
//  HelloPolyNG
//
//  Created by Juan Rafael Garcia Blanco on 8/11/10.
//  Copyright 2010 UPM. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import "PolygonShape.h"
#import "PolygonView.h"

#define DEFAULT_NUMBER_OF_SIDES 5
#define DEFAULT_MIN_NUMBER_OF_SIDES 3
#define DEFAULT_MAX_NUMBER_OF_SIDES 12

@interface MainWindowController : NSWindowController <NSWindowDelegate> {
	@private
	PolygonShape *polygon;
	PolygonView *polygonView;
	
	IBOutlet NSButton *decreaseButton, *increaseButton;
	IBOutlet NSTextField *numberOfSidesLabel;
	NSSlider *numberOfSidesSlider;
}

enum SwipeDir {
	SwipeLeft, SwipeRight
};

@property (retain, nonatomic) PolygonShape *polygon;
@property (retain, nonatomic) PolygonView *polygonView;
@property (assign, nonatomic) IBOutlet NSButton *decreaseButton, *increaseButton;
@property (assign, nonatomic) IBOutlet NSTextField *numberOfSidesLabel;
@property (retain, nonatomic) NSSlider *numberOfSidesSlider;

- (IBAction)decrease:(id)sender;
- (IBAction)increase:(id)sender;
- (void)sliderMoved:(id)sender;

- (void)toggleShowHideSlider:(BOOL)showingSlider;

- (void)updateInterface;
- (void)saveState:(NSUserDefaults *)defaults;

@end
