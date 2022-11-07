# frozen_string_literal: true

require 'spec_helper'

describe 'security group' do
  let(:component) do
    var(role: :root, name: 'component')
  end
  let(:deployment_identifier) do
    var(role: :root, name: 'deployment_identifier')
  end
  let(:vpc_id) do
    output(role: :prerequisites, name: 'vpc_id')
  end
  let(:allowed_cidrs) do
    var(role: :root, name: 'allowed_cidrs')
  end

  describe 'by default' do
    before(:context) do
      @plan = plan(role: :root)
    end

    it 'creates a security group' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .once)
    end

    it 'includes the component in the security group name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .with_attribute_value(:name, including(component)))
    end

    it 'includes the deployment identifier in the security group name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .with_attribute_value(:name, including(deployment_identifier)))
    end

    it 'includes the component in the security group description' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .with_attribute_value(:description, including(component)))
    end

    it 'uses the provided VPC ID' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .with_attribute_value(:vpc_id, vpc_id))
    end

    it 'includes component and deployment identifier tags' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .with_attribute_value(
                :tags,
                a_hash_including(
                  Component: component,
                  DeploymentIdentifier: deployment_identifier
                )
              ))
    end

    it 'includes a name tag' do
      name = "sg-elasticache-redis-#{component}-#{deployment_identifier}"
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .with_attribute_value(
                :tags,
                a_hash_including(Name: name)
              ))
    end

    it 'includes an ingress rule for the default redis port and ' \
       'provided allowed CIDRs' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .with_attribute_value(
                [:ingress, 0],
                a_hash_including(
                  from_port: 6379,
                  to_port: 6379,
                  protocol: 'tcp',
                  cidr_blocks: allowed_cidrs
                )
              ))
    end

    it 'outputs the security group ARN' do
      expect(@plan)
        .to(include_output_creation(name: 'security_group_arn'))
    end

    it 'outputs the security group ID' do
      expect(@plan)
        .to(include_output_creation(name: 'security_group_id'))
    end
  end
end
