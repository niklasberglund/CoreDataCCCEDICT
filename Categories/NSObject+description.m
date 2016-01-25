//
//  NSObject+description.m
//
//  Created by Niklas Berglund on 6/5/15.
//

#import "NSObject+description.h"

@implementation NSObject (description)

- (NSString *)descriptionWithMembers:(NSDictionary *)memberVariables
{
    NSMutableString *descriptionString = [[NSMutableString alloc] init];
    
    [descriptionString appendFormat:@"<%@: %p", [self class], self];
    
    for (NSString *key in memberVariables) {
        NSObject *value = [memberVariables valueForKey:key];
        
        [descriptionString appendFormat:@"; %@ = %@", key, value];
    }
    
    [descriptionString appendFormat:@">"];
    
    return descriptionString;
}

@end
