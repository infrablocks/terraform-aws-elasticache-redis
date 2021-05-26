require 'spec_helper'

describe 'security group' do
  include_context :terraform

  let(:component) {vars.component}
  let(:deployment_identifier) {vars.deployment_identifier}

  let(:security_group_id) do
    output_for(:harness, 'security_group_id')
  end

  let(:member_clusters) do
    output_for(:harness, 'member_clusters')
  end

  let(:cache_clusters) do
    member_clusters.collect { |member_cluster_id|
      elasticache_client
          .describe_cache_clusters(
              cache_cluster_id: member_cluster_id)
          .cache_clusters
          .first
    }
  end

  it 'sets the security group on each cache cluster' do
    expect(cache_clusters.size).to be > 0
    cache_clusters.each do |cache_cluster|
      expect(cache_cluster.security_groups[0].security_group_id)
          .to(eq(security_group_id))
    end
  end
end
