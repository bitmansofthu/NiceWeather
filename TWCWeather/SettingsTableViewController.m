//
//  SettingsTableTableViewController.m
//  TWCWeather
//
//  Created by AquaJava on 11/05/16.
//  Copyright © 2016 AquaJava. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "AppDelegate.h"

@interface SettingsTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UISlider *thresholdSlider;


@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.thresholdSlider.minimumValue = 0;
    self.thresholdSlider.maximumValue = 30;
    
    self.thresholdSlider.value = [[NSUserDefaults standardUserDefaults] integerForKey:NICE_TEMP_KEY];
    
    [self updateTemperatureLabel];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Logic

- (IBAction)thresholdSliderChanged:(UISlider *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNiceTempValueChanged object:[NSNumber numberWithInteger:sender.value]];
    
    [self updateTemperatureLabel];
}

- (IBAction)closePressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateTemperatureLabel {
    self.temperatureLabel.text = [NSString stringWithFormat:@"%ld ºC", (long)self.thresholdSlider.value];
}

#pragma mark - Table view data source



/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
