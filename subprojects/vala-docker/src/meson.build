sources = run_command('list-src.sh').stdout().strip().split('\n')
vala_docker_lib = static_library('libvaladocker', [sources], dependencies: deps, vala_args: vala_args)
vala_docker_dep = declare_dependency(include_directories: include_directories('.'), link_with: vala_docker_lib)