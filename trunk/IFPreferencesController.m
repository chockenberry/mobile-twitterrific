//
//  IFPreferencesController.m
//  MobileTwitterrific
//
//  Created by Craig Hockenberry on 8/20/07.
//  Based on Ian Baird's code in iPwnce
//
//  Copyright (c) 2007, The Iconfactory. All rights reserved.
//

#import "IFPreferencesController.h"

#import <UIKit/CDStructures.h>
#import <UIKit/UISwitchControl.h>


@implementation IFPreferencesController

#pragma mark Instance management

- (id)initWithAppController:(MobileTwitterrificApp *)appController
{
	self = [super init];
	if (self != nil)
	{
		controller = appController;
		[self _setupCells];
	}
	return self;
}

- (void)dealloc
{
	// destroy the ui prefs table
	[_prefsTable release];
	_prefsTable = nil;
 
	// destroy the prefs cells
	[_loginPreferenceCell release];
	_loginPreferenceCell = nil;
	[_passwordPreferenceCell release];
	_passwordPreferenceCell = nil;
	[_refreshPreferenceCell release];
	_refreshPreferenceCell = nil;
	
	[super dealloc];
}

#pragma mark UIPreferencesTable delegate & data source

- (int)numberOfGroupsInPreferencesTable:(id)prefsTable
{
	NSLog(@"IFPreferencesController: numberOfGroupsInPreferencesTable:");

	return 2;
}

- (int)preferencesTable:(id)prefsTable numberOfRowsInGroup:(int)group
{
	NSLog(@"IFPreferencesController: preferencesTable:numberOfRowsInGroup:");

	int rowCount = 0;	
	switch (group)
	{
	case 0:
		rowCount = 2;
		break;
	case 1:
		rowCount = 1;
		break;
	}
	return rowCount;
}

- (id)preferencesTable:(id)prefsTable cellForRow:(int)row inGroup:(int)group
{
	NSLog(@"IFPreferencesController: preferencesTable:cellForRow:inGroup:");
	
	id prefCell = nil;
	switch (group)
	{
	case 0:
		switch (row)
		{
		case 0:
			prefCell = _loginPreferenceCell;
			break;
		case 1:
			prefCell = _passwordPreferenceCell;
			break;
		}
		break;
	case 1:
		switch (row)
		{
		case 0:
			prefCell = _refreshPreferenceCell;
			break;
		}
		break;
	}
	return prefCell;
}

- (id)preferencesTable:(id)prefsTable titleForGroup:(int)group
{
	NSLog(@"IFPreferencesController: preferencesTable:titleForGroup:");

	NSString *title = nil;
	switch (group)
	{
	case 0:
		title = @"Twitter Login";
		break;
	case 1:
		title = @"Options";
		break;
	}
	return title;
}

- (float)preferencesTable:(id)prefsTable heightForRow:(int)row inGroup:(int)group withProposedHeight:(float)proposedHeight;
{
	NSLog(@"IFPreferencesController: preferencesTable:heightForRow:inGroup:withProposedHeight: and proposed height is %f", proposedHeight);
	return 48.0f;
}

#pragma mark View control

- (void)showPrefs
{
	UIWindow *mainWindow = [controller mainWindow];
	//CGRect prefsBounds = CGRectMake(0.0f, 0.0f, 320.0f, 0.0f);
	
	// create the main view
	UIView *mainView = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)] autorelease];
	
	// create the nav bar
	UINavigationBar *navigationBar = [[[UINavigationBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 48.0f)] autorelease];
	[navigationBar showButtonsWithLeftTitle:@"Back" rightTitle:nil leftBack:YES];
	[navigationBar setBarStyle:0];
	[navigationBar setDelegate:self]; 
	[mainView addSubview:navigationBar];
	
	// create the ui prefs table
	_prefsTable = [[UIPreferencesTable alloc] initWithFrame:CGRectMake(0.0f, 48.0f, 320.0f, 480.0f - 48.0f)];
	[_prefsTable setDataSource:self];
	[_prefsTable reloadData];
	[mainView addSubview:_prefsTable];
	
	// setup the views
	_oldContentView = [[mainWindow contentView] retain];
	[mainWindow setContentView:mainView];
}

- (void)hidePrefs
{
	// save the prefs
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:[_loginPreferenceCell value] forKey:@"login"];
	[userDefaults setObject:[_passwordPreferenceCell value] forKey:@"password"];
	[userDefaults setObject:[_refreshPreferenceCell value] forKey:@"refresh"];
	
	// restore the original content view
	[[controller mainWindow] setContentView:_oldContentView];
	[_oldContentView release];
	_oldContentView = nil;
	
	// destroy the ui prefs table
	[_prefsTable release];
	_prefsTable = nil;
}

#pragma mark UINavigationBar delegate

- (void)navigationBar:(UINavigationBar*)navbar buttonClicked:(int)button 
{
	switch (button) 
	{
	case 1: 
		[self hidePrefs]; 
		break;
	}
}

#pragma mark Utility

-(void) _setupCells
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	_loginPreferenceCell = [[UIPreferencesTextTableCell alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 48.0f)];
	[_loginPreferenceCell setValue:[userDefaults stringForKey:@"login"]];
	[_loginPreferenceCell setTitle:@"Login"];
	
	_passwordPreferenceCell = [[UIPreferencesTextTableCell alloc] initWithFrame:CGRectMake(0.0f, 48.0f, 320.0f, 48.0f)];
	[_passwordPreferenceCell setValue:[userDefaults stringForKey:@"password"]];
	[_passwordPreferenceCell setTitle:@"Password"];
	[[_passwordPreferenceCell textField] setSecure:YES];

	_refreshPreferenceCell = [[UIPreferencesControlTableCell alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 48.0f)];
	[_refreshPreferenceCell setValue:[userDefaults stringForKey:@"refresh"]];
	[_refreshPreferenceCell setTitle:@"Automatic refresh"];
	UISwitchControl *switchControl = [[[UISwitchControl alloc] initWithFrame:CGRectMake(320.0f - 114.0, 11.0f, 320.0f, 48.0f)] autorelease];
	[_refreshPreferenceCell setControl:switchControl];
}

@end
