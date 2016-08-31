has_library_changes = !git.modified_files.grep(/CarambaKit/).empty?

# Changelog
if !git.modified_files.include?("CHANGELOG.md") && has_library_changes
  fail("Please include a CHANGELOG entry. \n")
end

# The coding love
the_coding_love.random

# Junit
junit.parse "fastlane/test_output/report.junit"
junit.report