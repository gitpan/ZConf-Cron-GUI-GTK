package ZConf::Cron::GUI::GTK;

use warnings;
use strict;
use ZConf::Cron;
use ZConf::GUI;

=head1 NAME

ZConf::Cron::GUI::GTK - Implements a GTK backend for ZConf::Cron::GUI

=head1 VERSION

Version 0.0.0

=cut

our $VERSION = '0.0.0';

=head1 SYNOPSIS

    use ZConf::Cron::GUI::GTK;


    my $zcc=$ZConf::Cron->new;
    my $zccg=ZConf::Cron::GUI::GTK->new({zccron=>$zcc});


=head1 METHODS

=head2 new

This initializes it.

One arguement is taken and that is a hash value.

=head3 hash values

=head4 zccron

This is a ZConf::Cron object to use. If it is not specified,
a new one will be created.

=head4 zcgui

This is the ZConf::GUI object. If it is not passed, a new one will be created.

=cut

sub new{
	my %args;
	if(defined($_[1])){
		%args= %{$_[1]};
	}

	my $self={error=>undef, errorString=>undef};
	bless $self;

	#initiates
	if (!defined($args{zccron})) {
		$self->{zcc}=ZConf::Cron->new();
	}else {
		$self->{zcc}=$args{zccron};
	}

	#handles it if initializing ZConf::Runner failed
	if ($self->{zcc}->{error}) {
		my $errorstring=$self->{zcc}->{errorString};
		$errorstring=~s/\"/\\\"/g;
		my $error='Initializing ZConf::Cron failed. error="'.$self->{zcc}->{error}
		          .'" errorString="'.$self->{zcc}->{errorString}.'"';
	    $self->{error}=3;
		$self->{errorString}=$error;
		warn('ZConf-Cron-GUI-GTK new:1: '.$error);
		return $self;		
	}

	$self->{zconf}=$self->{zcc}->{zconf};

	return $self;
}

=head2 crontab

Allows the crontabs to be edited.

   $zccg->crontab;
   if($zccg->{error}){
       print "Error!\n";
   }

=cut

sub crontab{
	my $self=$_[0];

	$self->errorblank;
	if ($self->{error}) {
		warn('ZConf-Cron-GUI crontab: A permanent error was set');
		return undef;
	}

	system('gtk-gzccrontab');
	my $exitcode=$? >> 8;
	if ($? == -1) {
		$self->{error}=2;
		$self->{errorString}='"gtk-gzccrontab" did not run or is not in the current path';
		warn('ZConf-Cron-GUI-GTK crontab:2: '.$self->{errorString});
		return undef;
	}

	if ($exitcode ne '0') {
		$self->{error}=3;
		$self->{errorString}='"gtk-gzccrontab" exited with "'.$exitcode.'"';
		warn('ZConf-Cron-GUI-GTK crontab:3: '.$self->{errorString});
		return undef;		
	}


	return 1;
}

=head2 dialogs

This returns the available dailogs.

=cut

sub dialogs{
	return ('crontab');
}

=head2 windows

This returns a list of available windows.

=cut

sub windows{
	return ();
}

=head2 errorblank

This blanks the error storage and is only meant for internal usage.

It does the following.

    $self->{error}=undef;
    $self->{errorString}="";

=cut

#blanks the error flags
sub errorblank{
	my $self=$_[0];

	if ($self->{perror}) {
		warn('ZConf-Cron-GUI errorblank: A permanent error is set.');
		return undef;
	}

	$self->{error}=undef;
	$self->{errorString}="";

	return 1;
}

=head1 DIALOGS

ask

=head1 WINDOWS

At this time, no windows are supported.

=head1 ERROR CODES

=head2 1

Initializing ZConf::Cron failed.

=head2 2

Could not run "gtk-gzccrontab" as it was not found in the path.

=head2 3

'gtk-gzccrontab' exited with a non-zero.

=head1 AUTHOR

Zane C. Bowers, C<< <vvelox at vvelox.net> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-zconf-runner at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=ZConf-Runner>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc ZConf::Cron::GUI


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=ZConf-Cron-GUI-GTK>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/ZConf-Cron-GUI-GTK>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/ZConf-Cron-GUI-GTK>

=item * Search CPAN

L<http://search.cpan.org/dist/ZConf-Cron-GUI-GTK>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Zane C. Bowers, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of ZConf::Cron::GUI::GTK
