//
//  Entry.h
//  
//
//  Created by Niklas Berglund on 12/19/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Chinese_entry, English_entry;

NS_ASSUME_NONNULL_BEGIN

@interface Entry : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "Entry+CoreDataProperties.h"
