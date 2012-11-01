#!/usr/bin/perl -w

=head1 NAME

Slaughter::Info::openbsd - Perl Automation Tool Helper openbsd info implementation

=cut

=head1 SYNOPSIS

This module is the openbsd versions of the Slaughter information-gathering
module.

Modules beneath the C<Slaughter::Info> namespace are loaded when slaughter
is executed, they are used to populate a hash with information about
the current host.

This module is loaded only on openbsd systems, and will determine such details
as the local hostname, the free RAM, any IP addresses, etc.

Usage is:

=for example begin

    use Slaughter::Info::openbsd;

    my $obj  = Slaughter::Info::openbsd->new();
    my $data = $obj->getInformation();

    # use info now ..
    print "We have software RAID\n" if ( $data->{'softwareraid'} );

=for example end

When this module is used an attempt is also made to load the module
C<Slaughter::Info::Local::openbsd> - if that succeeds it will be used to
augment the information discovered and made available to slaughter
policies.

=cut


=head1 AUTHOR

 Steve
 --
 http://www.steve.org.uk/

=cut

=head1 LICENSE

Copyright (c) 2010-2012 by Steve Kemp.  All rights reserved.

This module is free software;
you can redistribute it and/or modify it under
the same terms as Perl itself.
The LICENSE file contains the full text of the license.

=cut


use strict;
use warnings;


package Slaughter::Info::openbsd;




=head2 new

Create a new instance of this object.

=cut

sub new
{
    my ( $proto, %supplied ) = (@_);
    my $class = ref($proto) || $proto;

    my $self = {};
    bless( $self, $class );
    return $self;

}


=head2 getInformation

This function retrieves meta-information about the current host.

The return value is a hash-reference of data determined dynamically.

=cut

sub getInformation
{
    my ($self) = (@_);

    #
    #  The data we will return.
    #
    my $ref;

    #
    #  Call "hostname" to determine the local hostname.
    #
    $ref->{ 'fqdn' } = `hostname`;
    chomp( $ref->{ 'fqdn' } );

    #
    #  Get the hostname and domain name as seperate strings.
    #
    if ( $ref->{ 'fqdn' } =~ /^([^.]+)\.(.*)$/ )
    {
        $ref->{ 'hostname' } = $1;
        $ref->{ 'domain' }   = $2;
    }
    else
    {

        #
        #  Better than nothing, right?
        #
        $ref->{ 'hostname' } = $ref->{ 'fqdn' };
        $ref->{ 'domain' }   = $ref->{ 'fqdn' };
    }


    #
    #  Kernel version.
    #
    $ref->{ 'release' } = `uname -r`;
    chomp( $ref->{ 'release' } );

    #
    #  Are we i386/amd64?
    #
    $ref->{'arch'} = `uname -p`;
    chomp( $ref->{'arch'} );

    #
    #  TODO IPv4/IPv6 addresses
    #

    return ($ref);
}



1;