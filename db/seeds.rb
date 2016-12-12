# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create some initial builds
Build.create! [
  {
    name: "1",
    branch: "dev",
    product: "coolproduct"
  },
  {
    name: "2",
    branch: "dev",
    product: "coolproduct"
  },
  {
    name: "3",
    branch: "dev",
    product: "coolproduct"
  },
  {
    name: "1",
    branch: "tst",
    product: "coolproduct"
  },
  {
    name: "2",
    branch: "tst",
    product: "coolproduct"
  },
  {
    name: "1",
    branch: "prod",
    product: "coolproduct"
  }
]

# Create an issue
Issue.create! [
  {
    issue_type: "fatalassert",
    signature: "thiscrashed.c:108",
    ticket: "jira-1"
  },
  {
    issue_type: "hardfault",
    signature: "PC0XDEADBEEF",
    ticket: "jira-2"
  }
]

# Create instances of these issues from the first build
Issue.first.instances.create! [
  {
    build: Build.first
  },
  {
    build: Build.first
  },
  {
    build: Build.first
  }
]

Issue.last.instances.create! [
  {
    build: Build.first
  }
]

