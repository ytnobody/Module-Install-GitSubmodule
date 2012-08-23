use inc::Module::Install;
name 'Module-Install-GitSubmodule';
all_from 'lib/Module/Install/GitSubmodule.pm';

requires 'Carp';
requires 'Config';
requires 'File::Spec';
requires 'Git::Class';
requires 'Guard';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
test_requires 'File::Temp';

auto_set_repository;
auto_include;
WriteAll;
