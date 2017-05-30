# -*- coding: utf-8 -*-
require 'submission_runners/base'
require 'fileutils'

module SubmissionRunners
  class Elixir < Base
    def self.image
      "elixir:1.4"
    end

    def build
      FileUtils.chmod 0777, submission_dir
      MockResult.new
    end

    def run
      # TODO: Need to delay standard input for this to work
      docker_run('iex', '-S', source_file, chdir: submission_dir, in: input_buffer)
    end

    # TODO: To be replaced in refactor via Chris' update mock object
    class MockResult
      def success?; true end
      def failure?; false end
      def out; '' end
      def err; '' end
    end
  end
end
