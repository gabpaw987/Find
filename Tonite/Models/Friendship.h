//
//  Friendship.h
//  Tonite
//
//  Created by Gabriel Pawlowsky on 3/23/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Friendship : NSManagedObject

@property (nonatomic, retain) NSString * friendship_id;
@property (nonatomic, retain) NSString * user1_id;
@property (nonatomic, retain) NSString * user2_id;

@end
