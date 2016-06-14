//
//  SettingsTableTableViewController.h
//  TWCWeather
//
//  Created by AquaJava on 11/05/16.
//  Copyright © 2016 AquaJava. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsTableViewControllerDelegate <NSObject>

- (void) niceTempValueChanged:(NSInteger)value;

@end

@interface SettingsTableViewController : UITableViewController

@property (nonatomic, assign) id<SettingsTableViewControllerDelegate> delegate;

@end
