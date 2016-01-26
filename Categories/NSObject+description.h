//
//  NSObject+description.h
//
//  Created by Niklas Berglund on 6/5/15.
//

#import <Foundation/Foundation.h>

@interface NSObject (description)

/*!
 * Returns a NSString formatted in the same way as Apple classes' description methods, with data from the members specified in the memberVariables argument.
 *
 * @param memberVariables Dictionary with member variables and their data. Example: \@{\@"title": self.title, \@"text":self.text}
 * @return Formatted string with the data of members in the memberVariables dictionary.
 */
- (NSString *)descriptionWithMembers:(NSDictionary *)memberVariables;

/*!
 * Returns a NSString formatted in the same way as Apple classes' description methods, with data from all properties of this object.
 *
 * @return Formatted string with the data of all properties of this object.
 */
- (NSString *)descriptionWithAllProperties;

@end
