#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe 'command_args', :type => :puppet_function do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params(2).and_raise_error(TypeError, /The only argument must be a hash/) }
  it { is_expected.to run.with_params({}).and_return('')}

  it { is_expected.to run.with_params(
    {
      'key'     => 'value',
      'bool'    => true,
      'nothere' => false,
      'array'   => [
        'one',
        'two',
      ],
    }).and_return("--key=value --bool --array=one --array=two")}

  it { is_expected.to run.with_params(
    {
      'key'     => 'value',
      'bool'    => true,
      'nothere' => false,
      'array'   => [
        'one',
        'two',
      ],
    }, '-').and_return("-key=value -bool -array=one -array=two")}

end
