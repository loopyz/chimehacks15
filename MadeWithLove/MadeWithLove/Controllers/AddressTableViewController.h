//
//  CMAddressTableViewController.h
//  ComfortMe
//
//  Created by Lucy Guo on 9/6/14.
//  Copyright (c) 2014 Stephen Greco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class GooglePlacesAutocompleteQuery;

@interface AddressTableViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate>
{
    NSArray *searchResultPlaces;
    GooglePlacesAutocompleteQuery *searchQuery;
    MKPointAnnotation *selectedPlaceAnnotation;
    BOOL shouldBeginEditing;
}

@property (nonatomic, strong) UISearchBar *searchBar;

@end
