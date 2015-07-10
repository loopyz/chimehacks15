//
//  PizzaTypeView.h
//  MadeWithLove
//
//  Created by Lucy Guo on 7/9/15.
//  Copyright (c) 2015 Lucy Guo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PizzaTypeView : UIView<UIPageViewControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UILabel *pizzaLabel;
@property (nonatomic, strong) UIImageView *pizzaImage;
@property (nonatomic, strong) UILabel *pizzaPriceLabel;

@property (nonatomic, strong) UIScrollView *pizzaImages;

@property (nonatomic, strong) UIButton *timeButton;
@property (nonatomic, strong) UIButton *orderButton;
@property (nonatomic, strong) UIButton *locationButton;

@end
