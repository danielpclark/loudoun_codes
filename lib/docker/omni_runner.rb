module Docker
  class OmniRunner
    def initialize(workdir)
      @workdir = Pathname.new workdir
      @command = ->entry {
            [
              'docker',
              'run',
              '-a stdin',
              '-a stdout',
              '-a stderr',
              "-v #{workdir()}:#{workdir()} -w #{workdir()}", # obligatory method call
              '-i',
              docker_image,
              language_executable,
              entry.path,
              '<',
              input.path,
              '|',
              'diff',
              '-w',
              output.path,
              '-'
            ].join(' ')
          }
    end

    def run(entry, input = nil, output = nil)
      raise 'Docker::Entry required' unless entry.is_a? Docker::Entry
      raise 'Docker::Input required' unless input && input.is_a?(Docker::Input)
      raise 'Docker::Output required' unless output && output.is_a?(Docker::Output)
      @input ||= input
      @output ||= output
      command.call(entry)
    end

    private def input
      @input
    end

    private def output
      @output
    end

    def docker_image
      raise "#{self} - #{__method__} not implemented"
    end

    def language_executable
      raise "#{self} - #{__method__} not implemented"
    end

    private def workdir # when in doubt, make it private
      @workdir
    end

    private def command
      @command
    end
  end
end
