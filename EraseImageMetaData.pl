use strict;
use autodie;
use Image::ExifTool qw(:Public);																	#https://metacpan.org/release/Image-ExifTool

my @files;
if(@ARGV != 2) {
	print("!!!!Invalid parameter amount. Read the 'Usage'.\n");
	Info();
	exit;
}

if($ARGV[0] eq '-l') {
	print("####A file list gets processed.\n");
	open FILELIST, "<", "$ARGV[1]";
	@files = <FILELIST>;
	close FILELIST;
	my $filecount = 0;
	foreach(@files) {
		chomp($_);
		$files[$filecount] = "$_";
		$filecount ++;
	}
	CImgMD(@files);
	COutput();
} elsif($ARGV[0] eq '-f') {
	print("####A single file gets processed.\n");
	push @files, "$ARGV[1]";
	CImgMD(@files);
	COutput();
} else {
	print("!!!!Invalid parameter amount. Read the 'Usage'.\n");
	Info();
	exit;
}

sub CImgMD {
	my $maxgroups = 0;																				#https://metacpan.org/pod/distribution/Image-ExifTool/lib/Image/ExifTool.pod#GetGroup
	my @tags;																						#https://metacpan.org/pod/distribution/Image-ExifTool/lib/Image/ExifTool/TagNames.pod
	my $rowcount = 0;
	foreach (@_) {
		my $exifTool = new Image::ExifTool;															#https://metacpan.org/pod/distribution/Image-ExifTool/lib/Image/ExifTool.pod#new
		$exifTool->Options(Unknown => 1);															#https://metacpan.org/pod/distribution/Image-ExifTool/lib/Image/ExifTool.pod#Options
		my $info = ImageInfo("$_");																	#https://metacpan.org/pod/distribution/Image-ExifTool/lib/Image/ExifTool.pod#ImageInfo
		while($maxgroups < 7) {																		#https://metacpan.org/pod/distribution/Image-ExifTool/lib/Image/ExifTool.pod#GetGroup
			push @tags, $exifTool->GetTagList($info, "Group$maxgroups");							#https://metacpan.org/pod/distribution/Image-ExifTool/lib/Image/ExifTool.pod#GetTagList
			foreach(@tags) {
				$exifTool->SetNewValue($tags[$rowcount]);											#https://metacpan.org/pod/distribution/Image-ExifTool/lib/Image/ExifTool.pod#SetNewValue
				$rowcount ++;
			}
			$rowcount = 0;
			$maxgroups ++;
		}
		$exifTool->WriteInfo($_);																	#https://metacpan.org/pod/distribution/Image-ExifTool/lib/Image/ExifTool.pod#WriteInfo
		$maxgroups = 0;
		@tags = ();
		$rowcount = 0;
	}
}

sub COutput {
	if($^O eq 'MSWin32') {
		system("cls");
	} else {
		system("clear");
	}
	Info();
}

sub Info {
	print("####Created by: 17ThedarkLord\n####Credits to: 17ThedarkLord & Phil Harvey (the order has no meaning)\n####I don't reply to any pull-requests about this tool because I did it actually only for my own use & I'm very busy.\n####However, I only write as much as I need to write about this tool.\n####Usage:\n####-1. You want to use this tool due x-reason.\n####0. You can handle a command prompt, install perl & the matching perl module via cpan.\n####1. Open the command prompt.\n####2. Execute the following command: perl EraseImageMetaData.pl -[l|f] [filelist.dat|singleimage.JPG]\n####It isn't checked by my tool if the images are writeable or not. It's your task to make sure, that the image/s is/are writeable.\n####If the code is chaotic in your eyes, improve it without me #no-hate & sharing is caring.\n####If the meta-data wasn't erased, consider piping the output into a log file & use the wiki-page of Exif Tool to answer your open questions: https://metacpan.org/release/Image-ExifTool\n####Any, to my github profile, sent text about my tool gets deleted as soon as I get time for it (s.a.).\n####The/All file/s were (not) processed.");	
}