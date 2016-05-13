//
//  ViewController.m
//  TWCWeather
//
//  Created by AquaJava on 09/05/16.
//  Copyright © 2016 AquaJava. All rights reserved.
//

#import "WeatherViewController.h"
#import "Model/ColorHelper.h"
#import "SettingsTableViewController.h"
#import "Model/OpenWeatherMapProvider.h"
#import "Model/LocationProvider.h"
#import "AppDelegate.h"

#define GRADIENT_ANIMATION_DURATION 2.0
#define CLOUDINESS_PERCENT_THRESHOLD 40

@interface WeatherViewController ()

@property (nonatomic, strong) CAGradientLayer *gradientBackgroundLayer;
@property (nonatomic, strong) UIColor* defaultTopColor;
@property (nonatomic, strong) UIColor* defaultBottomColor;
@property (nonatomic, strong) UIColor* clearTopColor;
@property (nonatomic, strong) UIColor* clearBottomColor;
@property (nonatomic, strong) UIColor* cloudyTopColor;
@property (nonatomic, strong) UIColor* cloudyBottomColor;

@property (weak, nonatomic) IBOutlet UIView *gradientContainerView;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

@property (assign) NSInteger niceTemp;
@property (assign) float currentTemp;

@end

@implementation WeatherViewController{
    BOOL weatherIconAnimating;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(niceTempChanged:) name:kNiceTempValueChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationUpdated:) name:kCurrentLocationUpdated object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:NICE_TEMP_KEY]) {
        _niceTemp = [[NSUserDefaults standardUserDefaults] integerForKey:NICE_TEMP_KEY];
    } else {
        _niceTemp = 15;
        [[NSUserDefaults standardUserDefaults] setInteger:self.niceTemp forKey:NICE_TEMP_KEY];
    }
    
    self.weatherIcon.image = [UIImage imageNamed:@"sun"];
    
    [self createGradientBackground];
    
    [self updateWeatherAndLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)appWillEnterForeground:(NSNotification*)notif {
    [self updateWeatherAndLocation];
}

- (void)viewDidLayoutSubviews {
    self.gradientBackgroundLayer.frame = self.gradientContainerView.bounds;
}

- (void)updateWeatherAndLocation {
    [self startWeatherIconSpinning];
    self.statusLabel.alpha = 0;
    
    self.settingsButton.enabled = NO;
    
    [[LocationProvider sharedInstance] startUpdatingLocation];
}

- (void)downloadWeatherData:(CLLocationCoordinate2D)coordinates {
    OpenWeatherMapProvider* provider = [[OpenWeatherMapProvider alloc] init];
    
    NSArray* coordsArr = @[[NSNumber numberWithDouble:coordinates.latitude], [NSNumber numberWithDouble:coordinates.longitude]];
    
    // TODO obtain current location
    [provider weatherInfoWithLocation:coordsArr complete:^(WeatherInfo *info, NSError *error) {
        [self stopWeatherIconSpinning];
        
        self.settingsButton.enabled = YES;
        
        if (error == nil) {
            if (info.temp) {
                [UIView animateWithDuration:2.0 animations:^{
                    self.statusLabel.alpha = 1.0;
                }];
                
                self.currentTemp = [info.temp floatValue];
                
                [self updateStatusLabel];
            }
            
            if (info.cloudiness) {
                if (info.cloudiness.integerValue < CLOUDINESS_PERCENT_THRESHOLD) {
                    [self animateGradient:@[(id)self.clearTopColor.CGColor, (id)self.clearBottomColor.CGColor]];
                } else {
                    [self animateGradient:@[(id)self.cloudyTopColor.CGColor, (id)self.cloudyBottomColor.CGColor]];
                }
            }
        } else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", nil) message:NSLocalizedString(@"Failed to download weather data.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
            [alert show];
        }
    }];
}

- (void)niceTempChanged:(NSNotification*)notif {
    self.niceTemp = [notif.object integerValue];
    [[NSUserDefaults standardUserDefaults] setInteger:self.niceTemp forKey:NICE_TEMP_KEY];
    
    [self updateStatusLabel];
}

