project('vala-dockery', ['vala', 'c'])

cc = meson.get_compiler('c')
libm = cc.find_library('m', required: true)

gee = dependency('gee-0.8')
json = dependency('json-glib-1.0')
soup = dependency('libsoup-2.4')
gio =   dependency('gio-unix-2.0')

vala_args = []
vala_args += ['--target-glib=2.50']

deps = [
  gee,
  json,
  soup,
  gio,
  libm,
]

subdir('src')
subdir('tests')
