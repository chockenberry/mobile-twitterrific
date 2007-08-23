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
	// destroy the preference table
	[_preferencesTable release];
	_preferencesTable = nil;
 
	// destroy the preference cells
	[_loginPreferenceCell release];
	_loginPreferenceCell = nil;
	[_passwordPreferenceCell release];
	_passwordPreferenceCell = nil;
	[_refreshPreferenceCell release];
	_refreshPreferenceCell = nil;
	[_notifyPreferenceCell release];
	_notifyPreferenceCell = nil;
	
	[super dealloc];
}

#pragma mark UIPreferencesTable delegate & data source

- (int)numberOfGroupsInPreferencesTable:(id)preferencesTable
{
	//NSLog(@"IFPreferencesController: numberOfGroupsInPreferencesTable:");

	return 2;
}

- (int)preferencesTable:(id)preferencesTable numberOfRowsInGroup:(int)group
{
	//NSLog(@"IFPreferencesController: preferencesTable:numberOfRowsInGroup:");

	int rowCount = 0;	
	switch (group)
	{
	case 0: // Twitter Login
		rowCount = 2;
		break;
	case 1: // Options
		rowCount = 2;
		break;
	}
	return rowCount;
}

- (id)preferencesTable:(id)preferencesTable cellForRow:(int)row inGroup:(int)group
{
	//NSLog(@"IFPreferencesController: preferencesTable:cellForRow:inGroup:");
	
	id prefCell = nil;
	switch (group)
	{
	case 0: // Twitter Login
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
	case 1: // Options
		switch (row)
		{
		case 0:
			prefCell = _refreshPreferenceCell;
			break;
		case 1:
			prefCell = _notifyPreferenceCell;
			break;
		}
		break;
	}
	return prefCell;
}

- (id)preferencesTable:(id)preferencesTable titleForGroup:(int)group
{
	//NSLog(@"IFPreferencesController: preferencesTable:titleForGroup:");

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

- (float)preferencesTable:(id)preferencesTable heightForRow:(int)row inGroup:(int)group withProposedHeight:(float)proposedHeight;
{
	//NSLog(@"IFPreferencesController: preferencesTable:heightForRow:inGroup:withProposedHeight: and proposed height is %f", proposedHeight);
	return 44.0f;
}

#pragma mark View control

- (void)showPreferences
{
	struct CGRect contentRect = [UIHardware fullScreenApplicationContentRect];
	contentRect.origin.x = 0.0f;
	contentRect.origin.y = 0.0f;
	
	// create the main view
	UIView *preferenceView = [[[UIView alloc] initWithFrame:contentRect] autorelease];
	
	// create the navigation bar
	UINavigationBar *navigationBar = [[[UINavigationBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, contentRect.size.width, 44.0f)] autorelease];
	[navigationBar showButtonsWithLeftTitle:nil rightTitle:@"Done" leftBack:YES];
	[navigationBar setBarStyle:0];
	[navigationBar setDelegate:self]; 
	[preferenceView addSubview:navigationBar];
	
	// create the preferences table and add it to our view
	_preferencesTable = [[UIPreferencesTable alloc] initWithFrame:CGRectMake(0.0f, 44.0f, contentRect.size.width, contentRect.size.height - 44.0f)];
	[_preferencesTable setDataSource:self];
	[_preferencesTable reloadData];
	[preferenceView addSubview:_preferencesTable];
	
	// setup the views
	UIWindow *mainWindow = [controller mainWindow];
	_oldContentView = [[mainWindow contentView] retain];
	[mainWindow setContentView:preferenceView];
}

- (void)hidePreferences
{
	// get the current preference values
	NSString *login = [_loginPreferenceCell value];
	NSString *password = [_passwordPreferenceCell value];
/*
NOTE: Use [control valueForKey:@"value"] instead of [control value] to avoid a
linker error. The returned floating point value on the stack will generate a
_objc_msgSend_fpret error. Using KVC lets you get back an NSNumber and then
extract the boolean value.
*/
	BOOL refresh = [[[_refreshPreferenceCell control] valueForKey:@"value"] boolValue];
	BOOL notify = [[[_notifyPreferenceCell control] valueForKey:@"value"] boolValue];

	//NSLog(@"IFPreferencesController: hidePreferences: login = %@", login);
	//NSLog(@"IFPreferencesController: hidePreferences: password = %@", password);
	//NSLog(@"IFPreferencesController: hidePreferences: refresh = %d", refresh);
	
	// save the preferences in user defaults
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:login forKey:@"login"];
	[userDefaults setObject:password forKey:@"password"];
	[userDefaults setBool:refresh forKey:@"refresh"];
	[userDefaults setBool:notify forKey:@"notify"];
	[userDefaults synchronize];
	
	// restore the original content view
	[[controller mainWindow] setContentView:_oldContentView];
	[_oldContentView release];
	_oldContentView = nil;
	
	// destroy the preference table for now, it will be recreated the next time we show
	[_preferencesTable release];
	_preferencesTable = nil;

	// notify the app controller that new user defaults are available
	[[NSNotificationCenter defaultCenter] postNotificationName:PREFERENCES_CHANGED object:nil];
}

