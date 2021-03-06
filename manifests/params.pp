# == Class: udev::params
#
# This class should be considered private.
#
class udev::params (
  $udevadm_path = '/sbin',
  $trigger = true
) {

  case $::osfamily {
    'Debian': {
      $udev_package    = 'udev'
      $udevlogpriority = 'udevadm control --log-priority'
      $udevtrigger     = 'udevadm trigger'
    }
    'RedHat': {
      if $::operatingsystem == 'Fedora' {
        if (versioncmp($::operatingsystemmajrelease,'20') >=0) {
          $udev_package    = 'systemd'
          $udevtrigger     = 'udevadm control --reload-rules'
          $udevlogpriority = 'udevadm control --log-priority'
        }
        else {
          fail("Module ${module_name} might not be supported on Fedora release ${::operatingsystemmajrelease}")
        }
      } else {
        case $::operatingsystemmajrelease {
          '5': {
            $udev_package    = 'udev'
            $udevtrigger     = 'udevtrigger'
            $udevlogpriority = 'udevcontrol log_priority'
          }
          '6': {
            $udev_package    = 'udev'
            $udevtrigger     = 'udevadm control --reload-rules'
            $udevlogpriority = 'udevadm control --log-priority'
          }
          '7': {
            $udev_package    = 'systemd'
            $udevtrigger     = 'udevadm control --reload-rules'
            $udevlogpriority = 'udevadm control --log-priority'
          }
          default: {
            fail("Module ${module_name} is not supported on RedHat release ${::operatingsystemmajrelease}")
          }
        }
      }
    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }
}
