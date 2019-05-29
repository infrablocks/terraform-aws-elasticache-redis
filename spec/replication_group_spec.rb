require 'spec_helper'

describe 'replication group' do
  include_context :terraform

  let(:component) {vars.component}
  let(:deployment_identifier) {vars.deployment_identifier}

  let(:node_count) {vars.node_count}
  let(:node_type) {vars.node_type}

  let(:engine_version) {vars.engine_version}

  let(:subnet_ids) do
    output_for(:prerequisites, 'private_subnet_ids')
        .split(',')
  end
  let(:subnet_group_name) do
    output_for(:harness, 'subnet_group_name')
  end
  let(:replication_group_id) do
    output_for(:harness, 'replication_group_id')
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

  context 'when automatic failover enabled' do
    before(:all) do
      reprovision({
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
      reprovision({
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
      reprovision({
          replication_group_id: ('a'..'z').to_a.shuffle[0,20].join,
          enable_encryption_at_rest: "yes",
          enable_encryption_in_transit: "yes",
          auth_token:
              TerraformModule.configuration.for(:harness).vars.auth_token
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
      reprovision({
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
