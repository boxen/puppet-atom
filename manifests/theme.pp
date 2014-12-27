# Install an Atom theme.
#
# Examples
#
#   atom::theme { 'monokai': }
define atom::theme (
  $ensure = 'latest'
) {
  require atom

  ensure_resource('package', $name, {
    ensure   => $ensure,
    provider => 'apm',
    require  => Package['atom'],
  })
}
