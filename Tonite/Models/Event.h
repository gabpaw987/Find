//
//  Store.h
//  Tonite
//
//  Created by Gabriel Pawlowsky on 3/23/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * event_id;
@property (nonatomic, retain) NSString * icon_id;
@property (nonatomic, retain) NSString * category_id;
@property (nonatomic, retain) NSString * venue_id;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * phone_no;
@property (nonatomic, retain) NSString * lon;
@property (nonatomic, retain) NSString * lat;
@property (nonatomic, retain) NSString * event_capacity;
@property (nonatomic, retain) NSString * event_tickets_male;
@property (nonatomic, retain) NSString * event_tickets_female;
@property (nonatomic, retain) NSString * event_desc;
@property (nonatomic, retain) NSString * event_address1;
@property (nonatomic, retain) NSString * event_address2;
@property (nonatomic, retain) NSString * event_zip;
@property (nonatomic, retain) NSString * event_city;
@property (nonatomic, retain) NSString * event_state;
@property (nonatomic, retain) NSString * event_country;
@property (nonatomic, retain) NSString * event_date_starttime;
@property (nonatomic, retain) NSString * event_endtime;
@property (nonatomic, retain) NSString * event_name;
@property (nonatomic, retain) NSString * updated_at;
@property (nonatomic, retain) NSString * created_at;
@property (nonatomic, retain) NSString * website;

@end
