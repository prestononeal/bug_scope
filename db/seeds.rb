# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Weighted list of issue templates
ISSUE_TEMPLATES = [
  [:fatalassert, 'thiscrashed.cpp:80'], [:fatalassert, 'thisalsocrashed.c:76'], 
  [:fatalassert, 'testapp.c:10'], [:fatalassert, 'helloworld.cpp:1000'],
  [:fatalassert, 'crashycrash.c:108'], [:fatalassert, 'weather.c:587'], 
  [:fatalassert, 'spacebook.cpp:809'], [:fatalassert, 'nevercrashes.c:39'],
  [:fatalassert, 'scopecore.c:512'], [:fatalassert, 'phonedriver.c:20'],
  [:hardfault, 'PC0XDEADBEEF'], [:hardfault, 'PC0XDEAABEEF'], 
  [:hardfault, 'PC0XDEADEEEF'], [:hardfault, 'PC0XDEADDEAD'], 
  [:hardfault, 'PC0XDEADBEE2'], [:hardfault, 'PC0XEA4U11FF'], 
  [:watchdog, 'XYZ_WATCHDOG'], [:watchdog, 'DSP_WATCHDOG']
]

# Create some initial builds
1.upto 30 do |i|
  Build.create({
    name: i.to_s,
    branch: "dev",
    product: "coolproduct"
  })
end
1.upto 20 do |i|
  Build.create({
    name: i.to_s,
    branch: "tst",
    product: "coolproduct"
  })
end
1.upto 10 do |i|
  Build.create({
    name: i.to_s,
    branch: "prod",
    product: "coolproduct"
  })
end
1.upto 15 do |i|
  Build.create({
    name: i.to_s,
    branch: "dev",
    product: "nextcoolproduct"
  })
end
1.upto 5 do |i|
  Build.create({
    name: i.to_s,
    branch: "tst",
    product: "nextcoolproduct"
  })
end
1.upto 2 do |i|
  Build.create({
    name: i.to_s,
    branch: "prod",
    product: "nextcoolproduct"
  })
end

# Create a bunch of random issues and instances
# from a given build
builds = Build.all
500.times {
  it = ISSUE_TEMPLATES.sample
  # Use first_or_create instead of create so we don't
  # create duplicate issues for a build. Their issuetypes and signature
  # combos should be unique.
  # This is similar to the "report" method in the issues controller.
  created = false
  build = builds.sample(1)[0]
  issue = build.issues.where(:issue_type => it[0], :signature => it[1]).first_or_create do |obj|
    # If the issue gets created, the instance linking the issue and build will also get created
    created = true
  end

  # Create an instance that points to this build and issue if it wasn't already created
  issue.instances.create(:build => build) if !created
}

# Create some tickets we can assign to some of the issues
issues = Issue.all
1.upto 50 do |i|
  iss = issues.sample(1)[0]
  iss.ticket = 'jira-' + i.to_s
  iss.save
end
