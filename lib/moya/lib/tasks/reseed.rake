
#Adding here all the tasks we need to do at startup so we can start with one
# command only avoiding to repeately load the Rails environment
task :reseed do
  Rake::Task["config"].invoke
  Rake::Task["reseed_already_configured"].invoke
end

task :reseed_already_configured => :environment do
  Rake::Task["db:drop"].invoke
  Rake::Task["db:create"].invoke
  Rake::Task["db:migrate"].invoke
  Rake::Task["db:seed"].invoke
end
