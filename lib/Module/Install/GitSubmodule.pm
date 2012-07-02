package Module::Install::GitSubmodule;

use strict;
use warnings;
use base qw( Module::Install::Base );
use vars qw( $VERSION );
use Carp;
use Config;
use File::Spec;
use Git::Class::Worktree;
use Guard;

$VERSION = 0.01;

sub install_git_submodule {
    my $self = shift;
    my $basedir = $self->admin->{base};
    my $extlib = File::Spec->catfile( $basedir, "extlib" );

    my $wt = Git::Class::Worktree->new( path => $basedir );

    $wt->git(qw/submodule update --init/);
    for my $submod_info ( $wt->git(qw/submodule/) ) {
         my $guard = guard { chdir $basedir };
         my ( $hash, $path ) = $submod_info =~ /^[\-\s]?([0-9a-fA-F]+)\s(.+)\s/;
 
         my $worktree_path = File::Spec->catfile($basedir, $path);
         chdir $worktree_path;
 
         my $subr = Git::Class::Worktree->new( path => $worktree_path );
         $subr->pull;
 
         my $cpanm = search_cpanm();
         my $res = system( "$cpanm ./ -l $extlib" );
         if ( $res ) {
             Carp::croak("Failure to install submodule $path");
         }
         else {
             print "*** submodule $path was installed ***\n";
         }
    }
    my $res = system("cp -rfv $extlib/lib/perl5/* $basedir/lib/");

    return 1 unless $res;
}

sub search_cpanm {
    my @search_path = qw( installbin );
    my $cpanm = `/usr/bin/which cpanm`;
    $cpanm =~ s/\n//;
    return $cpanm if $cpanm;
    for my $key ( @search_path ) {
        $cpanm = File::Spec->catfile( $Config{$key}, 'cpanm' );
        return $cpanm if $cpanm;
    }
}


1;

__END__

=head1 NAME

Module::Install::GitSubmodule - A Module::Install extention that resolves git submodule dependencies


=head1 VERSION

This document describes Module::Install::GitSubmodule version 0.01


=head1 SYNOPSIS

First, in your repository, add submodule.

    $ git submodule add git://some.host/you/your-repos.git

and in your Makefile.PL,

    use inc::Module::Install;
    install_git_submodules;

=head1 DESCRIPTION

About a module that is versioning with git, we often register dependent modules as submodule.

But, It's too boring to install into new-environment.

If you use Module::Install::GitSubmodule, it automates installing submodules.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
L<http://twitter.com/ytnobody>.


=head1 AUTHOR

  C<< <ytnobody at gmail dot com> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2012, satoshi azuma C<< <ytnobody at gmail dot com> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
