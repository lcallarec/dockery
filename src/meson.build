
sources = run_command('list-src.sh').stdout().strip().split('\n')

dockery_lib = static_library('libdockery', [sources], dependencies: deps, vala_args: vala_args)

dockery_dep = declare_dependency(include_directories: include_directories('.'), link_with: dockery_lib)

executable('dockery', ['main.vala', gresources], dependencies: deps + [dockery_dep], vala_args: vala_args, install: true)
