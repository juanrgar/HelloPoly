//
//  MainWindowController.m
//  HelloPolyNG
//
//  Created by Juan Rafael Garcia Blanco on 8/11/10.
//  Copyright 2010 UPM. All rights reserved.
//

#import "MainWindowController.h"


@implementation MainWindowController

@synthesize polygon;
@synthesize polygonView;
@synthesize decreaseButton;
@synthesize increaseButton;
@synthesize numberOfSidesLabel;
@synthesize numberOfSidesSlider;

- (id)initWithWindowNibName:(NSString *)windowNibName {
	NSLog(@"MainWindowController initWithWindowNibName:");
	
	int numberOfSides, minNumberOfSides, maxNumberOfSides;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	if (self = [super initWithWindowNibName:windowNibName]) {
		numberOfSides = [defaults integerForKey:@"numberOfSides"];
		if (numberOfSides == 0) {
			numberOfSides = DEFAULT_NUMBER_OF_SIDES;
			minNumberOfSides = DEFAULT_MIN_NUMBER_OF_SIDES;
			maxNumberOfSides = DEFAULT_MAX_NUMBER_OF_SIDES;
		}
		else {
			minNumberOfSides = [defaults integerForKey:@"minNumberOfSides"];
			maxNumberOfSides = [defaults integerForKey:@"maxNumberOfSides"];
		}
		
		polygon = [[PolygonShape alloc] initWithNumberOfSides:numberOfSides minimumNumberOfSides:minNumberOfSides maximumNumberOfSides:maxNumberOfSides];
	}
	return self;
}

- (void)dealloc {
	NSLog(@"MainWindowController dealloc");
	[polygonView release];
	[polygon release];
	[numberOfSidesSlider release];
	[super dealloc];
}

- (void)windowWillLoad {
	NSLog(@"MainWindowController windowWillLoad");
	[super windowWillLoad];
	polygonView = [[PolygonView alloc] initWithFrame:NSMakeRect(91, 79, 291, 291)];
	polygonView.numberOfSides = polygon.numberOfSides;
}

- (void)windowDidLoad {
	NSLog(@"MainWindowController windowDidLoad");
	[super windowDidLoad];
	[[self.window contentView] addSubview:polygonView];
	[self.window makeFirstResponder:polygonView];
	[self updateInterface];
	
	[[polygonView layer] setNeedsDisplay];
}

- (void)moveLayer:(CALayer *)layer from:(CGPoint)startPoint to:(CGPoint)endPoint withDelegate:(id)delegate {
	NSLog(@"moveLayer:from:to:withDelegate:");
	CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
	if (delegate != nil) {
		anim.delegate = delegate;
	}
	anim.fromValue = [NSValue valueWithPoint:NSPointFromCGPoint(startPoint)];
	anim.toValue = [NSValue valueWithPoint:NSPointFromCGPoint(endPoint)];
	layer.position = endPoint;
	[layer addAnimation:anim forKey:@"position"];
}

- (void)swipeTo:(enum SwipeDir)right {
	NSLog(@"swipeTo:");
	
	CALayer *theLayer = [self.polygonView layer];
	CGPoint endPoint;
	if (right == 1) {
		
		endPoint = CGPointMake(theLayer.position.x*3, theLayer.position.y);
	}
	else {
		endPoint = CGPointMake(theLayer.position.x*(-1), theLayer.position.y);
	}
	theLayer.opacity = 0.0;
	[self moveLayer:theLayer from:theLayer.position to:endPoint withDelegate:self];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
	CABasicAnimation *stoppedAnim = (CABasicAnimation *)anim;
	CGPoint curPoint = NSPointToCGPoint([stoppedAnim.toValue pointValue]);
	CALayer *theLayer = [self.polygonView layer];
	CGPoint startPoint, endPoint;
	
	if (curPoint.x > 200) {
		endPoint = CGPointMake(theLayer.position.x/3, theLayer.position.y);
		startPoint = CGPointMake(endPoint.x - endPoint.x*2, endPoint.y);
	}
	else {
		endPoint = CGPointMake(theLayer.position.x*(-1), theLayer.position.y);
		startPoint = CGPointMake(endPoint.x*3, endPoint.y);
	}
	
	theLayer.position = startPoint;
	[theLayer setNeedsDisplay];
	theLayer.opacity = 1.0;
	[self moveLayer:theLayer from:startPoint to:endPoint withDelegate:nil];
}

