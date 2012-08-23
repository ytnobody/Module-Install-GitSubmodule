use strict;
use warnings;
use Test::More;
use Git::Class;
use File::Temp qw( tempdir );
use File::Spec;
use Cwd;

my $workdir = tempdir(CLEANUP => 1);
unless ( -e $workdir ) {
    mkdir $workdir;
}
my $mock = File::Spec->catfile( $workdir, 'YTNOBODY-Mock-Repository' ) ;
my $wt;

my $git = Git::Class::Cmd->new;
$wt = $git->git( 
    clone => ( 'git://github.com/ytnobody/YTNOBODY-Mock-Repository.git', $mock )
);

my $cwd = getcwd;
chdir $mock;
my $res = system( 'perl Makefile.PL && make && make test && make realclean' );

chdir $cwd;
is $res, 0, 'Module setup was finished in peaceful.';

done_testing;
