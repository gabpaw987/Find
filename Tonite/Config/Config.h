//
//  Config.h
//  StoreFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#ifndef StoreFinder_Config_h
#define StoreFinder_Config_h

// SETTING TO NO WILL DISPLAY TEST ADS
// SETTING TO YES WILL REMOVE ALL TEST ADS
#define REMOVE_TEST_ADS YES

// Specify test ads id here
// To add another id follow this format
// [NSArray arrayWithObjects:GAD_SIMULATOR_ID, @"DEVICE_ID", nil]
#define TEST_ADS_ID [NSArray arrayWithObjects:GAD_SIMULATOR_ID, nil]

// Change this on your own consumer key
#define TWITTER_CONSUMER_KEY @"15ooS5bXc3vSK3tmwEMC3Cbtv"

// Change this on your own consumer secret
#define TWITTER_CONSUMER_SECRET @"LGctMNKYCUHL1gw1PlSuhTCQvhrbhhJlt31PbQr2VZDy49SJKu"

// You AdMob Banner Unit ID
#define BANNER_UNIT_ID @"ca-app-pub-2715300260198944/9530294111"

// Your email that you wish that users on your app will contact you.
#define ABOUT_US_EMAIL @"admin@tableservicetonite.com"

// Change this url depending on the name of your web hosting.
#define BASE_URL @"http://www.tableservicetonite.com/tonite/"

// AdMob background color
#define AD_BG_COLOR [UIColor clearColor]

// AdMob banner height
#define AD_BANNER_HEIGHT 0

// SHOW ADS ONLY IN MAIN VIEW (NEWS+SLIDER)
#define SHOW_ADS_MAIN_VIEW YES

// SHOW ADS ON FAVORITES VIEW
#define SHOW_ADS_FAVORITES_VIEW NO

// SHOW ADS ON FEATURED VIEW
#define SHOW_ADS_FEATURED_VIEW YES

// SHOW ADS ON FOR SEARCH VIEW
#define SHOW_ADS_SEARCH_VIEW YES

// SHOW ADS ON FOR NEWS VIEW
#define SHOW_ADS_NEWS_VIEW YES

// SHOW ADS ON CATEGORY VIEW
#define SHOW_ADS_CATEGORY_VIEW YES

// SHOW ADS ON MAP VIEW
#define SHOW_ADS_MAP_VIEW YES

// SHOW ADS ON STORE VIEW
#define SHOW_ADS_STORE_VIEW YES

// SHOW ADS ON STORE DETAIL VIEW
#define SHOW_ADS_STORE_DETAIL_VIEW YES

// KILOMETER TO MILES CONVERSION
#define KM_TO_MILES 0.621371f

#define RADIUS_DISTANCE_IN_METERS 300.0f

#define FILTER_DISTANCE_IN_KILOMETERS 20.0f


// DO NOT EDIT THIS
// WE USE THIS FOR DEBUGGING PURPOSES
#define WILL_DOWNLOAD_DATA YES

// DO NOT EDIT THIS
#define CATEGORY_JSON_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"rest/categories.php"]

// DO NOT EDIT THIS
#define VENUECATEGORY_JSON_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"rest/venue_categories.php"]

// DO NOT EDIT THIS
#define TICKET_JSON_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"rest/tickets.php"]

// DO NOT EDIT THIS
#define DATA_JSON_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"rest/data.php"]

// DO NOT EDIT THIS
#define REGISTER_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"rest/register.php"]

// DO NOT EDIT THISz
#define USER_PHOTO_UPLOAD_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"rest/file_uploader_user_photo.php"]

// DO NOT EDIT THIS
#define LOGIN_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"rest/login.php"]

// DO NOT EDIT THIS
#define UPDATE_USER_PROFILE_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"rest/update_user_profile.php"]

// DO NOT EDIT THIS
#define STATUS_SUCCESS @"-1"

// DO NOT EDIT THIS
#define STATUS_ERROR_LOGIN @"1"

// DO NOT EDIT THIS
#define STATUS_ERROR_CREDENTIALS @"2"

// DO NOT EDIT THIS
#define STATUS_ERROR_INVALID_ACCESS @"3"

// DO NOT EDIT THIS
#define STATUS_ERROR_USERNAME_EXIST @"4"

// DO NOT EDIT THIS
#define STATUS_ERROR_OUT_OF_SYNC @"5"

// DO NOT EDIT THIS
#define STATUS_CAN_RATE @"1"

// DO NOT EDIT THIS
#define ANCHOR_LEFT_PEEK 100.0

#endif
