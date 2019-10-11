#!/usr/bin/perl
	print "Content-type: text/html\n\n";
	print <<"HTML";
<html>
<head>
<title>TEST_TITLE</title>
<meta http-equiv="Content-Type" content="text/html; charset=Shift_JIS">
</head>
<div align="center">
TEST OK
</div>
HTML
system(hostname);
