//
//  RootViewController.m
//  MadeWithLove
//
//  Created by Lucy Guo on 7/9/15.
//  Copyright (c) 2015 Lucy Guo. All rights reserved.
//

#import "PizzaViewController.h"
#import "PizzaTypeView.h"
#import <RMDateSelectionViewController.h>
#import "macros.h"
#import <FAKFontAwesome.h>
#import <JTAlertView.h>
#import "SPGooglePlacesAutocompleteViewController.h"
#import "CMAddressSearchViewController.h"

@interface PizzaViewController () <UIAlertViewDelegate, CMAddressSearchDelegate>

@property (readonly, strong, nonatomic) PizzaTypeView *pizzaView;
@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation PizzaViewController {
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}

- (id)init {
    self = [super init];
    if (self) {
        _pizzaView = [[PizzaTypeView alloc] initWithFrame:self.view.frame];
        self.view = _pizzaView;
        _pizzaView.pizzaLabel.text = @"SURPREME PIZZA";
        [_pizzaView.timeButton addTarget:self action:@selector(triggerTimePicker) forControlEvents:UIControlEventTouchUpInside];
        [_pizzaView.orderButton addTarget:self action:@selector(orderPizza) forControlEvents:UIControlEventTouchUpInside];
        [_pizzaView.locationButton addTarget:self action:@selector(openLocationSelector) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setSelectedAddress:(NSString *)address {
    FAKFontAwesome *locationIcon = [FAKFontAwesome locationArrowIconWithSize:16];
    [locationIcon addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x828282)];
    
    NSMutableAttributedString *locationString = [[NSMutableAttributedString alloc] initWithAttributedString:[locationIcon attributedString]];
    
    NSRange range = [address rangeOfString:@","];
    
    NSString *shorterAddress = [address substringToIndex:range.location];
    
    NSMutableAttributedString *locationLabel = [[NSMutableAttributedString alloc] initWithString:[@"  " stringByAppendingString:shorterAddress]];
    [locationLabel addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x828282) range:NSMakeRange(0, locationLabel.length)];
    
    
    [locationString appendAttributedString:locationLabel];
    
    [_pizzaView.locationButton setAttributedTitle:locationString forState:UIControlStateNormal];
}

- (void)openLocationSelector {
    CMAddressSearchViewController *vc = [[CMAddressSearchViewController alloc] init];
    vc.delegate = self;
    
    
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:vc];
    
    navigationController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(dismissView)];
    
    //now present this navigation controller modally
    [self presentViewController:navigationController
                       animated:YES
                     completion:^{
                         
                     }];
    
}

- (void)dismissView {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)orderPizza {
//    NSString *address = [_pizzaView.locationButton.titleLabel.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
//    NSString *urlAsString = [[NSString stringWithFormat:@"http://twitterautomate.com/testapp/madewithlove.php?address="] stringByAppendingString:[address substringWithRange:NSMakeRange(3, address.length-3)]];
//    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
//    
//    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        
//        if (error) {
//            NSLog(@"Error %@; %@", error, [error localizedDescription]);
//        } else {
//            NSLog(@"Twilio'd");
//        }
//    }];
    
    JTAlertView *alertView = [[JTAlertView alloc] initWithTitle:@"We'll be there soon. Give us your number for updates. :)" andImage:[UIImage imageNamed:@"city"]];
    alertView.size = CGSizeMake(330, 230);
    alertView.popAnimation = YES;
    alertView.backgroundShadow = YES;
    
    [alertView addButtonWithTitle:@"OK" style:JTAlertViewStyleDefault action:^(JTAlertView *alertView) {
        [alertView hide];
    }];
    
    [alertView addButtonWithTitle:@"Add Phone #" style:JTAlertViewStyleDestructive action:^(JTAlertView *alertView) {
        [alertView hide];
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Phone Number" message:@"We'll call/text you about any questions." delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField * alertTextField = [alert textFieldAtIndex:0];
        alertTextField.keyboardType = UIKeyboardTypeNumberPad;
        alertTextField.placeholder = @"Enter your phone number";
        alert.delegate = self;
        [alert show];
    }];
    
    [alertView show];
}

- (BOOL)isToday:(NSDate *)date {
    NSDate *baseDate = [NSDate date];
    
    // determine the NSDate for midnight of the base date:
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comps = [calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit)
                                          fromDate:baseDate];
    NSDate* theMidnightHour = [calendar dateFromComponents:comps];
    
    // set up a localized date formatter so we can see the answers are right!
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    
    NSTimeInterval interval = [date timeIntervalSinceDate:theMidnightHour];
    if (interval >= 0 && interval < 60*60*24) {
        NSLog(@"%@ is on the same day as %@", [dateFormatter stringFromDate:date], [dateFormatter stringFromDate:baseDate]);
        return YES;
    }
    else {
        NSLog(@"%@ is NOT on the same day as %@", [dateFormatter stringFromDate:date], [dateFormatter stringFromDate:baseDate]);
        return NO;
    }
    
}

