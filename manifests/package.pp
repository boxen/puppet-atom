# Install an Atom package.
#
# Examples
#
#   atom::package { 'linter': }
define atom::package (
  $ensure = 'latest'
) {
  require atom

  ensure_resource('package', $name, {
    ensure   => $ensure,
    provider => 'apm',
    require  => Package['atom'],
  })
}
