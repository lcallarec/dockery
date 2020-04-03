
test_sources = files(run_command('list-src.sh').stdout().strip().split('\n'))

test(
    'vala-docker-test', 
    executable('vala-docker-test',test_sources, dependencies: deps + [vala_docker_dep])
)
