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

@interface PizzaViewController ()

@property (readonly, strong, nonatomic) PizzaTypeView *pizzaView;
@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation PizzaViewController

- (id)init {
    self = [super init];
    if (self) {
        _pizzaView = [[PizzaTypeView alloc] initWithFrame:self.view.frame];
        self.view = _pizzaView;
        _pizzaView.pizzaLabel.text = @"PEPPERONI PIZZA";
        [_pizzaView.timeButton addTarget:self action:@selector(triggerTimePicker) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return self;
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
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitMonth fromDate:selectedDate];

        NSInteger day = [components day];
        NSInteger month = [components month];
        NSInteger hour = [components hour];
        NSInteger minutes = [components minute];
        
        if ([self isToday:selectedDate]) {
            NSString *hourString = [@(hour) stringValue];
            NSString *minutesString = [@(minutes) stringValue];
            
            NSString *timeString = [@"COMING AT " stringByAppendingString:[[hourString stringByAppendingString:@":"] stringByAppendingString:minutesString]];
            
            NSMutableAttributedString *timeLabel = [[NSMutableAttributedString alloc] initWithString:timeString];
            [timeLabel addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, timeLabel.length)];
            
            [_pizzaView.timeButton setAttributedTitle:timeLabel forState:UIControlStateNormal];
            [_pizzaView.timeButton setBackgroundColor:UIColorFromRGB(0x48C0E7)];
        }
        
        else {
            NSString *monthString = [@(month) stringValue];
            NSString *dayString = [@(day) stringValue];
            
            NSString *timeString = [@"COMING ON " stringByAppendingString:[[monthString stringByAppendingString:@"/"] stringByAppendingString:dayString]];
            
            
            NSMutableAttributedString *timeLabel = [[NSMutableAttributedString alloc] initWithString:timeString];
            [timeLabel addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, timeLabel.length)];
            
            [_pizzaView.timeButton setAttributedTitle:timeLabel forState:UIControlStateNormal];
            [_pizzaView.timeButton setBackgroundColor:UIColorFromRGB(0x48C0E7)];
        }
        NSLog(@"Successfully selected date: %@", selectedDate);
        
        
        
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
    }];
    nowAction.dismissesActionController = YES;

    [dateSelectionController addAction:nowAction];
    

    //Now just present the date selection controller using the standard iOS presentation method
    [self presentViewController:dateSelectionController animated:YES completion:nil];
}

- (void)dateChanged:(id)sender
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
