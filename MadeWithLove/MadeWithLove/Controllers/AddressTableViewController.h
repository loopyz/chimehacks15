//
//  CMAddressTableViewController.h
//  ComfortMe
//
//  Created by Lucy Guo on 7/9/15.
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
