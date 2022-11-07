# frozen_string_literal: true

require 'spec_helper'

describe 'full' do
  let(:component) do
    var(role: :full, name: 'component')
  end
  let(:deployment_identifier) do
    var(role: :full, name: 'deployment_identifier')
  end
  let(:domain_name) do
    var(role: :full, name: 'domain_name')
  end

  before(:context) do
    apply(role: :full)
  end

  after(:context) do
    destroy(
      role: :full,
      only_if: -> { !ENV['FORCE_DESTROY'].nil? || ENV['SEED'].nil? }
    )
  end

  describe 'replication group' do
    let(:subnet_ids) do
      output(role: :full, name: 'private_subnet_ids')
    end
    let(:subnet_group_name) do
      output(role: :full, name: 'subnet_group_name')
    end
    let(:replication_group_id) do
      output(role: :full, name: 'replication_group_id')
    end
    let(:primary_endpoint_address) do
      output(role: :full, name: 'primary_endpoint_address')
    end
    let(:primary_endpoint_port) do
      output(role: :full, name: 'primary_endpoint_port')
    end
    let(:member_clusters) do
      output(role: :full, name: 'member_clusters')
    end

    let(:replication_group) do
      elasticache_client
        .describe_replication_groups(
          replication_group_id:
        )
        .replication_groups
        .first
    end

    let(:clusters) do
      replication_group.member_clusters.map(&method(:elasticache))
    end

    it 'uses the created subnet group' do
      expect(clusters)
        .to(all(belong_to_cache_subnet_group(subnet_group_name)))
    end

    it 'uses the specified node count' do
      expect(clusters.size).to(eq(2))
    end

    it 'uses the specified node type' do
      expect(replication_group.cache_node_type)
        .to(eq('cache.t2.micro'))
    end

    it 'uses the specified engine version' do
      clusters.each do |cluster|
        expect(cluster.engine_version).to(eq('5.0.6'))
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

    it 'has automatic failover enabled' do
      expect(replication_group.automatic_failover)
        .to(eq('enabled'))
    end

    it 'has at rest encryption enabled' do
      expect(replication_group.at_rest_encryption_enabled)
        .to(be(true))
    end

    it 'has in transit encryption enabled' do
      expect(replication_group.transit_encryption_enabled)
        .to(be(true))
    end

    it 'has auth token enabled' do
      expect(replication_group.auth_token_enabled)
        .to(be(true))
    end
  end

  describe 'security group' do
    let(:security_group_id) do
      output(role: :full, name: 'security_group_id')
    end

    let(:member_clusters) do
      output(role: :full, name: 'member_clusters')
    end

    let(:cache_clusters) do
      member_clusters.collect do |member_cluster_id|
        elasticache_client
          .describe_cache_clusters(
            cache_cluster_id: member_cluster_id
          )
          .cache_clusters
          .first
      end
    end

    it 'sets the security group on each cache cluster' do
      cache_clusters.each do |cache_cluster|
        expect(cache_cluster.security_groups[0].security_group_id)
          .to(eq(security_group_id))
      end
    end
  end

  describe 'subnet group' do
    let(:subnet_ids) do
      output(role: :full, name: 'private_subnet_ids')
    end
    let(:subnet_group_name) do
      output(role: :full, name: 'subnet_group_name')
    end

    let(:subnet_group) do
      elasticache_client
        .describe_cache_subnet_groups(
          cache_subnet_group_name: subnet_group_name
        )
        .cache_subnet_groups
        .first
    end

    it 'uses the specified subnet IDs' do
      expect(subnet_group.subnets.map(&:subnet_identifier))
        .to(contain_exactly(*subnet_ids))
    end
  end
end
