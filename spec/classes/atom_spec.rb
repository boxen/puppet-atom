require 'spec_helper'

describe 'atom' do
  let(:facts) { default_test_facts }
  let(:params) { {
    :packages => ['package-1', 'package-2'],
    :themes   => ['theme-1', 'theme-2']
  } }

  it do
    should include_class('brewcask')

    should contain_package('atom').with({
      :ensure          => 'present',
      :provider        => 'brewcask',
      :install_options => ['--appdir=/Applications', '--binarydir=/test/boxen/bin'],
    })

    %w(package-1 package-2 theme-1 theme-2).each do |pkg|
      should contain_package(pkg).with({
        :ensure   => 'latest',
        :provider => 'apm'
      })
    end
  end
end
