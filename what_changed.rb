#!/bin/env ruby

def directory_from_path(path)
  path.split(':')[0].split('/')[0] if path.split(':')[0] =~ /\// ? true : nil
end

#generate the changelog in jenkins
system "git diff --name-only $GIT_PREVIOUS_COMMIT $GIT_COMMIT > changelog"

paths=[]
File.open('changelog').each do |line|
  paths.push directory_from_path(line) if directory_from_path(line) != nil
end

paths.uniq.each do |path|
  if File.exists?(path)
    puts "Changes found for directory #{path}"
    puts "Running make all inside #{path}"
    Dir.chdir(path) do
      system "make all"
    end
  else
    puts "Directory is not found for #{path}"
  end
end
