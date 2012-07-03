use inc::Module::Install;
name 'Module-Install-GitSubmodule';
all_from 'lib/Module/Install/GitSubmodule.pm';

requires 'Carp';
requires 'Config';
requires 'File::Spec';
requires 'File::Temp';
requires 'Git::Class';
requires 'Guard';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
