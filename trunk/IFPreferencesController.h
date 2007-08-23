//
//  IFPreferencesController.h
//  MobileTwitterrific
//
//  Created by Craig Hockenberry on 8/20/07.
//
//  Copyright (c) 2007, The Iconfactory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <UIKit/UIPreferencesTable.h>
#import <UIKit/UIPreferencesTextTableCell.h>
#import <UIKit/UIPreferencesControlTableCell.h>
#import <UIKit/UITextField.h>

#import "MobileTwitterrificApp.h"


@interface IFPreferencesController : NSObject
{
    MobileTwitterrificApp *controller;
    
    UIPreferencesTable *_preferencesTable;
    UIView *_oldContentView;
	
	// oh bindings, how i miss thee
    UIPreferencesTextTableCell *_loginPreferenceCell;
    UIPreferencesTextTableCell *_passwordPreferenceCell;
    UIPreferencesControlTableCell *_refreshPreferenceCell;
    UIPreferencesControlTableCell *_notifyPreferenceCell;
}

- (id)initWithAppController:(MobileTwitterrificApp *)appController;

- (void)showPreferences;
- (void)hidePreferences;

- (void)_setupCells;

// Notifications
#define PREFERENCES_CHANGED @"IFPreferencesChanged"

@end
