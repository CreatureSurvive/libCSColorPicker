#ifdef SIMULATOR

extern NSString *UISystemRootDirectory();

#define currentUser NSHomeDirectory().pathComponents[2]

NSString* simulatorPath(NSString* path)
{
	if([path hasPrefix:@"/var/mobile/"] || [path hasPrefix:@"/User/"])
	{
		NSString* simulatorID = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject].pathComponents[7];
		NSString* strippedPath = [path stringByReplacingOccurrencesOfString:@"/var/mobile/" withString:@""];
		strippedPath = [strippedPath stringByReplacingOccurrencesOfString:@"/User/" withString:@""];
		return [NSString stringWithFormat:@"/Users/%@/Library/Developer/CoreSimulator/Devices/%@/data/%@", currentUser, simulatorID, strippedPath];
	}
	return [UISystemRootDirectory() stringByAppendingPathComponent:path];
}

#endif
