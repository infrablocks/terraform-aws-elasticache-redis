# frozen_string_literal: true

require 'spec_helper'

describe 'subnet group' do
  let(:component) do
    var(role: :root, name: 'component')
  end
  let(:deployment_identifier) do
    var(role: :root, name: 'deployment_identifier')
  end
  let(:subnet_ids) do
    output(role: :prerequisites, name: 'private_subnet_ids')
  end

  describe 'by default' do
    before(:context) do
      @plan = plan(role: :root)
    end

    it 'creates a subnet group' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticache_subnet_group')
              .once)
    end

    it 'includes the component in the subnet group name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticache_subnet_group')
              .with_attribute_value(:name, including(component)))
    end

    it 'includes the deployment identifier in the subnet group name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticache_subnet_group')
              .with_attribute_value(:name, including(deployment_identifier)))
    end

    it 'uses the provided subnet IDs' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticache_subnet_group')
              .with_attribute_value(:subnet_ids, contain_exactly(*subnet_ids)))
    end

    it 'outputs the subnet group name' do
      expect(@plan)
        .to(include_output_creation(name: 'subnet_group_name'))
    end
  end
end
#   let(:component) do
#     var(role: :root, name: 'component')
#   end
#   let(:deployment_identifier) do
#     var(role: :root, name: 'deployment_identifier')
#   end
#
#   let(:subnet_ids) do
#     output(role: :prerequisites, name: 'private_subnet_ids')
#   end
#   let(:subnet_group_name) do
#     output(role: :root, name: 'subnet_group_name')
#   end
#
#   let(:subnet_group) do
#     elasticache_client
#       .describe_cache_subnet_groups(
#         cache_subnet_group_name: subnet_group_name
#       )
#       .cache_subnet_groups
#       .first
#   end
#
#   it 'uses the specified subnet IDs' do
#     expect(subnet_group.subnets.map(&:subnet_identifier))
#       .to(contain_exactly(*subnet_ids))
#   end
