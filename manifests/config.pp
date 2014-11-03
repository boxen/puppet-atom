# Internal: Prepare your system for atom packages.
#
# Examples
#
#   include atom::config
class atom::config {
  $dir        = "/Users/${::luser}/.atom"
  $packagedir = "${dir}/packages"
  $apmloc     = "${boxen::config::bindir}/apm"

  file { [$dir, $packagedir, $apmloc]:
    ensure => directory
  }
}
