//
//  MJSONParsers.h
//  jchat
//
//  Created by Zsolt Laky on 5/31/16.
//  Copyright © 2016 Zsolt Laky. All rights reserved.
//

#ifndef MJSONParsers_h
#define MJSONParsers_h

#import <Foundation/Foundation.h>

#define ISNODENAME                              isEqualToString:[node name]
#define IS_NAMED_NODE(node)                     isEqualToString:[node name]
#define SETSTRNODEVALUE(strname,setter)         if ([strname ISNODENAME]) [setter:[node value]]; else
#define SETINTNODEVALUE(strname,setter)         if ([strname ISNODENAME]) [setter:[[node value] integerValue]]; else
#define SETBOOLNODEVALUE(strname,setter)        if ([strname ISNODENAME]) [setter:[[node value] boolValue]]; else
#define NODENOTPROCESSED                        NSLog(NODE_NOT_PROCESSED,[node name]);
#define GET_NAMED_INTEGER_ATTRIBUTE(Attribute)  [[node attributeNamed:Attribute] intValue]

@interface MJSONParsers : NSObject
+ (id) LoginResponse:(NSDictionary *)jsonData;
@end

#endif /* MJSONParsers_h */
