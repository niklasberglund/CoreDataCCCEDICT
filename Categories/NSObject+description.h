//
//  NSObject+description.h
//
//  Created by Niklas Berglund on 6/5/15.
//

#import <Foundation/Foundation.h>

@interface NSObject (description)

- (NSString *)descriptionWithMembers:(NSDictionary *)memberVariables;

@end