- (void)triggerTimePicker {
    //Create select action
    RMAction *selectAction = [RMAction actionWithTitle:@"Select" style:RMActionStyleDone andHandler:^(RMActionController *controller) {
        NSDate *selectedDate = ((UIDatePicker *)controller.contentView).date;
        
        if ([self isToday:selectedDate]) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"hh:mm a"];
            
            NSString *timeString = [@"Coming at " stringByAppendingString:[formatter stringFromDate:selectedDate]];
            
            NSMutableAttributedString *timeLabel = [[NSMutableAttributedString alloc] initWithString:timeString];
            [timeLabel addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, timeLabel.length)];
            
            [_pizzaView.timeButton setAttributedTitle:timeLabel forState:UIControlStateNormal];
            [_pizzaView.timeButton setBackgroundColor:UIColorFromRGB(0x48C0E7)];
        }
        
        else {
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"LLLL dd"];
            NSString *formattedDate = [df stringFromDate:selectedDate];
            
            NSString *timeString = [@"Coming on " stringByAppendingString:formattedDate];
            
            
            NSMutableAttributedString *timeLabel = [[NSMutableAttributedString alloc] initWithString:timeString];
            [timeLabel addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, timeLabel.length)];
            
            [_pizzaView.timeButton setAttributedTitle:timeLabel forState:UIControlStateNormal];
            [_pizzaView.timeButton setBackgroundColor:UIColorFromRGB(0x48C0E7)];
        }
        
        
        
    }];

    //Create cancel action
    RMAction *cancelAction = [RMAction actionWithTitle:@"Cancel" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
        NSLog(@"Date selection was canceled");
    }];

    //Create date selection view controller
    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:RMActionControllerStyleWhite selectAction:selectAction andCancelAction:cancelAction];
    dateSelectionController.title = @"Select Delivery Time";
    dateSelectionController.message = @"Choose a time for us to come. We'll be there +/- 15 minutes.";

    //Create now action and add it to date selection view controller
    RMAction *nowAction = [RMAction actionWithTitle:@"ASAP" style:RMActionStyleAdditional andHandler:^(RMActionController *controller) {
        ((UIDatePicker *)controller.contentView).date = [NSDate date];
        
        NSString *timeString = @"Coming ASAP";
        
        
        NSMutableAttributedString *timeLabel = [[NSMutableAttributedString alloc] initWithString:timeString];
        [timeLabel addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, timeLabel.length)];
        
        [_pizzaView.timeButton setAttributedTitle:timeLabel forState:UIControlStateNormal];
        [_pizzaView.timeButton setBackgroundColor:UIColorFromRGB(0x48C0E7)];
        
    }];
    nowAction.dismissesActionController = YES;

    [dateSelectionController addAction:nowAction];
    

    //Now just present the date selection controller using the standard iOS presentation method
    [self presentViewController:dateSelectionController animated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"Entered: %@",[[alertView textFieldAtIndex:0] text]);
    
    NSString *urlAsString = [[NSString stringWithFormat:@"http://twitterautomate.com/testapp/madewithlove2.php?number="] stringByAppendingString:[[alertView textFieldAtIndex:0] text]];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"Error %@; %@", error, [error localizedDescription]);
        } else {
            NSLog(@"Twilio'd");
        }
    }];
    
    
}

- (void)dateChanged:(id)sender
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self CurrentLocationIdentifier];
}

- (void)CurrentLocationIdentifier {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
    geocoder = [[CLGeocoder alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations objectAtIndex:0];
    [locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSLog(@"\nCurrent Location Detected\n");
             NSLog(@"placemark %@",placemark);
             NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             NSString *Address = [[NSString alloc]initWithString:locatedAt];
             NSString *Area = [[NSString alloc]initWithString:placemark.locality];
             NSString *Country = [[NSString alloc]initWithString:placemark.country];
             NSString *CountryArea = [NSString stringWithFormat:@"%@, %@", Area,Country];
             NSLog(@"%@",CountryArea);
         }
         else
         {
             NSLog(@"Geocode failed with error %@", error);
             NSLog(@"\nCurrent Location Not Detected\n");
             //return;
         }
         /*---- For more results
          placemark.region);
          placemark.country);
          placemark.locality);
          placemark.name);
          placemark.ocean);
          placemark.postalCode);
          placemark.subLocality);
          placemark.location);
          ------*/
     }];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        // Reverse Geocoding
        NSLog(@"Resolving the Address");
        [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
            if (error == nil && [placemarks count] > 0) {
                placemark = [placemarks lastObject];
                
                FAKFontAwesome *locationIcon = [FAKFontAwesome locationArrowIconWithSize:16];
                [locationIcon addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x828282)];
                
                NSMutableAttributedString *locationString = [[NSMutableAttributedString alloc] initWithAttributedString:[locationIcon attributedString]];
                
                NSMutableAttributedString *locationLabel = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@ %@",
                                                                                                              placemark.subThoroughfare, placemark.thoroughfare]];
                [locationLabel addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x828282) range:NSMakeRange(0, locationLabel.length)];
                
                
                [locationString appendAttributedString:locationLabel];
                
                [_pizzaView.locationButton setAttributedTitle:locationString forState:UIControlStateNormal];
                
                
            } else {
                NSLog(@"%@", error.debugDescription);
            }
        } ];
        
    }
}






@end