#pragma mark UINavigationBar delegate

- (void)navigationBar:(UINavigationBar*)navbar buttonClicked:(int)button 
{
	switch (button) 
	{
	case 0: 
		[self hidePreferences]; 
		break;
	}
}

#pragma mark Utility

- (void)_setupCells
{
	struct CGRect contentRect = [UIHardware fullScreenApplicationContentRect];

	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

	//NSLog(@"IFPreferencesController: _setupCells: login = %@", [userDefaults stringForKey:@"login"]);
	//NSLog(@"IFPreferencesController: _setupCells: password = %@", [userDefaults stringForKey:@"password"]);
	//NSLog(@"IFPreferencesController: _setupCells: refresh = %d", [userDefaults boolForKey:@"refresh"]);

	_loginPreferenceCell = [[UIPreferencesTextTableCell alloc] initWithFrame:CGRectMake(0.0f, 0.0f, contentRect.size.width, 44.0f)];
	[_loginPreferenceCell setValue:[userDefaults stringForKey:@"login"]];
	[_loginPreferenceCell setTitle:@"Login"];
	
	_passwordPreferenceCell = [[UIPreferencesTextTableCell alloc] initWithFrame:CGRectMake(0.0f, 44.0f, contentRect.size.width, 44.0f)];
	[_passwordPreferenceCell setValue:[userDefaults stringForKey:@"password"]];
	[_passwordPreferenceCell setTitle:@"Password"];
	[[_passwordPreferenceCell textField] setSecure:YES];

	_refreshPreferenceCell = [[UIPreferencesControlTableCell alloc] initWithFrame:CGRectMake(0.0f, 0.0f, contentRect.size.width, 44.0f)];
	BOOL refresh = [userDefaults boolForKey:@"refresh"];
	[_refreshPreferenceCell setTitle:@"Automatic Refresh"];
	UISwitchControl *refreshSwitchControl = [[[UISwitchControl alloc] initWithFrame:CGRectMake(contentRect.size.width - 112.0, 9.0f, 112.0f, 44.0f)] autorelease];
	[refreshSwitchControl setValue:refresh];
	[_refreshPreferenceCell setControl:refreshSwitchControl];

	_notifyPreferenceCell = [[UIPreferencesControlTableCell alloc] initWithFrame:CGRectMake(0.0f, 0.0f, contentRect.size.width, 44.0f)];
	BOOL notify = [userDefaults boolForKey:@"notify"];
	[_notifyPreferenceCell setTitle:@"Notification Sound"];
	UISwitchControl *notifySwitchControl = [[[UISwitchControl alloc] initWithFrame:CGRectMake(contentRect.size.width - 112.0, 9.0f, 112.0f, 44.0f)] autorelease];
	[notifySwitchControl setValue:notify];
	[_notifyPreferenceCell setControl:notifySwitchControl];
}

@end
