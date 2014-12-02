ISO8601DateFormatterValueTransformer
====================================

A small Objective-C library that integrates Peter Hosey's [ISO8601DateFormatter](https://github.com/boredzo/iso-8601-date-formatter) 
with [RKValueTransformers](https://github.com/RestKit/RKValueTransformers).

The implementation is done by adding `RKValueTransforming` conformance to the `ISO8601DateFormatter` via a category.

## Examples

### Usage

Basic usage is identical to all other `RKValueTransforming` classes.

```objc
#import "ISO8601DateValueTransformer.h"

RKISO8601DateFormatter *dateFormatter = [RKISO8601DateFormatter defaultISO8601DateFormatter];

// Transforming NSDate -> String
NSString *dateString = nil;
NSError *error = nil;
BOOL success = [dateFormatter transformValue:[NSDate date] toValue:&dateString ofClass:[NSDate class] error:&error];

// Transforming NSString -> NSDate
NSDate *date = nil;
success = [dateFormatter transformValue:@"2013-09-12T07:24:56-04:00" toValue:&dateString ofClass:[NSDate class] error:&error];
```

### Configuration as Default Date Transformer

Adding the date formatter to the default value transformer at position 0 ensures that it is used ahead of all other `NSString` <-> `NSDate` value transformers.

```objc
#import "ISO8601DateValueTransformer.h"

RKISO8601DateFormatter *dateFormatter = [RKISO8601DateFormatter defaultISO8601DateFormatter];
[[RKValueTransformer defaultValueTransformer] insertValueTransformer:dateFormatter atIndex:0];
```

## Credits

Blake Watters

- http://github.com/blakewatters
- http://twitter.com/blakewatters
- blakewatters@gmail.com

## License

ISO8601DateFormatterValueTransformer is available under the Apache 2 License. See the LICENSE file for more info.