- (IBAction)decrease:(id)sender {
	NSLog(@"MainWindowController decrease:");
	polygon.numberOfSides--;
	[self updateInterface];
	[self swipeTo:SwipeLeft];
}

- (IBAction)increase:(id)sender {
	NSLog(@"MainWindowController increase:");
	polygon.numberOfSides++;
	[self updateInterface];
	[self swipeTo:SwipeRight];
}

- (void)sliderMoved:(id)sender {
	NSLog(@"MainWindowController sliderMoved:");
	int oldNumberOfSides = polygon.numberOfSides;
	int newNumberOfSides = [numberOfSidesSlider intValue];
	if (oldNumberOfSides == newNumberOfSides) {
		return;
	}
	polygon.numberOfSides = newNumberOfSides;
	[self updateInterface];
	if (oldNumberOfSides > newNumberOfSides) {
		[self increase:nil];
	}
	else {
		[self decrease:nil];
	}

}

- (void)toggleShowHideSlider:(BOOL)showingSlider {
	NSLog(@"MainWindowController toggleShowHideSlider:");
	int minValue = polygon.minimumNumberOfSides;
	int maxValue = polygon.maximumNumberOfSides;
	
	if (!numberOfSidesSlider) {
		numberOfSidesSlider = [[NSSlider alloc] initWithFrame:NSMakeRect(18, 20, 438, 26)];
		[numberOfSidesSlider setNumberOfTickMarks:maxValue - minValue + 1];
		[numberOfSidesSlider setMinValue:minValue];
		[numberOfSidesSlider setMaxValue:maxValue];
		[numberOfSidesSlider setAllowsTickMarkValuesOnly:YES];
		[numberOfSidesSlider setIntValue:polygon.numberOfSides];
		[numberOfSidesSlider setTickMarkPosition:NSTickMarkBelow];
		[numberOfSidesSlider setAction:@selector(sliderMoved:)];
	}
	
	if (!showingSlider) {
		[[self.window contentView] addSubview:numberOfSidesSlider];
		[NSAnimationContext beginGrouping];
		[[decreaseButton animator] setAlphaValue:0.0];
		[[increaseButton animator] setAlphaValue:0.0];
		[[numberOfSidesLabel animator] setAlphaValue:0.0];
		[[numberOfSidesSlider animator] setAlphaValue:1.0];
		[NSAnimationContext endGrouping];
	}
	else {
		[NSAnimationContext beginGrouping];
		[[numberOfSidesSlider animator] setAlphaValue:0.0];
		[[decreaseButton animator] setAlphaValue:1.0];
		[[increaseButton animator] setAlphaValue:1.0];
		[[numberOfSidesLabel animator] setAlphaValue:1.0];
		[NSAnimationContext endGrouping];
		[numberOfSidesSlider removeFromSuperview];
	}
}

- (void)updateInterface {
	NSLog(@"MainWindowController updateInterface");
	int numberOfSides = polygon.numberOfSides;
	BOOL enDec, enInc;
	
	enDec = enInc = YES;
	
	if (numberOfSides == polygon.minimumNumberOfSides) {
		enDec = NO;
	}
	if (numberOfSides == polygon.maximumNumberOfSides) {
		enInc = NO;
	}
	[decreaseButton setEnabled:enDec];
	[increaseButton setEnabled:enInc];
	
	[numberOfSidesLabel setStringValue:[NSString stringWithFormat:@"%d", numberOfSides]];
	polygonView.numberOfSides = numberOfSides;
}

- (void)saveState:(NSUserDefaults *)defaults {
	NSLog(@"MainWindowController saveState:");
	[defaults setInteger:polygon.numberOfSides forKey:@"numberOfSides"];
	[defaults setInteger:polygon.minimumNumberOfSides forKey:@"minNumberOfSides"];
	[defaults setInteger:polygon.maximumNumberOfSides forKey:@"maxNumberOfSides"];
	[polygonView saveState:defaults];
}

- (void)swipeWithEvent:(NSEvent *)event {
	NSLog(@"PolygonView swipeWithEvent: %f", [event deltaX]);
	CGFloat deltaX = [event deltaX];
	int numberOfSides = polygon.numberOfSides;
	
	if (deltaX < 0) {
		if (polygon.maximumNumberOfSides == numberOfSides) {
			return;
		}
		[self increase:nil];
	}
	else {
		if (polygon.minimumNumberOfSides == numberOfSides) {
			return;
		}
		[self decrease:nil];
	}
}

@end
