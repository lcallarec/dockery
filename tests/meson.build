
test_sources = files(run_command('list-src.sh').stdout().strip().split('\n'))

test(
    'dockery-test', 
    executable('dockery-test',test_sources, dependencies: deps + [dockery_dep]),
    env: ['LANG=en_US.utf8', 'LC_NUMERIC=en_US.utf8']
)
