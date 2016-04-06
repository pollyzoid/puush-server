# puush API

All listed arguments for API are POST.

## /api/auth:
User authorisation. If client doesn't have API key saved, it sends password instead of the key,
then saves the API key.

#### Arguments:

	e: username
	k: key OR p: password
	z: "poop"

#### Returns: 

	Comma-separated list.
	type,key,expiry,usage

	Type is user's account type.
		<0 = Incorrect username/pass
		1 = Pro Account
		2 = Pro Tester
		9 = Haxor!
		any other (0) = default

		Account type changes the disk space quota. 200 MB for default, unlimited for others.
	Key is the user's API key. It's a 32-char long hex string and is used for authorisation.
		Key can be -1 for failed login.
	Expiry is datetime string in format YYYY-MM-DD HH:MM:SS (haven't checked, assuming)
		Probably used by the server to check when Pro status ends.
	Usage is used diskspace in bytes.

## /api/up:
File uploading.

#### Arguments:

	k: key
	f: uploaded file
	c: MD5 checksum
	z: "poop"

#### Returns:

	Comma-separated list.
	status,url,index,usage

	Status number:
		-4 = Insufficient storage
		-3 = Checksum error
		-2 = Connection error
		-1 = Auth failure

	URL is... the file's URL.
	Index is the new file's index.
	Usage is the user's new disk usage (total, not just the file size)

## /api/del:
Remove a file.

#### Arguments:

	k: key
	i: file index
	z: "poop"

## /api/hist:
List of previously uploaded files, limited to five client-side.

#### Arguments:

	k: key

#### Returns:

	First line contains a status number, then
	newline (\n) separated list of comma-separated lists.

	status
	index,datetime,url,filename,views
	index,datetime,url,filename,views
	index,datetime,url,filename,views

	Status number:
		-1 and -2: Some kind of error, doesn't parse the rest.
	Index is the file's index number, used to identify the file in other API methods.
	Datetime is the date and time of uploading as YYYY-MM-DD HH:MM:SS
	URL is file's URL on the site.
	Filename is the original filename
	Views is the number of times the file has been viewed/downloaded

## /api/thumb:
Thumbnail of an image file.

#### Arguments:

	k: key
	i: file index

#### Returns:

		Byte array containing a thumbnail of the image.
			(no client-side size limit?)

## /api/oshi:

Used for reporting client exceptions.

#### Arguments:

	e: username
	v: version
	l: exception name

## Updates in Windows

	version check: http://puush.me/dl/puush-win.txt?check=true
		contains current build number (85 at the time of writing)
	download: http://puush.me/dl/puush-win.zip

## Website (WIP)
Arguments are GET (at least the one argument I've checked)

#### /login/go:
Logs the user in and goes to their account page.

		k: key

#### /register
#### /reset_password