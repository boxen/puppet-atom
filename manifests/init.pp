# Install Atom into /Applications
#
# Usage:
#
#   include atom
#
# Parameters:
#
#   packages
#     An array of packages to install
#   themes
#     An array of themes to install
class atom (
  $ensure   = 'present',
  $packages = [],
  $themes   = [],
) {

  require brewcask

  if !defined(Package['atom']) {
    package { 'atom':
      ensure          => $ensure,
      provider        => 'brewcask',
      install_options => [
        '--appdir=/Applications',
        "--binarydir=${boxen::config::bindir}"
      ]
    }
  }

  $_ensure = $ensure ? { present => latest, default => $ensure }
  ensure_resource('package', concat($packages, $themes), {
    ensure   => $_ensure,
    provider => 'apm',
    require  => Package['atom'],
  })

}
