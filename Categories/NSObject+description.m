//
//  NSObject+description.m
//
//  Created by Niklas Berglund on 6/5/15.
//

#import "NSObject+description.h"
#import <objc/runtime.h>

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

- (NSString *)descriptionWithAllProperties
{
    NSMutableDictionary *propertiesDictionary = [NSMutableDictionary new];
    
    for (NSString *propertyName in [self allProperties]) {
        [propertiesDictionary setValue:[self valueForKey:propertyName] forKey:propertyName];
    }
    
    return [self descriptionWithMembers:propertiesDictionary];
}

- (NSArray *)allProperties
{
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableArray *propertyNames = [NSMutableArray array];
    
    unsigned i;
    for (i=0; i<count; i++)
    {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        [propertyNames addObject:name];
    }
    
    free(properties);
    
    // ignore these
    [propertyNames removeObjectsInArray:@[@"hash", @"superclass", @"description", @"debugDescription"]];
    
    return propertyNames;
}

@end
