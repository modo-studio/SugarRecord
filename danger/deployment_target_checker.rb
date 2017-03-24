require 'xcodeproj'
require 'cocoapods-core'
require_relative 'danger_result'

module Danger
  module Plugins

    # Plugin that checks if the deployment target in a given scheme matches with the one specified in a podspec.
    class DeploymentTargetChecker

      def initialize(project_path, target_name, platform, podspec_path, subspec = nil)
        @project_path = project_path
        @target_name = target_name
        @platform = platform
        @podspec_path = podspec_path
        @subspec = subspec
      end

      def execute
        project = Xcodeproj::Project.open(@project_path)
        target = project.targets.select {|t| t.name == @target_name }.first
        return Danger::Result.failure("Couldn't find the target #{@target_name} in the project") unless target
        deployment_target = target.deployment_target
        return Danger::Result.failure("Couldn't get the deployment target. Make sure the target has the SDKROOT manually specified") unless deployment_target
        podspec = Pod::Specification.from_file(@podspec_path)
        if @subspec
          podspec = podspec.recursive_subspecs.select { |s| s.name == @subspec }.first
        end
        return Danger::Result.failure("Couldn't find spec #{@podspec_path}") unless podspec
        podspec_deployment_target = podspec.deployment_target(@platform)
        Danger::Result.failure("The #{@target_name} #{@platform} deployment target, #{deployment_target} doesn't match with the one in the podspec, #{podspec_deployment_target}") unless deployment_target == podspec_deployment_target
      end

    end

  end
end