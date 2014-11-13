# Install an Atom theme.
#
# Examples
#
#   atom::theme { 'monokai': }
define atom::theme (
  $ensure = 'latest'
) {
  include atom

  package { $name:
    ensure   => $ensure,
    provider => 'apm',
    require  => File["${boxen::config::bindir}/apm"]
  }
}
