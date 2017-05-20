require 'rails_helper'
require_relative '../support/docker/ruby'

RSpec.describe 'OmniBuilder with Ruby', type: :docker do
  describe 'It works with docker command and barebone ruby image' do
    include Support::Docker::Ruby

    it 'good entry submission`' do
      Dir.mktmpdir { |dir|
        Dir.chdir(dir) {
          input = Docker::Input.create(File.join(dir, 'ProblemA.in'), in_file)
          output = Docker::Output.create(File.join(dir, 'ProblemA.out'), out_file)
          good_entry = Docker::Entry.create(File.join(dir, 'ProblemA.rb'), good_entry_file)

          expect(File.exist? input.path).to be_truthy
          expect(File.exist? output.path).to be_truthy
          expect(File.exist? good_entry.path).to be_truthy

          builder = Docker::RubyBuilder.new(dir)

          sys_exec(builder.build(good_entry, input, output))
          expect(err).to eq('')
          expect(out).to eq('')
          expect(@exitstatus).to eq(0)
        }
      }
    end

    it 'bad entry submission`' do
      Dir.mktmpdir { |dir|
        Dir.chdir(dir) {
          input = Docker::Input.create(File.join(dir, 'ProblemA.in'), in_file)
          output = Docker::Output.create(File.join(dir, 'ProblemA.out'), out_file)
          bad_entry = Docker::Entry.create(File.join(dir, 'ProblemB.rb'), bad_entry_file)

          expect(File.exist? input.path).to be_truthy
          expect(File.exist? output.path).to be_truthy
          expect(File.exist? bad_entry.path).to be_truthy

          builder = Docker::RubyBuilder.new(dir)

          sys_exec(builder.build(bad_entry, input, output))
          expect(err).to eq('')
          expect(out).to_not eq('')
          expect(@exitstatus).to_not eq(0)
        }
      }
    end
  end
end
