#import "NSImageAdditions.h"

@implementation NSImage (NSImageAdditions)
// Created for Adium by Evan Schoenberg on Tue Dec 02 2003 under the GPL.
// Returns an image from the owners bundle with the specified name
+ (NSImage *) imageNamed:(NSString *) name forClass:(Class) class {
	NSBundle *ownerBundle = [NSBundle bundleForClass:class];
	NSString *imagePath = [ownerBundle pathForImageResource:name];
	return [[NSImage alloc] initWithContentsOfFile:imagePath];
}

// Created for Adium by Evan Schoenberg on Tue Dec 02 2003 under the GPL.
// Draw this image in a rect, tiling if the rect is larger than the image
- (void) tileInRect:(NSRect) rect {
	NSSize size = [self size];
	NSRect destRect = NSMakeRect( rect.origin.x, rect.origin.y, size.width, size.height );
	double top = rect.origin.y + rect.size.height;
	double right = rect.origin.x + rect.size.width;

	// Tile vertically
	while( destRect.origin.y < top ) {
		// Tile horizontally
		while( destRect.origin.x < right ) {
			NSRect sourceRect = NSMakeRect( 0, 0, size.width, size.height );

			// Crop as necessary
			if( ( destRect.origin.x + destRect.size.width ) > right )
				sourceRect.size.width -= ( destRect.origin.x + destRect.size.width ) - right;

			if( ( destRect.origin.y + destRect.size.height ) > top )
				sourceRect.size.height -= ( destRect.origin.y + destRect.size.height ) - top;

			// Draw and shift
			[self compositeToPoint:destRect.origin fromRect:sourceRect operation:NSCompositeSourceOver];
			destRect.origin.x += destRect.size.width;
		}

		destRect.origin.y += destRect.size.height;
	}
}

+ (NSImage *) imageWithBase64EncodedString:(NSString *) base64String {
	return [[NSImage alloc] initWithBase64EncodedString:base64String];
}

- (id) initWithBase64EncodedString:(NSString *) base64String {
	if( [base64String length] ) {
		NSSize tempSize = { 100, 100 };
		NSData *data = nil;
		NSImageRep *imageRep = nil;

		self = [self initWithSize:tempSize];

		if( self ) {
			// Now, interpret the inBase64String.
			data = [NSData dataWithBase64EncodedString:base64String];

			// Create an image representation from the data.
			if( data ) imageRep = [NSBitmapImageRep imageRepWithData:data];

			if( imageRep ) {
				// Set the real size of the image and add the representation.
				[self setSize:[imageRep size]];
				[self addRepresentation:imageRep];
			}
		}

		return self;
	}

	return nil;
}

- (NSString *) base64EncodingWithFileType:(NSBitmapImageFileType) fileType {
	NSString *result = nil;
	NSBitmapImageRep *imageRep = nil;
	NSData *imageData = nil;

	// Look for an existing representation in the NSBitmapImageRep class.
	for( id object in [self representations] ) {
		if( object && [object isKindOfClass:[NSBitmapImageRep class]] )
			imageRep = object;
	}

	if( ! imageRep ) {
		imageRep = [NSBitmapImageRep imageRepWithData:[self TIFFRepresentation]];
		if( imageRep ) [self addRepresentation:imageRep];
	}

	if( imageRep ) {
		NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
		[dict setObject:[NSNumber numberWithBool:NO] forKey:NSImageInterlaced];
		imageData = [imageRep representationUsingType:fileType properties:dict];
	}

	if( imageData ) result = [imageData base64EncodingWithLineLength:78];

	return result;
}
@end
