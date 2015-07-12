//
//  PizzaTypeView.m
//  MadeWithLove
//
//  Created by Lucy Guo on 7/9/15.
//  Copyright (c) 2015 Lucy Guo. All rights reserved.
//

#import "PizzaTypeView.h"
#import "macros.h"
#import <FontAwesomeKit.h>
#import <RMDateSelectionViewController.h>

@interface PizzaTypeView()

@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation PizzaTypeView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupPizzaLabel];
        [self setupPizzaImage];
        [self setupTimeButton];
        [self setupOrderButton];
        [self setupLocationButton];
        [self setupPizzaPriceLabel];
    }
    
    return self;
}

- (void)setupPizzaPriceLabel {
    _pizzaPriceLabel = [[UILabel alloc] init];
    _pizzaPriceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _pizzaPriceLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:54];
    _pizzaPriceLabel.textColor = UIColorFromRGB(0xF93939);
    _pizzaPriceLabel.text = @"$5";
    _pizzaPriceLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_pizzaPriceLabel];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_pizzaPriceLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_pizzaPriceLabel)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_timeButton]-25-[_pizzaPriceLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_timeButton, _pizzaPriceLabel)]];
}

- (void)setupLocationButton {
    _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _locationButton.translatesAutoresizingMaskIntoConstraints = NO;
    _locationButton.backgroundColor = UIColorFromRGB(0xFCFCFC);
    _locationButton.layer.borderColor = [UIColorFromRGB(0xBFBBBB) CGColor];
    _locationButton.layer.borderWidth = .8f;
    
    FAKFontAwesome *locationIcon = [FAKFontAwesome locationArrowIconWithSize:16];
    [locationIcon addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x828282)];
    
    NSMutableAttributedString *locationString = [[NSMutableAttributedString alloc] initWithAttributedString:[locationIcon attributedString]];
    
    NSMutableAttributedString *locationLabel = [[NSMutableAttributedString alloc] initWithString:@"  1355 Market Street"];
    [locationLabel addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x828282) range:NSMakeRange(0, locationLabel.length)];
    
    
    [locationString appendAttributedString:locationLabel];
    
    [_locationButton setAttributedTitle:locationString forState:UIControlStateNormal];
    
    [self addSubview:_locationButton];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_locationButton]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_locationButton)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_locationButton(45)]-0-[_orderButton]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_orderButton, _locationButton)]];
    
}

- (void)setupOrderButton {
    _orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _orderButton.translatesAutoresizingMaskIntoConstraints = NO;
    _orderButton.backgroundColor = UIColorFromRGB(0xEE1C1D);
    _orderButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Bold" size:18];
    [_orderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_orderButton setTitle:@"ORDER PIZZA" forState:UIControlStateNormal];
    
    [self addSubview:_orderButton];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_orderButton]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_orderButton)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_orderButton(55)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_orderButton)]];
}

- (void)setupTimeButton {
    _timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _timeButton.backgroundColor = [UIColor whiteColor];
    _timeButton.layer.cornerRadius = 13;
    _timeButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:15
                                   ];
    [_timeButton setTitleColor:UIColorFromRGB(0x48C0E7) forState:UIControlStateNormal];
    _timeButton.translatesAutoresizingMaskIntoConstraints = NO;
    _timeButton.layer.borderWidth = 1;
    _timeButton.layer.borderColor = [UIColorFromRGB(0x48C0E7) CGColor];
    
    FAKFontAwesome *timeIcon = [FAKFontAwesome clockOIconWithSize:15];
    [timeIcon addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x48C0E7)];
    
    NSMutableAttributedString *timeString = [[NSMutableAttributedString alloc] initWithAttributedString:[timeIcon attributedString]];
    
    NSMutableAttributedString *timeLabel = [[NSMutableAttributedString alloc] initWithString:@"  Set Delivery Time"];
    [timeLabel addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x48C0E7) range:NSMakeRange(0, timeLabel.length)];
    
    
    [timeString appendAttributedString:timeLabel];

    [_timeButton setAttributedTitle:timeString forState:UIControlStateNormal];
    
    [self addSubview:_timeButton];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-90-[_timeButton]-90-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_timeButton)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_pizzaImage]-30-[_timeButton(30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_timeButton, _pizzaImage)]];
}

- (void)setupPizzaImage {
    //Horizontal arrangement
    UIImage *image = [UIImage imageNamed:@"Pizza"];
    
    _pizzaImage = [[UIImageView alloc] initWithImage:image];
    _pizzaImage.translatesAutoresizingMaskIntoConstraints = NO;
    _pizzaImage.contentMode = UIViewContentModeCenter;
    [self addSubview:_pizzaImage];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_pizzaLabel]-25-[_pizzaImage]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_pizzaImage, _pizzaLabel)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_pizzaImage]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_pizzaImage)]];
    

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int newOffset = scrollView.contentOffset.x;
    int newPage = (int)(newOffset/(scrollView.frame.size.width));
    [_pageControl setCurrentPage:newPage];
}

- (void)setupPizzaLabel {
    _pizzaLabel = [[UILabel alloc] init];
    _pizzaLabel.textColor = UIColorFromRGB(0xA9A9A9);
    _pizzaLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:18];
    _pizzaLabel.textAlignment = NSTextAlignmentCenter;
    _pizzaLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:_pizzaLabel];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[_pizzaLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_pizzaLabel)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_pizzaLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_pizzaLabel)]];
}

- (void)updateTimeButtonConstraints:(BOOL)isDate {
    if (isDate) {
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-60-[_timeButton]-60-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_timeButton)]];
        [self updateConstraints];
    } else {
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-90-[_timeButton]-90-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_timeButton)]];
        [self updateConstraints];

    }
}

@end
