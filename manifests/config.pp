# Internal: Prepare your system for atom packages.
#
# Examples
#
#   include atom::config
class atom::config {
  $dir        = "/Users/${::luser}/.atom"
  $packagedir = "${dir}/packages"

  file { [$dir, $packagedir]:
    ensure => directory
  }
}
