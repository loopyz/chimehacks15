//
//  PagedPizzaViewController.h
//  MadeWithLove
//
//  Created by Lucy Guo on 7/9/15.
//  Copyright (c) 2015 Lucy Guo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PagedPizzaViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end
