# frozen_string_literal: true

require 'spec_helper'

describe 'replication group' do
  let(:component) do
    var(role: :root, name: 'component')
  end
  let(:deployment_identifier) do
    var(role: :root, name: 'deployment_identifier')
  end
  let(:node_count) do
    var(role: :root, name: 'node_count').to_i
  end
  let(:node_type) do
    var(role: :root, name: 'node_type')
  end

  describe 'by default' do
    before(:context) do
      @plan = plan(role: :root)
    end

    it 'creates a replication group' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticache_replication_group')
              .once)
    end

    it 'includes the component in the replication group description' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticache_replication_group')
              .with_attribute_value(
                :replication_group_description, including(component)
              ))
    end

    it 'includes the deployment identifier in the replication ' \
       'group description' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticache_replication_group')
              .with_attribute_value(
                :replication_group_description, including(deployment_identifier)
              ))
    end

    it 'uses an engine version of 5.0.6' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticache_replication_group')
              .with_attribute_value(:engine_version, '5.0.6'))
    end

    it 'uses the provided node count' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticache_replication_group')
              .with_attribute_value(:number_cache_clusters, node_count))
    end

    it 'uses the provided node type' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticache_replication_group')
              .with_attribute_value(:node_type, node_type))
    end

    it 'uses a port of 6379' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticache_replication_group')
              .with_attribute_value(:port, 6379))
    end

    it 'does not set an auth token' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticache_replication_group')
              .with_attribute_value(:auth_token, a_nil_value))
    end

    it 'enables automatic failover' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticache_replication_group')
              .with_attribute_value(:automatic_failover_enabled, true))
    end

    it 'enables at rest encryption' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticache_replication_group')
              .with_attribute_value(:at_rest_encryption_enabled, true))
    end

    it 'enables in transit encryption' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticache_replication_group')
              .with_attribute_value(:transit_encryption_enabled, true))
    end

    it 'does not apply changes immediately' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticache_replication_group')
              .with_attribute_value(:apply_immediately, false))
    end

    it 'includes component and deployment identifier tags' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticache_replication_group')
              .with_attribute_value(
                :tags,
                a_hash_including(
                  Component: component,
                  DeploymentIdentifier: deployment_identifier
                )
              ))
    end

    it 'includes a name tag' do
      name = "elasticache-redis-#{component}-#{deployment_identifier}"
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticache_replication_group')
              .with_attribute_value(
                :tags,
                a_hash_including(Name: name)
              ))
    end

    it 'outputs the replication group ID' do
      expect(@plan)
        .to(include_output_creation(name: 'replication_group_id'))
    end

    it 'outputs the primary endpoint address' do
      expect(@plan)
        .to(include_output_creation(name: 'primary_endpoint_address'))
    end

    it 'outputs the primary endpoint port as the default redis port' do
      expect(@plan)
        .to(include_output_creation(name: 'primary_endpoint_port')
              .with_value(6379))
    end

    it 'outputs the member clusters' do
      expect(@plan)
        .to(include_output_creation(name: 'member_clusters'))
    end
  end

  describe 'when redis port provided' do
    before(:context) do
      @redis_port = 6380
      @plan = plan(role: :root) do |vars|
        vars.redis_port = @redis_port
      end
    end

    it 'uses the provided port' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticache_replication_group')
              .with_attribute_value(:port, @redis_port))
    end

    it 'outputs the primary endpoint port as the provided redis port' do
      expect(@plan)
        .to(include_output_creation(name: 'primary_endpoint_port')
              .with_value(@redis_port))
    end
  end

  describe 'when engine version provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.engine_version = '6.2'
      end
    end

    it 'uses the provided engine version' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticache_replication_group')
              .with_attribute_value(:engine_version, '6.2'))
    end
  end

  describe 'when auth token provided' do
    before(:context) do
      @auth_token =
        'APVjubqGt74ruXVwfLQJTFjVH6J7T3eGkgJJcQRTFPz3urf6EGkYo7a2xAGUndp4'
      @plan = plan(role: :root) do |vars|
        vars.auth_token = @auth_token
      end
    end

    it 'uses the provided auth token' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticache_replication_group')
              .with_attribute_value(:auth_token, eq(@auth_token)))
    end
  end

  describe 'when enable_automatic_failover is "yes"' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.enable_automatic_failover = 'yes'
      end
    end

    it 'enables automatic failover' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticache_replication_group')
              .with_attribute_value(:automatic_failover_enabled, true))
    end
  end

  describe 'when enable_automatic_failover is "no"' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.enable_automatic_failover = 'no'
      end
    end

    it 'does not enable automatic failover' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticache_replication_group')
              .with_attribute_value(:automatic_failover_enabled, false))
    end
  end

  describe 'when enable_encryption_at_rest is "yes"' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.enable_encryption_at_rest = 'yes'
      end
    end

    it 'enables encryption at rest' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticache_replication_group')
              .with_attribute_value(:transit_encryption_enabled, true))
    end
  end

  describe 'when enable_encryption_at_rest is "no"' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.enable_encryption_at_rest = 'no'
      end
    end

    it 'does not enable encryption at rest' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticache_replication_group')
              .with_attribute_value(:at_rest_encryption_enabled, false))
    end
  end

  describe 'when enable_encryption_in_transit is "yes"' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.enable_encryption_in_transit = 'yes'
      end
    end

    it 'enables encryption in transit' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticache_replication_group')
              .with_attribute_value(:transit_encryption_enabled, true))
    end
  end

  describe 'when enable_encryption_in_transit is "no"' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.enable_encryption_in_transit = 'no'
      end
    end

    it 'does not enable encryption in transit' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticache_replication_group')
              .with_attribute_value(:transit_encryption_enabled, false))
    end
  end

  describe 'when apply_immediately is "yes"' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.apply_immediately = 'yes'
      end
    end

    it 'enables immediate application of changes' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticache_replication_group')
              .with_attribute_value(:apply_immediately, true))
    end
  end

  describe 'when apply_immediately is "no"' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.apply_immediately = 'no'
      end
    end

    it 'does not enable immediate application of changes' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticache_replication_group')
              .with_attribute_value(:apply_immediately, false))
    end
  end
end
