Given(/^there are various public and private groups$/) do
  @public_group1 = FactoryGirl.create(:group, name: "hello world", viewable_by: 'everyone')
  5.times do
    @public_group1.add_member!(FactoryGirl.create(:user))
  end
  @public_group2 = FactoryGirl.create(:group, name: "beebly", viewable_by: 'everyone')
  @public_group3 = FactoryGirl.create(:group, name: "doodad", viewable_by: 'everyone')
  6.times do
    @public_group3.add_member!(FactoryGirl.create(:user))
  end
  @public_group4 = FactoryGirl.create(:group, name: "a group", viewable_by: 'everyone')
  7.times do
    @public_group4.add_member!(FactoryGirl.create(:user))
  end
  @private_group = FactoryGirl.create(:group, name: "something else", viewable_by: 'members')
end

When(/^I visit the public groups directory page$/) do
  visit '/groups'
end

Then(/^I should only see public groups with (\d+) or more members$/) do |arg1|
  find('#directory').should have_content(@public_group1.name)
  find('#directory').should_not have_content(@public_group2.name)
  find('#directory').should_not have_content(@private_group.name)
end

Then(/^the groups should be ordered by name$/) do
  @public_group4.name.should < @public_group3.name
  @public_group3.name.should < @public_group1.name
end

When(/^I search$/) do
  fill_in 'query', with: @public_group1.name
  click_on 'Search'
end

Then(/^I should only see groups that match the search$/) do
  find('#directory').should have_content @public_group1.name
  find('#directory').should_not have_content @public_group3.name
end

When(/^I choose to sort the public groups list by "(.*?)"$/) do |arg1|
  click_link "Number of members"
end

Then(/^I should see the groups ordered according to the number of members in the group$/) do
  @public_group4.name < @public_group3.name
  @public_group3.name < @public_group1.name
end
