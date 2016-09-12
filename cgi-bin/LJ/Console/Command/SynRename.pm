#!/usr/bin/perl
#
# LJ::Console::Command::SynRename
#
# Console command to rename a feed account.
#
# Author:
#      Alex Brett <kaberett@dreamwidth.org>
#
# Copyright (c) 2016 by Dreamwidth Studios, LLC.
#
# This program is free software; you may redistribute it and/or modify it under
# the same terms as Perl itself. For a copy of the license, please reference
# 'perldoc perlartistic' or 'perldog perlgpl'.

package LJ::Console::Command::SynRename;
use strict;

use base qw(LJ::Console::Command);
use Carp qw(croak);
use List::Util qw(max);

sub cmd { 'syn_rename' }
sub desc { 'Rename a syndicated feed account. Requires priv: syn_edit.' }

sub args_desc {
    [
        'old_username' => 'The current username.',
        'new_username' => 'New username.',
    ]
}

sub usage { '<old_username> "to" <new_username>' }

sub can_execute {
    my $remote = LJ::get_remote();
    return $remote && $remote->has_priv( "syn_edit" );
}

sub execute {
    my ( $self, $old_username, $to, $new_username, @args ) = @_;

    return $self->error( 'This command takes three arguments. Consult the reference.' )
        unless $old_username && $new_username && scalar(@args) == 0;

    return $self->error( 'Second argument must be "to".' )
        unless $to eq 'to';

    return $self->error( 'Username must end with _feed.' )
        unless $new_username =~ /^\w{1,25}$/ && $new_username =~ /_feed$/;

    my ( $ok, $msg ) = LJ::Feed::; ## TODO this needs to be something like LJ::Feed::rename_feed( args ) 
    return $self->error( $msg ) unless $ok;
    return $self->print( $msg );
}

1;
