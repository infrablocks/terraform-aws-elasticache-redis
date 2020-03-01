require 'spec_helper'

describe 'subnet group' do
  include_context :terraform

  let(:component) {vars.component}
  let(:deployment_identifier) {vars.deployment_identifier}

  let(:subnet_ids) do
    output_for(:prerequisites, 'private_subnet_ids', parse: true)
  end
  let(:subnet_group_name) do
    output_for(:harness, 'subnet_group_name')
  end

  let(:subnet_group) do
    elasticache_client
        .describe_cache_subnet_groups(
            cache_subnet_group_name: subnet_group_name)
        .cache_subnet_groups
        .first
  end

  it 'uses the specified subnet IDs' do
    expect(subnet_group.subnets.map(&:subnet_identifier))
        .to(contain_exactly(*subnet_ids))
  end
end
