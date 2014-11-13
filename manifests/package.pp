# Install an Atom package.
#
# Examples
#
#   atom::package { 'linter': }
define atom::package (
  $ensure = 'latest'
) {
  include atom

  package { $name:
    ensure   => $ensure,
    provider => 'apm',
    require  => File["${boxen::config::bindir}/apm"]
  }
}