- (void)locationUpdated:(NSNotification*)notif {
    if ([notif.object isKindOfClass:[CLLocation class]]) {
        CLLocation* loc = (CLLocation*)notif.object;
        
        [self downloadWeatherData:loc.coordinate];
        
        [[LocationProvider sharedInstance] stopUpdatingLocation];
    } else {
        [self stopWeatherIconSpinning];
        self.settingsButton.enabled = YES;
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", nil) message:NSLocalizedString(@"Current location is unavailable.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [alert show];
    }
}

- (void)updateStatusLabel {
    if (self.currentTemp >= self.niceTemp) {
        self.statusLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Nice, %.1f ºC", nil), self.currentTemp];
    } else {
        self.statusLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%.1f ºC", nil), self.currentTemp];
    }
}

- (IBAction)settingsPressed:(UIButton*)sender {
    SettingsTableViewController* ctrl = (SettingsTableViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"settingsNavigationController"];
    
    ctrl.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:ctrl animated:YES completion:nil];
    
    UIPopoverPresentationController *popController = [ctrl popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.sourceView = self.view;
    popController.sourceRect = sender.frame;
}

- (void)createGradientBackground {
    self.defaultTopColor = UIColorFromRGB(0x0E253B);
    self.defaultBottomColor = UIColorFromRGB(0x22577D);
    self.clearTopColor = UIColorFromRGB(0xF1C433);
    self.clearBottomColor = UIColorFromRGB(0x6BC4D6);
    self.cloudyTopColor = UIColorFromRGB(0xD2D3D0);
    self.cloudyBottomColor = UIColorFromRGB(0x888A85);
    
    self.gradientBackgroundLayer = [CAGradientLayer layer];
    self.gradientBackgroundLayer.frame = self.gradientContainerView.bounds;
    self.gradientBackgroundLayer.colors = @[
                       (id)self.defaultTopColor.CGColor,
                       (id)self.defaultBottomColor.CGColor
                       ];
    
    [self.gradientContainerView.layer addSublayer:self.gradientBackgroundLayer];
}

- (void)animateGradient:(NSArray*)toColors {
    NSArray *fromColors = self.gradientBackgroundLayer.colors;
    
    self.gradientBackgroundLayer.colors = toColors;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"colors"];
    
    animation.fromValue = fromColors;
    animation.toValue = toColors;
    animation.duration = GRADIENT_ANIMATION_DURATION;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.gradientBackgroundLayer addAnimation:animation forKey:@"animateGradient"];
}

- (void) startWeatherIconSpinning {
    weatherIconAnimating = YES;
    self.weatherIcon.alpha = 1;
    
    [self spinWeatherIconWithOptions:UIViewAnimationOptionCurveEaseIn];
}

- (void) stopWeatherIconSpinning {
    weatherIconAnimating = NO;
}

- (void) spinWeatherIconWithOptions: (UIViewAnimationOptions) options {
    // this spin completes 360 degrees every 2 seconds
    [UIView animateWithDuration: 1.0f
                          delay: 0.0f
                        options: options
                     animations: ^{
                         self.weatherIcon.transform = CGAffineTransformRotate(self.weatherIcon.transform, M_PI / 2);
                         
                         if (options == UIViewAnimationOptionCurveEaseOut) {
                             self.weatherIcon.alpha = 0.0f;
                         } else {
                             self.weatherIcon.alpha = 1.0f;
                         }
                     }
                     completion: ^(BOOL finished) {
                         if (finished) {
                             if (weatherIconAnimating) {
                                 // if flag still set, keep spinning with constant speed
                                 [self spinWeatherIconWithOptions: UIViewAnimationOptionCurveLinear];
                             } else if (options != UIViewAnimationOptionCurveEaseOut) {
                                 // one last spin, with deceleration
                                 [self spinWeatherIconWithOptions: UIViewAnimationOptionCurveEaseOut];
                             }
                         }
                     }];
}

@end
