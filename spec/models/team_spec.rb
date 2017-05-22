require 'rails_helper'

RSpec.describe Team, type: :model do
  it 'it has many submissions' do
    contest = Contest.instance
    problem = contest.problems.create!
    team = contest.teams.create!
    submission = problem.submissions.create!(team: team)
    submission = problem.submissions.create!(team: team)
    expect(team.submissions.count).to be 2
  end

end

# == Schema Information
#
# Table name: teams
#
#  id         :integer          not null, primary key
#  name       :string
#  username   :string
#  password   :string
#  contest_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
