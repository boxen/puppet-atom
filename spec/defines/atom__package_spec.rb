require 'spec_helper'

describe 'atom::package' do
  let(:facts) { default_test_facts }
  let(:title)  { 'example' }

  it do
    should include_class('atom')

    should contain_package('example').with({
      :ensure   => 'latest',
      :provider => 'apm'
    })
  end
end
