use inc::Module::Install;
name 'Module-Install-GitSubmodule';
all_from 'lib/Module/Install/GitSubmodule.pm';

requires 'Git::Class';
requires 'File::Temp';
requires 'File::Spec';
requires 'Guard';
requires 'Config';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
