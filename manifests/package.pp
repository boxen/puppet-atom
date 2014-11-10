# Public: Install an atom package using apm.
#
# namevar - The name of the package.
#
# Examples
#
#   atom::package { 'gist-it': }
#
#
define atom::package() {
  require atom::config

  $packname = "Install Atom package: ${name}"
  $command = "${boxen::config::bindir}/apm install ${name}"

  exec { $packname:
    command => $command
  }
}
