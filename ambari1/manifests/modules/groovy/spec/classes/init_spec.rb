require 'spec_helper'

describe 'groovy' do
  let(:binary_name) { 'groovy-binary-2.3.1.zip' }

  it { should contain_file '/etc/profile.d/groovy.sh' }
  it { should contain_staging__file binary_name }
  it { should contain_staging__extract binary_name }

  context 'invalid params' do
    shared_examples 'a bad catalog' do
      it { expect { subject }.to raise_error(Puppet::Error) }
    end

    context 'with a non-string base_url' do
      let(:params) { {:base_url => true,} }
      it_behaves_like 'a bad catalog'
    end

    context 'with a non-string version' do
      let(:params) { {:version => true,} }
      it_behaves_like 'a bad catalog'
    end
  end
end
