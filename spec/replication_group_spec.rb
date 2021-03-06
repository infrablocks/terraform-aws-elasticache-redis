require 'spec_helper'

describe 'replication group' do
  include_context :terraform

  let(:component) {vars.component}
  let(:deployment_identifier) {vars.deployment_identifier}

  let(:node_count) {vars.node_count.to_i}
  let(:node_type) {vars.node_type}

  let(:engine_version) {vars.engine_version}

  let(:subnet_ids) do
    output_for(:prerequisites, 'private_subnet_ids')
  end
  let(:subnet_group_name) do
    output_for(:harness, 'subnet_group_name')
  end
  let(:replication_group_id) do
    output_for(:harness, 'replication_group_id')
  end
  let(:primary_endpoint_address) do
    output_for(:harness, 'primary_endpoint_address')
  end
  let(:primary_endpoint_port) do
    output_for(:harness, 'primary_endpoint_port')
  end
  let(:member_clusters) do
    output_for(:harness, 'member_clusters')
  end

  let(:replication_group) do
    elasticache_client
        .describe_replication_groups(
            replication_group_id: replication_group_id)
        .replication_groups
        .first
  end

  let(:clusters) do
    replication_group.member_clusters.map(&method(:elasticache))
  end

  it 'uses the created subnet group' do
    clusters.each do |cluster|
      expect(cluster)
          .to(belong_to_cache_subnet_group(subnet_group_name))
    end
  end

  it 'uses the specified node count' do
    expect(clusters.size)
        .to(eq(node_count))
  end

  it 'uses the specified node type' do
    expect(replication_group.cache_node_type)
        .to(eq(node_type))
  end

  it 'uses the specified engine version' do
    clusters.each do |cluster|
      expect(cluster.engine_version)
          .to(eq(engine_version))
    end
  end

  it 'outputs the primary endpoint address' do
    expect(primary_endpoint_address).not_to be_nil
  end

  it 'outputs the primary_endpoint port' do
    expect(primary_endpoint_port).not_to be_nil
  end

  it 'outputs the member clusters' do
    expect(member_clusters).not_to be_nil
  end

  context 'when automatic failover enabled' do
    before(:all) do
      provision({
          enable_automatic_failover: "yes"
      })
    end

    it 'has automatic failover enabled' do
      expect(replication_group.automatic_failover)
          .to(eq("enabled"))
    end
  end

  context 'when automatic failover disabled' do
    before(:all) do
      provision({
          enable_automatic_failover: "no"
      })
    end

    it 'has automatic failover disabled' do
      expect(replication_group.automatic_failover)
          .to(eq("disabled"))
    end
  end

  context 'when encryption is enabled' do
    before(:all) do
      provision({
          replication_group_id: ('a'..'z').to_a.shuffle[0,20].join,
          enable_encryption_at_rest: "yes",
          enable_encryption_in_transit: "yes",
          auth_token:
              TerraformModule.configuration.for(:harness).vars[:auth_token]
      })
    end

    it 'has encryption enabled' do
      expect(replication_group.at_rest_encryption_enabled)
          .to(eq(true))
      expect(replication_group.transit_encryption_enabled)
          .to(eq(true))
    end

    it 'has auth token enabled' do
      expect(replication_group.auth_token_enabled)
          .to(eq(true))
    end
  end

  context 'when encryption is disabled' do
    before(:all) do
      provision({
          replication_group_id: ('a'..'z').to_a.shuffle[0,20].join,
          enable_encryption_at_rest: "no",
          enable_encryption_in_transit: "no",
          auth_token: ""
      })
    end

    it 'has encryption disabled' do
      expect(replication_group.at_rest_encryption_enabled)
          .to(eq(false))
      expect(replication_group.transit_encryption_enabled)
          .to(eq(false))
    end

    it 'has auth token disabled' do
      expect(replication_group.auth_token_enabled)
          .to(eq(false))
    end
  end
end
